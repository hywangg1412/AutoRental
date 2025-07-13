package Controller.Contract;

import Exception.NotFoundException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Model.Constants.BookingStatusConstants;
import Model.Entity.Booking.Booking;
import Model.Entity.User.User;
import Service.Booking.BookingService;
import java.io.IOException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ContractCreateServlet", urlPatterns = {"/contract/create"})
public class ContractCreateServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ContractCreateServlet.class.getName());
    private BookingService bookingService;

    @Override
    public void init() throws ServletException {
        super.init();
        bookingService = new BookingService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            User user = validateUserSession(request, response);
            if (user == null) return;

            Booking booking = validateBooking(request, response, user);
            if (booking == null) return;

            request.setAttribute("bookingId", booking.getBookingId().toString());
            request.getRequestDispatcher("/pages/contract/contract-sign.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error preparing contract sign page", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }

    private User validateUserSession(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return null;
        }
        return user;
    }

    private Booking validateBooking(HttpServletRequest request, HttpServletResponse response, User user) throws IOException, NotFoundException {
        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing booking ID");
            return null;
        }

        try {
            UUID bookingId = UUID.fromString(bookingIdStr);
            Booking booking = bookingService.findById(bookingId);
            
            if (booking == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Booking not found");
                return null;
            }

            if (!booking.getUserId().equals(user.getUserId())) {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied");
                return null;
            }

            if (!BookingStatusConstants.DEPOSIT_PAID.equals(booking.getStatus())) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Booking is not ready for contract signing");
                return null;
            }

            return booking;
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Invalid booking ID format: " + bookingIdStr, e);
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid booking ID format");
            return null;
        }
    }
} 