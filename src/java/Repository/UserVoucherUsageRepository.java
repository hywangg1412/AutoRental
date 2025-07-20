package Repository;

import Model.Entity.UserVoucherUsage;
import Config.DBContext;
import java.sql.*;
import java.util.UUID;

public class UserVoucherUsageRepository {
    private final DBContext dbContext = new DBContext();

    // Đếm số user đã dùng voucher theo discountId
    public int countUsersUsedVoucher(UUID discountId) throws SQLException {
        String sql = "SELECT COUNT(DISTINCT UserId) FROM UserVoucherUsage WHERE DiscountId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, discountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }
} 