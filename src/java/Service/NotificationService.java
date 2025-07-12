package Service;

import Model.Entity.Notification;
import Model.Entity.User.User;
import Repository.Interfaces.INotificationRepository;
import Repository.NotificationRepository;
import Service.Role.RoleService;
import Service.User.UserService;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class NotificationService {
    private static final Logger LOGGER = Logger.getLogger(NotificationService.class.getName());
    private final INotificationRepository notificationRepository;
    private final UserService userService = new UserService();
    private final RoleService roleService = new RoleService();

    public NotificationService() {
        this.notificationRepository = new NotificationRepository();
    }

    /**
     * Thêm một thông báo vào database
     * @param notification Đối tượng thông báo cần thêm
     * @return Thông báo đã được thêm
     * @throws SQLException Nếu có lỗi khi thêm vào database
     */
    public Notification add(Notification notification) throws SQLException {
        return notificationRepository.add(notification);
    }

    /**
     * Tìm thông báo theo ID
     * @param id ID của thông báo
     * @return Thông báo nếu tìm thấy, null nếu không tìm thấy
     * @throws SQLException Nếu có lỗi khi truy vấn database
     */
    public Notification findById(UUID id) throws SQLException {
        return notificationRepository.findById(id);
    }

    /**
     * Tìm tất cả thông báo của một người dùng
     * @param userId ID của người dùng
     * @return Danh sách thông báo
     */
    public List<Notification> findByUserId(UUID userId) {
        return notificationRepository.findByUserId(userId);
    }
    
    /**
     * Tìm tất cả thông báo chưa đọc của một người dùng
     * @param userId ID của người dùng
     * @return Danh sách thông báo chưa đọc
     */
    public List<Notification> findUnreadByUserId(UUID userId) {
        return notificationRepository.findUnreadByUserId(userId);
    }
    
    /**
     * Đếm số lượng thông báo chưa đọc của một người dùng
     * @param userId ID của người dùng
     * @return Số lượng thông báo chưa đọc
     */
    public int countUnreadByUserId(UUID userId) {
        return notificationRepository.countUnreadByUserId(userId);
    }
    
    /**
     * Đánh dấu một thông báo là đã đọc
     * @param notificationId ID của thông báo
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean markAsRead(UUID notificationId) {
        return notificationRepository.markAsRead(notificationId);
    }
    
    /**
     * Đánh dấu tất cả thông báo của một người dùng là đã đọc
     * @param userId ID của người dùng
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean markAllAsRead(UUID userId) {
        return notificationRepository.markAllAsRead(userId);
    }
    
    /**
     * Xóa một thông báo theo ID
     * @param notificationId ID của thông báo cần xóa
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean deleteNotification(UUID notificationId) {
        return notificationRepository.deleteNotificationById(notificationId);
    }

    /**
     * Lấy tất cả thông báo
     * @return Danh sách tất cả thông báo
     * @throws SQLException Nếu có lỗi khi truy vấn database
     */
    public List<Notification> findAll() throws SQLException {
        return notificationRepository.findAll();
    }

    /**
     * Xóa một thông báo
     * @param id ID của thông báo
     * @return true nếu thành công, false nếu thất bại
     * @throws SQLException Nếu có lỗi khi truy vấn database
     */
    public boolean delete(UUID id) throws SQLException {
        return notificationRepository.delete(id);
    }

    /**
     * Cập nhật một thông báo
     * @param notification Thông báo cần cập nhật
     * @return true nếu thành công, false nếu thất bại
     * @throws SQLException Nếu có lỗi khi truy vấn database
     */
    public boolean update(Notification notification) throws SQLException {
        return notificationRepository.update(notification);
    }
    
    /**
     * Gửi thông báo cho một người dùng cụ thể
     * @param userId ID của người dùng nhận thông báo
     * @param message Nội dung thông báo
     * @return true nếu gửi thành công, false nếu thất bại
     */
    public boolean sendNotificationToUser(UUID userId, String message) {
        try {
            Notification notification = new Notification(
                UUID.randomUUID(),
                userId,
                message,
                LocalDateTime.now()
            );
            add(notification);
            return true;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi gửi thông báo cho user: " + userId, e);
            return false;
        }
    }
    
    /**
     * Gửi thông báo cho tất cả người dùng có vai trò nhất định
     * @param roleName Tên vai trò (ví dụ: "Staff", "Admin")
     * @param message Nội dung thông báo
     * @return Số lượng người dùng đã gửi thông báo thành công
     */
    public int sendNotificationToRole(String roleName, String message) {
        int successCount = 0;
        try {
            // Lấy role theo tên
            var role = roleService.findByRoleName(roleName);
            if (role == null) {
                LOGGER.log(Level.WARNING, "Không tìm thấy role: " + roleName);
                return 0;
            }
            
            // Lấy tất cả user có role này
            List<User> users = userService.findByRoleId(role.getRoleId());
            
            // Gửi thông báo cho từng user
            for (User user : users) {
                try {
                    Notification notification = new Notification(
                        UUID.randomUUID(),
                        user.getUserId(),
                        message,
                        LocalDateTime.now()
                    );
                    add(notification);
                    successCount++;
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Lỗi khi gửi thông báo cho user: " + user.getUserId(), e);
                }
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi gửi thông báo cho role: " + roleName, e);
        }
        return successCount;
    }
    
    /**
     * Gửi thông báo cho tất cả staff
     * @param message Nội dung thông báo
     * @return Số lượng staff đã gửi thông báo thành công
     */
    public int sendNotificationToAllStaff(String message) {
        return sendNotificationToRole("Staff", message);
    }
    
    /**
     * Gửi thông báo cho tất cả admin
     * @param message Nội dung thông báo
     * @return Số lượng admin đã gửi thông báo thành công
     */
    public int sendNotificationToAllAdmin(String message) {
        return sendNotificationToRole("Admin", message);
    }

    /**
     * Lưu thông báo mới
     * @param notification Đối tượng thông báo
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean saveNotification(Notification notification) {
        try {
            add(notification);
            return true;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lưu thông báo", e);
            return false;
        }
    }
} 