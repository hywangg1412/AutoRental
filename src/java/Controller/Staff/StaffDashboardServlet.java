package Controller.Staff;

import java.io.IOException;
import java.util.List;
import java.util.UUID;
import java.util.ArrayList;
import java.util.Arrays;

import Model.Entity.Notification;
import Model.Entity.Booking.Booking;
import Service.NotificationService;
import Utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Service.Booking.BookingService;
import Model.Constants.BookingStatusConstants;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/staff/dashboard")
public class StaffDashboardServlet extends HttpServlet {
    private final NotificationService notificationService = new NotificationService();
    private final BookingService bookingService = new BookingService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set character encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Check staff login
        String userIdStr = (String) SessionUtil.getSessionAttribute(request, "userId");
        UUID staffId = null;
        try {
            staffId = UUID.fromString(userIdStr);
        } catch (Exception e) {
            System.out.println("Cannot convert userId from String to UUID: " + e.getMessage());
        }
        if (staffId == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }
        
        // Get all notifications
        List<Notification> notifications = notificationService.findByUserId(staffId);
        request.setAttribute("notifications", notifications);
        
        // Get unread notifications
        List<Notification> unreadNotifications = notificationService.findUnreadByUserId(staffId);
        request.setAttribute("unreadNotifications", unreadNotifications);
        
        // Get unread notification count
        int unreadCount = notificationService.countUnreadByUserId(staffId);
        request.setAttribute("unreadCount", unreadCount);
        
        // Get booking request counts
        int totalRequests = bookingService.countAllBookings();
        int accepted = bookingService.countBookingsByStatus(BookingStatusConstants.CONFIRMED);
        int pending = bookingService.countBookingsByStatus(BookingStatusConstants.PENDING);
        request.setAttribute("totalRequests", totalRequests);
        request.setAttribute("accepted", accepted);
        request.setAttribute("pending", pending);
        
        // Get recent booking requests
        List<Booking> recentBookings = bookingService.findAll();
        // Sort by status order: Pending > Confirmed > Cancelled > Completed
        List<String> statusOrder = java.util.Arrays.asList(
            BookingStatusConstants.PENDING,
            BookingStatusConstants.CONFIRMED,
            BookingStatusConstants.CANCELLED,
            BookingStatusConstants.COMPLETED
        );
        recentBookings.sort((b1, b2) -> {
            int cmp = Integer.compare(statusOrder.indexOf(b1.getStatus()), statusOrder.indexOf(b2.getStatus()));
            if (cmp == 0) {
                // If same status, sort by created date descending
                return b2.getCreatedDate().compareTo(b1.getCreatedDate());
            }
            return cmp;
        });
        if (recentBookings.size() > 5) {
            recentBookings = recentBookings.subList(0, 5);
        }
        request.setAttribute("recentBookings", recentBookings);
        request.setAttribute("hasBookings", !recentBookings.isEmpty());
        
        // Add status list to request
        List<String> statusList = Arrays.asList(
            BookingStatusConstants.PENDING,
            BookingStatusConstants.CONFIRMED,
            BookingStatusConstants.CANCELLED,
            BookingStatusConstants.COMPLETED
        );
        request.setAttribute("statusList", statusList);
        
        // Forward to staff dashboard
        request.getRequestDispatcher("/pages/staff/staff-dashboard.jsp").forward(request, response);
    }
} 