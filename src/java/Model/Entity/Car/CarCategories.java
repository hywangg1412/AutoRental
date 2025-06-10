
package Model.Entity.Car;

import java.util.UUID;

public class CarCategories {
    private UUID categoryId;
    private String categoryName;
    
    public CarCategories() {
    }

    public CarCategories(UUID categoryId, String categoryName) {
        this.categoryId = categoryId;
        this.categoryName = categoryName;
    }

    public UUID getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(UUID categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

   
    
}
