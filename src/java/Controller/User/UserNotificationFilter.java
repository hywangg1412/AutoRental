//package Controller.User;
//
//import Model.Entity.Notification;
//import Service.NotificationService;
//import Utils.SessionUtil;
//import jakarta.servlet.*;
//import jakarta.servlet.annotation.WebFilter;
//import jakarta.servlet.http.HttpServletRequest;
//
//import java.io.IOException;
//import java.util.List;
//import java.util.UUID;
//
//@WebFilter({
//    "/pages/user/*",
//    "/pages/index.jsp",
//    "/pages/about.jsp",
//    "/pages/car.jsp",
//    "/pages/contact.jsp"
//}) 
//public class UserNotificationFilter implements Filter {
//    private final NotificationService notificationService = new NotificationService();
//
//    @Override
//    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain)
//            throws IOException, ServletException {
//        HttpServletRequest request = (HttpServletRequest) servletRequest;
//
//        Object sessionValue = SessionUtil.getSessionAttribute(request, "userId");
//        UUID userId = null;
//        if (sessionValue instanceof UUID) {
//            userId = (UUID) sessionValue;
//        } else if (sessionValue instanceof String) {
//            try {
//                userId = UUID.fromString((String) sessionValue);
//            } catch (Exception e) {
//                userId = null;
//            }
//        }
//
//        if (userId != null) {
//            List<Notification> notifications = notificationService.findByUserId(userId);
//            int unreadCount = notificationService.countUnreadByUserId(userId);
//            request.setAttribute("notifications", notifications);
//            request.setAttribute("unreadCount", unreadCount);
//            System.out.println("UserId in filter: " + userId);
//            System.out.println("Notifications: " + notifications.size());
//        }
//
//        filterChain.doFilter(servletRequest, servletResponse);
//    }
//}
