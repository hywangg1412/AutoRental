package Controller.User.UserAccount;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Service.Auth.FacebookAuthService;
import Service.Auth.UserLoginsService;
import Model.Entity.OAuth.FacebookUser;
import Model.Entity.OAuth.UserLogins;
import Utils.SessionUtil;
import Model.Entity.User.User;

@WebServlet(name = "FacebookLinkServlet", urlPatterns = {"/facebook-link"})
public class FacebookLinkServlet extends HttpServlet {
    private FacebookAuthService facebookAuthService;
    private UserLoginsService userLoginsService;

    @Override
    public void init() {
        facebookAuthService = new FacebookAuthService();
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
            response.sendRedirect(facebookAuthService.getAuthorizationUrl());
            return;
        }
        try {
            FacebookUser fbUser = facebookAuthService.getUserInfo(code);
            if (fbUser.getFacebookId() == null) {
                request.setAttribute("error", "Cannot retrieve Facebook user information.");
                request.getRequestDispatcher("/pages/user/user-profile.jsp").forward(request, response);
                return;
            }
            UserLogins existing = userLoginsService.findByProviderAndKey("facebook", fbUser.getFacebookId());
            if (existing != null && !existing.getUserId().equals(currentUser.getUserId())) {
                request.setAttribute("error", "This Facebook account has been linked to another account.");
                request.getRequestDispatcher("/pages/user/user-profile.jsp").forward(request, response);
                return;
            }
            if (existing == null) {
                UserLogins newLogin = new UserLogins("facebook", fbUser.getFacebookId(), "Facebook", currentUser.getUserId());
                userLoginsService.add(newLogin);
            }
            SessionUtil.setSessionAttribute(request, "success", "Facebook link successful!");
            response.sendRedirect(request.getContextPath() + "/user/profile");
        } catch (Exception e) {
            request.setAttribute("error", "Facebook link failed: " + e.getMessage());
            request.getRequestDispatcher("/pages/user/user-profile.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}
