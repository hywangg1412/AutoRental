package Service;

import Model.DTO.UserFeedbackDTO;
import Model.Entity.Booking.Booking;
import Model.Entity.UserFeedback;
import Repository.Booking.BookingRepository;
import Repository.Interfaces.IUserFeedbackRepository;
import Repository.UserFeedbackRepository;
import Service.Interfaces.IUserFeedbackService;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserFeedbackService implements IUserFeedbackService {
    
    private static final Logger LOGGER = Logger.getLogger(UserFeedbackService.class.getName());
    private final IUserFeedbackRepository userFeedbackRepository;
    private final BookingRepository bookingRepository;
    
    public UserFeedbackService() {
        this.userFeedbackRepository = new UserFeedbackRepository();
        this.bookingRepository = new BookingRepository();
    }

    @Override
    public UserFeedback addFeedback(UserFeedback feedback) throws Exception {
        try {
            // Generate UUID if not provided
            if (feedback.getFeedbackId() == null) {
                feedback.setFeedbackId(UUID.randomUUID());
            }
            
            // Set current date if not provided
            if (feedback.getReviewed() == null) {
                feedback.setReviewed(LocalDate.now());
        }
            
            if (feedback.getCreatedDate() == null) {
                feedback.setCreatedDate(LocalDateTime.now());
            }
            
            return userFeedbackRepository.add(feedback);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding feedback: " + e.getMessage(), e);
            throw new Exception("Failed to add feedback: " + e.getMessage());
        }
    }

    @Override
    public boolean updateFeedback(UserFeedback feedback) throws Exception {
        try {
            // Check if feedback exists
            UserFeedback existingFeedback = userFeedbackRepository.findById(feedback.getFeedbackId());
            if (existingFeedback == null) {
                throw new Exception("Feedback not found with ID: " + feedback.getFeedbackId());
            }
            
            return userFeedbackRepository.update(feedback);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating feedback: " + e.getMessage(), e);
            throw new Exception("Failed to update feedback: " + e.getMessage());
        }
    }

    @Override
    public boolean deleteFeedback(UUID feedbackId) throws Exception {
        try {
            // Check if feedback exists
            UserFeedback existingFeedback = userFeedbackRepository.findById(feedbackId);
            if (existingFeedback == null) {
                throw new Exception("Feedback not found with ID: " + feedbackId);
            }
            
            return userFeedbackRepository.delete(feedbackId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting feedback: " + e.getMessage(), e);
            throw new Exception("Failed to delete feedback: " + e.getMessage());
        }
    }

    @Override
    public UserFeedback findById(UUID feedbackId) throws Exception {
        try {
            return userFeedbackRepository.findById(feedbackId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding feedback by ID: " + e.getMessage(), e);
            throw new Exception("Failed to find feedback: " + e.getMessage());
        }
    }

    @Override
    public List<UserFeedbackDTO> getFeedbackByCarId(UUID carId) throws Exception {
        try {
            List<UserFeedback> feedbacks = userFeedbackRepository.findByCarId(carId);
            return convertToFeedbackDTOs(feedbacks);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting feedback by car ID: " + e.getMessage(), e);
            throw new Exception("Failed to get feedback for car: " + e.getMessage());
        }
    }

    @Override
    public List<UserFeedbackDTO> getApprovedFeedbackByCarId(UUID carId) throws Exception {
        try {
            List<UserFeedback> feedbacks = userFeedbackRepository.findApprovedFeedbackByCarId(carId);
            return convertToFeedbackDTOs(feedbacks);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting approved feedback by car ID: " + e.getMessage(), e);
            throw new Exception("Failed to get approved feedback for car: " + e.getMessage());
        }
    }

    @Override
    public List<UserFeedbackDTO> getFeedbackByUserId(UUID userId) throws Exception {
        try {
            List<UserFeedback> feedbacks = userFeedbackRepository.findByUserId(userId);
            return convertToFeedbackDTOs(feedbacks);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting feedback by user ID: " + e.getMessage(), e);
            throw new Exception("Failed to get feedback for user: " + e.getMessage());
        }
    }

    @Override
    public UserFeedbackDTO getFeedbackByBookingId(UUID bookingId) throws Exception {
        try {
            UserFeedback feedback = userFeedbackRepository.findByBookingId(bookingId);
            if (feedback == null) {
                return null;
            }
            return convertToFeedbackDTO(feedback);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting feedback by booking ID: " + e.getMessage(), e);
            throw new Exception("Failed to get feedback for booking: " + e.getMessage());
        }
    }

    @Override
    public boolean canLeaveFeedback(UUID userId, UUID carId) throws Exception {
        try {
            return bookingRepository.hasCompletedBookingWithoutReview(userId, carId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking if user can leave feedback: " + e.getMessage(), e);
            throw new Exception("Failed to check if user can leave feedback: " + e.getMessage());
        }
    }

    @Override
    public UUID getEligibleBookingForFeedback(UUID userId, UUID carId) throws Exception {
        try {
            return bookingRepository.findCompletedBookingWithoutReview(userId, carId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting eligible booking for feedback: " + e.getMessage(), e);
            throw new Exception("Failed to get eligible booking for feedback: " + e.getMessage());
        }
    }

    @Override
    public List<UUID> getAllEligibleBookingsForFeedback(UUID userId, UUID carId) throws Exception {
        try {
            return bookingRepository.findAllCompletedBookingsWithoutReview(userId, carId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting all eligible bookings for feedback: " + e.getMessage(), e);
            throw new Exception("Failed to get all eligible bookings for feedback: " + e.getMessage());
        }
    }

    @Override
    public double getAverageRatingForCar(UUID carId) throws Exception {
        try {
            return userFeedbackRepository.getAverageRatingForCar(carId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting average rating for car: " + e.getMessage(), e);
            throw new Exception("Failed to get average rating for car: " + e.getMessage());
        }
    }

    @Override
    public int countFeedbackForCar(UUID carId) throws Exception {
        try {
            return userFeedbackRepository.countFeedbackForCar(carId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error counting feedback for car: " + e.getMessage(), e);
            throw new Exception("Failed to count feedback for car: " + e.getMessage());
        }
    }

    @Override
    public boolean approveFeedback(UUID feedbackId) throws Exception {
        try {
            return userFeedbackRepository.approveFeedback(feedbackId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error approving feedback: " + e.getMessage(), e);
            throw new Exception("Failed to approve feedback: " + e.getMessage());
        }
    }
    
    /**
     * Convert a UserFeedback entity to DTO
     * @param feedback The feedback entity
     * @return The feedback DTO
     */
    private UserFeedbackDTO convertToFeedbackDTO(UserFeedback feedback) {
        if (feedback == null) {
            return null;
        }
        
        UserFeedbackDTO dto = new UserFeedbackDTO();
        dto.setFeedbackId(feedback.getFeedbackId());
        dto.setUserId(feedback.getUserId());
        dto.setCarId(feedback.getCarId());
        dto.setBookingId(feedback.getBookingId());
        dto.setRating(feedback.getRating());
        dto.setContent(feedback.getContent());
        dto.setReviewed(feedback.getReviewed());
        dto.setCreatedDate(feedback.getCreatedDate());
        
        // Lấy booking code từ booking repository nếu có bookingId
        if (feedback.getBookingId() != null) {
            try {
                Booking booking = bookingRepository.findById(feedback.getBookingId());
                if (booking != null) {
                    dto.setBookingCode(booking.getBookingCode());
                }
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Could not retrieve booking code for feedback: " + e.getMessage(), e);
            }
        }
        
        // Note: User details (username, avatar) and car details (model, brand)
        // would typically be populated from their respective services
        // This is a simplified implementation
        return dto;
    }
    
    /**
     * Convert a list of UserFeedback entities to DTOs
     * @param feedbacks The list of feedback entities
     * @return The list of feedback DTOs
     */
    private List<UserFeedbackDTO> convertToFeedbackDTOs(List<UserFeedback> feedbacks) {
        List<UserFeedbackDTO> dtos = new ArrayList<>();
            if (feedbacks == null || feedbacks.isEmpty()) {
            return dtos;
        }
        
        for (UserFeedback feedback : feedbacks) {
            dtos.add(convertToFeedbackDTO(feedback));
        }
        
        return dtos;
}
}