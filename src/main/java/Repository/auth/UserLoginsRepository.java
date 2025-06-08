package Repository.auth;

import Config.DBContext;
import Model.Entity.OAuth.UserLogins;
import Repository.Interfaces.IUserLoginsRepository;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class UserLoginsRepository implements IUserLoginsRepository {
    private DBContext dbContext = new DBContext();

    @Override
    public UserLogins add(UserLogins entity) throws SQLException {
        String sql = "INSERT INTO UserLogins (LoginProvider, ProviderKey, ProviderDisplayName, UserId) VALUES (?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, entity.getLoginProvider());
            st.setString(2, entity.getProviderKey());
            st.setString(3, entity.getProviderDisplayName());
            st.setObject(4, entity.getUserId());
            
            int affectedRows = st.executeUpdate();
            if (affectedRows > 0) {
                return findByProviderAndKey(entity.getLoginProvider(), entity.getProviderKey());
            }
        }
        return null;
    }

    @Override
    public UserLogins findById(UUID Id) throws SQLException {
        String sql = "SELECT * FROM UserLogins WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setObject(1, Id);
            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return mapResultSetToUserLogin(rs);
            }
        }
        return null;
    }

    @Override
    public boolean update(UserLogins entity) throws SQLException {
        String sql = "UPDATE UserLogins SET ProviderDisplayName = ? WHERE LoginProvider = ? AND ProviderKey = ? AND UserId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, entity.getProviderDisplayName());
            st.setString(2, entity.getLoginProvider());
            st.setString(3, entity.getProviderKey());
            st.setObject(4, entity.getUserId());
            
            int affectedRows = st.executeUpdate();
            return affectedRows > 0;
        }
    }

    @Override
    public boolean delete(UUID Id) throws SQLException {
        String sql = "DELETE FROM UserLogins WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setObject(1, Id);
            int affectedRows = st.executeUpdate();
            return affectedRows > 0;
        }
    }

    @Override
    public List<UserLogins> findAll() throws SQLException {
        List<UserLogins> userLogins = new ArrayList<>();
        String sql = "SELECT * FROM UserLogins";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                userLogins.add(mapResultSetToUserLogin(rs));
            }
        }
        return userLogins;
    }

    // Thêm các phương thức hỗ trợ
    @Override
    public UserLogins findByProviderAndKey(String provider, String key) throws SQLException {
        String sql = "SELECT * FROM UserLogins WHERE LoginProvider = ? AND ProviderKey = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, provider);
            st.setString(2, key);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    UserLogins userLogins = new UserLogins();
                    userLogins.setUserId(rs.getObject("UserId", java.util.UUID.class));
                    userLogins.setLoginProvider(rs.getString("LoginProvider"));
                    userLogins.setProviderKey(rs.getString("ProviderKey"));
                    userLogins.setProviderDisplayName(rs.getString("ProviderDisplayName"));
                    return userLogins;
                }
            }
        }
        return null;
    }

    public List<UserLogins> findByUserId(UUID userId) throws SQLException {
        List<UserLogins> userLogins = new ArrayList<>();
        String sql = "SELECT * FROM UserLogins WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setObject(1, userId);
            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                userLogins.add(mapResultSetToUserLogin(rs));
            }
        }
        return userLogins;
    }

    private UserLogins mapResultSetToUserLogin(ResultSet rs) throws SQLException {
        UserLogins userLogin = new UserLogins();
        userLogin.setLoginProvider(rs.getString("LoginProvider"));
        userLogin.setProviderKey(rs.getString("ProviderKey"));
        userLogin.setProviderDisplayName(rs.getString("ProviderDisplayName"));
        userLogin.setUserId(UUID.fromString(rs.getString("UserId")));
        return userLogin;
    }
    
}
