package Model.Entity.OAuth;

import java.time.LocalDateTime;
import java.util.UUID;

public class EmailVerificationToken {
    public UUID id;
    public String token;
    private LocalDateTime expiryTime;
    private boolean isUsed;
    private UUID userId;
    private LocalDateTime createdAt;

    public EmailVerificationToken() {
    }

    public EmailVerificationToken(UUID id, String token, LocalDateTime expiryTime, boolean isUsed, UUID userId, LocalDateTime createdAt) {
        this.id = id;
        this.token = token;
        this.expiryTime = expiryTime;
        this.isUsed = isUsed;
        this.userId = userId;
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

    @Override
    public String toString() {
        return "EmailVerificationToken{" + "id=" + id + ", token=" + token + ", expiryTime=" + expiryTime + ", isUsed=" + isUsed + ", userId=" + userId + ", createdAt=" + createdAt + '}';
    }
}
