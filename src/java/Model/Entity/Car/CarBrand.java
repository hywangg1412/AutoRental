package Model.Entity.Car;

import java.util.UUID;

public class CarBrand {

    private UUID brandId;
    private String brandName;

    public CarBrand() {
    }

    public CarBrand(UUID brandId, String brandName) {
        this.brandId = brandId;
        this.brandName = brandName;
    }

    public UUID getBrandId() {
        return brandId;
    }

    public void setBrandId(UUID brandId) {
        this.brandId = brandId;
    }

    public String getBrandName() {
        return brandName;
    }

    public void setBrandName(String brandName) {
        this.brandName = brandName;
    }

    @Override
    public String toString() {
        return "CarBrand{" + "brandId=" + brandId + ", brandName=" + brandName + '}';
    }
}
