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

@WebFilter(urlPatterns = {"/pages/staff/*", "/staff/*"})
public class StaffNotificationFilter implements Filter {
    private final NotificationService notificationService = new NotificationService();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        // Set character encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        HttpServletRequest httpReq = (HttpServletRequest) request;
        String requestURI = httpReq.getRequestURI();
        
        // Lấy user object từ session
        Model.Entity.User.User user = (Model.Entity.User.User) SessionUtil.getSessionAttribute(httpReq, "user");
        UUID staffId = (user != null) ? user.getUserId() : null;
        
        if (staffId != null) {
            try {
                // Lấy tất cả thông báo
                List<Notification> notifications = notificationService.findByUserId(staffId);
                
                // Giới hạn chỉ hiển thị 5 thông báo mới nhất trong dropdown
                if (notifications.size() > 5) {
                    notifications = notifications.subList(0, 5);
                }
                
                request.setAttribute("notifications", notifications);
                
                // Lấy số lượng thông báo chưa đọc
                int unreadCount = notificationService.countUnreadByUserId(staffId);
                request.setAttribute("unreadCount", unreadCount);
            } catch (Exception e) {
                System.out.println("Lỗi khi lấy thông báo: " + e.getMessage());
                e.printStackTrace();
            }
        }
        
        chain.doFilter(request, response); // Tiếp tục xử lý request
    }
}