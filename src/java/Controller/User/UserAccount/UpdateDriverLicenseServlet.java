package Controller.User.UserAccount;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Service.External.CloudinaryService;
import Model.Entity.User.DriverLicense;
import Service.User.DriverLicenseService;
import Model.Entity.User.User;
import Exception.NotFoundException;
import java.util.UUID;
import jakarta.servlet.http.HttpSession;
import java.io.InputStream;
import jakarta.servlet.http.Part;
import com.google.gson.Gson;
import java.util.HashMap;
import java.util.Map;
import Utils.FormatUtils;

@WebServlet(name = "UpdateDriverLicenseServlet", urlPatterns = {"/user/update-driver-license"})
@MultipartConfig
public class UpdateDriverLicenseServlet extends HttpServlet {

    private CloudinaryService cloudinaryService;
    private DriverLicenseService driverLicenseService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        cloudinaryService = new CloudinaryService();
        driverLicenseService = new DriverLicenseService();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            response.sendRedirect(request.getContextPath() + "/user/profile");
            return;
        }

        try {
            if ("uploadImage".equals(action)) {
                handleImageUpload(request, response, session, user);
            } else if ("updateInfo".equals(action)) {
                handleInfoUpdate(request, response, session, user);
            } else {
                response.sendRedirect(request.getContextPath() + "/user/profile");
            }
        } catch (Exception e) {
            session.setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/user/profile");
        }
    }

    private void handleImageUpload(HttpServletRequest request, HttpServletResponse response, HttpSession session, User user) 
            throws ServletException, IOException {
        Part filePart = request.getPart("licenseImage");
        if (filePart == null || filePart.getSize() == 0) {
            session.setAttribute("error", "No image file provided");
            response.sendRedirect(request.getContextPath() + "/user/profile");
            return;
        }

        try (InputStream inputStream = filePart.getInputStream()) {
            String publicId = "driver_license_" + user.getUserId();
            String imageUrl = cloudinaryService.uploadAndGetUrlToFolder(inputStream, "driver_license", publicId);
            
            DriverLicense license = null;
            boolean isNewLicense = false;
            try {
                license = driverLicenseService.findByUserId(user.getUserId());
            } catch (NotFoundException e) {
                license = new DriverLicense();
                license.setLicenseId(UUID.randomUUID());
                license.setUserId(user.getUserId());
                license.setCreatedDate(java.time.LocalDateTime.now());
                isNewLicense = true;
            }
            
            license.setLicenseImage(imageUrl);
            
            if (isNewLicense) {
                driverLicenseService.add(license);
            } else {
                driverLicenseService.update(license);
            }
            
            session.setAttribute("success", "Driver license image updated successfully");
            
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                Map<String, Object> responseData = new HashMap<>();
                responseData.put("success", true);
                responseData.put("message", "Driver license image updated successfully");
                responseData.put("imageUrl", imageUrl);
                response.getWriter().write(gson.toJson(responseData));
            } else {
                response.sendRedirect(request.getContextPath() + "/user/profile");
            }
        } catch (Exception e) {
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                Map<String, Object> responseData = new HashMap<>();
                responseData.put("success", false);
                responseData.put("message", "Failed to upload image: " + e.getMessage());
                response.getWriter().write(gson.toJson(responseData));
            } else {
                session.setAttribute("error", "Failed to upload image: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/user/profile");
            }
        }
    }

    private void handleInfoUpdate(HttpServletRequest request, HttpServletResponse response, HttpSession session, User user) 
            throws ServletException, IOException {
        String licenseNumber = request.getParameter("licenseNumber");
        String fullName = request.getParameter("fullName");
        String dob = request.getParameter("dob");

        if (licenseNumber == null || !licenseNumber.matches("^[0-9]{12}$")) {
            handleError(request, response, session, "License number must be exactly 12 digits");
            return;
        }
        if (fullName == null || !fullName.matches("^[\\p{L} ]+$")) {
            handleError(request, response, session, "Full name must not contain special characters or numbers");
            return;
        }
        if (dob == null) {
            handleError(request, response, session, "Date of birth is required");
            return;
        }

        try {
            // Xử lý Date of Birth với định dạng dd/MM/yyyy
            java.time.LocalDate dobDate = FormatUtils.parseDateSafely(dob);
            if (dobDate == null) {
                handleError(request, response, session, "Invalid date of birth format. Please use dd/MM/yyyy format");
                return;
            }
            java.time.LocalDate today = java.time.LocalDate.now();
            if (dobDate.isAfter(today)) {
                handleError(request, response, session, "Date of birth cannot be in the future");
                return;
            }
            int age = today.getYear() - dobDate.getYear();
            if (today.getMonthValue() < dobDate.getMonthValue() || 
                (today.getMonthValue() == dobDate.getMonthValue() && today.getDayOfMonth() < dobDate.getDayOfMonth())) {
                age--;
            }
            if (age < 18) {
                handleError(request, response, session, "You must be at least 18 years old to register a driver license");
                return;
            }

            DriverLicense license = null;
            boolean isNewLicense = false;
            try {
                license = driverLicenseService.findByUserId(user.getUserId());
            } catch (NotFoundException e) {
                license = new DriverLicense();
                license.setLicenseId(UUID.randomUUID());
                license.setUserId(user.getUserId());
                license.setCreatedDate(java.time.LocalDateTime.now());
                isNewLicense = true;
            }
            
            license.setLicenseNumber(licenseNumber);
            license.setFullName(fullName);
            license.setDob(dobDate);
            
            if (isNewLicense) {
                driverLicenseService.add(license);
            } else {
                driverLicenseService.update(license);
            }
            
            session.setAttribute("success", "Driver license information updated successfully");
            
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                Map<String, Object> responseData = new HashMap<>();
                responseData.put("success", true);
                responseData.put("message", "Driver license information updated successfully");
                response.getWriter().write(gson.toJson(responseData));
            } else {
                response.sendRedirect(request.getContextPath() + "/user/profile");
            }
        } catch (Exception e) {
            handleError(request, response, session, "Failed to update information: " + e.getMessage());
        }
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, HttpSession session, String errorMessage) 
            throws IOException {
        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", false);
            responseData.put("message", errorMessage);
            response.getWriter().write(gson.toJson(responseData));
        } else {
            session.setAttribute("error", errorMessage);
            response.sendRedirect(request.getContextPath() + "/user/profile");
        }
    }
}

