package Controller.Auth;

import Model.Entity.User.User;
import Model.Entity.Role.Role;
import Model.Entity.Role.UserRole;
//import Service.Auth.EmailVerificationService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Utils.SessionUtil;
import Utils.ObjectUtils;
import java.time.LocalDateTime;
import java.util.Date;
import Service.User.UserService;
import Service.Role.RoleService;
import Service.Role.UserRoleService;
import java.util.UUID;
import java.sql.SQLException;
import Service.Auth.EmailOTPVerificationService;
import Model.Entity.OAuth.EmailOTPVerification;
import Service.External.MailService;

// /normalRegister
public class NormalRegisterServlet extends HttpServlet {

    private UserService userService;
    private RoleService roleService;
    private UserRoleService userRoleService;
//    private EmailVerificationService emailVerificationService;

    @Override
    public void init() {
        userService = new UserService();
        roleService = new RoleService();
        userRoleService = new UserRoleService();
//        emailVerificationService = new EmailVerificationService();
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
        if (username == null || username.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required!");
            request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
            return;
        }
        if (username.trim().length() < 3) {
            request.setAttribute("error", "Username must be at least 3 characters long!");
            request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
            return;
        }
        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            request.setAttribute("error", "Invalid email format!");
            request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
            return;
        }
        if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,100}$")) {
            request.setAttribute("error", "Password must be between 8 and 100 characters long and contain uppercase, lowercase, and numbers!");
            request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
            return;
        }
        if (!password.equals(repassword)) {
            request.setAttribute("error", "Passwords do not match!");
            request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
            return;
        }

        try {
            User existingUserByUsername = userService.findByUsername(username);
            if (existingUserByUsername != null) {
                request.setAttribute("error", "Username is already taken!");
                request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
                return;
            }
            User existingUser = userService.findByEmail(email);
            if (existingUser != null) {
                String errorMsg;
                if (existingUser.isDeleted()) {
                    errorMsg = "This email is associated with a deleted account and cannot be reused.";
                } else if (existingUser.isBanned()) {
                    errorMsg = "This email is associated with a banned account. Please contact support.";
                } else {
                    errorMsg = "An account with this email already exists.";
                }
                request.setAttribute("error", errorMsg);
                request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
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

            userService.add(user);

            EmailOTPVerificationService emailOTPService = new EmailOTPVerificationService();
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
            MailService mailService = new MailService();
            mailService.sendOtpEmail(user.getEmail(), otp, user.getUsername());

            SessionUtil.setSessionAttribute(request, "pendingUserType", "normal");
            SessionUtil.setSessionAttribute(request, "pendingUser", user);
            SessionUtil.setSessionAttribute(request, "userId", user.getUserId().toString());
            SessionUtil.setSessionAttribute(request, "username", user.getUsername());
            response.sendRedirect(request.getContextPath() + "/verify-otp");
        } catch (Exception e) {
            String errorMessage;
            if (e instanceof SQLException) {
                errorMessage = "Database error occurred. Please try again later.";
            } else if (e instanceof IllegalArgumentException) {
                errorMessage = "Invalid input data. Please check your information.";
            } else {
                errorMessage = "An unexpected error occurred. Please try again later.";
            }
            request.setAttribute("error", errorMessage);
            request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
        }
    }
}
