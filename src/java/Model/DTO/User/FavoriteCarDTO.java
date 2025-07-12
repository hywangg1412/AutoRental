package Model.DTO.User;

import java.math.BigDecimal;
import java.util.UUID;

public class FavoriteCarDTO {
    private UUID carId;
    private String carModel;
    private String brandName;
    private String mainImageUrl;
    private String transmissionName;
    private Integer seats;
    private String fuelTypeName;
    private BigDecimal pricePerDay;
    private String status;
    private String statusDisplay;

    // Constructors
    public FavoriteCarDTO() {
    }

    public FavoriteCarDTO(UUID carId, String carModel, String brandName, String mainImageUrl, String transmissionName, Integer seats, String fuelTypeName, BigDecimal pricePerDay, String status, String statusDisplay) {
        this.carId = carId;
        this.carModel = carModel;
        this.brandName = brandName;
        this.mainImageUrl = mainImageUrl;
        this.transmissionName = transmissionName;
        this.seats = seats;
        this.fuelTypeName = fuelTypeName;
        this.pricePerDay = pricePerDay;
        this.status = status;
        this.statusDisplay = statusDisplay;
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

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    public String getMainImageUrl() {
        return mainImageUrl;
    }

    public void setMainImageUrl(String mainImageUrl) {
        this.mainImageUrl = mainImageUrl;
    }

    public String getTransmissionName() {
        return transmissionName;
    }

    public void setTransmissionName(String transmissionName) {
        this.transmissionName = transmissionName;
    }

    public Integer getSeats() {
        return seats;
    }

    public void setSeats(Integer seats) {
        this.seats = seats;
    }

    public String getFuelTypeName() {
        return fuelTypeName;
    }

    public void setFuelTypeName(String fuelTypeName) {
        this.fuelTypeName = fuelTypeName;
    }

    public BigDecimal getPricePerDay() {
        return pricePerDay;
    }

    public void setPricePerDay(BigDecimal pricePerDay) {
        this.pricePerDay = pricePerDay;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getStatusDisplay() {
        return statusDisplay;
    }

    public void setStatusDisplay(String statusDisplay) {
        this.statusDisplay = statusDisplay;
    }
} 