package Repository.Interfaces.Ibooking;

import Model.Entity.Booking.BookingSurcharges;

import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public interface IBookingSurchargesRepository {
    BookingSurcharges add(BookingSurcharges surcharge) throws SQLException;
    List<BookingSurcharges> findByBookingId(UUID bookingId) throws SQLException;
    double getTotalSurchargesByBookingId(UUID bookingId) throws SQLException;
    boolean deleteByBookingId(UUID bookingId) throws SQLException;
    boolean deleteBySurchargeId(UUID surchargeId) throws SQLException;
} 