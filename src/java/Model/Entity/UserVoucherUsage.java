package Model.Entity;

import java.util.UUID;
import java.util.Date;

public class UserVoucherUsage {
    private UUID userId;
    private UUID discountId;
    private Date usedAt;

    public UserVoucherUsage() {}
    public UserVoucherUsage(UUID userId, UUID discountId, Date usedAt) {
        this.userId = userId;
        this.discountId = discountId;
        this.usedAt = usedAt;
    }
    public UUID getUserId() { return userId; }
    public void setUserId(UUID userId) { this.userId = userId; }
    public UUID getDiscountId() { return discountId; }
    public void setDiscountId(UUID discountId) { this.discountId = discountId; }
    public Date getUsedAt() { return usedAt; }
    public void setUsedAt(Date usedAt) { this.usedAt = usedAt; }
} 