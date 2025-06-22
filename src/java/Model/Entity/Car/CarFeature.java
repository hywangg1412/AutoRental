package Model.Entity.Car;

import java.util.UUID;

public class CarFeature {
    private UUID featureId;
    private String featureName;

    public CarFeature(UUID featureId, String featureName) {
        this.featureId = featureId;
        this.featureName = featureName;
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

    public void setFeatureName(String featureName) {
        this.featureName = featureName;
    }

    @Override
    public String toString() {
        return "CarFeature{" + "featureId=" + featureId + ", featureName=" + featureName + '}';
    }
    
    
}
