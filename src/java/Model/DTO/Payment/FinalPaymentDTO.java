package Model.DTO.Payment;

import Model.Entity.Booking.BookingSurcharges;
import Utils.PriceUtils;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

/**
 * DTO for the remaining payment page after car inspection
 */
public class FinalPaymentDTO {

    // Booking Information
    private UUID bookingId;
    private String bookingCode;
    private String customerName;
    private String customerPhone;
    private String customerEmail;
    private LocalDateTime pickupDateTime;
    private LocalDateTime returnDateTime;
    private LocalDateTime actualReturnDateTime;

    // Car Information
    private UUID carId;
    private String carModel;
    private String carLicensePlate;
    private String carBrand;

    // Payment Information
    private double totalAmount; // Total original amount (including VAT, insurance)
    private double depositAmount; // Deposit amount already paid
    private double remainingAmount; // Remaining amount (70% of total)
    private double totalSurcharges; // Total surcharges
    private double finalAmount; // Final amount to be paid (remaining + surcharges)

    // Surcharges List
    private List<BookingSurcharges> surcharges;

    // Inspection Information
    private LocalDateTime inspectionDate;
    private String inspectionNote;
    private String conditionStatus;

    // Constructor
    public FinalPaymentDTO() {
    }

    // Getters and Setters
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

    public LocalDateTime getActualReturnDateTime() {
        return actualReturnDateTime;
    }

    public void setActualReturnDateTime(LocalDateTime actualReturnDateTime) {
        this.actualReturnDateTime = actualReturnDateTime;
    }

    public UUID getCarId() {
        return carId;
    }

    public void setCarId(UUID carId) {
        this.carId = carId;
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

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public double getDepositAmount() {
        return depositAmount;
    }

    public void setDepositAmount(double depositAmount) {
        this.depositAmount = depositAmount;
    }

    public double getRemainingAmount() {
        return remainingAmount;
    }

    public void setRemainingAmount(double remainingAmount) {
        this.remainingAmount = remainingAmount;
    }

    public double getTotalSurcharges() {
        return totalSurcharges;
    }

    public void setTotalSurcharges(double totalSurcharges) {
        this.totalSurcharges = totalSurcharges;
    }

    public double getFinalAmount() {
        return finalAmount;
    }

    public void setFinalAmount(double finalAmount) {
        this.finalAmount = finalAmount;
    }

    public List<BookingSurcharges> getSurcharges() {
        return surcharges;
    }

    public void setSurcharges(List<BookingSurcharges> surcharges) {
        this.surcharges = surcharges;
    }

    public LocalDateTime getInspectionDate() {
        return inspectionDate;
    }

    public void setInspectionDate(LocalDateTime inspectionDate) {
        this.inspectionDate = inspectionDate;
    }

    public String getInspectionNote() {
        return inspectionNote;
    }

    public void setInspectionNote(String inspectionNote) {
        this.inspectionNote = inspectionNote;
    }

    public String getConditionStatus() {
        return conditionStatus;
    }

    public void setConditionStatus(String conditionStatus) {
        this.conditionStatus = conditionStatus;
    }

    // Formatted Methods for JSP
    public String getFormattedPickupDateTime() {
        if (pickupDateTime == null) {
            return "N/A";
        }
        return pickupDateTime.format(DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"));
    }

    public String getFormattedReturnDateTime() {
        if (returnDateTime == null) {
            return "N/A";
        }
        return returnDateTime.format(DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"));
    }

    public String getFormattedActualReturnDateTime() {
        if (actualReturnDateTime == null) {
            return "N/A";
        }
        return actualReturnDateTime.format(DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"));
    }

    public String getFormattedInspectionDate() {
        if (inspectionDate == null) {
            return "N/A";
        }
        return inspectionDate.format(DateTimeFormatter.ofPattern("MMM dd, yyyy HH:mm"));
    }

    public String getFormattedTotalAmount() {
        return PriceUtils.formatDbPrice(totalAmount);
    }

    public String getFormattedDepositAmount() {
        return PriceUtils.formatDbPrice(depositAmount);
    }

    public String getFormattedRemainingAmount() {
        return PriceUtils.formatDbPrice(remainingAmount);
    }

    public String getFormattedTotalSurcharges() {
        return PriceUtils.formatDbPrice(totalSurcharges);
    }

    public String getFormattedFinalAmount() {
        return PriceUtils.formatDbPrice(finalAmount);
    }

    public String getFullCarName() {
        return String.format("%s - %s",
                carModel != null ? carModel : "N/A",
                carLicensePlate != null ? carLicensePlate : "N/A");
    }

    /**
     * Check if there are any surcharges
     */
    public boolean hasSurcharges() {
        return surcharges != null && !surcharges.isEmpty() && totalSurcharges > 0;
    }

    /**
     * Calculate final amount
     */
    public void calculateFinalAmount() {
        this.finalAmount = this.remainingAmount + this.totalSurcharges;
    }
}
