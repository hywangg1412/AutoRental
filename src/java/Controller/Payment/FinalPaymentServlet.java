package Controller.Payment;

import Model.DTO.Payment.FinalPaymentDTO;
import Service.Payment.FinalPaymentService;
import Service.Payment.PaymentService;
import Utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Servlet for processing remaining payment after car inspection
 */
@WebServlet(name = "FinalPaymentServlet", urlPatterns = {"/payment/final-payment"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024, // 1MB
    maxFileSize = 1024 * 1024 * 10,  // 10MB
    maxRequestSize = 1024 * 1024 * 50 // 50MB
)
public class FinalPaymentServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(FinalPaymentServlet.class.getName());
    private final FinalPaymentService finalPaymentService = new FinalPaymentService();
    private final PaymentService paymentService = new PaymentService();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Check login
        String userIdStr = (String) SessionUtil.getSessionAttribute(request, "userId");
        if (userIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }
        
        try {
            UUID userId = UUID.fromString(userIdStr);
            
            // Get bookingId from parameter
            String bookingIdStr = request.getParameter("bookingId");
            if (bookingIdStr == null) {
                request.setAttribute("errorMessage", "Missing booking information");
                request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
                return;
            }
            
            UUID bookingId = UUID.fromString(bookingIdStr);
            
            // Check if booking can be paid
            if (!finalPaymentService.canProcessFinalPayment(bookingId)) {
                request.setAttribute("errorMessage", "Booking cannot process remaining payment");
                request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
                return;
            }
            
            // Get payment information
            FinalPaymentDTO paymentData = finalPaymentService.getFinalPaymentData(bookingId);
            request.setAttribute("paymentData", paymentData);
            
            // Forward to payment page
            request.getRequestDispatcher("/pages/payment/final-payment.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in doGet: {0}", e.getMessage());
            request.setAttribute("errorMessage", "Error: " + e.getMessage());
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        
        PrintWriter out = response.getWriter();
        
        try {
            // Check login
            String userIdStr = (String) SessionUtil.getSessionAttribute(request, "userId");
            if (userIdStr == null) {
                out.print("{\"success\":false,\"message\":\"Please login\"}");
                return;
            }
            
            UUID userId = UUID.fromString(userIdStr);
            
            // Get bookingId from parameter
            String bookingIdStr = request.getParameter("bookingId");
            LOGGER.info("Received bookingId parameter: " + bookingIdStr);
            
            if (bookingIdStr == null || bookingIdStr.trim().isEmpty()) {
                LOGGER.warning("Missing or empty bookingId parameter");
                out.print("{\"success\":false,\"message\":\"Missing booking information\"}");
                return;
            }
            
            UUID bookingId = UUID.fromString(bookingIdStr);
            LOGGER.info("Processing final payment for booking: " + bookingId);
            
            // Check if booking can be paid
            if (!finalPaymentService.canProcessFinalPayment(bookingId)) {
                LOGGER.warning("Booking " + bookingId + " cannot process final payment");
                out.print("{\"success\":false,\"message\":\"Booking cannot process remaining payment\"}");
                return;
            }
            
            // Get payment information
            FinalPaymentDTO paymentData = finalPaymentService.getFinalPaymentData(bookingId);
            LOGGER.info("Final payment data retrieved. Final amount: " + paymentData.getFinalAmount());

            // Create VNPay payment URL
            String paymentUrl = paymentService.createFinalPaymentUrl(bookingId, userId, paymentData.getFinalAmount());

            if (paymentUrl != null && !paymentUrl.isEmpty()) {
                LOGGER.info("Payment URL created successfully: " + paymentUrl);
                out.print("{\"success\":true,\"paymentUrl\":\"" + paymentUrl + "\"}");
            } else {
                LOGGER.warning("Failed to create payment URL");
                out.print("{\"success\":false,\"message\":\"Cannot create payment URL\"}");
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in doPost: {0}", e.getMessage());
            out.print("{\"success\":false,\"message\":\"Error: " + e.getMessage() + "\"}");
        }
    }
} 