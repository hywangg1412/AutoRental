package Utils;

import java.math.BigDecimal;
import java.text.NumberFormat;
import java.util.Locale;

/**
 * Utility class để xử lý giá tiền trong hệ thống
 * Hỗ trợ chuyển đổi giữa giá trị trong DB và giá trị hiển thị
 */
public class PriceUtils {
    
    // Hệ số chuyển đổi giữa DB và hiển thị
    // Khi giá trong DB thêm 3 số 0, đổi hệ số này thành 1.0
    private static final double PRICE_CONVERSION_FACTOR = 1000.0;
    
    /**
     * Chuyển đổi giá từ DB sang giá hiển thị
     * @param dbPrice giá lưu trong DB
     * @return giá để hiển thị (đã nhân với hệ số)
     */
    public static double fromDbToDisplayPrice(double dbPrice) {
        return dbPrice * PRICE_CONVERSION_FACTOR;
    }
    
    /**
     * Chuyển đổi giá từ hiển thị sang giá lưu DB
     * @param displayPrice giá hiển thị
     * @return giá để lưu vào DB (đã chia cho hệ số)
     */
    public static double fromDisplayToDbPrice(double displayPrice) {
        return displayPrice / PRICE_CONVERSION_FACTOR;
    }
    
    /**
     * Chuyển đổi giá từ DB sang giá hiển thị (BigDecimal)
     * @param dbPrice giá lưu trong DB
     * @return giá để hiển thị (đã nhân với hệ số)
     */
    public static BigDecimal fromDbToDisplayPrice(BigDecimal dbPrice) {
        if (dbPrice == null) return BigDecimal.ZERO;
        return dbPrice.multiply(BigDecimal.valueOf(PRICE_CONVERSION_FACTOR));
    }
    
    /**
     * Chuyển đổi giá từ hiển thị sang giá lưu DB (BigDecimal)
     * @param displayPrice giá hiển thị
     * @return giá để lưu vào DB (đã chia cho hệ số)
     */
    public static BigDecimal fromDisplayToDbPrice(BigDecimal displayPrice) {
        if (displayPrice == null) return BigDecimal.ZERO;
        return displayPrice.divide(BigDecimal.valueOf(PRICE_CONVERSION_FACTOR));
    }
    
    /**
     * Format giá tiền theo định dạng tiền tệ Việt Nam
     * @param price giá tiền cần format
     * @return chuỗi đã được format (VD: "1.000.000 VND")
     */
    public static String formatPrice(double price) {
        NumberFormat currencyFormatter = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
        return currencyFormatter.format(price) + " VND";
    }
    
    /**
     * Format giá tiền theo định dạng tiền tệ Việt Nam
     * @param price giá tiền cần format (BigDecimal)
     * @return chuỗi đã được format (VD: "1.000.000 VND")
     */
    public static String formatPrice(BigDecimal price) {
        if (price == null) return "0 VND";
        NumberFormat currencyFormatter = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
        return currencyFormatter.format(price) + " VND";
    }
    
    /**
     * Format giá tiền từ DB theo định dạng tiền tệ Việt Nam
     * @param dbPrice giá tiền trong DB cần format
     * @return chuỗi đã được format (VD: "1.000.000 VND")
     */
    public static String formatDbPrice(double dbPrice) {
        return formatPrice(fromDbToDisplayPrice(dbPrice));
    }
    
    /**
     * Format giá tiền từ DB theo định dạng tiền tệ Việt Nam
     * @param dbPrice giá tiền trong DB cần format (BigDecimal)
     * @return chuỗi đã được format (VD: "1.000.000 VND")
     */
    public static String formatDbPrice(BigDecimal dbPrice) {
        return formatPrice(fromDbToDisplayPrice(dbPrice));
    }
    
    /**
     * Format giá tiền theo định dạng tiền tệ Việt Nam không có đơn vị
     * @param price giá tiền cần format
     * @return chuỗi đã được format (VD: "1.000.000")
     */
    public static String formatPriceWithoutUnit(double price) {
        NumberFormat currencyFormatter = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
        return currencyFormatter.format(price);
    }
    
    /**
     * Format giá tiền từ DB theo định dạng tiền tệ Việt Nam không có đơn vị
     * @param dbPrice giá tiền trong DB cần format
     * @return chuỗi đã được format (VD: "1.000.000")
     */
    public static String formatDbPriceWithoutUnit(double dbPrice) {
        return formatPriceWithoutUnit(fromDbToDisplayPrice(dbPrice));
    }
} 