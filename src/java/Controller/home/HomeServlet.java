package Controller.Home;

import Model.DTO.CarListItemDTO;
import Model.Entity.Notification;
import Service.Car.CarListService;
import Service.NotificationService;
import Utils.FormatUtils;
import Utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.UUID;

@WebServlet("/pages/home")
public class HomeServlet extends HttpServlet {

    private CarListService carListService;
    private NotificationService notificationService;

    @Override
    public void init() throws ServletException {
        carListService = new CarListService();
        notificationService = new NotificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<CarListItemDTO> carList = carListService.getForHomePage(8);
            request.setAttribute("carList", carList);

            Object sessionValue = SessionUtil.getSessionAttribute(request, "userId");
            UUID userId = null;
            if (sessionValue instanceof UUID) {
                userId = (UUID) sessionValue;
            } else if (sessionValue instanceof String) {
                try {
                    userId = UUID.fromString((String) sessionValue);
                } catch (Exception e) {
                    userId = null;
                }
            }
            if (userId != null) {
                List<Notification> notifications = notificationService.findByUserId(userId);
                int unreadCount = notificationService.countUnreadByUserId(userId);
                SessionUtil.setSessionAttribute(request, "userNotifications", notifications);
                SessionUtil.setSessionAttribute(request, "userUnreadCount", unreadCount);
            }

            request.getRequestDispatcher("/pages/index.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi hệ thống.");
        }
    }
}