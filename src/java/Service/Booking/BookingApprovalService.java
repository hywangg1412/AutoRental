package Service.Booking;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Booking.Booking;
import Model.Entity.Booking.BookingApproval;
import Repository.Booking.BookingApprovalRepository;
import Repository.Booking.BookingRepository;
import Service.Interfaces.IBooking.IBookingApprovalService;

/**
 * Service xử lý logic duyệt booking (approve/reject)
 * Chịu trách nhiệm:
 * 1. Staff duyệt booking (approve/reject)
 * 2. Lưu lịch sử duyệt vào bảng BookingApproval
 * 3. Cập nhật trạng thái booking
 */
public class BookingApprovalService implements IBookingApprovalService {
    
    private static final Logger LOGGER = Logger.getLogger(BookingApprovalService.class.getName());
    private final BookingApprovalRepository bookingApprovalRepository = new BookingApprovalRepository();
    private final BookingRepository bookingRepository = new BookingRepository();

    /**
     * Staff duyệt booking (approve hoặc reject)
     * @param bookingId ID của booking cần duyệt
     * @param staffId ID của staff đang duyệt
     * @param approvalStatus "Approved" hoặc "Rejected"
     * @param note Ghi chú khi duyệt (có thể null)
     * @param rejectionReason Lý do từ chối (chỉ cần khi reject, có thể null)
     * @return BookingApproval object đã tạo
     */
    public BookingApproval approveBooking(UUID bookingId, UUID staffId, String approvalStatus, 
                                        String note, String rejectionReason) throws EventException {
        try {
            // 1. Kiểm tra booking có tồn tại không
            Booking booking = bookingRepository.findById(bookingId);
            if (booking == null) {
                throw new NotFoundException("Không tìm thấy booking với ID: " + bookingId);
            }

            // 2. Kiểm tra booking có đang ở trạng thái Pending không
            if (!"Pending".equals(booking.getStatus())) {
                throw new InvalidDataException("Booking đã được xử lý, không thể duyệt lại. Trạng thái hiện tại: " + booking.getStatus());
            }

            // 3. Tạo record lịch sử duyệt
            BookingApproval approval = new BookingApproval();
            approval.setApprovalId(UUID.randomUUID());
            approval.setBookingId(bookingId);
            approval.setStaffId(staffId);
            approval.setApprovalStatus(approvalStatus);
            approval.setApprovalDate(LocalDateTime.now());
            approval.setNote(note);
            approval.setRejectionReason(rejectionReason);

            // 4. Lưu vào bảng BookingApproval
            BookingApproval savedApproval = bookingApprovalRepository.add(approval);

            // 5. Cập nhật trạng thái booking
            String newBookingStatus = "Approved".equals(approvalStatus) ? "Confirmed" : "Rejected";
            booking.setStatus(newBookingStatus);
            booking.setHandledBy(staffId);
            
            // Nếu reject, lưu lý do vào CancelReason
            if ("Rejected".equals(approvalStatus) && rejectionReason != null) {
                booking.setCancelReason("Staff rejected: " + rejectionReason);
            }
            
            bookingRepository.update(booking);

            LOGGER.log(Level.INFO, "Staff {0} đã {1} booking {2}", 
                new Object[]{staffId, approvalStatus, bookingId});

            return savedApproval;

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi database khi duyệt booking", e);
            throw new EventException("Lỗi database khi duyệt booking: " + e.getMessage());
        } catch (NotFoundException | InvalidDataException e) {
            LOGGER.log(Level.WARNING, "Lỗi validation khi duyệt booking", e);
            throw new EventException(e.getMessage());
        }
    }

    /**
     * Lấy lịch sử duyệt của một booking
     * @param bookingId ID của booking
     * @return BookingApproval object hoặc null nếu chưa có
     */
    public BookingApproval getApprovalByBookingId(UUID bookingId) throws EventException, Exception {
        try {
            return bookingApprovalRepository.findByBookingId(bookingId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy lịch sử duyệt booking", e);
            throw new EventException("Lỗi khi lấy lịch sử duyệt booking: " + e.getMessage());
        }
    }

    /**
     * Lấy tất cả lịch sử duyệt theo trạng thái
     * @param status "Approved" hoặc "Rejected"
     * @return List các BookingApproval
     */
    public List<BookingApproval> getApprovalsByStatus(String status) throws EventException, Exception {
        try {
            return bookingApprovalRepository.findByStatus(status);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy danh sách duyệt theo trạng thái", e);
            throw new EventException("Lỗi khi lấy danh sách duyệt theo trạng thái: " + e.getMessage());
        }
    }

    // ========== CÁC METHOD CRUD CƠ BẢN (GIỮ LẠI ĐỂ TƯƠNG THÍCH) ==========

    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            List<BookingApproval> approvals = bookingApprovalRepository.findAll();
            if (approvals.isEmpty()) {
                throw new EmptyDataException("Không có lịch sử duyệt booking nào.");
            }
            approvals.forEach(approval -> LOGGER.info(approval.toString()));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi hiển thị lịch sử duyệt", e);
            throw new EventException("Lỗi khi hiển thị lịch sử duyệt: " + e.getMessage());
        }
    }

    @Override
    public BookingApproval add(BookingApproval entry) throws EventException, InvalidDataException {
        validateBookingApproval(entry);
        try {
            return bookingApprovalRepository.add(entry);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi thêm lịch sử duyệt", e);
            throw new EventException("Lỗi khi thêm lịch sử duyệt: " + e.getMessage());
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            BookingApproval approval = bookingApprovalRepository.findById(id);
            if (approval == null) {
                throw new NotFoundException("Không tìm thấy lịch sử duyệt với ID: " + id);
            }
            return bookingApprovalRepository.delete(id);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi xóa lịch sử duyệt", e);
            throw new EventException("Lỗi khi xóa lịch sử duyệt: " + e.getMessage());
        }
    }

    @Override
    public boolean update(BookingApproval entry) throws EventException, NotFoundException {
        try {
            validateBookingApproval(entry);
            BookingApproval approval = bookingApprovalRepository.findById(entry.getApprovalId());
            if (approval == null) {
                throw new NotFoundException("Không tìm thấy lịch sử duyệt với ID: " + entry.getApprovalId());
            }
            return bookingApprovalRepository.update(entry);
        } catch (InvalidDataException e) {
            LOGGER.log(Level.SEVERE, "Dữ liệu lịch sử duyệt không hợp lệ", e);
            throw new EventException("Dữ liệu lịch sử duyệt không hợp lệ: " + e.getMessage());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật lịch sử duyệt", e);
            throw new EventException("Lỗi khi cập nhật lịch sử duyệt: " + e.getMessage());
        }
    }

    @Override
    public BookingApproval findById(UUID id) throws NotFoundException {
        try {
            BookingApproval approval = bookingApprovalRepository.findById(id);
            if (approval == null) {
                throw new NotFoundException("Không tìm thấy lịch sử duyệt với ID: " + id);
            }
            return approval;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi tìm lịch sử duyệt", e);
            throw new NotFoundException("Lỗi khi tìm lịch sử duyệt: " + e.getMessage());
        }
    }

    @Override
    public List<BookingApproval> findByStatus(String status) throws EventException, Exception {
        return getApprovalsByStatus(status);
    }

    @Override
    public BookingApproval findByBookingId(UUID bookingId) throws EventException, Exception {
        return getApprovalByBookingId(bookingId);
    }

    /**
     * Validate dữ liệu BookingApproval
     */
    private void validateBookingApproval(BookingApproval approval) throws InvalidDataException {
        if (approval == null) {
            throw new InvalidDataException("BookingApproval không được null");
        }
        if (approval.getBookingId() == null) {
            throw new InvalidDataException("BookingId là bắt buộc");
        }
        if (approval.getStaffId() == null) {
            throw new InvalidDataException("StaffId là bắt buộc");
        }
        if (approval.getApprovalStatus() == null || approval.getApprovalStatus().isEmpty()) {
            throw new InvalidDataException("ApprovalStatus là bắt buộc");
        }
        if (!"Approved".equals(approval.getApprovalStatus()) && !"Rejected".equals(approval.getApprovalStatus())) {
            throw new InvalidDataException("ApprovalStatus phải là 'Approved' hoặc 'Rejected'");
        }
    }
}
