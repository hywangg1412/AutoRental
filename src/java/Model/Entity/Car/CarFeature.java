package Model.Entity.Car;

import java.util.UUID;

public class CarFeature {
    private UUID featureId;
    private String fetureName;

    public CarFeature(UUID featureId, String fetureName) {
        this.featureId = featureId;
        this.fetureName = fetureName;
    }

    public CarFeature() {
    }

    public UUID getFeatureId() {
        return featureId;
    }

    public void setFeatureId(UUID featureId) {
        this.featureId = featureId;
    }

    public String getFetureName() {
        return fetureName;
    }

    public void setFetureName(String fetureName) {
        this.fetureName = fetureName;
    }

    @Override
    public String toString() {
        return "CarFeature{" + "featureId=" + featureId + ", fetureName=" + fetureName + '}';
    }
    
    
}
