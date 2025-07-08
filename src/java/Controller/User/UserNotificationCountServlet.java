package Controller.User;

import java.io.IOException;
import java.util.UUID;

import Service.NotificationService;
import Utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/user/notifications/count")
public class UserNotificationCountServlet extends HttpServlet {
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
            
            // Lấy số lượng thông báo chưa đọc từ session trước
            Integer unreadCount = (Integer) request.getSession().getAttribute("userUnreadCount");
            
            // Nếu không có trong session thì query database
            if (unreadCount == null) {
                unreadCount = notificationService.countUnreadByUserId(userId);
                request.getSession().setAttribute("userUnreadCount", unreadCount);
            }
            
            // Trả về dạng JSON
            response.setContentType("application/json");
            response.getWriter().write("{\"count\": " + unreadCount + "}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
} 