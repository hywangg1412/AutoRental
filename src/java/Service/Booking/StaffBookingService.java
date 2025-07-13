package Service.Booking;

import java.sql.SQLException;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

import Model.DTO.BookingInfoDTO;
import Model.Entity.Booking.Booking;
import Model.Entity.Car.Car;
import Model.Entity.User.DriverLicense;
import Model.Entity.User.User;
import Repository.Booking.BookingRepository;
import Repository.Car.CarRepository;
import Repository.User.DriverLicenseRepository;
import Repository.User.UserRepository;

/**
 * This service handles business logic for staff-related booking operations. It
 * aggregates data from various repositories to create comprehensive DTOs for
 * the view layer.
 */
public class StaffBookingService {

    private static final Logger LOGGER = Logger.getLogger(StaffBookingService.class.getName());
    private final BookingRepository bookingRepository = new BookingRepository();
    private final UserRepository userRepository = new UserRepository();
    private final CarRepository carRepository = new CarRepository();
    private final DriverLicenseRepository driverLicenseRepository = new DriverLicenseRepository();

    /**
     * Retrieves all bookings and converts them into a list of BookingInfoDTOs.
     * Each DTO contains aggregated information for display on the staff booking
     * management page.
     *
     * @return A list of BookingInfoDTO objects.
     */
    public List<BookingInfoDTO> getAllBookingInfo() {
        List<BookingInfoDTO> dtos = new ArrayList<>();
        try {
            List<Booking> bookings = bookingRepository.findAll();
            LOGGER.log(Level.INFO, "Found {0} total bookings in the database.", bookings.size());

            if (bookings.isEmpty()) {
                return dtos;
            }

            for (Booking booking : bookings) {
                BookingInfoDTO dto = new BookingInfoDTO();
                LOGGER.log(Level.INFO, "Processing booking ID: {0}", booking.getBookingId());

                try {
                    // 1. Populate from Booking entity - THÊM RentalType
                    dto.setBookingId(booking.getBookingId());
                    dto.setBookingCode(booking.getBookingCode());
                    dto.setPickupDateTime(booking.getPickupDateTime());
                    dto.setReturnDateTime(booking.getReturnDateTime());
                    dto.setTotalAmount(booking.getTotalAmount());
                    dto.setStatus(booking.getStatus());
                    dto.setCreatedDate(booking.getCreatedDate());
                    dto.setRentalType(booking.getRentalType()); // *** THÊM RENTAL TYPE ***

                    // Đóng băng thông tin khách hàng và ảnh bằng lái từ entity Booking
                    // Ưu tiên thông tin đã đóng băng, nếu null thì lấy từ User entity
                    String customerName = booking.getCustomerName();
                    String customerPhone = booking.getCustomerPhone();
                    String customerEmail = booking.getCustomerEmail();
                    String driverLicenseImageUrl = booking.getDriverLicenseImageUrl();

                    // Fallback: Nếu thông tin đóng băng bị null, rỗng hoặc là 'null null', lấy từ User entity
                    if (customerName == null || customerName.trim().isEmpty() || customerName.trim().equalsIgnoreCase("null null")) {
                        try {
                            User user = userRepository.findById(booking.getUserId());
                            if (user != null) {
                                if (user.getUsername() != null && !user.getUsername().trim().isEmpty()) {
                                    customerName = user.getUsername();
                                } else {
                                    DriverLicense license = driverLicenseRepository.findByUserId(booking.getUserId());
                                    if (license != null && license.getFullName() != null && !license.getFullName().trim().isEmpty()) {
                                        customerName = license.getFullName();
                                    } else if (user.getEmail() != null && !user.getEmail().trim().isEmpty()) {
                                        customerName = user.getEmail();
                                    } else {
                                        customerName = "Unknown User";
                                    }
                                }
                                if (customerPhone == null || customerPhone.trim().isEmpty()) {
                                    customerPhone = user.getPhoneNumber();
                                }
                                if (customerEmail == null || customerEmail.trim().isEmpty()) {
                                    customerEmail = user.getEmail();
                                }
                            } else {
                                customerName = "Unknown User";
                                LOGGER.log(Level.WARNING, "User not found for booking ID: {0}", booking.getBookingId());
                            }
                        } catch (Exception e) {
                            customerName = "Unknown User";
                            LOGGER.log(Level.WARNING, "Error fetching user for booking ID: {0}", booking.getBookingId());
                        }
                    }

                    dto.setCustomerName(customerName);
                    dto.setCustomerPhone(customerPhone);
                    dto.setCustomerEmail(customerEmail);
                    dto.setDriverLicenseImageUrl(driverLicenseImageUrl);

                    // *** SỬA LOGIC TÍNH DURATION - GIỐNG BOOKING-FORM-DETAIL.JS ***
                    if (booking.getPickupDateTime() != null && booking.getReturnDateTime() != null) {
                        double accurateDuration = calculateAccurateDuration(
                                booking.getPickupDateTime(),
                                booking.getReturnDateTime(),
                                booking.getRentalType()
                        );
                        dto.setDuration(accurateDuration); // *** KHÔNG LÀM TRÒN - GIỮ NGUYÊN SỐ THẬP PHÂN ***
                    } else {
                        dto.setDuration(1.0); // Fallback
                    }

                    // 3. Populate from Car entity
                    Car car = carRepository.findById(booking.getCarId());
                    LOGGER.log(Level.INFO, "Looking up car with ID: {0}, Result: {1}",
                            new Object[]{booking.getCarId(), car != null ? "Found" : "NOT FOUND"});
                    if (car != null) {
                        dto.setCarModel(car.getCarModel());
                        dto.setCarLicensePlate(car.getLicensePlate());
                        dto.setCarStatus(car.getStatus().getValue());
                        LOGGER.log(Level.INFO, "Car details: Model={0}, Plate={1}, Status={2}",
                                new Object[]{car.getCarModel(), car.getLicensePlate(), car.getStatus().getValue()});
                    } else {
                        dto.setCarModel("--- VEHICLE NOT FOUND ---");
                        dto.setCarLicensePlate("--- N/A ---");
                        dto.setCarStatus("Unknown");
                        LOGGER.log(Level.WARNING, "Car not found for booking ID: {0}, CarId: {1}",
                                new Object[]{booking.getBookingId(), booking.getCarId()});
                    }

                    // 4. Populate from DriverLicense entity (fallback nếu chưa đóng băng)
                    if (driverLicenseImageUrl == null || driverLicenseImageUrl.trim().isEmpty()) {
                        DriverLicense license = driverLicenseRepository.findByUserId(booking.getUserId());
                        if (license != null && license.getLicenseImage() != null) {
                            dto.setDriverLicenseImageUrl(license.getLicenseImage());
                        } else {
                            dto.setDriverLicenseImageUrl(null);
                            LOGGER.log(Level.INFO, "No driver license found for user {0}", booking.getUserId());
                        }
                    }

                    // *** SỬA LOGIC DEPOSIT STATUS - DỰA TRÊN BOOKING STATUS THỰC TẾ ***
                    String depositStatus = determineDepositStatus(booking);
                    String contractStatus = determineContractStatus(booking);

                    System.out.println("=== DEBUG BOOKING " + booking.getBookingCode() + " ===");
                    System.out.println("Booking Status: " + booking.getStatus());
                    System.out.println("Determined Deposit Status: " + depositStatus);
                    System.out.println("Determined Contract Status: " + contractStatus);

                    dto.setDepositStatus(depositStatus);
                    dto.setContractStatus(contractStatus);

                    System.out.println("DTO Deposit Status after set: " + dto.getDepositStatus());
                    System.out.println("DTO Contract Status after set: " + dto.getContractStatus());
                    System.out.println("=== END DEBUG ===");

                    // AGGRESSIVE LOGGING - THÊM RentalType và DepositStatus
                    LOGGER.log(Level.INFO, "FINAL DTO CHECK -> BookingCode: '{0}', CarModel: '{1}', CustomerName: '{2}', RentalType: '{3}', DepositStatus: '{4}', Duration: {5}",
                            new Object[]{dto.getBookingCode(), dto.getCarModel(), dto.getCustomerName(), dto.getRentalType(), dto.getDepositStatus(), dto.getDuration()});

                    dtos.add(dto);

                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Failed to process booking ID: " + booking.getBookingId(), e);
                }
            }

        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error while fetching all booking info", e);
            return new ArrayList<>();
        }
        return dtos;
    }

    // *** THÊM METHOD TÍNH DURATION CHÍNH XÁC - GIỐNG BOOKING-FORM-DETAIL.JS ***
    private double calculateAccurateDuration(java.time.LocalDateTime start, java.time.LocalDateTime end, String rentalType) {
        if (start == null || end == null) {
            return 1.0;
        }

        Duration javaDuration = Duration.between(start, end);
        double result;

        // Logic giống hệt booking-form-detail.js
        switch (rentalType != null ? rentalType.toLowerCase() : "daily") {
            case "hourly":
                double hours = javaDuration.toMinutes() / 60.0;
                result = Math.max(Math.ceil(hours), 4.0); // Minimum 4 hours, làm tròn lên
                break;
            case "daily":
                double totalHours = javaDuration.toMinutes() / 60.0;
                double days = totalHours / 24.0;
                result = Math.max(days, 0.5); // Minimum 0.5 days - KHÔNG LÀM TRÒN
                break;
            case "monthly":
                double totalDays = javaDuration.toHours() / 24.0;
                double months = totalDays / 30.0;
                result = Math.max(months, 0.5); // Minimum 0.5 months
                break;
            default:
                // Fallback cho trường hợp không có rentalType
                result = Math.max(javaDuration.toDays(), 1);
        }

        return result;
    }

    // *** THÊM METHOD XÁC ĐỊNH DEPOSIT STATUS DỰA TRÊN BOOKING STATUS ***
    // *** SỬA LOGIC DEPOSIT STATUS - THEO BUSINESS MỚI ***
    private String determineDepositStatus(Booking booking) {
        String status = booking.getStatus();

        switch (status) {
            case "Pending":
            case "Rejected":
                return "Not Applicable"; // Chưa duyệt/bị từ chối thì không cần deposit
            case "Confirmed":
                return "Awaiting Payment"; // Đã duyệt, chờ thanh toán deposit
            case "AwaitingPayment":
                return "Awaiting Payment"; // Đã tạo payment, chờ thanh toán (có thể retry)
            case "DepositPaid":
                return "Paid"; // ✅ Đã thanh toán deposit thành công
            case "ContractSigned":
            case "FullyPaid":
            case "InProgress":
            case "Completed":
                return "Paid"; // Đã thanh toán deposit (và có thể đã thanh toán full)
            case "Cancelled":
                return "Cancelled";
            default:
                return "Unknown";
        }
    }

// *** SỬA LOGIC CONTRACT STATUS ***
    private String determineContractStatus(Booking booking) {
        String status = booking.getStatus();

        switch (status) {
            case "Pending":
            case "Rejected":
                return "Not Applicable"; // Chưa duyệt thì chưa có contract
            case "Confirmed":
            case "AwaitingPayment":
                return "Not Created"; // Chưa tạo contract (chưa đặt cọc)
            case "DepositPaid":
                return "Ready to Sign"; // ✅ Đã đặt cọc, sẵn sàng ký contract
            case "ContractSigned":
                return "Signed"; // Đã ký contract
            case "FullyPaid":
            case "InProgress":
            case "Completed":
                return "Completed"; // Contract hoàn thành
            case "Cancelled":
                return "Cancelled";
            default:
                return "Unknown";
        }
    }

    /**
     * Updates the status of a specific booking.
     *
     * @param bookingId The ID of the booking to update.
     * @param status The new status (e.g., "Accepted", "Rejected").
     * @param reason The reason for the status change (especially for rejection,
     * can be null).
     * @throws SQLException if a database access error occurs.
     */
    public void updateBookingStatus(java.util.UUID bookingId, String status, String reason) throws SQLException {
        // The 'reason' is available if we need to log it or store it elsewhere in the future.
        // For now, we just update the status.
        bookingRepository.updateBookingStatus(bookingId, status);
        LOGGER.log(Level.INFO, "Service initiated status update for booking ID {0} to {1}", new Object[]{bookingId, status});

        // TODO: Future enhancements could include:
        // - Sending an email notification to the user.
        // - Creating an audit log entry with the reason for the change.
    }

    // Lấy danh sách BookingInfoDTO theo phân trang (page, pageSize)
    public List<BookingInfoDTO> getBookingInfoPaged(int page, int pageSize) {
        List<BookingInfoDTO> dtos = new ArrayList<>();
        try {
            int offset = (page - 1) * pageSize;
            List<Booking> bookings = bookingRepository.findAllPaged(offset, pageSize);

            // Copy logic chuyển Booking -> DTO từ getAllBookingInfo
            for (Booking booking : bookings) {
                BookingInfoDTO dto = new BookingInfoDTO();

                try {
                    dto.setBookingId(booking.getBookingId());
                    dto.setBookingCode(booking.getBookingCode());
                    dto.setPickupDateTime(booking.getPickupDateTime());
                    dto.setReturnDateTime(booking.getReturnDateTime());
                    dto.setTotalAmount(booking.getTotalAmount());
                    dto.setStatus(booking.getStatus());
                    dto.setCreatedDate(booking.getCreatedDate());
                    dto.setRentalType(booking.getRentalType()); // *** THÊM RENTAL TYPE ***

                    // ... copy toàn bộ logic xử lý customer, car, license như getAllBookingInfo ...
                    String customerName = booking.getCustomerName();
                    String customerPhone = booking.getCustomerPhone();
                    String customerEmail = booking.getCustomerEmail();
                    String driverLicenseImageUrl = booking.getDriverLicenseImageUrl();

                    if (customerName == null || customerName.trim().isEmpty() || customerName.trim().equalsIgnoreCase("null null")) {
                        try {
                            User user = userRepository.findById(booking.getUserId());
                            if (user != null) {
                                if (user.getUsername() != null && !user.getUsername().trim().isEmpty()) {
                                    customerName = user.getUsername();
                                } else {
                                    DriverLicense license = driverLicenseRepository.findByUserId(booking.getUserId());
                                    if (license != null && license.getFullName() != null && !license.getFullName().trim().isEmpty()) {
                                        customerName = license.getFullName();
                                    } else if (user.getEmail() != null && !user.getEmail().trim().isEmpty()) {
                                        customerName = user.getEmail();
                                    } else {
                                        customerName = "Unknown User";
                                    }
                                }
                                if (customerPhone == null || customerPhone.trim().isEmpty()) {
                                    customerPhone = user.getPhoneNumber();
                                }
                                if (customerEmail == null || customerEmail.trim().isEmpty()) {
                                    customerEmail = user.getEmail();
                                }
                            } else {
                                customerName = "Unknown User";
                            }
                        } catch (Exception e) {
                            customerName = "Unknown User";
                        }
                    }

                    dto.setCustomerName(customerName);
                    dto.setCustomerPhone(customerPhone);
                    dto.setCustomerEmail(customerEmail);
                    dto.setDriverLicenseImageUrl(driverLicenseImageUrl);

                    // *** SỬA LOGIC TÍNH DURATION CHO PAGED CŨNG VẬY ***
                    if (booking.getPickupDateTime() != null && booking.getReturnDateTime() != null) {
                        double accurateDuration = calculateAccurateDuration(
                                booking.getPickupDateTime(),
                                booking.getReturnDateTime(),
                                booking.getRentalType()
                        );
                        dto.setDuration(accurateDuration); // *** KHÔNG LÀM TRÒN ***
                    } else {
                        dto.setDuration(1.0);
                    }

                    Car car = carRepository.findById(booking.getCarId());
                    if (car != null) {
                        dto.setCarModel(car.getCarModel());
                        dto.setCarLicensePlate(car.getLicensePlate());
                        dto.setCarStatus(car.getStatus().getValue());
                    } else {
                        dto.setCarModel("--- VEHICLE NOT FOUND ---");
                        dto.setCarLicensePlate("--- N/A ---");
                        dto.setCarStatus("Unknown");
                    }

                    if (driverLicenseImageUrl == null || driverLicenseImageUrl.trim().isEmpty()) {
                        DriverLicense license = driverLicenseRepository.findByUserId(booking.getUserId());
                        if (license != null && license.getLicenseImage() != null) {
                            dto.setDriverLicenseImageUrl(license.getLicenseImage());
                        } else {
                            dto.setDriverLicenseImageUrl(null);
                        }
                    }

                    // *** SỬA LOGIC DEPOSIT STATUS CHO PAGED CŨNG VẬY ***
                    String depositStatus = determineDepositStatus(booking);
                    String contractStatus = determineContractStatus(booking);

                    dto.setDepositStatus(depositStatus);
                    dto.setContractStatus(contractStatus);

                    dtos.add(dto);
                } catch (Exception e) {
                    // Bỏ qua booking lỗi
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "SQL error while fetching paged booking info", e);
            return new ArrayList<>();
        }
        return dtos;
    }
}
