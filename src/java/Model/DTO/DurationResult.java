package Model.DTO;

import java.math.BigDecimal;

/**
 * DTO chứa kết quả tính duration cho booking
 * Được sử dụng bởi BookingService để trả về thông tin duration đã tính toán
 */
public class DurationResult {
    
    private final BigDecimal billingUnits;
    private final String unitType;
    private final String note;

    public DurationResult(BigDecimal billingUnits, String unitType, String note) {
        this.billingUnits = billingUnits;
        this.unitType = unitType;
        this.note = note;
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
        return String.format("Duration: %s %s%s",
                billingUnits, unitType, note != null ? " (" + note + ")" : "");
    }
} 