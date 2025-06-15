package Controller.Auth;

import Mapper.UserMapper;
import Service.Auth.GoogleAuthService;
import Model.Entity.OAuth.GoogleUser;
import Service.UserService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Utils.SessionUtil;
import Model.Entity.User;
import Model.Entity.OAuth.UserLogins;
import Service.Auth.UserLoginsService;
import Model.Entity.Role.Role;
import Model.Entity.Role.UserRole;
import Service.Role.RoleService;
import Service.Role.UserRoleService;

// googleLogin
public class GoogleLoginServlet extends HttpServlet {

    private GoogleAuthService googleAuthService;
    private UserMapper userMapper;
    private UserService userService;
    private UserLoginsService userLoginsService;
    private RoleService roleService;
    private UserRoleService userRoleService;

    @Override
    public void init() {
        googleAuthService = new GoogleAuthService();
        userMapper = new UserMapper();
        userService = new UserService();
        userLoginsService = new UserLoginsService();
        roleService = new RoleService();
        userRoleService = new UserRoleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect(googleAuthService.getAuthorizationUrl());
            return;
        }
        try {
            GoogleUser googleUser = googleAuthService.getUserInfo(code);
            String email = googleUser.getEmail();
            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Cannot retrieve email from Google account.");
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            UserLogins userLogin = userLoginsService.findByProviderAndKey("google", googleUser.getGoogleId());
            if (userLogin == null) {
                request.setAttribute("error", "This Google account has not been registered.");
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            User user = userService.findById(userLogin.getUserId());
            if (user == null) {
                request.setAttribute("error", "This account does not exist.");
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            if (user.isBanned()) {
                request.setAttribute("error", "This account has been banned. Please contact support.");
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            if (user.getAccessFailedCount() > 0) {
                user.setAccessFailedCount(0);
                userService.update(user);
            }
            SessionUtil.removeSessionAttribute(request, "user");
            SessionUtil.setSessionAttribute(request, "user", user);
            SessionUtil.setSessionAttribute(request, "isLoggedIn", true);
            SessionUtil.setCookie(response, "userId", user.getUserId().toString(), 30 * 24 * 60 * 60, true, false, "/");
            // Lấy role thực tế và chuyển hướng phù hợp
            UserRole userRole = userRoleService.findByUserId(user.getUserId());
            Role actualRole = roleService.findById(userRole.getRoleId());
            String redirectUrl = "/pages/index.jsp";
            if (actualRole.getRoleName().equals("Staff")) {
                redirectUrl = "/pages/staff/staff-dashboard.jsp";
            } else if (actualRole.getRoleName().equals("Admin")) {
                redirectUrl = "/pages/admin/admin-dashboard.jsp";
            }
            response.sendRedirect(request.getContextPath() + redirectUrl);
        } catch (Exception e) {
            request.setAttribute("error", "Google login failed - " + e.getMessage());
            request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

}
