package Repository;

import Config.DBContext;
import Model.Entity.OAuth.PasswordResetToken;
import Repository.Interfaces.IPasswordResetToken;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class PasswordResetTokenRepository implements IPasswordResetToken {

    private DBContext dbContext;

    public PasswordResetTokenRepository() {
        dbContext = new DBContext();
    }

    @Override
    public void add(PasswordResetToken entity) throws SQLException {
        String sql = "INSERT INTO PasswordResetTokens (Id, Token, ExpiryTime, IsUsed, UserId, CreatedAt) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setObject(1, entity.getId());
            st.setString(2, entity.getToken());
            st.setObject(3, entity.getExpiryTime());
            st.setBoolean(4, entity.isIsUsed());
            st.setObject(5, entity.getUserId());
            st.setObject(6, entity.getCreatedAt());
            st.executeUpdate();
        }
    }

    @Override
    public PasswordResetToken findById(UUID Id) throws SQLException {
        String sql = "SELECT * FROM PasswordResetTokens WHERE Id = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setObject(1, Id);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToToken(rs);
                }
            }
        }
        return null;
    }

    @Override
    public void update(PasswordResetToken entity) throws SQLException {
        String sql = "UPDATE PasswordResetTokens SET Token=?, ExpiryTime=?, IsUsed=?, UserId=?, CreatedAt=? WHERE Id=?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, entity.getToken());
            st.setObject(2, entity.getExpiryTime());
            st.setBoolean(3, entity.isIsUsed());
            st.setObject(4, entity.getUserId());
            st.setObject(5, entity.getCreatedAt());
            st.setObject(6, entity.getId());
            st.executeUpdate();
        }
    }

    @Override
    public void delete(UUID Id) throws SQLException {
        String sql = "DELETE FROM PasswordResetTokens WHERE Id = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setObject(1, Id);
            st.executeUpdate();
        }
    }

    @Override
    public List<PasswordResetToken> findAll() throws SQLException {
        List<PasswordResetToken> list = new ArrayList<>();
        String sql = "SELECT * FROM PasswordResetTokens";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToToken(rs));
            }
        }
        return list;
    }

    @Override
    public PasswordResetToken findByToken(String token) {
        String sql = "SELECT * FROM PasswordResetTokens WHERE Token = ?";
        try (
                Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, token);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToToken(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving token: " + e.getMessage());
            e.printStackTrace();
        }

        return null;
    }

    private PasswordResetToken mapResultSetToToken(ResultSet rs) throws SQLException {
        PasswordResetToken token = new PasswordResetToken();
        token.setId(UUID.fromString(rs.getString("Id")));
        token.setToken(rs.getString("Token"));
        token.setExpiryTime(rs.getTimestamp("ExpiryTime").toLocalDateTime());
        token.setIsUsed(rs.getBoolean("IsUsed"));
        token.setUserId(UUID.fromString(rs.getString("UserId")));
        token.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
        return token;
    }

}
