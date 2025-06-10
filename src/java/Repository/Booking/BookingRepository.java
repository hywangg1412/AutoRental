package Repository.Booking;

import Config.DBContext;
import Model.Entity.Booking.Booking;
import Repository.Interfaces.IBooking.IBookingRepository;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookingRepository implements IBookingRepository {
    private static final Logger LOGGER = Logger.getLogger(BookingRepository.class.getName());
    private final DBContext dbContext;
    
    private static final String SQL_INSERT = 
        "INSERT INTO Booking (BookingId, UserId, CarId, HandledBy, PickupDateTime, ReturnDateTime, " +
        "TotalAmount, Status, DiscountId, CreatedDate, CancelReason, BookingCode, ExpectedPaymentMethod) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
    
    private static final String SQL_FIND_BY_ID = "SELECT * FROM Booking WHERE BookingId = ?";
    
    private static final String SQL_UPDATE = 
        "UPDATE Booking SET UserId = ?, CarId = ?, HandledBy = ?, PickupDateTime = ?, " +
        "ReturnDateTime = ?, TotalAmount = ?, Status = ?, DiscountId = ?, CreatedDate = ?, " +
        "CancelReason = ?, BookingCode = ?, ExpectedPaymentMethod = ? WHERE BookingId = ?";
    
    private static final String SQL_DELETE = "DELETE FROM Booking WHERE BookingId = ?";
    private static final String SQL_FIND_ALL = "SELECT * FROM Booking";

    public BookingRepository() {
        this.dbContext = new DBContext();
    }

    @Override
    public Booking add(Booking entity) throws SQLException {
        if (entity == null) {
            throw new IllegalArgumentException("Booking entity cannot be null");
        }
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_INSERT)) {
            
            setBookingParameters(ps, entity);
            ps.executeUpdate();
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
            
            setBookingParameters(ps, entity);
            ps.setObject(13, entity.getBookingId());
            
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

    private void setBookingParameters(PreparedStatement ps, Booking booking) throws SQLException {
        ps.setObject(1, booking.getUserId());
        ps.setObject(2, booking.getCarId());
        ps.setObject(3, booking.getHandledBy());
        ps.setObject(4, booking.getPickupDateTime());
        ps.setObject(5, booking.getReturnDateTime());
        ps.setDouble(6, booking.getTotalAmount());
        ps.setString(7, booking.getStatus());
        ps.setObject(8, booking.getDiscountId());
        ps.setObject(9, booking.getCreatedDate());
        ps.setString(10, booking.getCancelReason());
        ps.setString(11, booking.getBookingCode());
        ps.setString(12, booking.getExpectedPaymentMethod());
    }

    private Booking mapResultSetToBooking(ResultSet rs) throws SQLException {
        Booking booking = new Booking();
        booking.setBookingId(UUID.fromString(rs.getString("BookingId")));
        booking.setUserId(UUID.fromString(rs.getString("UserId")));
        booking.setCarId(rs.getString("CarId") != null ? UUID.fromString(rs.getString("CarId")) : null);
        booking.setHandledBy(rs.getString("HandledBy") != null ? UUID.fromString(rs.getString("HandledBy")) : null);
        booking.setPickupDateTime(rs.getTimestamp("PickupDateTime").toLocalDateTime());
        booking.setReturnDateTime(rs.getTimestamp("ReturnDateTime").toLocalDateTime());
        booking.setTotalAmount(rs.getDouble("TotalAmount"));
        booking.setStatus(rs.getString("Status"));
        booking.setDiscountId(rs.getString("DiscountId") != null ? UUID.fromString(rs.getString("DiscountId")) : null);
        booking.setCreatedDate(rs.getTimestamp("CreatedDate").toLocalDateTime());
        booking.setCancelReason(rs.getString("CancelReason"));
        booking.setBookingCode(rs.getString("BookingCode"));
        booking.setExpectedPaymentMethod(rs.getString("ExpectedPaymentMethod"));
        return booking;
    }
}
