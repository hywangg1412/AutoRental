package Model.Entity.Car;

import java.util.UUID;

public class CarFeature {
    private UUID featureId;
    private String featureName;

    public CarFeature(UUID featureId, String fetureName) {
        this.featureId = featureId;
        this.featureName = fetureName;
    }

    public CarFeature() {
    }

    public UUID getFeatureId() {
        return featureId;
    }

    public void setFeatureId(UUID featureId) {
        this.featureId = featureId;
    }

    public String getFeatureName() {
        return featureName;
    }

    public void setFeatureName(String fetureName) {
        this.featureName = fetureName;
    }

    @Override
    public String toString() {
        return "CarFeature{" + "featureId=" + featureId + ", fetureName=" + featureName + '}';
    }
    
    
}
