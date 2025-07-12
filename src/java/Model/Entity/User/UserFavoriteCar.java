package Model.Entity.User;

import java.util.UUID;

public class UserFavoriteCar {
    private UUID userId;
    private UUID carId;

    public UserFavoriteCar() {
    }

    public UserFavoriteCar(UUID userId, UUID carId) {
        this.userId = userId;
        this.carId = carId;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public UUID getCarId() {
        return carId;
    }

    public void setCarId(UUID carId) {
        this.carId = carId;
    }

    @Override
    public String toString() {
        return "UserFavoriteCar{" + "userId=" + userId + ", carId=" + carId + '}';
    }
    
}
