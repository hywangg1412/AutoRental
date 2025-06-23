package Model.Entity.Car;

import java.math.BigDecimal;
import java.util.Date;
import java.util.HashSet;
import java.util.Set;
import java.util.UUID;

public class Car {
    private UUID carId;
    private UUID brandId;
    private String carModel;
    private Integer yearManufactured;
    private UUID transmissionTypeId;
    private UUID fuelTypeId;
    private String licensePlate;
    private int seats;
    private int odometer;
    private BigDecimal pricePerHour;
    private BigDecimal pricePerDay;
    private BigDecimal pricePerMonth;
    private CarStatus status;
    private String description;
    private Date createdDate;
    private UUID categoryId;
    private UUID lastUpdatedBy;
    private Set<UUID> featureIds = new HashSet<>();

    public enum CarStatus {
        AVAILABLE("Available", "Available", "status-available"),
        RENTED("Rented", "Rented", "status-rented"),
        UNAVAILABLE("Unavailable", "Unavailable", "status-unavailable");

        private final String value;
        private final String displayValue;
        private final String cssClass;

        CarStatus(String value, String displayValue, String cssClass) {
            this.value = value;
            this.displayValue = displayValue;
            this.cssClass = cssClass;
        }

        public String getValue() {
            return value;
        }

        public String getDisplayValue() {
            return displayValue;
        }

        public String getCssClass() {
            return cssClass;
        }

        public static CarStatus fromDbValue(String value) {
            for (CarStatus status : CarStatus.values()) {
                if (status.getValue().equalsIgnoreCase(value)) {
                    return status;
                }
            }
            throw new IllegalArgumentException("No enum constant for value: " + value);
        }
    }

    public Car() {
        
    }

    public UUID getCarId() {
        return carId;
    }

    public void setCarId(UUID carId) {
        this.carId = carId;
    }

    public UUID getBrandId() {
        return brandId;
    }

    public void setBrandId(UUID brandId) {
        this.brandId = brandId;
    }

    public String getCarModel() {
        return carModel;
    }

    public void setCarModel(String carModel) {
        this.carModel = carModel;
    }

    public Integer getYearManufactured() {
        return yearManufactured;
    }

    public void setYearManufactured(Integer yearManufactured) {
        this.yearManufactured = yearManufactured;
    }

    public UUID getTransmissionTypeId() {
        return transmissionTypeId;
    }

    public void setTransmissionTypeId(UUID transmissionTypeId) {
        this.transmissionTypeId = transmissionTypeId;
    }

    public UUID getFuelTypeId() {
        return fuelTypeId;
    }

    public void setFuelTypeId(UUID fuelTypeId) {
        this.fuelTypeId = fuelTypeId;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public int getSeats() {
        return seats;
    }

    public void setSeats(int seats) {
        this.seats = seats;
    }

    public int getOdometer() {
        return odometer;
    }

    public void setOdometer(int odometer) {
        this.odometer = odometer;
    }

    public BigDecimal getPricePerHour() {
        return pricePerHour;
    }

    public void setPricePerHour(BigDecimal pricePerHour) {
        this.pricePerHour = pricePerHour;
    }

    public BigDecimal getPricePerDay() {
        return pricePerDay;
    }

    public void setPricePerDay(BigDecimal pricePerDay) {
        this.pricePerDay = pricePerDay;
    }

    public BigDecimal getPricePerMonth() {
        return pricePerMonth;
    }

    public void setPricePerMonth(BigDecimal pricePerMonth) {
        this.pricePerMonth = pricePerMonth;
    }

    public CarStatus getStatus() {
        return status;
    }

    public void setStatus(CarStatus status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public UUID getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(UUID categoryId) {
        this.categoryId = categoryId;
    }

    public UUID getLastUpdatedBy() {
        return lastUpdatedBy;
    }

    public void setLastUpdatedBy(UUID lastUpdatedBy) {
        this.lastUpdatedBy = lastUpdatedBy;
    }

    public Set<UUID> getFeatureIds() {
        return new HashSet<>(featureIds);
    }

    public void setFeatureIds(Set<UUID> featureIds) {
        this.featureIds = new HashSet<>(featureIds);
    }

    public void addFeatureId(UUID featureId) {
        this.featureIds.add(featureId);
    }

    public void removeFeatureId(UUID featureId) {
        this.featureIds.remove(featureId);
    }

    public boolean hasFeature(UUID featureId) {
        return this.featureIds.contains(featureId);
    }

    public boolean isAvailable() {
        return status == CarStatus.AVAILABLE;
    }

    public boolean isRented() {
        return status == CarStatus.RENTED;
    }

    public boolean isUnavailable() {
        return status == CarStatus.UNAVAILABLE;
    }

    public void markAsRented() {
        this.status = CarStatus.RENTED;
    }

    public void markAsAvailable() {
        this.status = CarStatus.AVAILABLE;
    }

    public void markAsUnavailable() {
        this.status = CarStatus.UNAVAILABLE;
    }

    @Override
    public String toString() {
        return "Car{" +
                "carId=" + carId +
                ", brandId=" + brandId +
                ", carModel='" + carModel + '\'' +
                ", yearManufactured=" + yearManufactured +
                ", transmissionTypeId=" + transmissionTypeId +
                ", fuelTypeId=" + fuelTypeId +
                ", licensePlate='" + licensePlate + '\'' +
                ", seats=" + seats +
                ", odometer=" + odometer +
                ", pricePerHour=" + pricePerHour +
                ", pricePerDay=" + pricePerDay +
                ", pricePerMonth=" + pricePerMonth +
                ", status='" + status.getValue() + '\'' +
                ", description='" + description + '\'' +
                ", createdDate=" + createdDate +
                ", categoryId=" + categoryId +
                ", lastUpdatedBy=" + lastUpdatedBy +
                ", featureIds=" + featureIds +
                '}';
    }
}
