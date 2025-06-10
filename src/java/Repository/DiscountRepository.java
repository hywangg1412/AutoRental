package Repository;

import Config.DBContext;
import Model.Entity.Discount;
import Repository.Interfaces.IDiscountRepository;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

public class DiscountRepository implements IDiscountRepository{
    private DBContext dbContext;
    
    public DiscountRepository(){
        dbContext = new DBContext();
    }

    private Connection getConnection() throws SQLException {
        return dbContext.getConnection();
    }

    @Override
    public Discount add(Discount entity) throws SQLException {
        String sql = "INSERT INTO Discount (DiscountId, DiscountName, Description, DiscountType, DiscountValue, StartDate, EndDate, IsActive, CreatedDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getDiscountId());
            ps.setString(2, entity.getDiscountName());
            ps.setString(3, entity.getDescription());
            ps.setString(4, entity.getDiscountType());
            ps.setBigDecimal(5, entity.getDiscountValue());
            ps.setTimestamp(6, Timestamp.valueOf(entity.getStartDate()));
            ps.setTimestamp(7, Timestamp.valueOf(entity.getEndDate()));
            ps.setBoolean(8, entity.isActive());
            ps.setTimestamp(9, Timestamp.valueOf(entity.getCreatedDate()));
            ps.executeUpdate();
            return entity;
        }
    }

    @Override
    public Discount findById(UUID id) throws SQLException {
        String sql = "SELECT * FROM Discount WHERE DiscountId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDiscount(rs);
                }
            }
        }
        return null;
    }

    @Override
    public boolean update(Discount entity) throws SQLException {
        String sql = "UPDATE Discount SET DiscountName=?, Description=?, DiscountType=?, DiscountValue=?, StartDate=?, EndDate=?, IsActive=?, CreatedDate=? WHERE DiscountId=?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, entity.getDiscountName());
            ps.setString(2, entity.getDescription());
            ps.setString(3, entity.getDiscountType());
            ps.setBigDecimal(4, entity.getDiscountValue());
            ps.setTimestamp(5, Timestamp.valueOf(entity.getStartDate()));
            ps.setTimestamp(6, Timestamp.valueOf(entity.getEndDate()));
            ps.setBoolean(7, entity.isActive());
            ps.setTimestamp(8, Timestamp.valueOf(entity.getCreatedDate()));
            ps.setObject(9, entity.getDiscountId());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(UUID id) throws SQLException {
        String sql = "DELETE FROM Discount WHERE DiscountId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<Discount> findAll() throws SQLException {
        String sql = "SELECT * FROM Discount";
        List<Discount> list = new ArrayList<>();
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToDiscount(rs));
            }
        }
        return list;
    }

    private Discount mapResultSetToDiscount(ResultSet rs) throws SQLException {
        Discount d = new Discount();
        d.setDiscountId(UUID.fromString(rs.getString("DiscountId")));
        d.setDiscountName(rs.getString("DiscountName"));
        d.setDescription(rs.getString("Description"));
        d.setDiscountType(rs.getString("DiscountType"));
        d.setDiscountValue(rs.getBigDecimal("DiscountValue"));
        Timestamp start = rs.getTimestamp("StartDate");
        Timestamp end = rs.getTimestamp("EndDate");
        Timestamp created = rs.getTimestamp("CreatedDate");
        d.setStartDate(start != null ? start.toLocalDateTime() : null);
        d.setEndDate(end != null ? end.toLocalDateTime() : null);
        d.setActive(rs.getBoolean("IsActive"));
        d.setCreatedDate(created != null ? created.toLocalDateTime() : null);
        return d;
    }
}
