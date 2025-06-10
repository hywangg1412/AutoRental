package Controller.Booking;

import Exception.EventException;
import Exception.NotFoundException;
import Model.Entity.Booking.Booking;
import Model.Entity.Booking.BookingApproval;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Service.Booking.BookingApprovalService;
import Service.Booking.BookingService;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

// /staff/booking-approval
public class BookingApprovalServlet extends HttpServlet {
    private BookingService bookingService;
    private BookingApprovalService approvalService;

    @Override
    public void init() {
        bookingService = new BookingService();
        approvalService = new BookingApprovalService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String bookingId = request.getParameter("bookingId");
            String action = request.getParameter("action");

            if (bookingId == null || bookingId.trim().isEmpty()) {
                throw new IllegalArgumentException("Booking ID is required.");
            }
            if (!"accept".equals(action) && !"decline".equals(action)) {
                throw new IllegalArgumentException("Invalid action.");
            }
            UUID bookingUUID = UUID.fromString(bookingId);

            Booking booking = bookingService.findById(bookingUUID);
            BookingApproval approval = approvalService.findByBookingId(bookingUUID);
            if (booking == null || approval == null) {
                throw new NotFoundException("Booking or approval not found.");
            }

            if ("accept".equals(action)) {
                booking.setStatus("Confirmed");
                approval.setApprovalStatus("Accepted");
            } else {
                booking.setStatus("Cancelled");
                approval.setApprovalStatus("Rejected");
            }
            System.out.println("Before update: " + booking.getStatus());
            bookingService.update(booking);
            System.out.println("After update: " + booking.getStatus());
            approvalService.update(approval);
            response.sendRedirect("booking-approval-list");
        } catch (IllegalArgumentException | EventException | NotFoundException e) {
            Logger.getLogger(BookingApprovalServlet.class.getName()).log(Level.SEVERE, null, e);
            request.setAttribute("error", e.getMessage());
            request.getRequestDispatcher("booking-approval-list").forward(request, response);
        }
    }

}
