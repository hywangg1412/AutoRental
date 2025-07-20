package Repository.Interfaces.Ibooking;

import Model.Entity.Booking.Booking;
import Repository.Interfaces.Repository;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public interface IBookingRepository extends Repository<Booking, UUID> {
    List<Booking> findByUserId(UUID userId) throws SQLException;
    void updateBookingStatus(UUID bookingId, String status) throws SQLException;
    List<Booking> findByStatus(String status) throws SQLException;
    
    /**
     * Check if a user has a completed booking for a car without a review
     * @param userId The user ID
     * @param carId The car ID
     * @return true if there is a completed booking without review, false otherwise
     * @throws SQLException If a database error occurs
     */
    boolean hasCompletedBookingWithoutReview(UUID userId, UUID carId) throws SQLException;
    
    /**
     * Find a completed booking without a review for a user and car
     * @param userId The user ID
     * @param carId The car ID
     * @return The booking ID or null if none exists
     * @throws SQLException If a database error occurs
     */
    UUID findCompletedBookingWithoutReview(UUID userId, UUID carId) throws SQLException;
}
