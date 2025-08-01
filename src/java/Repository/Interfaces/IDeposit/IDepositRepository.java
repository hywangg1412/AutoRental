package Repository.Interfaces.IDeposit;

import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

import Model.Entity.Booking.Booking;
import Model.Entity.Booking.BookingInsurance;
import Model.Entity.Booking.BookingSurcharges;
import Model.Entity.Deposit.Insurance;
import Model.Entity.Discount;

/**
 * Interface cho DepositRepository - CHỈ TRẢ VỀ ENTITY VÀ PRIMITIVE
 * Không có logic tính toán - chỉ truy xuất dữ liệu
 */
public interface IDepositRepository {
    
    // ========== BOOKING OPERATIONS ==========
    
    /**
     * Lấy booking với thông tin đầy đủ cho deposit
     * @param bookingId ID của booking
     * @return Booking entity (không phải DTO)
     */
    Booking getBookingForDeposit(UUID bookingId) throws SQLException;
    
    /**
     * Kiểm tra booking có thuộc về user không
     * @param bookingId ID của booking
     * @param userId ID của user
     * @return true nếu thuộc về user
     */
    boolean isBookingOwnedByUser(UUID bookingId, UUID userId) throws SQLException;
    
    /**
     * Cập nhật terms agreement cho booking
     * @param bookingId ID của booking
     * @param agreed Đã đồng ý hay chưa
     * @param termsVersion Phiên bản điều khoản
     * @return true nếu thành công
     */
    boolean updateTermsAgreement(UUID bookingId, boolean agreed, String termsVersion) throws SQLException;
    
    /**
     * Cập nhật discount cho booking
     * @param bookingId ID của booking
     * @param discountId ID của discount
     * @return true nếu thành công
     */
    boolean updateBookingDiscount(UUID bookingId, UUID discountId) throws SQLException;
    
    // ========== INSURANCE OPERATIONS ==========
    
    /**
     * Lấy danh sách bảo hiểm của booking - TRẢ VỀ ENTITY
     * @param bookingId ID của booking
     * @return List<BookingInsurance> entities
     */
    List<BookingInsurance> getBookingInsurancesByBookingId(UUID bookingId) throws SQLException;
    
    /**
     * Lấy thông tin insurance theo ID - TRẢ VỀ ENTITY
     * @param insuranceId ID của insurance
     * @return Insurance entity
     */
    Insurance getInsuranceById(UUID insuranceId) throws SQLException;
    
    // ========== DISCOUNT OPERATIONS ==========
    
    /**
     * Lấy voucher hợp lệ theo mã - TRẢ VỀ ENTITY
     * @param voucherCode Mã voucher
     * @return Discount entity hoặc null
     */
    Discount getValidVoucher(String voucherCode) throws SQLException;
    
    /**
     * Kiểm tra voucher có hợp lệ không (thời gian, trạng thái, giới hạn sử dụng)
     * @param voucherCode Mã voucher
     * @return Discount entity nếu hợp lệ, null nếu không hợp lệ
     */
    Discount validateVoucher(String voucherCode) throws SQLException;
    
    /**
     * Lấy discount theo ID
     * @param discountId ID của discount
     * @return Discount entity hoặc null
     */
    Discount getDiscountById(UUID discountId) throws SQLException;
    
    // ========== SURCHARGES OPERATIONS ==========
    
    /**
     * Lấy danh sách phí phụ của booking - TRẢ VỀ ENTITY
     * @param bookingId ID của booking
     * @return List<BookingSurcharges> entities
     */
    List<BookingSurcharges> getSurchargesByBookingId(UUID bookingId) throws SQLException;
    
    // ========== MISSING METHODS CẦN IMPLEMENT ==========
    
    /**
     * Tính toán tổng tiền và tiền cọc qua stored procedure
     * @param bookingId ID của booking
     * @return double[] {totalAmount, depositAmount}
     */
    double[] calculateTotalAndDeposit(UUID bookingId) throws SQLException;
    
    /**
     * Lấy tổng số tiền bảo hiểm của booking
     * @param bookingId ID của booking
     * @return Tổng tiền bảo hiểm
     */
    double getTotalInsuranceAmount(UUID bookingId) throws SQLException;
    
    /**
     * Lấy tổng phí theo category (Tax, Insurance, etc.)
     * @param bookingId ID của booking
     * @param category Category của surcharge
     * @return Tổng phí theo category
     */
    double getTotalSurchargesByCategory(UUID bookingId, String category) throws SQLException;

    // ====== BỔ SUNG HELPER CHO VOUCHER (KHÔNG ẢNH HƯỞNG CODE CŨ) ======

    /**
     * Helper: In ra toàn bộ voucher đang active trong DB (debug)
     */
    default void logAllActiveVouchers() {}

    /**
     * Helper: Kiểm tra chi tiết trạng thái voucher (debug)
     */
    default void debugVoucherStatus(String voucherCode) {}

    /**
     * Helper: Kiểm tra user đã dùng voucher này bao nhiêu lần
     */
    default int countUserVoucherUsage(UUID userId, UUID discountId) { return 0; }

    /**
     * Helper: Kiểm tra tổng số lượt sử dụng voucher này trên toàn hệ thống
     */
    default int countTotalVoucherUsage(UUID discountId) { return 0; }

    /**
     * Helper: Validate voucher nâng cao (có thể dùng cho unit test hoặc debug)
     */
    default boolean isVoucherCurrentlyValid(String voucherCode) { return false; }
    
    /**
     * Tăng số lần sử dụng voucher
     * @param discountId ID của discount
     * @return true nếu thành công
     */
    boolean incrementVoucherUsage(UUID discountId) throws SQLException;
    
    /**
     * Ghi log sử dụng voucher của user
     * @param userId ID của user
     * @param discountId ID của discount
     * @return true nếu thành công
     */
    boolean recordUserVoucherUsage(UUID userId, UUID discountId) throws SQLException;
}
