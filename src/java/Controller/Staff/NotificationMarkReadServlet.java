package Controller.Staff;

import java.io.IOException;
import java.util.UUID;

import Service.NotificationService;
import Utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/staff/notifications/mark-read")
public class NotificationMarkReadServlet extends HttpServlet {
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Set character encoding
            request.setCharacterEncoding("UTF-8");
            response.setCharacterEncoding("UTF-8");
            
            // Lấy userId của staff từ session
            Object sessionValue = SessionUtil.getSessionAttribute(request, "userId");
            UUID staffId = null;
            
            if (sessionValue instanceof UUID) {
                staffId = (UUID) sessionValue;
            } else if (sessionValue instanceof String) {
                try {
                    staffId = UUID.fromString((String) sessionValue);
                } catch (IllegalArgumentException e) {
                    System.out.println("Không thể chuyển đổi userId từ String sang UUID: " + e.getMessage());
                }
            }
            
            if (staffId == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\": \"User not logged in\"}");
                return;
            }
            
            String action = request.getParameter("action");
            
            if ("markAsRead".equals(action)) {
                String notificationIdStr = request.getParameter("notificationId");
                if (notificationIdStr == null || notificationIdStr.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\": \"Notification ID is required\"}");
                    return;
                }
                
                UUID notificationId = UUID.fromString(notificationIdStr);
                boolean success = notificationService.markAsRead(notificationId);
                
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": " + success + "}");
            } else if ("markAllAsRead".equals(action)) {
                boolean success = notificationService.markAllAsRead(staffId);
                
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": " + success + "}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Invalid action\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
} 