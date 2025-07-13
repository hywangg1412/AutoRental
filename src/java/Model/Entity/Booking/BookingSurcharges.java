package Model.Entity.Booking;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Model đại diện cho các khoản phí phụ của booking
 * Bao gồm VAT, penalty, service fees, etc.
 * Quan trọng cho tính năng deposit để tracking chi phí
 */
public class BookingSurcharges {
    
    // ========== CÁC FIELD CƠ BẢN ==========
    
    private UUID surchargeId;            // ID duy nhất của phí phụ
    private UUID bookingId;              // ID của booking
    private String surchargeType;        // Loại phí: "VAT", "Penalty", "Service", "Insurance"
    private double amount;               // Số tiền phí (VND) - DÙNG DOUBLE
    private String description;          // Mô tả chi tiết phí
    private LocalDateTime createdDate;   // Thời gian tạo phí
    private String surchargeCategory;    // Phân loại: "Tax", "Insurance", "Penalty", "Service"
    private boolean isSystemGenerated;   // Có phải phí tự động tạo không (VAT, Insurance)
    
    // ========== CONSTRUCTORS ==========
    
    /**
     * Constructor mặc định
     */
    public BookingSurcharges() {}
    
    /**
     * Constructor đầy đủ tham số
     */
    public BookingSurcharges(UUID surchargeId, UUID bookingId, String surchargeType,
                            double amount, String description, LocalDateTime createdDate,
                            String surchargeCategory, boolean isSystemGenerated) {
        this.surchargeId = surchargeId;
        this.bookingId = bookingId;
        this.surchargeType = surchargeType;
        this.amount = amount;
        this.description = description;
        this.createdDate = createdDate;
        this.surchargeCategory = surchargeCategory;
        this.isSystemGenerated = isSystemGenerated;
    }
    
    // ========== GETTERS VÀ SETTERS ==========
    
    public UUID getSurchargeId() { return surchargeId; }
    public void setSurchargeId(UUID surchargeId) { this.surchargeId = surchargeId; }
    
    public UUID getBookingId() { return bookingId; }
    public void setBookingId(UUID bookingId) { this.bookingId = bookingId; }
    
    /**
     * Lấy loại phí phụ
     * @return String "VAT", "Penalty", "Service", "Insurance"
     */
    public String getSurchargeType() { return surchargeType; }
    public void setSurchargeType(String surchargeType) { this.surchargeType = surchargeType; }
    
    /**
     * Lấy số tiền phí (sử dụng double để khớp với Booking)
     * @return double số tiền VND
     */
    public double getAmount() { return amount; }
    public void setAmount(double amount) { this.amount = amount; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public LocalDateTime getCreatedDate() { return createdDate; }
    public void setCreatedDate(LocalDateTime createdDate) { this.createdDate = createdDate; }
    
    /**
     * Lấy phân loại phí
     * @return String "Tax", "Insurance", "Penalty", "Service"
     */
    public String getSurchargeCategory() { return surchargeCategory; }
    public void setSurchargeCategory(String surchargeCategory) { this.surchargeCategory = surchargeCategory; }
    
    /**
     * Kiểm tra có phải phí tự động tạo không (VAT, Insurance)
     * @return true nếu là phí tự động
     */
    public boolean isSystemGenerated() { return isSystemGenerated; }
    public void setSystemGenerated(boolean systemGenerated) { isSystemGenerated = systemGenerated; }
    
    @Override
    public String toString() {
        return "BookingSurcharges{" +
                "surchargeId=" + surchargeId +
                ", bookingId=" + bookingId +
                ", surchargeType='" + surchargeType + '\'' +
                ", amount=" + amount +
                ", description='" + description + '\'' +
                ", createdDate=" + createdDate +
                ", surchargeCategory='" + surchargeCategory + '\'' +
                ", isSystemGenerated=" + isSystemGenerated +
                '}';
    }
}
