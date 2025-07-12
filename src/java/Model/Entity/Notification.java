package Model.Entity;

import java.time.LocalDateTime;
import java.util.UUID;

public class Notification {
    private UUID notificationId;
    private UUID userId;
    private String message;
    private LocalDateTime createdDate;
    private boolean isRead;

    public Notification() {}

    public Notification(UUID notificationId, UUID userId, String message, LocalDateTime createdDate) {
        this.notificationId = notificationId;
        this.userId = userId;
        this.message = message;
        this.createdDate = createdDate;
        this.isRead = false; // Mặc định là chưa đọc
    }
    
    public Notification(UUID notificationId, UUID userId, String message, LocalDateTime createdDate, boolean isRead) {
        this.notificationId = notificationId;
        this.userId = userId;
        this.message = message;
        this.createdDate = createdDate;
        this.isRead = isRead;
    }

    public UUID getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(UUID notificationId) {
        this.notificationId = notificationId;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }
    
    public boolean isRead() {
        return isRead;
    }
    
    public void setRead(boolean isRead) {
        this.isRead = isRead;
    }
} 