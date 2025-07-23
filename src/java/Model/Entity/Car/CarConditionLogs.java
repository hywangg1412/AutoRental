package Model.Entity.Car;

import java.time.LocalDateTime;
import java.util.UUID;

public class CarConditionLogs {
    private UUID logId;
    private UUID bookingId;
    private UUID carId;
    private UUID staffId;
    private String checkType; // 'Pickup', 'Return'
    private LocalDateTime checkTime;
    private Integer odometer;
    private String fuelLevel;
    private String conditionStatus; // 'Good', 'Need Maintenance', 'Damaged', etc.
    private String conditionDescription;
    private String damageImages; // JSON array of image URLs
    private String note;

    public CarConditionLogs() {
    }

    public CarConditionLogs(UUID logId, UUID bookingId, UUID carId, UUID staffId, String checkType, 
                           LocalDateTime checkTime, Integer odometer, String fuelLevel, 
                           String conditionStatus, String conditionDescription, 
                           String damageImages, String note) {
        this.logId = logId;
        this.bookingId = bookingId;
        this.carId = carId;
        this.staffId = staffId;
        this.checkType = checkType;
        this.checkTime = checkTime;
        this.odometer = odometer;
        this.fuelLevel = fuelLevel;
        this.conditionStatus = conditionStatus;
        this.conditionDescription = conditionDescription;
        this.damageImages = damageImages;
        this.note = note;
    }

    public UUID getLogId() {
        return logId;
    }

    public void setLogId(UUID logId) {
        this.logId = logId;
    }

    public UUID getBookingId() {
        return bookingId;
    }

    public void setBookingId(UUID bookingId) {
        this.bookingId = bookingId;
    }

    public UUID getCarId() {
        return carId;
    }

    public void setCarId(UUID carId) {
        this.carId = carId;
    }

    public UUID getStaffId() {
        return staffId;
    }

    public void setStaffId(UUID staffId) {
        this.staffId = staffId;
    }

    public String getCheckType() {
        return checkType;
    }

    public void setCheckType(String checkType) {
        this.checkType = checkType;
    }

    public LocalDateTime getCheckTime() {
        return checkTime;
    }

    public void setCheckTime(LocalDateTime checkTime) {
        this.checkTime = checkTime;
    }

    public Integer getOdometer() {
        return odometer;
    }

    public void setOdometer(Integer odometer) {
        this.odometer = odometer;
    }

    public String getFuelLevel() {
        return fuelLevel;
    }

    public void setFuelLevel(String fuelLevel) {
        this.fuelLevel = fuelLevel;
    }

    public String getConditionStatus() {
        return conditionStatus;
    }

    public void setConditionStatus(String conditionStatus) {
        this.conditionStatus = conditionStatus;
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
}
