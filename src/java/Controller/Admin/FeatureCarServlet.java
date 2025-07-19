package Controller.Admin;

import Model.Entity.Car.CarFeature;
import Service.Car.CarFeatureService;
import Service.Car.CarFeaturesMappingService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.*;
import org.json.JSONArray;
import org.json.JSONObject;

@WebServlet("/FeatureCarServlet")
public class FeatureCarServlet extends HttpServlet {
    private CarFeatureService carFeatureService = new CarFeatureService();
    private CarFeaturesMappingService mappingService = new CarFeaturesMappingService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String carIdStr = req.getParameter("carId");
        String carModel = req.getParameter("carModel");
        String accept = req.getHeader("Accept");
        try {
            List<CarFeature> allFeatures = carFeatureService.getAll();
            List<CarFeature> selected = new ArrayList<>();
            if (carIdStr != null && !carIdStr.isEmpty()) {
                try {
                    UUID carId = UUID.fromString(carIdStr);
                    selected = carFeatureService.findByCarId(carId);
                } catch (Exception ignored) {}
            }
            // Nếu là AJAX/json thì trả về json như cũ
            if (accept != null && accept.contains("application/json")) {
                JSONObject result = new JSONObject();
                result.put("allFeatures", new JSONArray(allFeatures.stream().map(f -> {
                    JSONObject o = new JSONObject();
                    o.put("featureId", f.getFeatureId().toString());
                    o.put("featureName", f.getFeatureName());
                    return o;
                }).toList()));
                result.put("selectedFeatures", new JSONArray(selected.stream().map(f -> f.getFeatureId().toString()).toList()));
                resp.setContentType("application/json");
                resp.getWriter().write(result.toString());
                return;
            }
            // Còn lại thì forward sang JSP
            req.setAttribute("allFeatures", allFeatures);
            req.setAttribute("selectedFeatures", selected.stream().map(CarFeature::getFeatureId).toList());
            req.setAttribute("carId", carIdStr);
            req.setAttribute("carModel", carModel);
            req.getRequestDispatcher("/pages/admin/car-feature-modal.jsp").forward(req, resp);
        } catch (Exception e) {
            resp.setStatus(500);
            resp.setContentType("text/plain");
            resp.getWriter().write("Lỗi: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String carIdStr = req.getParameter("carId");
            String[] featureIds = req.getParameterValues("featureId");
            UUID carId = UUID.fromString(carIdStr);
            // Xóa hết mapping cũ
            List<CarFeature> old = carFeatureService.findByCarId(carId);
            for (CarFeature f : old) {
                mappingService.deleteByCarAndFeature(carId, f.getFeatureId());
            }
            // Thêm mapping mới
            if (featureIds != null) {
                for (String fid : featureIds) {
                    mappingService.addMapping(carId, UUID.fromString(fid));
                }
            }
            resp.sendRedirect(req.getContextPath() + "/manageCarsServlet?success=updateFeature");
        } catch (Exception e) {
            resp.setStatus(500);
            resp.setContentType("text/plain");
            resp.getWriter().write("Lỗi: " + e.getMessage());
        }
    }
} 