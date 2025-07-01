package Controller.Booking;

import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import Service.Booking.StaffBookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/staff/update-booking-status")
public class UpdateBookingStatusServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(UpdateBookingStatusServlet.class.getName());
    private StaffBookingService staffBookingService;

    @Override
    public void init() throws ServletException {
        super.init();
        staffBookingService = new StaffBookingService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String bookingIdStr = request.getParameter("bookingId");
        String status = request.getParameter("status");
        String reason = request.getParameter("reason"); // Optional, for future use

        if (bookingIdStr == null || bookingIdStr.trim().isEmpty() || status == null || status.trim().isEmpty()) {
            LOGGER.log(Level.WARNING, "Missing bookingId or status parameter.");
            response.sendRedirect(request.getContextPath() + "/staff/booking-approval-list?error=missing_params");
            return;
        }

        try {
            UUID bookingId = UUID.fromString(bookingIdStr);
            
            LOGGER.log(Level.INFO, "Attempting to update booking ID {0} to status {1}", new Object[]{bookingId, status});
            
            staffBookingService.updateBookingStatus(bookingId, status, reason);
            
            LOGGER.log(Level.INFO, "Successfully updated status for booking ID {0}", bookingId);
            response.sendRedirect(request.getContextPath() + "/staff/booking-approval-list?success=update_successful");

        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.SEVERE, "Invalid UUID format for booking ID: " + bookingIdStr, e);
            response.sendRedirect(request.getContextPath() + "/staff/booking-approval-list?error=invalid_id");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error while updating booking status.", e);
            response.sendRedirect(request.getContextPath() + "/staff/booking-approval-list?error=db_error");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "An unexpected error occurred.", e);
            response.sendRedirect(request.getContextPath() + "/staff/booking-approval-list?error=unknown");
        }
    }

//    @Override
//    public String getServletInfo() {
//        return "Handles updating the status of a booking (Accept/Reject).";
//    }
} 