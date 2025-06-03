package Model.Entity.OAuth;

import java.time.LocalDateTime;
import java.util.UUID;

public class PasswordResetToken {

    private UUID id;
    private String token;
    private UUID userId;
    private LocalDateTime expiryTime;
    private boolean isUsed;
    private LocalDateTime createdAt;

    public PasswordResetToken() {
    }

    public PasswordResetToken(UUID userId, String token,boolean isUsed, LocalDateTime expiryTime , LocalDateTime createdAt) {
        this.userId = userId;
        this.token = token;
        this.expiryTime = expiryTime;
        this.isUsed = isUsed;
        this.createdAt = createdAt;
    }

    public PasswordResetToken(UUID id, String token, UUID userId, LocalDateTime expiryTime, boolean isUsed, LocalDateTime createdAt) {
        this.id = id;
        this.token = token;
        this.userId = userId;
        this.expiryTime = expiryTime;
        this.isUsed = isUsed;
        this.createdAt = createdAt;
    }

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
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

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "PasswordResetToken{" + "id=" + id + ", token=" + token + ", userId=" + userId + ", expiryTime=" + expiryTime + ", isUsed=" + isUsed + ", createdAt=" + createdAt + '}';
    }

}
