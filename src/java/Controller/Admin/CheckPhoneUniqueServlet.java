package Controller.Admin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.UUID;
import com.google.gson.Gson;
import com.google.gson.JsonObject;

import Model.Entity.User.User;
import Service.User.UserService;

@WebServlet(name = "CheckPhoneUniqueServlet", urlPatterns = {"/admin/check-phone-unique"})
public class CheckPhoneUniqueServlet extends HttpServlet {
    
    private UserService userService;
    private Gson gson;

    @Override
    public void init() {
        userService = new UserService();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        JsonObject jsonResponse = new JsonObject();
        
        try {
            String phoneNumber = request.getParameter("phoneNumber");
            String userIdParam = request.getParameter("userId");
            
            if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
                jsonResponse.addProperty("isUnique", false);
                jsonResponse.addProperty("message", "Số điện thoại không được để trống");
            } else {
                phoneNumber = phoneNumber.trim();
                
                // Check if phone number format is valid
                if (!phoneNumber.matches("^0\\d{9,10}$")) {
                    jsonResponse.addProperty("isUnique", false);
                    jsonResponse.addProperty("message", "Số điện thoại không đúng định dạng");
                } else {
                    UUID excludeUserId = null;
                    if (userIdParam != null && !userIdParam.trim().isEmpty()) {
                        try {
                            excludeUserId = UUID.fromString(userIdParam);
                        } catch (IllegalArgumentException e) {
                            // Invalid UUID format, treat as new user
                            excludeUserId = null;
                        }
                    }
                    
                    boolean isUnique = userService.isPhoneNumberUnique(phoneNumber, excludeUserId);
                    jsonResponse.addProperty("isUnique", isUnique);
                    jsonResponse.addProperty("message", isUnique ? "Số điện thoại có thể sử dụng" : "Số điện thoại đã tồn tại trong hệ thống");
                }
            }
            
        } catch (Exception e) {
            jsonResponse.addProperty("isUnique", false);
            jsonResponse.addProperty("message", "Lỗi kiểm tra số điện thoại: " + e.getMessage());
        }
        
        response.getWriter().write(gson.toJson(jsonResponse));
    }
} 