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
import Utils.SessionUtil;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "UpdateDriverLicenseServlet", urlPatterns = {"/user/update-driver-license"})
@MultipartConfig
public class UpdateDriverLicenseServlet extends HttpServlet {
    // Constants
    private static final String SIGNIN_PAGE = "/pages/authen/SignIn.jsp";
    private static final String USER_PROFILE_URL = "/user/profile";
    private static final String STAFF_PROFILE_URL = "/staff/profile";
    private static final String ROLE_STAFF = "Staff";
    private static final String CLOUDINARY_FOLDER = "driver_license";
    private static final String CLOUDINARY_PREFIX = "driver_license_";
    
    // Messages
    private static final String MSG_NO_CHANGES = "No changes detected";
    private static final String MSG_UPDATE_SUCCESS = "Driver license updated successfully";
    private static final String MSG_UPDATE_FAILED = "Failed to update driver license: ";
    private static final String MSG_GENERAL_ERROR = "An error occurred: ";
    
    private CloudinaryService cloudinaryService;
    private DriverLicenseService driverLicenseService;
    private Gson gson;
    private static final Logger LOGGER = Logger.getLogger(UpdateDriverLicenseServlet.class.getName());

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
        User user = (User) SessionUtil.getSessionAttribute(request, "user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + SIGNIN_PAGE);
            return;
        }

        try {
            handleDriverLicenseUpdate(request, response, user);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in UpdateDriverLicenseServlet", e);
            handleResponse(request, response, user, false, MSG_GENERAL_ERROR + e.getMessage());
        }
    }

    private void handleDriverLicenseUpdate(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        Part filePart = request.getPart("licenseImage");
        String licenseNumber = request.getParameter("licenseNumber");
        String fullName = request.getParameter("fullName");
        String dob = request.getParameter("dob");
        
        boolean hasNewImage = filePart != null && filePart.getSize() > 0;
        boolean hasInfoChanges = licenseNumber != null || fullName != null || dob != null;
        
        if (!hasNewImage && !hasInfoChanges) {
            handleResponse(request, response, user, false, MSG_NO_CHANGES);
            return;
        }
        
        // Validate info if changes exist
        if (hasInfoChanges) {
            String validationError = validateInfo(licenseNumber, fullName, dob);
            if (validationError != null) {
                handleResponse(request, response, user, false, validationError);
                return;
            }
        }
        
        try {
            DriverLicense license = getOrCreateLicense(user.getUserId());
            
            if (hasNewImage) {
                try (InputStream inputStream = filePart.getInputStream()) {
                    String publicId = CLOUDINARY_PREFIX + user.getUserId();
                    String imageUrl = cloudinaryService.uploadAndGetUrlToFolder(inputStream, CLOUDINARY_FOLDER, publicId);
                    license.setLicenseImage(imageUrl);
                }
            }
            
            if (hasInfoChanges) {
                LocalDate dobDate = FormatUtils.parseDateSafely(dob);
                license.setLicenseNumber(licenseNumber);
                license.setFullName(fullName);
                license.setDob(dobDate);
            }
            
            if (license.getLicenseId() == null) {
                driverLicenseService.add(license);
            } else {
                driverLicenseService.update(license);
            }
            
            handleResponse(request, response, user, true, MSG_UPDATE_SUCCESS, license.getLicenseImage());
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating driver license", e);
            handleResponse(request, response, user, false, MSG_UPDATE_FAILED + e.getMessage());
        }
    }

    private String validateInfo(String licenseNumber, String fullName, String dob) {
        if (licenseNumber == null || !licenseNumber.matches("^[0-9]{12}$")) {
            return "License number must be exactly 12 digits";
        }
        if (fullName == null || !fullName.matches("^[\\p{L} ]+$")) {
            return "Full name must not contain special characters or numbers";
        }
        if (dob == null) {
            return "Date of birth is required";
        }
        
        LocalDate dobDate = FormatUtils.parseDateSafely(dob);
        if (dobDate == null) {
            return "Invalid date of birth format. Please use dd/MM/yyyy format";
        }
        if (dobDate.isAfter(LocalDate.now())) {
            return "Date of birth cannot be in the future";
        }
        if (Period.between(dobDate, LocalDate.now()).getYears() < 18) {
            return "You must be at least 18 years old to register a driver license";
        }
        return null;
    }

    private void handleResponse(HttpServletRequest request, HttpServletResponse response, User user, 
                              boolean success, String message, String... imageUrl) throws IOException {
        SessionUtil.setSessionAttribute(request, success ? "success" : "error", message);
        
        if ("XMLHttpRequest".equals(request.getHeader("X-Requested-With"))) {
            Map<String, Object> responseData = new HashMap<>();
            responseData.put("success", success);
            responseData.put("message", message);
            if (imageUrl.length > 0 && imageUrl[0] != null) {
                responseData.put("newImageUrl", imageUrl[0]);
            }
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write(gson.toJson(responseData));
        } else {
            String profileUrl = USER_PROFILE_URL;
            try {
                Service.Role.RoleService roleService = new Service.Role.RoleService();
                Model.Entity.Role.Role userRole = roleService.findById(user.getRoleId());
                if (userRole != null && ROLE_STAFF.equalsIgnoreCase(userRole.getRoleName())) {
                    profileUrl = STAFF_PROFILE_URL;
                }
            } catch (Exception ex) {
                LOGGER.log(Level.WARNING, "Error getting user role for profile redirect", ex);
            }
            response.sendRedirect(request.getContextPath() + profileUrl);
        }
    }

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
}

