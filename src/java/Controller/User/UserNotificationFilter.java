package Controller.User;

import Model.Entity.Notification;
import Service.NotificationService;
import Utils.SessionUtil;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebFilter({
    "/pages/*",
    "/user/*",
    "/pages/home",
    "/pages/car"
}) 
public class UserNotificationFilter implements Filter {
    private final NotificationService notificationService = new NotificationService();

    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
            throws IOException, ServletException {
        HttpServletRequest request = (HttpServletRequest) servletRequest;

        Object sessionValue = SessionUtil.getSessionAttribute(request, "userId");
        UUID userId = null;
        if (sessionValue instanceof UUID) {
            userId = (UUID) sessionValue;
        } else if (sessionValue instanceof String) {
            try {
                userId = UUID.fromString((String) sessionValue);
            } catch (Exception e) {
                userId = null;
            }
        }

        if (userId != null) {
            try {
                // Kiểm tra xem notification đã có trong session chưa
                List<Notification> notifications = (List<Notification>) request.getSession().getAttribute("userNotifications");
                Integer unreadCount = (Integer) request.getSession().getAttribute("userUnreadCount");
                
                // Nếu chưa có trong session hoặc cần refresh
                if (notifications == null || unreadCount == null) {
                    notifications = notificationService.findByUserId(userId);
                    unreadCount = notificationService.countUnreadByUserId(userId);
                    
                    // Lưu vào session
                    request.getSession().setAttribute("userNotifications", notifications);
                    request.getSession().setAttribute("userUnreadCount", unreadCount);
                }
                
                // Set vào request attribute để JSP có thể sử dụng
                request.setAttribute("notifications", notifications);
                request.setAttribute("unreadCount", unreadCount);
                
                System.out.println("UserId in filter: " + userId);
                System.out.println("Notifications found: " + (notifications != null ? notifications.size() : "null"));
                System.out.println("Unread count: " + unreadCount);
            } catch (Exception e) {
                System.out.println("Error loading notifications: " + e.getMessage());
                e.printStackTrace();
            }
        }

        filterChain.doFilter(servletRequest, servletResponse);
    }
}
