package Controller.Payment;

import java.io.IOException;
import java.sql.SQLException;
import java.util.UUID;

import com.google.gson.Gson;

import Model.DTO.PaymentDTO;
import Model.Entity.User.User;
import Service.Payment.PaymentService;
import Utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "PaymentServlet", urlPatterns = {"/api/payment/*"})
public class PaymentServlet extends HttpServlet {
    private PaymentService paymentService;
    private final Gson gson = new Gson();
    
    @Override
    public void init() throws ServletException {
        System.out.println("=== PaymentServlet INIT ===");
        System.out.println("Servlet được khởi tạo thành công!");
        this.paymentService = new PaymentService();
        System.out.println("PaymentService với VNPay được khởi tạo thành công!");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("=== PaymentServlet doPost ===");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Context Path: " + request.getContextPath());
        System.out.println("Servlet Path: " + request.getServletPath());
        System.out.println("Path Info: " + request.getPathInfo());
        
        String pathInfo = request.getPathInfo();
        
        if (pathInfo == null || pathInfo.equals("/")) {
            System.out.println("ERROR: PathInfo null hoặc rỗng");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid path");
            return;
        }
        
        switch (pathInfo) {
            case "/create":
                System.out.println("Gọi handleCreatePayment");
                handleCreatePayment(request, response);
                break;
            case "/callback":
                System.out.println("Gọi handlePaymentCallback");
                handlePaymentCallback(request, response);
                break;
            default:
                System.out.println("ERROR: Path không được hỗ trợ: " + pathInfo);
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Path not supported: " + pathInfo);
                break;
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        System.out.println("=== PaymentServlet doGet ===");
        System.out.println("Request URI: " + request.getRequestURI());
        System.out.println("Path Info: " + request.getPathInfo());
        
        // Cho phép GET cho /create để test
        String pathInfo = request.getPathInfo();
        if ("/create".equals(pathInfo)) {
            handleCreatePayment(request, response);
            return;
        }
        
        if (pathInfo == null || pathInfo.equals("/")) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid path");
            return;
        }
        
        if (pathInfo.startsWith("/status/")) {
            String paymentId = pathInfo.substring("/status/".length());
            handleGetPaymentStatus(UUID.fromString(paymentId), response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Path not found: " + pathInfo);
        }
    }
    
    private void handleCreatePayment(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        System.out.println("=== handleCreatePayment START ===");
        System.out.println("Query String: " + request.getQueryString());
        
        // SỬ DỤNG PATTERN GIỐNG CÁC SERVLET KHÁC
        User user = (User) SessionUtil.getSessionAttribute(request, "user");
        if (user == null) {
            System.out.println("ERROR: User chưa đăng nhập");
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Bạn chưa đăng nhập hoặc phiên đăng nhập đã hết hạn!");
            return;
        }
        UUID userId = user.getUserId();
        System.out.println("User ID từ User object: " + userId);
        
        // Lấy bookingId từ query parameter
        String bookingId = request.getParameter("bookingId");
        System.out.println("BookingId từ query parameter: '" + bookingId + "'");
        
        // Kiểm tra bookingId
        if (bookingId == null || bookingId.trim().isEmpty()) {
            System.out.println("ERROR: BookingId null/empty");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu bookingId! Vui lòng kiểm tra lại request.");
            return;
        }

        System.out.println("BookingId final: '" + bookingId + "'");
        System.out.println("Gọi PaymentService.createDepositPayment với logic mới...");
        
        try {
            // Gọi service để tạo payment và lấy VNPay URL
            // Sử dụng logic mới từ DepositService (300K hoặc 10%)
            PaymentDTO paymentDTO = paymentService.createDepositPayment(
                UUID.fromString(bookingId), 
                userId
            );
            
            if (paymentDTO == null || paymentDTO.getQrCode() == null) {
                System.out.println("ERROR: PaymentDTO null hoặc QrCode null");
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể tạo payment link!");
                return;
            }
            
            // Redirect đến VNPay payment page
            String paymentUrl = paymentDTO.getQrCode();
            System.out.println("Redirecting to VNPay: " + paymentUrl);
            response.sendRedirect(paymentUrl);
            
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("VNPay error: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không thể tạo link thanh toán VNPay: " + e.getMessage());
        }
        
        System.out.println("=== handleCreatePayment END ===");
    }
    
    private void handlePaymentCallback(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        response.setContentType("application/json");
        
        String transactionId = request.getParameter("transactionId");
        String status = request.getParameter("status");
        
        if (transactionId == null || status == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing parameters");
            return;
        }
        
        try {
            boolean success = paymentService.processPaymentCallback(transactionId, status);
            if (!success) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Could not process payment callback");
                return;
            }
            
            response.getWriter().write("{\"success\": true}");
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("DEBUG ERROR: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
    
    private void handleGetPaymentStatus(UUID paymentId, HttpServletResponse response) 
            throws IOException {
        response.setContentType("application/json");
        
        try {
            PaymentDTO paymentDTO = paymentService.getPaymentStatus(paymentId);
            if (paymentDTO == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Payment not found");
                return;
            }
            
            response.getWriter().write(gson.toJson(paymentDTO));
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("DEBUG ERROR: " + e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, e.getMessage());
        }
    }
} 