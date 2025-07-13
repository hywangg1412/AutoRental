/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.Entity.Deposit;

/**
 *
 * @author admin
 */
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Model Insurance - sử dụng double để khớp với Booking model Logic tính toán
 * bảo hiểm sẽ được xử lý ở Service layer
 */
public class Insurance {

    private UUID insuranceId;
    private String insuranceName;
    private String insuranceType;        // "TNDS", "VatChat", "TaiNan"
    private double baseRatePerDay;       // Phí cố định/ngày (VND) - DÙNG DOUBLE
    private double percentageRate;       // Phí theo % giá xe - DÙNG DOUBLE
    private double coverageAmount;       // Số tiền bảo hiểm tối đa - DÙNG DOUBLE
    private String applicableCarSeats;   // "1-5", "6-11", "12+"
    private String description;
    private boolean isActive;
    private LocalDateTime createdDate;

    // Constructors
    public Insurance() {
    }

    public Insurance(UUID insuranceId, String insuranceName, String insuranceType,
            double baseRatePerDay, double percentageRate,
            double coverageAmount, String applicableCarSeats,
            String description, boolean isActive, LocalDateTime createdDate) {
        this.insuranceId = insuranceId;
        this.insuranceName = insuranceName;
        this.insuranceType = insuranceType;
        this.baseRatePerDay = baseRatePerDay;
        this.percentageRate = percentageRate;
        this.coverageAmount = coverageAmount;
        this.applicableCarSeats = applicableCarSeats;
        this.description = description;
        this.isActive = isActive;
        this.createdDate = createdDate;
    }

    // ========== GETTERS VÀ SETTERS ==========
    public UUID getInsuranceId() {
        return insuranceId;
    }

    public void setInsuranceId(UUID insuranceId) {
        this.insuranceId = insuranceId;
    }

    public String getInsuranceName() {
        return insuranceName;
    }

    public void setInsuranceName(String insuranceName) {
        this.insuranceName = insuranceName;
    }

    public String getInsuranceType() {
        return insuranceType;
    }

    public void setInsuranceType(String insuranceType) {
        this.insuranceType = insuranceType;
    }

    /**
     * Phí bảo hiểm cố định theo ngày (VND) - chỉ lưu trữ, logic tính toán ở
     * Service
     */
    public double getBaseRatePerDay() {
        return baseRatePerDay;
    }

    public void setBaseRatePerDay(double baseRatePerDay) {
        this.baseRatePerDay = baseRatePerDay;
    }

    /**
     * Tỷ lệ % phí bảo hiểm - chỉ lưu trữ, logic tính toán ở Service
     */
    public double getPercentageRate() {
        return percentageRate;
    }

    public void setPercentageRate(double percentageRate) {
        this.percentageRate = percentageRate;
    }

    /**
     * Số tiền bảo hiểm tối đa (VND) - chỉ lưu trữ
     */
    public double getCoverageAmount() {
        return coverageAmount;
    }

    public void setCoverageAmount(double coverageAmount) {
        this.coverageAmount = coverageAmount;
    }

    public String getApplicableCarSeats() {
        return applicableCarSeats;
    }

    public void setApplicableCarSeats(String applicableCarSeats) {
        this.applicableCarSeats = applicableCarSeats;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    @Override
    public String toString() {
        return "Insurance{"
                + "insuranceId=" + insuranceId
                + ", insuranceName='" + insuranceName + '\''
                + ", insuranceType='" + insuranceType + '\''
                + ", baseRatePerDay=" + baseRatePerDay
                + ", percentageRate=" + percentageRate
                + ", coverageAmount=" + coverageAmount
                + ", applicableCarSeats='" + applicableCarSeats + '\''
                + ", description='" + description + '\''
                + ", isActive=" + isActive
                + ", createdDate=" + createdDate
                + '}';
    }
}
