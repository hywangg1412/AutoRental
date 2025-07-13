package Service.Interfaces.IBooking;

import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Booking.BookingApproval;
import Service.Interfaces.Service;

public interface IBookingApprovalService extends Service<BookingApproval> {
    List<BookingApproval> findByStatus(String status) throws Exception;

    BookingApproval findByBookingId(UUID bookingId) throws Exception;
    
    /**
     * Xử lý việc phê duyệt booking bởi staff với tự động tạo bảo hiểm
     * @param bookingId ID của booking cần duyệt
     * @param staffId ID của staff đang duyệt  
     * @param approvalStatus "Approved" hoặc "Rejected"
     * @param note Ghi chú khi duyệt
     * @param rejectionReason Lý do từ chối (chỉ cần khi reject)
     * @return BookingApproval object đã tạo
     */
    BookingApproval processApproval(UUID bookingId, UUID staffId, String approvalStatus, 
                                  String note, String rejectionReason) 
                                  throws SQLException, NotFoundException, InvalidDataException;
}
