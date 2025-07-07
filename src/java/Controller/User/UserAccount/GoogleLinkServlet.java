package Controller.User.UserAccount;

import Service.Auth.GoogleAuthService;
import Service.Auth.UserLoginsService;
import Model.Entity.OAuth.GoogleUser;
import Model.Entity.OAuth.UserLogins;
import Utils.SessionUtil;
import Model.Entity.User.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "GoogleLinkServlet", urlPatterns = {"/google-link"})
public class GoogleLinkServlet extends HttpServlet {

    private GoogleAuthService googleAuthService;
    private UserLoginsService userLoginsService;

    @Override
    public void init() {
        googleAuthService = new GoogleAuthService();
        userLoginsService = new UserLoginsService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) SessionUtil.getSessionAttribute(request, "user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }
        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect(googleAuthService.getAuthorizationLinkUrl());
            return;
        }
        try {
            GoogleUser googleUser = googleAuthService.getUserInfoLink(code);
            if (googleUser.getGoogleId() == null) {
                SessionUtil.setSessionAttribute(request, "error", "Cannot retrieve Google user information.");
                response.sendRedirect(request.getContextPath() + "/user/profile");
                return;
            }
            UserLogins existing = userLoginsService.findByProviderAndKey("google", googleUser.getGoogleId());
            if (existing != null && !existing.getUserId().equals(currentUser.getUserId())) {
                SessionUtil.setSessionAttribute(request, "error", "This Google account has been linked to another account.");
                response.sendRedirect(request.getContextPath() + "/user/profile");
                return;
            }
            if (existing == null) {
                String displayName = googleUser.getFirstName() + " " + googleUser.getLastName();
                UserLogins newLogin = new UserLogins("google", googleUser.getGoogleId(), "Google", currentUser.getUserId());
                newLogin.setProviderDisplayName(displayName);
                userLoginsService.add(newLogin);
            }
            SessionUtil.setSessionAttribute(request, "success", "Google link successful!");
            response.sendRedirect(request.getContextPath() + "/user/profile");
        } catch (Exception e) {
            SessionUtil.setSessionAttribute(request, "error", "Google link failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/user/profile");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}
