package Repository.Interfaces.IBooking;

import Model.Entity.Booking.BookingApproval;
import Repository.Interfaces.Repository;
import java.util.List;
import java.util.UUID;

public interface IBookingApprovalRepository extends Repository<BookingApproval, Integer> {
    
    List<BookingApproval> findByStatus(String status) throws Exception;

    BookingApproval findByBookingId(UUID bookingId) throws Exception;
}
