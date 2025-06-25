package Model.Entity.OAuth;

import java.time.LocalDateTime;
import java.util.UUID;

public class EmailOTPVerification {
    public UUID id;
    public String otp;
    private LocalDateTime expiryTime;
    private boolean isUsed;
    private UUID userId;
    private LocalDateTime createdAt;
    private int resendCount;
    private LocalDateTime lastResendTime;
    private LocalDateTime resendBlockUntil;

    public EmailOTPVerification() {
    }

    public EmailOTPVerification(UUID id, String otp, LocalDateTime expiryTime, boolean isUsed, UUID userId, LocalDateTime createdAt, int resendCount, LocalDateTime lastResendTime, LocalDateTime resendBlockUntil) {
        this.id = id;
        this.otp = otp;
        this.expiryTime = expiryTime;
        this.isUsed = isUsed;
        this.userId = userId;
        this.createdAt = createdAt;
        this.resendCount = resendCount;
        this.lastResendTime = lastResendTime;
        this.resendBlockUntil = resendBlockUntil;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getOtp() {
        return otp;
    }

    public void setOtp(String otp) {
        this.otp = otp;
    }

    public LocalDateTime getExpiryTime() {
        return expiryTime;
    }

    public void setExpiryTime(LocalDateTime expiryTime) {
        this.expiryTime = expiryTime;
    }

    public boolean isIsUsed() {
        return isUsed;
    }

    public void setIsUsed(boolean isUsed) {
        this.isUsed = isUsed;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public int getResendCount() {
        return resendCount;
    }

    public void setResendCount(int resendCount) {
        this.resendCount = resendCount;
    }

    public LocalDateTime getLastResendTime() {
        return lastResendTime;
    }

    public void setLastResendTime(LocalDateTime lastResendTime) {
        this.lastResendTime = lastResendTime;
    }

    public LocalDateTime getResendBlockUntil() {
        return resendBlockUntil;
    }

    public void setResendBlockUntil(LocalDateTime resendBlockUntil) {
        this.resendBlockUntil = resendBlockUntil;
    }

    @Override
    public String toString() {
        return "EmailOTPVerification{" +
                "id=" + id +
                ", otp='" + otp + '\'' +
                ", expiryTime=" + expiryTime +
                ", isUsed=" + isUsed +
                ", userId=" + userId +
                ", createdAt=" + createdAt +
                ", resendCount=" + resendCount +
                ", lastResendTime=" + lastResendTime +
                ", resendBlockUntil=" + resendBlockUntil +
                '}';
    }
}
