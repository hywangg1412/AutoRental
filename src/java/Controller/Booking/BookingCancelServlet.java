package Controller.Booking;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Service.Booking.BookingService;
import Model.Entity.Booking.Booking;
import Model.Entity.User.User;
import Model.Constants.BookingStatusConstants;
import java.util.UUID;


@WebServlet(name = "BookingCancelServlet", urlPatterns = {"/user/booking-cancel"})
public class BookingCancelServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(BookingCancelServlet.class.getName());
    private BookingService bookingService;

    @Override
    public void init() throws ServletException {
        bookingService = new BookingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Allow GET for testing purposes
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            LOGGER.info("=== STARTING BOOKING CANCELLATION PROCESS ===");
            
            // Lấy thông tin từ request
            String bookingIdStr = request.getParameter("bookingId");
            String reason = request.getParameter("reason");
            
            LOGGER.info("Booking ID from request: " + bookingIdStr);
            LOGGER.info("Reason from request: " + reason);
            
            // Kiểm tra user đã đăng nhập chưa
            HttpSession session = request.getSession();
            User user = (User) session.getAttribute("user");
            if (user == null) {
                LOGGER.warning("User not logged in, redirecting to login page");
                response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
                return;
            }
            
            LOGGER.info("User ID: " + user.getUserId());
            
            if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
                LOGGER.warning("Booking ID is missing");
                request.setAttribute("error", "Booking ID is required.");
                request.getRequestDispatcher("/pages/user/my-trip.jsp").forward(request, response);
                return;
            }
            
            UUID bookingId = UUID.fromString(bookingIdStr);
            LOGGER.info("Parsed Booking ID: " + bookingId);
            
            // Lấy booking từ database
            Booking booking = bookingService.findById(bookingId);
            if (booking == null) {
                LOGGER.warning("Booking not found with ID: " + bookingId);
                request.setAttribute("error", "Booking not found.");
                request.getRequestDispatcher("/pages/user/my-trip.jsp").forward(request, response);
                return;
            }
            
            LOGGER.info("Found booking - Status: " + booking.getStatus() + ", User ID: " + booking.getUserId());
            
            // Kiểm tra user có quyền hủy booking này không
            if (!booking.getUserId().equals(user.getUserId())) {
                LOGGER.warning("User " + user.getUserId() + " doesn't have permission to cancel booking " + bookingId + " (owned by " + booking.getUserId() + ")");
                request.setAttribute("error", "You don't have permission to cancel this booking.");
                request.getRequestDispatcher("/pages/user/my-trip.jsp").forward(request, response);
                return;
            }
            
            // Cho phép hủy booking ở bất kỳ trạng thái nào
            LOGGER.info("Booking status check removed - allowing cancellation for status: " + booking.getStatus());
            
            LOGGER.info("All validations passed. Proceeding to cancel booking...");
            
            // Cập nhật trạng thái booking thành Cancelled
            booking.setStatus(BookingStatusConstants.CANCELLED);
            booking.setCancelReason(reason != null ? reason.trim() : "User cancelled");
            
            LOGGER.info("Updated booking - New Status: " + booking.getStatus() + ", Cancel Reason: " + booking.getCancelReason());
            
            boolean result = bookingService.update(booking);
            
            LOGGER.info("Update result: " + result);
            
            if (result) {
                LOGGER.info("Booking cancelled successfully. Redirecting to my-trip page.");
                // Redirect về trang my-trip
                response.sendRedirect(request.getContextPath() + "/user/my-trip");
            } else {
                LOGGER.warning("Failed to cancel booking. Update returned false.");
                request.setAttribute("error", "Failed to cancel booking. Please try again.");
                request.getRequestDispatcher("/pages/user/my-trip.jsp").forward(request, response);
            }
            
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.SEVERE, "Invalid booking ID format", e);
            request.setAttribute("error", "Invalid booking ID format.");
            request.getRequestDispatcher("/pages/user/my-trip.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during booking cancellation", e);
            request.setAttribute("error", "An error occurred: " + e.getMessage());
            request.getRequestDispatcher("/pages/user/my-trip.jsp").forward(request, response);
        }
    }
}
