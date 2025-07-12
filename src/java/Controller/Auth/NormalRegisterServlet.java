package Controller.Auth;

import Model.Entity.User.User;
import Model.Entity.Role.Role;
import Model.Constants.RoleConstants;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Utils.SessionUtil;
import Utils.ObjectUtils;
import java.time.LocalDateTime;
import Service.User.UserService;
import Service.Role.RoleService;
import java.util.UUID;
import Service.Auth.EmailOTPVerificationService;
import Model.Entity.OAuth.EmailOTPVerification;
import Service.External.MailService;

@WebServlet("/normalRegister")
public class NormalRegisterServlet extends HttpServlet {

    private UserService userService;
    private RoleService roleService;
    private EmailOTPVerificationService emailOTPService;
    private MailService mailService;

    @Override
    public void init() {
        userService = new UserService();
        roleService = new RoleService();
        emailOTPService = new EmailOTPVerificationService();
        mailService = new MailService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("pages/authen/SignUp.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String repassword = request.getParameter("repassword");

        // Validate input
        if (username == null || username.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            forwardWithError(request, response, "All fields are required!");
            return;
        }
        if (username.trim().length() < 3) {
            forwardWithError(request, response, "Username must be at least 3 characters long!");
            return;
        }
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            forwardWithError(request, response, "Invalid email format!");
            return;
        }
        if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,100}$")) {
            forwardWithError(request, response, "Password must be between 8 and 100 characters long and contain uppercase, lowercase, and numbers!");
            return;
        }
        if (!password.equals(repassword)) {
            forwardWithError(request, response, "Passwords do not match!");
            return;
        }

        try {
            if (userService.findByUsername(username) != null) {
                forwardWithError(request, response, "Username is already taken!");
                return;
            }
            User existingUser = userService.findByEmail(email);
            if (existingUser != null) {
                String errorMsg = existingUser.isDeleted() ? "This email is associated with a deleted account and cannot be reused."
                        : existingUser.isBanned() ? "This email is associated with a banned account. Please contact support."
                        : "An account with this email already exists.";
                forwardWithError(request, response, errorMsg);
                return;
            }

            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPasswordHash(ObjectUtils.hashPassword(password));
            user.setCreatedDate(LocalDateTime.now());
            user.setStatus("Active");
            user.setUserId(UUID.randomUUID());
            user.setNormalizedUserName(username.toUpperCase());
            user.setNormalizedEmail(email.toUpperCase());
            user.setEmailVerifed(false);
            user.setSecurityStamp(UUID.randomUUID().toString());
            user.setConcurrencyStamp(UUID.randomUUID().toString());
            user.setTwoFactorEnabled(false);
            user.setLockoutEnabled(true);
            user.setAccessFailedCount(0);

            Role userRole = roleService.findByRoleName(RoleConstants.USER);
            if (userRole == null) {
                forwardWithError(request, response, "Default user role not found!");
                return;
            }
            user.setRoleId(userRole.getRoleId());
            userService.add(user);

            // Generate and send OTP
            String otp = emailOTPService.generateOtp();
            EmailOTPVerification otpEntity = new EmailOTPVerification();
            otpEntity.setId(UUID.randomUUID());
            otpEntity.setOtp(otp);
            otpEntity.setUserId(user.getUserId());
            otpEntity.setCreatedAt(LocalDateTime.now());
            otpEntity.setExpiryTime(LocalDateTime.now().plusMinutes(10));
            otpEntity.setIsUsed(false);
            otpEntity.setResendCount(0);
            otpEntity.setLastResendTime(null);
            otpEntity.setResendBlockUntil(null);
            emailOTPService.add(otpEntity);
            
            mailService.sendOtpEmail(user.getEmail(), otp, user.getUsername());

            SessionUtil.setSessionAttribute(request, "userId", user.getUserId().toString());
            SessionUtil.setSessionAttribute(request, "email", user.getEmail());
            SessionUtil.setSessionAttribute(request, "username", user.getUsername());
            
            response.sendRedirect(request.getContextPath() + "/verify-otp");
            
        } catch (Exception e) {
            forwardWithError(request, response, "An unexpected error occurred. Please try again later.");
        }
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String errorMsg) throws ServletException, IOException {
        request.setAttribute("error", errorMsg);
        request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
    }
}