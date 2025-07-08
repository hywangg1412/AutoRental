
package Controller.User;

import Model.Entity.Notification;
import Service.NotificationService;
import Utils.SessionUtil;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import java.util.UUID;


@WebServlet(name = "UserNotificationRefreshServlet", urlPatterns = {"/user/notifications/refresh"})
public class UserNotificationRefreshServlet extends HttpServlet {
private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Set character encoding
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");
            
            // Lấy userId của user từ session
            Object sessionValue = SessionUtil.getSessionAttribute(request, "userId");
            UUID userId = null;
            
            if (sessionValue instanceof UUID) {
                userId = (UUID) sessionValue;
            } else if (sessionValue instanceof String) {
                try {
                    userId = UUID.fromString((String) sessionValue);
                } catch (IllegalArgumentException e) {
                    System.out.println("Không thể chuyển đổi userId từ String sang UUID: " + e.getMessage());
                }
            }
            
            if (userId == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\": \"User not logged in\"}");
                return;
            }
            
            // Refresh notifications từ database
            List<Notification> notifications = notificationService.findByUserId(userId);
            int unreadCount = notificationService.countUnreadByUserId(userId);
            
            // Cập nhật session
            request.getSession().setAttribute("userNotifications", notifications);
            request.getSession().setAttribute("userUnreadCount", unreadCount);
            
            // Trả về dạng JSON
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": true, \"count\": " + unreadCount + ", \"total\": " + notifications.size() + "}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }

}
