package Model.DTO.Deposit;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

import Model.DTO.DurationResult;
import Utils.PriceUtils;

/**
 * DTO mở rộng cho trang Deposit
 * Chứa thông tin Booking + Car + các thông tin cần thiết cho deposit
 * Sử dụng trong DepositServlet
 */
public class BookingDepositDTO {
    
    // ========== THÔNG TIN BOOKING ==========
    private UUID bookingId;
    private String bookingCode;
    private LocalDateTime pickupDateTime;
    private LocalDateTime returnDateTime;
    private double totalAmount;
    private String status;
    private String rentalType;
    private LocalDateTime createdDate;
    
    // ========== THÔNG TIN KHÁCH HÀNG ==========
    private String customerName;
    private String customerPhone;
    private String customerEmail;
    private String customerAddress;
    
    // ========== THÔNG TIN XE (JOIN TỪ CAR) ==========
    private String carModel;        // Tên xe (VD: "Toyota Vios")
    private String carLicensePlate; // Biển số xe (VD: "51A-12345")
    private String carBrand;        // Thương hiệu xe
    private int carSeats;           // Số chỗ ngồi
    private double carPricePerDay;  // Giá thuê mỗi ngày
    
    // ========== THÔNG TIN ĐIỀU KHOẢN ==========
    private boolean termsAgreed;
    private LocalDateTime termsAgreedAt;
    private String termsVersion;
    
    // Constructor mặc định
    public BookingDepositDTO() {}
    
    // ========== GETTERS VÀ SETTERS ==========
    
    public UUID getBookingId() {
        return bookingId;
    }
    
    public void setBookingId(UUID bookingId) {
        this.bookingId = bookingId;
    }
    
    public String getBookingCode() {
        return bookingCode;
    }
    
    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }
    
    public LocalDateTime getPickupDateTime() {
        return pickupDateTime;
    }
    
    public void setPickupDateTime(LocalDateTime pickupDateTime) {
        this.pickupDateTime = pickupDateTime;
    }
    
    public LocalDateTime getReturnDateTime() {
        return returnDateTime;
    }
    
    public void setReturnDateTime(LocalDateTime returnDateTime) {
        this.returnDateTime = returnDateTime;
    }
    
    public double getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public String getRentalType() {
        return rentalType;
    }
    
    public void setRentalType(String rentalType) {
        this.rentalType = rentalType;
    }
    
    public LocalDateTime getCreatedDate() {
        return createdDate;
    }
    
    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }
    
    public String getCustomerName() {
        return customerName;
    }
    
    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }
    
    public String getCustomerPhone() {
        return customerPhone;
    }
    
    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }
    
    public String getCustomerEmail() {
        return customerEmail;
    }
    
    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }
    
    public String getCustomerAddress() {
        return customerAddress;
    }
    
    public void setCustomerAddress(String customerAddress) {
        this.customerAddress = customerAddress;
    }
    
    public String getCarModel() {
        return carModel;
    }
    
    public void setCarModel(String carModel) {
        this.carModel = carModel;
    }
    
    public String getCarLicensePlate() {
        return carLicensePlate;
    }
    
    public void setCarLicensePlate(String carLicensePlate) {
        this.carLicensePlate = carLicensePlate;
    }
    
    public String getCarBrand() {
        return carBrand;
    }
    
    public void setCarBrand(String carBrand) {
        this.carBrand = carBrand;
    }
    
    public int getCarSeats() {
        return carSeats;
    }
    
    public void setCarSeats(int carSeats) {
        this.carSeats = carSeats;
    }
    
    public double getCarPricePerDay() {
        return carPricePerDay;
    }
    
    public void setCarPricePerDay(double carPricePerDay) {
        this.carPricePerDay = carPricePerDay;
    }
    
    public boolean isTermsAgreed() {
        return termsAgreed;
    }
    
    public void setTermsAgreed(boolean termsAgreed) {
        this.termsAgreed = termsAgreed;
    }
    
    public LocalDateTime getTermsAgreedAt() {
        return termsAgreedAt;
    }
    
    public void setTermsAgreedAt(LocalDateTime termsAgreedAt) {
        this.termsAgreedAt = termsAgreedAt;
    }
    
    public String getTermsVersion() {
        return termsVersion;
    }
    
    public void setTermsVersion(String termsVersion) {
        this.termsVersion = termsVersion;
    }
    
    // ========== FORMATTED METHODS CHO JSP ==========
    
    /**
     * Trả về thời gian pickup đã format cho JSP
     */
    public String getFormattedPickupDateTime() {
        if (pickupDateTime == null) return "N/A";
        return pickupDateTime.format(DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"));
    }
    
    /**
     * Trả về thời gian return đã format cho JSP
     */
    public String getFormattedReturnDateTime() {
        if (returnDateTime == null) return "N/A";
        return returnDateTime.format(DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"));
    }
    
    /**
     * Trả về tổng tiền đã format cho JSP (VD: "1.063.567 VND")
     * Sử dụng PriceUtils để format giá từ DB
     */
    public String getFormattedTotalAmount() {
        return PriceUtils.formatDbPrice(totalAmount);
    }
    
    /**
     * Trả về giá xe theo ngày đã format
     */
    public String getFormattedCarPricePerDay() {
        return PriceUtils.formatDbPrice(carPricePerDay);
    }
    
    /**
     * Trả về tên xe đầy đủ (VD: "Toyota Vios - 51A-12345")
     */
    public String getFullCarName() {
        return String.format("%s - %s", 
            carModel != null ? carModel : "N/A", 
            carLicensePlate != null ? carLicensePlate : "N/A");
    }
    
    /**
     * Tính số tiền đặt cọc (30% tổng chi phí)
     * @return Số tiền đặt cọc
     */
    public double getDepositAmount() {
        return totalAmount * 0.3;
    }
    
    /**
     * Trả về số tiền đặt cọc đã format
     */
    public String getFormattedDepositAmount() {
        return PriceUtils.formatDbPrice(getDepositAmount());
    }
    
    /**
     * Tính số tiền còn lại phải thanh toán (70% tổng chi phí)
     * @return Số tiền còn lại
     */
    public double getRemainingAmount() {
        return totalAmount * 0.7;
    }
    
    /**
     * Trả về số tiền còn lại đã format
     */
    public String getFormattedRemainingAmount() {
        return PriceUtils.formatDbPrice(getRemainingAmount());
    }
    
    /**
     * Tính số ngày thuê
     */
    public long getRentalDays() {
        if (pickupDateTime == null || returnDateTime == null) return 0;
        return java.time.Duration.between(pickupDateTime, returnDateTime).toDays();
    }
    
    /**
     * Tính số giờ thuê
     */
    public long getRentalHours() {
        if (pickupDateTime == null || returnDateTime == null) return 0;
        return java.time.Duration.between(pickupDateTime, returnDateTime).toHours();
    }
    
    /**
     * Trả về description loại thuê
     */
    public String getRentalTypeDescription() {
        if (rentalType == null) return "N/A";
        switch (rentalType.toLowerCase()) {
            case "hourly": return "Theo giờ";
            case "daily": return "Theo ngày";
            case "monthly": return "Theo tháng";
            default: return rentalType;
        }
    }
    
    /**
     * Format thời gian thuê cho hiển thị - SỬ DỤNG LẠI DurationResult có sẵn
     * Tương thích với BookingService logic
     */
    public String getFormattedRentalDuration() {
        if (pickupDateTime == null || returnDateTime == null) return "N/A";
        
        try {
            // Tạo DurationResult như BookingService
            DurationResult duration = calculateDuration();
            
            // Format theo tiếng Việt
            String unit = duration.getUnitType();
            BigDecimal value = duration.getBillingUnits();
            
            switch (unit.toLowerCase()) {
                case "hours":
                case "hour":
                    return value + " hour(s)";
                case "days": 
                case "day":
                    return value + " day(s)";
                case "months":
                case "month":
                    return value + " month(s)";
                default:
                    return value + " " + unit;
            }
        } catch (Exception e) {
            // Fallback về cách cũ
            return getRentalDays() + " day(s)";
        }
    }
    
    /**
     * Tính duration theo logic của BookingService
     * Tương thích với DurationResult
     */
    private DurationResult calculateDuration() {
        if (pickupDateTime == null || returnDateTime == null) {
            return new DurationResult(BigDecimal.ONE, "days", null);
        }
        
        if ("hourly".equals(rentalType)) {
            long hours = getRentalHours();
            BigDecimal billingHours = BigDecimal.valueOf(Math.max(1, hours)); // Minimum 1 hour
            return new DurationResult(billingHours, "hours", null);
            
        } else if ("monthly".equals(rentalType)) {
            long days = getRentalDays();
            BigDecimal billingMonths = BigDecimal.valueOf(Math.max(1, days / 30)); // Minimum 1 month
            return new DurationResult(billingMonths, "months", null);
            
        } else { // daily (default)
            long days = getRentalDays();
            BigDecimal billingDays = BigDecimal.valueOf(Math.max(1, days)); // Minimum 1 day
            return new DurationResult(billingDays, "days", null);
        }
    }
} 