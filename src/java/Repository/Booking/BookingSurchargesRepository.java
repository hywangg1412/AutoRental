/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository.Booking;

import Config.DBContext;
import Model.Entity.Booking.BookingSurcharges;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Repository xử lý các thao tác database cho BookingSurcharges Quản lý các phí
 * phụ của booking (VAT, penalty, service)
 */
public class BookingSurchargesRepository {

    private static final Logger LOGGER = Logger.getLogger(BookingSurchargesRepository.class.getName());
    private final DBContext dbContext;

    // SQL queries
    private static final String SQL_INSERT
            = "INSERT INTO BookingSurcharges (SurchargeId, BookingId, SurchargeType, Amount, "
            + "Description, CreatedDate, SurchargeCategory, IsSystemGenerated) "
            + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

    private static final String SQL_FIND_BY_BOOKING
            = "SELECT * FROM BookingSurcharges WHERE BookingId = ?";

    private static final String SQL_FIND_BY_CATEGORY
            = "SELECT * FROM BookingSurcharges WHERE BookingId = ? AND SurchargeCategory = ?";

    private static final String SQL_DELETE_BY_BOOKING_AND_CATEGORY
            = "DELETE FROM BookingSurcharges WHERE BookingId = ? AND SurchargeCategory = ?";

    private static final String SQL_FIND_BY_ID
            = "SELECT * FROM BookingSurcharges WHERE SurchargeId = ?";

    private static final String SQL_UPDATE
            = "UPDATE BookingSurcharges SET BookingId = ?, SurchargeType = ?, Amount = ?, "
            + "Description = ?, SurchargeCategory = ?, IsSystemGenerated = ? WHERE SurchargeId = ?";

    private static final String SQL_DELETE
            = "DELETE FROM BookingSurcharges WHERE SurchargeId = ?";

    private static final String SQL_FIND_ALL
            = "SELECT * FROM BookingSurcharges";

    public BookingSurchargesRepository() {
        this.dbContext = new DBContext();
    }

    /**
     * Thêm phí phụ mới cho booking
     */
    public BookingSurcharges add(BookingSurcharges entity) throws SQLException {
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_INSERT)) {

            ps.setObject(1, entity.getSurchargeId());
            ps.setObject(2, entity.getBookingId());
            ps.setString(3, entity.getSurchargeType());
            ps.setDouble(4, entity.getAmount());
            ps.setString(5, entity.getDescription());
            ps.setTimestamp(6, Timestamp.valueOf(entity.getCreatedDate()));
            ps.setString(7, entity.getSurchargeCategory());
            ps.setBoolean(8, entity.isSystemGenerated());

            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                return entity;
            }
            return null;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding booking surcharge", e);
            throw e;
        }
    }

    /**
     * Lấy tất cả phí phụ của một booking
     */
    public List<BookingSurcharges> findByBookingId(UUID bookingId) throws SQLException {
        List<BookingSurcharges> surcharges = new ArrayList<>();

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_BOOKING)) {

            ps.setObject(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    surcharges.add(mapResultSetToBookingSurcharges(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding surcharges by booking ID: " + bookingId, e);
            throw e;
        }

        return surcharges;
    }

    /**
     * Lấy phí phụ theo booking và category
     */
    public List<BookingSurcharges> findByBookingIdAndCategory(UUID bookingId, String category) throws SQLException {
        List<BookingSurcharges> surcharges = new ArrayList<>();

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_CATEGORY)) {

            ps.setObject(1, bookingId);
            ps.setString(2, category);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    surcharges.add(mapResultSetToBookingSurcharges(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding surcharges by category", e);
            throw e;
        }

        return surcharges;
    }

    /**
     * Xóa phí phụ theo booking và category (dùng để reset VAT khi tính lại)
     */
    public boolean deleteByBookingIdAndCategory(UUID bookingId, String category) throws SQLException {
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_DELETE_BY_BOOKING_AND_CATEGORY)) {

            ps.setObject(1, bookingId);
            ps.setString(2, category);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting surcharges by category", e);
            throw e;
        }
    }

    /**
     * Tính tổng phí phụ theo category
     */
    public double getTotalAmountByCategory(UUID bookingId, String category) throws SQLException {
        String sql = "SELECT SUM(Amount) as Total FROM BookingSurcharges WHERE BookingId = ? AND SurchargeCategory = ?";

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setObject(1, bookingId);
            ps.setString(2, category);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("Total");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating total amount by category", e);
            throw e;
        }

        return 0.0;
    }

    // ========== BASIC CRUD METHODS ==========
    public BookingSurcharges findById(UUID id) throws SQLException {
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_ID)) {

            ps.setObject(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBookingSurcharges(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding surcharge by ID: " + id, e);
            throw e;
        }
    }

    public boolean update(BookingSurcharges entity) throws SQLException {
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_UPDATE)) {

            ps.setObject(1, entity.getBookingId());
            ps.setString(2, entity.getSurchargeType());
            ps.setDouble(3, entity.getAmount());
            ps.setString(4, entity.getDescription());
            ps.setString(5, entity.getSurchargeCategory());
            ps.setBoolean(6, entity.isSystemGenerated());
            ps.setObject(7, entity.getSurchargeId());

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating surcharge", e);
            throw e;
        }
    }

    public boolean delete(UUID id) throws SQLException {
        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_DELETE)) {

            ps.setObject(1, id);

            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting surcharge", e);
            throw e;
        }
    }

    public List<BookingSurcharges> findAll() throws SQLException {
        List<BookingSurcharges> surcharges = new ArrayList<>();

        try (Connection conn = dbContext.getConnection(); PreparedStatement ps = conn.prepareStatement(SQL_FIND_ALL); ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                surcharges.add(mapResultSetToBookingSurcharges(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all surcharges", e);
            throw e;
        }

        return surcharges;
    }

    // ========== HELPER METHODS ==========
    /**
     * Map ResultSet sang BookingSurcharges object
     */
    private BookingSurcharges mapResultSetToBookingSurcharges(ResultSet rs) throws SQLException {
        BookingSurcharges surcharge = new BookingSurcharges();

        surcharge.setSurchargeId(UUID.fromString(rs.getString("SurchargeId")));
        surcharge.setBookingId(UUID.fromString(rs.getString("BookingId")));
        surcharge.setSurchargeType(rs.getString("SurchargeType"));
        surcharge.setAmount(rs.getDouble("Amount"));
        surcharge.setDescription(rs.getString("Description"));
        surcharge.setCreatedDate(rs.getTimestamp("CreatedDate").toLocalDateTime());
        surcharge.setSurchargeCategory(rs.getString("SurchargeCategory"));
        surcharge.setSystemGenerated(rs.getBoolean("IsSystemGenerated"));

        return surcharge;
    }
}