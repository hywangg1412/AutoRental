//package Controller.Booking;
//
//import java.io.IOException;
//import java.util.List;
//import java.util.logging.Level;
//import java.util.logging.Logger;
//
//import Model.DTO.BookingInfoDTO;
//import Model.Entity.User.User;
//import Service.Booking.StaffBookingService;
//import Utils.SessionUtil;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
///**
// * Servlet hiển thị danh sách booking cho staff xem và duyệt
// * URL: /staff/booking-approval-list
// * Method: GET (hiển thị trang), POST (redirect)
// * 
// * Chức năng:
// * 1. Lấy danh sách booking từ StaffBookingService
// * 2. Hiển thị trong staff-booking.jsp
// * 3. Staff có thể xem chi tiết và duyệt booking
// */
//@WebServlet("/staff/booking-approval-list")
//public class BookingApprovalListServlet extends HttpServlet {
//
//    private static final Logger LOGGER = Logger.getLogger(BookingApprovalListServlet.class.getName());
//    private StaffBookingService staffBookingService;
//
//    @Override
//    public void init() {
//        staffBookingService = new StaffBookingService();
//    }
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        try {
//            // 1. Kiểm tra session của staff
//            User staff = (User) SessionUtil.getSessionAttribute(request, "user");
//            if (staff == null) {
//                response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
//                return;
//            }
//
//            // TODO: Kiểm tra user có phải staff không (có thể kiểm tra role)
//            
//            // ====== PHÂN TRANG ======
//            int page = 1;
//            int pageSize = 10; // Số booking mỗi trang
//            try {
//                String pageParam = request.getParameter("page");
//                if (pageParam != null) page = Integer.parseInt(pageParam);
//            } catch (NumberFormatException ignored) {}
//            // Lấy danh sách booking phân trang
//            List<BookingInfoDTO> bookings = staffBookingService.getBookingInfoPaged(page, pageSize);
//            // Đếm tổng số booking để tính tổng số trang
//            int totalBookings = staffBookingService.getAllBookingInfo().size();
//            int totalPages = (int) Math.ceil((double) totalBookings / pageSize);
//
//            request.setAttribute("bookingRequests", bookings);
//            request.setAttribute("currentPage", page);
//            request.setAttribute("totalPages", totalPages);
//            // ====== END PHÂN TRANG ======
//            
//            // 6. Hiển thị thông báo thành công/lỗi nếu có
//            String successMessage = request.getParameter("success");
//            String errorMessage = request.getParameter("error");
//            
//            if (successMessage != null && !successMessage.trim().isEmpty()) {
//                request.setAttribute("successMessage", successMessage);
//            }
//            
//            if (errorMessage != null && !errorMessage.trim().isEmpty()) {
//                request.setAttribute("errorMessage", errorMessage);
//            }
//            
//        } catch (Exception e) {
//            LOGGER.log(Level.SEVERE, "Lỗi trong BookingApprovalListServlet", e);
//            request.setAttribute("errorMessage", "Không thể tải danh sách booking: " + e.getMessage());
//        }
//        
//        // 7. Forward đến trang JSP
//        request.getRequestDispatcher("/pages/staff/staff-booking.jsp").forward(request, response);
//    }
//
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        // POST request chỉ redirect về GET để refresh trang
//        response.sendRedirect(request.getContextPath() + "/staff/booking-approval-list");
//    }
//}
