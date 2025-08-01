package Controller.Booking;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonSerializer;
import com.google.gson.JsonElement;
import com.google.gson.JsonSerializationContext;
import com.google.gson.JsonDeserializer;
import com.google.gson.JsonDeserializationContext;
import com.google.gson.JsonParseException;
import Model.Entity.Booking.Booking;
import Repository.Booking.BookingRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.lang.reflect.Type;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet("/api/car-availability")
public class CarAvailabilityServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(CarAvailabilityServlet.class.getName());
    private final BookingRepository bookingRepository = new BookingRepository();
    private final Gson gson = new GsonBuilder()
        .registerTypeAdapter(LocalDateTime.class, new JsonSerializer<LocalDateTime>() {
            @Override
            public JsonElement serialize(LocalDateTime src, Type typeOfSrc, JsonSerializationContext context) {
                return context.serialize(src.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME));
            }
        })
        .registerTypeAdapter(LocalDateTime.class, new JsonDeserializer<LocalDateTime>() {
            @Override
            public LocalDateTime deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context)
                    throws JsonParseException {
                return LocalDateTime.parse(json.getAsString(), DateTimeFormatter.ISO_LOCAL_DATE_TIME);
            }
        })
        .create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        try {
            String carIdStr = request.getParameter("carId");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String testMode = request.getParameter("test");

            LOGGER.info("CarAvailabilityServlet called with carId: " + carIdStr);

            // Test mode để kiểm tra database
            if ("true".equals(testMode)) {
                System.out.println("=== TEST MODE ===");
                LOGGER.info("=== TEST MODE ===");
                try {
                    List<Booking> allBookings = bookingRepository.findAll();
                    System.out.println("Test: Total bookings in database: " + allBookings.size());
                    LOGGER.info("Test: Total bookings in database: " + allBookings.size());
                    
                    for (int i = 0; i < Math.min(allBookings.size(), 5); i++) {
                        Booking booking = allBookings.get(i);
                        System.out.println("Test: Booking " + i + " - CarId: " + booking.getCarId() + 
                                   ", Status: " + booking.getStatus());
                        LOGGER.info("Test: Booking " + i + " - CarId: " + booking.getCarId() + 
                                   ", Status: " + booking.getStatus());
                    }
                    
                    String responseText = "{\"test\": \"success\", \"totalBookings\": " + allBookings.size() + "}";
                    System.out.println("Sending response: " + responseText);
                    response.getWriter().write(responseText);
                    return;
                } catch (Exception e) {
                    System.out.println("Test mode error: " + e.getMessage());
                    e.printStackTrace();
                    LOGGER.severe("Test mode error: " + e.getMessage());
                    e.printStackTrace();
                    response.getWriter().write("{\"test\": \"error\", \"message\": \"" + e.getMessage() + "\"}");
                    return;
                }
            }

            if (carIdStr == null || carIdStr.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\": \"Car ID is required\"}");
                return;
            }

            UUID carId = UUID.fromString(carIdStr);
            LOGGER.info("Parsed carId: " + carId);

            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");
            LocalDateTime startDate = null;
            LocalDateTime endDate = null;

            if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                startDate = LocalDateTime.parse(startDateStr, formatter);
            }
            if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                endDate = LocalDateTime.parse(endDateStr, formatter);
            }

            List<Booking> conflictingBookings = getConflictingBookings(carId, startDate, endDate);

            AvailabilityResponse availabilityResponse = new AvailabilityResponse();
            availabilityResponse.setCarId(carId.toString());
            availabilityResponse.setConflictingBookings(conflictingBookings);
            availabilityResponse.setHasConflicts(!conflictingBookings.isEmpty());

            String jsonResponse = gson.toJson(availabilityResponse);
            LOGGER.info("Sending response: " + jsonResponse);
            response.getWriter().write(jsonResponse);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking car availability", e);
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"Internal server error: " + e.getMessage() + "\"}");
        }
    }

    private List<Booking> getConflictingBookings(UUID carId, LocalDateTime startDate, LocalDateTime endDate) {
        try {
            System.out.println("=== Starting getConflictingBookings ===");
            LOGGER.info("=== Starting getConflictingBookings ===");
            System.out.println("Requested carId: " + carId);
            LOGGER.info("Requested carId: " + carId);
            System.out.println("StartDate: " + startDate);
            LOGGER.info("StartDate: " + startDate);
            System.out.println("EndDate: " + endDate);
            LOGGER.info("EndDate: " + endDate);
            
            // Bước 1: Lấy tất cả booking từ database
            System.out.println("Step 1: Getting all bookings from database...");
            LOGGER.info("Step 1: Getting all bookings from database...");
            List<Booking> allBookings = bookingRepository.findAll();
            System.out.println("Total bookings found: " + allBookings.size());
            LOGGER.info("Total bookings found: " + allBookings.size());
            
            if (allBookings.isEmpty()) {
                System.out.println("No bookings found in database");
                LOGGER.info("No bookings found in database");
                return new java.util.ArrayList<>();
            }
            
            // Bước 2: Log tất cả booking để debug
            System.out.println("Step 2: Logging all bookings...");
            LOGGER.info("Step 2: Logging all bookings...");
            for (int i = 0; i < allBookings.size(); i++) {
                Booking booking = allBookings.get(i);
                try {
                    System.out.println("Booking " + i + ": Car ID = " + booking.getCarId() + 
                               ", Status = " + booking.getStatus() + 
                               ", Start = " + booking.getPickupDateTime() + 
                               ", End = " + booking.getReturnDateTime());
                    LOGGER.info("Booking " + i + ": Car ID = " + booking.getCarId() + 
                               ", Status = " + booking.getStatus() + 
                               ", Start = " + booking.getPickupDateTime() + 
                               ", End = " + booking.getReturnDateTime());
                } catch (Exception e) {
                    System.out.println("Error logging booking " + i + ": " + e.getMessage());
                    LOGGER.warning("Error logging booking " + i + ": " + e.getMessage());
                }
            }
            
            // Bước 3: Filter theo carId
            System.out.println("Step 3: Filtering by carId...");
            LOGGER.info("Step 3: Filtering by carId...");
            String[] restrictedStatuses = {"DepositPaid", "ContractSigned", "InProgress"};
            
            List<Booking> carBookings = new java.util.ArrayList<>();
            for (Booking booking : allBookings) {
                try {
                    if (booking.getCarId() != null && booking.getCarId().equals(carId)) {
                        carBookings.add(booking);
                        System.out.println("Found booking for car " + carId + ": Status = " + booking.getStatus());
                        LOGGER.info("Found booking for car " + carId + ": Status = " + booking.getStatus());
                    }
                } catch (Exception e) {
                    System.out.println("Error checking car match: " + e.getMessage());
                    LOGGER.warning("Error checking car match: " + e.getMessage());
                }
            }
            System.out.println("Bookings for car " + carId + ": " + carBookings.size());
            LOGGER.info("Bookings for car " + carId + ": " + carBookings.size());
            
            // Bước 4: Filter theo status
            System.out.println("Step 4: Filtering by restricted statuses...");
            LOGGER.info("Step 4: Filtering by restricted statuses...");
            List<Booking> restrictedBookings = new java.util.ArrayList<>();
            for (Booking booking : carBookings) {
                try {
                    String status = booking.getStatus();
                    for (String restrictedStatus : restrictedStatuses) {
                        if (restrictedStatus.equals(status)) {
                            restrictedBookings.add(booking);
                            System.out.println("Found restricted booking: Status = " + status + 
                                       ", Start = " + booking.getPickupDateTime() + 
                                       ", End = " + booking.getReturnDateTime());
                            LOGGER.info("Found restricted booking: Status = " + status + 
                                       ", Start = " + booking.getPickupDateTime() + 
                                       ", End = " + booking.getReturnDateTime());
                            break;
                        }
                    }
                } catch (Exception e) {
                    System.out.println("Error checking status match: " + e.getMessage());
                    LOGGER.warning("Error checking status match: " + e.getMessage());
                }
            }
            System.out.println("Restricted bookings found: " + restrictedBookings.size());
            LOGGER.info("Restricted bookings found: " + restrictedBookings.size());

            // Bước 5: Trả về kết quả
            if (startDate != null && endDate != null) {
                System.out.println("Step 5a: Checking conflicts with date range...");
                LOGGER.info("Step 5a: Checking conflicts with date range...");
                List<Booking> conflictingBookings = new java.util.ArrayList<>();
                for (Booking booking : restrictedBookings) {
                    try {
                        LocalDateTime bookingStart = booking.getPickupDateTime();
                        LocalDateTime bookingEnd = booking.getReturnDateTime();
                        boolean hasConflict = !(endDate.isBefore(bookingStart) || startDate.isAfter(bookingEnd));
                        if (hasConflict) {
                            conflictingBookings.add(booking);
                            System.out.println("Found conflicting booking: " + bookingStart + " to " + bookingEnd);
                            LOGGER.info("Found conflicting booking: " + bookingStart + " to " + bookingEnd);
                        }
                    } catch (Exception e) {
                        System.out.println("Error checking date conflict: " + e.getMessage());
                        LOGGER.warning("Error checking date conflict: " + e.getMessage());
                    }
                }
                System.out.println("Conflicting bookings: " + conflictingBookings.size());
                LOGGER.info("Conflicting bookings: " + conflictingBookings.size());
                return conflictingBookings;
            } else {
                System.out.println("Step 5b: Returning all restricted bookings for Flatpickr: " + restrictedBookings.size());
                LOGGER.info("Step 5b: Returning all restricted bookings for Flatpickr: " + restrictedBookings.size());
                return restrictedBookings;
            }

        } catch (Exception e) {
            System.out.println("Error getting conflicting bookings: " + e.getMessage());
            e.printStackTrace();
            LOGGER.log(Level.SEVERE, "Error getting conflicting bookings", e);
            e.printStackTrace();
            return new java.util.ArrayList<>();
        }
    }

    public static class AvailabilityResponse {
        private String carId;
        private List<Booking> conflictingBookings;
        private boolean hasConflicts;

        public String getCarId() { return carId; }
        public void setCarId(String carId) { this.carId = carId; }

        public List<Booking> getConflictingBookings() { return conflictingBookings; }
        public void setConflictingBookings(List<Booking> conflictingBookings) {
            this.conflictingBookings = conflictingBookings;
        }

        public boolean isHasConflicts() { return hasConflicts; }
        public void setHasConflicts(boolean hasConflicts) { this.hasConflicts = hasConflicts; }
    }
} 