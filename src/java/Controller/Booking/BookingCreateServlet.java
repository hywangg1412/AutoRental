package Controller.Booking;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.UUID;

import Model.DTO.DurationResult;
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
            // Step 1: Kiểm tra đăng nhập user
            User user = (User) SessionUtil.getSessionAttribute(request, "user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp?error=not_logged_in");
                return;
            }

            // Step 2: Lấy tất cả tham số cần thiết từ form
            String carIdStr = request.getParameter("carId");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String rentalType = request.getParameter("rentalType"); // Đã có sẵn
            String hasDriverLicenseParam = request.getParameter("hasDriverLicense");

            // Step 3: Validate dữ liệu đầu vào cơ bản
            if (carIdStr == null || carIdStr.trim().isEmpty()
                    || startDateStr == null || startDateStr.trim().isEmpty()
                    || endDateStr == null || endDateStr.trim().isEmpty()
                    || rentalType == null || rentalType.trim().isEmpty()) {
                throw new IllegalArgumentException("Car ID, start date, end date and rental type are required.");
            }

            // Validate rentalType phải là một trong các giá trị hợp lệ
            if (!rentalType.equals("hourly") && !rentalType.equals("daily") && !rentalType.equals("monthly")) {
                throw new IllegalArgumentException("Invalid rental type. Must be 'hourly', 'daily', or 'monthly'.");
            }

            UUID carId = UUID.fromString(carIdStr);
            LocalDateTime pickupDateTime = LocalDateTime.parse(startDateStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            LocalDateTime returnDateTime = LocalDateTime.parse(endDateStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);

// ✅ Thêm đoạn này sau khi đã có pickup/return
            DateTimeFormatter isoFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            request.setAttribute("pickupDefault", pickupDateTime.format(isoFormatter));
            request.setAttribute("returnDefault", returnDateTime.format(isoFormatter));

            // Validate thời gian
            if (pickupDateTime.isBefore(LocalDateTime.now().plusMinutes(5))) {
                throw new IllegalArgumentException("Pickup date/time must be at least 5 minutes in the future.");
            }

            if (returnDateTime.isBefore(pickupDateTime)) {
                throw new IllegalArgumentException("Return date/time must be after pickup date/time.");
            }

            // Step 4: Lấy thông tin xe để tính giá
            Car car = carRepository.findById(carId);
            if (car == null) {
                throw new IllegalArgumentException("Car with ID " + carIdStr + " not found.");
            }

            // Step 5: Xử lý logic bằng lái xe (upload nếu mới)
            boolean hasDriverLicense = "true".equals(hasDriverLicenseParam);
            if (!hasDriverLicense) {
                handleNewLicenseUpload(request, user);
            }

            // Step 6: Tạo và điền thông tin Booking object
            Booking newBooking = new Booking();
            newBooking.setBookingId(UUID.randomUUID());
            newBooking.setUserId(user.getUserId());
            newBooking.setCarId(carId);
            newBooking.setPickupDateTime(pickupDateTime);
            newBooking.setReturnDateTime(returnDateTime);
            // *** Lưu rentalType vào booking ***
            newBooking.setRentalType(rentalType);
            // *** THÊM DÒNG NÀY ***
            newBooking.setStatus("Pending");
            newBooking.setCreatedDate(LocalDateTime.now());

            // *** SỬA PHẦN PAYMENT METHOD ***
            // Đặt payment method mặc định là "Pending" vì chưa chọn
            // Sẽ được cập nhật ở bước contract/deposit
            newBooking.setExpectedPaymentMethod("Pending");

            // Tính tổng tiền dựa trên rentalType đã lưu
            double totalAmount = calculateTotalAmount(car, pickupDateTime, returnDateTime, rentalType, request);
            newBooking.setTotalAmount(totalAmount);

            // Set các field khác
            newBooking.setHandledBy(null);
            newBooking.setDiscountId(null);
            newBooking.setCancelReason(null);

            // Lấy thông tin khách hàng từ form
            String customerPhone = request.getParameter("customerPhone");
            String customerAddress = request.getParameter("customerAddress");

            // Lấy thông tin bằng lái
            DriverLicense driverLicense = driverLicenseService.findByUserId(user.getUserId());

            // Đóng băng tên khách hàng: ưu tiên fullName từ bằng lái
            String frozenName = null;
            if (driverLicense != null && driverLicense.getFullName() != null && !driverLicense.getFullName().trim().isEmpty()) {
                frozenName = driverLicense.getFullName();
            } else if (user.getUsername() != null && !user.getUsername().trim().isEmpty()) {
                frozenName = user.getUsername();
            } else {
                frozenName = "Unknown";
            }

            newBooking.setCustomerName(frozenName);
            newBooking.setCustomerPhone(customerPhone != null ? customerPhone : user.getPhoneNumber());
            newBooking.setCustomerEmail(user.getEmail());
            newBooking.setCustomerAddress(customerAddress); // Thêm dòng này nếu chưa có

            // Đóng băng ảnh bằng lái xe
            if (driverLicense != null) {
                newBooking.setDriverLicenseImageUrl(driverLicense.getLicenseImage());
            } else {
                newBooking.setDriverLicenseImageUrl(null);
            }

            // Step 7: Lưu booking vào database
            bookingService.add(newBooking);
            
            // Gửi notification cho tất cả staff khi có booking mới
            Service.NotificationService notificationService = new Service.NotificationService();
            String message = "Bạn có một booking request mới.";
            notificationService.sendNotificationToAllStaff(message);

            // Step 8: Lấy lại booking từ DB và chuyển đến trang success
            Booking savedBooking = bookingService.findById(newBooking.getBookingId());
            request.setAttribute("booking", savedBooking);
            request.getRequestDispatcher("/pages/booking-form/booking-success.jsp").forward(request, response);
            return;

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to create booking: " + e.getMessage());
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }

    }

    // ========== TÍNH TOÁN GIÁ THUÊ ==========
    
    /**
     * Tính tổng tiền thuê xe sử dụng logic từ BookingService
     * Đồng bộ với JavaScript frontend để hiển thị nhất quán
     */
    private double calculateTotalAmount(Car car, LocalDateTime start, LocalDateTime end,
            String rentalType, HttpServletRequest request) {

        // Sử dụng BookingService để tính toán (đã đồng bộ với JS)
        double totalAmount = bookingService.calculateTotalAmount(
                start, end, rentalType,
                car.getPricePerHour(),
                car.getPricePerDay(),
                car.getPricePerMonth()
        );

        // Lấy thông tin chi tiết duration để hiển thị trên JSP
        DurationResult durationResult = bookingService.calculateDuration(start, end, rentalType);

        // Gửi thông tin về JSP để hiển thị cho user
        request.setAttribute("unitType", durationResult.getUnitType());
        request.setAttribute("units", durationResult.getBillingUnitsAsDouble());
        request.setAttribute("unitPrice", getUnitPriceAsDouble(car, rentalType));
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("rentalNote", durationResult.getNote());

        return totalAmount;
    }

    /**
     * Helper method để lấy đơn giá theo loại thuê
     */
    private double getUnitPriceAsDouble(Car car, String rentalType) {
        switch (rentalType.toLowerCase()) {
            case "hourly":
                return car.getPricePerHour().doubleValue();
            case "daily":
                return car.getPricePerDay().doubleValue();
            case "monthly":
                return car.getPricePerMonth().doubleValue();
            default:
                throw new IllegalArgumentException("Loại thuê không hợp lệ: " + rentalType);
        }
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
