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
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;

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

    // Helper: Trả về JSON response
    private void sendJsonResponse(HttpServletResponse response, Map<String, Object> data) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(data));
    }

    // Helper: Lấy hoặc tạo mới DriverLicense
    private DriverLicense getOrCreateLicense(UUID userId) {
        try {
            return driverLicenseService.findByUserId(userId);
        } catch (NotFoundException e) {
            DriverLicense license = new DriverLicense();
            license.setLicenseId(UUID.randomUUID());
            license.setUserId(userId);
            license.setCreatedDate(LocalDateTime.now());
            return license;
        }
    }

    // Helper: Tính tuổi
    private int calculateAge(LocalDate dob, LocalDate today) {
        return Period.between(dob, today).getYears();
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
            switch (action) {
                case "uploadImage":
                    handleImageUploadOnly(request, response, session, user);
                    break;
                case "updateInfo":
                    handleInfoUpdateOnly(request, response, session, user);
                    break;
                case "updateBoth":
                    handleImageAndInfoUpdate(request, response, session, user);
                    break;
                default:
                    response.sendRedirect(request.getContextPath() + "/user/profile");
            }
        } catch (Exception e) {
            session.setAttribute("error", "An error occurred: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/user/profile");
        }
    }

    // Chỉ cập nhật ảnh, không ghi đè thông tin
    private void handleImageUploadOnly(HttpServletRequest request, HttpServletResponse response, HttpSession session, User user)
            throws ServletException, IOException {
        Part filePart = request.getPart("licenseImage");
        if (filePart == null || filePart.getSize() == 0) {
            handleError(request, response, session, "No image file provided");
            return;
        }
        try (InputStream inputStream = filePart.getInputStream()) {
            String publicId = "driver_license_" + user.getUserId();
            String imageUrl = cloudinaryService.uploadAndGetUrlToFolder(inputStream, "driver_license", publicId);

            DriverLicense license = getOrCreateLicense(user.getUserId());
            license.setLicenseImage(imageUrl);
            if (license.getLicenseId() == null) {
                driverLicenseService.add(license);
            } else {
                driverLicenseService.update(license);
            }

            session.setAttribute("success", "Driver license image updated successfully");
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                Map<String, Object> responseData = new HashMap<>();
                responseData.put("success", true);
                responseData.put("message", "Driver license image updated successfully");
                responseData.put("newImageUrl", imageUrl);
                sendJsonResponse(response, responseData);
            } else {
                response.sendRedirect(request.getContextPath() + "/user/profile");
            }
        } catch (Exception e) {
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                Map<String, Object> responseData = new HashMap<>();
                responseData.put("success", false);
                responseData.put("message", "Failed to upload image: " + e.getMessage());
                sendJsonResponse(response, responseData);
            } else {
                session.setAttribute("error", "Failed to upload image: " + e.getMessage());
                response.sendRedirect(request.getContextPath() + "/user/profile");
            }
        }
    }

    // Chỉ cập nhật thông tin, không ghi đè ảnh
    private void handleInfoUpdateOnly(HttpServletRequest request, HttpServletResponse response, HttpSession session, User user)
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
            LocalDate dobDate = FormatUtils.parseDateSafely(dob);
            if (dobDate == null) {
                handleError(request, response, session, "Invalid date of birth format. Please use dd/MM/yyyy format");
                return;
            }
            LocalDate today = LocalDate.now();
            if (dobDate.isAfter(today)) {
                handleError(request, response, session, "Date of birth cannot be in the future");
                return;
            }
            int age = calculateAge(dobDate, today);
            if (age < 18) {
                handleError(request, response, session, "You must be at least 18 years old to register a driver license");
                return;
            }
            DriverLicense license = getOrCreateLicense(user.getUserId());
            license.setLicenseNumber(licenseNumber);
            license.setFullName(fullName);
            license.setDob(dobDate);
            if (license.getLicenseId() == null) {
                driverLicenseService.add(license);
            } else {
                driverLicenseService.update(license);
            }
            session.setAttribute("success", "Driver license information updated successfully");
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                Map<String, Object> responseData = new HashMap<>();
                responseData.put("success", true);
                responseData.put("message", "Driver license information updated successfully");
                sendJsonResponse(response, responseData);
            } else {
                response.sendRedirect(request.getContextPath() + "/user/profile");
            }
        } catch (Exception e) {
            handleError(request, response, session, "Failed to update information: " + e.getMessage());
        }
    }

    private void handleImageAndInfoUpdate(HttpServletRequest request, HttpServletResponse response, HttpSession session, User user)
            throws ServletException, IOException {
        String licenseNumber = request.getParameter("licenseNumber");
        String fullName = request.getParameter("fullName");
        String dob = request.getParameter("dob");
        Part filePart = request.getPart("licenseImage");

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
        LocalDate dobDate = FormatUtils.parseDateSafely(dob);
        if (dobDate == null) {
            handleError(request, response, session, "Invalid date of birth format. Please use dd/MM/yyyy format");
            return;
        }
        LocalDate today = LocalDate.now();
        if (dobDate.isAfter(today)) {
            handleError(request, response, session, "Date of birth cannot be in the future");
            return;
        }
        int age = calculateAge(dobDate, today);
        if (age < 18) {
            handleError(request, response, session, "You must be at least 18 years old to register a driver license");
            return;
        }
        if (filePart == null || filePart.getSize() == 0) {
            handleError(request, response, session, "No image file provided");
            return;
        }
        try (InputStream inputStream = filePart.getInputStream()) {
            String publicId = "driver_license_" + user.getUserId();
            String imageUrl = cloudinaryService.uploadAndGetUrlToFolder(inputStream, "driver_license", publicId);
            DriverLicense license = getOrCreateLicense(user.getUserId());
            license.setLicenseNumber(licenseNumber);
            license.setFullName(fullName);
            license.setDob(dobDate);
            license.setLicenseImage(imageUrl);
            if (license.getLicenseId() == null) {
                driverLicenseService.add(license);
            } else {
                driverLicenseService.update(license);
            }
            session.setAttribute("success", "Driver license updated successfully");
            if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
                Map<String, Object> responseData = new HashMap<>();
                responseData.put("success", true);
                responseData.put("message", "Driver license updated successfully");
                responseData.put("newImageUrl", imageUrl);
                sendJsonResponse(response, responseData);
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
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", false);
            responseData.put("message", errorMessage);
            sendJsonResponse(response, responseData);
        } else {
            session.setAttribute("error", errorMessage);
            response.sendRedirect(request.getContextPath() + "/user/profile");
        }
    }
}

