package Model.DTO;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

public class BookingRequestDTO {

    private UUID approvalId;
    private String approvalStatus;
    private LocalDateTime approvalDate;
    private String note;
    private String rejectionReason;

    // Booking
    private String bookingCode;
    private UUID bookingId;
    private LocalDateTime pickupDateTime;
    private LocalDateTime returnDateTime;
    private double totalAmount;
    private String status;

    //Customer (User)
    private String customerName;
    private String customerEmail;
    private String customerPhone;

    //(Car)
    private String carModel;
    private String carLicensePlate;
    private String driverLicenseImageUrl;


    // Getter, Setter, Constructor...

    public BookingRequestDTO() {
    }
    
    // This constructor might need updates based on where it's used
    public BookingRequestDTO(UUID approvalId, String approvalStatus, LocalDateTime approvalDate, String note, String rejectionReason, UUID bookingId, LocalDateTime pickupDateTime, LocalDateTime returnDateTime, double totalAmount, String customerName, String customerEmail, String carModel, String licensePlate) {
        this.approvalId = approvalId;
        this.approvalStatus = approvalStatus;
        this.approvalDate = approvalDate;
        this.note = note;
        this.rejectionReason = rejectionReason;
        this.bookingId = bookingId;
        this.pickupDateTime = pickupDateTime;
        this.returnDateTime = returnDateTime;
        this.totalAmount = totalAmount;
        this.customerName = customerName;
        this.customerEmail = customerEmail;
        this.carModel = carModel;
        this.carLicensePlate = licensePlate;
    }

    public UUID getApprovalId() {
        return approvalId;
    }

    public void setApprovalId(UUID approvalId) {
        this.approvalId = approvalId;
    }

    public String getApprovalStatus() {
        return approvalStatus;
    }

    public void setApprovalStatus(String approvalStatus) {
        this.approvalStatus = approvalStatus;
    }

    public LocalDateTime getApprovalDate() {
        return approvalDate;
    }

    public void setApprovalDate(LocalDateTime approvalDate) {
        this.approvalDate = approvalDate;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getRejectionReason() {
        return rejectionReason;
    }

    public void setRejectionReason(String rejectionReason) {
        this.rejectionReason = rejectionReason;
    }

    public UUID getBookingId() {
        return bookingId;
    }

    public void setBookingId(UUID bookingId) {
        this.bookingId = bookingId;
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

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
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

    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    public String getDriverLicenseImageUrl() {
        return driverLicenseImageUrl;
    }

    public void setDriverLicenseImageUrl(String driverLicenseImageUrl) {
        this.driverLicenseImageUrl = driverLicenseImageUrl;
    }
}