package Service.Interfaces.IBooking;
import Model.Entity.Booking.Booking;
import Service.Interfaces.Service;
import java.sql.SQLException;
import java.util.List;

public interface IBookingService extends Service<Booking> {
    List<Booking> findByStatus(String status) throws SQLException;
}
