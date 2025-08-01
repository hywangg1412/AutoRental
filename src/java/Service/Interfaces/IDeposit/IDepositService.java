package Service.Interfaces.IDeposit;

import java.util.UUID;

import Model.DTO.Deposit.DepositPageDTO;

/**
 * Interface cho DepositService
 * Xử lý business logic liên quan đến deposit
 */
public interface IDepositService {
    
    /**
     * Lấy dữ liệu cho trang deposit
     * @param bookingId ID của booking
     * @param userId ID của user
     * @return DepositPageDTO chứa đầy đủ thông tin
     * @throws Exception khi có lỗi
     */
    DepositPageDTO getDepositPageData(UUID bookingId, UUID userId) throws Exception;
    
    /**
     * Áp dụng voucher cho booking
     * @param bookingId ID của booking
     * @param voucherCode Mã voucher
     * @param userId ID của user
     * @return true nếu thành công
     * @throws Exception khi có lỗi
     */
    boolean applyVoucher(UUID bookingId, String voucherCode, UUID userId) throws Exception;
    
    /**
     * Xóa voucher khỏi booking
     * @param bookingId ID của booking
     * @param userId ID của user
     * @return true nếu thành công
     * @throws Exception khi có lỗi
     */
    boolean removeVoucher(UUID bookingId, UUID userId) throws Exception;
    
    /**
     * Đồng ý với điều khoản
     * @param bookingId ID của booking
     * @param userId ID của user
     * @param termsVersion Phiên bản điều khoản
     * @return true nếu thành công
     * @throws Exception khi có lỗi
     */
    boolean agreeToTerms(UUID bookingId, UUID userId, String termsVersion) throws Exception;
    
    /**
     * Tính toán lại chi phí
     * @param bookingId ID của booking
     * @return DepositPageDTO với giá mới
     * @throws Exception khi có lỗi
     */
    DepositPageDTO recalculateCost(UUID bookingId) throws Exception;
    
    /**
     * Kiểm tra booking có thuộc về user không
     * @param bookingId ID của booking
     * @param userId ID của user
     * @return true nếu thuộc về user
     * @throws Exception khi có lỗi
     */
    boolean isBookingOwnedByUser(UUID bookingId, UUID userId) throws Exception;

    // ====== BỔ SUNG HELPER VOUCHER/DISCOUNT (CHỈ THÊM MỚI, KHÔNG ẢNH HƯỞNG CODE CŨ) ======

    /**
     * Helper: Log toàn bộ voucher đang active (gọi từ repository)
     */
    default void logAllActiveVouchers() {}

    /**
     * Helper: Debug chi tiết trạng thái voucher
     */
    default void debugVoucherStatus(String voucherCode) {}

    /**
     * Helper: Kiểm tra user đã dùng voucher này bao nhiêu lần
     */
    default int countUserVoucherUsage(java.util.UUID userId, java.util.UUID discountId) { return 0; }

    /**
     * Helper: Kiểm tra tổng số lượt sử dụng voucher này trên toàn hệ thống
     */
    default int countTotalVoucherUsage(java.util.UUID discountId) { return 0; }

    /**
     * Helper: Validate voucher nâng cao (có thể dùng cho unit test hoặc debug)
     */
    default boolean isVoucherCurrentlyValid(String voucherCode) { return false; }
    
    /**
     * Tạo JSON response cho voucher operations
     * @param success Trạng thái thành công
     * @param message Thông báo
     * @param bookingId ID của booking
     * @param userId ID của user
     * @return JSON string response
     * @throws Exception khi có lỗi
     */
    default String createVoucherResponse(boolean success, String message, UUID bookingId, UUID userId) throws Exception {
        return "{\"success\": false, \"message\": \"Method not implemented\"}";
    }
} 