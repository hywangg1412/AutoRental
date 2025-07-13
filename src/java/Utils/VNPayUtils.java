package Utils;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.TimeZone;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import jakarta.servlet.http.HttpServletRequest;

/**
 * VNPay Utility Class
 * Chứa các phương thức tiện ích để tích hợp với VNPay
 * 
 * @author Nhóm SWP
 */
public class VNPayUtils {
    
    /**
     * Tạo mã hash MD5
     * 
     * @param message Chuỗi cần hash
     * @return Chuỗi hash MD5
     */
    public static String md5(String message) {
        String digest = null;
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            byte[] hash = md.digest(message.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder(2 * hash.length);
            for (byte b : hash) {
                sb.append(String.format("%02x", b & 0xff));
            }
            digest = sb.toString();
        } catch (UnsupportedEncodingException ex) {
            digest = "";
        } catch (NoSuchAlgorithmException ex) {
            digest = "";
        }
        return digest;
    }

    /**
     * Tạo mã hash SHA256
     * 
     * @param message Chuỗi cần hash
     * @return Chuỗi hash SHA256
     */
    public static String sha256(String message) {
        String digest = null;
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(message.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder(2 * hash.length);
            for (byte b : hash) {
                sb.append(String.format("%02x", b & 0xff));
            }
            digest = sb.toString();
        } catch (UnsupportedEncodingException ex) {
            digest = "";
        } catch (NoSuchAlgorithmException ex) {
            digest = "";
        }
        return digest;
    }

    /**
     * Tạo chữ ký HMAC SHA512 cho tất cả các tham số (theo Config.java của VNPay mẫu)
     * 
     * @param fields Map chứa các tham số
     * @param secretKey Khóa bí mật
     * @return Chữ ký HMAC SHA512
     */
    public static String hashAllFields(Map fields, String secretKey) {
        List fieldNames = new ArrayList(fields.keySet());
        Collections.sort(fieldNames);
        StringBuilder sb = new StringBuilder();
        Iterator itr = fieldNames.iterator();
        while (itr.hasNext()) {
            String fieldName = (String) itr.next();
            String fieldValue = (String) fields.get(fieldName);
            if ((fieldValue != null) && (fieldValue.length() > 0)) {
                sb.append(fieldName);
                sb.append("=");
                sb.append(fieldValue); // Không encode ở đây, encode đã được thực hiện ở createPaymentUrl
            }
            if (itr.hasNext()) {
                sb.append("&");
            }
        }
        
        System.out.println("=== HASH ALL FIELDS DEBUG ===");
        System.out.println("Hash string: " + sb.toString());
        System.out.println("Secret key: " + secretKey);
        String result = hmacSHA512(secretKey, sb.toString());
        System.out.println("Hash result: " + result);
        System.out.println("============================");
        
        return result;
    }
    
    /**
     * Tạo chữ ký HMAC SHA512
     * 
     * @param key Khóa bí mật
     * @param data Dữ liệu cần ký
     * @return Chữ ký HMAC SHA512
     */
    public static String hmacSHA512(final String key, final String data) {
        try {
            if (key == null || data == null) {
                throw new NullPointerException();
            }
            final Mac hmac512 = Mac.getInstance("HmacSHA512");
            byte[] hmacKeyBytes = key.getBytes();
            final SecretKeySpec secretKey = new SecretKeySpec(hmacKeyBytes, "HmacSHA512");
            hmac512.init(secretKey);
            byte[] dataBytes = data.getBytes(StandardCharsets.UTF_8);
            byte[] result = hmac512.doFinal(dataBytes);
            StringBuilder sb = new StringBuilder(2 * result.length);
            for (byte b : result) {
                sb.append(String.format("%02x", b & 0xff));
            }
            return sb.toString();
        } catch (Exception ex) {
            return "";
        }
    }
    
    /**
     * Lấy địa chỉ IP của client
     * 
     * @param request HttpServletRequest
     * @return Địa chỉ IP
     */
    public static String getIpAddress(HttpServletRequest request) {
        String ipAddress;
        try {
            ipAddress = request.getHeader("X-FORWARDED-FOR");
            if (ipAddress == null) {
                ipAddress = request.getRemoteAddr();
            }
        } catch (Exception e) {
            ipAddress = "Invalid IP:" + e.getMessage();
        }
        return ipAddress;
    }

    /**
     * Tạo số ngẫu nhiên
     * 
     * @param len Độ dài số cần tạo
     * @return Chuỗi số ngẫu nhiên
     */
    public static String getRandomNumber(int len) {
        Random rnd = new Random();
        String chars = "0123456789";
        StringBuilder sb = new StringBuilder(len);
        for (int i = 0; i < len; i++) {
            sb.append(chars.charAt(rnd.nextInt(chars.length())));
        }
        return sb.toString();
    }
    
    /**
     * Tạo URL thanh toán VNPay (sao chép từ ajaxServlet của VNPay mẫu)
     * 
     * @param vnpParams Map chứa các tham số VNPay
     * @param secretKey Khóa bí mật
     * @param baseUrl URL cơ sở của VNPay
     * @return URL thanh toán hoàn chỉnh
     */
    public static String createPaymentUrl(Map<String, String> vnpParams, String secretKey, String baseUrl) {
        try {
            List fieldNames = new ArrayList(vnpParams.keySet());
            Collections.sort(fieldNames);
            StringBuilder hashData = new StringBuilder();
            StringBuilder query = new StringBuilder();
            Iterator itr = fieldNames.iterator();
            
            while (itr.hasNext()) {
                String fieldName = (String) itr.next();
                String fieldValue = (String) vnpParams.get(fieldName);
                if ((fieldValue != null) && (fieldValue.length() > 0)) {
                    //Build hash data
                    hashData.append(fieldName);
                    hashData.append('=');
                    hashData.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    //Build query
                    query.append(URLEncoder.encode(fieldName, StandardCharsets.US_ASCII.toString()));
                    query.append('=');
                    query.append(URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString()));
                    if (itr.hasNext()) {
                        query.append('&');
                        hashData.append('&');
                    }
                }
            }
            
            String queryUrl = query.toString();
            String vnpSecureHash = hmacSHA512(secretKey, hashData.toString());
            queryUrl += "&vnp_SecureHash=" + vnpSecureHash;
            
            System.out.println("=== PAYMENT URL CREATION (VNPay Style) ===");
            System.out.println("Hash data: " + hashData.toString());
            System.out.println("Secret key: " + secretKey);
            System.out.println("Generated signature: " + vnpSecureHash);
            System.out.println("Final URL: " + baseUrl + "?" + queryUrl);
            System.out.println("==========================================");
            
            return baseUrl + "?" + queryUrl;
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("Error creating payment URL", e);
        }
    }
    
    /**
     * Tạo thời gian theo định dạng VNPay (yyyyMMddHHmmss)
     * 
     * @param calendar Calendar object
     * @return Chuỗi thời gian theo định dạng VNPay
     */
    public static String formatDateTime(Calendar calendar) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        return formatter.format(calendar.getTime());
    }
    
    /**
     * Tạo thời gian hiện tại theo định dạng VNPay
     * 
     * @return Chuỗi thời gian hiện tại
     */
    public static String getCurrentDateTime() {
        Calendar calendar = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        return formatDateTime(calendar);
    }
    
    /**
     * Tạo thời gian hết hạn (thêm phút vào thời gian hiện tại)
     * 
     * @param minutes Số phút cần thêm
     * @return Chuỗi thời gian hết hạn
     */
    public static String getExpireDateTime(int minutes) {
        Calendar calendar = Calendar.getInstance(TimeZone.getTimeZone("Etc/GMT+7"));
        calendar.add(Calendar.MINUTE, minutes);
        return formatDateTime(calendar);
    }
    
    /**
     * Xác thực chữ ký từ VNPay callback (sửa lỗi double encoding)
     * 
     * @param request HttpServletRequest từ callback
     * @param secretKey Khóa bí mật
     * @return true nếu chữ ký hợp lệ
     */
    public static boolean validateSignature(HttpServletRequest request, String secretKey) {
        try {
            Map fields = new HashMap();
            
            // Lấy chỉ các parameters của VNPay (bắt đầu với vnp_)
            // Encode giống như khi tạo URL để signature khớp
            for (Enumeration params = request.getParameterNames(); params.hasMoreElements();) {
                String fieldName = (String) params.nextElement();
                String fieldValue = request.getParameter(fieldName);
                
                // Chỉ lấy parameters của VNPay (bắt đầu với vnp_)
                if (fieldName.startsWith("vnp_") && (fieldValue != null) && (fieldValue.length() > 0)) {
                    // Encode fieldValue giống như khi tạo URL
                    String encodedFieldValue = URLEncoder.encode(fieldValue, StandardCharsets.US_ASCII.toString());
                    fields.put(fieldName, encodedFieldValue);
                }
            }

            String vnpSecureHash = request.getParameter("vnp_SecureHash");
            
            // Loại bỏ vnp_SecureHashType và vnp_SecureHash khỏi danh sách để hash
            if (fields.containsKey("vnp_SecureHashType")) {
                fields.remove("vnp_SecureHashType");
            }
            if (fields.containsKey("vnp_SecureHash")) {
                fields.remove("vnp_SecureHash");
            }
            
            // Debug: hiển thị tất cả fields trước khi hash
            System.out.println("=== SIGNATURE VALIDATION DEBUG ===");
            System.out.println("Fields before hashing:");
            for (Object key : fields.keySet()) {
                System.out.println("- " + key + ": " + fields.get(key));
            }
            
            // Sử dụng hashAllFields như trong Config.java của VNPay mẫu
            String signValue = hashAllFields(fields, secretKey);
            
            System.out.println("=== SIGNATURE VALIDATION (VNPay Style) ===");
            System.out.println("Fields count: " + fields.size());
            System.out.println("Secret key: " + secretKey);
            System.out.println("Calculated signature: " + signValue);
            System.out.println("Received signature: " + vnpSecureHash);
            System.out.println("Match: " + signValue.equals(vnpSecureHash));
            System.out.println("==========================================");
            
            return signValue.equals(vnpSecureHash);
        } catch (Exception e) {
            System.out.println("Error validating signature: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
} 