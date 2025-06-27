package Service;

import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

import Model.Entity.Notification;
import Repository.NotificationRepository;

public class NotificationService {
    private final NotificationRepository notificationRepository = new NotificationRepository();

    public Notification add(Notification notification) throws SQLException {
        return notificationRepository.add(notification);
    }

    public Notification findById(UUID id) throws SQLException {
        return notificationRepository.findById(id);
    }

    public List<Notification> findByUserId(UUID userId) {
        return notificationRepository.findByUserId(userId);
    }
    
    public List<Notification> findUnreadByUserId(UUID userId) {
        return notificationRepository.findUnreadByUserId(userId);
    }
    
    public int countUnreadByUserId(UUID userId) {
        return notificationRepository.countUnreadByUserId(userId);
    }
    
    public boolean markAsRead(UUID notificationId) {
        return notificationRepository.markAsRead(notificationId);
    }
    
    public boolean markAllAsRead(UUID userId) {
        return notificationRepository.markAllAsRead(userId);
    }

    public List<Notification> findAll() throws SQLException {
        return notificationRepository.findAll();
    }

    public boolean delete(UUID id) throws SQLException {
        return notificationRepository.delete(id);
    }

    public boolean update(Notification notification) throws SQLException {
        return notificationRepository.update(notification);
    }
} 