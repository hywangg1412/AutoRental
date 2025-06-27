package Repository.Interfaces;

import java.util.List;
import java.util.UUID;

import Model.Entity.Notification;

public interface INotificationRepository extends Repository<Notification, UUID> {
    List<Notification> findByUserId(UUID userId);
    List<Notification> findUnreadByUserId(UUID userId);
    int countUnreadByUserId(UUID userId);
    boolean markAsRead(UUID notificationId);
    boolean markAllAsRead(UUID userId);
} 