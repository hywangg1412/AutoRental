package Controller.User.UserAccount;

import Exception.NotFoundException;
import Model.DTO.User.UserProfileDTO;
import Model.Entity.User.User;
import Model.Entity.OAuth.UserLogins;
import Service.User.UserService;
import Service.Auth.UserLoginsService;
import Service.User.DriverLicenseService;
import Model.Entity.User.DriverLicense;
import Utils.SessionUtil;
import java.io.IOException;
import java.util.List;
import java.util.Set;
import java.util.HashSet;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import Service.Role.RoleService;
import Model.Entity.Role.Role;
import Service.User.CitizenIdCardService;
import Model.Entity.User.CitizenIdCard;

@WebServlet("/user/profile")
public class UserProfileServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(UserProfileServlet.class.getName());
    private static final String LOGIN_PAGE = "/pages/authen/SignIn.jsp";

    private UserService userService;
    private UserLoginsService userLoginsService;
    private DriverLicenseService driverLicenseService;
    private RoleService roleService;
    private CitizenIdCardService citizenIdCardService;

    @Override
    public void init() {
        userService = new UserService();
        userLoginsService = new UserLoginsService();
        driverLicenseService = new DriverLicenseService();
        roleService = new RoleService();
        citizenIdCardService = new CitizenIdCardService();
    }

    private UserProfileDTO mapUserToProfileDTO(User user, List<UserLogins> userLogins) {
        if (user == null) {
            throw new IllegalArgumentException("User cannot be null");
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        UserProfileDTO profile = new UserProfileDTO();
        profile.setUsername(user.getUsername());
        profile.setUserDOB(user.getUserDOB());
        // Format userDOB to dd/MM/yyyy string for display
        if (user.getUserDOB() != null) {
            profile.setUserDOBFormatted(user.getUserDOB().format(formatter));
        }
        profile.setGender(user.getGender());
        profile.setPhoneNumber(user.getPhoneNumber());
        profile.setEmail(user.getEmail());
        profile.setEmailVerified(user.isEmailVerifed());
        profile.setAvatarUrl(user.getAvatarUrl());
        profile.setCreatedAt(user.getCreatedDate().format(formatter));

        Set<String> providers = new HashSet<>();
        for (UserLogins login : userLogins) {
            String provider = login.getLoginProvider().toLowerCase();
            providers.add(provider);
            
            // Set provider account names
            if ("facebook".equals(provider)) {
                profile.setHasFacebookLogin(true);
                profile.setFacebookAccountName(login.getProviderDisplayName());
            } else if ("google".equals(provider)) {
                profile.setHasGoogleLogin(true);
                profile.setGoogleAccountName(login.getProviderDisplayName());
            }
        }

        return profile;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Boolean isLoggedIn = (Boolean) SessionUtil.getSessionAttribute(request, "isLoggedIn");
            User user = (User) SessionUtil.getSessionAttribute(request, "user");

            if (isLoggedIn == null || !isLoggedIn || user == null) {
                LOGGER.log(Level.INFO, "User not logged in, redirecting to login page");
                response.sendRedirect(request.getContextPath() + LOGIN_PAGE);
                return;
            }

            List<UserLogins> userLogins = userLoginsService.findByUserId(user.getUserId());
            UserProfileDTO profile = mapUserToProfileDTO(user, userLogins);
            request.setAttribute("profile", profile);

            DriverLicense driverLicense = null;
            boolean isStaff = false;
            try {
                Role userRole = roleService.findById(user.getRoleId());
                if (userRole != null && "Staff".equalsIgnoreCase(userRole.getRoleName())) {
                    isStaff = true;
                }
            } catch (Exception ex) {
                // Nếu lỗi khi lấy role, coi như không phải staff
            }
            if (!isStaff) {
                try {
                    driverLicense = driverLicenseService.findByUserId(user.getUserId());
                } catch (NotFoundException e) {
                    LOGGER.log(Level.INFO, "User {0} doesn't have a driver license yet, creating new one", user.getUserId());
                    try {
                        driverLicense = driverLicenseService.createDefaultForUser(user.getUserId());
                    } catch (Exception ex) {
                        LOGGER.log(Level.SEVERE, "Error creating new driver license for user {0}", user.getUserId());
                        driverLicense = null;
                    }
                } catch (Exception e) {
                    LOGGER.log(Level.SEVERE, "Error getting driver license", e);
                    driverLicense = null;
                }
            }
            request.setAttribute("driverLicense", driverLicense);

            // Lấy thông tin CCCD
            CitizenIdCard citizenIdCard = null;
            try {
                citizenIdCard = citizenIdCardService.findByUserId(user.getUserId());
            } catch (NotFoundException e) {
                // Không có CCCD, để null
            }
            request.setAttribute("citizenId", citizenIdCard);

            // Read session messages and clear them
            String successMessage = (String) SessionUtil.getSessionAttribute(request, "success");
            String errorMessage = (String) SessionUtil.getSessionAttribute(request, "error");
            
            if (successMessage != null) {
                request.setAttribute("success", successMessage);
                SessionUtil.removeSessionAttribute(request, "success");
            }
            
            if (errorMessage != null) {
                request.setAttribute("error", errorMessage);
                SessionUtil.removeSessionAttribute(request, "error");
            }

            request.getRequestDispatcher("/pages/user/user-profile.jsp").forward(request, response);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing user profile request", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST method is not supported");
    }
}
