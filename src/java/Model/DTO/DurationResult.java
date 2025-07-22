package Model.DTO;

import java.math.BigDecimal;

/**
 * DTO chứa kết quả tính duration cho booking
 * Được sử dụng bởi BookingService để trả về thông tin duration đã tính toán
 */
public class DurationResult {
    
    private final BigDecimal billingUnits;
    private final String unitType;
    private String note;
    private String originalRentalType;
    private String adjustedRentalType;
    private String formattedDuration; // Thêm trường mới để lưu duration đã format (vd: "4 days 21 hours")

    public DurationResult(BigDecimal billingUnits, String unitType, String note) {
        this.billingUnits = billingUnits;
        this.unitType = unitType;
        this.note = note;
        this.originalRentalType = null;
        this.adjustedRentalType = null;
        this.formattedDuration = null;
    }

    // Getters
    public BigDecimal getBillingUnits() {
        return billingUnits;
    }

    public String getUnitType() {
        return unitType;
    }

    public String getNote() {
        return note;
    }
    
    // Setter for note (để có thể cập nhật ghi chú sau khi tạo đối tượng)
    public void setNote(String note) {
        this.note = note;
    }
    
    public String getOriginalRentalType() {
        return originalRentalType;
    }
    
    public void setOriginalRentalType(String originalRentalType) {
        this.originalRentalType = originalRentalType;
    }
    
    public String getAdjustedRentalType() {
        return adjustedRentalType;
    }
    
    public void setAdjustedRentalType(String adjustedRentalType) {
        this.adjustedRentalType = adjustedRentalType;
    }
    
    public String getFormattedDuration() {
        return formattedDuration;
    }
    
    public void setFormattedDuration(String formattedDuration) {
        this.formattedDuration = formattedDuration;
    }
    
    public boolean hasRentalTypeAdjusted() {
        return originalRentalType != null && adjustedRentalType != null && 
               !originalRentalType.equalsIgnoreCase(adjustedRentalType);
    }

    public boolean hasMinimumApplied() {
        return note != null;
    }

    /**
     * Convert BigDecimal sang double để tương thích với các tính toán khác
     * @return billing units dạng double
     */
    public double getBillingUnitsAsDouble() {
        return billingUnits.doubleValue();
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(String.format("Duration: %s %s", billingUnits, unitType));
        
        if (formattedDuration != null) {
            sb.append(String.format(" (%s)", formattedDuration));
        }
        
        if (hasRentalTypeAdjusted()) {
            sb.append(String.format(" (adjusted from %s to %s)", originalRentalType, adjustedRentalType));
        }
        
        if (note != null) {
            sb.append(" (").append(note).append(")");
        }
        
        return sb.toString();
    }
} 