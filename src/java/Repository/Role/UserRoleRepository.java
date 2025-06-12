package Repository.Role;

import Config.DBContext;
import Model.Entity.Role.UserRole;
import Repository.Interfaces.IRole.IUserRoleRepository;
import java.sql.*;
import java.util.*;

public class UserRoleRepository implements IUserRoleRepository {

    private final DBContext dbContext;

    public UserRoleRepository() {
        dbContext = new DBContext();
    }

    public Connection getConnection() throws SQLException {
        return dbContext.getConnection();
    }

    @Override
    public List<UserRole> findAll() throws SQLException {
        List<UserRole> userRoles = new ArrayList<>();
        String sql = "SELECT * FROM UserRoles";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                userRoles.add(new UserRole(
                        UUID.fromString(rs.getString("UserId")),
                        UUID.fromString(rs.getString("RoleId"))
                ));
            }
        }
        return userRoles;
    }

    public UserRole findById(UUID userId, UUID roleId) throws SQLException {
        String sql = "SELECT * FROM UserRoles WHERE UserId = ? AND RoleId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId.toString());
            ps.setString(2, roleId.toString());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new UserRole(
                            UUID.fromString(rs.getString("UserId")),
                            UUID.fromString(rs.getString("RoleId"))
                    );
                }
            }
        }
        return null;
    }

    @Override
    public UserRole findByUserId(UUID userId) throws SQLException {
        String sql = "SELECT * FROM UserRoles WHERE UserId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId.toString());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    return new UserRole(
                            UUID.fromString(rs.getString("UserId")),
                            UUID.fromString(rs.getString("RoleId"))
                    );
                }
            }
        }
        return null;
    }

    @Override
    public List<UserRole> findByRoleId(UUID roleId) throws SQLException {
        List<UserRole> userRoles = new ArrayList<>();
        String sql = "SELECT * FROM UserRoles WHERE RoleId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roleId.toString());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    userRoles.add(new UserRole(
                            UUID.fromString(rs.getString("UserId")),
                            UUID.fromString(rs.getString("RoleId"))
                    ));
                }
            }
        }
        return userRoles;
    }

    @Override
    public UserRole add(UserRole entity) throws SQLException {
        String sql = "INSERT INTO UserRoles (UserId, RoleId) VALUES (?, ?)";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, entity.getUserId().toString());
            ps.setString(2, entity.getRoleId().toString());
            ps.executeUpdate();
            return entity;
        }
    }

    public boolean delete(UUID userId, UUID roleId) throws SQLException {
        String sql = "DELETE FROM UserRoles WHERE UserId = ? AND RoleId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId.toString());
            ps.setString(2, roleId.toString());
            return ps.executeUpdate() > 0;
        }
    }

     @Override
    public boolean existsByUserIdAndRoleId(UUID userId, UUID roleId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM UserRoles WHERE UserId = ? AND RoleId = ?";
        try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId.toString());
            ps.setString(2, roleId.toString());
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        }
    }
    
    // Không implement 3 method này vì UserRole chỉ có 2 trường là khóa chính, không có trường nào để update
    @Override
    public boolean update(UserRole entity) throws SQLException {
        throw new UnsupportedOperationException("Update is not supported for UserRoles composite key.");
    }

    public UserRole findById(UUID Id) throws SQLException {
        throw new UnsupportedOperationException("Update is not supported for UserRoles composite key.");
    }

    public boolean delete(UUID Id) throws SQLException {
        throw new UnsupportedOperationException("Update is not supported for UserRoles composite key.");

    }

   
}
