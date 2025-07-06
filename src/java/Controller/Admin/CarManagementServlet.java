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
        if (!isAuthorized(request)) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/access-denied.jsp");
            return;
        }

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
            String errorMessage = URLEncoder.encode("Unable to load car management page: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/manageCarsServlet?error=" + errorMessage);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!isAuthorized(request)) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/access-denied.jsp");
            return;
        }

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
            redirectWithError(request, response, "Error processing request: " + e.getMessage());
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
                redirectWithSuccess(request, response, "Car deleted successfully");
            } catch (Exception e) {
                redirectWithError(request, response, "Error deleting car: " + e.getMessage());
            }
        } else {
            redirectWithError(request, response, "Car ID is required for deletion");
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
                redirectWithError(request, response, "Action is required");
                return;
            }

            switch (action.toLowerCase()) {
                case "add":
                    Car newCar = createCarFromRequest(request, true);
                    carService.add(newCar);
                    redirectWithSuccess(request, response, "Car added successfully. You can now upload images separately.");
                    break;

                case "update":
                    Car updatedCar = createCarFromRequest(request, false);
                    // Validate that car exists before update
                    Car existingCar = carService.findById(updatedCar.getCarId());
                    if (existingCar == null) {
                        redirectWithError(request, response, "Car not found for update");
                        return;
                    }
                    carService.update(updatedCar);
                    redirectWithSuccess(request, response, "Car updated successfully");
                    break;

                default:
                    redirectWithError(request, response, "Invalid action");
            }
        } catch (IllegalArgumentException e) {
            logger.warn("Validation error: {}", e.getMessage());
            redirectWithError(request, response, e.getMessage());
        } catch (Exception e) {
            logger.error("Error processing regular form: {}", e.getMessage());
            redirectWithError(request, response, "Error processing form: " + e.getMessage());
        }
    }



    private boolean isAuthorized(HttpServletRequest request) {
        return request.getSession().getAttribute("user") != null &&
               ("Admin".equals(request.getSession().getAttribute("userRole")) || "Staff".equals(request.getSession().getAttribute("userRole")));
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

        // Validation
        if (isAdd && carId != null && !carId.trim().isEmpty()) {
            throw new IllegalArgumentException("Car ID should not be provided for add operation");
        }
        if (!isAdd && (carId == null || carId.trim().isEmpty())) {
            throw new IllegalArgumentException("Car ID is required for update operation");
        }
        
        // Validate UUID format for update
        if (!isAdd) {
            try {
                UUID.fromString(carId);
            } catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("Invalid Car ID format");
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
            throw new IllegalArgumentException("All required fields must be filled");
        }

        // Validate license plate format
        String licensePlateTrimmed = licensePlate.trim();
        if (!licensePlateTrimmed.matches("^[0-9]{2}[A-Z]-[0-9]{4,5}$")) {
            throw new IllegalArgumentException("License plate must be in format: XX-XXXXX (e.g., 30A-12345)");
        }

        try {
            int seatsNum = Integer.parseInt(seats);
            if (seatsNum <= 0 || seatsNum > 50) throw new IllegalArgumentException("Seats must be between 1 and 50");
            int year = Integer.parseInt(yearManufactured);
            int currentYear = java.time.Year.now().getValue();
            if (year < 1900 || year > currentYear + 1) {
                throw new IllegalArgumentException("Year manufactured must be between 1900 and " + (currentYear + 1));
            }
            int odometerNum = Integer.parseInt(odometer);
            if (odometerNum < 0) throw new IllegalArgumentException("Odometer cannot be negative");

            BigDecimal priceDay = new BigDecimal(pricePerDay);
            BigDecimal priceHour = new BigDecimal(pricePerHour);
            BigDecimal priceMonth = BigDecimal.ZERO; // Default value for NOT NULL constraint
            
            if (pricePerMonth != null && !pricePerMonth.trim().isEmpty() && !pricePerMonth.equals("null")) {
                priceMonth = new BigDecimal(pricePerMonth);
                if (priceMonth.compareTo(BigDecimal.ZERO) < 0) {
                    throw new IllegalArgumentException("Price per month cannot be negative");
                }
            }
            
            if (priceDay.compareTo(BigDecimal.ZERO) < 0 || priceHour.compareTo(BigDecimal.ZERO) < 0) {
                throw new IllegalArgumentException("Prices cannot be negative");
            }

            // Validate reasonable price ranges
            if (priceDay.compareTo(new BigDecimal("1000")) > 0) {
                throw new IllegalArgumentException("Price per day cannot exceed $1000");
            }
            if (priceHour.compareTo(new BigDecimal("100")) > 0) {
                throw new IllegalArgumentException("Price per hour cannot exceed $100");
            }
            if (priceMonth.compareTo(new BigDecimal("10000")) > 0) {
                throw new IllegalArgumentException("Price per month cannot exceed $10000");
            }

            if (!status.equals("Available") && !status.equals("Rented") && !status.equals("Unavailable")) {
                throw new IllegalArgumentException("Invalid status value");
            }

            // Set car properties
            car.setCarId(isAdd ? UUID.randomUUID() : UUID.fromString(carId));
            
            String carModelTrimmed = carModel.trim();
            if (carModelTrimmed.length() > 100) {
                throw new IllegalArgumentException("Car model cannot exceed 100 characters");
            }
            car.setCarModel(carModelTrimmed);
            
            // Validate and set foreign keys
            try {
                car.setBrandId(UUID.fromString(brandId));
                car.setFuelTypeId(UUID.fromString(fuelTypeId));
                car.setTransmissionTypeId(UUID.fromString(transmissionTypeId));
                car.setCategoryId(categoryId != null && !categoryId.trim().isEmpty() ? UUID.fromString(categoryId) : null);
            } catch (IllegalArgumentException e) {
                throw new IllegalArgumentException("Invalid UUID format for one of the foreign keys");
            }
            car.setSeats(seatsNum);
            car.setYearManufactured(year);
            car.setLicensePlate(licensePlateTrimmed);
            car.setOdometer(odometerNum);
            car.setPricePerDay(priceDay);
            car.setPricePerHour(priceHour);
            car.setPricePerMonth(priceMonth); // Always set a value (never null)
            String descriptionTrimmed = description != null ? description.trim() : "";
            if (descriptionTrimmed.length() > 500) {
                throw new IllegalArgumentException("Description cannot exceed 500 characters");
            }
            car.setDescription(descriptionTrimmed);
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

            return car;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Invalid numeric format");
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