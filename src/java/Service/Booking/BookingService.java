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
import Model.Entity.Booking.BookingInsurance;
import Repository.Booking.BookingRepository;
import Service.Interfaces.IBooking.IBookingService;
import Service.Booking.BookingInsuranceService;
import Model.Entity.Deposit.Insurance;
import Repository.Deposit.InsuranceRepository;
import Repository.Booking.BookingInsuranceRepository;
import Model.Entity.Car.Car;
import Repository.Car.CarRepository;

public class BookingService implements IBookingService {
    private static final Logger LOGGER = Logger.getLogger(BookingService.class.getName());
    private final BookingRepository bookingRepository;
    private final BookingInsuranceService bookingInsuranceService;
    private final BookingInsuranceRepository bookingInsuranceRepository;
    private final InsuranceRepository insuranceRepository;
    
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
    // Không còn cần quy tắc tối thiểu cho daily và monthly vì đã có tự động chuyển đổi loại thuê
    private static final int DAYS_PER_MONTH = 30; // Quy ước 1 tháng = 30 ngày

    public BookingService() {
        this.bookingRepository = new BookingRepository();
        this.bookingInsuranceService = new BookingInsuranceService();
        this.bookingInsuranceRepository = new BookingInsuranceRepository();
        this.insuranceRepository = new InsuranceRepository();
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
        return add(entry, false); // Mặc định không có bảo hiểm bổ sung
    }
    
    /**
     * Thêm booking mới với thông tin về bảo hiểm bổ sung
     * 
     * @param entry Booking cần thêm
     * @param hasAdditionalInsurance Có mua bảo hiểm tai nạn bổ sung không
     * @return Booking đã được thêm
     * @throws EventException Nếu có lỗi khi thêm
     * @throws InvalidDataException Nếu dữ liệu không hợp lệ
     */
    public Booking add(Booking entry, boolean hasAdditionalInsurance) throws EventException, InvalidDataException {
        try {
            validateBooking(entry);
            prepareNewBooking(entry);
            
            // Ghi log tổng tiền trước khi lưu vào database
            LOGGER.info("Tổng tiền booking trước khi lưu: " + entry.getTotalAmount() + "K VND");
            
            // Lưu booking vào database
            Booking savedBooking = bookingRepository.add(entry);
            
            // Ghi log tổng tiền sau khi lưu vào database
            LOGGER.info("Tổng tiền booking sau khi lưu: " + savedBooking.getTotalAmount() + "K VND");
            
            // Lấy thông tin xe từ booking (giả định có carId trong booking)
            int carSeats = getCarSeats(entry.getCarId());
            
            // Tạo bảo hiểm cho booking nếu đã lưu thành công
            if (savedBooking != null) {
                // Tạo các bảo hiểm cho booking
                List<BookingInsurance> insurances = bookingInsuranceService.createInsurancesForBooking(
                    savedBooking, carSeats, hasAdditionalInsurance);
                
                LOGGER.info("Đã tạo " + insurances.size() + " bảo hiểm cho booking " + savedBooking.getBookingId());
            }
            
            return savedBooking;
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
     * @param hourlyPrice Giá theo giờ (BigDecimal) - đơn vị K (nghìn đồng)
     * @param dailyPrice Giá theo ngày (BigDecimal) - đơn vị K (nghìn đồng)
     * @param monthlyPrice Giá theo tháng (BigDecimal) - đơn vị K (nghìn đồng)
     * @param carSeats Số chỗ ngồi của xe
     * @param hasAdditionalInsurance Có mua bảo hiểm tai nạn bổ sung không
     * @return Tổng tiền dạng double (đơn vị K - nghìn đồng)
     */
    public double calculateTotalAmount(LocalDateTime start, LocalDateTime end, String rentalType,
            BigDecimal hourlyPrice, BigDecimal dailyPrice, BigDecimal monthlyPrice,
            int carSeats, boolean hasAdditionalInsurance) {

        // Tính duration theo quy tắc tối thiểu và tự động điều chỉnh loại thuê
        DurationResult durationResult = calculateDuration(start, end, rentalType);
        BigDecimal unitPrice;

        // Chọn đơn giá theo đơn vị thời gian thực tế (không phải loại thuê)
        String unitType = durationResult.getUnitType();
        switch (unitType) {
            case "hour":
                unitPrice = hourlyPrice;
                break;
            case "day":
                unitPrice = dailyPrice;
                break;
            case "month":
                unitPrice = monthlyPrice;
                break;
            default:
                throw new IllegalArgumentException("Đơn vị thời gian không hợp lệ: " + unitType);
        }

        // Tính tổng tiền thuê xe: duration * unitPrice, KHÔNG làm tròn duration
        // Lấy giá trị chính xác của duration để tính tiền thuê xe
        // Lưu ý: unitPrice đã là đơn vị K (nghìn đồng) nên không cần nhân 1000
        BigDecimal rentalAmount = unitPrice.multiply(durationResult.getBillingUnits())
                .setScale(3, RoundingMode.HALF_UP); // Giữ lại 3 số thập phân
                
        // Tính số ngày thuê cho bảo hiểm (làm tròn lên)
        double rentalDays;
        if (unitType.equals("hour")) {
            // Với thuê theo giờ, luôn tính tối thiểu 1 ngày bảo hiểm
            rentalDays = 1;
        } else if (unitType.equals("day")) {
            rentalDays = Math.ceil(durationResult.getBillingUnitsAsDouble());
        } else { // month
            rentalDays = Math.ceil(durationResult.getBillingUnitsAsDouble() * 30.0);
        }
        
        // Tính phí bảo hiểm từ database
        double basicInsuranceFee = 0; // Giá trị mặc định là 0 thay vì hardcode
        double additionalInsuranceFee = 0; // Giá trị mặc định là 0 thay vì hardcode
        
        try {
            // Lấy thông tin bảo hiểm từ database
            Repository.Deposit.InsuranceRepository insuranceRepo = new Repository.Deposit.InsuranceRepository();
            
            // Bảo hiểm vật chất (bắt buộc) - Tính theo công thức: 2% giá trị xe / 365 ngày * số ngày thuê
            // Ước tính giá trị xe dựa trên giá thuê ngày
            double dailyRate = dailyPrice.doubleValue() * 1000; // Chuyển sang VND
            double yearCoefficient = getYearCoefficient(dailyRate);
            double estimatedCarValue = dailyRate * 365 * yearCoefficient;
            double premiumPerDay = estimatedCarValue * 0.02 / 365;
            
            // Giảm 50% phí bảo hiểm vật chất để đồng nhất với frontend
            // QUAN TRỌNG: Frontend đang giảm 50% phí bảo hiểm vật chất trong file booking-form-detail.js
            premiumPerDay = premiumPerDay * 0.5;
            
            // Chuyển từ VND sang K (nghìn đồng)
            basicInsuranceFee = (premiumPerDay / 1000) * rentalDays;
            
            // Bảo hiểm tai nạn (tùy chọn)
            if (hasAdditionalInsurance) {
                // Tìm bảo hiểm tai nạn phù hợp với số chỗ ngồi của xe
                Model.Entity.Deposit.Insurance accidentInsurance = null;
                
                // Lấy danh sách bảo hiểm tai nạn
                List<Model.Entity.Deposit.Insurance> accidentInsurances = insuranceRepo.findByType("TaiNan");
                
                for (Model.Entity.Deposit.Insurance insurance : accidentInsurances) {
                    String seatRange = insurance.getApplicableCarSeats();
                    if (isApplicableSeatRange(carSeats, seatRange)) {
                        accidentInsurance = insurance;
                        break;
                    }
                }
                
                if (accidentInsurance != null) {
                    // Tính phí bảo hiểm tai nạn theo công thức: baseRate * số ngày thuê
                    // Lưu ý: baseRatePerDay trong DB là đơn vị VND, cần chia 1000 để chuyển về đơn vị K
                    additionalInsuranceFee = (accidentInsurance.getBaseRatePerDay() / 1000.0) * rentalDays;
                }
            }
            
            // Log để debug
            LOGGER.info("Phí bảo hiểm vật chất: " + basicInsuranceFee + "K VND");
            LOGGER.info("Phí bảo hiểm tai nạn: " + additionalInsuranceFee + "K VND");
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Lỗi khi tính phí bảo hiểm: " + e.getMessage(), e);
            // Đặt giá trị mặc định là 0 để dễ xử lý lỗi
            basicInsuranceFee = 0;
            additionalInsuranceFee = 0;
        }

        // Tổng tiền = tiền thuê xe + phí bảo hiểm cơ bản + phí bảo hiểm bổ sung
        // Kết quả là đơn vị K (nghìn đồng) để lưu vào database
        double totalAmount = rentalAmount.doubleValue() + basicInsuranceFee + additionalInsuranceFee;
        
        LOGGER.info("Tiền thuê xe: " + rentalAmount.doubleValue() + "K VND");
        LOGGER.info("Tổng tiền: " + totalAmount + "K VND");

        return totalAmount; // Trả về double để lưu vào database (đơn vị K)
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
        // Kiểm tra đầu vào
        if (start == null || end == null) {
            throw new IllegalArgumentException("Start time and end time cannot be null");
        }
        
        if (start.isAfter(end)) {
            throw new IllegalArgumentException("Start time must be before end time");
        }
        
        if (rentalType == null || rentalType.trim().isEmpty()) {
            throw new IllegalArgumentException("Rental type cannot be null or empty");
        }
        
        // Chuẩn hóa rentalType
        String normalizedType = rentalType.trim().toLowerCase();
        
        // Tính toán duration
        Duration duration = Duration.between(start, end);
        
        // Kiểm tra và điều chỉnh loại thuê nếu cần
        String adjustedRentalType = normalizedType;
        String adjustmentNote = null;
        
        // Chuyển đổi các dạng khác nhau của rentalType
        if (normalizedType.equals("hour") || normalizedType.equals("hours")) {
            adjustedRentalType = "hourly";
        } else if (normalizedType.equals("day") || normalizedType.equals("days")) {
            adjustedRentalType = "daily";
        } else if (normalizedType.equals("month") || normalizedType.equals("months")) {
            adjustedRentalType = "monthly";
        }
        
        // Tính toán số giờ và ngày
        double totalHours = duration.toMinutes() / 60.0;
        double totalDays = totalHours / 24.0;
        
        // Quy tắc tự động điều chỉnh loại thuê dựa trên thời gian thuê
        // ĐỒNG BỘ 100% với JavaScript frontend
        if (totalHours < 24 && !adjustedRentalType.equals("hourly")) {
            adjustedRentalType = "hourly";
            adjustmentNote = "Thời gian thuê dưới 24 giờ, tự động chuyển sang tính theo giờ";
        } else if (totalHours >= 24 && totalDays < 30 && !adjustedRentalType.equals("daily")) {
            adjustedRentalType = "daily";
            if (totalDays < 1) {
                adjustmentNote = "Thời gian thuê từ 24 giờ trở lên, tự động chuyển sang tính theo ngày";
            } else {
                adjustmentNote = String.format("Thời gian thuê %.1f ngày, tự động chuyển sang tính theo ngày", totalDays);
            }
        } else if (totalDays >= 30 && !adjustedRentalType.equals("monthly")) {
            adjustedRentalType = "monthly";
            adjustmentNote = String.format("Thời gian thuê %.1f ngày (30+ ngày), tự động chuyển sang tính theo tháng", totalDays);
        }
        
        // Tính toán kết quả dựa trên loại thuê đã điều chỉnh
        DurationResult result;
        switch (adjustedRentalType) {
            case "hourly":
                result = calculateHourlyDuration(duration);
                break;
            case "daily":
                result = calculateDailyDuration(duration);
                break;
            case "monthly":
                result = calculateMonthlyDuration(duration);
                break;
            default:
                throw new IllegalArgumentException("Loại thuê không hợp lệ: " + adjustedRentalType);
        }
        
        // Thêm ghi chú về việc điều chỉnh loại thuê nếu có
        if (adjustmentNote != null) {
            result.setNote(adjustmentNote + (result.getNote() != null ? ". " + result.getNote() : ""));
            result.setOriginalRentalType(rentalType);
            result.setAdjustedRentalType(adjustedRentalType);
        }
        
        return result;
    }

    // ========== CÁC PHƯƠNG THỨC HELPER TÍNH TOÁN ==========
    
    /**
     * Tính duration theo giờ - ĐỒNG BỘ VỚI JAVASCRIPT
     * JS logic: Giữ nguyên số giờ thực tế (không làm tròn) để tính tiền chính xác
     * Hiển thị chi tiết giờ và phút
     * Cập nhật: Nếu thời gian thuê vượt quá 24 giờ, khuyến nghị chuyển sang thuê theo ngày
     */
    private DurationResult calculateHourlyDuration(Duration duration) {
        double actualHours = duration.toMinutes() / 60.0;
        // Đảm bảo tối thiểu 4 giờ
        double billingHours = Math.max(actualHours, MIN_HOURLY_DURATION);
        
        // Tạo text hiển thị chi tiết giờ và phút
        int hoursPart = (int) Math.floor(actualHours);
        int minutesPart = (int) Math.round((actualHours - hoursPart) * 60);
        
        String formattedDuration;
        if (minutesPart > 0) {
            formattedDuration = String.format("%d hours %d minutes", hoursPart, minutesPart);
        } else {
            formattedDuration = String.format("%d hours", hoursPart);
        }
        
        String note = null;
        if (actualHours < MIN_HOURLY_DURATION) {
            note = "Tối thiểu 4 giờ được áp dụng";
        } else if (actualHours > 24.0) {
            note = "Thời gian thuê vượt quá 24 giờ, khuyến nghị chuyển sang thuê theo ngày";
        }
        
        DurationResult result = new DurationResult(
                BigDecimal.valueOf(billingHours).setScale(4, RoundingMode.HALF_UP),
                "hour",
                note
        );
        
        // Thêm thông tin hiển thị
        result.setFormattedDuration(formattedDuration);
        
        return result;
    }

    /**
     * Tính duration theo ngày - ĐỒNG BỘ VỚI JAVASCRIPT  
     * JS logic: Tính số ngày chính xác bao gồm phần lẻ
     * Hiển thị chi tiết ngày, giờ và phút
     * Cập nhật: Nếu thời gian thuê dưới 24 giờ, tự động chuyển sang tính theo giờ
     */
    private DurationResult calculateDailyDuration(Duration duration) {
        double totalHours = duration.toMinutes() / 60.0;
        
        // Nếu thời gian thuê dưới 24 giờ, tự động chuyển sang tính theo giờ
        if (totalHours < 24.0) {
            // Áp dụng quy tắc tính theo giờ (tối thiểu 4 giờ)
            double billingHours = Math.max(totalHours, MIN_HOURLY_DURATION);
            
            // Tạo text hiển thị chi tiết giờ và phút
            int hoursPart = (int) Math.floor(totalHours);
            int minutesPart = (int) Math.round((totalHours - hoursPart) * 60);
            
            String formattedDuration;
            if (minutesPart > 0) {
                formattedDuration = String.format("%d hours %d minutes", hoursPart, minutesPart);
            } else {
                formattedDuration = String.format("%d hours", hoursPart);
            }
            
            DurationResult result = new DurationResult(
                BigDecimal.valueOf(billingHours).setScale(4, RoundingMode.HALF_UP),
                "hour", // Đơn vị là giờ
                "Thời gian thuê dưới 24 giờ, tự động tính theo giờ"
            );
            
            // Thêm thông tin hiển thị
            result.setFormattedDuration(formattedDuration);
            
            return result;
        } 
        // Nếu thời gian thuê từ 24 giờ trở lên, tính theo ngày
        else {
            // Tính số ngày chính xác bao gồm phần lẻ
            double exactDays = totalHours / 24.0;
            
            // Tạo text hiển thị chi tiết ngày, giờ và phút
            int daysPart = (int) Math.floor(exactDays);
            double remainingHours = (exactDays - daysPart) * 24;
            int hoursPart = (int) Math.floor(remainingHours);
            int minutesPart = (int) Math.round((remainingHours - hoursPart) * 60);
            
            // Điều chỉnh nếu phút = 60
            if (minutesPart == 60) {
                minutesPart = 0;
                hoursPart++;
                
                // Điều chỉnh nếu giờ = 24
                if (hoursPart == 24) {
                    hoursPart = 0;
                    daysPart++;
                }
            }
            
            StringBuilder formattedDuration = new StringBuilder();
            formattedDuration.append(daysPart).append(" days");
            
            if (hoursPart > 0 && minutesPart > 0) {
                formattedDuration.append(" ").append(hoursPart).append(" hours ").append(minutesPart).append(" minutes");
            } else if (hoursPart > 0) {
                formattedDuration.append(" ").append(hoursPart).append(" hours");
            } else if (minutesPart > 0) {
                formattedDuration.append(" ").append(minutesPart).append(" minutes");
            }
            
            DurationResult result = new DurationResult(
                BigDecimal.valueOf(exactDays).setScale(4, RoundingMode.HALF_UP),
                "day",
                null
            );
            
            // Thêm thông tin hiển thị
            result.setFormattedDuration(formattedDuration.toString());
            
            return result;
        }
    }

    /**
     * Tính duration theo tháng - ĐỒNG BỘ VỚI JAVASCRIPT
     * JS logic: Tính số tháng chính xác bao gồm phần lẻ
     * Hiển thị chi tiết tháng, ngày, giờ và phút
     */
    private DurationResult calculateMonthlyDuration(Duration duration) {
        double totalDays = duration.toHours() / 24.0;
        double exactMonths = totalDays / DAYS_PER_MONTH;
        // Không còn áp dụng quy tắc tối thiểu cho monthly
        double billingMonths = exactMonths;
        
        // Tạo text hiển thị chi tiết tháng, ngày, giờ và phút
        int monthsPart = (int) Math.floor(exactMonths);
        double remainingDays = (exactMonths - monthsPart) * DAYS_PER_MONTH;
        int daysPart = (int) Math.floor(remainingDays);
        double remainingHours = (remainingDays - daysPart) * 24;
        int hoursPart = (int) Math.floor(remainingHours);
        int minutesPart = (int) Math.round((remainingHours - hoursPart) * 60);
        
        // Điều chỉnh nếu phút = 60
        if (minutesPart == 60) {
            minutesPart = 0;
            hoursPart++;
            
            // Điều chỉnh nếu giờ = 24
            if (hoursPart == 24) {
                hoursPart = 0;
                daysPart++;
                
                // Điều chỉnh nếu ngày = 30
                if (daysPart == DAYS_PER_MONTH) {
                    daysPart = 0;
                    monthsPart++;
                }
            }
        }
        
        // Tạo chuỗi hiển thị
        StringBuilder formattedDuration = new StringBuilder();
        
        if (monthsPart > 0) {
            formattedDuration.append(monthsPart).append(" months");
            if (daysPart > 0 || hoursPart > 0 || minutesPart > 0) {
                formattedDuration.append(" ");
            }
        }
        
        if (daysPart > 0) {
            formattedDuration.append(daysPart).append(" days");
            if (hoursPart > 0 || minutesPart > 0) {
                formattedDuration.append(" ");
            }
        }
        
        if (hoursPart > 0) {
            formattedDuration.append(hoursPart).append(" hours");
            if (minutesPart > 0) {
                formattedDuration.append(" ");
            }
        }
        
        if (minutesPart > 0) {
            formattedDuration.append(minutesPart).append(" minutes");
        }
        
        // Nếu chuỗi rỗng, mặc định hiển thị "0 months"
        if (formattedDuration.length() == 0) {
            formattedDuration.append("0 months");
        }

        DurationResult result = new DurationResult(
                BigDecimal.valueOf(billingMonths).setScale(4, RoundingMode.HALF_UP),
                "month",
                null // Không còn thông báo về tối thiểu
        );
        
        // Thêm thông tin hiển thị
        result.setFormattedDuration(formattedDuration.toString());
        
        return result;
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
        
        // Kiểm tra thời gian - đơn giản hóa thông báo lỗi
        if (booking.getPickupDateTime() == null || booking.getReturnDateTime() == null) {
            throw new InvalidDataException("Thời gian nhận xe và trả xe là bắt buộc");
        }
        
        if (booking.getPickupDateTime().isAfter(booking.getReturnDateTime())) {
            throw new InvalidDataException("Thời gian nhận xe phải trước thời gian trả xe");
        }
        
        // Chỉ kiểm tra thời gian quá khứ nếu đang tạo booking mới
        if (booking.getCreatedDate() == null && booking.getPickupDateTime().isBefore(LocalDateTime.now())) {
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

    public void updateBookingStatus(UUID bookingId, String status) throws SQLException {
        bookingRepository.updateBookingStatus(bookingId, status);
    }
    
    /**
     * Lấy số chỗ ngồi của xe từ carId
     * 
     * @param carId ID của xe
     * @return Số chỗ ngồi của xe
     */
    private int getCarSeats(UUID carId) {
        try {
            // Lấy thông tin xe từ repository
            Car car = new CarRepository().findById(carId);
            if (car != null) {
                return car.getSeats();
            }
            LOGGER.warning("Không tìm thấy xe với ID: " + carId + ", sử dụng giá trị mặc định 5 chỗ");
            return 5; // Giá trị mặc định nếu không tìm thấy xe
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi lấy số chỗ ngồi của xe: " + e.getMessage(), e);
            return 5; // Giá trị mặc định nếu có lỗi
        }
    }
    
    /**
     * Kiểm tra xem booking có mua bảo hiểm bổ sung không
     * 
     * @param booking Booking cần kiểm tra
     * @return true nếu có mua bảo hiểm bổ sung, false nếu không
     */
    private boolean hasAdditionalInsurance(Booking booking) {
        try {
            // Nếu booking mới tạo (chưa có ID), không thể có bảo hiểm
            if (booking == null || booking.getBookingId() == null) {
                return false;
            }
            
            // Kiểm tra trong BookingInsurance xem có bảo hiểm loại TaiNan không
            List<BookingInsurance> insurances = bookingInsuranceRepository.findByBookingId(booking.getBookingId());
            
            // Nếu chưa có bảo hiểm nào, trả về false
            if (insurances == null || insurances.isEmpty()) {
                return false;
            }
            
            for (BookingInsurance insurance : insurances) {
                Insurance insuranceInfo = insuranceRepository.findById(insurance.getInsuranceId());
                if (insuranceInfo != null && "TaiNan".equals(insuranceInfo.getInsuranceType())) {
                    return true;
                }
            }
            
            return false;
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Lỗi khi kiểm tra bảo hiểm bổ sung: " + e.getMessage(), e);
            return false;
        }
    }
    
    /**
     * Kiểm tra xem số chỗ ngồi có phù hợp với range của bảo hiểm không
     */
    private boolean isApplicableSeatRange(int seats, String seatRange) {
        if (seatRange == null) return true;
        
        if (seatRange.equals("1-5")) return seats <= 5;
        if (seatRange.equals("6-11")) return seats >= 6 && seats <= 11;
        if (seatRange.equals("12+")) return seats >= 12;
        
        return true;
    }
    
    /**
     * Xác định hệ số năm sử dụng theo giá thuê/ngày
     */
    private double getYearCoefficient(double dailyRate) {
        if (dailyRate <= 500000) {
            return 5; // Hệ số thấp
        } else if (dailyRate <= 800000) {
            return 7; // Hệ số trung bình
        } else if (dailyRate <= 1200000) {
            return 10; // Hệ số cao
        } else {
            return 15; // Hệ số cao cấp
        }
    }
}
