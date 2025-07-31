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
import java.io.PrintWriter;
import java.util.UUID;

@WebServlet(name = "ReturnCarRequestServlet", urlPatterns = {"/booking/return-car-request"})
public class ReturnCarRequestServlet extends HttpServlet {
    private final BookingService bookingService = new BookingService();
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null) {
            out.print("{\"success\":false,\"message\":\"Thiếu bookingId\"}");
            return;
        }

        try {
            UUID bookingId = UUID.fromString(bookingIdStr);
            Booking booking = bookingService.findById(bookingId);
            if (booking == null) {
                out.print("{\"success\":false,\"message\":\"Không tìm thấy booking\"}");
                return;
            }
            // Chỉ cho phép trả xe khi trạng thái là ContractSigned hoặc InProgress
            if (!BookingStatusConstants.CONTRACT_SIGNED.equals(booking.getStatus())
                && !BookingStatusConstants.IN_PROGRESS.equals(booking.getStatus())) {
                out.print("{\"success\":false,\"message\":\"Không thể trả xe ở trạng thái hiện tại\"}");
                return;
            }
            // Cập nhật trạng thái thành PendingInspection để đưa vào danh sách chờ kiểm tra
            bookingService.updateBookingStatus(bookingId, BookingStatusConstants.PENDING_INSPECTION);
            // Gửi thông báo cho staff
            notificationService.sendNotificationToAllStaff("Customer has requested car return, waiting for inspection. Booking code: " + booking.getBookingCode());
            out.print("{\"success\":true,\"message\":\"Yêu cầu trả xe đã được gửi, vui lòng chờ nhân viên kiểm tra xe\"}");
        } catch (Exception e) {
            out.print("{\"success\":false,\"message\":\"Lỗi: " + e.getMessage() + "\"}");
        }
    }
}