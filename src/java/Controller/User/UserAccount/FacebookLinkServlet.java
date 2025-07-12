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
import Service.Role.RoleService;
import Model.Entity.Role.Role;

@WebServlet(name = "FacebookLinkServlet", urlPatterns = {"/facebook-link"})
public class FacebookLinkServlet extends HttpServlet {
    private FacebookAuthService facebookAuthService;
    private UserLoginsService userLoginsService;
    private RoleService roleService;

    @Override
    public void init() {
        facebookAuthService = new FacebookAuthService();
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
            response.sendRedirect(facebookAuthService.getAuthorizationLinkUrl());
            return;
        }
        try {
            FacebookUser fbUser = facebookAuthService.getLinkUserInfo(code);
            if (fbUser.getFacebookId() == null) {
                SessionUtil.setSessionAttribute(request, "error", "Cannot retrieve Facebook user information.");
                response.sendRedirect(request.getContextPath() + profileRedirect);
                return;
            }
            UserLogins existing = userLoginsService.findByProviderAndKey("facebook", fbUser.getFacebookId());
            if (existing != null && !existing.getUserId().equals(currentUser.getUserId())) {
                SessionUtil.setSessionAttribute(request, "error", "This Facebook account has been linked to another account.");
                response.sendRedirect(request.getContextPath() + profileRedirect);
                return;
            }
            if (existing == null) {
                String displayName = fbUser.getFullName();
                UserLogins newLogin = new UserLogins("facebook", fbUser.getFacebookId(), "Facebook", currentUser.getUserId());
                newLogin.setProviderDisplayName(displayName);
                userLoginsService.add(newLogin);
            }
            SessionUtil.setSessionAttribute(request, "success", "Facebook link successful!");
            response.sendRedirect(request.getContextPath() + profileRedirect);
        } catch (Exception e) {
            SessionUtil.setSessionAttribute(request, "error", "Facebook link failed: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + profileRedirect);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}
