package Service;

import Model.DTO.UserFeedbackDTO;
import Model.Entity.Booking.Booking;
import Model.Entity.Car.Car;
import Model.Entity.Car.CarBrand;
import Model.Entity.User.User;
import Model.Entity.UserFeedback;
import Repository.Booking.BookingRepository;
import Repository.Car.CarBrandRepository;
import Repository.Car.CarRepository;
import Repository.Interfaces.IUserFeedbackRepository;
import Repository.User.UserRepository;
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
import java.util.stream.Collectors;

public class UserFeedbackService implements IUserFeedbackService {
    
    private static final Logger LOGGER = Logger.getLogger(UserFeedbackService.class.getName());
    private final IUserFeedbackRepository userFeedbackRepository;
    private final BookingRepository bookingRepository;
    private final CarRepository carRepository;
    private final CarBrandRepository carBrandRepository;
    private final UserRepository userRepository;
    
    public UserFeedbackService() {
        this.userFeedbackRepository = new UserFeedbackRepository();
        this.bookingRepository = new BookingRepository();
        this.carRepository = new CarRepository();
        this.carBrandRepository = new CarBrandRepository();
        this.userRepository = new UserRepository();
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
    
    @Override
    public boolean addStaffReply(UUID feedbackId, String reply) throws Exception {
        try {
            // Check if feedback exists
            UserFeedback existingFeedback = userFeedbackRepository.findById(feedbackId);
            if (existingFeedback == null) {
                throw new Exception("Feedback not found with ID: " + feedbackId);
            }
            
            return userFeedbackRepository.addStaffReply(feedbackId, reply);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding staff reply to feedback: " + e.getMessage(), e);
            throw new Exception("Failed to add staff reply: " + e.getMessage());
        }
    }
    
    @Override
    public List<UserFeedbackDTO> getPendingReplies() throws Exception {
        try {
            List<UserFeedback> feedbacks = userFeedbackRepository.findPendingReplies();
            return convertToFeedbackDTOs(feedbacks);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting pending replies: " + e.getMessage(), e);
            throw new Exception("Failed to get pending replies: " + e.getMessage());
        }
    }
    
    @Override
    public List<UserFeedbackDTO> getAllFeedback() throws Exception {
        try {
            List<UserFeedback> feedbacks = userFeedbackRepository.findAll();
            return convertToFeedbackDTOs(feedbacks);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting all feedback: " + e.getMessage(), e);
            throw new Exception("Failed to get all feedback: " + e.getMessage());
        }
    }
    
    @Override
    public List<UserFeedbackDTO> getRespondedFeedback() throws Exception {
        try {
            List<UserFeedback> allFeedbacks = userFeedbackRepository.findAll();
            List<UserFeedback> respondedFeedbacks = allFeedbacks.stream()
                    .filter(feedback -> feedback.getStaffReply() != null && !feedback.getStaffReply().isEmpty())
                    .collect(Collectors.toList());
            return convertToFeedbackDTOs(respondedFeedbacks);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting responded feedback: " + e.getMessage(), e);
            throw new Exception("Failed to get responded feedback: " + e.getMessage());
        }
    }
    
    @Override
    public List<UserFeedbackDTO> getFeedbackByRating(int rating) throws Exception {
        try {
            List<UserFeedback> allFeedbacks = userFeedbackRepository.findAll();
            List<UserFeedback> filteredFeedbacks = allFeedbacks.stream()
                    .filter(feedback -> feedback.getRating() == rating)
                    .collect(Collectors.toList());
            return convertToFeedbackDTOs(filteredFeedbacks);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting feedback by rating: " + e.getMessage(), e);
            throw new Exception("Failed to get feedback by rating: " + e.getMessage());
        }
    }
    
    @Override
    public boolean addBulkStaffReply(List<UUID> feedbackIds, String reply) throws Exception {
        try {
            boolean success = true;
            for (UUID feedbackId : feedbackIds) {
                try {
                    // Check if feedback exists
                    UserFeedback existingFeedback = userFeedbackRepository.findById(feedbackId);
                    if (existingFeedback == null) {
                        LOGGER.log(Level.WARNING, "Feedback not found with ID: " + feedbackId);
                        continue;
                    }
                    
                    boolean result = userFeedbackRepository.addStaffReply(feedbackId, reply);
                    if (!result) {
                        success = false;
                        LOGGER.log(Level.WARNING, "Failed to add staff reply to feedback ID: " + feedbackId);
                    }
                } catch (Exception e) {
                    success = false;
                    LOGGER.log(Level.WARNING, "Error adding staff reply to feedback ID: " + feedbackId + " - " + e.getMessage(), e);
                }
            }
            return success;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding bulk staff reply: " + e.getMessage(), e);
            throw new Exception("Failed to add bulk staff reply: " + e.getMessage());
        }
    }
    
    /**
     * Convert a UserFeedback entity to DTO
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
        dto.setStaffReply(feedback.getStaffReply());
        dto.setReplyDate(feedback.getReplyDate());
        
        // Lấy booking code từ booking repository
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
        
        // Lấy thông tin xe và brand
        if (feedback.getCarId() != null) {
            try {
                Car car = carRepository.findById(feedback.getCarId());
                if (car != null) {
                    dto.setCarModel(car.getCarModel());
                    
                    // Lấy thông tin brand từ brandId của xe
                    if (car.getBrandId() != null) {
                        CarBrand brand = carBrandRepository.findById(car.getBrandId());
                        if (brand != null) {
                            dto.setCarBrand(brand.getBrandName());
                        }
                    }
                }
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Could not retrieve car details for feedback: " + e.getMessage(), e);
            }
        }
        
        // Lấy thông tin người dùng
        if (feedback.getUserId() != null) {
            try {
                User user = userRepository.findById(feedback.getUserId());
                if (user != null) {
                    // Sử dụng normalizedUserName nếu fullName là null
                    String userName = user.getFullName();
                    if (userName == null || userName.trim().equals("null null")) {
                        userName = user.getNormalizedUserName();
                    }
                    dto.setUsername(userName);
                    dto.setUserAvatar(user.getAvatarUrl());
                }
            } catch (SQLException e) {
                LOGGER.log(Level.WARNING, "Could not retrieve user details for feedback: " + e.getMessage(), e);
            }
        }
        
        return dto;
    }
    
    /**
     * Convert a list of UserFeedback entities to DTOs
     * @param feedbacks List of UserFeedback entities
     * @return List of UserFeedbackDTO objects
     */
    private List<UserFeedbackDTO> convertToFeedbackDTOs(List<UserFeedback> feedbacks) throws Exception {
        List<UserFeedbackDTO> dtos = new ArrayList<>();
            if (feedbacks == null || feedbacks.isEmpty()) {
            return dtos;
        }
        
        for (UserFeedback feedback : feedbacks) {
            UserFeedbackDTO dto = new UserFeedbackDTO();
            dto.setFeedbackId(feedback.getFeedbackId());
            dto.setUserId(feedback.getUserId());
            dto.setCarId(feedback.getCarId());
            dto.setBookingId(feedback.getBookingId());
            dto.setRating(feedback.getRating());
            dto.setContent(feedback.getContent());
            dto.setReviewed(feedback.getReviewed());
            dto.setCreatedDate(feedback.getCreatedDate());
            dto.setStaffReply(feedback.getStaffReply());
            dto.setReplyDate(feedback.getReplyDate());
            
            // Get booking code if available
            if (feedback.getBookingId() != null) {
                try {
                    Booking booking = bookingRepository.findById(feedback.getBookingId());
                    if (booking != null && booking.getBookingCode() != null) {
                        dto.setBookingCode(booking.getBookingCode());
                    }
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Error getting booking code: " + e.getMessage());
                }
            }
            
            // Get car details
            try {
                Car car = carRepository.findById(feedback.getCarId());
                if (car != null) {
                    dto.setCarModel(car.getCarModel());
                    
                    // Get car brand
                    try {
                        CarBrand brand = carBrandRepository.findById(car.getBrandId());
                        if (brand != null) {
                            dto.setCarBrand(brand.getBrandName());
                        }
                    } catch (Exception e) {
                        LOGGER.log(Level.WARNING, "Error getting car brand: " + e.getMessage());
                    }
                }
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error getting car details: " + e.getMessage());
            }
            
            // Get user details
            try {
                User user = userRepository.findById(feedback.getUserId());
                if (user != null) {
                    // Sử dụng normalizedUserName nếu fullName là null
                    String userName = user.getFullName();
                    if (userName == null || userName.trim().equals("null null")) {
                        userName = user.getNormalizedUserName();
                    }
                    dto.setUsername(userName);
                    dto.setUserAvatar(user.getAvatarUrl());
                }
            } catch (Exception e) {
                LOGGER.log(Level.WARNING, "Error getting user details: " + e.getMessage());
            }
            
            dtos.add(dto);
        }
        
        return dtos;
}
}