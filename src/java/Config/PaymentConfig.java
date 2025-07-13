package Config;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class PaymentConfig {
    
    private static Properties properties;
    private static final String PROPERTIES_FILE = "/payment.properties";
    
    static {
        try {
            properties = new Properties();
            InputStream inputStream = PaymentConfig.class.getClassLoader().getResourceAsStream("payment.properties");
            
            if (inputStream == null) {
                // Thử đọc từ root của project
                inputStream = PaymentConfig.class.getResourceAsStream("/payment.properties");
            }
            
            if (inputStream == null) {
                throw new RuntimeException("Không thể tìm thấy file payment.properties");
            }
            
            properties.load(inputStream);
            inputStream.close();
            
            System.out.println("Đã load thành công file payment.properties");
            
        } catch (IOException e) {
            System.err.println("Lỗi khi đọc file payment.properties: " + e.getMessage());
            throw new RuntimeException("Không thể đọc file payment.properties", e);
        }
    }
    
    public static String getVnpayTmnCode() {
        String tmnCode = properties.getProperty("vnpay.tmn.code");
        if (tmnCode == null || tmnCode.trim().isEmpty()) {
            throw new RuntimeException("VNPay TMN Code không được cấu hình");
        }
        return tmnCode;
    }
    
    public static String getVnpayHashSecret() {
        String hashSecret = properties.getProperty("vnpay.hash.secret");
        if (hashSecret == null || hashSecret.trim().isEmpty()) {
            throw new RuntimeException("VNPay Hash Secret không được cấu hình");
        }
        return hashSecret;
    }
    
    public static String getVnpayPayUrl() {
        String payUrl = properties.getProperty("vnpay.pay.url");
        if (payUrl == null || payUrl.trim().isEmpty()) {
            throw new RuntimeException("VNPay Pay URL không được cấu hình");
        }
        return payUrl;
    }
    
    public static String getVnpayReturnUrl() {
        String returnUrl = properties.getProperty("vnpay.return.url");
        if (returnUrl == null || returnUrl.trim().isEmpty()) {
            throw new RuntimeException("VNPay Return URL không được cấu hình");
        }
        return returnUrl;
    }
    
    public static String getVnpayCancelUrl() {
        String cancelUrl = properties.getProperty("vnpay.cancel.url");
        if (cancelUrl == null || cancelUrl.trim().isEmpty()) {
            throw new RuntimeException("VNPay Cancel URL không được cấu hình");
        }
        return cancelUrl;
    }
    
    public static String getVnpayErrorUrl() {
        String errorUrl = properties.getProperty("vnpay.error.url");
        if (errorUrl == null || errorUrl.trim().isEmpty()) {
            throw new RuntimeException("VNPay Error URL không được cấu hình");
        }
        return errorUrl;
    }
    
    public static String getVnpayApiUrl() {
        String apiUrl = properties.getProperty("vnpay.api.url");
        if (apiUrl == null || apiUrl.trim().isEmpty()) {
            throw new RuntimeException("VNPay API URL không được cấu hình");
        }
        return apiUrl;
    }
    
    /**
     * Kiểm tra xem tất cả các cấu hình VNPay có đầy đủ không
     * @return true nếu tất cả cấu hình đều có giá trị
     */
    public static boolean isVnpayConfigValid() {
        try {
            getVnpayTmnCode();
            getVnpayHashSecret();
            getVnpayPayUrl();
            getVnpayReturnUrl();
            getVnpayCancelUrl();
            getVnpayErrorUrl();
            getVnpayApiUrl();
            return true;
        } catch (RuntimeException e) {
            System.err.println("Cấu hình VNPay không hợp lệ: " + e.getMessage());
            return false;
        }
    }
    
    /**
     * Hiển thị thông tin cấu hình (ẩn sensitive data)
     */
    public static void displayConfigInfo() {
        System.out.println("=== THÔNG TIN CẤU HÌNH VNPAY ===");
        System.out.println("TMN Code: " + maskSensitiveData(getVnpayTmnCode()));
        System.out.println("Hash Secret: " + maskSensitiveData(getVnpayHashSecret()));
        System.out.println("Pay URL: " + getVnpayPayUrl());
        System.out.println("Return URL: " + getVnpayReturnUrl());
        System.out.println("Cancel URL: " + getVnpayCancelUrl());
        System.out.println("Error URL: " + getVnpayErrorUrl());
        System.out.println("API URL: " + getVnpayApiUrl());
        System.out.println("================================");
    }
    
    private static String maskSensitiveData(String data) {
        if (data == null || data.length() <= 4) {
            return "****";
        }
        return data.substring(0, 2) + "****" + data.substring(data.length() - 2);
    }
}
