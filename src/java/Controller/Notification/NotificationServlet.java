package Controller.Notification;

import Model.Entity.Notification;
import Model.Entity.User.User;
import Service.NotificationService;
import Utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

/**
 * Servlet xử lý việc lấy thông báo cho người dùng
 * URL: /notifications
 * Method: GET
 */
@WebServlet(name = "NotificationServlet", urlPatterns = {"/notifications"})
public class NotificationServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(NotificationServlet.class.getName());
    private final NotificationService notificationService = new NotificationService();
    private final Gson gson = new GsonBuilder().setDateFormat("yyyy-MM-dd'T'HH:mm:ss").create();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // 1. Kiểm tra session - người dùng phải đăng nhập
            User currentUser = (User) SessionUtil.getSessionAttribute(request, "user");
            
            if (currentUser == null) {
                response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                response.getWriter().write("{\"error\": \"User not logged in\"}");
                return;
            }
            
            UUID userId = currentUser.getUserId();
            
            // Kiểm tra xem có yêu cầu lấy chi tiết thông báo hay không
            String action = request.getParameter("action");
            
            if ("getNotifications".equals(action)) {
                // 2. Lấy danh sách thông báo của người dùng
                List<Notification> notifications = notificationService.findByUserId(userId);
                
                // 3. Đếm số lượng thông báo chưa đọc
                int unreadCount = notificationService.countUnreadByUserId(userId);
                
                // 4. Chuyển đổi thông báo thành định dạng JSON
                List<Map<String, Object>> notificationList = new ArrayList<>();
                
                DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                
                for (Notification notification : notifications) {
                    Map<String, Object> notificationMap = new HashMap<>();
                    notificationMap.put("id", notification.getNotificationId().toString());
                    notificationMap.put("message", notification.getMessage());
                    notificationMap.put("createdDate", notification.getCreatedDate().format(formatter));
                    notificationMap.put("isRead", notification.isRead());
                    
                    // Xác định loại thông báo dựa vào nội dung
                    String type = "info"; // Mặc định là info
                    String message = notification.getMessage().toLowerCase();
                    
                    if (message.contains("đã được duyệt")) {
                        type = "success";
                    } else if (message.contains("đã bị từ chối") || message.contains("từ chối")) {
                        type = "danger";
                    }
                    
                    notificationMap.put("type", type);
                    notificationList.add(notificationMap);
                }
                
                // 5. Tạo đối tượng kết quả
                Map<String, Object> result = new HashMap<>();
                result.put("notifications", notificationList);
                result.put("unreadCount", unreadCount);
                
                // 6. Trả về kết quả dạng JSON
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                response.getWriter().write(gson.toJson(result));
            } else {
                // Trả về thông báo lỗi
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Invalid action\"}");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy thông báo", e);
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Chuyển hướng POST request sang GET
        response.sendRedirect(request.getRequestURI());
    }
} 