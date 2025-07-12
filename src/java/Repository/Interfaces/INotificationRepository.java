package Repository.Interfaces;

import Model.Entity.Notification;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public interface INotificationRepository {
    Notification add(Notification entity) throws SQLException;
    Notification findById(UUID id) throws SQLException;
    boolean update(Notification entity) throws SQLException;
    boolean delete(UUID id) throws SQLException;
    List<Notification> findAll() throws SQLException;
    List<Notification> findByUserId(UUID userId);
    List<Notification> findUnreadByUserId(UUID userId);
    int countUnreadByUserId(UUID userId);
    boolean markAsRead(UUID notificationId);
    boolean markAllAsRead(UUID userId);
    boolean deleteNotificationById(UUID notificationId);
} 