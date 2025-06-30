package Controller.User;

import Model.DTO.BookingInfoDTO;
import Model.Entity.Booking.Booking;
import Model.Entity.Car.Car;
import Model.Entity.User.User;
import Repository.Car.CarRepository;
import Service.Booking.BookingService;
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

@WebServlet("/user/my-trip")
public class UserBookingListServlet extends HttpServlet {
    private BookingService bookingService;
    private CarRepository carRepository;

    @Override
    public void init() {
        bookingService = new BookingService();
        carRepository = new CarRepository();
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
            List<BookingInfoDTO> dtos = new ArrayList<>();
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
                // Lấy thông tin xe
                Car car = carRepository.findById(booking.getCarId());
                if (car != null) {
                    dto.setCarModel(car.getCarModel());
                    dto.setCarLicensePlate(car.getLicensePlate());
                    dto.setCarStatus(car.getStatus() != null ? car.getStatus().getValue() : "");
                }
                // Tính duration
                if (booking.getPickupDateTime() != null && booking.getReturnDateTime() != null) {
                    long duration = java.time.Duration.between(booking.getPickupDateTime(), booking.getReturnDateTime()).toDays();
                    dto.setDuration(duration > 0 ? duration : 1);
                }
                dtos.add(dto);
            }
            request.setAttribute("bookingRequests", dtos);
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Cannot load booking list: " + e.getMessage());
        }
        request.getRequestDispatcher("/pages/user/my-trip.jsp").forward(request, response);
    }
}