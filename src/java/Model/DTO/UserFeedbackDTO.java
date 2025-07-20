package Model.DTO;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

/**
 * Data Transfer Object for User Feedback
 */
public class UserFeedbackDTO {
    private UUID feedbackId;
    private UUID userId;
    private UUID carId;
    private UUID bookingId;
    private String bookingCode; // Thêm trường bookingCode
    private String username;
    private String userAvatar;
    private int rating;
    private String content;
    private LocalDate reviewed;
    private LocalDateTime createdDate;

    // Additional fields for display
    private String carModel;
    private String carBrand;

    public UserFeedbackDTO() {
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
    
    public String getBookingCode() {
        return bookingCode;
    }

    public void setBookingCode(String bookingCode) {
        this.bookingCode = bookingCode;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getUserAvatar() {
        return userAvatar;
    }

    public void setUserAvatar(String userAvatar) {
        this.userAvatar = userAvatar;
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

    public String getCarModel() {
        return carModel;
    }

    public void setCarModel(String carModel) {
        this.carModel = carModel;
    }

    public String getCarBrand() {
        return carBrand;
    }

    public void setCarBrand(String carBrand) {
        this.carBrand = carBrand;
    }
    
    /**
     * Get the formatted created date
     * @return The formatted date string
     */
    public String getFormattedCreatedDate() {
        if (createdDate == null) {
            return "";
        }
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
        return createdDate.format(formatter);
    }

    /**
     * Get HTML representation of rating stars
     * @return HTML string with star icons
     */
    public String getRatingStarsHtml() {
        StringBuilder stars = new StringBuilder();
        // Add filled stars
        for (int i = 0; i < rating; i++) {
            stars.append("<i class=\"fas fa-star text-warning\"></i>");
        }
        // Add empty stars
        for (int i = rating; i < 5; i++) {
            stars.append("<i class=\"far fa-star text-muted\"></i>");
        }
        return stars.toString();
    }

    /**
     * Get a shortened version of the booking ID for display
     * @return The shortened booking ID string
     */
    public String getShortBookingId() {
        if (bookingId == null) {
            return "N/A";
        }
        String fullId = bookingId.toString();
        // Lấy 8 ký tự đầu tiên của UUID
        return fullId.substring(0, 8) + "...";
    }
} 