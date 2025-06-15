package Model.Entity.Car;

import java.util.UUID;

public class CarImage {
    private UUID imageId;
    private UUID carId;
    private String imageUrl;
    private boolean isMain;

    public CarImage() {}

    public CarImage(UUID imageId, UUID carId, String imageUrl, boolean isMain) {
        this.imageId = imageId;
        this.carId = carId;
        this.imageUrl = imageUrl;
        this.isMain = isMain;
    }

    public UUID getImageId() {
        return imageId;
    }

    public void setImageId(UUID imageId) {
        this.imageId = imageId;
    }

    public UUID getCarId() {
        return carId;
    }

    public void setCarId(UUID carId) {
        this.carId = carId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isMain() {
        return isMain;
    }

    public void setIsMain(boolean isMain) {
        this.isMain = isMain;
    }

    @Override
    public String toString() {
        return "CarImage{" +
                "imageId=" + imageId +
                ", carId=" + carId +
                ", imageUrl='" + imageUrl + '\'' +
                ", isMain=" + isMain +
                '}';
    }
}
