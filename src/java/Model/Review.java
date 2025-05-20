package Model;

import Model.Car;
import java.time.LocalDateTime;
import java.util.Date;


public class Review {
    private int reviewId;
    private String reviewContent;
    private int rating;
    private LocalDateTime reviewDate;
    private Car car;

    public Review() {
    }

    public int getReviewId() {
        return reviewId;
    }

    public void setReviewId(int reviewId) {
        this.reviewId = reviewId;
    }

    public String getReviewContent() {
        return reviewContent;
    }

    public void setReviewContent(String reviewContent) {
        this.reviewContent = reviewContent;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public LocalDateTime getReviewDate() {
        return reviewDate;
    }

    public void setReviewDate(LocalDateTime reviewDate) {
        this.reviewDate = reviewDate;
    }

    public Car getCar() {
        return car;
    }

    public void setCar(Car car) {
        this.car = car;
    }

    @Override
    public String toString() {
        return "Review{" + "reviewId=" + reviewId + ", reviewContent=" + reviewContent + ", rating=" + rating + ", reviewDate=" + reviewDate + ", car=" + car + '}';
    }
    
}
