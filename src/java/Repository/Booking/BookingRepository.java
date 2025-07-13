package Repository.Booking;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import Config.DBContext;
import Model.Entity.Booking.Booking;
import Repository.Interfaces.IBooking.IBookingRepository;

public class BookingRepository implements IBookingRepository {
    private static final Logger LOGGER = Logger.getLogger(BookingRepository.class.getName());
    private final DBContext dbContext;
    
    private static final String SQL_INSERT = 
        "INSERT INTO Booking (BookingId, UserId, CarId, HandledBy, PickupDateTime, ReturnDateTime, " +
        "TotalAmount, Status, DiscountId, CreatedDate, CancelReason, BookingCode, ExpectedPaymentMethod, " +
        "CustomerName, CustomerPhone, CustomerAddress, CustomerEmail, DriverLicenseImageUrl) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    private static final String SQL_FIND_BY_ID = "SELECT * FROM Booking WHERE BookingId = ?";
    
    private static final String SQL_UPDATE = 
        "UPDATE Booking SET UserId = ?, CarId = ?, HandledBy = ?, PickupDateTime = ?, " +
        "ReturnDateTime = ?, TotalAmount = ?, Status = ?, DiscountId = ?, CreatedDate = ?, " +
        "CancelReason = ?, BookingCode = ?, ExpectedPaymentMethod = ?, " +
        "CustomerName = ?, CustomerPhone = ?, CustomerAddress = ?, CustomerEmail = ?, DriverLicenseImageUrl = ? " +
        "WHERE BookingId = ?";
    
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
        LOGGER.info("Booking code before insert: " + entity.getBookingCode());
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_INSERT)) {
            
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
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_ID)) {
            
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
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE)) {
            
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
            ps.setObject(18, entity.getBookingId());
            
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
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_DELETE)) {
            
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
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_ALL);
             ResultSet rs = ps.executeQuery()) {
            
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
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
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
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_USER_ID)) {
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
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE_STATUS)) {
            
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
        LOGGER.info("BookingCode parameter: " + entity.getBookingCode());
        
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
        
        LOGGER.info("All parameters set successfully");
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
        return booking;
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
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
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

}
