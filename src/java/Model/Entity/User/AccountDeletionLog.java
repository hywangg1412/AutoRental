package Model.Entity.User;

import java.time.LocalDateTime;
import java.util.UUID;

public class AccountDeletionLog {
    private UUID logId;
    private UUID userId;
    private String deletionReason;
    private String additionalComments;
    private LocalDateTime timestamp;

    public AccountDeletionLog() {
    }

    public AccountDeletionLog(UUID logId, UUID userId, String deletionReason, String additionalComments, LocalDateTime timestamp) {
        this.logId = logId;
        this.userId = userId;
        this.deletionReason = deletionReason;
        this.additionalComments = additionalComments;
        this.timestamp = timestamp;
    }

    // Getters and Setters
    public UUID getLogId() {
        return logId;
    }

    public void setLogId(UUID logId) {
        this.logId = logId;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public String getDeletionReason() {
        return deletionReason;
    }

    public void setDeletionReason(String deletionReason) {
        this.deletionReason = deletionReason;
    }

    public String getAdditionalComments() {
        return additionalComments;
    }

    public void setAdditionalComments(String additionalComments) {
        this.additionalComments = additionalComments;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }
} 