package Repository.User;

import Config.DBContext;
import Model.Entity.User.User;
import Repository.Interfaces.IUser.IUserRepository;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import java.util.UUID;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserRepository implements IUserRepository {

    private static final Logger LOGGER = Logger.getLogger(UserRepository.class.getName());
    private final DBContext dbContext = new DBContext();

    @Override
    public User findByEmail(String email) {
        String sql = "SELECT * FROM Users WHERE Email = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToUser(rs);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding user by email: " + email, e);
        }
        return null;
    }

    @Override
    public User add(User entity) throws SQLException {
        String sql = "INSERT INTO Users (UserId, Username, UserDOB, PhoneNumber, "
                + "AvatarUrl, Gender, FirstName, LastName, Status, CreatedDate, "
                + "NormalizedUserName, Email, NormalizedEmail, EmailVerifed, PasswordHash, "
                + "SecurityStamp, ConcurrencyStamp, TwoFactorEnabled, LockoutEnd, LockoutEnabled, "
                + "AccessFailedCount) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setObject(1, entity.getUserId());
            st.setString(2, entity.getUsername());
            st.setDate(3, entity.getUserDOB() != null ? java.sql.Date.valueOf(entity.getUserDOB()) : null);
            st.setString(4, entity.getPhoneNumber());
            st.setString(5, entity.getAvatarUrl());
            st.setString(6, entity.getGender());
            st.setString(7, entity.getFirstName());
            st.setString(8, entity.getLastName());
            st.setString(9, entity.getStatus());
            st.setTimestamp(10, entity.getCreatedDate() != null ? Timestamp.valueOf(entity.getCreatedDate()) : null);
            st.setString(11, entity.getNormalizedUserName());
            st.setString(12, entity.getEmail());
            st.setString(13, entity.getNormalizedEmail());
            st.setBoolean(14, entity.isEmailVerifed());
            st.setString(15, entity.getPasswordHash());
            st.setString(16, entity.getSecurityStamp());
            st.setString(17, entity.getConcurrencyStamp());
            st.setBoolean(18, entity.isTwoFactorEnabled());
            st.setTimestamp(19, entity.getLockoutEnd() != null ? Timestamp.valueOf(entity.getLockoutEnd()) : null);
            st.setBoolean(20, entity.isLockoutEnabled());
            st.setInt(21, entity.getAccessFailedCount());
            int affectedRows = st.executeUpdate();
            if (affectedRows > 0) {
                return findById(entity.getUserId());
            }
        }
        return null;
    }

    public User findById(UUID userId) throws SQLException {
        String sql = "SELECT * FROM Users WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {

            st.setObject(1, userId);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        }
        return null;
    }

    @Override
    public boolean update(User entity) throws SQLException {
        String sql = "UPDATE Users SET Username = ?, UserDOB = ?, PhoneNumber = ?, "
                + "AvatarUrl = ?, Gender = ?, FirstName = ?, LastName = ?, "
                + "Status = ?, CreatedDate = ?, NormalizedUserName = ?, Email = ?, "
                + "NormalizedEmail = ?, EmailVerifed = ?, PasswordHash = ?, SecurityStamp = ?, "
                + "ConcurrencyStamp = ?, TwoFactorEnabled = ?, LockoutEnd = ?, LockoutEnabled = ?, "
                + "AccessFailedCount = ? WHERE UserId = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, entity.getUsername());
            st.setDate(2, entity.getUserDOB() != null ? java.sql.Date.valueOf(entity.getUserDOB()) : null);
            st.setString(3, entity.getPhoneNumber());
            st.setString(4, entity.getAvatarUrl());
            st.setString(5, entity.getGender());
            st.setString(6, entity.getFirstName());
            st.setString(7, entity.getLastName());
            st.setString(8, entity.getStatus());
            st.setTimestamp(9, entity.getCreatedDate() != null ? Timestamp.valueOf(entity.getCreatedDate()) : null);
            st.setString(10, entity.getNormalizedUserName());
            st.setString(11, entity.getEmail());
            st.setString(12, entity.getNormalizedEmail());
            st.setBoolean(13, entity.isEmailVerifed());
            st.setString(14, entity.getPasswordHash());
            st.setString(15, entity.getSecurityStamp());
            st.setString(16, entity.getConcurrencyStamp());
            st.setBoolean(17, entity.isTwoFactorEnabled());
            st.setTimestamp(18, entity.getLockoutEnd() != null ? Timestamp.valueOf(entity.getLockoutEnd()) : null);
            st.setBoolean(19, entity.isLockoutEnabled());
            st.setInt(20, entity.getAccessFailedCount());
            st.setObject(21, entity.getUserId());
            int affectedRows = st.executeUpdate();
            return affectedRows > 0;
        }
    }

    @Override
    public boolean delete(UUID userId) throws SQLException {
        String sql = "DELETE FROM Users WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setObject(1, userId);
            int affectedRows = st.executeUpdate();
            return affectedRows > 0;
        }
    }

    @Override
    public List<User> findAll() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM Users";

        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql); ResultSet rs = st.executeQuery()) {

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        }
        return users;
    }

    public User findByUsernameAndPassword(String username, String passwordHash) {
        String sql = "SELECT * FROM Users WHERE Username = ? AND PasswordHash = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {

            st.setString(1, username);
            st.setString(2, passwordHash);

            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToUser(rs);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding user by username and password for username: " + username, ex);
        }
        return null;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(UUID.fromString(rs.getString("UserId")));
        user.setUsername(rs.getString("Username"));
        user.setUserDOB(rs.getDate("UserDOB") != null ? rs.getDate("UserDOB").toLocalDate() : null);
        user.setPhoneNumber(rs.getString("PhoneNumber"));
        user.setAvatarUrl(rs.getString("AvatarUrl"));
        user.setGender(rs.getString("Gender"));
        user.setFirstName(rs.getString("FirstName"));
        user.setLastName(rs.getString("LastName"));
        user.setStatus(rs.getString("Status"));
        user.setCreatedDate(rs.getTimestamp("CreatedDate") != null ? rs.getTimestamp("CreatedDate").toLocalDateTime() : null);
        user.setNormalizedUserName(rs.getString("NormalizedUserName"));
        user.setEmail(rs.getString("Email"));
        user.setNormalizedEmail(rs.getString("NormalizedEmail"));
        user.setEmailVerifed(rs.getBoolean("EmailVerifed"));
        user.setPasswordHash(rs.getString("PasswordHash"));
        user.setSecurityStamp(rs.getString("SecurityStamp"));
        user.setConcurrencyStamp(rs.getString("ConcurrencyStamp"));
        user.setTwoFactorEnabled(rs.getBoolean("TwoFactorEnabled"));
        user.setLockoutEnd(rs.getTimestamp("LockoutEnd") != null ? rs.getTimestamp("LockoutEnd").toLocalDateTime() : null);
        user.setLockoutEnabled(rs.getBoolean("LockoutEnabled"));
        user.setAccessFailedCount(rs.getInt("AccessFailedCount"));
        return user;
    }

    @Override
    public boolean updateUserInfo(UUID userId, String username, String dob, String gender) {
        String sql = "UPDATE Users SET Username = ?, UserDOB = ?, Gender = ? WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            if (dob != null && !dob.isEmpty()) {
                ps.setDate(2, java.sql.Date.valueOf(dob));
            } else {
                ps.setNull(2, java.sql.Types.DATE);
            }
            ps.setString(3, gender);
            ps.setObject(4, userId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating user info in repository for userId: " + userId, e);
            return false;
        }
    }

    @Override
    public boolean updatePhoneNumber(UUID userId, String phoneNumber) {
        String sql = "UPDATE Users SET PhoneNumber = ? WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, phoneNumber);
            ps.setObject(2, userId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating phone number in repository for userId: " + userId, e);
            return false;
        }
    }

    @Override
    public boolean updateUserAvatar(UUID userId, String avatarUrl) {
        String sql = "UPDATE Users SET AvatarUrl = ? WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, avatarUrl);
            ps.setObject(2, userId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error updating user avatar in repository for userId: " + userId, ex);
        }
        return false;
    }

    public boolean updateStatus(UUID userId, String status) throws SQLException {
        String sql = "UPDATE Users SET Status = ? WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, status);
            st.setObject(2, userId);
            int affectedRows = st.executeUpdate();
            return affectedRows > 0;
        }
    }

    @Override
    public boolean anonymize(UUID userId) {
        String sql = "UPDATE Users SET " +
                     "Username = ?, " +
                     "Email = ?, " +
                     "PhoneNumber = NULL, " +
                     "AvatarUrl = NULL, " +
                     "FirstName = NULL, " +
                     "LastName = NULL, " +
                     "UserDOB = NULL, " +
                     "PasswordHash = ?, " +
                     "SecurityStamp = ? " +
                     "WHERE UserId = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            String uniqueId = userId.toString().substring(0, 8);
            st.setString(1, "deleted_user_" + uniqueId);
            st.setString(2, "deleted_" + uniqueId + "@deleted.com");
            st.setString(3, "ANONYMIZED_PASSWORD_" + UUID.randomUUID().toString());
            st.setString(4, UUID.randomUUID().toString());
            st.setObject(5, userId);

            int affectedRows = st.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error during user anonymization in repository for userId: " + userId, e);
            return false;
        }
    }

}
