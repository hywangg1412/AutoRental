package Controller.Staff;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Constants.BookingStatusConstants;
import Model.DTO.PendingInspectionDTO;
import Model.Entity.Booking.Booking;
import Model.Entity.Car.Car;
import Model.Entity.Car.CarConditionLogs;
import Model.Entity.User.User;
import Service.Booking.BookingService;
import Service.Car.CarConditionService;
import Service.Car.CarService;
import Service.External.CloudinaryService;
import Service.NotificationService;
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
            out.print("{\"success\":false,\"message\":\"Không thể xác định người dùng\"}");
            return;
        }
        
        // Get action parameter
        String action = request.getParameter("action");
        if (action == null) {
            out.print("{\"success\":false,\"message\":\"Thiếu tham số action\"}");
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
                out.print("{\"success\":false,\"message\":\"Hành động không hợp lệ\"}");
                break;
        }
    }
    
    private void handleAjaxRequest(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String type = request.getParameter("type");
        if (type == null) {
            out.print("{\"success\":false,\"message\":\"Thiếu tham số type\"}");
            return;
        }
        
        switch (type) {
            case "getBookingDetails":
                getBookingDetails(request, response);
                break;
            default:
                out.print("{\"success\":false,\"message\":\"Loại yêu cầu không hợp lệ\"}");
                break;
        }
    }
    
    private void getBookingDetails(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null) {
            out.print("{\"success\":false,\"message\":\"Thiếu bookingId\"}");
            return;
        }
        
        try {
            UUID bookingId = UUID.fromString(bookingIdStr);
            Booking booking = bookingService.findById(bookingId);
            if (booking == null) {
                out.print("{\"success\":false,\"message\":\"Không tìm thấy booking\"}");
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
            out.print("{\"success\":false,\"message\":\"Lỗi: " + e.getMessage() + "\"}");
        }
    }
    
    private void submitInspection(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        
        try {
            // Get staff ID from session
            String userIdStr = (String) SessionUtil.getSessionAttribute(request, "userId");
            if (userIdStr == null) {
                out.print("{\"success\":false,\"message\":\"Bạn cần đăng nhập để thực hiện chức năng này\"}");
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
                // Cập nhật status booking thành Completed
                bookingService.updateBookingStatus(bookingId, BookingStatusConstants.COMPLETED);

                // Gửi notification cho user
                Booking booking = bookingService.findById(bookingId);
                if (booking != null) {
                    notificationService.sendNotificationToUser(
                            booking.getUserId(),
                            "Xe của bạn đã được kiểm tra và hoàn tất trả xe. Mã booking: " + booking.getBookingCode());
                }
                
                out.print("{\"success\":true,\"message\":\"Đã lưu thông tin kiểm tra xe thành công\"}");
            } else {
                out.print("{\"success\":false,\"message\":\"Không thể lưu thông tin kiểm tra xe\"}");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error submitting inspection: {0}", e.getMessage());
            out.print("{\"success\":false,\"message\":\"Lỗi: " + e.getMessage() + "\"}");
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
                out.print("{\"success\":false,\"message\":\"Thiếu thông tin booking hoặc log\"}");
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
                            "Xe của bạn đã được trả thành công. Mã booking: " + booking.getBookingCode());
                }
                
                out.print("{\"success\":true,\"message\":\"Đã chấp nhận trả xe thành công\"}");
            } else {
                out.print("{\"success\":false,\"message\":\"Không thể chấp nhận trả xe\"}");
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error accepting return: {0}", e.getMessage());
            out.print("{\"success\":false,\"message\":\"Lỗi: " + e.getMessage() + "\"}");
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
    
    
} 