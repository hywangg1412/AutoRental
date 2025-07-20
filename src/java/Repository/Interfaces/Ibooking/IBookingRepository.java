package Repository.Interfaces.IBooking;

import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

import Model.Entity.Booking.Booking;
import Repository.Interfaces.Repository;

public interface IBookingRepository extends Repository<Booking, UUID> {
    List<Booking> findByUserId(UUID userId) throws SQLException;
    void updateBookingStatus(UUID bookingId, String status) throws SQLException;
    List<Booking> findByStatus(String status) throws SQLException;
}
