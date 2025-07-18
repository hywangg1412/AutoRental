package Controller.Staff;

import Model.DTO.User.UserProfileDTO;
import Model.Entity.User.User;
import Model.Entity.OAuth.UserLogins;
import Service.User.UserService;
import Service.Auth.UserLoginsService;
import Utils.SessionUtil;
import java.io.IOException;
import java.util.List;
import java.util.HashSet;
import java.util.Set;
import java.time.format.DateTimeFormatter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "StaffProfileServlet", urlPatterns = {"/staff/profile"})
public class StaffProfileServlet extends HttpServlet {
    private static final String LOGIN_PAGE = "/pages/authen/SignIn.jsp";
    private UserService userService;
    private UserLoginsService userLoginsService;

    @Override
    public void init() {
        userService = new UserService();
        userLoginsService = new UserLoginsService();
    }

    private UserProfileDTO mapUserToProfileDTO(User user, List<UserLogins> userLogins) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        UserProfileDTO profile = new UserProfileDTO();
        profile.setUsername(user.getUsername());
        profile.setUserDOB(user.getUserDOB());
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
        Boolean isLoggedIn = (Boolean) SessionUtil.getSessionAttribute(request, "isLoggedIn");
        User user = (User) SessionUtil.getSessionAttribute(request, "user");
        if (isLoggedIn == null || !isLoggedIn || user == null) {
            response.sendRedirect(request.getContextPath() + LOGIN_PAGE);
            return;
        }
        try {
            List<UserLogins> userLogins = userLoginsService.findByUserId(user.getUserId());
            UserProfileDTO profile = mapUserToProfileDTO(user, userLogins);
            request.setAttribute("profile", profile);
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
            request.getRequestDispatcher("/pages/staff/profile/staff-profile.jsp").forward(request, response);
        } catch (Exception e) {
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "An error occurred while processing your request");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "POST method is not supported");
    }
}
