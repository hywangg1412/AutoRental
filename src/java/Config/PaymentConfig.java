package Config;

import java.io.InputStream;
import java.util.Properties;
import java.util.logging.Level;
import java.util.logging.Logger;

import io.github.cdimascio.dotenv.Dotenv;

/**
 * Lớp cấu hình VNPay - Quản lý thông tin xác thực thanh toán
 *
 * Chức năng chính: - Đọc thông tin cấu hình VNPay từ nhiều nguồn khác nhau - Ưu
 * tiên: Biến môi trường hệ thống → File .env → File payment.properties - Cung
 * cấp các phương thức để lấy thông tin cấu hình VNPay
 *
 * @author Nhóm SWP
 */
public class PaymentConfig {

    // Logger để ghi log quá trình cấu hình
    private static final Logger LOGGER = Logger.getLogger(PaymentConfig.class.getName());

    // Đối tượng để đọc file .env
    private static Dotenv dotenv;

    // Đối tượng để đọc file payment.properties
    private static Properties properties;

    /**
     * Khối static - Chạy khi class được load lần đầu Nhiệm vụ: Khởi tạo và load
     * cấu hình từ các nguồn khác nhau
     */
    static {
        LOGGER.info("=== BẮT ĐẦU KHỞI TẠO CẤU HÌNH VNPAY ===");

        // BƯỚC 1: Khởi tạo file .env
        initializeEnvFile();

        // BƯỚC 2: Khởi tạo file payment.properties
        initializePropertiesFile();

        LOGGER.info("=== HOÀN THÀNH KHỞI TẠO CẤU HÌNH VNPAY ===");
    }

    /**
     * Khởi tạo file .env Đọc file .env từ thư mục gốc của dự án
     */
    private static void initializeEnvFile() {
        try {
            // Cấu hình và load file .env
            dotenv = Dotenv.configure()
                    .ignoreIfMissing() // Không báo lỗi nếu thiếu file
                    .ignoreIfMalformed() // Không báo lỗi nếu file có lỗi format
                    .load();                       // Thực hiện load file

            // Kiểm tra xem có load thành công không
            if (dotenv != null && dotenv.get("VNPAY_TMN_CODE") != null) {
                LOGGER.info("✅ Đã load thành công file .env");
                LOGGER.info("✅ VNPAY_TMN_CODE từ .env: " + dotenv.get("VNPAY_TMN_CODE"));
            } else {
                LOGGER.info("⚠️ Không tìm thấy file .env hoặc không có VNPAY_TMN_CODE, sử dụng payment.properties");
            }

        } catch (Exception e) {
            LOGGER.log(Level.INFO, "⚠️ Không thể load file .env: " + e.getMessage());
            dotenv = null;
        }
    }
    
    /**
     * Khởi tạo file payment.properties Đọc file payment.properties từ thư mục
     * resources
     */
    private static void initializePropertiesFile() {
        try {
            properties = new Properties();

            // Đọc file payment.properties từ classpath (thư mục resources)
            InputStream inputStream = PaymentConfig.class.getClassLoader()
                    .getResourceAsStream("payment.properties");

            if (inputStream != null) {
                properties.load(inputStream);
                LOGGER.info("✅ Đã load thành công file payment.properties");
                inputStream.close();
            } else {
                LOGGER.warning("⚠️ Không tìm thấy file payment.properties");
            }

        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "❌ Lỗi khi load file payment.properties: " + e.getMessage(), e);
            properties = null;
        }
    }

    /**
     * Phương thức chính để lấy giá trị cấu hình Thứ tự ưu tiên: System
     * Environment → File .env → File payment.properties
     *
     * @param environmentVariableName Tên biến môi trường cần lấy
     * @return Giá trị của biến môi trường
     * @throws RuntimeException Nếu không tìm thấy biến môi trường ở bất kỳ
     * nguồn nào
     */
    private static String getConfigValue(String environmentVariableName) {
        LOGGER.info("🔍 Đang tìm biến môi trường: " + environmentVariableName);

        // ƯU TIÊN 1: Biến môi trường hệ thống
        String systemEnvValue = System.getenv(environmentVariableName);
        if (systemEnvValue != null && !systemEnvValue.isEmpty()) {
            LOGGER.info("✅ Tìm thấy trong biến môi trường hệ thống: " + environmentVariableName);
            return systemEnvValue;
        }

        // ƯU TIÊN 2: File .env
        if (dotenv != null) {
            String envFileValue = dotenv.get(environmentVariableName);
            if (envFileValue != null && !envFileValue.isEmpty()) {
                LOGGER.info("✅ Tìm thấy trong file .env: " + environmentVariableName);
                return envFileValue;
            }
        }

        // ƯU TIÊN 3: File payment.properties (chuyển đổi tên biến)
        if (properties != null) {
            String propertyName = convertToPropertyName(environmentVariableName);
            String propertyValue = properties.getProperty(propertyName);
            if (propertyValue != null && !propertyValue.isEmpty()) {
                LOGGER.info("✅ Tìm thấy trong payment.properties: " + propertyName);
                return propertyValue;
            }
        }

        // Nếu không tìm thấy ở đâu cả, báo lỗi
        String errorMessage = "❌ Không tìm thấy biến môi trường: " + environmentVariableName;
        LOGGER.severe(errorMessage);
        throw new RuntimeException(errorMessage);
    }

    /**
     * Chuyển đổi tên biến môi trường sang tên trong file properties Ví dụ:
     * VNPAY_TMN_CODE → vnpay.tmn.code
     *
     * @param environmentVariableName Tên biến môi trường
     * @return Tên tương ứng trong file properties
     */
    private static String convertToPropertyName(String environmentVariableName) {
        switch (environmentVariableName) {
            case "VNPAY_TMN_CODE":
                return "vnpay.tmn.code";
            case "VNPAY_HASH_SECRET":
                return "vnpay.hash.secret";
            case "VNPAY_PAY_URL":
                return "vnpay.pay.url";
            case "VNPAY_RETURN_URL":
                return "vnpay.return.url";
            case "VNPAY_CANCEL_URL":
                return "vnpay.cancel.url";
            case "VNPAY_ERROR_URL":
                return "vnpay.error.url";
            case "VNPAY_API_URL":
                return "vnpay.api.url";
            default:
                // Chuyển đổi mặc định: VNPAY_TMN_CODE → vnpay.tmn.code
                return environmentVariableName.toLowerCase().replace("_", ".");
        }
    }

    // ===================================================================
    // CÁC PHƯƠNG THỨC PUBLIC ĐỂ LẤY THÔNG TIN CẤU HÌNH VNPAY
    // ===================================================================
    /**
     * Lấy VNPay Terminal/Merchant Code
     *
     * @return Terminal Code để xác thực với VNPay
     */
    public static String getTmnCode() {
        return getConfigValue("VNPAY_TMN_CODE");
    }

    /**
     * Lấy VNPay Hash Secret
     *
     * @return Hash Secret để tạo chữ ký bảo mật
     */
    public static String getHashSecret() {
        return getConfigValue("VNPAY_HASH_SECRET");
    }
    
    /**
     * Lấy VNPay Payment URL
     *
     * @return Payment URL để redirect khách hàng
     */
    public static String getPayUrl() {
        return getConfigValue("VNPAY_PAY_URL");
    }

    /**
     * Lấy URL chuyển hướng khi thanh toán thành công/thất bại
     *
     * @return Return URL
     */
    public static String getReturnUrl() {
        return getConfigValue("VNPAY_RETURN_URL");
    }
    
    /**
     * Lấy URL chuyển hướng khi hủy thanh toán
     *
     * @return Cancel URL
     */
    public static String getCancelUrl() {
        return getConfigValue("VNPAY_CANCEL_URL");
    }

    /**
     * Lấy URL chuyển hướng khi có lỗi thanh toán
     *
     * @return Error URL
     */
    public static String getErrorUrl() {
        return getConfigValue("VNPAY_ERROR_URL");
    }
    
    /**
     * Lấy VNPay API Base URL
     *
     * @return VNPay API Base URL
     */
    public static String getVNPayApiUrl() {
        try {
            return getConfigValue("VNPAY_API_URL");
        } catch (RuntimeException e) {
            // Fallback to default VNPay API URL
            LOGGER.info("⚠️ Không tìm thấy VNPAY_API_URL, sử dụng URL mặc định");
            return "https://sandbox.vnpayment.vn/merchant_webapi/api/transaction";
    }
    }
}
