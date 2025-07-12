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

@WebServlet("/notifications/delete")
public class NotificationDeleteServlet extends HttpServlet {
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
            
            String notificationIdStr = request.getParameter("notificationId");
            
            if (notificationIdStr == null || notificationIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Missing notification ID\"}");
                return;
            }
            
            try {
                UUID notificationId = UUID.fromString(notificationIdStr);
                boolean success = notificationService.deleteNotification(notificationId);
                
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": " + success + "}");
            } catch (IllegalArgumentException e) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Invalid notification ID\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
} 