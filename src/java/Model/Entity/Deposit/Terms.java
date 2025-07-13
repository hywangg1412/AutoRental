/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Model.Entity.Deposit;

/**
 *
 * @author admin
 */
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Model Terms - quản lý điều khoản và điều kiện Hỗ trợ nội dung phân tầng
 * (short/full content)
 */
public class Terms {

    private UUID termsId;
    private String version;              // v1.0, v1.1, v2.0...
    private String title;                // Tiêu đề điều khoản
    private String shortContent;         // Nội dung tóm tắt (cho deposit page)
    private String fullContent;          // Nội dung đầy đủ (cho modal)
    private LocalDate effectiveDate;     // Ngày có hiệu lực
    private boolean isActive;            // Có đang hoạt động không
    private LocalDateTime createdDate;   // Thời gian tạo

    // Constructors
    public Terms() {
    }

    // ========== GETTERS VÀ SETTERS ==========
    public UUID getTermsId() {
        return termsId;
    }

    public void setTermsId(UUID termsId) {
        this.termsId = termsId;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    /**
     * Nội dung tóm tắt điều khoản (hiển thị trong deposit page)
     */
    public String getShortContent() {
        return shortContent;
    }

    public void setShortContent(String shortContent) {
        this.shortContent = shortContent;
    }

    /**
     * Nội dung đầy đủ điều khoản (hiển thị trong modal)
     */
    public String getFullContent() {
        return fullContent;
    }

    public void setFullContent(String fullContent) {
        this.fullContent = fullContent;
    }

    public LocalDate getEffectiveDate() {
        return effectiveDate;
    }

    public void setEffectiveDate(LocalDate effectiveDate) {
        this.effectiveDate = effectiveDate;
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
        return "Terms{"
                + "termsId=" + termsId
                + ", version='" + version + '\''
                + ", title='" + title + '\''
                + ", effectiveDate=" + effectiveDate
                + ", isActive=" + isActive
                + '}';
    }
}
