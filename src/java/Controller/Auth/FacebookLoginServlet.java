package Controller.Auth;

import Mapper.UserMapper;
import Model.Constants.UserStatusConstants;
import Model.Entity.OAuth.FacebookUser;
import Model.Entity.User.User;
import Service.User.UserService;
import Service.Auth.FacebookAuthService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Utils.SessionUtil;
import Model.Entity.OAuth.UserLogins;
import Model.Entity.Role.Role;
import Model.Entity.Role.UserRole;
import Service.Role.RoleService;
import Service.Role.UserRoleService;
import Service.Auth.UserLoginsService;
import java.util.UUID;
import Service.External.MailService;
import Service.Auth.EmailOTPVerificationService;
import Model.Entity.OAuth.EmailOTPVerification;

// facebookLogin
public class FacebookLoginServlet extends HttpServlet {

    private FacebookAuthService facebookAuthService;
    private UserMapper userMapper;
    private UserService userService;
    private UserLoginsService userLoginsService;
    private RoleService roleService;
    private UserRoleService userRoleService;
    private MailService mailService;
    private EmailOTPVerificationService emailOTPService;

    @Override
    public void init() {
        facebookAuthService = new FacebookAuthService();
        userMapper = new UserMapper();
        userService = new UserService();
        userLoginsService = new UserLoginsService();
        roleService = new RoleService();
        userRoleService = new UserRoleService();
        mailService = new MailService();
        emailOTPService = new EmailOTPVerificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect(facebookAuthService.getAuthorizationUrl());
            return;
        }
        try {
            FacebookUser facebookUser = facebookAuthService.getUserInfo(code);
            UserLogins userLogin = userLoginsService.findByProviderAndKey("facebook", facebookUser.getFacebookId());
            if (userLogin == null) {
                request.setAttribute("error", "This Facebook account has not been registered.");
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            User user = userService.findById(userLogin.getUserId());
            if (user == null) {
                request.setAttribute("error", "This account does not exist.");
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            if (user.isDeleted()) {
                request.setAttribute("error", "This account has been deleted.");
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
            if (!user.isActive()) {
                user.setStatus(UserStatusConstants.ACTIVE);
                userService.update(user);
            }
            if (!user.isEmailVerifed()) {
                EmailOTPVerification otp = emailOTPService.findByUserId(user.getUserId());
                if (otp != null) {
                    mailService.sendOtpEmail(user.getEmail(), otp.getOtp(), user.getUsername());
                }
                request.setAttribute("error", "Your email has not been verified. A new verification code has been sent to your email.");
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                return;
            }

            SessionUtil.removeSessionAttribute(request, "user");
            SessionUtil.setSessionAttribute(request, "user", user);
            SessionUtil.setSessionAttribute(request, "isLoggedIn", true);
            SessionUtil.setCookie(response, "userId", user.getUserId().toString(), 30 * 24 * 60 * 60, true, false, "/");

            UserRole userRole = userRoleService.findByUserId(user.getUserId());
            Role actualRole = roleService.findById(userRole.getRoleId());

            String redirectUrl = "/pages/home"; 

            if (actualRole.getRoleName().equals("Staff")) {
                redirectUrl = "/pages/staff/staff-dashboard.jsp";
            } else if (actualRole.getRoleName().equals("Admin")) {
                redirectUrl = "/pages/admin/admin-dashboard.jsp";
            }

            response.sendRedirect(request.getContextPath() + redirectUrl);
        } catch (Exception e) {
            request.setAttribute("error", "Facebook login failed - " + e.getMessage());
            request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

}
