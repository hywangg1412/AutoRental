package Service.Booking;

import java.sql.SQLException;
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
 * This service handles business logic for staff-related booking operations.
 * It aggregates data from various repositories to create comprehensive DTOs for the view layer.
 */
public class StaffBookingService {

    private static final Logger LOGGER = Logger.getLogger(StaffBookingService.class.getName());
    private final BookingRepository bookingRepository = new BookingRepository();
    private final UserRepository userRepository = new UserRepository();
    private final CarRepository carRepository = new CarRepository();
    private final DriverLicenseRepository driverLicenseRepository = new DriverLicenseRepository();

    /**
     * Retrieves all bookings and converts them into a list of BookingInfoDTOs.
     * Each DTO contains aggregated information for display on the staff booking management page.
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
                    // 1. Populate from Booking entity
                    dto.setBookingId(booking.getBookingId());
                    dto.setBookingCode(booking.getBookingCode());
                    dto.setPickupDateTime(booking.getPickupDateTime());
                    dto.setReturnDateTime(booking.getReturnDateTime());
                    dto.setTotalAmount(booking.getTotalAmount());
                    dto.setStatus(booking.getStatus());
                    dto.setCreatedDate(booking.getCreatedDate());
                    
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
                    
                    // Calculate duration
                    if (booking.getPickupDateTime() != null && booking.getReturnDateTime() != null) {
                        long duration = java.time.Duration.between(booking.getPickupDateTime(), booking.getReturnDateTime()).toDays();
                        dto.setDuration(duration > 0 ? duration : 1); // Minimum 1 day
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
                    
                    dto.setDepositStatus("Paid"); 
                    dto.setContractStatus("Pending");

                    // AGGRESSIVE LOGGING
                    LOGGER.log(Level.INFO, "FINAL DTO CHECK -> BookingCode: '{0}', CarModel: '{1}', CustomerName: '{2}'", 
                            new Object[]{dto.getBookingCode(), dto.getCarModel(), dto.getCustomerName()});
                            
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

    /**
     * Updates the status of a specific booking.
     *
     * @param bookingId The ID of the booking to update.
     * @param status The new status (e.g., "Accepted", "Rejected").
     * @param reason The reason for the status change (especially for rejection, can be null).
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

    // TODO: Implement getDashboardStats() method
    // This method will calculate statistics for the dashboard.
    // For now, it's a placeholder.
    /*
    public DashboardStatsDTO getDashboardStats() {
        // ... logic to calculate total requests, pending, accepted, revenue etc. ...
    }
    */

    // Lấy danh sách BookingInfoDTO theo phân trang (page, pageSize)
    public List<BookingInfoDTO> getBookingInfoPaged(int page, int pageSize) {
        List<BookingInfoDTO> dtos = new ArrayList<>();
        try {
            int offset = (page - 1) * pageSize;
            List<Booking> bookings = bookingRepository.findAllPaged(offset, pageSize);
            // Copy logic chuyển Booking -> DTO từ getAllBookingInfo
            for (Booking booking : bookings) {
                BookingInfoDTO dto = new BookingInfoDTO();
                // ... (copy toàn bộ logic set các trường cho dto như getAllBookingInfo)
                try {
                    dto.setBookingId(booking.getBookingId());
                    dto.setBookingCode(booking.getBookingCode());
                    dto.setPickupDateTime(booking.getPickupDateTime());
                    dto.setReturnDateTime(booking.getReturnDateTime());
                    dto.setTotalAmount(booking.getTotalAmount());
                    dto.setStatus(booking.getStatus());
                    dto.setCreatedDate(booking.getCreatedDate());
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
                    if (booking.getPickupDateTime() != null && booking.getReturnDateTime() != null) {
                        long duration = java.time.Duration.between(booking.getPickupDateTime(), booking.getReturnDateTime()).toDays();
                        dto.setDuration(duration > 0 ? duration : 1);
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
                    dto.setDepositStatus("Paid");
                    dto.setContractStatus("Pending");
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