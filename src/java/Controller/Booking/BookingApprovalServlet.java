package Controller.Booking;

import java.io.IOException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import Exception.EventException;
import Model.Entity.Booking.Booking;
import Model.Entity.Booking.BookingApproval;
import Model.Entity.User.User;
import Service.Booking.BookingApprovalService;
import Service.Booking.BookingService;
import Service.NotificationService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet xử lý việc staff duyệt booking (approve/reject)
 * URL: /staff/approve-booking
 * Method: POST
 * 
 * Parameters:
 * - bookingId: ID của booking cần duyệt (bắt buộc)
 * - action: "approve" hoặc "reject" (bắt buộc)
 * - note: Ghi chú khi duyệt (tùy chọn)
 * - declineReason: Lý do từ chối (bắt buộc nếu reject)
 */
@WebServlet(name = "BookingApprovalServlet", urlPatterns = {"/staff/approve-booking"})
public class BookingApprovalServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(BookingApprovalServlet.class.getName());
    private final BookingApprovalService bookingApprovalService = new BookingApprovalService();
    private final BookingService bookingService = new BookingService();
    private final NotificationService notificationService = new NotificationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            // 1. Kiểm tra session - chỉ staff mới được duyệt booking
            User currentUser = (User) request.getSession().getAttribute("user");
            if (currentUser == null) {
                response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Vui lòng đăng nhập");
                return;
            }
            // TODO: Thêm logic kiểm tra role staff nếu cần
            
            // 2. Lấy thông tin từ form (từ popup reject hoặc approve)
            String bookingIdStr = request.getParameter("bookingId");
            String action = request.getParameter("action"); // "approve" hoặc "reject"
            String note = request.getParameter("note");
            // Lưu ý: popup reject sẽ gửi tham số declineReason, còn form cũ có thể gửi rejectionReason
            String rejectionReason = request.getParameter("declineReason");
            if (rejectionReason == null) rejectionReason = request.getParameter("rejectionReason");
            
            // 3. Validate dữ liệu đầu vào
            if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Booking ID không được để trống");
                return;
            }
            
            if (action == null || (!"approve".equals(action) && !"reject".equals(action))) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action phải là 'approve' hoặc 'reject'");
                return;
            }
            
            // Nếu reject mà không có lý do
            if ("reject".equals(action) && (rejectionReason == null || rejectionReason.trim().isEmpty())) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Lý do từ chối không được để trống");
                return;
            }
            
            // 4. Parse bookingId
            UUID bookingId;
            try {
                bookingId = UUID.fromString(bookingIdStr);
            } catch (IllegalArgumentException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Booking ID không hợp lệ");
                return;
            }
            
            // Lấy thông tin booking để biết userId
            Booking booking = bookingService.findById(bookingId);
            if (booking == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy booking");
                return;
            }
            
            // 5. Xử lý duyệt booking
            // Nếu action là approve thì approvalStatus = 'Approved', nếu reject thì 'Rejected'
            String approvalStatus = "approve".equals(action) ? "Approved" : "Rejected";
            
            // Ghi log thao tác staff
            LOGGER.log(Level.INFO, "Staff {0} đang {1} booking {2}", 
                new Object[]{currentUser.getUserId(), action, bookingId});
            
            // Gọi service để duyệt booking (lưu lịch sử + cập nhật trạng thái + lưu lý do từ chối nếu có)
            BookingApproval approval = bookingApprovalService.approveBooking(
                bookingId, 
                currentUser.getUserId(), 
                approvalStatus, 
                note, 
                rejectionReason
            );
            
            // 6. Gửi thông báo cho khách hàng
            UUID userId = booking.getUserId();
            String bookingCode = booking.getBookingCode();
            
            if ("approve".equals(action)) {
                // Nếu duyệt thành công, gửi thông báo kèm link đến trang thanh toán đặt cọc
                String message = "Your booking (code " + bookingCode + ") has been approved. Please proceed with the deposit payment to complete the car booking.";
                notificationService.sendNotificationToUser(userId, message);
            } else {
                // Nếu từ chối, gửi thông báo kèm lý do từ chối
                String message = "Your booking (code " + bookingCode + ") has been rejected. Reason: " + rejectionReason;
                notificationService.sendNotificationToUser(userId, message);
            }
            // 7. Trả về kết quả thành công
            LOGGER.log(Level.INFO, "Staff {0} đã {1} booking {2} thành công và gửi thông báo cho khách hàng", 
                new Object[]{currentUser.getUserId(), action, bookingId});
            
            // Redirect về trang danh sách booking với thông báo thành công
            String successMessage = "approve".equals(action) ? 
                "Đã duyệt booking thành công" : "Đã từ chối booking thành công";
            
            response.sendRedirect(request.getContextPath() + "/staff/booking-approval-list?success=" + 
                java.net.URLEncoder.encode(successMessage, "UTF-8"));
            
        } catch (EventException e) {
            // Xử lý lỗi business logic
            LOGGER.log(Level.WARNING, "Lỗi khi duyệt booking", e);
            String errorMessage = "Lỗi khi duyệt booking: " + e.getMessage();
            response.sendRedirect(request.getContextPath() + "/staff/booking-approval-list?error=" + 
                java.net.URLEncoder.encode(errorMessage, "UTF-8"));
            
        } catch (Exception e) {
            // Xử lý lỗi hệ thống
            LOGGER.log(Level.SEVERE, "Lỗi hệ thống khi duyệt booking", e);
            String errorMessage = "Lỗi hệ thống, vui lòng thử lại sau";
            response.sendRedirect(request.getContextPath() + "/staff/booking-approval-list?error=" + 
                java.net.URLEncoder.encode(errorMessage, "UTF-8"));
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Không cho phép GET request
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Chỉ hỗ trợ POST method");
    }
} 