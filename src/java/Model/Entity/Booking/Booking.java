package Model.Entity.Booking;

import java.time.LocalDateTime;
import java.util.UUID;

public class Booking {

    private UUID bookingId;
    private UUID userId;
    private UUID carId;
    private UUID handledBy;
    private LocalDateTime pickupDateTime;
    private LocalDateTime returnDateTime;
    private double totalAmount;
    private String status;
    private UUID discountId;
    private LocalDateTime createdDate;
    private String cancelReason;
    private String bookingCode;
    private String expectedPaymentMethod;

    // *** THÊM FIELD MỚI CHO RENTAL TYPE ***
    private String rentalType; // Loại thuê: "hourly", "daily", "monthly"

    // Thông tin khách hàng được "đóng băng" tại thời điểm booking
    private String customerName; // Tên khách hàng tại thời điểm booking
    private String customerPhone; // Số điện thoại khách hàng tại thời điểm booking
    private String customerAddress; // Địa chỉ khách hàng tại thời điểm booking
    private String customerEmail; // Email khách hàng tại thời điểm booking
    private String driverLicenseImageUrl; // Ảnh bằng lái xe tại thời điểm booking

    // Thêm vào Booking.java
    private boolean isTermsAgreed = false;        // Đã đồng ý điều khoản chưa
    private LocalDateTime termsAgreedAt;          // Thời gian đồng ý điều khoản
    private String termsVersion = "v1.0";         // Phiên bản điều khoản

    public Booking() {
    }

    public Booking(UUID bookingId, UUID userId, UUID carId, UUID handledBy, LocalDateTime pickupDateTime, LocalDateTime returnDateTime, double totalAmount, String status, UUID discountId, LocalDateTime createdDate, String cancelReason, String bookingCode, String expectedPaymentMethod) {
        this.bookingId = bookingId;
        this.userId = userId;
        this.carId = carId;
        this.handledBy = handledBy;
        this.pickupDateTime = pickupDateTime;
        this.returnDateTime = returnDateTime;
        this.totalAmount = totalAmount;
        this.status = status;
        this.discountId = discountId;
        this.createdDate = createdDate;
        this.cancelReason = cancelReason;
        this.bookingCode = bookingCode;
        this.expectedPaymentMethod = expectedPaymentMethod;
    }

    // Terms Agreement
    public boolean isTermsAgreed() {
        return isTermsAgreed;
    }

    public void setTermsAgreed(boolean termsAgreed) {
        isTermsAgreed = termsAgreed;
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

    public UUID getBookingId() {
        return bookingId;
    }

    public void setBookingId(UUID bookingId) {
        this.bookingId = bookingId;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public UUID getCarId() {
        return carId;
    }

    public void setCarId(UUID carId) {
        this.carId = carId;
    }

    public UUID getHandledBy() {
        return handledBy;
    }

    public void setHandledBy(UUID handledBy) {
        this.handledBy = handledBy;
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

    public UUID getDiscountId() {
        return discountId;
    }

    public void setDiscountId(UUID discountId) {
        this.discountId = discountId;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public String getCancelReason() {
        return cancelReason;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }

    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    public String getExpectedPaymentMethod() {
        return expectedPaymentMethod;
    }

    public void setExpectedPaymentMethod(String expectedPaymentMethod) {
        this.expectedPaymentMethod = expectedPaymentMethod;
    }

    // *** GETTER VÀ SETTER CHO RENTAL TYPE MỚI ***
    public String getRentalType() {
        return rentalType;
    }

    public void setRentalType(String rentalType) {
        this.rentalType = rentalType;
    }

    // Getter & Setter cho các trường mới
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

    public String getCustomerAddress() {
        return customerAddress;
    }

    public void setCustomerAddress(String customerAddress) {
        this.customerAddress = customerAddress;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getDriverLicenseImageUrl() {
        return driverLicenseImageUrl;
    }

    public void setDriverLicenseImageUrl(String driverLicenseImageUrl) {
        this.driverLicenseImageUrl = driverLicenseImageUrl;
    }

    @Override
    public String toString() {
        return "Booking{"
                + "bookingId=" + bookingId
                + ", userId=" + userId
                + ", carId=" + carId
                + ", handledBy=" + handledBy
                + ", pickupDate=" + pickupDateTime
                + ", returnDate=" + returnDateTime
                + ", totalAmount=" + totalAmount
                + ", status='" + status + '\''
                + ", discountId=" + discountId
                + ", createdDate=" + createdDate
                + ", cancelReason='" + cancelReason + '\''
                + ", bookingCode='" + bookingCode + '\''
                + ", expectedPaymentMethod='" + expectedPaymentMethod + '\''
                + ", rentalType='" + rentalType + '\''
                + // *** THÊM VÀO toString() ***
                '}';
    }
}
