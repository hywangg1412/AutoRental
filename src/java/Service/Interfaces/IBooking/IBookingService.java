package Service.Interfaces.IBooking;

import java.sql.SQLException;
import java.util.List;

import Model.Entity.Booking.Booking;
import Service.Interfaces.Service;

public interface IBookingService extends Service<Booking> {
    List<Booking> findByStatus(String status) throws SQLException;
    int countAllBookings();
    int countBookingsByStatus(String status);
    List<Booking> findAll();
}
