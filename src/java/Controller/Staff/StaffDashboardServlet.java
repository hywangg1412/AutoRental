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

@WebServlet("/staff/dashboard")
public class StaffDashboardServlet extends HttpServlet {
    private final NotificationService notificationService = new NotificationService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set character encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Kiểm tra đăng nhập staff
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
        
        // Lấy tất cả thông báo
        List<Notification> notifications = notificationService.findByUserId(staffId);
        request.setAttribute("notifications", notifications);
        
        // Lấy thông báo chưa đọc
        List<Notification> unreadNotifications = notificationService.findUnreadByUserId(staffId);
        request.setAttribute("unreadNotifications", unreadNotifications);
        
        // Lấy số lượng thông báo chưa đọc
        int unreadCount = notificationService.countUnreadByUserId(staffId);
        request.setAttribute("unreadCount", unreadCount);
        
        // Forward to staff dashboard
        request.getRequestDispatcher("/pages/staff/staff-dashboard.jsp").forward(request, response);
    }
} 