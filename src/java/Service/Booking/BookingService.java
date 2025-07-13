package Service.Booking;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.SQLException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Constants.BookingStatusConstants;
import Model.DTO.DurationResult;
import Model.Entity.Booking.Booking;
import Repository.Booking.BookingRepository;
import Service.Interfaces.IBooking.IBookingService;

public class BookingService implements IBookingService {
    private static final Logger LOGGER = Logger.getLogger(BookingService.class.getName());
    private final BookingRepository bookingRepository;
    
    private static final String[] VALID_STATUSES = {
        BookingStatusConstants.PENDING,
        BookingStatusConstants.CONFIRMED,
        BookingStatusConstants.CANCELLED,
        BookingStatusConstants.COMPLETED,
        BookingStatusConstants.AWAITING_PAYMENT,
        BookingStatusConstants.DEPOSIT_PAID,
        BookingStatusConstants.CONTRACT_SIGNED,
        BookingStatusConstants.FULLY_PAID,
        BookingStatusConstants.IN_PROGRESS,
        BookingStatusConstants.REJECTED
    };
    private static final String DEFAULT_STATUS = BookingStatusConstants.PENDING;
    
    // ==========  HẰNG SỐ TÍNH TOÁN ==========
    private static final double MIN_HOURLY_DURATION = 4.0; // Tối thiểu 4 giờ thuê (theo quy định công ty)
    private static final double MIN_DAILY_DURATION = 0.5;  // Tối thiểu 0.5 ngày thuê (12 tiếng)
    private static final double MIN_MONTHLY_DURATION = 0.5; // Tối thiểu 0.5 tháng thuê (15 ngày)
    private static final int DAYS_PER_MONTH = 30; // Quy ước 1 tháng = 30 ngày

    public BookingService() {
        this.bookingRepository = new BookingRepository();
    }

    // ========== CRUD METHODS - CÁC PHƯƠNG THỨC CƠ BẢN ==========
    
    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            List<Booking> bookings = bookingRepository.findAll();
            if (bookings.isEmpty()) {
                throw new EmptyDataException("Không tìm thấy booking nào.");
            }
            bookings.forEach(booking -> LOGGER.info(booking.toString()));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi hiển thị danh sách bookings", e);
            throw new EventException("Lỗi hiển thị bookings: " + e.getMessage());
        }
    }

    @Override
    public Booking add(Booking entry) throws EventException, InvalidDataException {
        try {
            validateBooking(entry);
            prepareNewBooking(entry);
            return bookingRepository.add(entry);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi thêm booking", e);
            throw new EventException("Lỗi thêm booking: " + e.getMessage());
        }
    }

    @Override
    public boolean update(Booking entry) throws EventException, NotFoundException {
        try {
            validateBookingExists(entry.getBookingId());
            validateBooking(entry);
            return bookingRepository.update(entry);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi cập nhật booking", e);
            throw new EventException("Lỗi cập nhật booking: " + e.getMessage());
        } catch (InvalidDataException e) {
            LOGGER.log(Level.SEVERE, "Dữ liệu booking không hợp lệ", e);
            throw new EventException("Dữ liệu booking không hợp lệ: " + e.getMessage());
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            validateBookingExists(id);
            return bookingRepository.delete(id);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi xóa booking", e);
            throw new EventException("Lỗi xóa booking: " + e.getMessage());
        }
    }

    @Override
    public Booking findById(UUID id) throws NotFoundException {
        if (id == null) {
            throw new NotFoundException("ID booking không được null");
        }
        
        try {
            Booking booking = bookingRepository.findById(id);
            if (booking == null) {
                throw new NotFoundException("Không tìm thấy booking với ID: " + id);
            }
            return booking;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi tìm booking với ID: " + id, e);
            throw new RuntimeException("Lỗi tìm booking: " + e.getMessage(), e);
        }
    }

    // ========== QUERY METHODS - CÁC PHƯƠNG THỨC TRUỲ VẤN ==========
    
    @Override
    public List<Booking> findByStatus(String status) throws SQLException {
        return bookingRepository.findByStatus(status);
    }

    public List<Booking> findByUserId(UUID userId) throws SQLException {
        return bookingRepository.findByUserId(userId);
    }

    @Override
    public List<Booking> findAll() {
        try {
            return bookingRepository.findAll();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Lỗi lấy danh sách booking", ex);
            return null;
        }
    }

    @Override
    public int countAllBookings() {
        try {
            return bookingRepository.findAll().size();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi đếm tổng bookings", e);
            return 0;
        }
    }

    @Override
    public int countBookingsByStatus(String status) {
        try {
            return bookingRepository.findByStatus(status).size();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi đếm bookings theo status: " + status, e);
            return 0;
        }
    }

    // ========== CÁC PHƯƠNG THỨC TÍNH TOÁN ==========
    
    /**
     * Tính tổng số tiền thuê xe dựa trên thời gian và loại thuê
     * Logic tương thích với JavaScript frontend (booking-form-detail.js)
     * 
     * @param start Thời gian bắt đầu thuê
     * @param end Thời gian kết thúc thuê
     * @param rentalType Loại thuê: "hourly", "daily", "monthly"
     * @param hourlyPrice Giá theo giờ (BigDecimal)
     * @param dailyPrice Giá theo ngày (BigDecimal)
     * @param monthlyPrice Giá theo tháng (BigDecimal)
     * @return Tổng tiền dạng double (đã làm tròn như Math.round trong JS)
     */
    public double calculateTotalAmount(LocalDateTime start, LocalDateTime end, String rentalType,
            BigDecimal hourlyPrice, BigDecimal dailyPrice, BigDecimal monthlyPrice) {

        // Tính duration theo quy tắc tối thiểu
        DurationResult durationResult = calculateDuration(start, end, rentalType);
        BigDecimal unitPrice;

        // Chọn đơn giá theo loại thuê
        switch (rentalType.toLowerCase()) {
            case "hourly":
                unitPrice = hourlyPrice;
                break;
            case "daily":
                unitPrice = dailyPrice;
                break;
            case "monthly":
                unitPrice = monthlyPrice;
                break;
            default:
                throw new IllegalArgumentException("Loại thuê không hợp lệ: " + rentalType);
        }

        // Tính tổng tiền: duration * unitPrice, làm tròn như JavaScript
        BigDecimal totalAmount = unitPrice.multiply(durationResult.getBillingUnits())
                .setScale(0, RoundingMode.HALF_UP);

        return totalAmount.doubleValue(); // Trả về double để lưu vào database
    }

    /**
     * Tính thời gian thuê theo loại thuê với quy tắc tối thiểu
     * Đảm bảo logic tương thích 100% với JavaScript frontend
     *
     * @param start Thời gian bắt đầu thuê
     * @param end Thời gian kết thúc thuê  
     * @param rentalType Loại thuê: "hourly", "daily", "monthly"
     * @return DurationResult chứa thông tin thời gian đã áp dụng quy tắc tối thiểu
     */
    public DurationResult calculateDuration(LocalDateTime start, LocalDateTime end, String rentalType) {
        if (start == null || end == null) {
            throw new IllegalArgumentException("Thời gian bắt đầu và kết thúc không được null");
        }

        if (end.isBefore(start)) {
            throw new IllegalArgumentException("Thời gian kết thúc phải sau thời gian bắt đầu");
        }

        Duration duration = Duration.between(start, end);

        switch (rentalType.toLowerCase()) {
            case "hourly":
                return calculateHourlyDuration(duration);
            case "daily":
                return calculateDailyDuration(duration);
            case "monthly":
                return calculateMonthlyDuration(duration);
            default:
                throw new IllegalArgumentException("Loại thuê không hợp lệ: " + rentalType);
        }
    }

    // ========== CÁC PHƯƠNG THỨC HELPER TÍNH TOÁN ==========
    
    /**
     * Tính duration theo giờ - ĐỒNG BỘ VỚI JAVASCRIPT
     * JS logic: Math.ceil(hours), tối thiểu 4 giờ
     */
    private DurationResult calculateHourlyDuration(Duration duration) {
        double actualHours = duration.toMinutes() / 60.0;
        // Làm tròn lên như JavaScript Math.ceil
        double ceilHours = Math.ceil(actualHours);
        // Áp dụng quy tắc tối thiểu 4 giờ
        double billingHours = Math.max(ceilHours, MIN_HOURLY_DURATION);

        return new DurationResult(
                BigDecimal.valueOf(billingHours).setScale(2, RoundingMode.HALF_UP),
                "hour",
                actualHours < MIN_HOURLY_DURATION ? "Tối thiểu 4 giờ được áp dụng" : null
        );
    }

    /**
     * Tính duration theo ngày - ĐỒNG BỘ VỚI JAVASCRIPT  
     * JS logic: totalHours/24, tối thiểu 0.5 ngày, làm tròn 2 chữ số
     */
    private DurationResult calculateDailyDuration(Duration duration) {
        double totalHours = duration.toMinutes() / 60.0;
        double actualDays = totalHours / 24.0;
        // Áp dụng quy tắc tối thiểu 0.5 ngày
        double billingDays = Math.max(actualDays, MIN_DAILY_DURATION);
        // Làm tròn 2 chữ số như JavaScript Math.round(x * 100) / 100
        billingDays = Math.round(billingDays * 100.0) / 100.0;

        return new DurationResult(
                BigDecimal.valueOf(billingDays).setScale(2, RoundingMode.HALF_UP),
                "day",
                actualDays < MIN_DAILY_DURATION ? "Tối thiểu 0.5 ngày được áp dụng" : null
        );
    }

    /**
     * Tính duration theo tháng - ĐỒNG BỘ VỚI JAVASCRIPT
     * JS logic: days/30, tối thiểu 0.5 tháng, làm tròn 2 chữ số
     */
    private DurationResult calculateMonthlyDuration(Duration duration) {
        double totalDays = duration.toHours() / 24.0;
        double actualMonths = totalDays / DAYS_PER_MONTH;
        // Áp dụng quy tắc tối thiểu 0.5 tháng
        double billingMonths = Math.max(actualMonths, MIN_MONTHLY_DURATION);
        // Làm tròn 2 chữ số như JavaScript Math.round(x * 100) / 100
        billingMonths = Math.round(billingMonths * 100.0) / 100.0;

        return new DurationResult(
                BigDecimal.valueOf(billingMonths).setScale(2, RoundingMode.HALF_UP),
                "month",
                actualMonths < MIN_MONTHLY_DURATION ? "Tối thiểu 0.5 tháng được áp dụng" : null
        );
    }

    // ========== VALIDATION METHODS - CÁC PHƯƠNG THỨC KIỂM TRA ==========

    private void validateBooking(Booking booking) throws InvalidDataException {
        if (booking == null) {
            throw new InvalidDataException("Booking không được null");
        }
        
        // Kiểm tra các trường bắt buộc
        if (booking.getUserId() == null) {
            throw new InvalidDataException("User ID là bắt buộc");
        }
        if (booking.getCarId() == null) {
            throw new InvalidDataException("Car ID là bắt buộc");
        }
        
        // Kiểm tra thời gian
        if (booking.getPickupDateTime() == null) {
            throw new InvalidDataException("Thời gian nhận xe là bắt buộc");
        }
        if (booking.getReturnDateTime() == null) {
            throw new InvalidDataException("Thời gian trả xe là bắt buộc");
        }
        if (booking.getPickupDateTime().isAfter(booking.getReturnDateTime())) {
            throw new InvalidDataException("Thời gian nhận xe phải trước thời gian trả xe");
        }
        if (booking.getPickupDateTime().isBefore(LocalDateTime.now())) {
            throw new InvalidDataException("Thời gian nhận xe không thể ở quá khứ");
        }
        
        // Kiểm tra số tiền
        if (booking.getTotalAmount() < 0) {
            throw new InvalidDataException("Tổng tiền không thể âm");
        }
        
        // Kiểm tra status
        if (booking.getStatus() != null && !isValidStatus(booking.getStatus())) {
            throw new InvalidDataException("Status booking không hợp lệ. Phải là một trong: " + String.join(", ", VALID_STATUSES));
        }
    }

    private boolean isValidStatus(String status) {
        for (String validStatus : VALID_STATUSES) {
            if (validStatus.equals(status)) {
                return true;
            }
        }
        return false;
    }

    private void validateBookingExists(UUID id) throws NotFoundException, SQLException {
        if (bookingRepository.findById(id) == null) {
            throw new NotFoundException("Không tìm thấy booking với ID: " + id);
        }
    }

    // ========== PREPARATION METHOD - PHƯƠNG THỨC CHUẨN BỊ ==========
    
    private void prepareNewBooking(Booking booking) {
        LOGGER.info("Chuẩn bị booking mới với ID: " + booking.getBookingId());
        
        // Set thời gian tạo và status mặc định
        booking.setCreatedDate(LocalDateTime.now());
        if (booking.getStatus() == null || booking.getStatus().isEmpty()) {
            booking.setStatus(DEFAULT_STATUS);
        }
        
        // Tự động tạo booking code nếu chưa có
        if (booking.getBookingCode() == null || booking.getBookingCode().trim().isEmpty()) {
            String generatedCode = BookingRepository.generateBookingCode();
            booking.setBookingCode(generatedCode);
            LOGGER.info("Đã tạo booking code: " + generatedCode);
        }
        
        LOGGER.info("Thông tin khách hàng - Tên: " + booking.getCustomerName() + 
                   ", SĐT: " + booking.getCustomerPhone() + 
                   ", Email: " + booking.getCustomerEmail());
    }
}
