package Repository;

import Config.DBContext;
import Model.Entity.User;
import Repository.Interfaces.IUserRepository;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;
import java.util.UUID;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserRepository implements IUserRepository {

    private DBContext dbContext = new DBContext();

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
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public User add(User entity) throws SQLException {
        String sql = "INSERT INTO Users (UserId, Username, UserDOB, PhoneNumber, UserAddress, "
                + "UserDescription, AvatarUrl, Gender, FirstName, LastName, Status, CreatedDate, "
                + "NormalizedUserName, Email, NormalizedEmail, EmailVerifed, PasswordHash, "
                + "SecurityStamp, ConcurrencyStamp, TwoFactorEnabled, LockoutEnd, LockoutEnabled, "
                + "AccessFailedCount) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setObject(1, entity.getUserId());
            st.setString(2, entity.getUsername());
            st.setDate(3, entity.getUserDOB() != null ? java.sql.Date.valueOf(entity.getUserDOB()) : null);
            st.setString(4, entity.getPhoneNumber());
            st.setString(5, entity.getUserAddress());
            st.setString(6, entity.getUserDescription());
            st.setString(7, entity.getAvatarUrl());
            st.setString(8, entity.getGender());
            st.setString(9, entity.getFirstName());
            st.setString(10, entity.getLastName());
            st.setString(11, entity.getStatus());
            st.setTimestamp(12, entity.getCreatedDate() != null ? Timestamp.valueOf(entity.getCreatedDate()) : null);
            st.setString(13, entity.getNormalizedUserName());
            st.setString(14, entity.getEmail());
            st.setString(15, entity.getNormalizedEmail());
            st.setBoolean(16, entity.isEmailVerifed());
            st.setString(17, entity.getPasswordHash());
            st.setString(18, entity.getSecurityStamp());
            st.setString(19, entity.getConcurrencyStamp());
            st.setBoolean(20, entity.isTwoFactorEnabled());
            st.setTimestamp(21, entity.getLockoutEnd() != null ? Timestamp.valueOf(entity.getLockoutEnd()) : null);
            st.setBoolean(22, entity.isLockoutEnabled());
            st.setInt(23, entity.getAccessFailedCount());
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
        String sql = "UPDATE Users SET Username = ?, UserDOB = ?, PhoneNumber = ?, UserAddress = ?, "
                + "UserDescription = ?, AvatarUrl = ?, Gender = ?, FirstName = ?, LastName = ?, "
                + "Status = ?, CreatedDate = ?, NormalizedUserName = ?, Email = ?, "
                + "NormalizedEmail = ?, EmailVerifed = ?, PasswordHash = ?, SecurityStamp = ?, "
                + "ConcurrencyStamp = ?, TwoFactorEnabled = ?, LockoutEnd = ?, LockoutEnabled = ?, "
                + "AccessFailedCount = ? WHERE UserId = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, entity.getUsername());
            st.setDate(2, entity.getUserDOB() != null ? java.sql.Date.valueOf(entity.getUserDOB()) : null);
            st.setString(3, entity.getPhoneNumber());
            st.setString(4, entity.getUserAddress());
            st.setString(5, entity.getUserDescription());
            st.setString(6, entity.getAvatarUrl());
            st.setString(7, entity.getGender());
            st.setString(8, entity.getFirstName());
            st.setString(9, entity.getLastName());
            st.setString(10, entity.getStatus());
            st.setTimestamp(11, entity.getCreatedDate() != null ? Timestamp.valueOf(entity.getCreatedDate()) : null);
            st.setString(12, entity.getNormalizedUserName());
            st.setString(13, entity.getEmail());
            st.setString(14, entity.getNormalizedEmail());
            st.setBoolean(15, entity.isEmailVerifed());
            st.setString(16, entity.getPasswordHash());
            st.setString(17, entity.getSecurityStamp());
            st.setString(18, entity.getConcurrencyStamp());
            st.setBoolean(19, entity.isTwoFactorEnabled());
            st.setTimestamp(20, entity.getLockoutEnd() != null ? Timestamp.valueOf(entity.getLockoutEnd()) : null);
            st.setBoolean(21, entity.isLockoutEnabled());
            st.setInt(22, entity.getAccessFailedCount());
            st.setObject(23, entity.getUserId());
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
            System.out.println("Error While Finding Username and Password - " + ex.getMessage());
        }
        return null;
    }

    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(UUID.fromString(rs.getString("UserId")));
        user.setUsername(rs.getString("Username"));
        user.setUserDOB(rs.getDate("UserDOB") != null ? rs.getDate("UserDOB").toLocalDate() : null);
        user.setPhoneNumber(rs.getString("PhoneNumber"));
        user.setUserAddress(rs.getString("UserAddress"));
        user.setUserDescription(rs.getString("UserDescription"));
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
            e.printStackTrace();
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
            e.printStackTrace();
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
                Logger.getLogger(UserRepository.class.getName()).log(Level.SEVERE, null, ex);
            }
            return false;
        }

}
