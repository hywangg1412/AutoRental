package Controller.Booking;

import Model.Entity.Booking.Booking;
import Model.Entity.User;
import Service.Booking.BookingService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

@WebServlet("/booking/create") 
public class BookingServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }

        try {
            // Lấy dữ liệu từ form
            UUID carId = UUID.fromString(request.getParameter("carId"));
            String pickupStr = request.getParameter("startDate");
            String returnStr = request.getParameter("endDate");
            String paymentMethod = "Chưa chọn"; // Tạm thời

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime pickup = LocalDateTime.parse(pickupStr, formatter);
            LocalDateTime ret = LocalDateTime.parse(returnStr, formatter);

            long days = java.time.Duration.between(pickup, ret).toDays();
            if (days <= 0) days = 1;

            // Tạm hardcode đơn giá (có thể lấy từ CarService)
            double unitPrice = 450_000;
            double totalAmount = unitPrice * days;

            // Tạo Booking
            Booking booking = new Booking();
            booking.setBookingId(UUID.randomUUID());
            booking.setUserId(user.getUserId());
            booking.setCarId(carId);
            booking.setPickupDateTime(pickup);
            booking.setReturnDateTime(ret);
            booking.setTotalAmount(totalAmount);
            booking.setStatus("Pending");
            booking.setCreatedDate(LocalDateTime.now());
            booking.setExpectedPaymentMethod(paymentMethod);

            // Lưu Booking
            bookingService.add(booking);

            // ✅ Redirect đến trang success thay vì forward lại trang cũ
            response.sendRedirect(request.getContextPath() + "/pages/booking-form/booking-success.jsp");

        } catch (Exception e) {
            e.printStackTrace(); // log kỹ
            // Nếu lỗi → chuyển về error page, KHÔNG forward lại booking-form-details.jsp vì thiếu car
            request.setAttribute("error", "Đặt xe thất bại: " + e.getMessage());
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }
}
