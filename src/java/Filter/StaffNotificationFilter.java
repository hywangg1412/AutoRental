package Filter;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

import Model.Entity.Notification;
import Service.NotificationService;
import Utils.SessionUtil;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;

@WebFilter("/pages/staff/*") // Áp dụng cho tất cả trang staff
public class StaffNotificationFilter implements Filter {
    private final NotificationService notificationService = new NotificationService();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // Set character encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpServletRequest httpReq = (HttpServletRequest) request;
        System.out.println("StaffNotificationFilter đang chạy cho URL: " + httpReq.getRequestURI());
        
        // Kiểm tra session
        Object sessionValue = SessionUtil.getSessionAttribute(httpReq, "userId");
        System.out.println("Giá trị userId trong session: " + (sessionValue != null ? sessionValue.toString() : "null"));
        System.out.println("Kiểu dữ liệu của userId trong session: " + (sessionValue != null ? sessionValue.getClass().getName() : "null"));
        
        UUID staffId = null;
        if (sessionValue instanceof UUID) {
            staffId = (UUID) sessionValue;
        } else if (sessionValue instanceof String) {
            try {
                staffId = UUID.fromString((String) sessionValue);
                System.out.println("Đã chuyển đổi String thành UUID: " + staffId);
            } catch (IllegalArgumentException e) {
                System.out.println("Không thể chuyển đổi String thành UUID: " + e.getMessage());
            }
        }
        
        System.out.println("StaffId sau xử lý: " + staffId);
        
        if (staffId != null) {
            try {
                // Lấy tất cả thông báo
                List<Notification> notifications = notificationService.findByUserId(staffId);
                System.out.println("Số lượng notification lấy được: " + notifications.size());
                for (Notification n : notifications) {
                    System.out.println("Notification: " + n.getNotificationId() + " - " + n.getMessage() + " - Đã đọc: " + n.isRead());
                }
                request.setAttribute("notifications", notifications);
                
                // Lấy số lượng thông báo chưa đọc
                List<Notification> unreadNotifications = notificationService.findUnreadByUserId(staffId);
                int unreadCount = unreadNotifications.size();
                System.out.println("Số lượng notification chưa đọc: " + unreadCount);
                request.setAttribute("unreadNotifications", unreadNotifications);
                request.setAttribute("unreadCount", unreadCount);
            } catch (Exception e) {
                System.out.println("Lỗi khi lấy thông báo: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            System.out.println("Không có staffId trong session");
        }
        chain.doFilter(request, response); // Tiếp tục xử lý request
    }
} 