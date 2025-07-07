package Controller.Auth;

import Model.Constants.UserStatusConstants;
import Model.Entity.User.User;
import Model.Entity.Role.Role;
import Service.User.UserService;
import Service.Role.RoleService;
import Utils.SessionUtil;
import Utils.ObjectUtils;
import java.io.IOException;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import Service.External.MailService;
import Service.Auth.EmailOTPVerificationService;
import Model.Entity.OAuth.EmailOTPVerification;

// /normalLogin
public class NormalLoginServlet extends HttpServlet {

    private UserService userService;
    private RoleService roleService;
    private MailService mailService;
    private EmailOTPVerificationService emailOTPService;

    @Override
    public void init() {
        userService = new UserService();
        roleService = new RoleService();
        mailService = new MailService();
        emailOTPService = new EmailOTPVerificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("pages/authen/SignIn.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required!");
            request.getRequestDispatcher("pages/authen/SignIn.jsp").forward(request, response);
            return;
        }
        try {
            User user = userService.findByEmail(email);
            if (user == null) {
                request.setAttribute("error", "Email not found!");
                request.getRequestDispatcher("pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            if (user.isDeleted()) {
                request.setAttribute("error", "This account has been deleted and cannot be accessed.");
                request.getRequestDispatcher("pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            if (user.isBanned()) {
                request.setAttribute("error", "This account has been banned. Please contact support.");
                request.getRequestDispatcher("pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            
            if (user.isLockoutEnabled() && user.getAccessFailedCount() >= 5) {
                user.setStatus("Banned");
                user.setAccessFailedCount(0);
                userService.update(user);
                request.setAttribute("error", "Account is locked due to too many failed attempts. Please contact support.");
                request.getRequestDispatcher("pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            if (!ObjectUtils.verifyPassword(password, user.getPasswordHash())) {
                user.setAccessFailedCount(user.getAccessFailedCount() + 1);
                if (user.isLockoutEnabled() && user.getAccessFailedCount() >= 5) {
                    user.setStatus("Banned");
                    user.setAccessFailedCount(0);
                    userService.update(user);
                    request.setAttribute("error", "Account is locked due to too many failed attempts. Please contact support.");
                } else {
                    userService.update(user);
                    request.setAttribute("error", "Invalid password! " + (5 - user.getAccessFailedCount()) + " attempts remaining.");
                }
                request.getRequestDispatcher("pages/authen/SignIn.jsp").forward(request, response);
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
                request.getRequestDispatcher("pages/authen/SignIn.jsp").forward(request, response);
                return;
            }

            String redirectUrl = "/pages/index.jsp";
            if (user.getRoleId() != null) {
                String roleIdStr = user.getRoleId().toString();
                if (roleIdStr.equals("550e8400-e29b-41d4-a716-446655440000")) { // Staff
                    redirectUrl = "/staff/dashboard";
                } else if (roleIdStr.equals("7c9e6679-7425-40de-944b-e07fc1f90ae7")) { // Admin
                    redirectUrl = "/admin/dashboard";
                }
            }

            SessionUtil.setSessionAttribute(request, "user", user);
            SessionUtil.setSessionAttribute(request, "userId", user.getUserId());
            SessionUtil.setSessionAttribute(request, "isLoggedIn", true);
            SessionUtil.setCookie(response, "userId", user.getUserId().toString(), 30 * 24 * 60 * 60, true, false, "/");
            response.sendRedirect(request.getContextPath() + redirectUrl);
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred during login. Please try again later.");
            request.getRequestDispatcher("pages/authen/SignIn.jsp").forward(request, response);
        }
    }
}
