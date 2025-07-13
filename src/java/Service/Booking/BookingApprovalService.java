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
import Model.Entity.Booking.BookingInsurance;
import Model.Entity.Deposit.Insurance;
import Repository.Booking.BookingApprovalRepository;
import Repository.Booking.BookingInsuranceRepository;
import Repository.Booking.BookingRepository;
import Repository.Deposit.InsuranceRepository;
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
    
    private final BookingApprovalRepository bookingApprovalRepository;
    private final BookingRepository bookingRepository;
    private final BookingInsuranceRepository bookingInsuranceRepository;
    private final InsuranceRepository insuranceRepository;

    public BookingApprovalService() {
        this.bookingApprovalRepository = new BookingApprovalRepository();
        this.bookingRepository = new BookingRepository();
        this.bookingInsuranceRepository = new BookingInsuranceRepository();
        this.insuranceRepository = new InsuranceRepository();
    }

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

            // *** MỚI THÊM: Tự động tạo bảo hiểm khi duyệt thành Confirmed ***
            if ("Approved".equals(approvalStatus)) {
                try {
                    createDefaultInsuranceForBooking(booking);
                    LOGGER.log(Level.INFO, "Đã tạo bảo hiểm mặc định cho booking {0}", bookingId);
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Lỗi khi tạo bảo hiểm cho booking " + bookingId + ": " + e.getMessage(), e);
                    // Không throw exception để không ảnh hưởng đến quá trình duyệt
                }
            }

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
    public BookingApproval processApproval(UUID bookingId, UUID staffId, String approvalStatus, 
                                         String note, String rejectionReason) 
                                         throws SQLException, NotFoundException, InvalidDataException {
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

            // *** TỰ ĐỘNG TẠO BẢO HIỂM KHI DUYỆT THÀNH CONFIRMED ***
            if ("Approved".equals(approvalStatus)) {
                try {
                    createDefaultInsuranceForBooking(booking);
                    LOGGER.log(Level.INFO, "Đã tạo bảo hiểm mặc định cho booking {0}", bookingId);
                } catch (Exception e) {
                    LOGGER.log(Level.WARNING, "Lỗi khi tạo bảo hiểm cho booking " + bookingId + ": " + e.getMessage(), e);
                    // Không throw exception để không ảnh hưởng đến quá trình duyệt
                }
            }

            LOGGER.log(Level.INFO, "Staff {0} đã {1} booking {2}", 
                new Object[]{staffId, approvalStatus, bookingId});

            return savedApproval;

        } catch (NotFoundException | InvalidDataException e) {
            LOGGER.log(Level.WARNING, "Lỗi xử lý duyệt booking: " + e.getMessage(), e);
            throw e;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi database khi xử lý duyệt booking " + bookingId, e);
            throw e;
        }
    }

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

    /**
     * TỰ ĐỘNG TẠO ĐỦ 3 LOẠI BẢO HIỂM CHO BOOKING MỚI ĐƯỢC DUYỆT
     * - TNDS: Theo số chỗ xe
     * - Vật chất: 0 (sẽ được DepositService tính toán)  
     * - Tai nạn: Fixed rate
     */
    private void createDefaultInsuranceForBooking(Booking booking) throws SQLException {
        try {
            LOGGER.info("=== TẠO BẢO HIỂM MẶC ĐỊNH CHO BOOKING " + booking.getBookingId() + " ===");

            // Tính số ngày thuê để tính phí
            double rentalDays = calculateRentalDays(booking);
            LOGGER.info("Số ngày thuê: " + rentalDays);

            // Lấy thông tin xe để xác định số chỗ
            int carSeats = getCarSeats(booking.getCarId());
            LOGGER.info("Số chỗ xe: " + carSeats);

            // Lấy tất cả loại bảo hiểm có sẵn
            List<Insurance> availableInsurances = insuranceRepository.findAll();
            LOGGER.info("Tìm thấy " + availableInsurances.size() + " loại bảo hiểm");

            int insuranceCount = 0;

            for (Insurance insurance : availableInsurances) {
                if (!insurance.isActive()) continue;

                BookingInsurance bookingInsurance = new BookingInsurance();
                bookingInsurance.setBookingInsuranceId(UUID.randomUUID());
                bookingInsurance.setBookingId(booking.getBookingId());
                bookingInsurance.setInsuranceId(insurance.getInsuranceId());
                bookingInsurance.setRentalDays(rentalDays);
                bookingInsurance.setCarSeats(carSeats);
                bookingInsurance.setEstimatedCarValue(booking.getTotalAmount() * 1000); // Ước tính giá xe
                bookingInsurance.setCreatedAt(LocalDateTime.now());

                // Tính phí theo loại bảo hiểm
                double premiumAmount = calculateInsurancePremium(insurance, carSeats, booking.getTotalAmount(), rentalDays);
                bookingInsurance.setPremiumAmount(premiumAmount);

                // Lưu vào database
                BookingInsurance saved = bookingInsuranceRepository.add(bookingInsurance);
                if (saved != null) {
                    insuranceCount++;
                    LOGGER.info("Đã tạo bảo hiểm: " + insurance.getInsuranceName() + 
                               " = " + premiumAmount + " (DB value)");
                }
            }

            LOGGER.info("=== ĐÃ TẠO " + insuranceCount + " LOẠI BẢO HIỂM CHO BOOKING ===");

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi tạo bảo hiểm cho booking " + booking.getBookingId(), e);
            throw e;
        }
    }

    /**
     * Tính phí bảo hiểm theo loại
     */
    private double calculateInsurancePremium(Insurance insurance, int carSeats, double bookingTotal, double rentalDays) {
        try {
            switch (insurance.getInsuranceType()) {
                case "TNDS":
                    // TNDS: Dựa theo số chỗ xe và số ngày
                    if (carSeats <= 5) {
                        return 10.0; // 10 VND/ngày cho xe ≤ 5 chỗ (DB value)
                    } else if (carSeats <= 11) {
                        return 15.0; // 15 VND/ngày cho xe 6-11 chỗ
                    } else {
                        return 20.0; // 20 VND/ngày cho xe 12+ chỗ
                    }

                case "TaiNan":
                    // Tai nạn: Fixed rate
                    return 5.0; // 5 VND/ngày (DB value)

                case "VatChat":
                    // Vật chất: Để 0, DepositService sẽ tính toán
                    return 0.0;

                default:
                    LOGGER.warning("Loại bảo hiểm không xác định: " + insurance.getInsuranceType());
                    return 0.0;
            }
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Lỗi tính phí bảo hiểm cho " + insurance.getInsuranceName(), e);
            return 0.0;
        }
    }

    /**
     * Tính số ngày thuê
     */
    private double calculateRentalDays(Booking booking) {
        try {
            if (booking.getPickupDateTime() == null || booking.getReturnDateTime() == null) {
                return 1.0; // Default 1 ngày
            }

            java.time.Duration duration = java.time.Duration.between(
                booking.getPickupDateTime(), 
                booking.getReturnDateTime()
            );

            double totalHours = duration.toMinutes() / 60.0;
            double days = totalHours / 24.0;

            // Tối thiểu 0.5 ngày
            return Math.max(days, 0.5);

        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Lỗi tính số ngày thuê", e);
            return 1.0;
        }
    }

    /**
     * Lấy số chỗ xe từ database
     */
    private int getCarSeats(UUID carId) {
        try {
            // Đơn giản hóa: Trả về 5 chỗ mặc định
            // Có thể mở rộng sau để query từ bảng Car
            return 5;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Lỗi lấy thông tin xe", e);
            return 5; // Default 5 chỗ
        }
    }
}
