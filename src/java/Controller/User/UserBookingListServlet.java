package Controller.User;

import Model.DTO.BookingInfoDTO;
import Model.Entity.Booking.Booking;
import Model.Entity.Car.Car;
import Model.Entity.User.User;
import Model.Constants.BookingStatusConstants;
import Repository.Car.CarRepository;
import Repository.Car.CarImageRepository;
import Service.Booking.BookingService;
import Service.Car.CarImageService;
import Utils.SessionUtil;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.Map;
import java.util.HashMap;

@WebServlet("/user/my-trip")
public class UserBookingListServlet extends HttpServlet {
    private BookingService bookingService;
    private CarRepository carRepository;
    private CarImageRepository carImageRepository;
    private CarImageService carImageService;

    @Override
    public void init() {
        bookingService = new BookingService();
        carRepository = new CarRepository();
        carImageService = new CarImageService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) SessionUtil.getSessionAttribute(request, "user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }
        try {
            UUID userId = user.getUserId();
            List<Booking> bookings = bookingService.findByUserId(userId);
            List<BookingInfoDTO> currentTrips = new ArrayList<>();
            List<BookingInfoDTO> pastTrips = new ArrayList<>();

            List<UUID> carIds = new ArrayList<>();
            for (Booking booking : bookings) {
                if (booking.getCarId() != null) {
                    carIds.add(booking.getCarId());
                }
            }

            Map<UUID, Car> carMap = new HashMap<>();
            for (UUID carId : carIds) {
                Car car = carRepository.findById(carId);
                if (car != null) {
                    carMap.put(carId, car);
                }
            }
            Map<UUID, String> carImageMap = new HashMap<>();
            for (UUID carId : carIds) {
                String imgUrl = carImageService.getMainImageUrlByCarId(carId);
                carImageMap.put(carId, imgUrl);
            }
            for (Booking booking : bookings) {
                BookingInfoDTO dto = new BookingInfoDTO();
                dto.setBookingId(booking.getBookingId());
                dto.setBookingCode(booking.getBookingCode());
                dto.setPickupDateTime(booking.getPickupDateTime());
                dto.setReturnDateTime(booking.getReturnDateTime());
                dto.setTotalAmount(booking.getTotalAmount());
                dto.setStatus(booking.getStatus());
                dto.setCreatedDate(booking.getCreatedDate());
                dto.setCustomerName(booking.getCustomerName());
                dto.setCustomerEmail(booking.getCustomerEmail());
                dto.setCustomerPhone(booking.getCustomerPhone());
                dto.setDriverLicenseImageUrl(booking.getDriverLicenseImageUrl());
                Car car = carMap.get(booking.getCarId());
                if (car != null) {
                    dto.setCarModel(car.getCarModel());
                    dto.setCarLicensePlate(car.getLicensePlate());
                    dto.setCarStatus(car.getStatus() != null ? car.getStatus().getValue() : "");
                }
                String carImg = carImageMap.getOrDefault(booking.getCarId(), "/images/car-default.jpg");
                dto.setCarImage(carImg);
                if (booking.getPickupDateTime() != null && booking.getReturnDateTime() != null) {
                    long duration = java.time.Duration.between(booking.getPickupDateTime(), booking.getReturnDateTime()).toDays();
                    dto.setDuration(duration > 0 ? duration : 1);
                }
                if (BookingStatusConstants.PENDING.equals(booking.getStatus()) || 
                    BookingStatusConstants.CONFIRMED.equals(booking.getStatus()) || 
                    BookingStatusConstants.IN_PROGRESS.equals(booking.getStatus()) ||
                    BookingStatusConstants.DEPOSIT_PAID.equals(booking.getStatus()) ||
                    BookingStatusConstants.CONTRACT_SIGNED.equals(booking.getStatus())) {
                    currentTrips.add(dto);
                } else {
                    // pastTrips.add(dto);
                }
            }
            
            request.setAttribute("currentTrips", currentTrips);
            request.setAttribute("pastTrips", pastTrips);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Cannot load booking list: " + e.getMessage());
        }
        request.getRequestDispatcher("/pages/user/my-trip.jsp").forward(request, response);
    }
}