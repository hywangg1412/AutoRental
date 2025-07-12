package Controller.Notification;

import java.io.IOException;
import java.util.UUID;

import Service.NotificationService;
import Utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Model.Entity.User.User;

@WebServlet("/notifications/mark-read")
public class NotificationMarkReadServlet extends HttpServlet {
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Set character encoding
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");
            
            // Lấy userId từ session
            User user = (User) SessionUtil.getSessionAttribute(request, "user");
            UUID userId = (user != null) ? user.getUserId() : null;
            
            if (userId == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\": \"User not logged in\"}");
                return;
            }
            
            String action = request.getParameter("action");
            String notificationIdStr = request.getParameter("notificationId");
            String all = request.getParameter("all");
            
            boolean success = false;
            
            // Xử lý theo tham số
            if ("true".equals(all) || "markAllAsRead".equals(action)) {
                // Đánh dấu tất cả thông báo là đã đọc
                success = notificationService.markAllAsRead(userId);
            } else if (notificationIdStr != null && !notificationIdStr.trim().isEmpty()) {
                // Đánh dấu một thông báo cụ thể là đã đọc
                try {
                    UUID notificationId = UUID.fromString(notificationIdStr);
                    success = notificationService.markAsRead(notificationId);
                } catch (IllegalArgumentException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\": \"Invalid notification ID\"}");
                    return;
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Invalid action or missing parameters\"}");
                return;
            }
            
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": " + success + "}");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
} 