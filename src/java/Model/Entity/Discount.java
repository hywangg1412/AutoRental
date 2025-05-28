package Model;

import java.util.Date;

public class Discount {
    private int discountId;
    private Date startDate;
    private Date endDate;
    private boolean isActive;
    private String type;

    public Discount() {
    }

    public int getDiscountId() {
        return discountId;
    }

    public void setDiscountId(int discountId) {
        this.discountId = discountId;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    @Override
    public String toString() {
        return "Discount{" + "discountId=" + discountId + ", startDate=" + startDate + ", endDate=" + endDate + ", isActive=" + isActive + ", type=" + type + '}';
    }
    
}
