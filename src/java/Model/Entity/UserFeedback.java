package Model.Entity;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Entity class for user feedback on cars
 */
public class UserFeedback {
    private UUID feedbackId;
    private UUID userId;
    private UUID carId;
    private UUID bookingId; // Reference to the booking that led to this feedback
    private int rating;
    private String content;
    private LocalDate reviewed;
    private LocalDateTime createdDate;
    
    public UserFeedback() {
    }
    
    public UserFeedback(UUID feedbackId, UUID userId, UUID carId, UUID bookingId, int rating, String content, 
            LocalDate reviewed, LocalDateTime createdDate) {
        this.feedbackId = feedbackId;
        this.userId = userId;
        this.carId = carId;
        this.bookingId = bookingId;
        this.rating = rating;
        this.content = content;
        this.reviewed = reviewed;
        this.createdDate = createdDate;
    }

    // Getters and setters
    public UUID getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(UUID feedbackId) {
        this.feedbackId = feedbackId;
    }

    public UUID getUserId() {
        return userId;
    }

    public void setUserId(UUID userId) {
        this.userId = userId;
    }

    public UUID getCarId() {
        return carId;
    }

    public void setCarId(UUID carId) {
        this.carId = carId;
    }
    
    public UUID getBookingId() {
        return bookingId;
    }

    public void setBookingId(UUID bookingId) {
        this.bookingId = bookingId;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public LocalDate getReviewed() {
        return reviewed;
    }

    public void setReviewed(LocalDate reviewed) {
        this.reviewed = reviewed;
    }

    public LocalDateTime getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(LocalDateTime createdDate) {
        this.createdDate = createdDate;
    }
} 