package Service.Payment;

import Model.DTO.Payment.FinalPaymentDTO;
import Model.Entity.Booking.Booking;
import Model.Entity.Booking.BookingSurcharges;
import Model.Entity.Car.Car;
import Model.Entity.Car.CarBrand;
import Model.Entity.Car.CarConditionLogs;
import Repository.Booking.BookingRepository;
import Repository.Booking.BookingSurchargesRepository;
import Repository.Car.CarRepository;
import Repository.Car.CarBrandRepository;
import Repository.Car.CarConditionLogsRepository;
import Service.Car.CarService;
import Service.Car.CarBrandService;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Service xử lý thanh toán số tiền còn lại sau khi kiểm tra xe
 */
public class FinalPaymentService {
    
    private static final Logger LOGGER = Logger.getLogger(FinalPaymentService.class.getName());
    
    private final BookingRepository bookingRepository;
    private final BookingSurchargesRepository surchargesRepository;
    private final CarRepository carRepository;
    private final CarBrandRepository carBrandRepository;
    private final CarConditionLogsRepository conditionLogsRepository;
    private final CarService carService;
    private final CarBrandService carBrandService;
    
    public FinalPaymentService() {
        this.bookingRepository = new BookingRepository();
        this.surchargesRepository = new BookingSurchargesRepository();
        this.carRepository = new CarRepository();
        this.carBrandRepository = new CarBrandRepository();
        this.conditionLogsRepository = new CarConditionLogsRepository();
        this.carService = new CarService();
        this.carBrandService = new CarBrandService();
    }
    
    /**
     * Lấy thông tin thanh toán số tiền còn lại cho booking
     */
    public FinalPaymentDTO getFinalPaymentData(UUID bookingId) throws SQLException {
        LOGGER.info("Getting final payment data for booking: " + bookingId);
        
        // Lấy thông tin booking
        Booking booking = bookingRepository.findById(bookingId);
        if (booking == null) {
            throw new SQLException("Không tìm thấy booking với ID: " + bookingId);
        }
        
        // Lấy thông tin xe
        Car car = carRepository.findById(booking.getCarId());
        if (car == null) {
            throw new SQLException("Không tìm thấy thông tin xe");
        }
        
        // Lấy thông tin thương hiệu xe
        CarBrand carBrand = carBrandRepository.findById(car.getBrandId());
        
        // Lấy thông tin kiểm tra xe gần nhất
        List<CarConditionLogs> inspections = conditionLogsRepository.findByBookingId(bookingId);
        CarConditionLogs latestInspection = inspections != null && !inspections.isEmpty() ? inspections.get(0) : null;
        
        // Lấy danh sách phụ phí (không bao gồm VAT)
        List<BookingSurcharges> surcharges = surchargesRepository.findByBookingId(bookingId);
        
        // Loại bỏ VAT surcharge khỏi danh sách phụ phí
        if (surcharges != null) {
            surcharges.removeIf(surcharge -> "VAT".equals(surcharge.getSurchargeType()));
        }
        
        // Tính toán các khoản tiền
        double totalAmount = booking.getTotalAmount();
        double depositAmount = calculateDepositAmount(totalAmount);
        double remainingAmount = totalAmount - depositAmount;
        double totalSurcharges = calculateTotalSurcharges(surcharges);
        double finalAmount = remainingAmount + totalSurcharges;
        
        // Tạo DTO
        FinalPaymentDTO dto = new FinalPaymentDTO();
        dto.setBookingId(booking.getBookingId());
        dto.setBookingCode(booking.getBookingCode());
        dto.setCustomerName(booking.getCustomerName());
        dto.setCustomerPhone(booking.getCustomerPhone());
        dto.setCustomerEmail(booking.getCustomerEmail());
        dto.setPickupDateTime(booking.getPickupDateTime());
        dto.setReturnDateTime(booking.getReturnDateTime());
        dto.setActualReturnDateTime(latestInspection != null ? latestInspection.getCheckTime() : null);
        
        dto.setCarId(car.getCarId());
        dto.setCarModel(car.getCarModel());
        dto.setCarLicensePlate(car.getLicensePlate());
        dto.setCarBrand(carBrand != null ? carBrand.getBrandName() : "N/A");
        
        dto.setTotalAmount(totalAmount);
        dto.setDepositAmount(depositAmount);
        dto.setRemainingAmount(remainingAmount);
        dto.setTotalSurcharges(totalSurcharges);
        dto.setFinalAmount(finalAmount);
        
        dto.setSurcharges(surcharges);
        dto.setInspectionDate(latestInspection != null ? latestInspection.getCheckTime() : null);
        dto.setInspectionNote(latestInspection != null ? latestInspection.getNote() : null);
        dto.setConditionStatus(latestInspection != null ? latestInspection.getConditionStatus() : null);
        
        LOGGER.info("Final payment data calculated (excluding VAT):");
        LOGGER.info("- Total Amount: " + totalAmount);
        LOGGER.info("- Deposit Amount: " + depositAmount);
        LOGGER.info("- Remaining Amount: " + remainingAmount);
        LOGGER.info("- Total Surcharges (no VAT): " + totalSurcharges);
        LOGGER.info("- Final Amount: " + finalAmount);
        
        return dto;
    }
    
    /**
     * Tính số tiền đặt cọc theo logic đúng
     * - Nếu totalAmount < 3 triệu: đặt cọc = 300.000 VND
     * - Nếu totalAmount >= 3 triệu: đặt cọc = 10% của totalAmount
     */
    private double calculateDepositAmount(double totalAmount) {
        // Đơn vị DB: 3000 = 3 triệu VND
        if (totalAmount >= 3000.0) {
            // Nếu total >= 3 triệu: đặt cọc = 10% của total
            return totalAmount * 0.10;
        } else {
            // Nếu total < 3 triệu: đặt cọc cố định 300.000 VND
            return 300.0; // 300.000 VND trong DB
        }
    }
    
    /**
     * Tính tổng phụ phí
     */
    private double calculateTotalSurcharges(List<BookingSurcharges> surcharges) {
        if (surcharges == null || surcharges.isEmpty()) {
            return 0.0;
        }
        
        double total = 0.0;
        LOGGER.info("=== CALCULATING SURCHARGES (EXCLUDING VAT) ===");
        
        for (BookingSurcharges surcharge : surcharges) {
            double amount = surcharge.getAmount();
            total += amount;
            LOGGER.info("Surcharge: " + surcharge.getSurchargeType() + 
                       " - Amount: " + amount + " (DB unit) = " + (amount * 1000) + " VND" +
                       " - Description: " + surcharge.getDescription());
        }
        
        LOGGER.info("Total surcharges (no VAT): " + total + " (DB value) = " + (total * 1000) + " VND");
        return total;
    }
    
    /**
     * Đảm bảo VAT surcharge tồn tại cho booking
     */
    private void ensureVatSurcharge(UUID bookingId, double totalAmount) {
        try {
            // Kiểm tra xem đã có VAT surcharge chưa
            List<BookingSurcharges> existingSurcharges = surchargesRepository.findByBookingId(bookingId);
            boolean hasVatSurcharge = existingSurcharges.stream()
                    .anyMatch(s -> "VAT".equals(s.getSurchargeType()));
            
            if (!hasVatSurcharge) {
                // Tính VAT = 10% của totalAmount
                double vatAmount = totalAmount * 0.10;
                
                // Tạo VAT surcharge
                BookingSurcharges vatSurcharge = new BookingSurcharges();
                vatSurcharge.setSurchargeId(UUID.randomUUID());
                vatSurcharge.setBookingId(bookingId);
                vatSurcharge.setSurchargeType("VAT");
                vatSurcharge.setAmount(vatAmount);
                vatSurcharge.setDescription("Thuế VAT 10% áp dụng cho tổng chi phí thuê xe và bảo hiểm");
                vatSurcharge.setCreatedDate(LocalDateTime.now());
                vatSurcharge.setSurchargeCategory("Tax");
                vatSurcharge.setSystemGenerated(true);
                
                surchargesRepository.add(vatSurcharge);
                LOGGER.info("Created VAT surcharge: " + vatAmount + " (DB value) = " + (vatAmount * 1000) + " VND");
            } else {
                LOGGER.info("VAT surcharge already exists for booking: " + bookingId);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error ensuring VAT surcharge: {0}", e.getMessage());
        }
    }
    
    /**
     * Kiểm tra booking có thể thanh toán số tiền còn lại không
     */
    public boolean canProcessFinalPayment(UUID bookingId) throws SQLException {
        Booking booking = bookingRepository.findById(bookingId);
        if (booking == null) {
            return false;
        }
        
        // Chỉ cho phép thanh toán khi đã kiểm tra xe xong
        return "InspectionCompleted".equals(booking.getStatus());
    }
    
    /**
     * Cập nhật trạng thái booking sau khi thanh toán số tiền còn lại thành công
     */
    public boolean updateBookingAfterFinalPayment(UUID bookingId) throws SQLException {
        LOGGER.info("Updating booking status after final payment: " + bookingId);
        
        try {
            // Cập nhật trạng thái thành Completed
            bookingRepository.updateBookingStatus(bookingId, "Completed");
            LOGGER.info("Booking status updated to Completed successfully");
            return true;
        } catch (Exception e) {
            LOGGER.warning("Failed to update booking status to Completed: " + e.getMessage());
            return false;
        }
    }
} 