package Repository.Auth;

import Config.DBContext;
import Model.Entity.OAuth.EmailOTPVerification;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.time.LocalDateTime;
import java.sql.Timestamp;
import Repository.Interfaces.IAuth.IEmailOTPVerificationRepository;

public class EmailOTPVerificationRepository implements IEmailOTPVerificationRepository {

    private DBContext dbContext;

    public EmailOTPVerificationRepository() {
        this.dbContext = new DBContext();
    }

    @Override
    public EmailOTPVerification findByOTP(String otp) {
        String sql = "SELECT * FROM EmailOTPVerification WHERE OTP = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, otp);
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
    public EmailOTPVerification findByUserId(UUID userId) {
        String sql = "SELECT * FROM EmailOTPVerification WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
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
        String sql = "DELETE FROM EmailOTPVerification WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setObject(1, userId);
            st.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error deleting email verification tokens by user ID: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public EmailOTPVerification add(EmailOTPVerification entity) throws SQLException {
        String sql = "INSERT INTO EmailOTPVerification (Id, OTP, ExpiryTime, IsUsed, UserId, CreatedAt, ResendCount, LastResendTime, ResendBlockUntil) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setObject(1, entity.getId());
            st.setString(2, entity.getOtp());
            st.setObject(3, entity.getExpiryTime());
            st.setBoolean(4, entity.isIsUsed());
            st.setObject(5, entity.getUserId());
            st.setObject(6, entity.getCreatedAt());
            st.setInt(7, entity.getResendCount());
            st.setObject(8, entity.getLastResendTime());
            st.setObject(9, entity.getResendBlockUntil());
            int affectedRows = st.executeUpdate();
            if (affectedRows > 0) {
                return findById(entity.getId());
            }
        }
        return null;
    }

    @Override
    public EmailOTPVerification findById(UUID Id) throws SQLException {
        String sql = "SELECT * FROM EmailOTPVerification WHERE Id = ?";
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
    public boolean update(EmailOTPVerification entity) throws SQLException {
        String sql = "UPDATE EmailOTPVerification SET OTP=?, ExpiryTime=?, IsUsed=?, UserId=?, CreatedAt=?, ResendCount=?, LastResendTime=?, ResendBlockUntil=? WHERE Id=?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, entity.getOtp());
            st.setObject(2, entity.getExpiryTime());
            st.setBoolean(3, entity.isIsUsed());
            st.setObject(4, entity.getUserId());
            st.setObject(5, entity.getCreatedAt());
            st.setInt(6, entity.getResendCount());
            st.setObject(7, entity.getLastResendTime());
            st.setObject(8, entity.getResendBlockUntil());
            st.setObject(9, entity.getId());
            int affectedRows = st.executeUpdate();
            return affectedRows > 0;
        }
    }

    @Override
    public boolean delete(UUID Id) throws SQLException {
        String sql = "DELETE FROM EmailOTPVerification WHERE Id = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setObject(1, Id);
            int affectedRows = st.executeUpdate();
            return affectedRows > 0;
        }
    }

    @Override
    public List<EmailOTPVerification> findAll() throws SQLException {
        List<EmailOTPVerification> list = new ArrayList<>();
        String sql = "SELECT * FROM EmailOTPVerification";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql); ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToToken(rs));
            }
        }
        return list;
    }

    private EmailOTPVerification mapResultSetToToken(ResultSet rs) throws SQLException {
        EmailOTPVerification token = new EmailOTPVerification();
        token.setId(UUID.fromString(rs.getString("Id")));
        token.setOtp(rs.getString("OTP"));
        token.setExpiryTime(rs.getTimestamp("ExpiryTime").toLocalDateTime());
        token.setIsUsed(rs.getBoolean("IsUsed"));
        token.setUserId(UUID.fromString(rs.getString("UserId")));
        token.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
        token.setResendCount(rs.getInt("ResendCount"));
        Timestamp lastResend = rs.getTimestamp("LastResendTime");
        token.setLastResendTime(lastResend != null ? lastResend.toLocalDateTime() : null);
        Timestamp blockUntil = rs.getTimestamp("ResendBlockUntil");
        token.setResendBlockUntil(blockUntil != null ? blockUntil.toLocalDateTime() : null);
        return token;
    }
}
