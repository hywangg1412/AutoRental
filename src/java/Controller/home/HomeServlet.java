package Controller.Home;

import Model.DTO.CarListItemDTO;
import Service.Car.CarListService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/pages/home")
public class HomeServlet extends HttpServlet {

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
            request.setAttribute("carList", carList);
            request.getRequestDispatcher("/pages/index.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Đã xảy ra lỗi hệ thống.");
        }
    }
}