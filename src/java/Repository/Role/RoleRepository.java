package Repository.Role;

import Config.DBContext;
import Model.Entity.Role.Role;
import Repository.Interfaces.IRole.IRoleRepository;
import java.sql.*;
import java.util.*;

public class RoleRepository implements IRoleRepository {
    private final DBContext dbContext = new DBContext();

    @Override
    public List<Role> findAll() throws SQLException {
        List<Role> roles = new ArrayList<>();
        String sql = "SELECT * FROM Roles";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                roles.add(new Role(
                    UUID.fromString(rs.getString("RoleId")),
                    rs.getString("RoleName"),
                    rs.getString("NormalizedName")
                ));
            }
        }
        return roles;
    }

    @Override
    public Role findById(UUID id) throws SQLException {
        String sql = "SELECT * FROM Roles WHERE RoleId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id.toString());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Role(
                        UUID.fromString(rs.getString("RoleId")),
                        rs.getString("RoleName"),
                        rs.getString("NormalizedName")
                    );
                }
            }
        }
        return null;
    }

    @Override
    public Role findByRoleName(String roleName) throws SQLException {
        String sql = "SELECT * FROM Roles WHERE RoleName = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, roleName);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Role(
                        UUID.fromString(rs.getString("RoleId")),
                        rs.getString("RoleName"),
                        rs.getString("NormalizedName")
                    );
                }
            }
        }
        return null;
    }

    @Override
    public Role add(Role entity) throws SQLException {
        String sql = "INSERT INTO Roles (RoleId, RoleName, NormalizedName) VALUES (?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            UUID id = entity.getRoleId() != null ? entity.getRoleId() : UUID.randomUUID();
            ps.setString(1, id.toString());
            ps.setString(2, entity.getRoleName());
            ps.setString(3, entity.getNormalizedName());
            ps.executeUpdate();
            entity.setRoleId(id);
            return entity;
        }
    }

    @Override
    public boolean update(Role entity) throws SQLException {
        String sql = "UPDATE Roles SET RoleName = ?, NormalizedName = ? WHERE RoleId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, entity.getRoleName());
            ps.setString(2, entity.getNormalizedName());
            ps.setString(3, entity.getRoleId().toString());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(UUID id) throws SQLException {
        String sql = "DELETE FROM Roles WHERE RoleId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, id.toString());
            return ps.executeUpdate() > 0;
        }
    }
}
