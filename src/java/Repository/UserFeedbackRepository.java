package Repository;

import Config.DBContext;
import Model.Entity.UserFeedback;
import Repository.Interfaces.IUserFeedbackRepository;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserFeedbackRepository implements IUserFeedbackRepository {

    private static final Logger LOGGER = Logger.getLogger(UserFeedbackRepository.class.getName());
    private final DBContext dbContext;

    // SQL queries
    private static final String SQL_INSERT = 
            "INSERT INTO UserFeedback (FeedbackId, UserId, CarId, BookingId, Rating, Content, Reviewed, CreatedDate) " +
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    
    private static final String SQL_FIND_BY_ID = 
            "SELECT * FROM UserFeedback WHERE FeedbackId = ?";
    
    private static final String SQL_UPDATE = 
            "UPDATE UserFeedback SET UserId = ?, CarId = ?, BookingId = ?, Rating = ?, " +
            "Content = ?, Reviewed = ? WHERE FeedbackId = ?";
    
    private static final String SQL_DELETE = 
            "DELETE FROM UserFeedback WHERE FeedbackId = ?";
    
    private static final String SQL_FIND_ALL = 
            "SELECT * FROM UserFeedback ORDER BY CreatedDate DESC";
    
    private static final String SQL_FIND_BY_CAR_ID = 
            "SELECT * FROM UserFeedback WHERE CarId = ? ORDER BY CreatedDate DESC";
    
    private static final String SQL_FIND_BY_USER_ID = 
            "SELECT * FROM UserFeedback WHERE UserId = ? ORDER BY CreatedDate DESC";
    
    private static final String SQL_FIND_BY_BOOKING_ID = 
            "SELECT * FROM UserFeedback WHERE BookingId = ?";
    
    private static final String SQL_EXISTS_BY_BOOKING_ID = 
            "SELECT COUNT(*) FROM UserFeedback WHERE BookingId = ?";
    
    private static final String SQL_GET_AVERAGE_RATING = 
            "SELECT AVG(CAST(Rating AS FLOAT)) FROM UserFeedback WHERE CarId = ?";
    
    private static final String SQL_COUNT_FEEDBACK = 
            "SELECT COUNT(*) FROM UserFeedback WHERE CarId = ?";

    public UserFeedbackRepository() {
        this.dbContext = new DBContext();
    }

    @Override
    public UserFeedback add(UserFeedback entity) throws SQLException {
        if (entity == null) {
            throw new IllegalArgumentException("UserFeedback entity cannot be null");
        }
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_INSERT)) {
            
            ps.setObject(1, entity.getFeedbackId());
            ps.setObject(2, entity.getUserId());
            ps.setObject(3, entity.getCarId());
            ps.setObject(4, entity.getBookingId());
            ps.setInt(5, entity.getRating());
            ps.setString(6, entity.getContent());
            ps.setDate(7, entity.getReviewed() != null ? Date.valueOf(entity.getReviewed()) : null);
            ps.setTimestamp(8, entity.getCreatedDate() != null ? 
                    Timestamp.valueOf(entity.getCreatedDate()) : Timestamp.valueOf(LocalDateTime.now()));
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                LOGGER.info("Successfully added feedback with ID: " + entity.getFeedbackId());
                return entity;
            } else {
                LOGGER.warning("Failed to add feedback with ID: " + entity.getFeedbackId());
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding feedback: " + e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public UserFeedback findById(UUID id) throws SQLException {
        if (id == null) {
            throw new IllegalArgumentException("Feedback ID cannot be null");
        }
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_ID)) {
            
            ps.setObject(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToFeedback(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding feedback by ID: " + e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public boolean update(UserFeedback entity) throws SQLException {
        if (entity == null || entity.getFeedbackId() == null) {
            throw new IllegalArgumentException("UserFeedback entity and ID cannot be null");
        }
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE)) {
            
            ps.setObject(1, entity.getUserId());
            ps.setObject(2, entity.getCarId());
            ps.setObject(3, entity.getBookingId());
            ps.setInt(4, entity.getRating());
            ps.setString(5, entity.getContent());
            ps.setDate(6, entity.getReviewed() != null ? Date.valueOf(entity.getReviewed()) : null);
            ps.setObject(7, entity.getFeedbackId());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating feedback: " + e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public boolean delete(UUID id) throws SQLException {
        if (id == null) {
            throw new IllegalArgumentException("Feedback ID cannot be null");
        }
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_DELETE)) {
            
            ps.setObject(1, id);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting feedback: " + e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public List<UserFeedback> findAll() throws SQLException {
        List<UserFeedback> feedbackList = new ArrayList<>();
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_ALL);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                feedbackList.add(mapResultSetToFeedback(rs));
            }
            return feedbackList;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all feedback: " + e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public List<UserFeedback> findByCarId(UUID carId) throws SQLException {
        if (carId == null) {
            throw new IllegalArgumentException("Car ID cannot be null");
        }
        
        List<UserFeedback> feedbackList = new ArrayList<>();
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_CAR_ID)) {
            
            ps.setObject(1, carId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    feedbackList.add(mapResultSetToFeedback(rs));
                }
            }
            return feedbackList;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding feedback by car ID: " + e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public List<UserFeedback> findApprovedFeedbackByCarId(UUID carId) throws SQLException {
        // Since IsApproved is removed, we'll just return all feedback for the car
        return findByCarId(carId);
    }

    @Override
    public List<UserFeedback> findByUserId(UUID userId) throws SQLException {
        if (userId == null) {
            throw new IllegalArgumentException("User ID cannot be null");
        }
        
        List<UserFeedback> feedbackList = new ArrayList<>();
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_USER_ID)) {
            
            ps.setObject(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    feedbackList.add(mapResultSetToFeedback(rs));
                }
            }
            return feedbackList;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding feedback by user ID: " + e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public UserFeedback findByBookingId(UUID bookingId) throws SQLException {
        if (bookingId == null) {
            throw new IllegalArgumentException("Booking ID cannot be null");
        }
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_BOOKING_ID)) {
            
            ps.setObject(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToFeedback(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding feedback by booking ID: " + e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public boolean existsByBookingId(UUID bookingId) throws SQLException {
        if (bookingId == null) {
            throw new IllegalArgumentException("Booking ID cannot be null");
        }
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_EXISTS_BY_BOOKING_ID)) {
            
            ps.setObject(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
                return false;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error checking if feedback exists for booking: " + e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public double getAverageRatingForCar(UUID carId) throws SQLException {
        if (carId == null) {
            throw new IllegalArgumentException("Car ID cannot be null");
        }
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_AVERAGE_RATING)) {
            
            ps.setObject(1, carId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    double avgRating = rs.getDouble(1);
                    return rs.wasNull() ? 0 : avgRating;
                }
                return 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting average rating for car: " + e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public int countFeedbackForCar(UUID carId) throws SQLException {
        if (carId == null) {
            throw new IllegalArgumentException("Car ID cannot be null");
        }
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_COUNT_FEEDBACK)) {
            
            ps.setObject(1, carId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
                return 0;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error counting feedback for car: " + e.getMessage(), e);
            throw e;
        }
    }

    @Override
    public boolean approveFeedback(UUID feedbackId) throws SQLException {
        // Since IsApproved is removed, this method is now a no-op
        LOGGER.info("approveFeedback called but IsApproved field has been removed");
        return true;
    }

    private UserFeedback mapResultSetToFeedback(ResultSet rs) throws SQLException {
        UserFeedback feedback = new UserFeedback();
        feedback.setFeedbackId(UUID.fromString(rs.getString("FeedbackId")));
        feedback.setUserId(UUID.fromString(rs.getString("UserId")));
        
        String carIdStr = rs.getString("CarId");
        if (carIdStr != null) {
            feedback.setCarId(UUID.fromString(carIdStr));
        }
        
        String bookingIdStr = rs.getString("BookingId");
        if (bookingIdStr != null) {
            feedback.setBookingId(UUID.fromString(bookingIdStr));
        }
        
        feedback.setRating(rs.getInt("Rating"));
        feedback.setContent(rs.getString("Content"));
        
        Date reviewedDate = rs.getDate("Reviewed");
        if (reviewedDate != null) {
            feedback.setReviewed(reviewedDate.toLocalDate());
        }
        
        Timestamp createdTimestamp = rs.getTimestamp("CreatedDate");
        if (createdTimestamp != null) {
            feedback.setCreatedDate(createdTimestamp.toLocalDateTime());
        }
        
        return feedback;
    }
} 