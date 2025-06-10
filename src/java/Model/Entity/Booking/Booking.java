package Model.Entity.Booking;

import java.util.Date;
import java.util.UUID;
import java.time.LocalDateTime;

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

    

    @Override
    public String toString() {
        return "Booking{" +
                "bookingId=" + bookingId +
                ", userId=" + userId +
                ", carId=" + carId +
                ", handledBy=" + handledBy +
                ", pickupDate=" + pickupDateTime +
                ", returnDate=" + returnDateTime +
                ", totalAmount=" + totalAmount +
                ", status='" + status + '\'' +
                ", discountId=" + discountId +
                ", createdDate=" + createdDate +
                ", cancelReason='" + cancelReason + '\'' +
                ", bookingCode='" + bookingCode + '\'' +
                ", expectedPaymentMethod='" + expectedPaymentMethod + '\'' +
                '}';
    }
}
