package Controller.User.UserAccount;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Service.Auth.FacebookAuthService;
import Service.Auth.GoogleAuthService;
import Service.Auth.UserLoginsService;
import Model.Entity.OAuth.FacebookUser;
import Model.Entity.OAuth.GoogleUser;
import Model.Entity.OAuth.UserLogins;
import Utils.SessionUtil;
import Model.Entity.User.User;
import Service.Role.RoleService;
import Model.Entity.Role.Role;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "SocialLinkServlet", urlPatterns = {"/user/social-link"})
public class SocialLinkServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(SocialLinkServlet.class.getName());
    private FacebookAuthService facebookAuthService;
    private GoogleAuthService googleAuthService;
    private UserLoginsService userLoginsService;
    private RoleService roleService;

    public void init() {
        facebookAuthService = new FacebookAuthService();
        googleAuthService = new GoogleAuthService();
        userLoginsService = new UserLoginsService();
        roleService = new RoleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        User currentUser = (User) SessionUtil.getSessionAttribute(request, "user");
        if (currentUser == null) {
            LOGGER.log(Level.INFO, "User not logged in, redirecting to login page");
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }
        String profileRedirect = getProfileRedirect(currentUser);
        String provider = request.getParameter("provider");
        if (provider == null) {
            SessionUtil.setSessionAttribute(request, "error", "Provider is required.");
            LOGGER.log(Level.WARNING, "Provider parameter missing in social link request");
            response.sendRedirect(request.getContextPath() + profileRedirect);
            return;
        }
        try {
            if (provider.equals("facebook")) {
                handleFacebookLink(request, response, currentUser, profileRedirect);
            } else if (provider.equals("google")) {
                handleGoogleLink(request, response, currentUser, profileRedirect);
            } else {
                SessionUtil.setSessionAttribute(request, "error", "Unknown provider.");
                LOGGER.log(Level.WARNING, "Unknown provider: {0}", provider);
                response.sendRedirect(request.getContextPath() + profileRedirect);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error in social link process", e);
            SessionUtil.setSessionAttribute(request, "error", "Social link failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + profileRedirect);
        }
    }

    private String getProfileRedirect(User currentUser) {
        try {
            Role userRole = roleService.findById(currentUser.getRoleId());
            if (userRole != null && "Staff".equalsIgnoreCase(userRole.getRoleName())) {
                return "/staff/profile";
            }
        } catch (Exception ex) {
            LOGGER.log(Level.WARNING, "Error getting user role for profile redirect", ex);
        }
        return "/user/profile";
    }

    private void handleFacebookLink(HttpServletRequest request, HttpServletResponse response, User currentUser, String profileRedirect)
            throws IOException {
        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect(facebookAuthService.getAuthorizationLinkUrl());
            return;
        }
        try {
            FacebookUser fbUser = facebookAuthService.getLinkUserInfo(code);
            if (fbUser.getFacebookId() == null) {
                SessionUtil.setSessionAttribute(request, "error", "Cannot retrieve Facebook user information.");
                LOGGER.log(Level.WARNING, "Facebook user info is null");
                response.sendRedirect(request.getContextPath() + profileRedirect);
                return;
            }
            UserLogins existing = userLoginsService.findByProviderAndKey("facebook", fbUser.getFacebookId());
            if (existing != null && !existing.getUserId().equals(currentUser.getUserId())) {
                SessionUtil.setSessionAttribute(request, "error", "This Facebook account has been linked to another account.");
                LOGGER.log(Level.INFO, "Facebook account already linked to another user");
                response.sendRedirect(request.getContextPath() + profileRedirect);
                return;
            }
            if (existing == null) {
                String displayName = fbUser.getFullName();
                UserLogins newLogin = new UserLogins("facebook", fbUser.getFacebookId(), "Facebook", currentUser.getUserId());
                newLogin.setProviderDisplayName(displayName);
                userLoginsService.add(newLogin);
                LOGGER.log(Level.INFO, "Facebook account linked for user {0}", currentUser.getUserId());
            }
            SessionUtil.setSessionAttribute(request, "success", "Facebook link successful!");
            response.sendRedirect(request.getContextPath() + profileRedirect);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Facebook link failed", e);
            SessionUtil.setSessionAttribute(request, "error", "Facebook link failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + profileRedirect);
        }
    }

    private void handleGoogleLink(HttpServletRequest request, HttpServletResponse response, User currentUser, String profileRedirect)
            throws IOException {
        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect(googleAuthService.getAuthorizationLinkUrl());
            return;
        }
        try {
            GoogleUser googleUser = googleAuthService.getUserInfoLink(code);
            if (googleUser.getGoogleId() == null) {
                SessionUtil.setSessionAttribute(request, "error", "Cannot retrieve Google user information.");
                LOGGER.log(Level.WARNING, "Google user info is null");
                response.sendRedirect(request.getContextPath() + profileRedirect);
                return;
            }
            UserLogins existing = userLoginsService.findByProviderAndKey("google", googleUser.getGoogleId());
            if (existing != null && !existing.getUserId().equals(currentUser.getUserId())) {
                SessionUtil.setSessionAttribute(request, "error", "This Google account has been linked to another account.");
                LOGGER.log(Level.INFO, "Google account already linked to another user");
                response.sendRedirect(request.getContextPath() + profileRedirect);
                return;
            }
            if (existing == null) {
                String displayName = googleUser.getFirstName() + " " + googleUser.getLastName();
                UserLogins newLogin = new UserLogins("google", googleUser.getGoogleId(), "Google", currentUser.getUserId());
                newLogin.setProviderDisplayName(displayName);
                userLoginsService.add(newLogin);
                LOGGER.log(Level.INFO, "Google account linked for user {0}", currentUser.getUserId());
            }
            SessionUtil.setSessionAttribute(request, "success", "Google link successful!");
            response.sendRedirect(request.getContextPath() + profileRedirect);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Google link failed", e);
            SessionUtil.setSessionAttribute(request, "error", "Google link failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + profileRedirect);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Không hỗ trợ POST
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
    }
}
