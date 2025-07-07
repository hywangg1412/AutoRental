package Repository;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import Config.DBContext;
import Model.Entity.Notification;
import Repository.Interfaces.INotificationRepository;


public class NotificationRepository implements INotificationRepository {
    private final DBContext dbContext = new DBContext();

    @Override
    public Notification add(Notification entity) throws SQLException {
        String sql = "INSERT INTO Notification (NotificationId, UserId, Message, CreatedDate, IsRead) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getNotificationId());
            ps.setObject(2, entity.getUserId());
            ps.setString(3, entity.getMessage());
            ps.setTimestamp(4, Timestamp.valueOf(entity.getCreatedDate()));
            ps.setBoolean(5, entity.isRead());
            ps.executeUpdate();
            return entity;
        }
    }

    @Override
    public Notification findById(UUID id) throws SQLException {
        String sql = "SELECT * FROM Notification WHERE NotificationId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToNotification(rs);
                }
            }
        }
        return null;
    }

    @Override
    public boolean update(Notification entity) throws SQLException {
        String sql = "UPDATE Notification SET UserId = ?, Message = ?, CreatedDate = ?, IsRead = ? WHERE NotificationId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getUserId());
            ps.setString(2, entity.getMessage());
            ps.setTimestamp(3, Timestamp.valueOf(entity.getCreatedDate()));
            ps.setBoolean(4, entity.isRead());
            ps.setObject(5, entity.getNotificationId());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(UUID id) throws SQLException {
        String sql = "DELETE FROM Notification WHERE NotificationId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<Notification> findAll() throws SQLException {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM Notification ORDER BY CreatedDate DESC";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToNotification(rs));
            }
        }
        return list;
    }

    @Override
    public List<Notification> findByUserId(UUID userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM Notification WHERE UserId = ? ORDER BY CreatedDate DESC";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToNotification(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi truy vấn notification: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
    
    @Override
    public List<Notification> findUnreadByUserId(UUID userId) {
        List<Notification> list = new ArrayList<>();
        String sql = "SELECT * FROM Notification WHERE UserId = ? AND IsRead = 0 ORDER BY CreatedDate DESC";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToNotification(rs));
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi truy vấn notification chưa đọc: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }
    
    @Override
    public int countUnreadByUserId(UUID userId) {
        String sql = "SELECT COUNT(*) FROM Notification WHERE UserId = ? AND IsRead = 0";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi đếm notification chưa đọc: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    @Override
    public boolean markAsRead(UUID notificationId) {
        String sql = "UPDATE Notification SET IsRead = 1 WHERE NotificationId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, notificationId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi khi đánh dấu đã đọc notification: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    @Override
    public boolean markAllAsRead(UUID userId) {
        String sql = "UPDATE Notification SET IsRead = 1 WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi khi đánh dấu đã đọc tất cả notification: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private Notification mapResultSetToNotification(ResultSet rs) throws SQLException {
        String notificationIdStr = rs.getString("NotificationId");
        String userIdStr = rs.getString("UserId");
        UUID notificationId = null;
        UUID userId = null;
        
        try {
            notificationId = UUID.fromString(notificationIdStr);
        } catch (IllegalArgumentException e) {
            System.out.println("Lỗi chuyển đổi NotificationId: " + e.getMessage());
            notificationId = UUID.randomUUID(); // Fallback
        }
        
        try {
            userId = UUID.fromString(userIdStr);
        } catch (IllegalArgumentException e) {
            System.out.println("Lỗi chuyển đổi UserId: " + e.getMessage());
            userId = UUID.randomUUID(); // Fallback
        }
        
        String message = rs.getString("Message");
        LocalDateTime createdDate = rs.getTimestamp("CreatedDate").toLocalDateTime();
        boolean isRead = rs.getBoolean("IsRead");
        return new Notification(notificationId, userId, message, createdDate, isRead);
    }
} 