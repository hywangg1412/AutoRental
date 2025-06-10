package Model.Entity.Car;

import java.util.UUID;
import java.util.logging.Logger;

public class CarFeaturesMapping {
    private UUID carId;
    private UUID featureId;

    public CarFeaturesMapping(UUID carId, UUID featureId) {
        this.carId = carId;
        this.featureId = featureId;
    }

    public CarFeaturesMapping() {
    }

    public UUID getCarId() {
        return carId;
    }

    public void setCarId(UUID carId) {
        this.carId = carId;
    }

    public UUID getFeatureId() {
        return featureId;
    }

    public void setFeatureId(UUID featureId) {
        this.featureId = featureId;
    }

    @Override
    public String toString() {
        return "CarFeaturesMapping{" + "carId=" + carId + ", featureId=" + featureId + '}';
    }
}
