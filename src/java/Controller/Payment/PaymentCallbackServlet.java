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
            redirectToError(request, response, "SYSTEM_ERROR", "Lỗi hệ thống: " + e.getMessage(), null, null);
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
                    "Chữ ký không hợp lệ từ VNPay", vnpTxnRef, vnpResponseCode);
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
                response.sendRedirect(request.getContextPath() + "/pages/deposit/deposit-success.jsp");
            } else {
                System.out.println("❌ Payment failed or cancelled");
                String errorMessage = getVNPayErrorMessage(vnpResponseCode);
                redirectToError(request, response, "PAYMENT_FAILED", 
                    errorMessage, vnpTxnRef, vnpResponseCode);
            }
            
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error processing VNPay return", e);
            redirectToError(request, response, "DATABASE_ERROR", 
                "Lỗi cơ sở dữ liệu: " + e.getMessage(), 
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
                "Lỗi cơ sở dữ liệu khi hủy thanh toán: " + e.getMessage(), 
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
                "Lỗi cơ sở dữ liệu khi xử lý lỗi thanh toán: " + e.getMessage(), 
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
            return "Không xác định được mã lỗi";
        }
        
        switch (responseCode) {
            case "00":
                return "Giao dịch thành công";
            case "07":
                return "Trừ tiền thành công. Giao dịch bị nghi ngờ (liên quan tới lừa đảo, giao dịch bất thường)";
            case "09":
                return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng chưa đăng ký dịch vụ InternetBanking tại ngân hàng";
            case "10":
                return "Giao dịch không thành công do: Khách hàng xác thực thông tin thẻ/tài khoản không đúng quá 3 lần";
            case "11":
                return "Giao dịch không thành công do: Đã hết hạn chờ thanh toán. Xin quý khách vui lòng thực hiện lại giao dịch";
            case "12":
                return "Giao dịch không thành công do: Thẻ/Tài khoản của khách hàng bị khóa";
            case "13":
                return "Giao dịch không thành công do: Quý khách nhập sai mật khẩu xác thực giao dịch (OTP)";
            case "24":
                return "Giao dịch không thành công do: Khách hàng hủy giao dịch";
            case "51":
                return "Giao dịch không thành công do: Tài khoản của quý khách không đủ số dư để thực hiện giao dịch";
            case "65":
                return "Giao dịch không thành công do: Tài khoản của Quý khách đã vượt quá hạn mức giao dịch trong ngày";
            case "75":
                return "Ngân hàng thanh toán đang bảo trì";
            case "79":
                return "Giao dịch không thành công do: KH nhập sai mật khẩu thanh toán quá số lần quy định";
            case "99":
                return "Các lỗi khác (lỗi còn lại, không có trong danh sách mã lỗi đã liệt kê)";
            default:
                return "Lỗi không xác định từ VNPay (Mã: " + responseCode + ")";
        }
    }
}
