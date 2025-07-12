package Filter;

import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;

import Model.Entity.Notification;
import Model.Entity.User.User;
import Service.NotificationService;
import Utils.SessionUtil;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

/**
 * Filter để cập nhật thông báo cho người dùng trong session
 * Áp dụng cho tất cả các URL của user
 */
@WebFilter(urlPatterns = {"/pages/user/*", "/user/*", "/user/profile", "/pages/car/*", "/pages/booking-form/*", "/booking-form/*", "/notifications"})
public class UserNotificationFilter implements Filter {
    private final NotificationService notificationService = new NotificationService();
    private final DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss");

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // Set character encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpServletRequest httpReq = (HttpServletRequest) request;
        HttpSession session = httpReq.getSession(false);
        
        // Lấy user object từ session
        User user = (User) SessionUtil.getSessionAttribute(httpReq, "user");
        UUID userId = (user != null) ? user.getUserId() : null;
        
        if (userId != null) {
            try {
                // Lấy số lượng thông báo chưa đọc
                int unreadCount = notificationService.countUnreadByUserId(userId);
                
                // Lưu vào session để hiển thị trong navbar
                session.setAttribute("userUnreadCount", unreadCount);
                
                // Nếu đang ở trang thông báo, lấy tất cả thông báo
                String requestURI = httpReq.getRequestURI();
                if (requestURI.contains("/notifications")) {
                    // Đã được xử lý trong NotificationServlet, không cần làm gì thêm
                } else {
                    // Nếu không phải trang thông báo, chỉ lấy 5 thông báo mới nhất để hiển thị trong dropdown
                    List<Notification> recentNotifications = notificationService.findByUserId(userId);
                    if (recentNotifications.size() > 5) {
                        recentNotifications = recentNotifications.subList(0, 5);
                    }
                    
                    // Định dạng ngày giờ cho mỗi thông báo trước khi đưa vào session
                    for (Notification notification : recentNotifications) {
                        if (notification.getCreatedDate() != null) {
                            notification.setMessage(notification.getMessage());
                        }
                    }
                    
                    session.setAttribute("userNotifications", recentNotifications);
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        
        chain.doFilter(request, response); // Tiếp tục xử lý request
    }
} 