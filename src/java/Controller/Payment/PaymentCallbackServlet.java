package Controller.Payment;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

import Config.PaymentConfig;
import Service.Payment.PaymentService;
import Utils.VNPayUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "PaymentCallbackServlet", urlPatterns = {
    "/payment/return",
    "/payment/cancel",
    "/payment/error"
})
public class PaymentCallbackServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(PaymentCallbackServlet.class.getName());
    private PaymentService paymentService;

    @Override
    public void init() throws ServletException {
        this.paymentService = new PaymentService();
        LOGGER.info("PaymentCallbackServlet initialized with VNPay support");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String pathInfo = request.getServletPath();
        
        System.out.println("=== VNPay Callback Received ===");
        System.out.println("Path: " + pathInfo);
        System.out.println("Query String: " + request.getQueryString());
        
        // Log all parameters
        System.out.println("Parameters:");
        request.getParameterMap().forEach((key, values) -> {
            System.out.println("- " + key + ": " + String.join(", ", values));
        });

        try {
            if ("/payment/return".equals(pathInfo)) {
                handleVNPayReturn(request, response);
            } else if ("/payment/cancel".equals(pathInfo)) {
                handleCancel(request, response);
            } else if ("/payment/error".equals(pathInfo)) {
                handleError(request, response);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing payment callback", e);
            redirectToError(request, response, "SYSTEM_ERROR", "System error: " + e.getMessage(), null, null);
        }
    }

    private void handleVNPayReturn(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=== Processing VNPay Return ===");
        
        try {
            // Lấy thông tin từ VNPay response
            String vnpTxnRef = request.getParameter("vnp_TxnRef");
            String vnpTransactionStatus = request.getParameter("vnp_TransactionStatus");
            String vnpResponseCode = request.getParameter("vnp_ResponseCode");
            String vnpTransactionNo = request.getParameter("vnp_TransactionNo");
            String vnpAmount = request.getParameter("vnp_Amount");
            String vnpSecureHash = request.getParameter("vnp_SecureHash");
            
            System.out.println("VNPay Response Details:");
            System.out.println("- TxnRef: " + vnpTxnRef);
            System.out.println("- TransactionStatus: " + vnpTransactionStatus);
            System.out.println("- ResponseCode: " + vnpResponseCode);
            System.out.println("- TransactionNo: " + vnpTransactionNo);
            System.out.println("- Amount: " + vnpAmount);
            System.out.println("- SecureHash: " + vnpSecureHash);
            
            // Log tất cả parameters nhận được
            System.out.println("All Parameters:");
            request.getParameterMap().forEach((key, values) -> {
                System.out.println("- " + key + ": " + String.join(", ", values));
            });
            
            // Xác thực chữ ký từ VNPay - sử dụng logic từ VNPay mẫu
            System.out.println("=== Starting Signature Validation ===");
            boolean isValidSignature = VNPayUtils.validateSignature(request, PaymentConfig.getHashSecret());
            System.out.println("=== Signature Validation Result: " + isValidSignature + " ===");
            
            if (!isValidSignature) {
                System.out.println("❌ Invalid signature from VNPay");
                System.out.println("Expected signature validation to pass, but it failed.");
                System.out.println("This could be due to:");
                System.out.println("1. Different encoding between creation and validation");
                System.out.println("2. Different parameter ordering");
                System.out.println("3. Different hash algorithm");
                System.out.println("4. Wrong secret key");
                
                redirectToError(request, response, "INVALID_SIGNATURE", 
                    "Invalid signature from VNPay", vnpTxnRef, vnpResponseCode);
                return;
            }
            
            System.out.println("✅ Valid signature from VNPay");
            
            if (vnpTxnRef == null || vnpTransactionStatus == null) {
                System.out.println("❌ Missing required parameters from VNPay");
                redirectToError(request, response, "MISSING_PARAMS", 
                    "Thiếu thông tin cần thiết từ VNPay", vnpTxnRef, vnpResponseCode);
                    return;
                }
            
            // Xử lý kết quả thanh toán
            boolean success = paymentService.processPaymentCallback(vnpTxnRef, vnpTransactionStatus);
            
            if (success && "00".equals(vnpTransactionStatus)) {
                System.out.println("✅ Payment successful");
                
                // Kiểm tra loại thanh toán để redirect đúng trang
                String paymentType = paymentService.getPaymentTypeByTxnRef(vnpTxnRef);
                if ("FinalPayment".equals(paymentType)) {
                    // Thanh toán số tiền còn lại
                    response.sendRedirect(request.getContextPath() + "/pages/payment/final-payment-success.jsp");
                } else {
                    // Thanh toán tiền cọc
                    response.sendRedirect(request.getContextPath() + "/pages/deposit/deposit-success.jsp");
                }
            } else {
                System.out.println("❌ Payment failed or cancelled");
                String errorMessage = getVNPayErrorMessage(vnpResponseCode);
                redirectToError(request, response, "PAYMENT_FAILED", 
                    errorMessage, vnpTxnRef, vnpResponseCode);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error processing VNPay return", e);
            redirectToError(request, response, "DATABASE_ERROR", 
                "Database error: " + e.getMessage(), 
                request.getParameter("vnp_TxnRef"), 
                request.getParameter("vnp_ResponseCode"));
        }
    }

    private void handleCancel(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=== Processing Payment Cancel ===");
        
        try {
            String vnpTxnRef = request.getParameter("vnp_TxnRef");
            String vnpResponseCode = request.getParameter("vnp_ResponseCode");
            
            if (vnpTxnRef != null) {
                // Cập nhật trạng thái payment thành Cancelled
                paymentService.processPaymentCallback(vnpTxnRef, "Cancelled");
            }
            // Chuyển về trang cancel với thông tin chi tiết
            String cancelUrl = request.getContextPath() + "/pages/deposit/deposit-cancel.jsp";
            if (vnpTxnRef != null) {
                cancelUrl += "?txnRef=" + URLEncoder.encode(vnpTxnRef, StandardCharsets.UTF_8);
            }
            response.sendRedirect(cancelUrl);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error processing cancelled payment", e);
            redirectToError(request, response, "DATABASE_ERROR", 
                "Database error when cancelling payment: " + e.getMessage(), 
                request.getParameter("vnp_TxnRef"), 
                request.getParameter("vnp_ResponseCode"));
        }
    }
    
    private void handleError(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("=== Processing Payment Error ===");
        
        try {
            String vnpTxnRef = request.getParameter("vnp_TxnRef");
            String vnpResponseCode = request.getParameter("vnp_ResponseCode");
            
            if (vnpTxnRef != null) {
                // Cập nhật trạng thái payment thành Failed
                paymentService.processPaymentCallback(vnpTxnRef, "Failed");
            }
            
            String errorMessage = getVNPayErrorMessage(vnpResponseCode);
            redirectToError(request, response, "VNPAY_ERROR", 
                errorMessage, vnpTxnRef, vnpResponseCode);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error processing failed payment", e);
            redirectToError(request, response, "DATABASE_ERROR", 
                "Database error when processing payment error: " + e.getMessage(), 
                request.getParameter("vnp_TxnRef"), 
                request.getParameter("vnp_ResponseCode"));
        }
    }
    
    private void redirectToError(HttpServletRequest request, HttpServletResponse response, 
                                String errorCode, String errorMessage, 
                                String txnRef, String responseCode) throws IOException {
        StringBuilder errorUrl = new StringBuilder();
        errorUrl.append(request.getContextPath()).append("/pages/deposit/deposit-error.jsp");
        
        // Thêm các parameters
        errorUrl.append("?errorCode=").append(URLEncoder.encode(errorCode, StandardCharsets.UTF_8));
        errorUrl.append("&errorMessage=").append(URLEncoder.encode(errorMessage, StandardCharsets.UTF_8));
        
        if (txnRef != null) {
            errorUrl.append("&txnRef=").append(URLEncoder.encode(txnRef, StandardCharsets.UTF_8));
        }
        
        if (responseCode != null) {
            errorUrl.append("&responseCode=").append(URLEncoder.encode(responseCode, StandardCharsets.UTF_8));
        }
        
        System.out.println("Redirecting to error page: " + errorUrl.toString());
        response.sendRedirect(errorUrl.toString());
    }
    
    private String getVNPayErrorMessage(String responseCode) {
        if (responseCode == null) {
            return "Unable to determine error code";
        }
        
        switch (responseCode) {
            case "00":
                return "Transaction successful";
            case "07":
                return "Debit successful. Transaction suspected (related to fraud, unusual transaction)";
            case "09":
                return "Transaction failed because: Customer's Card/Account has not registered for InternetBanking service at the bank";
            case "10":
                return "Transaction failed because: Customer verified incorrect card/account information more than 3 times";
            case "11":
                return "Transaction failed because: Payment waiting time has expired. Please retry the transaction";
            case "12":
                return "Transaction failed because: Customer's Card/Account is locked";
            case "13":
                return "Transaction failed because: Customer entered incorrect transaction verification password (OTP)";
            case "24":
                return "Transaction failed because: Customer cancelled the transaction";
            case "51":
                return "Transaction failed because: Customer's account has insufficient balance to perform the transaction";
            case "65":
                return "Transaction failed because: Customer's account has exceeded the daily transaction limit";
            case "75":
                return "Payment bank is under maintenance";
            case "79":
                return "Transaction failed because: Customer entered incorrect payment password too many times";
            case "99":
                return "Other errors (remaining errors, not listed in the error code list)";
            default:
                return "Unknown error from VNPay (Code: " + responseCode + ")";
        }
    }
}
