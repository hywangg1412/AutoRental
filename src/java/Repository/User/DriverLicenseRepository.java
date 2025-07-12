package Repository.User;

import Config.DBContext;
import Model.Entity.User.DriverLicense;
import Repository.Interfaces.IUser.IDriverLicenseRepository;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.*;

public class DriverLicenseRepository implements IDriverLicenseRepository {
    private final DBContext dbContext = new DBContext();

    @Override
    public DriverLicense add(DriverLicense entity) throws SQLException {
        String sql = "INSERT INTO DriverLicenses (LicenseId, UserId, LicenseNumber, FullName, DOB, LicenseImage, CreatedDate) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setInsertParams(ps, entity);
            int affected = ps.executeUpdate();
            return affected > 0 ? entity : null;
        } catch (SQLException e) {
            System.err.println("Error adding DriverLicense: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public DriverLicense findById(UUID id) throws SQLException {
        String sql = "SELECT * FROM DriverLicenses WHERE LicenseId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id != null ? id.toString() : null);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDriverLicense(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error finding DriverLicense by id: " + e.getMessage());
            throw e;
        }
        return null;
    }

    @Override
    public boolean update(DriverLicense entity) throws SQLException {
        String sql = "UPDATE DriverLicenses SET LicenseNumber=?, FullName=?, DOB=?, LicenseImage=? WHERE LicenseId=?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            setUpdateParams(ps, entity);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating DriverLicense: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public boolean delete(UUID id) throws SQLException {
        String sql = "DELETE FROM DriverLicenses WHERE LicenseId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id != null ? id.toString() : null);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting DriverLicense: " + e.getMessage());
            throw e;
        }
    }

    @Override
    public List<DriverLicense> findAll() throws SQLException {
        List<DriverLicense> list = new ArrayList<>();
        String sql = "SELECT * FROM DriverLicenses";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToDriverLicense(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error finding all DriverLicenses: " + e.getMessage());
            throw e;
        }
        return list;
    }

    public DriverLicense findByUserId(UUID userId) throws SQLException {
        String sql = "SELECT * FROM DriverLicenses WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId != null ? userId.toString() : null);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDriverLicense(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error finding DriverLicense by userId: " + e.getMessage());
            throw e;
        }
        return null;
    }

    private void setInsertParams(PreparedStatement ps, DriverLicense entity) throws SQLException {
        ps.setString(1, entity.getLicenseId() != null ? entity.getLicenseId().toString() : null);
        ps.setString(2, entity.getUserId() != null ? entity.getUserId().toString() : null);
        ps.setString(3, entity.getLicenseNumber());
        ps.setString(4, entity.getFullName());
        if (entity.getDob() != null) {
            ps.setDate(5, java.sql.Date.valueOf(entity.getDob()));
        } else {
            ps.setNull(5, java.sql.Types.DATE);
        }
        ps.setString(6, entity.getLicenseImage());
        ps.setTimestamp(7, entity.getCreatedDate() != null ? java.sql.Timestamp.valueOf(entity.getCreatedDate()) : java.sql.Timestamp.valueOf(java.time.LocalDateTime.now()));
    }

    private void setUpdateParams(PreparedStatement ps, DriverLicense entity) throws SQLException {
        ps.setString(1, entity.getLicenseNumber());
        ps.setString(2, entity.getFullName());
        if (entity.getDob() != null) {
            ps.setDate(3, java.sql.Date.valueOf(entity.getDob()));
        } else {
            ps.setNull(3, java.sql.Types.DATE);
        }
        ps.setString(4, entity.getLicenseImage());
        ps.setString(5, entity.getLicenseId() != null ? entity.getLicenseId().toString() : null);
    }

    private DriverLicense mapResultSetToDriverLicense(ResultSet rs) throws SQLException {
        DriverLicense dl = new DriverLicense();
        dl.setLicenseId(UUID.fromString(rs.getString("LicenseId")));
        dl.setUserId(UUID.fromString(rs.getString("UserId")));
        dl.setLicenseNumber(rs.getString("LicenseNumber"));
        dl.setFullName(rs.getString("FullName"));
        java.sql.Date dob = rs.getDate("DOB");
        dl.setDob(dob != null ? dob.toLocalDate() : null);
        dl.setLicenseImage(rs.getString("LicenseImage"));
        Timestamp created = rs.getTimestamp("CreatedDate");
        dl.setCreatedDate(created != null ? created.toLocalDateTime() : null);
        return dl;
    }
}
