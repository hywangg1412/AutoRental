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
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Discount getDiscountById(UUID discountId) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
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
     * Map ResultSet sang Discount entity
     */
//    private Discount mapResultSetToDiscount(ResultSet rs) throws SQLException {
//        Discount discount = new Discount();
//
//        discount.setDiscountId(UUID.fromString(rs.getString("DiscountId")));
//        discount.setDiscountName(rs.getString("DiscountName"));
//        discount.setDescription(rs.getString("Description"));
//        discount.setDiscountType(rs.getString("DiscountType"));
//        discount.setDiscountValue(java.math.BigDecimal.valueOf(rs.getDouble("DiscountValue")));
//        
//        // Handle date fields safely
//        if (rs.getTimestamp("StartDate") != null) {
//            discount.setStartDate(rs.getTimestamp("StartDate").toLocalDateTime());
//        }
//        if (rs.getTimestamp("EndDate") != null) {
//            discount.setEndDate(rs.getTimestamp("EndDate").toLocalDateTime());
//        }
//        
//        discount.setActive(rs.getBoolean("IsActive"));
//        if (rs.getTimestamp("CreatedDate") != null) {
//        discount.setCreatedDate(rs.getTimestamp("CreatedDate").toLocalDateTime());
//        }
//
//        return discount;
//    }
    
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
        // Simple calculation: lấy booking total amount và tính deposit 30%
        Booking booking = getBookingForDeposit(bookingId);
        if (booking == null) {
            return new double[]{0, 0};
        }
        
        double totalAmount = booking.getTotalAmount();
        double depositAmount = totalAmount * 0.30; // 30% deposit
        
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
}
