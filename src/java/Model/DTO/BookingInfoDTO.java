package Model.DTO;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;
import Model.DTO.Deposit.InsuranceDetailDTO; // Thêm import
import Utils.PriceUtils; // Thêm import PriceUtils

/**
 * Data Transfer Object for displaying comprehensive booking information on the
 * staff interface. This object aggregates data from Booking, User, Car, and
 * DriverLicense entities.
 */
public class BookingInfoDTO {

    // Booking Information
    private UUID bookingId;
    private String bookingCode; // Friendly booking code like "BK-20240621-XYZ12"
    private LocalDateTime pickupDateTime;
    private LocalDateTime returnDateTime;
    private double totalAmount;
    private String status;
    private LocalDateTime createdDate;

    // *** THAY ĐỔI KIỂU DỮ LIỆU TỪ LONG SANG DOUBLE ***
    private double duration; // Thay vì long duration

    // *** THÊM FIELD MỚI CHO RENTAL TYPE ***
    private String rentalType; // Loại thuê: "hourly", "daily", "monthly"

    // *** THÊM FIELD MỚI CHO FORMATTED DURATION ***
    private String formattedDuration; // Chuỗi hiển thị duration đã format (ví dụ: "10 days 4 hours 30 minutes")

    // User (Customer) Information
    private String customerName;
    private String customerEmail;
    private String customerPhone;

    // Car Information
    private String carModel;
    private String carLicensePlate; // Biển số xe
    private String carStatus;

    // Driver License Information
    private String driverLicenseImageUrl;

    // Status Information for Modal
    private String depositStatus;
    private String contractStatus;

    // --- Thêm các trường từ BookingDTO ---
    private String carImage;
    private java.math.BigDecimal pricePerDay;
    private String cancelReason;

    // Để đồng bộ với BookingDTO
    private String fullName; // alias cho customerName
    private String email; // alias cho customerEmail
    private String phoneNumber; // alias cho customerPhone

    // Thông tin giá chi tiết
    private java.math.BigDecimal pricePerHour;
    private java.math.BigDecimal pricePerMonth;

    // Thông tin bảo hiểm
    private List<InsuranceDetailDTO> insuranceDetails;
    private double basicInsuranceFee;
    private double additionalInsuranceFee;

    private boolean hasFeedback;

    // Constructors
    public BookingInfoDTO() {
    }

    // --- Start of Getters and Setters ---
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

    // --- NEW FORMATTING METHODS ---
    public String getFormattedPickupDateTime() {
        if (pickupDateTime == null) {
            return "";
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy, hh:mm a");
        return pickupDateTime.format(formatter);
    }

    public String getFormattedReturnDateTime() {
        if (returnDateTime == null) {
            return "";
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MMM dd, yyyy, hh:mm a");
        return returnDateTime.format(formatter);
    }
    // --- END OF NEW METHODS ---

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }

    // *** GETTER VÀ SETTER CHO DURATION KIỂU DOUBLE ***
    public double getDuration() {
        return duration;
    }

    public void setDuration(double duration) {
        this.duration = duration;
    }

    // *** THÊM METHOD FORMAT DURATION CHO HIỂN THỊ CÓ SỐ THẬP PHÂN ***
    public String getFormattedDuration() {
        // Nếu đã có formattedDuration được đặt trực tiếp, ưu tiên sử dụng nó
        if (formattedDuration != null && !formattedDuration.isEmpty()) {
            return formattedDuration;
        }

        // Nếu không, tính toán formattedDuration từ duration và rentalType
        if (duration <= 0) {
            return "1 day";
        }

        // Format duration theo rental type với số thập phân
        if (rentalType != null) {
            switch (rentalType.toLowerCase()) {
                case "hourly":
                    if (duration == Math.floor(duration)) {
                        return String.format("%.0f hours", duration); // Không có thập phân
                    } else {
                        return String.format("%.1f hours", duration); // 1 chữ số thập phân
                    }
                case "daily":
                    if (duration == Math.floor(duration)) {
                        return String.format("%.0f days", duration); // Không có thập phân
                    } else {
                        return String.format("%.2f days", duration); // 2 chữ số thập phân
                    }
                case "monthly":
                    if (duration == Math.floor(duration)) {
                        return String.format("%.0f months", duration); // Không có thập phân
                    } else {
                        return String.format("%.2f months", duration); // 2 chữ số thập phân
                    }
                default:
                    return String.format("%.2f days", duration);
            }
        }

        // Mặc định hiển thị days
        if (duration == Math.floor(duration)) {
            return String.format("%.0f days", duration);
        } else {
            return String.format("%.2f days", duration);
        }
    }

    /**
     * Đặt chuỗi đã format sẵn cho duration, ưu tiên sử dụng chuỗi này khi hiển
     * thị
     *
     * @param formattedDuration Chuỗi hiển thị duration đã format (ví dụ: "10
     * days 4 hours 30 minutes")
     */
    public void setFormattedDuration(String formattedDuration) {
        this.formattedDuration = formattedDuration;
    }

    // *** GETTER VÀ SETTER CHO RENTAL TYPE MỚI ***
    public String getRentalType() {
        return rentalType;
    }

    public void setRentalType(String rentalType) {
        this.rentalType = rentalType;
    }

    // *** THÊM METHOD FORMAT RENTAL TYPE CHO HIỂN THỊ ***
    public String getFormattedRentalType() {
        if (rentalType == null || rentalType.trim().isEmpty()) {
            return "Daily"; // Mặc định
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

    // ... các getter/setter khác giữ nguyên ...
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

    public String getCarModel() {
        return carModel;
    }

    public void setCarModel(String carModel) {
        this.carModel = carModel;
    }

    public String getCarLicensePlate() {
        return carLicensePlate;
    }

    public void setCarLicensePlate(String carLicensePlate) {
        this.carLicensePlate = carLicensePlate;
    }

    public String getCarStatus() {
        return carStatus;
    }

    public void setCarStatus(String carStatus) {
        this.carStatus = carStatus;
    }

    public String getDriverLicenseImageUrl() {
        return driverLicenseImageUrl;
    }

    public void setDriverLicenseImageUrl(String driverLicenseImageUrl) {
        this.driverLicenseImageUrl = driverLicenseImageUrl;
    }

    public String getDepositStatus() {
        return depositStatus;
    }

    public void setDepositStatus(String depositStatus) {
        this.depositStatus = depositStatus;
    }

    public String getContractStatus() {
        return contractStatus;
    }

    public void setContractStatus(String contractStatus) {
        this.contractStatus = contractStatus;
    }

    public boolean isHasFeedback() {
        return hasFeedback;
    }

    public void setHasFeedback(boolean hasFeedback) {
        this.hasFeedback = hasFeedback;
        // Getter/Setter cho các trường mới

    }

    public String getCarImage() {
        return carImage;
    }

    public void setCarImage(String carImage) {
        this.carImage = carImage;
    }

    public java.math.BigDecimal getPricePerDay() {
        return pricePerDay;
    }

    public void setPricePerDay(java.math.BigDecimal pricePerDay) {
        this.pricePerDay = pricePerDay;
    }

    public String getCancelReason() {
        return cancelReason;
    }

    public void setCancelReason(String cancelReason) {
        this.cancelReason = cancelReason;
    }

    public String getFullName() {
        return fullName != null ? fullName : customerName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email != null ? email : customerEmail;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNumber() {
        return phoneNumber != null ? phoneNumber : customerPhone;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    // Getters và setters cho các trường mới
    public java.math.BigDecimal getPricePerHour() {
        return pricePerHour;
    }

    public void setPricePerHour(java.math.BigDecimal pricePerHour) {
        this.pricePerHour = pricePerHour;
    }

    public java.math.BigDecimal getPricePerMonth() {
        return pricePerMonth;
    }

    public void setPricePerMonth(java.math.BigDecimal pricePerMonth) {
        this.pricePerMonth = pricePerMonth;
    }

    public List<InsuranceDetailDTO> getInsuranceDetails() {
        return insuranceDetails;
    }

    public void setInsuranceDetails(List<InsuranceDetailDTO> insuranceDetails) {
        this.insuranceDetails = insuranceDetails;
    }

    public double getBasicInsuranceFee() {
        return basicInsuranceFee;
    }

    public void setBasicInsuranceFee(double basicInsuranceFee) {
        this.basicInsuranceFee = basicInsuranceFee;
    }

    public double getAdditionalInsuranceFee() {
        return additionalInsuranceFee;
    }

    public void setAdditionalInsuranceFee(double additionalInsuranceFee) {
        this.additionalInsuranceFee = additionalInsuranceFee;
    }

    // --- Các phương thức format giá tiền sử dụng PriceUtils ---
    /**
     * Trả về giá theo giờ đã format
     */
    public String getFormattedPricePerHour() {
        if (pricePerHour == null) {
            return "N/A";
        }
        return PriceUtils.formatDbPrice(pricePerHour);
    }

    /**
     * Trả về giá theo ngày đã format
     */
    public String getFormattedPricePerDay() {
        if (pricePerDay == null) {
            return "N/A";
        }
        return PriceUtils.formatDbPrice(pricePerDay);
    }

    /**
     * Trả về giá theo tháng đã format
     */
    public String getFormattedPricePerMonth() {
        if (pricePerMonth == null) {
            return "N/A";
        }
        return PriceUtils.formatDbPrice(pricePerMonth);
    }

    /**
     * Trả về phí bảo hiểm cơ bản đã format
     */
    public String getFormattedBasicInsuranceFee() {
        return PriceUtils.formatDbPrice(basicInsuranceFee);
    }

    /**
     * Trả về phí bảo hiểm bổ sung đã format
     */
    public String getFormattedAdditionalInsuranceFee() {
        return PriceUtils.formatDbPrice(additionalInsuranceFee);
    }

    /**
     * Trả về tổng tiền đã format
     */
    public String getFormattedTotalAmount() {
        return PriceUtils.formatDbPrice(totalAmount);
    }

    // --- End of Getters and Setters ---
    @Override
    public String toString() {
        return "BookingInfoDTO{"
                + "bookingId=" + bookingId
                + ", bookingCode='" + bookingCode + '\''
                + ", pickupDateTime=" + pickupDateTime
                + ", returnDateTime=" + returnDateTime
                + ", totalAmount=" + totalAmount
                + ", status='" + status + '\''
                + ", customerName='" + customerName + '\''
                + ", carModel='" + carModel + '\''
                + ", driverLicenseImageUrl='" + driverLicenseImageUrl + '\''
                + ", rentalType='" + rentalType + '\''
                + // *** THÊM VÀO toString() ***
                ", duration=" + duration
                + // *** THÊM DURATION VÀO toString() ***
                '}';
    }
}
