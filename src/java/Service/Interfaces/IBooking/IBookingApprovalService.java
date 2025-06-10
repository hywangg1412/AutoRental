package Service.Interfaces.IBooking;

import Model.Entity.Booking.BookingApproval;
import Service.Interfaces.Service;
import java.util.List;
import java.util.UUID;

public interface IBookingApprovalService extends Service<BookingApproval> {
    List<BookingApproval> findByStatus(String status) throws Exception;

    BookingApproval findByBookingId(UUID bookingId) throws Exception;
}
