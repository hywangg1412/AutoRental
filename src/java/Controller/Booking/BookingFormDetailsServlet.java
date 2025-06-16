package Controller.Booking;

import Model.DTO.CarDetailDTO;
import Service.Car.CarDetailService;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/booking/form/details")
public class BookingFormDetailsServlet extends HttpServlet {

    private final CarDetailService carDetailService = new CarDetailService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null) {
                response.sendRedirect(request.getContextPath() + "/car.jsp");
                return;
            }

            UUID carId = UUID.fromString(idParam);
            CarDetailDTO carDto = carDetailService.getCarDetail(carId);

            request.setAttribute("car", carDto);
            request.getRequestDispatcher("/pages/booking-form/booking-form-details.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không tìm thấy xe hoặc xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
