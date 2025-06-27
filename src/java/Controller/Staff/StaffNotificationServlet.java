package Controller.Staff;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

import Model.Entity.Notification;
import Service.NotificationService;
import Utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/staff/notifications/*")
public class StaffNotificationServlet extends HttpServlet {
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
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
                response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
                return;
            }
            
            // Lấy danh sách notification cho staff
            List<Notification> notifications = notificationService.findByUserId(staffId);
            request.setAttribute("notifications", notifications);
            
            // Lấy số lượng thông báo chưa đọc
            int unreadCount = notificationService.countUnreadByUserId(staffId);
            request.setAttribute("unreadCount", unreadCount);
            
            // Forward sang trang JSP để hiển thị
            request.getRequestDispatcher("/pages/staff/staff-notification.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể lấy thông báo: " + e.getMessage());
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
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
                response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
                return;
            }
            
            String action = request.getParameter("action");
            String notificationIdStr = request.getParameter("notificationId");
            
            if ("markAsRead".equals(action) && notificationIdStr != null) {
                // Đánh dấu một thông báo đã đọc
                UUID notificationId = UUID.fromString(notificationIdStr);
                notificationService.markAsRead(notificationId);
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true}");
            } else if ("markAllAsRead".equals(action)) {
                // Đánh dấu tất cả thông báo đã đọc
                notificationService.markAllAsRead(staffId);
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true}");
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