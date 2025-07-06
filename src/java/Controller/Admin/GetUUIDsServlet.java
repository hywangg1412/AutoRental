package Controller.Admin;

import Service.Car.CarBrandService;
import Service.Car.FuelTypeService;
import Service.Car.TransmissionTypeService;
import Service.Car.CarListService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

@WebServlet("/getUUIDsServlet")
public class GetUUIDsServlet extends HttpServlet {
    private static final Logger logger = LoggerFactory.getLogger(GetUUIDsServlet.class);
    private static final CarBrandService carBrandService = new CarBrandService();
    private static final FuelTypeService fuelTypeService = new FuelTypeService();
    private static final TransmissionTypeService transmissionTypeService = new TransmissionTypeService();
    private static final CarListService carListService = new CarListService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Load all the data needed for UUIDs
            request.setAttribute("brandList", carBrandService.getAll() != null ? carBrandService.getAll() : new java.util.ArrayList<>());
            request.setAttribute("fuelTypeList", fuelTypeService.getAll() != null ? fuelTypeService.getAll() : new java.util.ArrayList<>());
            request.setAttribute("transmissionTypeList", transmissionTypeService.getAll() != null ? transmissionTypeService.getAll() : new java.util.ArrayList<>());
            request.setAttribute("carList", carListService.getAll() != null ? carListService.getAll() : new java.util.ArrayList<>());
            
            request.getRequestDispatcher("/pages/admin/get-uuids.jsp").forward(request, response);
        } catch (Exception e) {
            logger.error("Error loading UUIDs data: {}", e.getMessage(), e);
            String errorMessage = URLEncoder.encode("Unable to load UUIDs data: " + e.getMessage(), StandardCharsets.UTF_8);
            response.sendRedirect(request.getContextPath() + "/manageCarsServlet?error=" + errorMessage);
        }
    }
} 