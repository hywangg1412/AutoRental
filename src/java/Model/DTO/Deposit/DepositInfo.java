package Model.DTO.Deposit;

/**
 * DTO chứa thông tin tính toán deposit cho booking
 * Sử dụng cho DepositServlet
 */
public class DepositInfo {
    
    // Thông tin cơ bản
    private double baseAmount;       // Giá thuê xe cơ bản
    private double insuranceAmount;  // Tổng tiền bảo hiểm
    private double discountAmount;   // Tiền giảm giá
    private double vatAmount;        // Tiền VAT (10%)
    private double totalAmount;      // Tổng tiền
    private double depositAmount;    // Tiền cọc (30%)
    
    // Chi tiết bảo hiểm
    private double tndsInsurance;    // Bảo hiểm TNDS
    private double materialInsurance; // Bảo hiểm vật chất
    private double accidentInsurance; // Bảo hiểm tai nạn
    
    // Thông tin thời gian
    private int rentalDays;
    private String rentalType;
    
    // Constructor
    public DepositInfo() {}
    
    public DepositInfo(double baseAmount, double insuranceAmount, double discountAmount, 
                      double vatAmount, double totalAmount, double depositAmount) {
        this.baseAmount = baseAmount;
        this.insuranceAmount = insuranceAmount;
        this.discountAmount = discountAmount;
        this.vatAmount = vatAmount;
        this.totalAmount = totalAmount;
        this.depositAmount = depositAmount;
    }
    
    // Getters và Setters
    public double getBaseAmount() {
        return baseAmount;
    }
    
    public void setBaseAmount(double baseAmount) {
        this.baseAmount = baseAmount;
    }
    
    public double getInsuranceAmount() {
        return insuranceAmount;
    }
    
    public void setInsuranceAmount(double insuranceAmount) {
        this.insuranceAmount = insuranceAmount;
    }
    
    public double getDiscountAmount() {
        return discountAmount;
    }
    
    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }
    
    public double getVatAmount() {
        return vatAmount;
    }
    
    public void setVatAmount(double vatAmount) {
        this.vatAmount = vatAmount;
    }
    
    public double getTotalAmount() {
        return totalAmount;
    }
    
    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }
    
    public double getDepositAmount() {
        return depositAmount;
    }
    
    public void setDepositAmount(double depositAmount) {
        this.depositAmount = depositAmount;
    }
    
    public double getTndsInsurance() {
        return tndsInsurance;
    }
    
    public void setTndsInsurance(double tndsInsurance) {
        this.tndsInsurance = tndsInsurance;
    }
    
    public double getMaterialInsurance() {
        return materialInsurance;
    }
    
    public void setMaterialInsurance(double materialInsurance) {
        this.materialInsurance = materialInsurance;
    }
    
    public double getAccidentInsurance() {
        return accidentInsurance;
    }
    
    public void setAccidentInsurance(double accidentInsurance) {
        this.accidentInsurance = accidentInsurance;
    }
    
    public int getRentalDays() {
        return rentalDays;
    }
    
    public void setRentalDays(int rentalDays) {
        this.rentalDays = rentalDays;
    }
    
    public String getRentalType() {
        return rentalType;
    }
    
    public void setRentalType(String rentalType) {
        this.rentalType = rentalType;
    }
    
    // ========== FORMATTED METHODS CHO JSP ==========
    
    /**
     * Format baseAmount cho JSP display
     */
    public String getFormattedBaseAmount() {
        return String.format("%,.0f", baseAmount);
    }
    
    /**
     * Format insuranceAmount cho JSP display
     */
    public String getFormattedInsuranceAmount() {
        return String.format("%,.0f", insuranceAmount);
    }
    
    /**
     * Format discountAmount cho JSP display
     */
    public String getFormattedDiscountAmount() {
        return String.format("%,.0f", discountAmount);
    }
    
    /**
     * Format vatAmount cho JSP display
     */
    public String getFormattedVatAmount() {
        return String.format("%,.0f", vatAmount);
    }
    
    /**
     * Format totalAmount cho JSP display
     */
    public String getFormattedTotalAmount() {
        return String.format("%,.0f", totalAmount);
    }
    
    /**
     * Format depositAmount cho JSP display
     */
    public String getFormattedDepositAmount() {
        return String.format("%,.0f", depositAmount);
    }
    
    public String getFormattedTndsInsurance() {
        return String.format("%,.0f", tndsInsurance);
    }
    
    public String getFormattedMaterialInsurance() {
        return String.format("%,.0f", materialInsurance);
    }
    
    public String getFormattedAccidentInsurance() {
        return String.format("%,.0f", accidentInsurance);
    }
} 