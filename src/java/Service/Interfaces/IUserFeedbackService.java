package Service.Interfaces;

import Model.DTO.UserFeedbackDTO;
import Model.Entity.UserFeedback;
import java.util.List;
import java.util.UUID;

/**
 * Interface for UserFeedback service operations
 */
public interface IUserFeedbackService {
    
    /**
     * Add a new feedback
     * @param feedback The feedback to add
     * @return The added feedback
     * @throws Exception If an error occurs
     */
    UserFeedback addFeedback(UserFeedback feedback) throws Exception;
    
    /**
     * Update an existing feedback
     * @param feedback The feedback to update
     * @return true if successful, false otherwise
     * @throws Exception If an error occurs
     */
    boolean updateFeedback(UserFeedback feedback) throws Exception;
    
    /**
     * Delete a feedback
     * @param feedbackId The ID of the feedback to delete
     * @return true if successful, false otherwise
     * @throws Exception If an error occurs
     */
    boolean deleteFeedback(UUID feedbackId) throws Exception;
    
    /**
     * Find feedback by ID
     * @param feedbackId The ID of the feedback to find
     * @return The feedback if found, null otherwise
     * @throws Exception If an error occurs
     */
    UserFeedback findById(UUID feedbackId) throws Exception;
    
    /**
     * Get all feedback for a car
     * @param carId The car ID
     * @return List of feedback DTOs
     * @throws Exception If an error occurs
     */
    List<UserFeedbackDTO> getFeedbackByCarId(UUID carId) throws Exception;
    
    /**
     * Get all approved feedback for a car
     * @param carId The car ID
     * @return List of approved feedback DTOs
     * @throws Exception If an error occurs
     */
    List<UserFeedbackDTO> getApprovedFeedbackByCarId(UUID carId) throws Exception;
    
    /**
     * Get all feedback by a user
     * @param userId The user ID
     * @return List of feedback DTOs
     * @throws Exception If an error occurs
     */
    List<UserFeedbackDTO> getFeedbackByUserId(UUID userId) throws Exception;
    
    /**
     * Get feedback for a specific booking
     * @param bookingId The booking ID
     * @return The feedback DTO or null if none exists
     * @throws Exception If an error occurs
     */
    UserFeedbackDTO getFeedbackByBookingId(UUID bookingId) throws Exception;
    
    /**
     * Check if a user can leave feedback for a car
     * @param userId The user ID
     * @param carId The car ID
     * @return true if the user can leave feedback, false otherwise
     * @throws Exception If an error occurs
     */
    boolean canLeaveFeedback(UUID userId, UUID carId) throws Exception;
    
    /**
     * Get the booking ID that can be used for feedback
     * @param userId The user ID
     * @param carId The car ID
     * @return The booking ID or null if none exists
     * @throws Exception If an error occurs
     */
    UUID getEligibleBookingForFeedback(UUID userId, UUID carId) throws Exception;
    
    /**
     * Get all eligible booking IDs that can be used for feedback
     * @param userId The user ID
     * @param carId The car ID
     * @return List of eligible booking IDs
     * @throws Exception If an error occurs
     */
    List<UUID> getAllEligibleBookingsForFeedback(UUID userId, UUID carId) throws Exception;
    
    /**
     * Get average rating for a car
     * @param carId The car ID
     * @return The average rating or 0 if no ratings
     * @throws Exception If an error occurs
     */
    double getAverageRatingForCar(UUID carId) throws Exception;
    
    /**
     * Count total number of feedback for a car
     * @param carId The car ID
     * @return The count of feedback
     * @throws Exception If an error occurs
     */
    int countFeedbackForCar(UUID carId) throws Exception;
    
    /**
     * Approve a feedback
     * @param feedbackId The feedback ID
     * @return true if successful, false otherwise
     * @throws Exception If an error occurs
     */
    boolean approveFeedback(UUID feedbackId) throws Exception;
    
    /**
     * Add a staff reply to a feedback
     * @param feedbackId The feedback ID
     * @param reply The reply content
     * @return true if successful, false otherwise
     * @throws Exception If an error occurs
     */
    boolean addStaffReply(UUID feedbackId, String reply) throws Exception;
    
    /**
     * Get all feedback pending staff reply
     * @return List of feedback DTOs pending reply
     * @throws Exception If an error occurs
     */
    List<UserFeedbackDTO> getPendingReplies() throws Exception;
    
    /**
     * Get all feedback (both responded and pending)
     * @return List of all feedback DTOs
     * @throws Exception If an error occurs
     */
    List<UserFeedbackDTO> getAllFeedback() throws Exception;
    
    /**
     * Get all feedback that have staff replies
     * @return List of feedback DTOs with staff replies
     * @throws Exception If an error occurs
     */
    List<UserFeedbackDTO> getRespondedFeedback() throws Exception;
    
    /**
     * Get all feedback with a specific rating
     * @param rating The rating to filter by (1-5)
     * @return List of feedback DTOs with the specified rating
     * @throws Exception If an error occurs
     */
    List<UserFeedbackDTO> getFeedbackByRating(int rating) throws Exception;
    
    /**
     * Add a staff reply to multiple feedback entries
     * @param feedbackIds List of feedback IDs to reply to
     * @param reply The reply content
     * @return true if all replies were added successfully, false otherwise
     * @throws Exception If an error occurs
     */
    boolean addBulkStaffReply(List<UUID> feedbackIds, String reply) throws Exception;
} 