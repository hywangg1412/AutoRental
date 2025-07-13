package Controller.Booking;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Service.Booking.BookingService;
import java.util.UUID;
import Exception.EventException;
import Exception.NotFoundException;


@WebServlet(name = "BookingCancelServlet", urlPatterns = {"/user/booking-cancel"})
public class BookingCancelServlet extends HttpServlet {
    private BookingService bookingService;

    @Override
    public void init() throws ServletException {
        super.init();
        bookingService = new BookingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET not supported");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String bookingId = request.getParameter("bookingId");
            boolean result = false;
            String message = null;
            try {
                result = bookingService.delete(UUID.fromString(bookingId));
            } catch (NotFoundException e) {
                message = "Booking not found.";
            } catch (EventException e) {
                message = e.getMessage();
            }
            if (result) {
                response.sendRedirect(request.getContextPath() + "/user/my-trip");
            } else {
                request.setAttribute("error", message != null ? message : "Cannot cancel booking.");
                request.getRequestDispatcher("/pages/user/my-trip.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("/pages/user/my-trip.jsp").forward(request, response);
        }
    }
}
