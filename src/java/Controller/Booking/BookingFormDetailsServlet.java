//package Controller.Booking;
//
//import java.io.IOException;
//import java.util.UUID;
//
//import Model.DTO.CarDetailDTO;
//import Service.Car.CarDetailService;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//
//@WebServlet("/booking/form/details")
//public class BookingFormDetailsServlet extends HttpServlet {
//
//    private final CarDetailService carDetailService = new CarDetailService();
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        try {
//            String idParam = request.getParameter("id");
//            if (idParam == null) {
//                response.sendRedirect(request.getContextPath() + "/car.jsp");
//                return;
//            }
//
//            UUID carId = UUID.fromString(idParam);
//            CarDetailDTO carDto = carDetailService.getCarDetail(carId);
//
//            request.setAttribute("car", carDto);
//            request.getRequestDispatcher("/pages/booking-form/booking-form-details.jsp").forward(request, response);
//
//        } catch (Exception e) {
//            e.printStackTrace();
//            request.setAttribute("error", "Không tìm thấy xe hoặc xảy ra lỗi: " + e.getMessage());
//            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
//        }
//    }
//}



package Controller.Booking;

import Model.DTO.CarDetailDTO;
import Model.Entity.User.DriverLicense;
import Model.Entity.User.User;
import Service.Car.CarDetailService;
import Service.User.DriverLicenseService;
import Utils.SessionUtil;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/booking/form/details")
public class BookingFormDetailsServlet extends HttpServlet {

    private final CarDetailService carDetailService = new CarDetailService();
    private final DriverLicenseService driverLicenseService = new DriverLicenseService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // Check user login
            User user = (User) SessionUtil.getSessionAttribute(request, "user");
            if (user == null) {
                response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
                return;
            }

            String idParam = request.getParameter("id");
            if (idParam == null) {
                response.sendRedirect(request.getContextPath() + "/car.jsp");
                return;
            }

            UUID carId = UUID.fromString(idParam);
            CarDetailDTO carDto = carDetailService.getCarDetail(carId);

            // Check if user has uploaded driver license
            DriverLicense driverLicense = null;
            boolean hasDriverLicense = false;
            try {
                driverLicense = driverLicenseService.findByUserId(user.getUserId());
                hasDriverLicense = (driverLicense != null && driverLicense.getLicenseImage() != null);
            } catch (Exception e) {
                // User doesn't have driver license yet
                hasDriverLicense = false;
            }

            // Set attributes for JSP
            request.setAttribute("car", carDto);
            request.setAttribute("hasDriverLicense", hasDriverLicense);
            request.setAttribute("driverLicense", driverLicense);
            
            request.getRequestDispatcher("/pages/booking-form/booking-form-details.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không tìm thấy xe hoặc xảy ra lỗi: " + e.getMessage());
            request.getRequestDispatcher("/pages/error.jsp").forward(request, response);
        }
    }
}