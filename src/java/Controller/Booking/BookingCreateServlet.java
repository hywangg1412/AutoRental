package Controller.Booking;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.time.Duration;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

import Model.Entity.Booking.Booking;
import Model.Entity.Car.Car;
import Model.Entity.User.DriverLicense;
import Model.Entity.User.User;
import Repository.Car.CarRepository;
import Service.Booking.BookingService;
import Service.External.CloudinaryService;
import Service.User.DriverLicenseService;
import Utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/booking/create")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024, // 1MB
        maxFileSize = 1024 * 1024 * 5, // 5MB
        maxRequestSize = 1024 * 1024 * 10 // 10MB
)
public class BookingCreateServlet extends HttpServlet {

    private final DriverLicenseService driverLicenseService = new DriverLicenseService();
    private final CloudinaryService cloudinaryService = new CloudinaryService();
    private final BookingService bookingService = new BookingService();
    private final CarRepository carRepository = new CarRepository();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Step 1: Check user login
            User user = (User) SessionUtil.getSessionAttribute(request, "user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp?error=not_logged_in");
                return;
            }

            // Step 2: Get all required parameters from the form
            String carIdStr = request.getParameter("carId");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String rentalType = request.getParameter("rentalType");
            String hasDriverLicenseParam = request.getParameter("hasDriverLicense");

            // Step 3: Validate essential booking data
            if (carIdStr == null || carIdStr.trim().isEmpty()
                    || startDateStr == null || startDateStr.trim().isEmpty()
                    || endDateStr == null || endDateStr.trim().isEmpty()
                    || rentalType == null || rentalType.trim().isEmpty()) {
                throw new IllegalArgumentException("Car ID, start date, end date and rental type are required.");
            }

            UUID carId = UUID.fromString(carIdStr);
            LocalDateTime pickupDateTime = LocalDateTime.parse(startDateStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            LocalDateTime returnDateTime = LocalDateTime.parse(endDateStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);

            if (pickupDateTime.isBefore(LocalDateTime.now().plusMinutes(5))) {
                throw new IllegalArgumentException("Pickup date/time must be at least 5 minutes in the future.");
            }
            if (returnDateTime.isBefore(pickupDateTime)) {
                throw new IllegalArgumentException("Return date/time must be after pickup date/time.");
            }

            // Step 4: Get Car Details for Price Calculation
            Car car = carRepository.findById(carId);
            if (car == null) {
                throw new IllegalArgumentException("Car with ID " + carIdStr + " not found.");
            }

            // Step 5: Handle driver license logic (upload if new)
            boolean hasDriverLicense = "true".equals(hasDriverLicenseParam);
            if (!hasDriverLicense) {
                // This method will throw an exception if validation fails
                handleNewLicenseUpload(request, user);
            }

            // Step 6: Create and Populate the Booking object
            Booking newBooking = new Booking();
            newBooking.setBookingId(UUID.randomUUID());
            newBooking.setUserId(user.getUserId());
            newBooking.setCarId(carId);
            newBooking.setPickupDateTime(pickupDateTime);
            newBooking.setReturnDateTime(returnDateTime);
            newBooking.setStatus("Pending");
            newBooking.setCreatedDate(LocalDateTime.now());

            // Booking code sẽ được tạo tự động trong BookingService.prepareNewBooking()
            // Set a default payment method, can be changed later
            newBooking.setExpectedPaymentMethod("Pay at pickup");

            // Calculate total amount on the server for security and accuracy
            double totalAmount = calculateTotalAmount(car, pickupDateTime, returnDateTime, rentalType);
            newBooking.setTotalAmount(totalAmount);

            // Set other fields to null by default
            newBooking.setHandledBy(null);
            newBooking.setDiscountId(null);
            newBooking.setCancelReason(null);

            // Lấy thông tin phone và address từ form booking
            String customerPhone = request.getParameter("customerPhone");
            String customerAddress = request.getParameter("customerAddress");

            // Lấy driverLicense trước!
            DriverLicense driverLicense = driverLicenseService.findByUserId(user.getUserId());

            // Đóng băng customerName: ưu tiên fullName bằng lái, nếu không có thì lấy username, không lấy firstName/lastName
            String frozenName = null;
            if (driverLicense != null && driverLicense.getFullName() != null && !driverLicense.getFullName().trim().isEmpty()) {
                frozenName = driverLicense.getFullName();
            } else if (user.getUsername() != null && !user.getUsername().trim().isEmpty()) {
                frozenName = user.getUsername();
            } else {
                frozenName = "Unknown";
            }
            newBooking.setCustomerName(frozenName);

            // Đóng băng thông tin khách hàng vào booking
            newBooking.setCustomerPhone(customerPhone != null ? customerPhone : user.getPhoneNumber()); // Số điện thoại
            newBooking.setCustomerEmail(user.getEmail()); // Email

            // Đóng băng ảnh bằng lái xe vào booking
            if (driverLicense != null) {
                newBooking.setDriverLicenseImageUrl(driverLicense.getLicenseImage());
            } else {
                newBooking.setDriverLicenseImageUrl(null);
            }

            // Step 7: Save the booking to the database
            bookingService.add(newBooking);
            // --- Gửi notification cho tất cả staff khi có booking mới ---
            try {
                Service.Role.RoleService roleService = new Service.Role.RoleService();
                Model.Entity.Role.Role staffRole = roleService.findByRoleName("Staff");
                java.util.UUID staffRoleId = staffRole.getRoleId();

                Service.Role.UserRoleService userRoleService = new Service.Role.UserRoleService();
                java.util.List<Model.Entity.Role.UserRole> staffUserRoles = userRoleService.findByRoleId(staffRoleId);

                Service.NotificationService notificationService = new Service.NotificationService();
                String message = "Bạn có một booking request mới.";
                for (Model.Entity.Role.UserRole ur : staffUserRoles) {
                    Model.Entity.Notification notification = new Model.Entity.Notification(
                            java.util.UUID.randomUUID(),
                            ur.getUserId(),
                            message,
                            java.time.LocalDateTime.now()
                    );
                    notificationService.add(notification);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
                // Không làm fail booking nếu lỗi notification
            }
            // Step 8: Lấy lại booking từ DB để lấy totalAmount và các thông tin khác
            Booking savedBooking = bookingService.findById(newBooking.getBookingId());
            request.setAttribute("booking", savedBooking);
            request.getRequestDispatcher("/pages/booking-form/booking-success.jsp").forward(request, response);
            return;

        } catch (Exception e) {
            e.printStackTrace();
            // Set a user-friendly error message to display on an error page
            request.setAttribute("error", "Failed to create booking: " + e.getMessage());
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }

    private double calculateTotalAmount(Car car, LocalDateTime start, LocalDateTime end, String rentalType) {
        Duration duration = Duration.between(start, end);
        BigDecimal totalAmount = BigDecimal.ZERO;

        switch (rentalType) {
            case "hourly":
                long hours = duration.toHours();
                if (duration.toMinutesPart() > 0) {
                    hours++; // Round up to the next hour
                }
                totalAmount = car.getPricePerHour().multiply(BigDecimal.valueOf(hours));
                break;
            case "daily":
                long days = duration.toDays();
                if (duration.toHoursPart() > 0 || duration.toMinutesPart() > 0) {
                    days++; // Round up to the next day
                }
                totalAmount = car.getPricePerDay().multiply(BigDecimal.valueOf(days));
                break;
            case "monthly":
                long months = duration.toDays() / 30; // Simple month calculation
                if (duration.toDays() % 30 > 0) {
                    months++; // Round up to the next month
                }
                totalAmount = car.getPricePerMonth().multiply(BigDecimal.valueOf(months));
                break;
            default:
                throw new IllegalArgumentException("Invalid rental type: " + rentalType);
        }

        return totalAmount.doubleValue();
    }

    private void handleNewLicenseUpload(HttpServletRequest request, User user)
            throws Exception {

        // Get license form data
        String licenseNumber = request.getParameter("licenseNumber");
        String licenseFullName = request.getParameter("licenseFullName");
        String licenseDob = request.getParameter("licenseDob");
        Part licenseImagePart = request.getPart("licenseImage");

        // Validate required fields
        if (licenseNumber == null || licenseNumber.trim().isEmpty()) {
            throw new IllegalArgumentException("License number is required");
        }
        if (licenseFullName == null || licenseFullName.trim().isEmpty()) {
            throw new IllegalArgumentException("License full name is required");
        }
        if (licenseDob == null || licenseDob.trim().isEmpty()) {
            throw new IllegalArgumentException("License date of birth is required");
        }
        if (licenseImagePart == null || licenseImagePart.getSize() == 0) {
            throw new IllegalArgumentException("License image is required");
        }

        // Validate license number format (12 digits)
        if (!licenseNumber.matches("^[0-9]{12}$")) {
            throw new IllegalArgumentException("License number must be exactly 12 digits");
        }

        // Validate full name (letters and spaces only)
        if (!licenseFullName.matches("^[\\p{L} ]+$")) {
            throw new IllegalArgumentException("Full name must contain only letters and spaces");
        }

        // Validate date of birth
        LocalDate dob;
        try {
            dob = LocalDate.parse(licenseDob);
            LocalDate today = LocalDate.now();
            if (dob.isAfter(today)) {
                throw new IllegalArgumentException("Date of birth cannot be in the future");
            }
            // Check minimum age (18 years)
            if (today.getYear() - dob.getYear() < 18) {
                throw new IllegalArgumentException("You must be at least 18 years old");
            }
        } catch (Exception e) {
            throw new IllegalArgumentException("Invalid date of birth format");
        }

        // Validate and upload image
        String imageUrl = uploadLicenseImage(licenseImagePart);

        // Create or update driver license record
        DriverLicense driverLicense = driverLicenseService.findByUserId(user.getUserId());
        if (driverLicense == null) {
            // Create new license record
            driverLicense = new DriverLicense();
            driverLicense.setLicenseId(UUID.randomUUID());
            driverLicense.setUserId(user.getUserId());
            driverLicense.setCreatedDate(LocalDateTime.now());
        }

        // Update license information
        driverLicense.setLicenseNumber(licenseNumber);
        driverLicense.setFullName(licenseFullName);
        driverLicense.setDob(dob);
        driverLicense.setLicenseImage(imageUrl);

        // Save to database
        if (driverLicense.getLicenseId() == null) {
            driverLicenseService.add(driverLicense);
        } else {
            driverLicenseService.update(driverLicense);
        }
    }

    private String uploadLicenseImage(Part filePart) throws Exception {
        // Validate file type
        String contentType = filePart.getContentType();
        if (contentType == null
                || (!contentType.startsWith("image/") && !contentType.equals("application/pdf"))) {
            throw new IllegalArgumentException("Invalid file type. Only images and PDF are allowed");
        }

        // Validate file size (max 5MB)
        if (filePart.getSize() > 5 * 1024 * 1024) {
            throw new IllegalArgumentException("File size must be less than 5MB");
        }

        // Upload to Cloudinary using the correct method
        try (InputStream inputStream = filePart.getInputStream()) {
            String originalFilename = filePart.getSubmittedFileName();
            return cloudinaryService.uploadAndGetUrlToFolder(inputStream, originalFilename, "driver_licenses");
        } catch (Exception e) {
            throw new Exception("Failed to upload license image: " + e.getMessage());
        }
    }
}
