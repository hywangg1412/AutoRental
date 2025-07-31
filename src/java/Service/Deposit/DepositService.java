package Service.Deposit;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.Duration;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import Model.DTO.Deposit.DepositPageDTO;
import Model.DTO.Deposit.InsuranceDetailDTO;
import Model.DTO.Deposit.DiscountDTO;
import Model.DTO.DurationResult;
import Model.Entity.Booking.Booking;
import Model.Entity.Booking.BookingInsurance;
import Model.Entity.Deposit.Insurance;
import Model.Entity.Deposit.Terms;
import Model.Entity.Discount;

import Repository.Interfaces.IDeposit.IDepositRepository;
import Repository.Interfaces.IDeposit.ITermsRepository;
import Service.Interfaces.IDeposit.IDepositService;
import Service.Booking.BookingService;

/**
 * Service xử lý logic đặt cọc - STYLE ĐỂ SINH VIÊN DỄ HIỂU
 * Logic đơn giản: Lấy dữ liệu từ database → Tính toán → Trả về DTO
 * TÁI SỬ DỤNG logic duration từ BookingService
 */
public class DepositService implements IDepositService {

    private static final Logger LOGGER = Logger.getLogger(DepositService.class.getName());
    
    // ========== CÁC HẰNG SỐ TÍNH TOÁN - DỄ HIỂU ==========
    private static final double DEPOSIT_PERCENTAGE = 0.10;    // 10% đặt cọc (cho base amount >= 3 triệu)
    private static final double FIXED_DEPOSIT_AMOUNT = 300.0; // 300.000 VND cố định (cho base amount < 3 triệu)
    private static final double DEPOSIT_THRESHOLD = 3000.0;   // 3 triệu VND (đơn vị DB)
    private static final double VAT_PERCENTAGE = 0.10;        // 10% VAT
    private static final double VEHICLE_INSURANCE_RATE = 0.02; // 2% bảo hiểm vật chất/năm
    
    // Hệ số ước tính giá trị xe theo giá thuê/ngày
    private static final double COEFFICIENT_LOW = 5;     // ≤ 500k/ngày
    private static final double COEFFICIENT_MEDIUM = 7;  // ≤ 800k/ngày
    private static final double COEFFICIENT_HIGH = 10;   // ≤ 1,200k/ngày
    private static final double COEFFICIENT_LUXURY = 15; // > 1,200k/ngày

    // ========== HẰNG SỐ DURATION - TÁI SỬ DỤNG TỪ BOOKINGSERVICE ==========
    private static final double MIN_HOURLY_DURATION = 4.0; // Tối thiểu 4 giờ thuê
    private static final double MIN_DAILY_DURATION = 0.5;  // Tối thiểu 0.5 ngày thuê (12 tiếng)
    private static final double MIN_MONTHLY_DURATION = 0.5; // Tối thiểu 0.5 tháng thuê (15 ngày)
    private static final int DAYS_PER_MONTH = 30; // Quy ước 1 tháng = 30 ngày

    private final IDepositRepository depositRepository;
    private final ITermsRepository termsRepository;
    private final BookingService bookingService; // Tái sử dụng logic từ BookingService

    public DepositService(IDepositRepository depositRepository, ITermsRepository termsRepository) {
        this.depositRepository = depositRepository;
        this.termsRepository = termsRepository;
        this.bookingService = new BookingService(); // Tạo instance để tái sử dụng
    }

    // ========== PHƯƠNG THỨC CHÍNH - LẤY DỮ LIỆU DEPOSIT ==========

    @Override
    public DepositPageDTO getDepositPageData(UUID bookingId, UUID userId) throws Exception {
        // Bước 1: Kiểm tra quyền sở hữu booking
        if (!depositRepository.isBookingOwnedByUser(bookingId, userId)) {
            throw new SecurityException("Booking không thuộc về user này");
        }

        // Bước 2: Lấy thông tin booking
        Booking booking = depositRepository.getBookingForDeposit(bookingId);
        if (booking == null) {
            throw new IllegalArgumentException("Không tìm thấy booking");
        }

        // Bước 3: Kiểm tra trạng thái booking
        if (!"Confirmed".equals(booking.getStatus()) && !"Pending".equals(booking.getStatus())) {
            throw new IllegalStateException("Booking phải ở trạng thái Confirmed hoặc Pending");
        }

        // Bước 4: Lấy thông tin xe
        Repository.Deposit.DepositRepository.CarInfoForDeposit carInfo = 
            ((Repository.Deposit.DepositRepository) depositRepository).getCarInfoByBookingId(bookingId);

        // Bước 5: Tạo DTO và điền dữ liệu
        DepositPageDTO dto = new DepositPageDTO();

        // Map thông tin cơ bản
        mapBookingInfoToDTO(booking, dto);
        
        // Map thông tin xe
        if (carInfo != null) {
            mapCarInfoToDTO(carInfo, dto);
        }
        
        // Tính duration bằng DurationResult
        calculateDurationUsingDurationResult(booking, dto);
        
        // Lấy danh sách bảo hiểm
        List<InsuranceDetailDTO> insuranceList = getInsuranceList(bookingId);
        dto.setInsuranceDetails(insuranceList);
        
        // Tính toán giá cả
        calculateAllPricing(booking, dto);
        
        // Lấy thông tin discount đã áp dụng (nếu có)
        if (booking.getDiscountId() != null) {
            Discount appliedDiscount = depositRepository.getDiscountById(booking.getDiscountId());
            if (appliedDiscount != null) {
                // Convert từ Entity sang DTO
                DiscountDTO discountDTO = new DiscountDTO();
                discountDTO.setDiscountId(appliedDiscount.getDiscountId());
                discountDTO.setName(appliedDiscount.getDiscountName());
                discountDTO.setDescription(appliedDiscount.getDescription());
                discountDTO.setDiscountType(appliedDiscount.getDiscountType());
                discountDTO.setDiscountValue(appliedDiscount.getDiscountValue().doubleValue());
                discountDTO.setVoucherCode(appliedDiscount.getVoucherCode());
                discountDTO.setMinOrderAmount(appliedDiscount.getMinOrderAmount() != null ? appliedDiscount.getMinOrderAmount().doubleValue() : 0.0);
                discountDTO.setMaxDiscountAmount(appliedDiscount.getMaxDiscountAmount() != null ? appliedDiscount.getMaxDiscountAmount().doubleValue() : 0.0);
                dto.setAppliedDiscount(discountDTO);
            }
        }

        return dto;
    }

    // ========== CÁC PHƯƠNG THỨC KHÁC ==========

    @Override
    public boolean applyVoucher(UUID bookingId, String voucherCode, UUID userId) throws Exception {
        LOGGER.info("=== APPLYING VOUCHER ===");
        LOGGER.info("Booking ID: " + bookingId);
        LOGGER.info("Voucher Code: " + voucherCode);
        LOGGER.info("User ID: " + userId);
        
        // Debug: Log tất cả voucher active trong DB
        depositRepository.logAllActiveVouchers();
        
        // 1. Kiểm tra quyền sở hữu booking
        if (!isBookingOwnedByUser(bookingId, userId)) {
            LOGGER.warning("Booking không thuộc về user này: " + userId);
            return false;
        }
        
        // 2. Lấy thông tin voucher từ database
        LOGGER.info("Đang tìm voucher: " + voucherCode);
        Discount discount = depositRepository.getValidVoucher(voucherCode);
        if (discount == null) {
            LOGGER.warning("Voucher không tồn tại: " + voucherCode);
            // Debug: Kiểm tra tất cả voucher trong DB
            depositRepository.debugVoucherStatus(voucherCode);
            return false;
        }
        LOGGER.info("Tìm thấy voucher: " + discount.getDiscountName());
        
        // 3. Kiểm tra voucher có active không
        LOGGER.info("Kiểm tra voucher active: " + discount.isIsActive());
        if (!discount.isIsActive()) {
            LOGGER.warning("Voucher không active: " + voucherCode);
            return false;
        }
        
        // 4. Kiểm tra thời gian hiệu lực
        Date currentDate = new Date();
        if (discount.getStartDate() != null && currentDate.before(discount.getStartDate())) {
            LOGGER.warning("Voucher chưa có hiệu lực: " + voucherCode);
            return false;
        }
        if (discount.getEndDate() != null && currentDate.after(discount.getEndDate())) {
            LOGGER.warning("Voucher đã hết hạn: " + voucherCode);
            return false;
        }
        
        // 5. Kiểm tra số lần sử dụng
        if (discount.getUsageLimit() != null && discount.getUsedCount() >= discount.getUsageLimit()) {
            LOGGER.warning("Voucher đã hết lượt sử dụng: " + voucherCode);
            return false;
        }
        
        // 6. Kiểm tra user đã dùng voucher này chưa
        int userUsageCount = countUserVoucherUsage(userId, discount.getDiscountId());
        if (userUsageCount > 0) {
            LOGGER.warning("User đã sử dụng voucher này: " + voucherCode);
            return false;
        }
        
        // 7. Lấy thông tin booking để kiểm tra giá trị đơn hàng
        Booking booking = depositRepository.getBookingForDeposit(bookingId);
        if (booking == null) {
            LOGGER.severe("Không tìm thấy booking: " + bookingId);
            return false;
        }
        
        // 8. Tính toán giá trị đơn hàng (base amount + insurance)
        double baseAmount = booking.getTotalAmount();
        double insuranceAmount = calculateVehicleInsurance(booking);
        double subtotal = baseAmount + insuranceAmount;
        
        LOGGER.info("Tính toán giá trị đơn hàng:");
        LOGGER.info("  - Base amount (DB): " + baseAmount);
        LOGGER.info("  - Insurance amount (DB): " + insuranceAmount);
        LOGGER.info("  - Subtotal (DB): " + subtotal);
        LOGGER.info("  - Subtotal (VND): " + (subtotal * 1000));
        
        // 9. Kiểm tra giá trị tối thiểu đơn hàng
        // Chuyển đổi subtotal từ DB unit sang VND để so sánh với MinOrderAmount
        double subtotalVND = subtotal * 1000;
        LOGGER.info("Kiểm tra giá trị tối thiểu: subtotal(VND)=" + subtotalVND + ", minOrder=" + discount.getMinOrderAmount());
        if (discount.getMinOrderAmount() != null && subtotalVND < discount.getMinOrderAmount().doubleValue()) {
            LOGGER.warning("Đơn hàng không đạt giá trị tối thiểu: " + subtotalVND + " < " + discount.getMinOrderAmount());
            return false;
        }
        
        // 10. Cập nhật discount cho booking
        boolean updateSuccess = depositRepository.updateBookingDiscount(bookingId, discount.getDiscountId());
        if (!updateSuccess) {
            LOGGER.severe("Không thể cập nhật discount cho booking");
            return false;
        }
        
        // 11. Tăng số lần sử dụng voucher
        depositRepository.incrementVoucherUsage(discount.getDiscountId());
        
        // 12. Ghi log sử dụng voucher của user
        depositRepository.recordUserVoucherUsage(userId, discount.getDiscountId());
        
        LOGGER.info("Voucher applied successfully: " + voucherCode);
        LOGGER.info("=== END APPLYING VOUCHER ===");
        return true;
    }



    @Override
    public String createVoucherResponse(boolean success, String message, UUID bookingId, UUID userId) throws Exception {
        LOGGER.info("=== CREATING VOUCHER RESPONSE ===");
        LOGGER.info("Success: " + success);
        LOGGER.info("Message: " + message);
        
        if (!success) {
            String errorResponse = String.format("{\"success\": false, \"message\": \"%s\"}", message);
            LOGGER.info("Error response: " + errorResponse);
            return errorResponse;
        }
        
        // Lấy dữ liệu cập nhật sau khi áp dụng/xóa voucher
        DepositPageDTO depositData = getDepositPageData(bookingId, userId);
        LOGGER.info("Deposit data loaded:");
        LOGGER.info("  - Subtotal: " + depositData.getSubtotal());
        LOGGER.info("  - Discount amount: " + depositData.getDiscountAmount());
        LOGGER.info("  - VAT amount: " + depositData.getVatAmount());
        LOGGER.info("  - Total amount: " + depositData.getTotalAmount());
        LOGGER.info("  - Deposit amount: " + depositData.getDepositAmount());
        if (depositData.getAppliedDiscount() != null) {
            LOGGER.info("  - Applied discount: " + depositData.getAppliedDiscount().getVoucherCode());
        }
        
        // Tạo response JSON theo format mà JSP mong đợi
        StringBuilder json = new StringBuilder();
        json.append("{");
        json.append("\"success\": true,");
        json.append("\"message\": \"").append(message).append("\",");
        
        // Thêm thông tin voucher nếu có
        if (depositData.getAppliedDiscount() != null) {
            json.append("\"discountCode\": \"").append(depositData.getAppliedDiscount().getVoucherCode()).append("\",");
            json.append("\"discountAmount\": ").append(depositData.getDiscountAmount()).append(",");
            LOGGER.info("  - JSON discountCode: " + depositData.getAppliedDiscount().getVoucherCode());
            LOGGER.info("  - JSON discountAmount: " + depositData.getDiscountAmount());
        } else {
            json.append("\"discountCode\": null,");
            json.append("\"discountAmount\": 0,");
            LOGGER.info("  - JSON discountCode: null");
            LOGGER.info("  - JSON discountAmount: 0");
        }
        
        // Thêm các thông tin khác theo đúng format JSP mong đợi
        json.append("\"baseAmount\": ").append(depositData.getSubtotal()).append(",");
        json.append("\"vatAmount\": ").append(depositData.getVatAmount()).append(",");
        json.append("\"totalAmount\": ").append(depositData.getTotalAmount()).append(",");
        json.append("\"depositAmount\": ").append(depositData.getDepositAmount());
        json.append("}");
        
        String response = json.toString();
        LOGGER.info("Final JSON response: " + response);
        LOGGER.info("=== END CREATING VOUCHER RESPONSE ===");
        return response;
    }

    @Override
    public boolean agreeToTerms(UUID bookingId, UUID userId, String termsVersion) throws Exception {
        // Kiểm tra quyền
        if (!depositRepository.isBookingOwnedByUser(bookingId, userId)) {
            throw new SecurityException("Không có quyền với booking này");
        }

        // Cập nhật đồng ý điều khoản
        return depositRepository.updateTermsAgreement(bookingId, true, termsVersion);
    }

    @Override
    public DepositPageDTO recalculateCost(UUID bookingId) throws Exception {
        // Lấy lại booking và tính toán
        Booking booking = depositRepository.getBookingForDeposit(bookingId);
        if (booking == null) {
            throw new IllegalArgumentException("Không tìm thấy booking");
        }
        
        // Lấy car info
        Repository.Deposit.DepositRepository.CarInfoForDeposit carInfo = 
            ((Repository.Deposit.DepositRepository) depositRepository).getCarInfoByBookingId(bookingId);
        
        DepositPageDTO dto = new DepositPageDTO();
        mapBookingInfoToDTO(booking, dto);
        
        if (carInfo != null) {
            mapCarInfoToDTO(carInfo, dto);
        }
        
        calculateDurationUsingDurationResult(booking, dto);
        
        List<InsuranceDetailDTO> insuranceList = getInsuranceList(bookingId);
        dto.setInsuranceDetails(insuranceList);
        
        calculateAllPricing(booking, dto);
        return dto;
    }

    @Override
    public boolean isBookingOwnedByUser(UUID bookingId, UUID userId) throws Exception {
        return depositRepository.isBookingOwnedByUser(bookingId, userId);
    }

    @Override
    public boolean removeVoucher(UUID bookingId, UUID userId) throws Exception {
        LOGGER.info("=== REMOVING VOUCHER ===");
        LOGGER.info("Booking ID: " + bookingId);
        LOGGER.info("User ID: " + userId);
        
        // 1. Kiểm tra quyền sở hữu booking
        if (!isBookingOwnedByUser(bookingId, userId)) {
            LOGGER.warning("Booking không thuộc về user này: " + userId);
            return false;
        }
        
        // 2. Lấy thông tin booking
        Booking booking = depositRepository.getBookingForDeposit(bookingId);
        if (booking == null) {
            LOGGER.severe("Không tìm thấy booking: " + bookingId);
            return false;
        }
        
        // 3. Kiểm tra xem booking có voucher không
        if (booking.getDiscountId() == null) {
            LOGGER.warning("Booking không có voucher để xóa");
            return false;
        }
        
        // 4. Cập nhật booking để xóa discount
        boolean updateSuccess = depositRepository.updateBookingDiscount(bookingId, null);
        if (!updateSuccess) {
            LOGGER.severe("Không thể xóa discount cho booking");
            return false;
        }
        
        LOGGER.info("Voucher removed successfully from booking: " + bookingId);
        return true;
    }

    // ========== CÁC PHƯƠNG THỨC HELPER - ĐƠN GIẢN DỄ HIỂU ==========
    
    /**
     * Sao chép thông tin từ Booking entity sang DTO
     */
    private void mapBookingInfoToDTO(Booking booking, DepositPageDTO dto) {
        dto.setBookingId(booking.getBookingId());
        dto.setBookingCode(booking.getBookingCode());
        dto.setCustomerName(booking.getCustomerName());
        dto.setCustomerPhone(booking.getCustomerPhone());
        dto.setCustomerEmail(booking.getCustomerEmail());
        dto.setPickupDateTime(booking.getPickupDateTime());
        dto.setReturnDateTime(booking.getReturnDateTime());
        dto.setRentalType(booking.getRentalType()); // THÊM DÒNG NÀY
        dto.setTermsAgreed(booking.isTermsAgreed());
        dto.setTermsAgreedAt(booking.getTermsAgreedAt());
        
        // Lấy điều khoản từ DB theo version
        try {
            Terms terms = termsRepository.findByVersion(booking.getTermsVersion());
            if (terms != null) {
                dto.setTermsVersion(terms.getVersion());
                dto.setTermsTitle(terms.getTitle());
                dto.setTermsShortContent(terms.getShortContent());
                dto.setTermsFullContent(terms.getFullContent());
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Lỗi khi lấy điều khoản từ DB", e);
        }
    }

    /**
     * Map thông tin xe - MỚI THÊM
     */
    private void mapCarInfoToDTO(Repository.Deposit.DepositRepository.CarInfoForDeposit carInfo, DepositPageDTO dto) {
        dto.setCarModel(carInfo.getCarModel());
        dto.setCarBrand(carInfo.getCarBrand());
        dto.setLicensePlate(carInfo.getLicensePlate());
        dto.setCarSeats(carInfo.getCarSeats());
    }

    /**
     * Tính duration sử dụng DurationResult - TÁI SỬ DỤNG TỪ BOOKINGSERVICE
     */
    private void calculateDurationUsingDurationResult(Booking booking, DepositPageDTO dto) {
        if (booking.getPickupDateTime() != null && booking.getReturnDateTime() != null) {
            String rentalType = booking.getRentalType() != null ? booking.getRentalType() : "daily";
            
            LOGGER.info("=== DURATION CALCULATION DEBUG ===");
            LOGGER.info("Booking ID: " + booking.getBookingId());
            LOGGER.info("Rental Type: " + rentalType);
            LOGGER.info("Pickup: " + booking.getPickupDateTime());
            LOGGER.info("Return: " + booking.getReturnDateTime());
            
            // TÁI SỬ DỤNG TRỰC TIẾP TỪ BOOKINGSERVICE - ĐẢM BẢO TÍNH NHẤT QUÁN
            DurationResult durationResult = bookingService.calculateDuration(
                booking.getPickupDateTime(), 
                booking.getReturnDateTime(), 
                rentalType
            );
            
            // Set duration từ DurationResult
            dto.setDuration(durationResult.getBillingUnitsAsDouble());
            
            // Set formattedDuration từ DurationResult (giống như staff-booking)
            if (durationResult.getFormattedDuration() != null) {
                dto.setFormattedDuration(durationResult.getFormattedDuration());
            }
            
            LOGGER.info(String.format("Duration calculation result: %s %s %s", 
                durationResult.getBillingUnits(), 
                durationResult.getUnitType(),
                durationResult.getNote() != null ? "(" + durationResult.getNote() + ")" : ""
            ));
            LOGGER.info("Formatted duration: " + dto.getFormattedDuration());
            LOGGER.info("=== END DURATION CALCULATION ===");
        } else {
            dto.setDuration(1.0); // Default 1 ngày
            LOGGER.warning("Pickup or Return time is null, using default duration 1.0");
        }
    }





    /**
     * TÍNH BẢO HIỂM VẬT CHẤT PER DAY THEO CÔNG THỨC SINH VIÊN CUNG CẤP
     * 
     * Công thức:
     * 1. Ước tính giá trị xe = Giá thuê/ngày × 365 × Hệ số năm sử dụng  
     * 2. Phí bảo hiểm vật chất PER DAY = Giá trị xe × 2% / 365
     *    = (Giá thuê/ngày × 365 × Hệ số năm) × 0.02 / 365
     * 
     * LƯU Ý: Database lưu chia 1000, tính toán với VND thực rồi chia 1000 để trả về DB value
     * 
     * Return: Phí bảo hiểm vật chất PER DAY (đơn vị DB)
     */
    private double calculateVehicleInsurance(Booking booking) {
        try {
            LOGGER.info("=== CALCULATING VEHICLE INSURANCE ===");
            LOGGER.info("Booking ID: " + booking.getBookingId());
            LOGGER.info("Total Amount (DB value): " + booking.getTotalAmount());
            
            // Chuyển đổi từ giá trị database sang VND thực tế
            double actualTotalAmount = booking.getTotalAmount() * 1000;
            LOGGER.info("Actual Total Amount (VND for calculation): " + actualTotalAmount);
            
            // Bước 1: Ước tính giá thuê/ngày (VND thực)
            double dailyRateVND = estimateDailyRateWithActualValue(booking, actualTotalAmount);
            LOGGER.info("Estimated daily rate: " + dailyRateVND + " VND");

            // Bước 2: Xác định hệ số năm sử dụng theo giá thuê
            double yearCoefficient = getYearCoefficient(dailyRateVND);
            LOGGER.info("Year coefficient: " + yearCoefficient);

            // Bước 3: Tính giá xe mới (VND thực)
            double estimatedCarValue = dailyRateVND * 365 * yearCoefficient;
            LOGGER.info("Estimated car value: " + estimatedCarValue + " VND");
            
            // Bước 4: Tính phí bảo hiểm vật chất PER DAY (VND thực)
            double vehicleInsurancePerDayVND = estimatedCarValue * VEHICLE_INSURANCE_RATE / 365;
            LOGGER.info("Vehicle insurance per day (VND): " + vehicleInsurancePerDayVND);
            
            // Chuyển về đơn vị DB (chia 1000) để gán vào DTO
            double vehicleInsurancePerDayDB = vehicleInsurancePerDayVND / 1000;
            vehicleInsurancePerDayDB = Math.round(vehicleInsurancePerDayDB * 1000.0) / 1000.0;
            
            LOGGER.info("Vehicle insurance per day: " + vehicleInsurancePerDayVND + " VND → " + vehicleInsurancePerDayDB + " (DB value for DTO)");
            LOGGER.info("=== END VEHICLE INSURANCE CALCULATION ===");

            return vehicleInsurancePerDayDB;

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi tính bảo hiểm vật chất", e);
            return 0.0;
        }
    }

    /**
     * Kiểm tra xem số chỗ ngồi có phù hợp với range của bảo hiểm TNDS không
     */
    private boolean isApplicableSeatRange(int seats, String seatRange) {
        if (seatRange == null) return true;
        
        if (seatRange.equals("1-5")) return seats <= 5;
        if (seatRange.equals("6-11")) return seats >= 6 && seats <= 11;
        if (seatRange.equals("12+")) return seats >= 12;
        
        return true;
    }

    /**
     * Lấy danh sách bảo hiểm cho booking, lọc TNDS theo số chỗ ngồi
     * Đảm bảo chỉ hiển thị một bảo hiểm vật chất và một bảo hiểm tai nạn nếu có
     */
    private List<InsuranceDetailDTO> getInsuranceList(UUID bookingId) throws Exception {
        List<InsuranceDetailDTO> insuranceList = new ArrayList<>();
        
        try {
            // Lấy danh sách booking insurance từ database
            List<BookingInsurance> bookingInsurances = depositRepository.getBookingInsurancesByBookingId(bookingId);
            LOGGER.info("Found " + bookingInsurances.size() + " booking insurances from database");

            // Tạo map để lưu bảo hiểm theo loại (chỉ giữ một bảo hiểm cho mỗi loại)
            java.util.Map<String, InsuranceDetailDTO> insuranceMap = new java.util.HashMap<>();

            // Với mỗi booking insurance, lấy thông tin chi tiết
            for (BookingInsurance bookingInsurance : bookingInsurances) {
                Insurance insurance = depositRepository.getInsuranceById(bookingInsurance.getInsuranceId());

                if (insurance != null) {
                    LOGGER.info("Processing insurance: " + insurance.getInsuranceName() + 
                            " (Type: " + insurance.getInsuranceType() + ", Premium: " + 
                            bookingInsurance.getPremiumAmount() + ")");
                    
                    // Kiểm tra TNDS có phù hợp với số chỗ không
                    if ("TaiNan".equals(insurance.getInsuranceType())) {
                        String seatRange = insurance.getApplicableCarSeats();
                        int carSeats = bookingInsurance.getCarSeats();
                        if (!isApplicableSeatRange(carSeats, seatRange)) {
                            LOGGER.info("Skipping insurance - seat range not applicable: " + seatRange + 
                                    " for car with " + carSeats + " seats");
                            continue;
                        }
                    }

                    String insuranceType = insurance.getInsuranceType();
                    
                    // Nếu đã có bảo hiểm loại này, chỉ cập nhật nếu phí cao hơn
                    if (insuranceMap.containsKey(insuranceType)) {
                        InsuranceDetailDTO existingDto = insuranceMap.get(insuranceType);
                        if (bookingInsurance.getPremiumAmount() > existingDto.getPremiumAmount()) {
                            LOGGER.info("Updating existing insurance with higher premium: " + 
                                    bookingInsurance.getPremiumAmount() + " > " + existingDto.getPremiumAmount());
                            existingDto.setPremiumAmount(bookingInsurance.getPremiumAmount());
                            existingDto.setInsuranceName(insurance.getInsuranceName());
                            existingDto.setDescription(insurance.getDescription());
                        }
                    } else {
                        // Nếu chưa có, thêm vào map
                        InsuranceDetailDTO dto = new InsuranceDetailDTO();
                        dto.setInsuranceName(insurance.getInsuranceName());
                        dto.setInsuranceType(insuranceType);
                        dto.setPremiumAmount(bookingInsurance.getPremiumAmount());
                        dto.setDescription(insurance.getDescription());
                        
                        insuranceMap.put(insuranceType, dto);
                        LOGGER.info("Added insurance: " + insurance.getInsuranceName() + 
                                " (" + insuranceType + ") = " + bookingInsurance.getPremiumAmount() + " (DB value)");
                    }
                } else {
                    LOGGER.warning("Insurance not found for ID: " + bookingInsurance.getInsuranceId());
                }
            }

            // Chuyển từ map sang list
            insuranceList.addAll(insuranceMap.values());
            
            LOGGER.info("Final insurance list contains " + insuranceList.size() + " items:");
            for (InsuranceDetailDTO dto : insuranceList) {
                LOGGER.info("- " + dto.getInsuranceName() + " (" + dto.getInsuranceType() + "): " + 
                        dto.getPremiumAmount() + " (DB value)");
            }

        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Lỗi khi lấy thông tin bảo hiểm cho booking " + bookingId, e);
            // Trả về danh sách rỗng thay vì throw exception
        }

        return insuranceList;
    }

    /**
     * Tính toán tất cả giá cả - LOGIC ĐƠN GIẢN
     * Logic: Giá thuê + Bảo hiểm - Giảm giá + VAT = Tổng cộng
     *        Đặt cọc = 300.000 VND (hardcode)
     * LƯU Ý: Giữ nguyên giá trị DB để tính toán, format display sẽ xử lý × 1000
     */
    private void calculateAllPricing(Booking booking, DepositPageDTO dto) throws Exception {
        try {
            LOGGER.info("=== CALCULATING ALL PRICING ===");
            
            // Lấy thông tin bảo hiểm từ database
            List<InsuranceDetailDTO> insuranceDetails = dto.getInsuranceDetails();
            
            // Tính tổng phí bảo hiểm từ danh sách chi tiết
            double totalInsuranceAmount = 0.0;
            for (InsuranceDetailDTO insurance : insuranceDetails) {
                totalInsuranceAmount += insurance.getPremiumAmount();
                LOGGER.info("Insurance: " + insurance.getInsuranceName() + " = " + insurance.getPremiumAmount() + " (DB value)");
            }
            LOGGER.info("Total insurance amount from details: " + totalInsuranceAmount + " (DB value)");
            
            // Lấy tổng phí bảo hiểm từ repository để kiểm tra
            double repoInsuranceAmount = depositRepository.getTotalInsuranceAmount(booking.getBookingId());
            LOGGER.info("Total insurance amount from repository: " + repoInsuranceAmount + " (DB value)");
            
            // Sử dụng tổng phí bảo hiểm từ chi tiết để đảm bảo chính xác
            double insuranceAmount = totalInsuranceAmount;
            
            // Tính base rental price = booking.totalAmount - insuranceAmount
            double baseAmount = booking.getTotalAmount() - insuranceAmount;
            LOGGER.info("Base amount calculation: " + booking.getTotalAmount() + " - " + insuranceAmount + " = " + baseAmount + " (DB value)");
            
            // Bước 3: Tính subtotal trước khi áp dụng discount
            double subtotal = baseAmount + insuranceAmount;
            LOGGER.info("Subtotal before discount: " + baseAmount + " + " + insuranceAmount + " = " + subtotal);
            
            // Bước 4: Giảm giá từ voucher đã áp dụng
            double discountAmount = 0.0;
            if (booking.getDiscountId() != null) {
                Discount appliedDiscount = depositRepository.getDiscountById(booking.getDiscountId());
                if (appliedDiscount != null) {
                    LOGGER.info("Tính toán discount cho voucher: " + appliedDiscount.getVoucherCode());
                    LOGGER.info("  - Discount type: " + appliedDiscount.getDiscountType());
                    LOGGER.info("  - Discount value: " + appliedDiscount.getDiscountValue());
                    LOGGER.info("  - Max discount: " + appliedDiscount.getMaxDiscountAmount());
                    
                    if ("Percent".equalsIgnoreCase(appliedDiscount.getDiscountType())) {
                        // Giảm theo phần trăm
                        discountAmount = subtotal * (appliedDiscount.getDiscountValue().doubleValue() / 100.0);
                        // Kiểm tra giới hạn tối đa
                        if (appliedDiscount.getMaxDiscountAmount() != null && discountAmount > appliedDiscount.getMaxDiscountAmount().doubleValue()) {
                            discountAmount = appliedDiscount.getMaxDiscountAmount().doubleValue();
                        }
                        LOGGER.info("  - Percent discount: " + discountAmount + " (DB value)");
                    } else {
                        // Giảm cố định - chuyển từ VND sang DB unit
                        discountAmount = appliedDiscount.getDiscountValue().doubleValue() / 1000.0;
                        LOGGER.info("  - Fixed discount: " + discountAmount + " (DB value) = " + (discountAmount * 1000) + " VND");
                    }
                    LOGGER.info("Applied discount: " + appliedDiscount.getVoucherCode() + " = " + discountAmount + " (DB value)");
                }
            }
            LOGGER.info("Final discount amount: " + discountAmount + " (DB value)");
            
            // Bước 5: Tính subtotal sau khi áp dụng discount
            double finalSubtotal = subtotal - discountAmount;
            LOGGER.info("Final subtotal after discount: " + subtotal + " - " + discountAmount + " = " + finalSubtotal);
            
            // Bước 6: Tính VAT = finalSubtotal * 10%
            double vatAmount = finalSubtotal * VAT_PERCENTAGE;
            LOGGER.info("VAT (10%): " + finalSubtotal + " × " + VAT_PERCENTAGE + " = " + vatAmount);
            
            // Bước 7: Tổng cộng = finalSubtotal + VAT
            double totalAmount = finalSubtotal + vatAmount;
            LOGGER.info("Total: " + finalSubtotal + " + " + vatAmount + " = " + totalAmount);
            
            // Bước 8: Tính tiền đặt cọc theo logic mới
            double depositAmount;
            if (finalSubtotal >= DEPOSIT_THRESHOLD) {
                // Nếu finalSubtotal >= 3 triệu: đặt cọc = 10% của finalSubtotal
                depositAmount = finalSubtotal * DEPOSIT_PERCENTAGE;
                LOGGER.info("Deposit calculation (10%): " + finalSubtotal + " × " + DEPOSIT_PERCENTAGE + " = " + depositAmount + " (DB value)");
            } else {
                // Nếu finalSubtotal < 3 triệu: đặt cọc cố định 300.000 VND
                depositAmount = FIXED_DEPOSIT_AMOUNT;
                LOGGER.info("Deposit (fixed): " + FIXED_DEPOSIT_AMOUNT + " (DB value) = 300.000 VND");
            }

            // Gán vào DTO (giá trị DB, format methods sẽ xử lý hiển thị)
            dto.setBaseRentalPrice(baseAmount);
            dto.setTotalInsuranceAmount(insuranceAmount);
            dto.setDiscountAmount(discountAmount);
            dto.setSubtotal(finalSubtotal);
            dto.setVatAmount(vatAmount);
            dto.setTotalAmount(totalAmount);
            dto.setDepositAmount(depositAmount);
            
            LOGGER.info("=== END PRICING CALCULATION ===");
            LOGGER.info("Final deposit amount: " + depositAmount + " (DB value) - JSP will show with 000 VND suffix");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi tính toán giá cho booking " + booking.getBookingId(), e);
            
            // Nếu lỗi, dùng giá trị mặc định để tránh crash
            double baseAmount = booking.getTotalAmount();
            dto.setBaseRentalPrice(baseAmount);
            dto.setTotalInsuranceAmount(0.0);
            dto.setDiscountAmount(0.0);
            dto.setSubtotal(baseAmount);
            dto.setVatAmount(baseAmount * VAT_PERCENTAGE);
            dto.setTotalAmount(baseAmount * (1 + VAT_PERCENTAGE));
            
            // Tính tiền đặt cọc theo logic mới
            double depositAmount;
            if (baseAmount >= DEPOSIT_THRESHOLD) {
                depositAmount = baseAmount * DEPOSIT_PERCENTAGE;
            } else {
                depositAmount = FIXED_DEPOSIT_AMOUNT;
            }
            dto.setDepositAmount(depositAmount);
        }
    }

    // Phương thức getTotalInsuranceAmount đã được xóa và sử dụng trực tiếp từ repository
    
    /**
     * Ước tính giá thuê/ngày từ booking.totalAmount
     */
    private double estimateDailyRate(Booking booking) {
        LOGGER.info("--- Estimating daily rate ---");
        
        // Tính số ngày thuê bằng DurationResult để chính xác
        DurationResult durationResult = bookingService.calculateDuration(
            booking.getPickupDateTime(), 
            booking.getReturnDateTime(), 
            booking.getRentalType() != null ? booking.getRentalType() : "daily"
        );
        
        double rentalDays = durationResult.getBillingUnitsAsDouble();
        LOGGER.info("Duration result: " + durationResult.getBillingUnits() + " " + durationResult.getUnitType());
        
        // Chuyển đổi về ngày
        if ("hour".equals(durationResult.getUnitType())) {
            rentalDays = rentalDays / 24.0;
            LOGGER.info("Converted " + durationResult.getBillingUnits() + " hours to " + rentalDays + " days");
        } else if ("month".equals(durationResult.getUnitType())) {
            rentalDays = rentalDays * 30;
            LOGGER.info("Converted " + durationResult.getBillingUnits() + " months to " + rentalDays + " days");
        }
        
        if (rentalDays <= 0) {
            rentalDays = 1;
            LOGGER.info("Rental days was <= 0, set to 1");
        }

        // Ước tính giá/ngày = totalAmount / số ngày
        double dailyRate = booking.getTotalAmount() / rentalDays;
        LOGGER.info("Daily rate calculation: " + booking.getTotalAmount() + " / " + rentalDays + " = " + dailyRate);
        
        return dailyRate;
    }

    /**
     * Ước tính giá thuê/ngày từ giá trị thực tế (đã nhân 1000)
     * Sử dụng cho tính bảo hiểm vật chất với giá trị VND chính xác
     */
    private double estimateDailyRateWithActualValue(Booking booking, double actualTotalAmount) {
        LOGGER.info("--- Estimating daily rate with actual VND value ---");
        
        // Tính số ngày thuê bằng DurationResult để chính xác
        DurationResult durationResult = bookingService.calculateDuration(
            booking.getPickupDateTime(), 
            booking.getReturnDateTime(), 
            booking.getRentalType() != null ? booking.getRentalType() : "daily"
        );
        
        double rentalDays = durationResult.getBillingUnitsAsDouble();
        LOGGER.info("Duration result: " + durationResult.getBillingUnits() + " " + durationResult.getUnitType());
        
        // Chuyển đổi về ngày
        if ("hour".equals(durationResult.getUnitType())) {
            rentalDays = rentalDays / 24.0;
            LOGGER.info("Converted " + durationResult.getBillingUnits() + " hours to " + rentalDays + " days");
        } else if ("month".equals(durationResult.getUnitType())) {
            rentalDays = rentalDays * 30;
            LOGGER.info("Converted " + durationResult.getBillingUnits() + " months to " + rentalDays + " days");
        }
        
        if (rentalDays <= 0) {
            rentalDays = 1;
            LOGGER.info("Rental days was <= 0, set to 1");
        }

        // Ước tính giá/ngày = actualTotalAmount / số ngày
        double dailyRate = actualTotalAmount / rentalDays;
        LOGGER.info("Daily rate calculation: " + actualTotalAmount + " VND / " + rentalDays + " days = " + dailyRate + " VND/day");
        
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

    // ====== BỔ SUNG HELPER VOUCHER/DISCOUNT (CHỈ THÊM MỚI) ======

    /**
     * Helper: Log toàn bộ voucher đang active (gọi từ repository)
     */
    public void logAllActiveVouchers() {
        if (depositRepository instanceof Repository.Deposit.DepositRepository) {
            ((Repository.Deposit.DepositRepository) depositRepository).logAllActiveVouchers();
        } else {
            LOGGER.info("Repository không hỗ trợ logAllActiveVouchers()");
        }
    }

    /**
     * Helper: Debug chi tiết trạng thái voucher
     */
    public void debugVoucherStatus(String voucherCode) {
        if (depositRepository instanceof Repository.Deposit.DepositRepository) {
            ((Repository.Deposit.DepositRepository) depositRepository).debugVoucherStatus(voucherCode);
        } else {
            LOGGER.info("Repository không hỗ trợ debugVoucherStatus()");
        }
    }

    /**
     * Helper: Kiểm tra user đã dùng voucher này bao nhiêu lần
     */
    public int countUserVoucherUsage(UUID userId, UUID discountId) {
        if (depositRepository instanceof Repository.Deposit.DepositRepository) {
            return ((Repository.Deposit.DepositRepository) depositRepository).countUserVoucherUsage(userId, discountId);
        }
        return 0;
    }

    /**
     * Helper: Kiểm tra tổng số lượt sử dụng voucher này trên toàn hệ thống
     */
    public int countTotalVoucherUsage(UUID discountId) {
        if (depositRepository instanceof Repository.Deposit.DepositRepository) {
            return ((Repository.Deposit.DepositRepository) depositRepository).countTotalVoucherUsage(discountId);
        }
        return 0;
    }

    /**
     * Helper: Validate voucher nâng cao (có thể dùng cho unit test hoặc debug)
     */
    public boolean isVoucherCurrentlyValid(String voucherCode) {
        if (depositRepository instanceof Repository.Deposit.DepositRepository) {
            return ((Repository.Deposit.DepositRepository) depositRepository).isVoucherCurrentlyValid(voucherCode);
        }
        return false;
    }

    // ====== BỔ SUNG HELPER REMOVE VOUCHER/DISCOUNT (CHỈ THÊM MỚI) ======

    /**
     * Helper: Xóa thông tin voucher/discount khỏi DepositPageDTO (nếu cần clear ở service)
     */
    public void removeVoucherInfo(DepositPageDTO dto) {
        if (dto != null) {
            dto.setAppliedDiscount(null);
            dto.setDiscountAmount(0.0);
        }
    }
}
