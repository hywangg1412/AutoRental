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

@WebServlet("/pages/car")
public class CarServlet extends HttpServlet {

    private CarListService carListService;

    @Override
    public void init() throws ServletException {
        carListService = new CarListService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<CarListItemDTO> carList = carListService.getAll(); 
            System.out.println("Số lượng xe lấy được: " + carList.size());
            request.setAttribute("carList", carList);
            request.getRequestDispatcher("/pages/car.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi hệ thống.");
        }
    }
}
