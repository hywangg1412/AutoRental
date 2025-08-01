package Repository.Deposit;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import Config.DBContext;
import Model.Entity.Booking.Booking;
import Model.Entity.Booking.BookingInsurance;
import Model.Entity.Booking.BookingSurcharges;
import Model.Entity.Deposit.Insurance;
import Model.Entity.Discount;
import Repository.Interfaces.IDeposit.IDepositRepository;

/**
 * Repository xử lý các thao tác database cho deposit feature 
 * Implement theo interface IDeposit.IDepositRepository
 */
public class DepositRepository implements IDepositRepository {

    private static final Logger LOGGER = Logger.getLogger(DepositRepository.class.getName());
    private final DBContext dbContext;

    public DepositRepository() {
        this.dbContext = new DBContext();
    }

    // ========== IMPLEMENT INTERFACE METHODS ==========
    
    @Override
    public Booking getBookingForDeposit(UUID bookingId) throws SQLException {
        // Chỉ lấy booking info, car info sẽ lấy riêng
        String sql = "SELECT * FROM Booking WHERE BookingId = ?";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBooking(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting booking for deposit: " + bookingId, e);
            throw e;
        }
    }

    /**
     * Lấy thông tin xe từ booking - MỚI THÊM
     */
    public CarInfoForDeposit getCarInfoByBookingId(UUID bookingId) throws SQLException {
        String sql = "SELECT c.CarModel, cb.BrandName, c.LicensePlate, c.Seats, c.PricePerDay " +
                     "FROM Booking b " +
                     "JOIN Car c ON b.CarId = c.CarId " +
                     "JOIN CarBrand cb ON c.BrandId = cb.BrandId " +
                     "WHERE b.BookingId = ?";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CarInfoForDeposit carInfo = new CarInfoForDeposit();
                    carInfo.setCarModel(rs.getString("CarModel"));
                    carInfo.setCarBrand(rs.getString("BrandName"));
                    carInfo.setLicensePlate(rs.getString("LicensePlate"));
                    carInfo.setCarSeats(rs.getInt("Seats"));
                    carInfo.setPricePerDay(rs.getDouble("PricePerDay"));
                    return carInfo;
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting car info for booking: " + bookingId, e);
            throw e;
        }
    }

    @Override
    public Discount getValidVoucher(String voucherCode) throws SQLException {
        String sql = "SELECT * FROM Discount WHERE VoucherCode = ? AND IsActive = 1";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, voucherCode);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDiscount(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting valid voucher: " + voucherCode, e);
            throw e;
        }
    }

    @Override
    public Discount getDiscountById(UUID discountId) throws SQLException {
        String sql = "SELECT * FROM Discount WHERE DiscountId = ?";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, discountId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToDiscount(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting discount by ID: " + discountId, e);
            throw e;
        }
    }

    @Override
    public Discount validateVoucher(String voucherCode) throws SQLException {
        String sql = "SELECT * FROM Discount WHERE VoucherCode = ? AND IsActive = 1";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, voucherCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Có thể kiểm tra thêm ngày bắt đầu, ngày kết thúc, usage limit ở đây nếu muốn
                    return mapResultSetToDiscount(rs);
                }
            }
        }
        return null;
    }

    /**
     * Inner class chứa thông tin xe cần thiết cho deposit
     */
    public static class CarInfoForDeposit {
        private String carModel;
        private String carBrand;
        private String licensePlate;
        private int carSeats;
        private double pricePerDay;

        // Getters and setters
        public String getCarModel() { return carModel; }
        public void setCarModel(String carModel) { this.carModel = carModel; }
        
        public String getCarBrand() { return carBrand; }
        public void setCarBrand(String carBrand) { this.carBrand = carBrand; }
        
        public String getLicensePlate() { return licensePlate; }
        public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }
        
        public int getCarSeats() { return carSeats; }
        public void setCarSeats(int carSeats) { this.carSeats = carSeats; }
        
        public double getPricePerDay() { return pricePerDay; }
        public void setPricePerDay(double pricePerDay) { this.pricePerDay = pricePerDay; }
    }

    @Override
    public boolean isBookingOwnedByUser(UUID bookingId, UUID userId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Booking WHERE BookingId = ? AND UserId = ?";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, bookingId);
            ps.setObject(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() && rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking booking ownership", e);
            throw e;
        }
    }

    @Override
    public boolean updateTermsAgreement(UUID bookingId, boolean agreed, String termsVersion) throws SQLException {
        String sql = "UPDATE Booking SET TermsAgreed = ?, TermsAgreedAt = GETDATE(), TermsVersion = ? WHERE BookingId = ?";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, agreed);
            ps.setString(2, termsVersion);
            ps.setObject(3, bookingId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating terms agreement", e);
            throw e;
        }
    }

    @Override
    public boolean updateBookingDiscount(UUID bookingId, UUID discountId) throws SQLException {
        String sql = "UPDATE Booking SET DiscountId = ? WHERE BookingId = ?";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, discountId);
            ps.setObject(2, bookingId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating booking discount", e);
            throw e;
        }
    }

    @Override
    public List<BookingInsurance> getBookingInsurancesByBookingId(UUID bookingId) throws SQLException {
        String sql = "SELECT * FROM BookingInsurance WHERE BookingId = ?";
        List<BookingInsurance> bookingInsurances = new ArrayList<>();
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingInsurance bookingInsurance = new BookingInsurance();
                    bookingInsurance.setBookingInsuranceId(UUID.fromString(rs.getString("BookingInsuranceId")));
                    bookingInsurance.setBookingId(UUID.fromString(rs.getString("BookingId")));
                    bookingInsurance.setInsuranceId(UUID.fromString(rs.getString("InsuranceId")));
                    bookingInsurance.setPremiumAmount(rs.getDouble("PremiumAmount"));
                    bookingInsurance.setRentalDays(rs.getDouble("RentalDays"));
                    bookingInsurance.setCarSeats(rs.getInt("CarSeats"));
                    bookingInsurance.setEstimatedCarValue(rs.getDouble("EstimatedCarValue"));
                    bookingInsurance.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
                    
                    bookingInsurances.add(bookingInsurance);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting booking insurances: " + bookingId, e);
            // Return empty list on error instead of throwing
            return new ArrayList<>();
        }
        
        return bookingInsurances;
    }

    @Override
    public Insurance getInsuranceById(UUID insuranceId) throws SQLException {
        String sql = "SELECT * FROM Insurance WHERE InsuranceId = ?";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, insuranceId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToInsurance(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting insurance by ID: " + insuranceId, e);
            return null; // Return null on error instead of throwing
        }
    }

//    @Override
//    public Discount getValidVoucher(String voucherCode) throws SQLException {
//        String sql = "SELECT * FROM Discount WHERE VoucherCode = ? AND IsActive = 1 "
//                + "AND StartDate <= GETDATE() AND EndDate >= GETDATE() "
//                + "AND DiscountCategory = 'Voucher'";
//        
//        try (Connection conn = dbContext.getConnection(); 
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setString(1, voucherCode);
//
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) {
//                    return mapResultSetToDiscount(rs);
//                }
//                return null;
//            }
//        } catch (SQLException e) {
//            LOGGER.log(Level.SEVERE, "Error getting valid voucher: " + voucherCode, e);
//            throw e;
//        }
//    }

//    @Override
//    public Discount getDiscountById(UUID discountId) throws SQLException {
//        String sql = "SELECT * FROM Discount WHERE DiscountId = ?";
//        
//        try (Connection conn = dbContext.getConnection(); 
//             PreparedStatement ps = conn.prepareStatement(sql)) {
//
//            ps.setObject(1, discountId);
//
//            try (ResultSet rs = ps.executeQuery()) {
//                if (rs.next()) {
//                    return mapResultSetToDiscount(rs);
//                }
//                return null;
//            }
//        } catch (SQLException e) {
//            LOGGER.log(Level.SEVERE, "Error getting discount by ID: " + discountId, e);
//            throw e;
//        }
//    }

    @Override
    public List<BookingSurcharges> getSurchargesByBookingId(UUID bookingId) throws SQLException {
        // Placeholder - return empty list
        return new java.util.ArrayList<>();
    }

    // ========== MAPPING METHODS ==========
    
    /**
     * Map ResultSet sang Booking entity
     */
    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();

        booking.setBookingId(UUID.fromString(rs.getString("BookingId")));
        booking.setUserId(UUID.fromString(rs.getString("UserId")));
        booking.setCarId(UUID.fromString(rs.getString("CarId")));
        booking.setHandledBy(rs.getString("HandledBy") != null
                ? UUID.fromString(rs.getString("HandledBy")) : null);
        booking.setPickupDateTime(rs.getTimestamp("PickupDateTime").toLocalDateTime());
        booking.setReturnDateTime(rs.getTimestamp("ReturnDateTime").toLocalDateTime());
        booking.setTotalAmount(rs.getDouble("TotalAmount"));
        booking.setStatus(rs.getString("Status"));
        booking.setDiscountId(rs.getString("DiscountId") != null
                ? UUID.fromString(rs.getString("DiscountId")) : null);
        booking.setCreatedDate(rs.getTimestamp("CreatedDate").toLocalDateTime());
        booking.setCancelReason(rs.getString("CancelReason"));
        booking.setBookingCode(rs.getString("BookingCode"));
        booking.setExpectedPaymentMethod(rs.getString("ExpectedPaymentMethod"));
        booking.setRentalType(rs.getString("RentalType"));

        // Customer info
        booking.setCustomerName(rs.getString("CustomerName"));
        booking.setCustomerPhone(rs.getString("CustomerPhone"));
        booking.setCustomerAddress(rs.getString("CustomerAddress"));
        booking.setCustomerEmail(rs.getString("CustomerEmail"));
        booking.setDriverLicenseImageUrl(rs.getString("DriverLicenseImageUrl"));

        // Terms fields
        booking.setTermsAgreed(rs.getBoolean("TermsAgreed"));
        booking.setTermsAgreedAt(rs.getTimestamp("TermsAgreedAt") != null
                ? rs.getTimestamp("TermsAgreedAt").toLocalDateTime() : null);
        booking.setTermsVersion(rs.getString("TermsVersion"));

        return booking;
    }

    /**
     * Map ResultSet sang Discount entity (bổ sung, không xóa code cũ)
     */
    private Discount mapResultSetToDiscount(ResultSet rs) throws SQLException {
        Discount discount = new Discount();
        discount.setDiscountId(UUID.fromString(rs.getString("DiscountId")));
        discount.setDiscountName(rs.getString("DiscountName"));
        discount.setDescription(rs.getString("Description"));
        discount.setDiscountType(rs.getString("DiscountType"));
        discount.setDiscountValue(rs.getBigDecimal("DiscountValue"));
        // Mapping ngày tháng an toàn, không ép kiểu LocalDateTime
        java.sql.Timestamp startTs = rs.getTimestamp("StartDate");
        if (startTs != null) discount.setStartDate(startTs);
        java.sql.Timestamp endTs = rs.getTimestamp("EndDate");
        if (endTs != null) discount.setEndDate(endTs);
        discount.setIsActive(rs.getBoolean("IsActive"));
        java.sql.Timestamp createdTs = rs.getTimestamp("CreatedDate");
        if (createdTs != null) discount.setCreatedDate(createdTs);
        discount.setVoucherCode(rs.getString("VoucherCode"));
        discount.setMinOrderAmount(rs.getBigDecimal("MinOrderAmount"));
        discount.setMaxDiscountAmount(rs.getBigDecimal("MaxDiscountAmount"));
        discount.setUsageLimit(rs.getObject("UsageLimit") != null ? rs.getInt("UsageLimit") : null);
        discount.setUsedCount(rs.getInt("UsedCount"));
        discount.setDiscountCategory(rs.getString("DiscountCategory"));
        return discount;
    }
    
    /**
     * Map ResultSet sang Insurance entity
     */
    private Insurance mapResultSetToInsurance(ResultSet rs) throws SQLException {
        Insurance insurance = new Insurance();
        
        insurance.setInsuranceId(UUID.fromString(rs.getString("InsuranceId")));
        insurance.setInsuranceName(rs.getString("InsuranceName"));
        insurance.setInsuranceType(rs.getString("InsuranceType"));
        insurance.setBaseRatePerDay(rs.getDouble("BaseRatePerDay"));
        insurance.setPercentageRate(rs.getDouble("PercentageRate"));
        insurance.setCoverageAmount(rs.getDouble("CoverageAmount"));
        insurance.setApplicableCarSeats(rs.getString("ApplicableCarSeats"));
        insurance.setDescription(rs.getString("Description"));
        insurance.setActive(rs.getBoolean("IsActive"));
        insurance.setCreatedDate(rs.getTimestamp("CreatedDate").toLocalDateTime());
        
        return insurance;
    }
    
    // ========== IMPLEMENT MISSING METHODS ==========
    
    @Override
    public double[] calculateTotalAndDeposit(UUID bookingId) throws SQLException {
        // Tính toán theo logic mới: deposit cố định 300K hoặc 10% tùy theo total amount
        Booking booking = getBookingForDeposit(bookingId);
        if (booking == null) {
            return new double[]{0, 0};
        }
        
        double totalAmount = booking.getTotalAmount();
        double depositAmount;
        
        if (totalAmount >= 3000.0) {
            // Nếu total >= 3 triệu: đặt cọc = 10% của total
            depositAmount = totalAmount * 0.10;
        } else {
            // Nếu total < 3 triệu: đặt cọc cố định 300K
            depositAmount = 300.0;
        }
        
        LOGGER.info("Calculate total and deposit - Total: " + totalAmount + ", Deposit: " + depositAmount);
        return new double[]{totalAmount, depositAmount};
    }
    
    @Override
    public double getTotalInsuranceAmount(UUID bookingId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(PremiumAmount), 0) as TotalInsurance FROM BookingInsurance WHERE BookingId = ?";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double total = rs.getDouble("TotalInsurance");
                    LOGGER.info("Total insurance amount for booking " + bookingId + ": " + total);
                    return total;
                }
                return 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total insurance amount: " + bookingId, e);
            throw e;
        }
    }
    
    @Override
    public double getTotalSurchargesByCategory(UUID bookingId, String category) throws SQLException {
        String sql = "SELECT COALESCE(SUM(Amount), 0) as TotalSurcharges FROM BookingSurcharges WHERE BookingId = ? AND SurchargeCategory = ?";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, bookingId);
            ps.setString(2, category);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double total = rs.getDouble("TotalSurcharges");
                    LOGGER.info("Total surcharges (" + category + ") for booking " + bookingId + ": " + total);
                    return total;
                }
                return 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting total surcharges by category: " + bookingId + ", " + category, e);
            throw e;
        }
    }

    // ====== BỔ SUNG HELPER VOUCHER (CHỈ THÊM MỚI) ======

    /**
     * Helper: In ra toàn bộ voucher đang active trong DB (debug)
     */
    public void logAllActiveVouchers() {
        String sql = "SELECT VoucherCode, DiscountName, StartDate, EndDate, IsActive FROM Discount WHERE IsActive = 1";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            LOGGER.info("=== DANH SÁCH VOUCHER ĐANG ACTIVE ===");
            while (rs.next()) {
                LOGGER.info(String.format("Voucher: %s | Name: %s | Start: %s | End: %s | Active: %s",
                        rs.getString("VoucherCode"),
                        rs.getString("DiscountName"),
                        rs.getDate("StartDate"),
                        rs.getDate("EndDate"),
                        rs.getBoolean("IsActive")));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Không thể lấy danh sách voucher active", e);
        }
    }

    /**
     * Helper: Kiểm tra chi tiết trạng thái voucher (debug)
     */
    public void debugVoucherStatus(String voucherCode) {
        String sql = "SELECT * FROM Discount WHERE VoucherCode = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, voucherCode);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    LOGGER.info("=== DEBUG VOUCHER STATUS ===");
                    LOGGER.info("VoucherCode: " + rs.getString("VoucherCode"));
                    LOGGER.info("DiscountName: " + rs.getString("DiscountName"));
                    LOGGER.info("IsActive: " + rs.getBoolean("IsActive"));
                    LOGGER.info("StartDate: " + rs.getDate("StartDate"));
                    LOGGER.info("EndDate: " + rs.getDate("EndDate"));
                    LOGGER.info("UsageLimit: " + rs.getObject("UsageLimit"));
                    LOGGER.info("UsedCount: " + rs.getInt("UsedCount"));
                } else {
                    LOGGER.warning("Voucher không tồn tại: " + voucherCode);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Không thể debug voucher: " + voucherCode, e);
        }
    }

    /**
     * Helper: Kiểm tra user đã dùng voucher này bao nhiêu lần
     */
    public int countUserVoucherUsage(UUID userId, UUID discountId) {
        String sql = "SELECT COUNT(*) FROM UserVoucherUsage WHERE UserId = ? AND DiscountId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, userId);
            ps.setObject(2, discountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Không thể đếm số lần user dùng voucher", e);
        }
        return 0;
    }

    /**
     * Helper: Kiểm tra tổng số lượt sử dụng voucher này trên toàn hệ thống
     */
    public int countTotalVoucherUsage(UUID discountId) {
        String sql = "SELECT COUNT(*) FROM UserVoucherUsage WHERE DiscountId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, discountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Không thể đếm tổng số lượt sử dụng voucher", e);
        }
        return 0;
    }

    /**
     * Helper: Validate voucher nâng cao (có thể dùng cho unit test hoặc debug)
     */
    public boolean isVoucherCurrentlyValid(String voucherCode) {
        try {
            Discount discount = validateVoucher(voucherCode);
            if (discount == null) return false;
            // Kiểm tra số lượt sử dụng thực tế
            int used = countTotalVoucherUsage(discount.getDiscountId());
            if (discount.getUsageLimit() != null && used >= discount.getUsageLimit()) {
                LOGGER.warning("Voucher đã hết lượt sử dụng thực tế: " + used + "/" + discount.getUsageLimit());
                return false;
            }
            return true;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Lỗi khi kiểm tra voucher hiện tại", e);
            return false;
        }
    }
    
    @Override
    public boolean incrementVoucherUsage(UUID discountId) throws SQLException {
        String sql = "UPDATE Discount SET UsedCount = UsedCount + 1 WHERE DiscountId = ?";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, discountId);
            int rowsAffected = ps.executeUpdate();
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error incrementing voucher usage: " + discountId, e);
            throw e;
        }
    }
    
    @Override
    public boolean recordUserVoucherUsage(UUID userId, UUID discountId) throws SQLException {
        String sql = "INSERT INTO UserVoucherUsage (UserId, DiscountId, UsedAt) VALUES (?, ?, GETDATE())";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, userId);
            ps.setObject(2, discountId);
            int rowsAffected = ps.executeUpdate();
            
            return rowsAffected > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error recording user voucher usage: " + userId + ", " + discountId, e);
            throw e;
        }
    }
}
