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

@WebServlet("/user/profile")
public class UserProfileServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(UserProfileServlet.class.getName());
    private static final String LOGIN_PAGE = "/pages/authen/SignIn.jsp";

    private UserService userService;
    private UserLoginsService userLoginsService;
    private DriverLicenseService driverLicenseService;

    @Override
    public void init() {
        userService = new UserService();
        userLoginsService = new UserLoginsService();
        driverLicenseService = new DriverLicenseService();
    }

    private UserProfileDTO mapUserToProfileDTO(User user, List<UserLogins> userLogins) {
        if (user == null) {
            throw new IllegalArgumentException("User cannot be null");
        }

        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        UserProfileDTO profile = new UserProfileDTO();
        profile.setUsername(user.getUsername());
        profile.setUserDOB(user.getUserDOB());
        profile.setGender(user.getGender());
        profile.setPhoneNumber(user.getPhoneNumber());
        profile.setEmail(user.getEmail());
        profile.setAvatarUrl(user.getAvatarUrl());
        profile.setCreatedAt(user.getCreatedDate().format(formatter));

        Set<String> providers = new HashSet<>();
        userLogins.forEach(login -> providers.add(login.getLoginProvider().toLowerCase()));

        profile.setHasFacebookLogin(providers.contains("facebook"));
        profile.setHasGoogleLogin(providers.contains("google"));

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
            try {
                driverLicense = driverLicenseService.findByUserId(user.getUserId());
            } catch (NotFoundException e) {
                // User doesn't have a driver license yet, create a new one
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
            request.setAttribute("driverLicense", driverLicense);

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
