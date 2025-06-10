package Repository.Interfaces.IBooking;

import Model.Entity.Booking.Booking;
import Repository.Interfaces.Repository;
import java.util.List;
import java.sql.SQLException;

public interface IBookingRepository extends Repository<Booking, Integer>{
    List<Booking> findByStatus(String status) throws SQLException;
}
