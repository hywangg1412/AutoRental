package Repository.Booking;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import Config.DBContext;
import Model.Constants.BookingStatusConstants;
import Model.Entity.Booking.Booking;
import Repository.Interfaces.Ibooking.IBookingRepository;

public class BookingRepository implements IBookingRepository {

    private static final Logger LOGGER = Logger.getLogger(BookingRepository.class.getName());
    private final DBContext dbContext;

    private static final String SQL_INSERT
            = "INSERT INTO Booking (BookingId, UserId, CarId, HandledBy, PickupDateTime, ReturnDateTime, "
            + "TotalAmount, Status, DiscountId, CreatedDate, CancelReason, BookingCode, ExpectedPaymentMethod, "
            + "CustomerName, CustomerPhone, CustomerAddress, CustomerEmail, DriverLicenseImageUrl, RentalType, "
            + "TermsAgreed, TermsAgreedAt, TermsVersion) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String SQL_FIND_BY_ID = "SELECT * FROM Booking WHERE BookingId = ?";

    private static final String SQL_UPDATE
            = "UPDATE Booking SET UserId = ?, CarId = ?, HandledBy = ?, PickupDateTime = ?, "
            + "ReturnDateTime = ?, TotalAmount = ?, Status = ?, DiscountId = ?, CreatedDate = ?, "
            + "CancelReason = ?, BookingCode = ?, ExpectedPaymentMethod = ?, "
            + "CustomerName = ?, CustomerPhone = ?, CustomerAddress = ?, CustomerEmail = ?, "
            + "DriverLicenseImageUrl = ?, RentalType = ?, TermsAgreed = ?, TermsAgreedAt = ?, TermsVersion = ? "
            + "WHERE BookingId = ?";

    private static final String SQL_DELETE = "DELETE FROM Booking WHERE BookingId = ?";
    private static final String SQL_FIND_ALL = "SELECT * FROM Booking";
    private static final String SQL_UPDATE_STATUS = "UPDATE Booking SET Status = ? WHERE BookingId = ?";
    private static final String SQL_FIND_BY_USER_ID = "SELECT * FROM Booking WHERE UserId = ?";

    public BookingRepository() {
        this.dbContext = new DBContext();
    }

    @Override
    public Booking add(Booking entity) throws SQLException {
        if (entity == null) {
            throw new IllegalArgumentException("Booking entity cannot be null");
        }
        LOGGER.info("Adding booking with ID: " + entity.getBookingId());
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_INSERT)) {
            setBookingParameters(ps, entity);
            int affectedRows = ps.executeUpdate();
            LOGGER.info("Insert affected rows: " + affectedRows);
            return entity;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding booking: " + e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public Booking findById(UUID Id) throws SQLException {
        if (Id == null) {
            throw new IllegalArgumentException("Booking ID cannot be null");
        }

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_ID)) {

            ps.setObject(1, Id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBooking(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding booking by ID: " + e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public boolean update(Booking entity) throws SQLException {
        if (entity == null || entity.getBookingId() == null) {
            throw new IllegalArgumentException("Booking entity and ID cannot be null");
        }

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_UPDATE)) {

            ps.setObject(1, entity.getUserId());
            ps.setObject(2, entity.getCarId());
            ps.setObject(3, entity.getHandledBy());
            ps.setTimestamp(4, Timestamp.valueOf(entity.getPickupDateTime()));
            ps.setTimestamp(5, Timestamp.valueOf(entity.getReturnDateTime()));
            ps.setBigDecimal(6, BigDecimal.valueOf(entity.getTotalAmount()));
            ps.setString(7, entity.getStatus());
            ps.setObject(8, entity.getDiscountId());
            ps.setTimestamp(9, Timestamp.valueOf(entity.getCreatedDate()));
            ps.setString(10, entity.getCancelReason());
            ps.setString(11, entity.getBookingCode());
            ps.setString(12, entity.getExpectedPaymentMethod());
            ps.setString(13, entity.getCustomerName());
            ps.setString(14, entity.getCustomerPhone());
            ps.setString(15, entity.getCustomerAddress());
            ps.setString(16, entity.getCustomerEmail());
            ps.setString(17, entity.getDriverLicenseImageUrl());
            ps.setString(18, entity.getRentalType());
            
            // *** THÊM CÁC FIELD MỚI CHO DEPOSIT ***
            ps.setBoolean(19, entity.isTermsAgreed());
            ps.setTimestamp(20, entity.getTermsAgreedAt() != null
                    ? Timestamp.valueOf(entity.getTermsAgreedAt()) : null);
            ps.setString(21, entity.getTermsVersion());
            
            // *** WHERE CLAUSE - BookingId phải là parameter cuối cùng ***
            ps.setObject(22, entity.getBookingId());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating booking: " + e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public boolean delete(UUID Id) throws SQLException {
        if (Id == null) {
            throw new IllegalArgumentException("Booking ID cannot be null");
        }

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_DELETE)) {

            ps.setObject(1, Id);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting booking: " + e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public List<Booking> findAll() throws SQLException {
        List<Booking> bookings = new ArrayList<>();

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_FIND_ALL); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                bookings.add(mapResultSetToBooking(rs));
            }
            return bookings;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all bookings: " + e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public List<Booking> findByStatus(String status) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Booking WHERE Status = ?";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }
        }
        return bookings;
    }

    @Override
    public List<Booking> findByUserId(UUID userId) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_USER_ID)) {
            ps.setObject(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding bookings by user ID: " + userId, e);
            throw e;
        }
        return bookings;
    }

    @Override
    public void updateBookingStatus(UUID bookingId, String status) throws SQLException {
        if (bookingId == null || status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Booking ID and status cannot be null or empty");
        }

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_STATUS)) {

            ps.setString(1, status);
            ps.setObject(2, bookingId);

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                LOGGER.log(Level.WARNING, "No booking found with ID {0} to update status.", bookingId);
            } else {
                LOGGER.log(Level.INFO, "Successfully updated status for booking ID {0} to {1}", new Object[]{bookingId, status});
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating booking status for ID " + bookingId, e);
            throw e;
        }
    }

    private void setBookingParameters(PreparedStatement ps, Booking entity) throws SQLException {
        LOGGER.info("Setting booking parameters...");
        ps.setObject(1, entity.getBookingId());
        ps.setObject(2, entity.getUserId());
        ps.setObject(3, entity.getCarId());
        ps.setObject(4, entity.getHandledBy());
        ps.setTimestamp(5, Timestamp.valueOf(entity.getPickupDateTime()));
        ps.setTimestamp(6, Timestamp.valueOf(entity.getReturnDateTime()));
        ps.setBigDecimal(7, BigDecimal.valueOf(entity.getTotalAmount()));
        ps.setString(8, entity.getStatus());
        ps.setObject(9, entity.getDiscountId());
        ps.setTimestamp(10, Timestamp.valueOf(entity.getCreatedDate()));
        ps.setString(11, entity.getCancelReason());
        ps.setString(12, entity.getBookingCode());
        ps.setString(13, entity.getExpectedPaymentMethod());
        ps.setString(14, entity.getCustomerName());
        ps.setString(15, entity.getCustomerPhone());
        ps.setString(16, entity.getCustomerAddress());
        ps.setString(17, entity.getCustomerEmail());
        ps.setString(18, entity.getDriverLicenseImageUrl());
        ps.setString(19, entity.getRentalType());

        // *** THÊM CÁC FIELD MỚI CHO DEPOSIT ***
        ps.setBoolean(20, entity.isTermsAgreed());
        ps.setTimestamp(21, entity.getTermsAgreedAt() != null
                ? Timestamp.valueOf(entity.getTermsAgreedAt()) : null);
        ps.setString(22, entity.getTermsVersion());

        LOGGER.info("All parameters set successfully including deposit fields");
    }

    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(UUID.fromString(rs.getString("BookingId")));
        booking.setUserId(UUID.fromString(rs.getString("UserId")));
        booking.setCarId(rs.getString("CarId") != null ? UUID.fromString(rs.getString("CarId")) : null);
        booking.setHandledBy(rs.getString("HandledBy") != null ? UUID.fromString(rs.getString("HandledBy")) : null);
        booking.setPickupDateTime(rs.getTimestamp("PickupDateTime").toLocalDateTime());
        booking.setReturnDateTime(rs.getTimestamp("ReturnDateTime").toLocalDateTime());
        booking.setTotalAmount(rs.getBigDecimal("TotalAmount").doubleValue());
        booking.setStatus(rs.getString("Status"));
        booking.setDiscountId(rs.getString("DiscountId") != null ? UUID.fromString(rs.getString("DiscountId")) : null);
        booking.setCreatedDate(rs.getTimestamp("CreatedDate").toLocalDateTime());
        booking.setCancelReason(rs.getString("CancelReason"));
        booking.setBookingCode(rs.getString("BookingCode"));
        booking.setExpectedPaymentMethod(rs.getString("ExpectedPaymentMethod"));
        booking.setCustomerName(rs.getString("CustomerName"));
        booking.setCustomerPhone(rs.getString("CustomerPhone"));
        booking.setCustomerAddress(rs.getString("CustomerAddress"));
        booking.setCustomerEmail(rs.getString("CustomerEmail"));
        booking.setDriverLicenseImageUrl(rs.getString("DriverLicenseImageUrl"));
        booking.setRentalType(rs.getString("RentalType"));

        // *** THÊM CÁC FIELD MỚI CHO DEPOSIT ***
        booking.setTermsAgreed(rs.getBoolean("TermsAgreed"));
        booking.setTermsAgreedAt(rs.getTimestamp("TermsAgreedAt") != null
                ? rs.getTimestamp("TermsAgreedAt").toLocalDateTime() : null);
        booking.setTermsVersion(rs.getString("TermsVersion"));

        return booking;
    }

    public boolean updateTermsAgreement(UUID bookingId, boolean agreed, String termsVersion) throws SQLException {
        String sql = "UPDATE Booking SET TermsAgreed = ?, TermsAgreedAt = ?, TermsVersion = ? WHERE BookingId = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, agreed);
            ps.setTimestamp(2, agreed ? Timestamp.valueOf(LocalDateTime.now()) : null);
            ps.setString(3, agreed ? termsVersion : null);
            ps.setObject(4, bookingId);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating terms agreement for booking: " + bookingId, e);
            throw e;
        }
    }

    /**
     * Cập nhật tổng tiền booking sau khi thanh toán deposit thành công
     * Mục đích: Đóng băng giá tiền booking để tránh thay đổi giá trong tương lai
     * 
     * @param bookingId ID của booking cần cập nhật
     * @param finalTotalAmount Tổng tiền cuối cùng từ deposit (bao gồm thuế VAT và các phí khác)
     * @return true nếu cập nhật thành công
     * @throws SQLException nếu có lỗi database
     */
    public boolean updateBookingTotalAmount(UUID bookingId, double finalTotalAmount) throws SQLException {
        String sql = "UPDATE Booking SET TotalAmount = ? WHERE BookingId = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, finalTotalAmount);
            ps.setObject(2, bookingId);

            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                LOGGER.info("✅ Đã cập nhật TotalAmount cho booking " + bookingId + " = " + finalTotalAmount + " (DB value)");
                LOGGER.info("💰 Giá tiền booking đã được đóng băng, không thay đổi khi giá thuê xe tăng trong tương lai");
                return true;
            } else {
                LOGGER.warning("⚠️ Không tìm thấy booking " + bookingId + " để cập nhật TotalAmount");
                return false;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "❌ Lỗi cập nhật TotalAmount cho booking: " + bookingId, e);
            throw e;
        }
    }

    public static String generateBookingCode() {
        String datePart = java.time.LocalDate.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyyMMdd"));
        String randomPart = UUID.randomUUID().toString().substring(0, 5).toUpperCase();
        return "BK-" + datePart + "-" + randomPart;
    }

    // Lấy danh sách booking theo phân trang (offset, limit)
    public List<Booking> findAllPaged(int offset, int limit) throws SQLException {
        List<Booking> bookings = new ArrayList<>();
        // SQL Server: dùng OFFSET ... FETCH NEXT ...
        String sql = "SELECT * FROM Booking ORDER BY CreatedDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapResultSetToBooking(rs));
                }
            }
        }
        return bookings;
    }
    
    
    
    @Override
    public boolean hasCompletedBookingWithoutReview(UUID userId, UUID carId) throws SQLException {
        // Kiểm tra xem người dùng có booking hoàn thành cho xe này không
        // Không cần kiểm tra đã có đánh giá hay chưa, chỉ cần có booking hoàn thành
        String sql = "SELECT COUNT(*) FROM Booking WHERE UserId = ? AND CarId = ? AND Status = ?";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, userId.toString());
        stmt.setString(2, carId.toString());
        stmt.setString(3, BookingStatusConstants.COMPLETED);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        }
    }
}

    @Override
    public UUID findCompletedBookingWithoutReview(UUID userId, UUID carId) throws SQLException {
        // Tìm booking hoàn thành chưa có đánh giá cho xe cụ thể
        // Trả về booking gần đây nhất chưa có đánh giá
    String sql = "SELECT TOP 1 b.BookingId FROM Booking b " +
                "LEFT JOIN UserFeedback f ON b.BookingId = f.BookingId " +
                "WHERE b.UserId = ? AND b.CarId = ? AND b.Status = ? AND f.FeedbackId IS NULL " +
                "ORDER BY b.ReturnDateTime DESC";
    try (Connection conn = dbContext.getConnection();
         PreparedStatement stmt = conn.prepareStatement(sql)) {
        stmt.setString(1, userId.toString());
        stmt.setString(2, carId.toString());
        stmt.setString(3, BookingStatusConstants.COMPLETED);
        try (ResultSet rs = stmt.executeQuery()) {
            if (rs.next()) {
                return UUID.fromString(rs.getString("BookingId"));
            }
            return null;
        }
    }
    }
    
    /**
     * Tìm tất cả các booking hoàn thành chưa có đánh giá cho một người dùng và một xe
     * @param userId ID của người dùng
     * @param carId ID của xe
     * @return Danh sách các booking ID
     * @throws SQLException Nếu có lỗi truy vấn database
     */
    public List<UUID> findAllCompletedBookingsWithoutReview(UUID userId, UUID carId) throws SQLException {
        List<UUID> bookingIds = new ArrayList<>();
        
        String sql = "SELECT b.BookingId FROM Booking b " +
                "LEFT JOIN UserFeedback f ON b.BookingId = f.BookingId " +
                "WHERE b.UserId = ? AND b.CarId = ? AND b.Status = ? AND f.FeedbackId IS NULL " +
                "ORDER BY b.ReturnDateTime DESC";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, userId.toString());
            stmt.setString(2, carId.toString());
            stmt.setString(3, BookingStatusConstants.COMPLETED);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    bookingIds.add(UUID.fromString(rs.getString("BookingId")));
                }
            }
        }
        
        return bookingIds;
}

    /**
     * Kiểm tra xem người dùng có booking đã hoàn thành cho một chiếc xe cụ thể hay không
     * @param userId ID của người dùng
     * @param carId ID của xe
     * @return true nếu người dùng có ít nhất một booking đã hoàn thành cho xe này
     * @throws SQLException nếu có lỗi truy vấn cơ sở dữ liệu
     */
    public boolean hasCompletedBookings(UUID userId, UUID carId) throws SQLException {
        if (userId == null || carId == null) {
            throw new IllegalArgumentException("User ID and Car ID cannot be null");
        }
        
        String sql = "SELECT COUNT(*) FROM Booking b " +
                     "JOIN Car c ON b.CarId = c.CarId " +
                     "WHERE b.UserId = ? AND c.CarId = ? AND b.Status = ?";
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, userId);
            ps.setObject(2, carId);
            ps.setString(3, BookingStatusConstants.COMPLETED);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
                return false;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if user has completed bookings for car: " + e.getMessage(), e);
            throw e;
        }
    }
}

