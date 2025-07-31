package Controller.Staff;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Constants.BookingStatusConstants;
import Model.DTO.PendingInspectionDTO;
import Model.Entity.Booking.Booking;
import Model.Entity.Booking.BookingSurcharges;
import Model.Entity.Car.Car;
import Model.Entity.Car.CarConditionLogs;
import Model.Entity.User.User;
import Service.Booking.BookingService;
import Service.Car.CarConditionService;
import Service.Car.CarService;
import Service.External.CloudinaryService;
import Service.NotificationService;
import Repository.Booking.BookingSurchargesRepository;
import Utils.SessionUtil;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.stream.Collectors;
import org.json.JSONArray;
import org.json.JSONObject;
import java.util.Collection;
import java.util.Map;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet(name = "StaffCarConditionServlet", urlPatterns = {"/staff/car-condition"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class StaffCarConditionServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(StaffCarConditionServlet.class.getName());
    private final CarConditionService carConditionService = new CarConditionService();
    private final BookingService bookingService = new BookingService();
    private final CarService carService = new CarService();
    private final NotificationService notificationService = new NotificationService();
    private final CloudinaryService cloudinaryService = new CloudinaryService();
    private final Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set character encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        
        // Check staff login
        String userIdStr = (String) SessionUtil.getSessionAttribute(request, "userId");
        UUID staffId = null;
        try {
            staffId = UUID.fromString(userIdStr);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Cannot convert userId from String to UUID: {0}", e.getMessage());
        }
        
        if (staffId == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }
        
        // Check for AJAX request
        String isAjax = request.getParameter("ajax");
        if (isAjax != null && isAjax.equals("true")) {
            handleAjaxRequest(request, response);
            return;
        }
        
        try {
            // Get recent inspections
            List<CarConditionLogs> recentInspections = new ArrayList<>();
            try {
                recentInspections = carConditionService.findRecentInspections(5);
            } catch (EmptyDataException e) {
                LOGGER.log(Level.INFO, "No recent inspections found");
            }
            List<PendingInspectionDTO> dtos = new ArrayList<>();
            for (CarConditionLogs log : recentInspections) {
                PendingInspectionDTO dto = new PendingInspectionDTO();
                // Lấy booking, car, user từ log
                Booking booking = bookingService.findById(log.getBookingId());
                Car car = carService.findById(booking.getCarId());
                // Set các trường inspection
                dto.setCheckType(log.getCheckType());
                dto.setConditionStatus(log.getConditionStatus());
                dto.setFuelLevel(log.getFuelLevel());
                dto.setConditionDescription(log.getConditionDescription());
                dto.setDamageImages(log.getDamageImages());
                dto.setNote(log.getNote());
                dto.setCheckTime(log.getCheckTime());
                dto.setLogId(log.getLogId());
                dto.setOdometer(log.getOdometer());
                // Set các trường booking/car/user
                dto.setCarModel(car.getCarModel());
                dto.setLicensePlate(car.getLicensePlate());
                dto.setCustomerName(booking.getCustomerName());
                dto.setReturnDateTime(booking.getReturnDateTime());
                dtos.add(dto);
            }
            request.setAttribute("recentInspections", dtos);
            
            // Get pending inspections
            List<CarConditionLogs> pendingInspections = new ArrayList<>();
            try {
                // Get bookings with PendingInspection status
                List<Booking> pendingBookings = bookingService.findByStatus(BookingStatusConstants.PENDING_INSPECTION);
                
                // For each booking, get car details and create a data transfer object
                List<PendingInspectionDTO> pendingInspectionDTOs = new ArrayList<>();
                for (Booking booking : pendingBookings) {
                    PendingInspectionDTO dto = new PendingInspectionDTO();
                    dto.setBookingId(booking.getBookingId());
                    dto.setBookingCode(booking.getBookingCode());
                    
                    try {
                        Car car = carService.findById(booking.getCarId());
                        if (car != null) {
                            dto.setCarId(car.getCarId());
                            dto.setCarModel(car.getCarModel());
                            dto.setLicensePlate(car.getLicensePlate());
                        }
                    } catch (Exception e) {
                        LOGGER.log(Level.WARNING, "Error getting car details: {0}", e.getMessage());
                    }
                    
                    dto.setCustomerName(booking.getCustomerName());
                    dto.setReturnDateTime(booking.getReturnDateTime());
                    dto.setStatus(booking.getStatus());
                    
                    pendingInspectionDTOs.add(dto);
                }
                
                request.setAttribute("pendingInspections", pendingInspectionDTOs);
            } catch (SQLException e) {
                LOGGER.log(Level.SEVERE, "Error getting pending inspections: {0}", e.getMessage());
            }
            
            // Forward to the JSP page
            request.getRequestDispatcher("/pages/staff/staff-car-condition.jsp").forward(request, response);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in doGet: {0}", e.getMessage());
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Internal server error");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set character encoding
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        // Check staff login
        String userIdStr = (String) SessionUtil.getSessionAttribute(request, "userId");
        UUID staffId = null;
        try {
            staffId = UUID.fromString(userIdStr);
        } catch (Exception e) {
            LOGGER.log(Level.WARNING, "Cannot convert userId from String to UUID: {0}", e.getMessage());
            out.print("{\"success\":false,\"message\":\"Cannot identify user\"}");
            return;
        }
        
        // Get action parameter
        String action = request.getParameter("action");
        if (action == null) {
            out.print("{\"success\":false,\"message\":\"Missing action parameter\"}");
            return;
        }
        
        switch (action) {
            case "submitInspection":
                submitInspection(request, response);
                break;
            case "acceptReturn":
                handleAcceptReturn(request, response, staffId);
                break;
            default:
                out.print("{\"success\":false,\"message\":\"Invalid action\"}");
                break;
        }
    }
    
    private void handleAjaxRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String type = request.getParameter("type");
        if (type == null) {
            out.print("{\"success\":false,\"message\":\"Missing type parameter\"}");
            return;
        }
        
        switch (type) {
            case "getBookingDetails":
                getBookingDetails(request, response);
                break;
            default:
                out.print("{\"success\":false,\"message\":\"Invalid request type\"}");
                break;
        }
    }
    
    private void getBookingDetails(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null) {
            out.print("{\"success\":false,\"message\":\"Missing bookingId\"}");
            return;
        }
        
        try {
            UUID bookingId = UUID.fromString(bookingIdStr);
            Booking booking = bookingService.findById(bookingId);
            if (booking == null) {
                out.print("{\"success\":false,\"message\":\"Booking not found\"}");
                return;
            }
            
            JSONObject result = new JSONObject();
            result.put("success", true);
            
            JSONObject bookingData = new JSONObject();
            bookingData.put("bookingId", booking.getBookingId().toString());
            bookingData.put("bookingCode", booking.getBookingCode());
            bookingData.put("customerName", booking.getCustomerName());
            LocalDateTime returnDateTime = booking.getReturnDateTime();
            if (returnDateTime != null) {
                String formatted = returnDateTime.format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"));
                bookingData.put("returnDateTime", formatted);
            } else {
                bookingData.put("returnDateTime", "");
            }
            
            // Get car details
            Car car = carService.findById(booking.getCarId());
            if (car != null) {
                bookingData.put("carId", car.getCarId().toString());
                bookingData.put("carModel", car.getCarModel());
                bookingData.put("licensePlate", car.getLicensePlate());
                bookingData.put("odometer", car.getOdometer());
            }
            
            result.put("data", bookingData);
            out.print(result.toString());
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting booking details: {0}", e.getMessage());
            out.print("{\"success\":false,\"message\":\"Error: " + e.getMessage() + "\"}");
        }
    }
    
    private void submitInspection(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            // Get staff ID from session
            String userIdStr = (String) SessionUtil.getSessionAttribute(request, "userId");
            if (userIdStr == null) {
                out.print("{\"success\":false,\"message\":\"You need to login to perform this function\"}");
                return;
            }
            UUID staffId = UUID.fromString(userIdStr);
            
            // Get form data
            UUID bookingId = UUID.fromString(request.getParameter("bookingId"));
            UUID carId = UUID.fromString(request.getParameter("carId"));
            String checkType = request.getParameter("checkType");
            Integer odometer = null;
            if (request.getParameter("odometer") != null && !request.getParameter("odometer").isEmpty()) {
                odometer = Integer.parseInt(request.getParameter("odometer"));
            }
            String fuelLevel = request.getParameter("fuelLevel");
            String conditionStatus = request.getParameter("conditionStatus");
            String conditionDescription = request.getParameter("conditionDescription");
            String note = request.getParameter("note");
            
            // Handle image uploads
            Collection<Part> fileParts = request.getParts();
            JSONArray imageUrlsArray = new JSONArray();
            
            for (Part filePart : fileParts) {
                if (filePart.getName().equals("damageImages") && filePart.getSize() > 0) {
                    // Tải ảnh lên Cloudinary
                    try {
                        // Tạo tên folder và public_id cho ảnh
                        String folderName = "car_condition_logs";
                        String publicId = "damage_" + bookingId.toString() + "_" + System.currentTimeMillis();
                        
                        // Upload ảnh và lấy URL
                        Map uploadResult = cloudinaryService.uploadImageToFolder(filePart.getInputStream().readAllBytes(), folderName);
                        String imageUrl = cloudinaryService.getImageUrlAfterUpload(uploadResult);
                        
                        // Thêm URL vào mảng JSON
                        if (imageUrl != null && !imageUrl.isEmpty()) {
                            imageUrlsArray.put(imageUrl);
                        }
                    } catch (Exception e) {
                        LOGGER.log(Level.SEVERE, "Error uploading image to Cloudinary: {0}", e.getMessage());
                    }
                }
            }
            
            String damageImages = imageUrlsArray.toString();
            
            // Create inspection log
            CarConditionLogs log = carConditionService.createInspection(
                    bookingId, carId, staffId, checkType, odometer, fuelLevel,
                    conditionStatus, conditionDescription, damageImages, note);
            
            if (log != null) {
                // Tạo phụ phí dựa trên kết quả kiểm tra
                createSurchargesFromInspection(bookingId, log, request);
                
                // Cập nhật status booking thành InspectionCompleted
                bookingService.updateBookingStatus(bookingId, BookingStatusConstants.INSPECTION_COMPLETED);

                // Gửi notification cho user
                Booking booking = bookingService.findById(bookingId);
                if (booking != null) {
                    notificationService.sendNotificationToUser(
                            booking.getUserId(),
                            "Your car has been inspected. Please check the final payment details and complete the remaining payment. Booking code: " + booking.getBookingCode());
                }
                
                out.print("{\"success\":true,\"message\":\"Car inspection information saved successfully. Customer can now pay the remaining amount.\"}");
            } else {
                out.print("{\"success\":false,\"message\":\"Cannot save car inspection information\"}");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error submitting inspection: {0}", e.getMessage());
            out.print("{\"success\":false,\"message\":\"Error: " + e.getMessage() + "\"}");
        }
    }
    
    private void handleAcceptReturn(HttpServletRequest request, HttpServletResponse response, UUID staffId) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            // Get parameters
            String bookingIdStr = request.getParameter("bookingId");
            String logIdStr = request.getParameter("logId");
            
            if (bookingIdStr == null || logIdStr == null) {
                out.print("{\"success\":false,\"message\":\"Missing booking or log information\"}");
                return;
            }
            
            UUID bookingId = UUID.fromString(bookingIdStr);
            UUID logId = UUID.fromString(logIdStr);
            
            // Accept return
            boolean success = carConditionService.acceptReturnCar(bookingId, logId);
            
            if (success) {
                // Send notification to user
                Booking booking = bookingService.findById(bookingId);
                if (booking != null) {
                    notificationService.sendNotificationToUser(
                            booking.getUserId(),
                            "Your car has been returned successfully. Booking code: " + booking.getBookingCode() + ". You can provide feedback now.");
                }
                
                out.print("{\"success\":true,\"message\":\"Car return accepted successfully\"}");
            } else {
                out.print("{\"success\":false,\"message\":\"Cannot accept car return\"}");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error accepting return: {0}", e.getMessage());
            out.print("{\"success\":false,\"message\":\"Error: " + e.getMessage() + "\"}");
        }
    }
    
    private String getSubmittedFileName(Part part) {
        for (String cd : part.getHeader("content-disposition").split(";")) {
            if (cd.trim().startsWith("filename")) {
                String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
                return fileName.substring(fileName.lastIndexOf('/') + 1).substring(fileName.lastIndexOf('\\') + 1);
            }
        }
        return null;
    }
    
    /**
     * Create surcharges based on car inspection results
     */
    private void createSurchargesFromInspection(UUID bookingId, CarConditionLogs inspection, HttpServletRequest request) {
        try {
            BookingSurchargesRepository surchargesRepository = new BookingSurchargesRepository();
            
            // Lấy thông tin booking để tính toán
            Booking booking = bookingService.findById(bookingId);
            if (booking == null) return;
            
            // Kiểm tra trả xe muộn
            String lateReturnHours = request.getParameter("lateReturnHours");
            if (lateReturnHours != null && !lateReturnHours.isEmpty()) {
                try {
                    double hours = Double.parseDouble(lateReturnHours);
                    if (hours > 0) {
                        double lateReturnFee = (hours * 50000) / 1000; // 50,000 VND/hour -> DB unit
                        createSurcharge(bookingId, "LateReturn", lateReturnFee, 
                            "Late return fee: " + hours + " hours", "Penalty", surchargesRepository);
                    }
                } catch (NumberFormatException e) {
                    LOGGER.warning("Invalid late return hours: " + lateReturnHours);
                }
            }
            
            // Kiểm tra thiếu nhiên liệu
            String fuelShortage = request.getParameter("fuelShortage");
            if ("true".equals(fuelShortage)) {
                String fuelPrice = request.getParameter("fuelPrice");
                double fuelFee = 0; // Không có base fee, chỉ tính theo input
                if (fuelPrice != null && !fuelPrice.isEmpty()) {
                    try {
                        // Input từ staff là VND, cần chuyển về DB unit
                        double fuelPriceVnd = Double.parseDouble(fuelPrice);
                        // Giới hạn số tiền hợp lý (tối đa 10 triệu VND)
                        if (fuelPriceVnd > 10000000) {
                            fuelPriceVnd = 10000000;
                            LOGGER.warning("Fuel price too high, capped at 10,000,000 VND");
                        }
                        fuelFee = fuelPriceVnd / 1000; // Convert VND to DB unit
                        LOGGER.info("Fuel price input: " + fuelPriceVnd + " VND -> " + fuelFee + " DB unit");
                    } catch (NumberFormatException e) {
                        LOGGER.warning("Invalid fuel price: " + fuelPrice);
                    }
                }
                createSurcharge(bookingId, "FuelShortage", fuelFee, 
                    "Fuel shortage fee", "Fuel", surchargesRepository);
            }
            
            // Kiểm tra vi phạm giao thông
            String trafficViolations = request.getParameter("trafficViolations");
            if ("true".equals(trafficViolations)) {
                String violationFine = request.getParameter("violationFine");
                double totalFee = 0; // Không có base fee, chỉ tính theo input
                if (violationFine != null && !violationFine.isEmpty()) {
                    try {
                        // Input từ staff là VND, cần chuyển về DB unit
                        double violationFineVnd = Double.parseDouble(violationFine);
                        // Giới hạn số tiền hợp lý (tối đa 10 triệu VND)
                        if (violationFineVnd > 10000000) {
                            violationFineVnd = 10000000;
                            LOGGER.warning("Violation fine too high, capped at 10,000,000 VND");
                        }
                        totalFee = violationFineVnd / 1000; // Convert VND to DB unit
                        LOGGER.info("Violation fine input: " + violationFineVnd + " VND -> " + totalFee + " DB unit");
                    } catch (NumberFormatException e) {
                        LOGGER.warning("Invalid violation fine: " + violationFine);
                    }
                }
                createSurcharge(bookingId, "TrafficViolations", totalFee, 
                    "Traffic violation fee", "Traffic", surchargesRepository);
            }
            
            // Kiểm tra vệ sinh xe
            String excessiveCleaning = request.getParameter("excessiveCleaning");
            if ("true".equals(excessiveCleaning)) {
                createSurcharge(bookingId, "ExcessiveCleaning", 200, 
                    "Car cleaning fee", "Cleaning", surchargesRepository); // 200,000 VND -> 200 DB unit
            }
            
            // Kiểm tra hư hỏng nhỏ
            String minorDamage = request.getParameter("minorDamage");
            if ("true".equals(minorDamage)) {
                String damageAmount = request.getParameter("damageAmount");
                double damageFee = 100; // Default minimum 100,000 VND -> 100 DB unit
                if (damageAmount != null && !damageAmount.isEmpty()) {
                    try {
                        // Input từ staff là VND, cần chuyển về DB unit
                        double damageAmountVnd = Double.parseDouble(damageAmount);
                        // Giới hạn số tiền hợp lý (tối đa 5 triệu VND)
                        if (damageAmountVnd > 5000000) {
                            damageAmountVnd = 5000000;
                            LOGGER.warning("Damage amount too high, capped at 5,000,000 VND");
                        }
                        damageFee = damageAmountVnd / 1000; // Convert VND to DB unit
                        if (damageFee < 100) damageFee = 100; // Min 100,000 VND
                        if (damageFee > 500) damageFee = 500; // Max 500,000 VND
                        LOGGER.info("Damage amount input: " + damageAmountVnd + " VND -> " + damageFee + " DB unit");
                    } catch (NumberFormatException e) {
                        LOGGER.warning("Invalid damage amount: " + damageAmount);
                    }
                }
                createSurcharge(bookingId, "MinorDamage", damageFee, 
                    "Minor damage repair fee", "Damage", surchargesRepository);
            }
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating surcharges: {0}", e.getMessage());
        }
    }
    
    /**
     * Tạo một phụ phí
     */
    private void createSurcharge(UUID bookingId, String surchargeType, double amount, 
                                String description, String category, BookingSurchargesRepository repository) {
        try {
            BookingSurcharges surcharge = new BookingSurcharges();
            surcharge.setSurchargeId(UUID.randomUUID());
            surcharge.setBookingId(bookingId);
            surcharge.setSurchargeType(surchargeType);
            surcharge.setAmount(amount);
            surcharge.setDescription(description);
            surcharge.setCreatedDate(LocalDateTime.now());
            surcharge.setSurchargeCategory(category);
            surcharge.setSystemGenerated(false);
            
            repository.add(surcharge);
            LOGGER.info("Created surcharge: " + surchargeType + " - " + amount + " (DB unit) = " + (amount * 1000) + " VND");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating surcharge: {0}", e.getMessage());
        }
    }
} 