package Model.Entity.Car;

import java.util.UUID;

public class FuelType {
    private UUID fuelTypeId;
    private String fuelName;

    public FuelType() {
    }

    public FuelType(UUID fuelTypeId, String fuelName) {
        this.fuelTypeId = fuelTypeId;
        this.fuelName = fuelName;
    }

    public UUID getFuelTypeId() {
        return fuelTypeId;
    }

    public void setFuelTypeId(UUID fuelTypeId) {
        this.fuelTypeId = fuelTypeId;
    }

    public String getFuelName() {
        return fuelName;
    }

    public void setFuelName(String fuelName) {
        this.fuelName = fuelName;
    }

    @Override
    public String toString() {
        return "FuelType{" + "fuelTypeId=" + fuelTypeId + ", fuelName=" + fuelName + '}';
    }
    
}
