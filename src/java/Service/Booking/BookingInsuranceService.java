package Service.Booking;

import Model.Entity.Booking.Booking;
import Model.Entity.Booking.BookingInsurance;
import Model.Entity.Deposit.Insurance;
import Repository.Booking.BookingInsuranceRepository;
import Repository.Deposit.InsuranceRepository;
import Repository.Car.CarRepository;
import Model.Entity.Car.Car;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Service xử lý logic bảo hiểm cho booking
 * Tái sử dụng logic từ DepositService
 */
public class BookingInsuranceService {
    private static final Logger LOGGER = Logger.getLogger(BookingInsuranceService.class.getName());
    
    // ========== HẰNG SỐ TÍNH TOÁN BẢO HIỂM ==========
    private static final double VEHICLE_INSURANCE_RATE = 0.02; // 2% bảo hiểm vật chất/năm
    
    // Hệ số ước tính giá trị xe theo giá thuê/ngày
    private static final double COEFFICIENT_LOW = 5;     // ≤ 500k/ngày
    private static final double COEFFICIENT_MEDIUM = 7;  // ≤ 800k/ngày
    private static final double COEFFICIENT_HIGH = 10;   // ≤ 1,200k/ngày
    private static final double COEFFICIENT_LUXURY = 15; // > 1,200k/ngày
    
    private final BookingInsuranceRepository bookingInsuranceRepository;
    private final InsuranceRepository insuranceRepository;
    
    public BookingInsuranceService() {
        this.bookingInsuranceRepository = new BookingInsuranceRepository();
        this.insuranceRepository = new InsuranceRepository();
    }
    
    /**
     * Tạo các bảo hiểm cho booking mới
     * Được gọi sau khi booking được tạo thành công
     * 
     * @param booking Booking đã được tạo
     * @param carSeats Số chỗ ngồi của xe
     * @param hasAdditionalInsurance Có mua bảo hiểm tai nạn bổ sung không
     * @return Danh sách BookingInsurance đã tạo
     */
    public List<BookingInsurance> createInsurancesForBooking(Booking booking, int carSeats, boolean hasAdditionalInsurance) {
        List<BookingInsurance> result = new ArrayList<>();
        try {
            LOGGER.info("Tạo bảo hiểm cho booking: " + booking.getBookingId());
            
            // Tính số ngày thuê để tính bảo hiểm
            double rentalDays = calculateRentalDaysForInsurance(booking);
            
            // 1. Tạo bảo hiểm vật chất (BẮT BUỘC)
            BookingInsurance vehicleInsurance = createVehicleInsurance(booking, carSeats, rentalDays);
            if (vehicleInsurance != null) {
                result.add(vehicleInsurance);
                LOGGER.info("Đã tạo bảo hiểm vật chất: " + vehicleInsurance.getPremiumAmount());
            }
            
            // 2. Tạo bảo hiểm tai nạn nếu được chọn
            if (hasAdditionalInsurance) {
                BookingInsurance accidentInsurance = createAccidentInsurance(booking, carSeats, rentalDays);
                if (accidentInsurance != null) {
                    result.add(accidentInsurance);
                    LOGGER.info("Đã tạo bảo hiểm tai nạn: " + accidentInsurance.getPremiumAmount());
                }
            }
            
            LOGGER.info("Hoàn thành tạo " + result.size() + " bảo hiểm cho booking");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tạo bảo hiểm cho booking", e);
        }
        
        return result;
    }
    
    /**
     * Tạo bảo hiểm vật chất cho booking
     * 
     * @param booking Booking cần tạo bảo hiểm
     * @param carSeats Số chỗ ngồi của xe
     * @param rentalDays Số ngày thuê đã tính
     * @return BookingInsurance đã tạo hoặc null nếu có lỗi
     */
    private BookingInsurance createVehicleInsurance(Booking booking, int carSeats, double rentalDays) {
        try {
            // Lấy bảo hiểm vật chất từ database
            List<Insurance> vehicleInsurances = insuranceRepository.findByType("VatChat");
            if (vehicleInsurances.isEmpty()) {
                LOGGER.warning("Không tìm thấy bảo hiểm vật chất trong database");
                return null;
            }
            
            Insurance vehicleInsurance = vehicleInsurances.get(0);
            
            // Ước tính giá trị xe để lưu vào database
            double dailyRate = estimateDailyRate(booking);
            double yearCoefficient = getYearCoefficient(dailyRate);
            double estimatedCarValue = dailyRate * 365 * yearCoefficient;
            
            // Tính phí bảo hiểm vật chất theo công thức: 2% giá trị xe / 365 ngày * số ngày thuê
            double premiumPerDay = estimatedCarValue * VEHICLE_INSURANCE_RATE / 365;
            
            // Giảm 50% phí bảo hiểm vật chất để đồng nhất với frontend
            premiumPerDay = premiumPerDay * 0.5;
            
            // Tổng phí bảo hiểm vật chất
            double totalPremium = premiumPerDay * rentalDays;
            
            // Chuyển từ VND sang đơn vị DB (K - nghìn đồng)
            double premiumAmountInK = totalPremium / 1000;
            
            // Tạo BookingInsurance mới
            BookingInsurance bookingInsurance = new BookingInsurance();
            bookingInsurance.setBookingInsuranceId(UUID.randomUUID());
            bookingInsurance.setBookingId(booking.getBookingId());
            bookingInsurance.setInsuranceId(vehicleInsurance.getInsuranceId());
            bookingInsurance.setPremiumAmount(premiumAmountInK); // Lưu giá tiền thực tế đã tính
            bookingInsurance.setRentalDays(rentalDays);
            bookingInsurance.setCarSeats(carSeats);
            bookingInsurance.setEstimatedCarValue(estimatedCarValue);
            bookingInsurance.setCreatedAt(LocalDateTime.now());
            
            // Ghi log để debug
            LOGGER.info("Tạo bảo hiểm vật chất cho booking " + booking.getBookingId());
            LOGGER.info("- Giá trị xe: " + estimatedCarValue + " VND");
            LOGGER.info("- Phí bảo hiểm/ngày: " + premiumPerDay + " VND");
            LOGGER.info("- Số ngày thuê: " + rentalDays);
            LOGGER.info("- Tổng phí bảo hiểm: " + totalPremium + " VND (" + premiumAmountInK + "K)");
            
            // Lưu vào database
            return bookingInsuranceRepository.add(bookingInsurance);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tạo bảo hiểm vật chất", e);
            return null;
        }
    }
    
    /**
     * Tạo bảo hiểm tai nạn cho booking
     * 
     * @param booking Booking cần tạo bảo hiểm
     * @param carSeats Số chỗ ngồi của xe
     * @param rentalDays Số ngày thuê đã tính
     * @return BookingInsurance đã tạo hoặc null nếu có lỗi
     */
    private BookingInsurance createAccidentInsurance(Booking booking, int carSeats, double rentalDays) {
        try {
            // Lấy bảo hiểm tai nạn phù hợp với số chỗ ngồi
            Insurance accidentInsurance = findAccidentInsuranceBySeats(carSeats);
            if (accidentInsurance == null) {
                LOGGER.warning("Không tìm thấy bảo hiểm tai nạn phù hợp với xe " + carSeats + " chỗ");
                return null;
            }
            
            // Tính phí bảo hiểm tai nạn = baseRatePerDay * số ngày thuê
            double premiumPerDay = accidentInsurance.getBaseRatePerDay();
            double totalPremium = premiumPerDay * rentalDays;
            
            // Chuyển từ VND sang đơn vị DB (K - nghìn đồng)
            double premiumAmountInK = totalPremium / 1000;
            
            // Tạo BookingInsurance mới
            BookingInsurance bookingInsurance = new BookingInsurance();
            bookingInsurance.setBookingInsuranceId(UUID.randomUUID());
            bookingInsurance.setBookingId(booking.getBookingId());
            bookingInsurance.setInsuranceId(accidentInsurance.getInsuranceId());
            bookingInsurance.setPremiumAmount(premiumAmountInK); // Lưu đơn vị K (nghìn đồng)
            bookingInsurance.setRentalDays(rentalDays);
            bookingInsurance.setCarSeats(carSeats);
            bookingInsurance.setEstimatedCarValue(0); // Không cần cho bảo hiểm tai nạn
            bookingInsurance.setCreatedAt(LocalDateTime.now());
            
            // Ghi log để debug
            LOGGER.info("Tạo bảo hiểm tai nạn cho booking " + booking.getBookingId());
            LOGGER.info("- Phí bảo hiểm/ngày: " + premiumPerDay + " VND");
            LOGGER.info("- Số ngày thuê: " + rentalDays);
            LOGGER.info("- Tổng phí bảo hiểm: " + totalPremium + " VND (" + premiumAmountInK + "K)");
            
            // Lưu vào database
            return bookingInsuranceRepository.add(bookingInsurance);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tạo bảo hiểm tai nạn", e);
            return null;
        }
    }
    
    /**
     * Tìm bảo hiểm tai nạn phù hợp với số chỗ ngồi
     * 
     * @param carSeats Số chỗ ngồi của xe
     * @return Insurance phù hợp hoặc null nếu không tìm thấy
     */
    private Insurance findAccidentInsuranceBySeats(int carSeats) {
        try {
            // Tìm bảo hiểm tai nạn với loại "TaiNan"
            List<Insurance> accidentInsurances = insuranceRepository.findByType("TaiNan");
            LOGGER.info("Tìm thấy " + accidentInsurances.size() + " bảo hiểm tai nạn");
            
            // Lọc theo số chỗ ngồi
            for (Insurance insurance : accidentInsurances) {
                if (isApplicableSeatRange(carSeats, insurance.getApplicableCarSeats())) {
                    LOGGER.info("Đã tìm thấy bảo hiểm phù hợp cho xe " + carSeats + " chỗ: " + insurance.getInsuranceName());
                    return insurance;
                }
            }
            
            LOGGER.warning("Không tìm thấy bảo hiểm tai nạn phù hợp cho xe " + carSeats + " chỗ");
            return null;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm bảo hiểm tai nạn", e);
            return null;
        }
    }
    
    /**
     * Kiểm tra xem số chỗ ngồi có phù hợp với range của bảo hiểm không
     */
    private boolean isApplicableSeatRange(int seats, String seatRange) {
        if (seatRange == null) return true;
        
        if (seatRange.equals("1-5")) return seats <= 5;
        if (seatRange.equals("6-11")) return seats >= 6 && seats <= 11;
        if (seatRange.equals("12+")) return seats >= 12;
        
        return true;
    }
    
    /**
     * Tính tổng phí bảo hiểm cho booking
     * 
     * @param booking Booking cần tính phí bảo hiểm
     * @return Tổng phí bảo hiểm (đơn vị VND)
     */
    public double calculateTotalInsuranceAmount(Booking booking) {
        try {
            return bookingInsuranceRepository.getTotalPremiumAmount(booking.getBookingId()) * 1000;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tính tổng phí bảo hiểm", e);
            return 0;
        }
    }
    
    /**
     * Tính số ngày thuê cho bảo hiểm
     * 
     * @param booking Booking cần tính số ngày
     * @return Số ngày thuê (làm tròn lên)
     */
    private double calculateRentalDaysForInsurance(Booking booking) {
        LocalDateTime startDate = booking.getPickupDateTime();
        LocalDateTime endDate = booking.getReturnDateTime();
        
        if (startDate == null || endDate == null) {
            return 1.0; // Mặc định 1 ngày nếu không có thông tin
        }
        
        Duration duration = Duration.between(startDate, endDate);
        double hours = duration.toMinutes() / 60.0;
        
        // Chuyển đổi thành ngày và làm tròn lên
        double days = Math.ceil(hours / 24.0);
        return Math.max(days, 1.0); // Tối thiểu 1 ngày
    }
    
    /**
     * Ước tính giá thuê/ngày từ booking.totalAmount
     * QUAN TRỌNG: Sửa để lấy giá thuê ngày trực tiếp từ Car thay vì tính từ totalAmount
     */
    private double estimateDailyRate(Booking booking) {
        try {
            // Lấy thông tin xe từ repository
            CarRepository carRepository = new CarRepository();
            Car car = carRepository.findById(booking.getCarId());
            
            if (car != null) {
                // Lấy giá thuê ngày trực tiếp từ Car
                // Chuyển đổi từ đơn vị K sang VND thực tế
                double dailyRate = car.getPricePerDay().doubleValue() * 1000;
                LOGGER.info("Lấy giá thuê ngày trực tiếp từ Car: " + dailyRate + " VND");
                return dailyRate;
            } else {
                LOGGER.warning("Không tìm thấy xe với ID: " + booking.getCarId() + ", sử dụng phương pháp ước tính từ totalAmount");
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Lỗi khi lấy thông tin xe: " + e.getMessage(), e);
            LOGGER.info("Sử dụng phương pháp ước tính từ totalAmount");
        }
        
        // Fallback: Tính từ totalAmount nếu không lấy được thông tin xe
        // Tính số ngày thuê
        LocalDateTime startDate = booking.getPickupDateTime();
        LocalDateTime endDate = booking.getReturnDateTime();
        
        if (startDate == null || endDate == null) {
            return booking.getTotalAmount(); // Trả về totalAmount nếu không có thông tin thời gian
        }
        
        Duration duration = Duration.between(startDate, endDate);
        double hours = duration.toMinutes() / 60.0;
        double days = hours / 24.0;
        
        if (days <= 0) {
            days = 1;
        }
        
        // Ước tính giá/ngày = totalAmount / số ngày
        // Chuyển đổi từ đơn vị DB sang VND thực tế
        double actualTotalAmount = booking.getTotalAmount() * 1000;
        double dailyRate = actualTotalAmount / days;
        
        return dailyRate;
    }
    
    /**
     * Xác định hệ số năm sử dụng theo giá thuê/ngày
     * 
     * Quy tắc:
     * - ≤ 500k: hệ số = 5
     * - ≤ 800k: hệ số = 7  
     * - ≤ 1,200k: hệ số = 10
     * - > 1,200k: hệ số = 15
     */
    private double getYearCoefficient(double dailyRate) {
        if (dailyRate <= 500000) {
            return COEFFICIENT_LOW;
        } else if (dailyRate <= 800000) {
            return COEFFICIENT_MEDIUM;
        } else if (dailyRate <= 1200000) {
            return COEFFICIENT_HIGH;
        } else {
            return COEFFICIENT_LUXURY;
        }
    }

    /**
     * Cập nhật lại tất cả các bản ghi BookingInsurance cũ, đặt premiumAmount = 0 cho bảo hiểm vật chất
     * Phương thức này chỉ nên được gọi một lần để chuẩn hóa dữ liệu
     * 
     * @return Số bản ghi đã cập nhật
     */
    public int updateAllVehicleInsurancePremiums() {
        int updatedCount = 0;
        try {
            LOGGER.info("Bắt đầu cập nhật premiumAmount = 0 cho tất cả bảo hiểm vật chất...");
            
            // Lấy danh sách ID của tất cả bảo hiểm vật chất
            List<UUID> vehicleInsuranceIds = new ArrayList<>();
            List<Insurance> vehicleInsurances = insuranceRepository.findByType("VatChat");
            for (Insurance insurance : vehicleInsurances) {
                vehicleInsuranceIds.add(insurance.getInsuranceId());
            }
            
            if (vehicleInsuranceIds.isEmpty()) {
                LOGGER.warning("Không tìm thấy bảo hiểm vật chất nào trong database");
                return 0;
            }
            
            // Cập nhật tất cả bản ghi BookingInsurance có InsuranceId thuộc danh sách trên
            updatedCount = bookingInsuranceRepository.updateAllVehicleInsurancePremiums(vehicleInsuranceIds);
            
            LOGGER.info("Đã cập nhật " + updatedCount + " bản ghi BookingInsurance");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật premiumAmount cho bảo hiểm vật chất", e);
        }
        
        return updatedCount;
    }
} 