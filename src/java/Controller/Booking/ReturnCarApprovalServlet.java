package Controller.Booking;

import Model.Constants.BookingStatusConstants;
import Model.Entity.Booking.Booking;
import Service.Booking.BookingService;
import Service.NotificationService;
import Exception.NotFoundException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.UUID;

@WebServlet(name = "ReturnCarApprovalServlet", urlPatterns = {"/staff/return-car-approval"})
public class ReturnCarApprovalServlet extends HttpServlet {
    private final BookingService bookingService = new BookingService();
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingIdStr = request.getParameter("bookingId");
        String action = request.getParameter("action");
        String reason = request.getParameter("reason");

        if (bookingIdStr == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/staff/booking-approval-list?error=Thiếu thông tin");
            return;
        }

        try {
            UUID bookingId = UUID.fromString(bookingIdStr);
            Booking booking = bookingService.findById(bookingId);
            if (booking == null) {
                response.sendRedirect(request.getContextPath() + "/staff/booking-approval-list?error=Không tìm thấy booking");
                return;
            }

            if ("approve".equals(action)) {
                bookingService.updateBookingStatus(bookingId, BookingStatusConstants.COMPLETED);
                notificationService.sendNotificationToUser(booking.getUserId(), "Your car return request has been confirmed. Thank you for using our service!");
                response.sendRedirect(request.getContextPath() + "/staff/booking-approval-list?success=Confirmed Return Car");
                return;
            } else if ("reject".equals(action)) {
                bookingService.updateBookingStatus(bookingId, BookingStatusConstants.RETURN_REJECTED);
                notificationService.sendNotificationToUser(booking.getUserId(), "Your car return request has been rejected. Reason: " + reason);
                response.sendRedirect(request.getContextPath() + "/staff/booking-approval-list?success=Rejected Return Car");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/staff/booking-approval-list?success=Đã xử lý yêu cầu trả xe");
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/staff/booking-approval-list?error=Lỗi: " + e.getMessage());
        }
    }
}