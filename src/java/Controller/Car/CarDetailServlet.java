package Controller.Car;

import Model.DTO.CarDetailDTO;
import Service.Car.CarDetailService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/pages/car-single")
public class CarDetailServlet extends HttpServlet {

    private CarDetailService carDetailService;

    @Override
    public void init() throws ServletException {
        carDetailService = new CarDetailService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        System.out.println("📥 Nhận request với id: " + idParam);

        if (idParam == null || idParam.trim().isEmpty()) {
            System.out.println("❌ ID null hoặc rỗng");
            response.sendRedirect(request.getContextPath() + "/notfound.jsp");
            return;
        }

        try {
            UUID carId = UUID.fromString(idParam);
            System.out.println("✅ ID hợp lệ: " + carId);

            CarDetailDTO car = carDetailService.getCarDetail(carId);
            if (car == null) {
                System.out.println("❌ Không tìm thấy xe trong CarDetailService");
                response.sendRedirect(request.getContextPath() + "/notfound.jsp");
                return;
            }

            // Log thông tin DTO để kiểm tra
            System.out.println("🚗 Car model: " + car.getCarModel());
            System.out.println("🏷 Brand: " + car.getBrandName());
            System.out.println("⛽ Fuel: " + car.getFuelName());
            System.out.println("⚙ Transmission: " + car.getTransmissionName());
            System.out.println("🖼 Số ảnh: " + (car.getImageUrls() != null ? car.getImageUrls().size() : 0));

            request.setAttribute("car", car);
            request.getRequestDispatcher("/pages/car-single.jsp").forward(request, response);

        } catch (IllegalArgumentException e) {
            System.out.println("❌ ID sai định dạng UUID: " + idParam);
            response.sendRedirect(request.getContextPath() + "/notfound.jsp");

        } catch (Exception e) {
            System.out.println("❌ Lỗi khi xử lý chi tiết xe: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/notfound.jsp");
        }
    }
}
