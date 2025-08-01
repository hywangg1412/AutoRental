package Controller.Deposit;
//quanquan
import java.io.IOException;
import java.util.UUID;
import java.util.logging.Logger;

import Model.DTO.Deposit.DepositPageDTO;
import Model.Entity.User.User;
import Service.Deposit.DepositService;
import Service.Interfaces.IDeposit.IDepositService;
import Utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet xử lý trang deposit - đặt cọc
 * SỬ DỤNG DepositService để xử lý business logic
 * Servlet CHỈ XỬ LÝ doGet và doPost, không chứa business logic
 */
@WebServlet("/customer/deposit")
public class DepositServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(DepositServlet.class.getName());

    private final IDepositService depositService;

    public DepositServlet() {
        // Tạo dependencies theo đúng pattern
        Repository.Deposit.DepositRepository depositRepository = new Repository.Deposit.DepositRepository();
        Repository.Deposit.TermsRepository termsRepository = new Repository.Deposit.TermsRepository();
        this.depositService = new DepositService(depositRepository, termsRepository);
    }

    // ========== GET METHOD - HIỂN THỊ TRANG DEPOSIT ==========
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        LOGGER.info("🚀 DepositServlet.doGet() được gọi!");
        LOGGER.info("📋 Request URI: " + request.getRequestURI());
        LOGGER.info("📋 Context Path: " + request.getContextPath());
        LOGGER.info("📋 Servlet Path: " + request.getServletPath());
        
        // DEBUG MODE: Trả về simple response để test servlet mapping
        String debugMode = request.getParameter("debug");
        if ("simple".equals(debugMode)) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<h1>✅ DepositServlet Working!</h1>");
            response.getWriter().println("<p>Servlet mapping works correctly.</p>");
            response.getWriter().println("<p>BookingId: " + request.getParameter("bookingId") + "</p>");
            response.getWriter().println("<p>Session user: " + SessionUtil.getSessionAttribute(request, "user") + "</p>");
            return;
        }
        
        try {
            // 1. Kiểm tra đăng nhập - SỬ DỤNG PATTERN GIỐNG CÁC SERVLET KHÁC
            User user = (User) SessionUtil.getSessionAttribute(request, "user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
                return;
            }
            
            // 2. Lấy bookingId từ URL
            String bookingIdStr = request.getParameter("bookingId");
            if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
                request.setAttribute("errorMessage", "Thiếu bookingId trên URL!");
                request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
                return;
            }
            
            try {
                java.util.UUID bookingId = java.util.UUID.fromString(bookingIdStr);
                java.util.UUID userId = user.getUserId(); // Lấy từ User object
                
                System.out.println("=== DEBUG DepositServlet ===");
                System.out.println("BookingId từ URL: " + bookingIdStr);
                System.out.println("BookingId UUID: " + bookingId);
                System.out.println("UserId: " + userId);
                
                Service.Deposit.DepositService depositService = new Service.Deposit.DepositService(new Repository.Deposit.DepositRepository(), new Repository.Deposit.TermsRepository());
                Model.DTO.Deposit.DepositPageDTO depositPageDTO = depositService.getDepositPageData(bookingId, userId);
                
                // Đảm bảo bookingId luôn được set vào DTO
                depositPageDTO.setBookingId(bookingId);
                System.out.println("DepositPageDTO bookingId: " + depositPageDTO.getBookingId());
                
                request.setAttribute("depositPageData", depositPageDTO);
                request.getRequestDispatcher("/pages/booking-form/booking-form-deposit.jsp").forward(request, response);
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("errorMessage", "Lỗi khi lấy dữ liệu đặt cọc: " + e.getMessage());
                request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            }
            
        } catch (SecurityException e) {
            LOGGER.warning("🔒 Security error: " + e.getMessage());
            request.setAttribute("errorMessage", "Bạn không có quyền truy cập booking này");
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            
        } catch (IllegalStateException e) {
            LOGGER.warning("⚠️ State error: " + e.getMessage());
            request.setAttribute("errorMessage", e.getMessage());
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.severe("❌ Unexpected error in DepositServlet: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("errorMessage", "Đã xảy ra lỗi hệ thống: " + e.getMessage());
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }

    // ========== POST METHOD - XỬ LÝ AJAX ACTIONS ==========
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // 1. Kiểm tra đăng nhập - SỬ DỤNG PATTERN GIỐNG CÁC SERVLET KHÁC
            User user = (User) SessionUtil.getSessionAttribute(request, "user");
            if (user == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Chưa đăng nhập\"}");
                return;
            }

            // 2. Lấy action và bookingId
            String action = request.getParameter("action");
            String bookingIdParam = request.getParameter("bookingId");
            
            if (action == null || bookingIdParam == null) {
                response.getWriter().write("{\"success\": false, \"message\": \"Thiếu tham số\"}");
                return;
            }

            UUID bookingId = UUID.fromString(bookingIdParam);
            UUID userId = user.getUserId(); // Lấy từ User object

            // 3. Xử lý theo action
            switch (action) {
                case "agreeTerms":
                    handleAgreeTerms(bookingId, userId, response);
                    break;
                case "applyVoucher":
                    String voucherCode = request.getParameter("voucherCode");
                    handleApplyVoucher(bookingId, voucherCode, userId, response);
                    break;
                case "removeVoucher":
                    handleRemoveVoucher(bookingId, userId, response);
                    break;
                case "recalculate":
                    handleRecalculate(bookingId, userId, response);
                    break;
                default:
                    response.getWriter().write("{\"success\": false, \"message\": \"Action không hợp lệ\"}");
                    break;
            }

        } catch (Exception e) {
            LOGGER.severe("Lỗi khi xử lý POST deposit: " + e.getMessage());
            response.getWriter().write("{\"success\": false, \"message\": \"Lỗi server: " + e.getMessage() + "\"}");
        }
    }

    // ========== HELPER METHODS - CÁC PHƯƠNG THỨC HỖ TRỢ ==========

    // ========== XÓA CÁC METHOD TÍNH TOÁN (CHUYỂN VỀ SERVICE) ==========
    
    // Method calculateDepositInfoFromDTO() đã được chuyển về DepositService.calculateDepositInfo()
    // Method createVATSurcharge() đã được chuyển về DepositService.createVATSurchargeRecord()
    // Method createFallbackDepositInfo() đã được chuyển về DepositService.createFallbackDepositInfo()


    /**
     * Xử lý đồng ý điều khoản - ỦY QUYỀN CHO SERVICE
     */
    private void handleAgreeTerms(UUID bookingId, UUID userId, HttpServletResponse response) throws IOException {
        try {
            // Lấy version mới nhất từ DB
            Repository.Deposit.TermsRepository termsRepository = new Repository.Deposit.TermsRepository();
            String latestVersion = termsRepository.getLatestVersion();
            
            // Gọi service xử lý agree terms
            boolean termsAgreed = depositService.agreeToTerms(bookingId, userId, latestVersion);
            
            if (termsAgreed) {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": true, \"message\": \"Terms agreed successfully\"}");
            } else {
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to agree to terms\"}");
            }
            
        } catch (Exception e) {
            LOGGER.severe("❌ Error agreeing to terms: " + e.getMessage());
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Error processing terms agreement\"}");
        }
    }

    /**
     * Xử lý áp dụng voucher - ỦY QUYỀN CHO SERVICE
     */
    private void handleApplyVoucher(UUID bookingId, String voucherCode, UUID userId, HttpServletResponse response) throws IOException {
        try {
            LOGGER.info("=== APPLYING VOUCHER VIA SERVLET ===");
            LOGGER.info("Booking ID: " + bookingId);
            LOGGER.info("Voucher Code: " + voucherCode);
            LOGGER.info("User ID: " + userId);
            
            // GỌI SERVICE XỬ LÝ VOUCHER LOGIC
            boolean voucherApplied = depositService.applyVoucher(bookingId, voucherCode, userId);
            
            if (voucherApplied) {
                // Sử dụng method mới từ DepositService để tạo JSON response
                String jsonResponse = depositService.createVoucherResponse(true, "Voucher applied successfully", bookingId, userId);
                response.setContentType("application/json");
                response.getWriter().write(jsonResponse);
                LOGGER.info("Voucher applied successfully");
            } else {
                // Voucher không hợp lệ
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Invalid voucher code\"}");
                LOGGER.warning("Voucher application failed - invalid code");
            }
            
        } catch (Exception e) {
            LOGGER.severe("❌ Error applying voucher: " + e.getMessage());
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra khi áp dụng voucher\"}");
        }
    }

    /**
     * Xử lý xóa voucher - ỦY QUYỀN CHO SERVICE
     */
    private void handleRemoveVoucher(UUID bookingId, UUID userId, HttpServletResponse response) throws IOException {
        try {
            LOGGER.info("=== REMOVING VOUCHER VIA SERVLET ===");
            LOGGER.info("Booking ID: " + bookingId);
            LOGGER.info("User ID: " + userId);
            
            // GỌI SERVICE XỬ LÝ REMOVE VOUCHER LOGIC
            boolean voucherRemoved = depositService.removeVoucher(bookingId, userId);
            
            if (voucherRemoved) {
                // Sử dụng method mới từ DepositService để tạo JSON response
                String jsonResponse = depositService.createVoucherResponse(true, "Voucher removed successfully", bookingId, userId);
                response.setContentType("application/json");
                response.getWriter().write(jsonResponse);
                LOGGER.info("Voucher removed successfully");
            } else {
                // Không thể xóa voucher
                response.setContentType("application/json");
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to remove voucher\"}");
                LOGGER.warning("Voucher removal failed");
            }
            
        } catch (Exception e) {
            LOGGER.severe("❌ Error removing voucher: " + e.getMessage());
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Có lỗi xảy ra khi xóa voucher\"}");
        }
    }

    /**
     * Xử lý tính lại giá - TRẢ VỀ DỮ LIỆU MỚI
     */
    private void handleRecalculate(UUID bookingId, UUID userId, HttpServletResponse response) throws IOException {
        try {
            // GỌI SERVICE RECALCULATE
            DepositPageDTO recalculatedData = depositService.recalculateCost(bookingId);
            
            // Trả về JSON với dữ liệu mới
            String jsonResponse = String.format(
                "{\"success\": true, \"baseAmount\": %.0f, \"insuranceAmount\": %.0f, \"vatAmount\": %.0f, \"totalAmount\": %.0f, \"depositAmount\": %.0f}",
                recalculatedData.getBaseRentalPrice(), recalculatedData.getTotalInsuranceAmount(),
                recalculatedData.getVatAmount(), recalculatedData.getTotalAmount(),
                recalculatedData.getDepositAmount()
            );
            
            response.setContentType("application/json");
            response.getWriter().write(jsonResponse);
            
        } catch (Exception e) {
            LOGGER.severe("❌ Error recalculating: " + e.getMessage());
            response.setContentType("application/json");
            response.getWriter().write("{\"success\": false, \"message\": \"Error recalculating costs\"}");
        }
    }

}
 