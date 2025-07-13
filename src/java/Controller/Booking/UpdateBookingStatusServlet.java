package Controller.Booking;

import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import Model.Entity.User.User;
import Service.Booking.BookingApprovalService;
import Service.Booking.StaffBookingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * LEGACY SERVLET - Được khuyến nghị sử dụng BookingApprovalServlet thay thế
 * Servlet cập nhật trạng thái booking (Accept/Reject)
 * URL: /staff/update-booking-status
 * Method: POST
 * 
 * Parameters:
 * - bookingId: ID của booking (required)
 * - status: "Accepted" hoặc "Rejected" (required)
 * - reason: Lý do (tùy chọn, khuyến nghị cho reject)
 */
@WebServlet("/staff/update-booking-status")
public class UpdateBookingStatusServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(UpdateBookingStatusServlet.class.getName());
    private StaffBookingService staffBookingService;
    private BookingApprovalService bookingApprovalService;

    @Override
    public void init() throws ServletException {
        super.init();
        staffBookingService = new StaffBookingService();
        bookingApprovalService = new BookingApprovalService();
        
        LOGGER.info("UpdateBookingStatusServlet initialized - LEGACY MODE");
        LOGGER.warning("Consider using BookingApprovalServlet for new implementations");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // 1. Kiểm tra đăng nhập
            User currentUser = (User) request.getSession().getAttribute("user");
            if (currentUser == null) {
                LOGGER.warning("Unauthorized access attempt to update booking status");
                response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
                return;
            }
            
            // 2. Lấy parameters
            String bookingIdStr = request.getParameter("bookingId");
            String status = request.getParameter("status");
            String reason = request.getParameter("reason");

            LOGGER.log(Level.INFO, "Legacy booking status update request - BookingId: {0}, Status: {1}, Staff: {2}", 
                new Object[]{bookingIdStr, status, currentUser.getUserId()});

            // 3. Validate input
            if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
                LOGGER.warning("Missing bookingId parameter in legacy request");
                response.sendRedirect(request.getContextPath() + 
                    "/staff/booking-approval-list?error=" + 
                    java.net.URLEncoder.encode("Thiếu thông tin booking ID", "UTF-8"));
                return;
            }
            
            if (status == null || status.trim().isEmpty()) {
                LOGGER.warning("Missing status parameter in legacy request");
                response.sendRedirect(request.getContextPath() + 
                    "/staff/booking-approval-list?error=" + 
                    java.net.URLEncoder.encode("Thiếu thông tin trạng thái", "UTF-8"));
                return;
            }

            // 4. Parse và validate booking ID
            UUID bookingId;
            try {
                bookingId = UUID.fromString(bookingIdStr);
            } catch (IllegalArgumentException e) {
                LOGGER.log(Level.SEVERE, "Invalid UUID format for booking ID: " + bookingIdStr, e);
                response.sendRedirect(request.getContextPath() + 
                    "/staff/booking-approval-list?error=" + 
                    java.net.URLEncoder.encode("Booking ID không hợp lệ", "UTF-8"));
                return;
            }
            
            // 5. Normalize status và route đến service phù hợp
            String normalizedStatus = status.trim();
            
            if ("Accepted".equalsIgnoreCase(normalizedStatus) || "Confirmed".equalsIgnoreCase(normalizedStatus)) {
                // Sử dụng BookingApprovalService để approve
                LOGGER.log(Level.INFO, "Routing legacy accept request to BookingApprovalService");
                
                bookingApprovalService.approveBooking(
                    bookingId, 
                    currentUser.getUserId(), 
                    "Approved", 
                    reason, 
                    null
                );
                
                String successMessage = "Đã duyệt booking thành công (Legacy Mode)";
                response.sendRedirect(request.getContextPath() + 
                    "/staff/booking-approval-list?success=" + 
                    java.net.URLEncoder.encode(successMessage, "UTF-8"));
                
            } else if ("Rejected".equalsIgnoreCase(normalizedStatus)) {
                // Sử dụng BookingApprovalService để reject
                LOGGER.log(Level.INFO, "Routing legacy reject request to BookingApprovalService");
                
                String rejectionReason = (reason != null && !reason.trim().isEmpty()) ? 
                    reason : "Không có lý do cụ thể";
                
                bookingApprovalService.approveBooking(
                    bookingId, 
                    currentUser.getUserId(), 
                    "Rejected", 
                    reason, 
                    rejectionReason
                );
                
                String successMessage = "Đã từ chối booking thành công (Legacy Mode)";
                response.sendRedirect(request.getContextPath() + 
                    "/staff/booking-approval-list?success=" + 
                    java.net.URLEncoder.encode(successMessage, "UTF-8"));
                
            } else {
                // Fallback: sử dụng StaffBookingService cũ
                LOGGER.log(Level.WARNING, "Using legacy StaffBookingService for status: {0}", normalizedStatus);
                
                staffBookingService.updateBookingStatus(bookingId, normalizedStatus, reason);
                
                String successMessage = "Đã cập nhật trạng thái booking thành công";
                response.sendRedirect(request.getContextPath() + 
                    "/staff/booking-approval-list?success=" + 
                    java.net.URLEncoder.encode(successMessage, "UTF-8"));
            }

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in legacy UpdateBookingStatusServlet", e);
            
            String errorType = "unknown";
            String errorMessage = "Lỗi hệ thống, vui lòng thử lại sau";
            
            if (e instanceof SQLException) {
                errorType = "db_error";
                errorMessage = "Lỗi cơ sở dữ liệu";
            } else if (e.getMessage() != null && e.getMessage().contains("không tìm thấy")) {
                errorType = "not_found";
                errorMessage = "Không tìm thấy booking";
            } else if (e.getMessage() != null && e.getMessage().contains("đã được xử lý")) {
                errorType = "already_processed";
                errorMessage = "Booking đã được xử lý trước đó";
            }
            
            response.sendRedirect(request.getContextPath() + 
                "/staff/booking-approval-list?error=" + 
                java.net.URLEncoder.encode(errorMessage, "UTF-8") + 
                "&errorType=" + errorType);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        LOGGER.warning("GET request attempted on legacy update booking status endpoint");
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, 
            "Chỉ hỗ trợ POST method");
    }

    @Override
    public String getServletInfo() {
        return "LEGACY: Handles updating booking status (Accept/Reject). " +
               "Consider using BookingApprovalServlet for new implementations.";
    }
} 