package Repository.Interfaces;

import Model.Entity.UserFeedback;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

/**
 * Interface for UserFeedback repository operations
 */
public interface IUserFeedbackRepository extends Repository<UserFeedback, UUID> {
    
    /**
     * Find all feedback for a specific car
     * @param carId The car ID
     * @return List of feedback for the car
     * @throws SQLException If a database error occurs
     */
    List<UserFeedback> findByCarId(UUID carId) throws SQLException;
    
    /**
     * Find all feedback by a specific user
     * @param userId The user ID
     * @return List of feedback by the user
     * @throws SQLException If a database error occurs
     */
    List<UserFeedback> findByUserId(UUID userId) throws SQLException;
    
    /**
     * Find feedback for a specific booking
     * @param bookingId The booking ID
     * @return The feedback for the booking, or null if none exists
     * @throws SQLException If a database error occurs
     */
    UserFeedback findByBookingId(UUID bookingId) throws SQLException;
    
    /**
     * Check if a user has already submitted feedback for a specific booking
     * @param bookingId The booking ID
     * @return true if feedback exists, false otherwise
     * @throws SQLException If a database error occurs
     */
    boolean existsByBookingId(UUID bookingId) throws SQLException;
    
    /**
     * Get average rating for a car
     * @param carId The car ID
     * @return The average rating or 0 if no ratings
     * @throws SQLException If a database error occurs
     */
    double getAverageRatingForCar(UUID carId) throws SQLException;
    
    /**
     * Count total number of feedback for a car
     * @param carId The car ID
     * @return The count of feedback
     * @throws SQLException If a database error occurs
     */
    int countFeedbackForCar(UUID carId) throws SQLException;
    
    /**
     * Approve a feedback
     * @param feedbackId The feedback ID
     * @return true if successful, false otherwise
     * @throws SQLException If a database error occurs
     */
    boolean approveFeedback(UUID feedbackId) throws SQLException;
    
    /**
     * Get all approved feedback for a car
     * @param carId The car ID
     * @return List of approved feedback
     * @throws SQLException If a database error occurs
     */
    List<UserFeedback> findApprovedFeedbackByCarId(UUID carId) throws SQLException;
} 