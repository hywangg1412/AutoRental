package Model.DTO.Deposit;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;
import Utils.PriceUtils; // Thêm import PriceUtils

/**
 * DTO chứa tất cả thông tin cần thiết cho trang deposit
 * Theo pattern của BookingInfoDTO - sử dụng double cho logic, BigDecimal cho hiển thị
 */
public class DepositPageDTO {

    // Thông tin booking cơ bản
    private UUID bookingId;
    private String bookingCode;
    private LocalDateTime pickupDateTime;
    private LocalDateTime returnDateTime;
    private String rentalType;              // hourly, daily, monthly
    private double duration;                // Thời gian thuê
    private String formattedDuration;       // Chuỗi hiển thị duration đã format (ví dụ: "12 days 9 hours 30 minutes")
    private String status;                  // Trạng thái booking

    // Thông tin xe
    private String carModel;
    private String carBrand;
    private String licensePlate;
    private int carSeats;

    // Thông tin khách hàng
    private String customerName;
    private String customerEmail;
    private String customerPhone;

    // *** THÔNG TIN GIÁ CẢ - SỬ DỤNG DOUBLE CHO TÍNH TOÁN ***
    private double baseRentalPrice;         // Giá thuê cơ bản từ Booking.totalAmount
    private double totalInsuranceAmount;    // Tổng phí bảo hiểm
    private double discountAmount;          // Số tiền giảm từ discount
    private double subtotal;                // base + insurance - discount
    private double vatAmount;               // VAT 10%
    private double totalAmount;             // Tổng cuối cùng (subtotal + VAT)
    private double depositAmount;           // Tiền cọc (cố định 300K hoặc 10% tùy theo total amount)

    // Thông tin điều khoản
    private boolean termsAgreed;           // Đã đồng ý điều khoản chưa
    private String termsVersion;           // Phiên bản điều khoản hiện tại
    private String termsTitle;
    private String termsShortContent;
    private String termsFullContent;
    private LocalDateTime termsAgreedAt;

    // Chi tiết bảo hiểm
    private List<InsuranceDetailDTO> insuranceDetails;

    // Thông tin discount đã áp dụng
    private DiscountDTO appliedDiscount;

    // Constructor mặc định
    public DepositPageDTO() {
    }

    // ========== GETTERS VÀ SETTERS CHO THÔNG TIN CƠ BẢN ==========

    public UUID getBookingId() {
        return bookingId;
    }

    public void setBookingId(UUID bookingId) {
        this.bookingId = bookingId;
    }

    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    public LocalDateTime getPickupDateTime() {
        return pickupDateTime;
    }

    public void setPickupDateTime(LocalDateTime pickupDateTime) {
        this.pickupDateTime = pickupDateTime;
    }

    public LocalDateTime getReturnDateTime() {
        return returnDateTime;
    }

    public void setReturnDateTime(LocalDateTime returnDateTime) {
        this.returnDateTime = returnDateTime;
    }

    public String getRentalType() {
        return rentalType;
    }

    public void setRentalType(String rentalType) {
        this.rentalType = rentalType;
    }

    public double getDuration() {
        return duration;
    }

    public void setDuration(double duration) {
        this.duration = duration;
    }

    public String getFormattedDuration() {
        // Nếu đã có formattedDuration được đặt trực tiếp, ưu tiên sử dụng nó
        if (formattedDuration != null && !formattedDuration.isEmpty()) {
            return formattedDuration;
        }
        
        // Nếu không, sử dụng logic cũ để tính toán
        if (rentalType != null) {
            switch (rentalType.toLowerCase()) {
                case "hourly":
                    if (duration < 1) {
                        int minutes = (int) Math.round(duration * 60);
                        return String.format("%d minutes", minutes);
                    } else {
                        int hours = (int) Math.floor(duration);
                        int minutes = (int) Math.round((duration - hours) * 60);
                        if (minutes > 0) {
                            return String.format("%d hours %d minutes", hours, minutes);
                        } else {
                            return String.format("%d hours", hours);
                        }
                    }
                case "daily":
                    if (duration < 1) {
                        int hours = (int) Math.round(duration * 24);
                        return String.format("%d hours", hours);
                    } else {
                        int days = (int) Math.floor(duration);
                        int hours = (int) Math.round((duration - days) * 24);
                        if (hours > 0) {
                            return String.format("%d days %d hours", days, hours);
                        } else {
                            return String.format("%d days", days);
                        }
                    }
                case "monthly":
                    if (duration < 1) {
                        int days = (int) Math.round(duration * 30);
                        return String.format("%d days", days);
                    } else {
                        int months = (int) Math.floor(duration);
                        int days = (int) Math.round((duration - months) * 30);
                        if (days > 0) {
                            return String.format("%d months %d days", months, days);
                        } else {
                            return String.format("%d months", months);
                        }
                    }
                default:
                    return String.format("%.2f days", duration);
            }
        }
        return String.format("%.2f days", duration);
    }

    public void setFormattedDuration(String formattedDuration) {
        this.formattedDuration = formattedDuration;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    // Alias method for compatibility with PaymentService
    public String getBookingStatus() {
        return status;
    }

    // ========== GETTERS VÀ SETTERS CHO THÔNG TIN XE ==========

    public String getCarModel() {
        return carModel;
    }

    public void setCarModel(String carModel) {
        this.carModel = carModel;
    }

    public String getCarBrand() {
        return carBrand;
    }

    public void setCarBrand(String carBrand) {
        this.carBrand = carBrand;
    }

    public String getLicensePlate() {
        return licensePlate;
    }

    public void setLicensePlate(String licensePlate) {
        this.licensePlate = licensePlate;
    }

    public int getCarSeats() {
        return carSeats;
    }

    public void setCarSeats(int carSeats) {
        this.carSeats = carSeats;
    }

    // ========== GETTERS VÀ SETTERS CHO THÔNG TIN KHÁCH HÀNG ==========

    public String getCustomerName() {
        return customerName;
    }

    public void setCustomerName(String customerName) {
        this.customerName = customerName;
    }

    public String getCustomerEmail() {
        return customerEmail;
    }

    public void setCustomerEmail(String customerEmail) {
        this.customerEmail = customerEmail;
    }

    public String getCustomerPhone() {
        return customerPhone;
    }

    public void setCustomerPhone(String customerPhone) {
        this.customerPhone = customerPhone;
    }

    // ========== GETTERS VÀ SETTERS CHO GIÁ CẢ - DOUBLE ==========

    public double getBaseRentalPrice() {
        return baseRentalPrice;
    }

    public void setBaseRentalPrice(double baseRentalPrice) {
        this.baseRentalPrice = baseRentalPrice;
    }

    public double getTotalInsuranceAmount() {
        return totalInsuranceAmount;
    }

    public void setTotalInsuranceAmount(double totalInsuranceAmount) {
        this.totalInsuranceAmount = totalInsuranceAmount;
    }

    public double getDiscountAmount() {
        return discountAmount;
    }

    public void setDiscountAmount(double discountAmount) {
        this.discountAmount = discountAmount;
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
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

    // ========== GETTERS VÀ SETTERS CHO ĐIỀU KHOẢN ==========

    public boolean isTermsAgreed() {
        return termsAgreed;
    }

    public void setTermsAgreed(boolean termsAgreed) {
        this.termsAgreed = termsAgreed;
    }

    public String getTermsVersion() {
        return termsVersion;
    }

    public void setTermsVersion(String termsVersion) {
        this.termsVersion = termsVersion;
    }

    public String getTermsTitle() {
        return termsTitle;
    }

    public void setTermsTitle(String termsTitle) {
        this.termsTitle = termsTitle;
    }

    public String getTermsShortContent() {
        return termsShortContent;
    }

    public void setTermsShortContent(String termsShortContent) {
        this.termsShortContent = termsShortContent;
    }

    public String getTermsFullContent() {
        return termsFullContent;
    }

    public void setTermsFullContent(String termsFullContent) {
        this.termsFullContent = termsFullContent;
    }

    public LocalDateTime getTermsAgreedAt() {
        return termsAgreedAt;
    }

    public void setTermsAgreedAt(LocalDateTime termsAgreedAt) {
        this.termsAgreedAt = termsAgreedAt;
    }

    // ========== GETTERS VÀ SETTERS CHO DETAILS ==========

    public List<InsuranceDetailDTO> getInsuranceDetails() {
        return insuranceDetails;
    }

    public void setInsuranceDetails(List<InsuranceDetailDTO> insuranceDetails) {
        this.insuranceDetails = insuranceDetails;
    }

    public DiscountDTO getAppliedDiscount() {
        return appliedDiscount;
    }

    public void setAppliedDiscount(DiscountDTO appliedDiscount) {
        this.appliedDiscount = appliedDiscount;
    }

    // ========== FORMATTED METHODS CHO JSP (BIGDECIMAL) ==========

    public String getFormattedPickupDateTime() {
        if (pickupDateTime == null) {
            return "";
        }
        return pickupDateTime.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    public String getFormattedReturnDateTime() {
        if (returnDateTime == null) {
            return "";
        }
        return returnDateTime.format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }

    public String getFormattedRentalType() {
        if (rentalType == null) {
            return "Daily";
        }
        switch (rentalType.toLowerCase()) {
            case "hourly":
                return "Per Hour";
            case "daily":
                return "Per Day";
            case "monthly":
                return "Per Month";
            default:
                return rentalType;
        }
    }



    /**
     * Format số tiền - trả về định dạng VND đúng cho JSP sử dụng PriceUtils
     */
    public String getFormattedBaseRentalPrice() {
        return PriceUtils.formatDbPrice(baseRentalPrice);
    }

    public String getFormattedTotalInsuranceAmount() {
        return PriceUtils.formatDbPrice(totalInsuranceAmount);
    }

    public String getFormattedDiscountAmount() {
        return PriceUtils.formatDbPrice(discountAmount);
    }

    public String getFormattedSubtotal() {
        return PriceUtils.formatDbPrice(subtotal);
    }

    public String getFormattedVatAmount() {
        return PriceUtils.formatDbPrice(vatAmount);
    }

    public String getFormattedTotalAmount() {
        return PriceUtils.formatDbPrice(totalAmount);
    }

    public String getFormattedDepositAmount() {
        return PriceUtils.formatDbPrice(depositAmount);
    }

    // ========== BUSINESS LOGIC METHODS ==========

    public boolean canProceedToPayment() {
        return termsAgreed; // Chỉ cho phép thanh toán khi đã đồng ý điều khoản
    }

    /**
     * Tính % deposit so với total
     */
    public String getDepositPercentage() {
        if (totalAmount > 0) {
            double percentage = (depositAmount / totalAmount) * 100;
            return String.format("%.0f%%", percentage);
        }
        return "Fixed"; // Hiển thị "Fixed" thay vì % vì đã hardcode
    }

    @Override
    public String toString() {
        return "DepositPageDTO{"
                + "bookingId=" + bookingId
                + ", bookingCode='" + bookingCode + '\''
                + ", carModel='" + carModel + '\''
                + ", totalAmount=" + totalAmount
                + ", depositAmount=" + depositAmount
                + '}';
    }
}
