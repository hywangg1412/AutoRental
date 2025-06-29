package Controller.Car;

import Model.Entity.Car.Car;
import Service.Car.CarService;
import Exception.EmptyDataException;
import Model.DTO.CarListItemDTO;
import Service.Car.CarListService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;
import java.util.Arrays;
import Service.Car.CarBrandService;
import Service.Car.FuelTypeService;
import Service.Car.CarCategoriesService;
import Service.Car.CarFeatureService;
import Model.DTO.StatusOption;
import Service.Car.TransmissionTypeService;

@WebServlet(urlPatterns = {"/pages/car", "/pages/car-list-fragment"})
public class CarServlet extends HttpServlet {

    private CarListService carListService;
    private CarService carService;
    private CarBrandService carBrandService;
    private FuelTypeService fuelTypeService;
    private CarCategoriesService carCategoriesService;
    private CarFeatureService carFeatureService;
    private TransmissionTypeService transmissionTypeService;

    @Override
    public void init() throws ServletException {
        carListService = new CarListService();
        carService = new CarService();
        carBrandService = new CarBrandService();
        fuelTypeService = new FuelTypeService();
        carCategoriesService = new CarCategoriesService();
        carFeatureService = new CarFeatureService();
        transmissionTypeService = new TransmissionTypeService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String[] brandIds = request.getParameterValues("brandId");
            String[] fuelTypeIds = request.getParameterValues("fuelTypeId");
            String[] seats = request.getParameterValues("seat");
            String[] categoryIds = request.getParameterValues("categoryId");
            String[] statuses = request.getParameterValues("status");
            String[] featureIds = request.getParameterValues("featureId");
            String[] transmissionTypeIds = request.getParameterValues("transmissionTypeId");
            String sort = request.getParameter("sort");
            String keyword = request.getParameter("keyword");
            
            // New range filter parameters
            Integer minPricePerHour = null, maxPricePerHour = null;
            Integer minSeats = null, maxSeats = null;
            Integer minYear = null, maxYear = null;
            Integer minOdometer = null, maxOdometer = null;
            Integer minDistance = null, maxDistance = null;
            
            if (request.getParameter("minPricePerHour") != null && !request.getParameter("minPricePerHour").isEmpty()) {
                minPricePerHour = Integer.parseInt(request.getParameter("minPricePerHour"));
            }
            if (request.getParameter("maxPricePerHour") != null && !request.getParameter("maxPricePerHour").isEmpty()) {
                maxPricePerHour = Integer.parseInt(request.getParameter("maxPricePerHour"));
            }
            if (request.getParameter("minSeats") != null && !request.getParameter("minSeats").isEmpty()) {
                minSeats = Integer.parseInt(request.getParameter("minSeats"));
            }
            if (request.getParameter("maxSeats") != null && !request.getParameter("maxSeats").isEmpty()) {
                maxSeats = Integer.parseInt(request.getParameter("maxSeats"));
            }
            if (request.getParameter("minYear") != null && !request.getParameter("minYear").isEmpty()) {
                minYear = Integer.parseInt(request.getParameter("minYear"));
            }
            if (request.getParameter("maxYear") != null && !request.getParameter("maxYear").isEmpty()) {
                maxYear = Integer.parseInt(request.getParameter("maxYear"));
            }
            if (request.getParameter("minOdometer") != null && !request.getParameter("minOdometer").isEmpty()) {
                minOdometer = Integer.parseInt(request.getParameter("minOdometer"));
            }
            if (request.getParameter("maxOdometer") != null && !request.getParameter("maxOdometer").isEmpty()) {
                maxOdometer = Integer.parseInt(request.getParameter("maxOdometer"));
            }
            if (request.getParameter("minDistance") != null && !request.getParameter("minDistance").isEmpty()) {
                minDistance = Integer.parseInt(request.getParameter("minDistance"));
            }
            if (request.getParameter("maxDistance") != null && !request.getParameter("maxDistance").isEmpty()) {
                maxDistance = Integer.parseInt(request.getParameter("maxDistance"));
            }

            int page = 1, limit = 6;
            if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page"));
            int offset = (page - 1) * limit;

            List<CarListItemDTO> carList = carListService.filterCars(brandIds, fuelTypeIds, seats, categoryIds, statuses, featureIds, transmissionTypeIds, sort, keyword, minPricePerHour, maxPricePerHour, minSeats, maxSeats, minYear, maxYear, minOdometer, maxOdometer, minDistance, maxDistance, offset, limit);
            int totalCars = carListService.countFilteredCars(brandIds, fuelTypeIds, seats, categoryIds, statuses, featureIds, transmissionTypeIds, keyword, minPricePerHour, maxPricePerHour, minSeats, maxSeats, minYear, maxYear, minOdometer, maxOdometer, minDistance, maxDistance);
            int totalPages = (int) Math.ceil((double) totalCars / limit);

            request.setAttribute("carList", carList);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("keyword", keyword);

            // Truyền các list filter sang JSP
            request.setAttribute("brandList", carBrandService.getAll());
            request.setAttribute("fuelTypeList", fuelTypeService.getAll());
            request.setAttribute("seatList", carService.getAllSeatNumbers());
            request.setAttribute("categoryList", carCategoriesService.getAll());
            request.setAttribute("featureList", carFeatureService.getAll());
            request.setAttribute("transmissionTypeList", transmissionTypeService.getAll());
            request.setAttribute("statusList", Arrays.asList(
                new StatusOption("Available", "Available"),
                new StatusOption("Rented", "Rented"),
                new StatusOption("Unavailable", "Unavailable")
            ));
            request.setAttribute("paramNames", request.getParameterMap().keySet());
            request.setAttribute("paramValues", request.getParameterMap());

            String requestURI = request.getRequestURI();
            if (requestURI.contains("car-list-fragment")) {
                request.getRequestDispatcher("/pages/car/car-list-fragment.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/pages/car/car.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request.");
        }
    }
}
