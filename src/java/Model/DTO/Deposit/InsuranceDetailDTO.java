package Model.DTO.Deposit;

/**
 * DTO hiển thị chi tiết bảo hiểm trong deposit page Chỉ chứa thông tin cần
 * thiết cho giao diện - logic tính toán ở Service
 */
public class InsuranceDetailDTO {

    private String insuranceName;        // Tên bảo hiểm
    private String insuranceType;        // Loại: "TNDS", "VatChat", "TaiNan"
    private double premiumAmount;        // Phí bảo hiểm (VND) - DÙNG DOUBLE
    private String description;          // Mô tả

    // Constructors
    public InsuranceDetailDTO() {
    }

    public InsuranceDetailDTO(String insuranceName, String insuranceType,
            double premiumAmount, String description) {
        this.insuranceName = insuranceName;
        this.insuranceType = insuranceType;
        this.premiumAmount = premiumAmount;
        this.description = description;
    }

    // ========== GETTERS VÀ SETTERS - CHỈ LƯU TRỮ ==========
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
     * Phí bảo hiểm - chỉ lưu trữ kết quả từ Service, không có logic tính toán
     */
    public double getPremiumAmount() {
        return premiumAmount;
    }

    public void setPremiumAmount(double premiumAmount) {
        this.premiumAmount = premiumAmount;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * Format hiển thị tiền cho JSP - trả về định dạng VND đúng
     */
    public String getFormattedPremiumAmount() {
        return String.format("%,.0f VND", premiumAmount * 1000);
    }

    @Override
    public String toString() {
        return "InsuranceDetailDTO{"
                + "insuranceName='" + insuranceName + '\''
                + ", insuranceType='" + insuranceType + '\''
                + ", premiumAmount=" + premiumAmount
                + ", description='" + description + '\''
                + '}';
    }
}
