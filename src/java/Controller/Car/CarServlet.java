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
            

            int page = 1, limit = 6;
            if (request.getParameter("page") != null) page = Integer.parseInt(request.getParameter("page"));
            int offset = (page - 1) * limit;

  
            List<CarListItemDTO> carList = carListService.filterCars(brandIds, fuelTypeIds, seats, categoryIds, statuses, featureIds, transmissionTypeIds, sort, keyword, offset, limit);
            int totalCars = carListService.countFilteredCars(brandIds, fuelTypeIds, seats, categoryIds, statuses, featureIds, transmissionTypeIds, keyword);
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
