package Model.DTO;

import java.time.LocalDateTime;
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
    private String pickupDateTime;
    private String returnDateTime;
    private double totalAmount;

    //Customer (User)
    private String customerName;
    private String customerEmail;

    //(Car)
    private String carModel;
    private String licensePlate;

    // Getter, Setter, Constructor...

    public BookingRequestDTO() {
    }

    public BookingRequestDTO(UUID approvalId, String approvalStatus, LocalDateTime approvalDate, String note, String rejectionReason, UUID bookingId, String pickupDateTime, String returnDateTime, double totalAmount, String customerName, String customerEmail, String carModel, String licensePlate) {
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
        this.licensePlate = licensePlate;
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
        if (this.bookingCode == null && bookingId != null) {
            String s = bookingId.toString().replace("-", "");
            this.bookingCode = "BK" + s.substring(0, 6).toUpperCase();
        }
    }
    
    public String getPickupDateTime() {
        return pickupDateTime;
    }

    public void setPickupDateTime(String pickupDateTime) {
        this.pickupDateTime = pickupDateTime;
    }

    public String getReturnDateTime() {
        return returnDateTime;
    }

    public void setReturnDateTime(String returnDateTime) {
        this.returnDateTime = returnDateTime;
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

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    @Override
    public String toString() {
        return "BookingApprovalDTO{" + "approvalId=" + approvalId + ", approvalStatus=" + approvalStatus + ", approvalDate=" + approvalDate + ", note=" + note + ", rejectionReason=" + rejectionReason + ", bookingId=" + bookingId + ", pickupDateTime=" + pickupDateTime + ", returnDateTime=" + returnDateTime + ", totalAmount=" + totalAmount + ", customerName=" + customerName + ", customerEmail=" + customerEmail + ", carModel=" + carModel + ", licensePlate=" + licensePlate + '}';
    }
    
}
