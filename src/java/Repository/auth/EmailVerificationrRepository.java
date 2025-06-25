package Repository.Auth;

import Config.DBContext;
import Model.Entity.OAuth.EmailVerificationToken;
import Repository.Interfaces.IAuth.IEmailVerificationTokenRepository;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class EmailVerificationrRepository implements IEmailVerificationTokenRepository {

    private DBContext dbContext;

    public EmailVerificationrRepository() {
        dbContext = new DBContext();
    }

    @Override
    public EmailVerificationToken findByToken(String token) {
        String sql = "SELECT * FROM EmailVerificationTokens WHERE Token = ?";
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, token);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToToken(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving email verification token: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public EmailVerificationToken findByUserId(UUID userId) {
        String sql = "SELECT * FROM EmailVerificationTokens WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setObject(1, userId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToToken(rs);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error retrieving email verification token by user ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public void deleteByUserId(UUID userId) {
        String sql = "DELETE FROM EmailVerificationTokens WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setObject(1, userId);
            st.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error deleting email verification tokens by user ID: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public EmailVerificationToken add(EmailVerificationToken entity) throws SQLException {
        String sql = "INSERT INTO EmailVerificationTokens (Id, Token, ExpiryTime, IsUsed, UserId, CreatedAt) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setObject(1, entity.getId());
            st.setString(2, entity.getToken());
            st.setObject(3, entity.getExpiryTime());
            st.setBoolean(4, entity.isIsUsed());
            st.setObject(5, entity.getUserId());
            st.setObject(6, entity.getCreatedAt());
            int affectedRows = st.executeUpdate();
            if (affectedRows > 0) {
                return findById(entity.getId());
            }
        }
        return null;
    }

    @Override
    public EmailVerificationToken findById(UUID Id) throws SQLException {
        String sql = "SELECT * FROM EmailVerificationTokens WHERE Id = ?";
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement st = conn.prepareStatement(sql)) {
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
    public boolean update(EmailVerificationToken entity) throws SQLException {
        String sql = "UPDATE EmailVerificationTokens SET Token=?, ExpiryTime=?, IsUsed=?, UserId=?, CreatedAt=? WHERE Id=?";
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, entity.getToken());
            st.setObject(2, entity.getExpiryTime());
            st.setBoolean(3, entity.isIsUsed());
            st.setObject(4, entity.getUserId());
            st.setObject(5, entity.getCreatedAt());
            st.setObject(6, entity.getId());
            int affectedRows = st.executeUpdate();
            return affectedRows > 0;
        }
    }

    @Override
    public boolean delete(UUID Id) throws SQLException {
        String sql = "DELETE FROM EmailVerificationTokens WHERE Id = ?";
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setObject(1, Id);
            int affectedRows = st.executeUpdate();
            return affectedRows > 0;
        }
    }

    @Override
    public List<EmailVerificationToken> findAll() throws SQLException {
        List<EmailVerificationToken> list = new ArrayList<>();
        String sql = "SELECT * FROM EmailVerificationTokens";
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement st = conn.prepareStatement(sql); 
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToToken(rs));
            }
        }
        return list;
    }

    private EmailVerificationToken mapResultSetToToken(ResultSet rs) throws SQLException {
        EmailVerificationToken token = new EmailVerificationToken();
        token.setId(UUID.fromString(rs.getString("Id")));
        token.setToken(rs.getString("Token"));
        token.setExpiryTime(rs.getTimestamp("ExpiryTime").toLocalDateTime());
        token.setIsUsed(rs.getBoolean("IsUsed"));
        token.setUserId(UUID.fromString(rs.getString("UserId")));
        token.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
        return token;
    }
}
