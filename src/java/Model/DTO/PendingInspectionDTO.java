// Data Transfer Object for pending inspections
package Model.DTO;

import java.util.UUID;
import java.time.LocalDateTime;

public class PendingInspectionDTO {

    private UUID bookingId;
    private String bookingCode;
    private UUID carId;
    private String carModel;
    private String licensePlate;
    private String customerName;
    private LocalDateTime returnDateTime;
    private String status;
    private String previousCondition = "Good"; // Default value
    private String checkType;
    private String conditionStatus;
    private String fuelLevel;
    private String conditionDescription;
    private String damageImages;
    private String note;
    private LocalDateTime checkTime;
    private UUID logId;
    private Integer odometer;

    // Getters and setters
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

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public LocalDateTime getReturnDateTime() {
        return returnDateTime;
    }

    public void setReturnDateTime(LocalDateTime returnDateTime) {
        this.returnDateTime = returnDateTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getPreviousCondition() {
        return previousCondition;
    }

    public void setPreviousCondition(String previousCondition) {
        this.previousCondition = previousCondition;
    }

    public String getCheckType() {
        return checkType;
    }

    public void setCheckType(String checkType) {
        this.checkType = checkType;
    }

    public String getConditionStatus() {
        return conditionStatus;
    }

    public void setConditionStatus(String conditionStatus) {
        this.conditionStatus = conditionStatus;
    }

    public String getFuelLevel() {
        return fuelLevel;
    }

    public void setFuelLevel(String fuelLevel) {
        this.fuelLevel = fuelLevel;
    }

    public String getConditionDescription() {
        return conditionDescription;
    }

    public void setConditionDescription(String conditionDescription) {
        this.conditionDescription = conditionDescription;
    }

    public String getDamageImages() {
        return damageImages;
    }

    public void setDamageImages(String damageImages) {
        this.damageImages = damageImages;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public LocalDateTime getCheckTime() {
        return checkTime;
    }
    public void setCheckTime(LocalDateTime checkTime) {
        this.checkTime = checkTime;
    }

    public UUID getLogId() {
        return logId;
    }
    public void setLogId(UUID logId) {
        this.logId = logId;
    }

    public Integer getOdometer() {
        return odometer;
    }
    public void setOdometer(Integer odometer) {
        this.odometer = odometer;
    }
}
