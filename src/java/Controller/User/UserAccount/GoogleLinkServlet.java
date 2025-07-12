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
import Service.Role.RoleService;
import Model.Entity.Role.Role;

@WebServlet(name = "GoogleLinkServlet", urlPatterns = {"/google-link"})
public class GoogleLinkServlet extends HttpServlet {

    private GoogleAuthService googleAuthService;
    private UserLoginsService userLoginsService;
    private RoleService roleService;

    @Override
    public void init() {
        googleAuthService = new GoogleAuthService();
        userLoginsService = new UserLoginsService();
        roleService = new RoleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = (User) SessionUtil.getSessionAttribute(request, "user");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }
        String profileRedirect = "/user/profile";
        try {
            Role userRole = roleService.findById(currentUser.getRoleId());
            if (userRole != null && "Staff".equalsIgnoreCase(userRole.getRoleName())) {
                profileRedirect = "/staff/profile";
            }
        } catch (Exception ex) {
            // Nếu lỗi khi lấy role, giữ nguyên profileRedirect là /user/profile
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
                response.sendRedirect(request.getContextPath() + profileRedirect);
                return;
            }
            UserLogins existing = userLoginsService.findByProviderAndKey("google", googleUser.getGoogleId());
            if (existing != null && !existing.getUserId().equals(currentUser.getUserId())) {
                SessionUtil.setSessionAttribute(request, "error", "This Google account has been linked to another account.");
                response.sendRedirect(request.getContextPath() + profileRedirect);
                return;
            }
            if (existing == null) {
                String displayName = googleUser.getFirstName() + " " + googleUser.getLastName();
                UserLogins newLogin = new UserLogins("google", googleUser.getGoogleId(), "Google", currentUser.getUserId());
                newLogin.setProviderDisplayName(displayName);
                userLoginsService.add(newLogin);
            }
            SessionUtil.setSessionAttribute(request, "success", "Google link successful!");
            response.sendRedirect(request.getContextPath() + profileRedirect);
        } catch (Exception e) {
            SessionUtil.setSessionAttribute(request, "error", "Google link failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + profileRedirect);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}
