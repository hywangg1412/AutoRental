package Controller.Booking;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.Map;
import java.math.BigDecimal;
import java.util.logging.Level;
import java.util.logging.Logger;

import Model.DTO.DurationResult;
import Model.Entity.Booking.Booking;
import Model.Entity.Car.Car;
import Model.Entity.User.DriverLicense;
import Model.Entity.User.User;
import Repository.Booking.BookingRepository;
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

    private static final Logger LOGGER = Logger.getLogger(BookingCreateServlet.class.getName());

    private final DriverLicenseService driverLicenseService = new DriverLicenseService();
    private final CloudinaryService cloudinaryService = new CloudinaryService();
    private final BookingService bookingService = new BookingService();
    private final CarRepository carRepository = new CarRepository();
    private final BookingRepository bookingRepository = new BookingRepository();
    
    // Constants for time restrictions
    private static final int EARLIEST_HOUR = 7;  // 7 AM
    private static final int LATEST_HOUR = 22;   // 10 PM
    private static final int MAINTENANCE_BUFFER_DAYS = 1;  // 1 day buffer after each rental

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
            
            // Sửa phần parse ngày giờ để xử lý nhiều định dạng khác nhau
            LocalDateTime pickupDateTime;
            LocalDateTime returnDateTime;
            
            try {
                // Thử parse theo định dạng ISO_LOCAL_DATE_TIME (YYYY-MM-DDThh:mm)
                pickupDateTime = LocalDateTime.parse(startDateStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
                returnDateTime = LocalDateTime.parse(endDateStr, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            } catch (Exception e) {
                try {
                    // Thử parse theo định dạng "YYYY-MM-DD HH:MM" (định dạng của Flatpickr)
                    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
                    pickupDateTime = LocalDateTime.parse(startDateStr, formatter);
                    returnDateTime = LocalDateTime.parse(endDateStr, formatter);
                } catch (Exception ex) {
                    throw new IllegalArgumentException("Invalid date/time format. Expected format: YYYY-MM-DD HH:MM or YYYY-MM-DDThh:mm");
                }
            }

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
            
            // Validate time restrictions (7am to 10pm)
            validateTimeRestrictions(pickupDateTime, returnDateTime);
            
            // Validate time increments (whole hours or half hours)
            validateTimeIncrements(pickupDateTime, returnDateTime);

            // Step 4: Lấy thông tin xe để tính giá
            Car car = carRepository.findById(carId);
            if (car == null) {
                throw new IllegalArgumentException("Car with ID " + carIdStr + " not found.");
            }
            
            // Check for overlapping bookings with maintenance buffer
//            checkOverlappingBookings(carId, pickupDateTime, returnDateTime);

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
            // Lấy lại thông tin hasAdditionalInsurance từ request để truyền vào bookingService.add()
            boolean hasAdditionalInsurance = "true".equals(request.getParameter("additionalInsurance"));
            
            // Thêm log để kiểm tra giá trị hasAdditionalInsurance
            LOGGER.info("Giá trị hasAdditionalInsurance trước khi lưu booking: " + hasAdditionalInsurance);
            LOGGER.info("Giá trị additionalInsurance từ request: " + request.getParameter("additionalInsurance"));
            
            bookingService.add(newBooking, hasAdditionalInsurance);
            
            // Gửi notification cho tất cả staff khi có booking mới
            Service.NotificationService notificationService = new Service.NotificationService();
            String message = "You have a new booking request.";
            notificationService.sendNotificationToAllStaff(message);

            // Step 8: Lấy lại booking từ DB và chuyển đến trang success
            Booking savedBooking = bookingService.findById(newBooking.getBookingId());
            request.setAttribute("booking", savedBooking);
            request.getRequestDispatcher("/pages/booking-form/booking-success.jsp").forward(request, response);
            return;

        } catch (Exception e) {
            e.printStackTrace();
            // Cải thiện thông báo lỗi để hiển thị chi tiết hơn
            String errorMessage = "Failed to create booking: " + e.getMessage();
            
            // Thêm thông tin chi tiết về loại lỗi
            if (e instanceof IllegalArgumentException) {
                errorMessage = "Invalid input: " + e.getMessage();
            } else if (e instanceof java.sql.SQLException) {
                errorMessage = "Database error: " + e.getMessage();
            } else if (e instanceof java.io.IOException) {
                errorMessage = "File upload error: " + e.getMessage();
            }
            
            // Ghi log lỗi
            LOGGER.log(Level.SEVERE, "Error in BookingCreateServlet: ", e);
            
            // Đặt thông báo lỗi chi tiết vào request attribute
            request.setAttribute("errorMessage", errorMessage);
            request.setAttribute("exception", e);
            
            // Chuyển hướng đến trang error.jsp
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }
    
    /**
     * Validates that pickup and return times are within allowed hours (7am to 10pm)
     */
    private void validateTimeRestrictions(LocalDateTime pickupDateTime, LocalDateTime returnDateTime) {
        int pickupHour = pickupDateTime.getHour();
        int returnHour = returnDateTime.getHour();
        
        if (pickupHour < EARLIEST_HOUR || pickupHour > LATEST_HOUR) {
            throw new IllegalArgumentException("Pickup time must be between 7:00 AM and 10:00 PM.");
        }
        
        if (returnHour < EARLIEST_HOUR || returnHour > LATEST_HOUR) {
            throw new IllegalArgumentException("Return time must be between 7:00 AM and 10:00 PM.");
        }
    }
    
    /**
     * Validates that pickup and return times are on the hour or half hour
     */
    private void validateTimeIncrements(LocalDateTime pickupDateTime, LocalDateTime returnDateTime) {
        int pickupMinute = pickupDateTime.getMinute();
        int returnMinute = returnDateTime.getMinute();
        
        if (pickupMinute != 0 && pickupMinute != 30) {
            throw new IllegalArgumentException("Pickup time must be on the hour or half hour (e.g., 9:00 or 9:30).");
        }
        
        if (returnMinute != 0 && returnMinute != 30) {
            throw new IllegalArgumentException("Return time must be on the hour or half hour (e.g., 9:00 or 9:30).");
        }
    }
    
    /**
     * Checks for overlapping bookings with maintenance buffer
     */
//    private void checkOverlappingBookings(UUID carId, LocalDateTime pickupDateTime, LocalDateTime returnDateTime) throws Exception {
//        // Get all bookings for this car that are confirmed or in progress
//        List<Booking> carBookings = new ArrayList<>();
//        try {
//            // Get all bookings for this car
//            List<Booking> allBookings = bookingRepository.findAll();
//            
//            // Filter bookings for this car with relevant statuses
//            String[] relevantStatuses = {"Confirmed", "Deposit_Paid", "Contract_Signed", "Fully_Paid", "In_Progress"};
//            for (Booking booking : allBookings) {
//                if (booking.getCarId().equals(carId)) {
//                    String status = booking.getStatus();
//                    for (String relevantStatus : relevantStatuses) {
//                        if (relevantStatus.equalsIgnoreCase(status)) {
//                            carBookings.add(booking);
//                            break;
//                        }
//                    }
//                }
//            }
//        } catch (Exception e) {
//            throw new Exception("Error checking car availability: " + e.getMessage());
//        }
//        
//        // Add maintenance buffer to return date
//        LocalDateTime bufferEndDateTime = returnDateTime.plusDays(MAINTENANCE_BUFFER_DAYS);
//        
//        // Check for overlaps
//        for (Booking booking : carBookings) {
//            LocalDateTime existingPickup = booking.getPickupDateTime();
//            LocalDateTime existingReturn = booking.getReturnDateTime();
//            
//            // Add maintenance buffer to existing booking's return date
//            LocalDateTime existingBufferEnd = existingReturn.plusDays(MAINTENANCE_BUFFER_DAYS);
//            
//            // Check if there's an overlap
//            if (!(bufferEndDateTime.isBefore(existingPickup) || pickupDateTime.isAfter(existingBufferEnd))) {
//                throw new IllegalArgumentException(
//                    "This car is already booked during the selected period or within the maintenance buffer period. " +
//                    "Please choose different dates or check other available cars."
//                );
//            }
//        }
//    }

    // ========== TÍNH TOÁN GIÁ THUÊ ==========
    
    /**
     * Tính tổng tiền thuê xe sử dụng logic từ BookingService
     * Đồng bộ với JavaScript frontend để hiển thị nhất quán
     * Bao gồm phí bảo hiểm
     */
    private double calculateTotalAmount(Car car, LocalDateTime start, LocalDateTime end,
            String rentalType, HttpServletRequest request) {

        // Kiểm tra xem có mua bảo hiểm bổ sung không
        boolean hasAdditionalInsurance = "true".equals(request.getParameter("additionalInsurance"));
        
        // Lấy số chỗ ngồi của xe
        int carSeats = car.getSeats();
        
        // Sử dụng BookingService để tính toán (đã đồng bộ với JS)
        double totalAmount = bookingService.calculateTotalAmount(
                start, end, rentalType,
                car.getPricePerHour(),
                car.getPricePerDay(),
                car.getPricePerMonth(),
                carSeats,
                hasAdditionalInsurance
        );

        // Lấy thông tin chi tiết duration để hiển thị trên JSP
        DurationResult durationResult = bookingService.calculateDuration(start, end, rentalType);

        // Kiểm tra xem có điều chỉnh loại thuê không
        if (durationResult.hasRentalTypeAdjusted()) {
            // Cập nhật lại rentalType theo loại thuê đã điều chỉnh
            rentalType = durationResult.getAdjustedRentalType();
            
            // Ghi log thông tin điều chỉnh
            LOGGER.log(Level.INFO, "Rental type adjusted from {0} to {1} for better pricing", 
                    new Object[]{durationResult.getOriginalRentalType(), rentalType});
            
            // Thêm thông báo cho người dùng
            request.setAttribute("rentalTypeAdjusted", true);
            request.setAttribute("originalRentalType", durationResult.getOriginalRentalType());
            request.setAttribute("adjustedRentalType", rentalType);
        }

        // Tạo service để tính bảo hiểm
        Service.Booking.BookingInsuranceService insuranceService = new Service.Booking.BookingInsuranceService();
        
        // Tính số ngày thuê cho bảo hiểm (làm tròn lên)
        double rentalDays;
        if (durationResult.getUnitType().equals("hour")) {
            rentalDays = Math.ceil(durationResult.getBillingUnitsAsDouble() / 24.0);
        } else if (durationResult.getUnitType().equals("day")) {
            rentalDays = Math.ceil(durationResult.getBillingUnitsAsDouble());
        } else { // month
            rentalDays = Math.ceil(durationResult.getBillingUnitsAsDouble() * 30.0);
        }
        
        // Lấy thông tin bảo hiểm từ database
        Repository.Deposit.InsuranceRepository insuranceRepo = new Repository.Deposit.InsuranceRepository();
        double basicInsuranceFee = 0; // Giá trị mặc định là 0
        double additionalInsuranceFee = 0; // Giá trị mặc định là 0
        
        try {
            // Tính phí bảo hiểm vật chất (bắt buộc)
            List<Model.Entity.Deposit.Insurance> vehicleInsurances = insuranceRepo.findByType("VatChat");
            if (!vehicleInsurances.isEmpty()) {
                Model.Entity.Deposit.Insurance vehicleInsurance = vehicleInsurances.get(0);
                // Ước tính giá trị xe dựa trên giá thuê ngày
                double dailyRate = car.getPricePerDay().doubleValue() * 1000; // Chuyển sang VND
                double yearCoefficient = getYearCoefficient(dailyRate);
                double estimatedCarValue = dailyRate * 365 * yearCoefficient;
                double premiumPerDay = estimatedCarValue * vehicleInsurance.getPercentageRate() / 100 / 365;
                basicInsuranceFee = premiumPerDay * rentalDays;
            }
            
            // Tính phí bảo hiểm tai nạn nếu được chọn
            if (hasAdditionalInsurance) {
                // Tìm bảo hiểm tai nạn phù hợp với số chỗ ngồi
                List<Model.Entity.Deposit.Insurance> accidentInsurances = insuranceRepo.findByType("TaiNan");
                boolean found = false;
                
                for (Model.Entity.Deposit.Insurance insurance : accidentInsurances) {
                    if (isApplicableSeatRange(carSeats, insurance.getApplicableCarSeats())) {
                        additionalInsuranceFee = insurance.getBaseRatePerDay() * rentalDays;
                        found = true;
                        break;
                    }
                }
                
                if (!found) {
                    System.out.println("Không tìm thấy bảo hiểm tai nạn phù hợp cho xe " + carSeats + " chỗ");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Đặt giá trị mặc định là 0 để dễ xử lý lỗi
            basicInsuranceFee = 0;
            additionalInsuranceFee = 0;
        }
        
        // Tính giá thuê xe cơ bản (không bao gồm bảo hiểm)
        BigDecimal unitPrice = BigDecimal.ZERO;
        switch (durationResult.getUnitType()) {
            case "hour":
                unitPrice = car.getPricePerHour();
                break;
            case "day":
                unitPrice = car.getPricePerDay();
                break;
            case "month":
                unitPrice = car.getPricePerMonth();
                break;
        }
        
        double baseRentalFee = unitPrice.doubleValue() * durationResult.getBillingUnitsAsDouble() * 1000;
        
        // Gửi thông tin về JSP để hiển thị cho user
        request.setAttribute("unitType", durationResult.getUnitType());
        request.setAttribute("units", durationResult.getBillingUnitsAsDouble());
        request.setAttribute("unitPrice", getUnitPriceAsDouble(car, durationResult.getUnitType()));
        request.setAttribute("baseRentalFee", baseRentalFee);
        request.setAttribute("basicInsuranceFee", basicInsuranceFee);
        request.setAttribute("additionalInsuranceFee", additionalInsuranceFee);
        request.setAttribute("hasAdditionalInsurance", hasAdditionalInsurance);
        request.setAttribute("totalAmount", totalAmount);
        request.setAttribute("rentalNote", durationResult.getNote());

        return totalAmount;
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

    /**
     * Helper method để lấy đơn giá theo loại thuê
     */
    private double getUnitPriceAsDouble(Car car, String rentalType) {
        if (rentalType == null) {
            throw new IllegalArgumentException("Loại thuê không được để trống");
        }
        
        // Chuẩn hóa rentalType
        String normalizedType = rentalType.trim().toLowerCase();
        
        // Xử lý các trường hợp có thể xảy ra
        switch (normalizedType) {
            case "hourly":
            case "hour":
                return car.getPricePerHour().doubleValue();
            case "daily":
            case "day":
                return car.getPricePerDay().doubleValue();
            case "monthly":
            case "month":
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

        // Upload image to Cloudinary
        String imageUrl = uploadLicenseImage(licenseImagePart);

        // Create and save driver license
        DriverLicense driverLicense = new DriverLicense();
            driverLicense.setLicenseId(UUID.randomUUID());
            driverLicense.setUserId(user.getUserId());
        driverLicense.setLicenseNumber(licenseNumber);
        driverLicense.setFullName(licenseFullName);
        driverLicense.setDob(LocalDate.parse(licenseDob));
        driverLicense.setLicenseImage(imageUrl);
        // Note: DriverLicense doesn't have a setVerified method, so we'll skip that
        driverLicense.setCreatedDate(LocalDateTime.now());

            driverLicenseService.add(driverLicense);
    }

    private String uploadLicenseImage(Part filePart) throws Exception {
        try (InputStream fileContent = filePart.getInputStream()) {
            // Convert InputStream to byte array since the CloudinaryService.uploadImage method expects that
            byte[] imageBytes = fileContent.readAllBytes();
            Map uploadResult = cloudinaryService.uploadImage(imageBytes);
            return cloudinaryService.getImageUrlAfterUpload(uploadResult);
        } catch (Exception e) {
            throw new Exception("Failed to upload license image: " + e.getMessage());
        }
    }
}
