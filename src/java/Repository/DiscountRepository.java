package Repository;

import Config.DBContext;
import Model.Entity.Discount;


import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class DiscountRepository {
    private final DBContext dbContext;

    public DiscountRepository() {
        this.dbContext = new DBContext();
    }

    public List<Discount> findAll() throws SQLException {
        List<Discount> discounts = new ArrayList<>();
        String sql = "SELECT * FROM Discount";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = dbContext.getConnection();
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();
            while (rs.next()) {
                Discount discount = new Discount();
                discount.setDiscountId(UUID.fromString(rs.getString("DiscountId")));
                discount.setDiscountName(rs.getString("DiscountName"));
                discount.setDescription(rs.getString("Description"));
                discount.setDiscountType(rs.getString("DiscountType"));
                discount.setDiscountValue(rs.getBigDecimal("DiscountValue"));
                discount.setStartDate(rs.getDate("StartDate"));
                discount.setEndDate(rs.getDate("EndDate"));
                discount.setIsActive(rs.getBoolean("IsActive"));
                discount.setCreatedDate(rs.getTimestamp("CreatedDate"));
                discount.setVoucherCode(rs.getString("VoucherCode"));
                discount.setMinOrderAmount(rs.getBigDecimal("MinOrderAmount"));
                discount.setMaxDiscountAmount(rs.getBigDecimal("MaxDiscountAmount"));
                discount.setUsageLimit(rs.getObject("UsageLimit") != null ? rs.getInt("UsageLimit") : null);
                discount.setUsedCount(rs.getInt("UsedCount"));
                discount.setDiscountCategory(rs.getString("DiscountCategory"));
                discounts.add(discount);
            }
        } finally {
            dbContext.close(conn, pstmt, rs);
        }
        return discounts;
    }

    public Discount findById(UUID discountId) throws SQLException {
        String sql = "SELECT * FROM Discount WHERE DiscountId = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = dbContext.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, discountId.toString());
            rs = pstmt.executeQuery();
            if (rs.next()) {
                Discount discount = new Discount();
                discount.setDiscountId(UUID.fromString(rs.getString("DiscountId")));
                discount.setDiscountName(rs.getString("DiscountName"));
                discount.setDescription(rs.getString("Description"));
                discount.setDiscountType(rs.getString("DiscountType"));
                discount.setDiscountValue(rs.getBigDecimal("DiscountValue"));
                discount.setStartDate(rs.getDate("StartDate"));
                discount.setEndDate(rs.getDate("EndDate"));
                discount.setIsActive(rs.getBoolean("IsActive"));
                discount.setCreatedDate(rs.getTimestamp("CreatedDate"));
                discount.setVoucherCode(rs.getString("VoucherCode"));
                discount.setMinOrderAmount(rs.getBigDecimal("MinOrderAmount"));
                discount.setMaxDiscountAmount(rs.getBigDecimal("MaxDiscountAmount"));
                discount.setUsageLimit(rs.getObject("UsageLimit") != null ? rs.getInt("UsageLimit") : null);
                discount.setUsedCount(rs.getInt("UsedCount"));
                discount.setDiscountCategory(rs.getString("DiscountCategory"));
                return discount;
            }
            return null;
        } finally {
            dbContext.close(conn, pstmt, rs);
        }
    }

    public void save(Discount discount) throws SQLException {
        String sql = "INSERT INTO Discount (DiscountId, DiscountName, Description, DiscountType, DiscountValue, StartDate, EndDate, IsActive, CreatedDate, VoucherCode, MinOrderAmount, MaxDiscountAmount, UsageLimit, UsedCount, DiscountCategory) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = dbContext.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, discount.getDiscountId().toString());
            pstmt.setString(2, discount.getDiscountName());
            pstmt.setString(3, discount.getDescription());
            pstmt.setString(4, discount.getDiscountType());
            pstmt.setBigDecimal(5, discount.getDiscountValue());
            pstmt.setDate(6, new java.sql.Date(discount.getStartDate().getTime()));
            pstmt.setDate(7, new java.sql.Date(discount.getEndDate().getTime()));
            pstmt.setBoolean(8, discount.isIsActive());
            pstmt.setTimestamp(9, new java.sql.Timestamp(discount.getCreatedDate().getTime()));
            pstmt.setString(10, discount.getVoucherCode());
            pstmt.setBigDecimal(11, discount.getMinOrderAmount());
            pstmt.setBigDecimal(12, discount.getMaxDiscountAmount());
            pstmt.setObject(13, discount.getUsageLimit());
            pstmt.setInt(14, discount.getUsedCount());
            pstmt.setString(15, discount.getDiscountCategory());
            pstmt.executeUpdate();
        } finally {
            dbContext.close(conn, pstmt);
        }
    }

    public void update(Discount discount) throws SQLException {
        String sql = "UPDATE Discount SET DiscountName = ?, Description = ?, DiscountType = ?, DiscountValue = ?, StartDate = ?, EndDate = ?, IsActive = ?, VoucherCode = ?, MinOrderAmount = ?, MaxDiscountAmount = ?, UsageLimit = ?, UsedCount = ?, DiscountCategory = ? WHERE DiscountId = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = dbContext.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, discount.getDiscountName());
            pstmt.setString(2, discount.getDescription());
            pstmt.setString(3, discount.getDiscountType()); // Fixed typo: getDiscountfnType to getDiscountType
            pstmt.setBigDecimal(4, discount.getDiscountValue());
            pstmt.setDate(5, new java.sql.Date(discount.getStartDate().getTime()));
            pstmt.setDate(6, new java.sql.Date(discount.getEndDate().getTime()));
            pstmt.setBoolean(7, discount.isIsActive());
            pstmt.setString(8, discount.getVoucherCode());
            pstmt.setBigDecimal(9, discount.getMinOrderAmount());
            pstmt.setBigDecimal(10, discount.getMaxDiscountAmount());
            pstmt.setObject(11, discount.getUsageLimit());
            pstmt.setInt(12, discount.getUsedCount());
            pstmt.setString(13, discount.getDiscountCategory());
            pstmt.setString(14, discount.getDiscountId().toString());
            pstmt.executeUpdate();
        } finally {
            dbContext.close(conn, pstmt);
        }
    }

    public int delete(String discountId) throws SQLException {
        String sql = "DELETE FROM Discount WHERE DiscountId = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = dbContext.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, discountId);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows;
        } finally {
            dbContext.close(conn, pstmt);
        }
    }
}
