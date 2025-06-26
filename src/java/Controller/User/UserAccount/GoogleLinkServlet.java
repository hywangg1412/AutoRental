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
            response.sendRedirect(googleAuthService.getAuthorizationUrl());
            return;
        }
        try {
            GoogleUser googleUser = googleAuthService.getUserInfo(code);
            if (googleUser.getGoogleId() == null) {
                request.setAttribute("error", "Cannot retrieve Google user information.");
                request.getRequestDispatcher("/pages/user/user-profile.jsp").forward(request, response);
                return;
            }
            UserLogins existing = userLoginsService.findByProviderAndKey("google", googleUser.getGoogleId());
            if (existing != null && !existing.getUserId().equals(currentUser.getUserId())) {
                request.setAttribute("error", "This Google account has been linked to another account.");
                request.getRequestDispatcher("/pages/user/user-profile.jsp").forward(request, response);
                return;
            }
            if (existing == null) {
                UserLogins newLogin = new UserLogins("google", googleUser.getGoogleId(), "Google", currentUser.getUserId());
                userLoginsService.add(newLogin);
            }
            SessionUtil.setSessionAttribute(request, "success", "Google link successful!");
            response.sendRedirect(request.getContextPath() + "/user/profile");
        } catch (Exception e) {
            request.setAttribute("error", "Google link failed: " + e.getMessage());
            request.getRequestDispatcher("/pages/user/user-profile.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}
