package Model.DTO;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * Data Transfer Object for displaying comprehensive booking information on the staff interface.
 * This object aggregates data from Booking, User, Car, and DriverLicense entities.
 */
public class BookingInfoDTO {

    // Booking Information
    private UUID bookingId;
    private String bookingCode; // Friendly booking code like "BK-20240621-XYZ12"
    private LocalDateTime pickupDateTime;
    private LocalDateTime returnDateTime;
    private double totalAmount;
    private String status;
    private LocalDateTime createdDate;
    private long duration;

    // User (Customer) Information
    private String customerName;
    private String customerEmail;
    private String customerPhone;

    // Car Information
    private String carModel;
    private String carLicensePlate; // Biển số xe
    private String carStatus;

    // Driver License Information
    private String driverLicenseImageUrl;

    // Status Information for Modal
    private String depositStatus;
    private String contractStatus;

    // --- Thêm các trường từ BookingDTO ---
    private String carImage;
    private java.math.BigDecimal pricePerDay;
    private String cancelReason;
    // Để đồng bộ với BookingDTO
    private String fullName; // alias cho customerName
    private String email;    // alias cho customerEmail
    private String phoneNumber; // alias cho customerPhone

    // Constructors
    public BookingInfoDTO() {
    }

    // --- Start of Getters and Setters ---

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
    
    // --- NEW FORMATTING METHODS ---
    public String getFormattedPickupDateTime() {
        if (pickupDateTime == null) {
            return "";
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy, hh:mm a");
        return pickupDateTime.format(formatter);
    }

    public String getFormattedReturnDateTime() {
        if (returnDateTime == null) {
            return "";
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy, hh:mm a");
        return returnDateTime.format(formatter);
    }
    // --- END OF NEW METHODS ---

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

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    public long getDuration() {
        return duration;
    }

    public void setDuration(long duration) {
        this.duration = duration;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
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

    public String getCarStatus() {
        return carStatus;
    }

    public void setCarStatus(String carStatus) {
        this.carStatus = carStatus;
    }

    public String getDriverLicenseImageUrl() {
        return driverLicenseImageUrl;
    }

    public void setDriverLicenseImageUrl(String driverLicenseImageUrl) {
        this.driverLicenseImageUrl = driverLicenseImageUrl;
    }

    public String getDepositStatus() {
        return depositStatus;
    }

    public void setDepositStatus(String depositStatus) {
        this.depositStatus = depositStatus;
    }

    public String getContractStatus() {
        return contractStatus;
    }

    public void setContractStatus(String contractStatus) {
        this.contractStatus = contractStatus;
    }

    // Getter/Setter cho các trường mới
    public String getCarImage() { return carImage; }
    public void setCarImage(String carImage) { this.carImage = carImage; }
    public java.math.BigDecimal getPricePerDay() { return pricePerDay; }
    public void setPricePerDay(java.math.BigDecimal pricePerDay) { this.pricePerDay = pricePerDay; }
    public String getCancelReason() { return cancelReason; }
    public void setCancelReason(String cancelReason) { this.cancelReason = cancelReason; }
    public String getFullName() { return fullName != null ? fullName : customerName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getEmail() { return email != null ? email : customerEmail; }
    public void setEmail(String email) { this.email = email; }
    public String getPhoneNumber() { return phoneNumber != null ? phoneNumber : customerPhone; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    // --- End of Getters and Setters ---

    @Override
    public String toString() {
        return "BookingInfoDTO{" +
                "bookingId=" + bookingId +
                ", bookingCode='" + bookingCode + '\'' +
                ", pickupDateTime=" + pickupDateTime +
                ", returnDateTime=" + returnDateTime +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                ", customerName='" + customerName + '\'' +
                ", carModel='" + carModel + '\'' +
                ", driverLicenseImageUrl='" + driverLicenseImageUrl + '\'' +
                '}';
    }
}