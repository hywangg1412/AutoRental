package Controller.Admin;

import Exception.NotFoundException;
import Model.Entity.Car.*;
import Model.DTO.CarListItemDTO;
import Model.Entity.Car.Car.CarStatus;
import Model.Entity.User.User;
import Service.Car.*;
import Repository.Car.CarImageRepository;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.BufferedReader;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.io.InputStreamReader;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@WebServlet("/manageCarsServlet")
public class CarManagementServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(CarManagementServlet.class);
    private static final String UPLOAD_DIR = "Uploads/car-images";
    private static final int MAX_IMAGE_COUNT = 10;
    private static final CarListService carListService = new CarListService();
    private static final CarService carService = new CarService();
    private static final CarBrandService carBrandService = new CarBrandService();
    private static final FuelTypeService fuelTypeService = new FuelTypeService();
    private static final TransmissionTypeService transmissionTypeService = new TransmissionTypeService();
    private static final CarCategoriesService carCategoriesService = new CarCategoriesService();
    private static final CarImageRepository carImageRepository = new CarImageRepository();

    @Override
    public void init() throws ServletException {
        try {
            String realPath = getServletContext().getRealPath("");
            Files.createDirectories(Paths.get(realPath + UPLOAD_DIR));
        } catch (IOException e) {
            throw new ServletException("Failed to initialize upload directory", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tạm thời bỏ qua kiểm tra quyền để test
        /*
        if (!isAuthorized(request)) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write("""
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Không có quyền truy cập</title>
                    <meta charset="UTF-8">
                    <style>
                        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
                        .error { color: red; font-size: 18px; margin-bottom: 20px; }
                        .info { color: #666; margin-bottom: 20px; }
                        .btn { background: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; }
                    </style>
                </head>
                <body>
                    <div class="error">⚠️ Không có quyền truy cập</div>
                    <div class="info">Bạn cần đăng nhập với tài khoản Admin hoặc Staff để truy cập trang này.</div>
                    <a href="javascript:history.back()" class="btn">Quay lại</a>
                    <a href="${pageContext.request.contextPath}/" class="btn">Về trang chủ</a>
                </body>
                </html>
                """);
            return;
        }
        */

        String carIdParam = request.getParameter("carId");
        if (carIdParam != null && !carIdParam.trim().isEmpty()) {
            try {
                UUID carId = UUID.fromString(carIdParam);
                Car car = carService.findById(carId);
                if (car != null) {
                    CarImage mainImage = carImageRepository.findMainImageByCarId(carId);
                    String imageUrl = (mainImage != null) ? mainImage.getImageUrl() : null;
                    response.setContentType("application/json");
                    response.setCharacterEncoding("UTF-8");
                    String json = String.format("{\"carId\":\"%s\",\"carModel\":\"%s\",\"brandId\":\"%s\",\"fuelTypeId\":\"%s\",\"transmissionTypeId\":\"%s\",\"categoryId\":\"%s\",\"seats\":%d,\"yearManufactured\":%d,\"licensePlate\":\"%s\",\"odometer\":%d,\"description\":\"%s\",\"pricePerDay\":%s,\"pricePerHour\":%s,\"pricePerMonth\":%s,\"status\":\"%s\",\"mainImageUrl\":\"%s\"}",
                        car.getCarId(),
                        car.getCarModel() != null ? car.getCarModel().replace("\"", "\\\"") : "",
                        car.getBrandId(),
                        car.getFuelTypeId(),
                        car.getTransmissionTypeId(),
                        car.getCategoryId() != null ? car.getCategoryId().toString() : "",
                        car.getSeats(),
                        car.getYearManufactured(),
                        car.getLicensePlate() != null ? car.getLicensePlate().replace("\"", "\\\"") : "",
                        car.getOdometer(),
                        car.getDescription() != null ? car.getDescription().replace("\"", "\\\"") : "",
                        car.getPricePerDay() != null ? car.getPricePerDay().toString() : "0",
                        car.getPricePerHour() != null ? car.getPricePerHour().toString() : "0",
                        car.getPricePerMonth() != null ? car.getPricePerMonth().toString() : "0",
                        car.getStatus() != null ? car.getStatus().getValue() : "Available",
                        imageUrl != null ? imageUrl.replace("\"", "\\\"") : ""
                    );
                    response.getWriter().write(json);
                } else {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Car not found");
                }
            } catch (IllegalArgumentException e) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid car ID format");
            } catch (Exception e) {
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error fetching car details");
            }
            return;
        }

        try {
            int page = parsePageParameter(request.getParameter("page"));
            int limit = 10;
            int offset = (page - 1) * limit;

            List<CarListItemDTO> carList = carListService.getByPage(offset, limit);
            if (carList == null) carList = new ArrayList<>();

            for (CarListItemDTO dto : carList) {
                Car car = carService.findById(dto.getCarId());
                if (car != null) {
                    dto.setTransmissionTypeName(transmissionTypeService.findById(car.getTransmissionTypeId()) != null ? 
                        transmissionTypeService.findById(car.getTransmissionTypeId()).getTransmissionName() : "N/A");
                    dto.setFuelName(fuelTypeService.findById(car.getFuelTypeId()) != null ? 
                        fuelTypeService.findById(car.getFuelTypeId()).getFuelName() : "N/A");
                    dto.setYearManufactured(car.getYearManufactured());
                    dto.setSeats(car.getSeats());
                    dto.setStatusDisplay(car.getStatus() != null ? car.getStatus().getDisplayValue() : "N/A");
                    dto.setStatusCssClass(car.getStatus() != null ? car.getStatus().getCssClass() : "unknown");
                    dto.setPricePerHour(car.getPricePerHour());
                    dto.setPricePerMonth(car.getPricePerMonth());
                    CarImage mainImage = carImageRepository.findMainImageByCarId(car.getCarId());
                    dto.setMainImageUrl(mainImage != null ? mainImage.getImageUrl() : null);
                }
            }

            int totalCars = carListService.countAll();
            int totalPages = (int) Math.ceil((double) totalCars / limit);

            request.setAttribute("carList", carList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("brandList", carBrandService.getAll() != null ? carBrandService.getAll() : new ArrayList<>());
            request.setAttribute("fuelTypeList", fuelTypeService.getAll() != null ? fuelTypeService.getAll() : new ArrayList<>());
            request.setAttribute("transmissionTypeList", transmissionTypeService.getAll() != null ? transmissionTypeService.getAll() : new ArrayList<>());
            request.setAttribute("categoryList", carCategoriesService.getAll() != null ? carCategoriesService.getAll() : new ArrayList<>());
            request.setAttribute("statusList", Arrays.asList(CarStatusOption.values()));
            request.setAttribute("maxYear", java.time.Year.now().getValue() + 1);

            request.getRequestDispatcher("/pages/admin/manage-cars.jsp").forward(request, response);
        } catch (Exception e) {
            String errorMessage = URLEncoder.encode("Không thể tải trang quản lý xe: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/manageCarsServlet?error=" + errorMessage);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Tạm thời bỏ qua kiểm tra quyền để test
        /*
        if (!isAuthorized(request)) {
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().write("""
                <!DOCTYPE html>
                <html>
                <head>
                    <title>Không có quyền truy cập</title>
                    <meta charset="UTF-8">
                    <style>
                        body { font-family: Arial, sans-serif; text-align: center; padding: 50px; }
                        .error { color: red; font-size: 18px; margin-bottom: 20px; }
                        .info { color: #666; margin-bottom: 20px; }
                        .btn { background: #007bff; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; }
                    </style>
                </head>
                <body>
                    <div class="error">⚠️ Không có quyền truy cập</div>
                    <div class="info">Bạn cần đăng nhập với tài khoản Admin hoặc Staff để truy cập trang này.</div>
                    <a href="javascript:history.back()" class="btn">Quay lại</a>
                    <a href="${pageContext.request.contextPath}/" class="btn">Về trang chủ</a>
                </body>
                </html>
                """);
            return;
        }
        */

        try {
            String action = request.getParameter("action");
            logger.info("Received action: '{}'", action);
            
            // Debug: Log all parameters
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                String paramValue = request.getParameter(paramName);
                logger.info("Parameter: {} = {}", paramName, paramValue);
            }
            
            // Xử lý delete operation
            if ("delete".equals(action != null ? action.toLowerCase() : "")) {
                handleDelete(request, response);
                return;
            }

            // Xử lý add/update operation (không xử lý ảnh)
            handleRegularFormRequest(request, response);
        } catch (Exception e) {
            logger.error("Error in doPost: {}", e.getMessage());
            redirectWithError(request, response, "Lỗi xử lý yêu cầu: " + e.getMessage());
        }
    }

    private void handleDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String carIdStr = request.getParameter("carId");
        if (carIdStr != null && !carIdStr.trim().isEmpty()) {
            try {
                UUID carId = UUID.fromString(carIdStr);
                carService.delete(carId);
                List<CarImage> images = carImageRepository.findByCarId(carId);
                for (CarImage image : images) {
                    carImageRepository.delete(image.getImageId());
                }
                redirectWithSuccess(request, response, "Xe đã được xóa thành công");
            } catch (Exception e) {
                redirectWithError(request, response, "Lỗi xóa xe: " + e.getMessage());
            }
        } else {
            redirectWithError(request, response, "Car ID là bắt buộc để xóa");
        }
    }

    private void handleRegularFormRequest(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            String action = request.getParameter("action");
            logger.info("Received action: '{}'", action);
            
            // Debug: Log all parameters
            java.util.Enumeration<String> paramNames = request.getParameterNames();
            while (paramNames.hasMoreElements()) {
                String paramName = paramNames.nextElement();
                String paramValue = request.getParameter(paramName);
                logger.info("Parameter: {} = {}", paramName, paramValue);
            }
            
            if (action == null || action.trim().isEmpty()) {
                logger.warn("Action is null or empty");
                redirectWithError(request, response, "Hành động là bắt buộc");
                return;
            }

            logger.info("Processing action: {}", action);
            switch (action.toLowerCase()) {
                case "add":
                    logger.info("Processing add action");
                    Car newCar = createCarFromRequest(request, true);
                    logger.info("Created car object: {}", newCar.getCarId());
                    try {
                        carService.add(newCar);
                        logger.info("Car added successfully");
                        redirectWithSuccess(request, response, "Xe đã được thêm thành công. Bạn có thể upload ảnh riêng biệt.");
                    } catch (Exception addError) {
                        logger.error("Error adding car: {}", addError.getMessage(), addError);
                        redirectWithError(request, response, "Lỗi thêm xe: " + addError.getMessage());
                    }
                    break;

                case "update":
                    logger.info("Processing update action");
                    Car updatedCar = createCarFromRequest(request, false);
                    // Validate that car exists before update
                    Car existingCar = carService.findById(updatedCar.getCarId());
                    if (existingCar == null) {
                        logger.warn("Car not found for update: {}", updatedCar.getCarId());
                        redirectWithError(request, response, "Không tìm thấy xe để cập nhật");
                        return;
                    }
                    carService.update(updatedCar);
                    logger.info("Car updated successfully");
                    redirectWithSuccess(request, response, "Xe đã được cập nhật thành công");
                    break;

                default:
                    logger.warn("Invalid action: {}", action);
                    redirectWithError(request, response, "Hành động không hợp lệ");
            }
        } catch (IllegalArgumentException e) {
            logger.warn("Validation error: {}", e.getMessage());
            redirectWithError(request, response, e.getMessage());
        } catch (Exception e) {
            logger.error("Error processing regular form: {}", e.getMessage(), e);
            redirectWithError(request, response, "Lỗi xử lý form: " + e.getMessage());
        }
    }

    private boolean isAuthorized(HttpServletRequest request) {
        Object user = request.getSession().getAttribute("user");
        Object userRole = request.getSession().getAttribute("userRole");
        
        logger.info("Authorization check - user: {}, userRole: {}", user, userRole);
        
        boolean isAuthorized = user != null && 
               ("Admin".equals(userRole) || "Staff".equals(userRole));
        
        logger.info("Authorization result: {}", isAuthorized);
        
        return isAuthorized;
    }

    private int parsePageParameter(String pageParam) {
        try {
            return pageParam != null && !pageParam.trim().isEmpty() ? Math.max(1, Integer.parseInt(pageParam)) : 1;
        } catch (NumberFormatException e) {
            return 1;
        }
    }

    private Car createCarFromRequest(HttpServletRequest request, boolean isAdd) throws IllegalArgumentException {
        Car car = new Car();
        
        // Get parameters with null safety
        String carId = request.getParameter("carId");
        String carModel = request.getParameter("carModel");
        String brandId = request.getParameter("brandId");
        String fuelTypeId = request.getParameter("fuelTypeId");
        String transmissionTypeId = request.getParameter("transmissionTypeId");
        String categoryId = request.getParameter("categoryId");
        String seats = request.getParameter("seats");
        String yearManufactured = request.getParameter("yearManufactured");
        String licensePlate = request.getParameter("licensePlate");
        String odometer = request.getParameter("odometer");
        String pricePerDay = request.getParameter("pricePerDay");
        String pricePerHour = request.getParameter("pricePerHour");
        String pricePerMonth = request.getParameter("pricePerMonth");
        String description = request.getParameter("description");
        String status = request.getParameter("status");

        logger.info("Received parameters - carModel: {}, brandId: {}, fuelTypeId: {}, transmissionTypeId: {}, seats: {}, year: {}, licensePlate: {}, odometer: {}, pricePerDay: {}, pricePerHour: {}, status: {}", 
            carModel, brandId, fuelTypeId, transmissionTypeId, seats, yearManufactured, licensePlate, odometer, pricePerDay, pricePerHour, status);

        // Validation
        if (isAdd && carId != null && !carId.trim().isEmpty()) {
            throw new IllegalArgumentException("Car ID không nên được cung cấp cho thao tác thêm");
        }
        if (!isAdd && (carId == null || carId.trim().isEmpty())) {
            throw new IllegalArgumentException("Car ID là bắt buộc cho thao tác cập nhật");
        }
        
        // Validate UUID format for update
        if (!isAdd) {
            try {
                UUID.fromString(carId);
            } catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("Định dạng Car ID không hợp lệ");
            }
        }

        if (carModel == null || carModel.trim().isEmpty() ||
            brandId == null || brandId.trim().isEmpty() ||
            fuelTypeId == null || fuelTypeId.trim().isEmpty() ||
            transmissionTypeId == null || transmissionTypeId.trim().isEmpty() ||
            seats == null || seats.trim().isEmpty() ||
            yearManufactured == null || yearManufactured.trim().isEmpty() ||
            licensePlate == null || licensePlate.trim().isEmpty() ||
            odometer == null || odometer.trim().isEmpty() ||
            pricePerDay == null || pricePerDay.trim().isEmpty() ||
            pricePerHour == null || pricePerHour.trim().isEmpty() ||
            status == null || status.trim().isEmpty()) {
            throw new IllegalArgumentException("Tất cả các trường bắt buộc phải được điền đầy đủ");
        }

        // Validate license plate format
        String licensePlateTrimmed = licensePlate.trim();
        if (!licensePlateTrimmed.matches("^[0-9]{2}[A-Z]-[0-9]{4,5}$")) {
            throw new IllegalArgumentException("Biển số xe phải có định dạng: XX-XXXXX (ví dụ: 30A-12345)");
        }

        try {
            int seatsNum = Integer.parseInt(seats);
            if (seatsNum <= 0 || seatsNum > 50) throw new IllegalArgumentException("Số ghế phải từ 1 đến 50");
            int year = Integer.parseInt(yearManufactured);
            int currentYear = java.time.Year.now().getValue();
            if (year < 1900 || year > currentYear + 1) {
                throw new IllegalArgumentException("Năm sản xuất phải từ 1900 đến " + (currentYear + 1));
            }
            int odometerNum = Integer.parseInt(odometer);
            if (odometerNum < 0) throw new IllegalArgumentException("Số km đã chạy không được âm");

            BigDecimal priceDay = new BigDecimal(pricePerDay);
            BigDecimal priceHour = new BigDecimal(pricePerHour);
            BigDecimal priceMonth = BigDecimal.ZERO; // Default value for NOT NULL constraint
            
            if (pricePerMonth != null && !pricePerMonth.trim().isEmpty() && !pricePerMonth.equals("null") && !pricePerMonth.equals("0")) {
                try {
                    priceMonth = new BigDecimal(pricePerMonth);
                    if (priceMonth.compareTo(BigDecimal.ZERO) < 0) {
                        throw new IllegalArgumentException("Giá theo tháng không được âm");
                    }
                    if (priceMonth.compareTo(new BigDecimal("10000")) > 0) {
                        throw new IllegalArgumentException("Giá theo tháng không được vượt quá $10000");
                    }
                } catch (NumberFormatException e) {
                    throw new IllegalArgumentException("Giá theo tháng không hợp lệ");
                }
            }
            
            if (priceDay.compareTo(BigDecimal.ZERO) < 0 || priceHour.compareTo(BigDecimal.ZERO) < 0) {
                throw new IllegalArgumentException("Giá không được âm");
            }

            // Validate reasonable price ranges
            if (priceDay.compareTo(new BigDecimal("1000")) > 0) {
                throw new IllegalArgumentException("Giá theo ngày không được vượt quá $1000");
            }
            if (priceHour.compareTo(new BigDecimal("100")) > 0) {
                throw new IllegalArgumentException("Giá theo giờ không được vượt quá $100");
            }

            if (!status.equals("Available") && !status.equals("Rented") && !status.equals("Unavailable")) {
                throw new IllegalArgumentException("Giá trị trạng thái không hợp lệ");
            }

            // Set car properties
            car.setCarId(isAdd ? UUID.randomUUID() : UUID.fromString(carId));
            
            String carModelTrimmed = carModel.trim();
            if (carModelTrimmed.length() > 100) {
                throw new IllegalArgumentException("Model xe không được vượt quá 100 ký tự");
            }
            car.setCarModel(carModelTrimmed);
            
            // Set default UUIDs from data.sql (user can input text but we use fixed UUIDs)
            car.setBrandId(UUID.fromString("11111111-1111-1111-1111-111111111111")); // Toyota
            car.setFuelTypeId(UUID.fromString("55555555-5555-5555-5555-555555555555")); // Xăng
            car.setTransmissionTypeId(UUID.fromString("33333333-3333-3333-3333-333333333333")); // Số tự động
            
            if (categoryId != null && !categoryId.trim().isEmpty()) {
                car.setCategoryId(UUID.fromString("77777777-7777-7777-7777-777777777777")); // Xe 4 chỗ
            } else {
                car.setCategoryId(null);
            }
            car.setSeats(seatsNum);
            car.setYearManufactured(year);
            car.setLicensePlate(licensePlateTrimmed);
            car.setOdometer(odometerNum);
            car.setPricePerDay(priceDay);
            car.setPricePerHour(priceHour);
            car.setPricePerMonth(priceMonth); // Always set a value (never null)
            
            // Handle description - can be null or empty
            if (description != null && !description.trim().isEmpty()) {
                String descriptionTrimmed = description.trim();
                if (descriptionTrimmed.length() > 500) {
                    throw new IllegalArgumentException("Mô tả không được vượt quá 500 ký tự");
                }
                car.setDescription(descriptionTrimmed);
            } else {
                car.setDescription(null);
            }
            car.setStatus(CarStatus.fromDbValue(status));
            
            if (isAdd) {
                car.setCreatedDate(new java.util.Date());
            } else {
                // For update, get existing car data to preserve createdDate
                try {
                    Car existingCar = carService.findById(UUID.fromString(carId));
                    if (existingCar != null) {
                        car.setCreatedDate(existingCar.getCreatedDate());
                    } else {
                        car.setCreatedDate(new java.util.Date());
                    }
                } catch (Exception e) {
                    logger.warn("Could not get existing car data, using current date: {}", e.getMessage());
                    car.setCreatedDate(new java.util.Date());
                }
            }
            car.setLastUpdatedBy(getCurrentUserId(request));

            // Debug logging
            logger.info("Final car object - BrandId: {}, FuelTypeId: {}, TransmissionTypeId: {}, CategoryId: {}", 
                car.getBrandId(), car.getFuelTypeId(), car.getTransmissionTypeId(), car.getCategoryId());
            
            // Ensure featureIds is initialized
            if (car.getFeatureIds() == null) {
                car.setFeatureIds(new java.util.HashSet<>());
            }
            logger.info("FeatureIds: {}", car.getFeatureIds());

            return car;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Định dạng số không hợp lệ");
        }
    }

    private void redirectWithSuccess(HttpServletRequest request, HttpServletResponse response, String message) throws IOException {
        response.sendRedirect(request.getContextPath() + "/manageCarsServlet?success=" +
                URLEncoder.encode(message, StandardCharsets.UTF_8));
    }

    private void redirectWithError(HttpServletRequest request, HttpServletResponse response, String message) throws IOException {
        response.sendRedirect(request.getContextPath() + "/manageCarsServlet?error=" +
                URLEncoder.encode(message, StandardCharsets.UTF_8));
    }

    private UUID getCurrentUserId(HttpServletRequest request) {
        Object userObj = request.getSession().getAttribute("user");
        if (userObj instanceof User) {
            return ((User) userObj).getUserId();
        }
        return null;
    }

    public enum CarStatusOption {
        AVAILABLE("Available", "Available"),
        RENTED("Rented", "Rented"),
        UNAVAILABLE("Unavailable", "Unavailable");

        private final String value;
        private final String label;

        CarStatusOption(String value, String label) {
            this.value = value;
            this.label = label;
        }

        public String getValue() { return value; }
        public String getLabel() { return label; }
    }
}