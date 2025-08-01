package Model.DTO.Deposit;

import Utils.PriceUtils; // Thêm import PriceUtils

/**
 * DTO cho voucher/discount - chỉ lưu trữ thông tin, logic tính toán ở Service
 */
public class DiscountDTO {

    private java.util.UUID discountId;   // ID của discount
    private String voucherCode;          // Mã voucher
    private String name;                 // Tên discount
    private String discountType;         // "Percent" hoặc "Fixed"
    private double discountValue;        // Giá trị giảm - DÙNG DOUBLE
    private double minOrderAmount;       // Đơn hàng tối thiểu - DÙNG DOUBLE
    private double maxDiscountAmount;    // Giá trị giảm tối đa - DÙNG DOUBLE
    private String description;          // Mô tả

    // Constructors
    public DiscountDTO() {
    }

    public DiscountDTO(String voucherCode, String name, String discountType,
            double discountValue, double minOrderAmount, String description) {
        this.voucherCode = voucherCode;
        this.name = name;
        this.discountType = discountType;
        this.discountValue = discountValue;
        this.minOrderAmount = minOrderAmount;
        this.description = description;
    }

    // ========== GETTERS VÀ SETTERS - CHỈ LƯU TRỮ ==========
    public java.util.UUID getDiscountId() {
        return discountId;
    }

    public void setDiscountId(java.util.UUID discountId) {
        this.discountId = discountId;
    }

    public String getVoucherCode() {
        return voucherCode;
    }

    public void setVoucherCode(String voucherCode) {
        this.voucherCode = voucherCode;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDiscountType() {
        return discountType;
    }

    public void setDiscountType(String discountType) {
        this.discountType = discountType;
    }

    /**
     * Giá trị giảm giá - chỉ lưu trữ, logic tính toán ở Service
     */
    public double getDiscountValue() {
        return discountValue;
    }

    public void setDiscountValue(double discountValue) {
        this.discountValue = discountValue;
    }

    /**
     * Số tiền đơn hàng tối thiểu - chỉ lưu trữ
     */
    public double getMinOrderAmount() {
        return minOrderAmount;
    }

    public void setMinOrderAmount(double minOrderAmount) {
        this.minOrderAmount = minOrderAmount;
    }

    public double getMaxDiscountAmount() {
        return maxDiscountAmount;
    }

    public void setMaxDiscountAmount(double maxDiscountAmount) {
        this.maxDiscountAmount = maxDiscountAmount;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * Format hiển thị giá trị giảm giá cho JSP
     * @return Chuỗi đã format theo định dạng VND hoặc % tùy loại
     */
    public String getFormattedDiscountValue() {
        if ("Percent".equalsIgnoreCase(discountType)) {
            return String.format("%.0f%%", discountValue);
        } else {
            return PriceUtils.formatDbPrice(discountValue);
        }
    }
    
    /**
     * Format hiển thị giá trị đơn hàng tối thiểu cho JSP
     * @return Chuỗi đã format theo định dạng VND
     */
    public String getFormattedMinOrderAmount() {
        return PriceUtils.formatDbPrice(minOrderAmount);
    }

    @Override
    public String toString() {
        return "DiscountDTO{"
                + "voucherCode='" + voucherCode + '\''
                + ", name='" + name + '\''
                + ", discountType='" + discountType + '\''
                + ", discountValue=" + discountValue
                + ", minOrderAmount=" + minOrderAmount
                + ", description='" + description + '\''
                + '}';
    }
}
