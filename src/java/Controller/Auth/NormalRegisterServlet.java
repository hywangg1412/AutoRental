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
import java.sql.SQLException;

@WebServlet("/normalRegister")
public class NormalRegisterServlet extends HttpServlet {

    // Constants
    private static final String SIGNUP_PAGE = "pages/authen/SignUp.jsp";
    private static final String VERIFY_OTP_URL = "/verify-otp";
    private static final String USER_ROLE = "USER";
    private static final String ACTIVE_STATUS = "Active";
    
    // Validation patterns
    private static final String EMAIL_PATTERN = "^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$";
    private static final String PASSWORD_PATTERN = "^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,100}$";
    
    // Messages
    private static final String MSG_ALL_FIELDS_REQUIRED = "All fields are required!";
    private static final String MSG_USERNAME_TOO_SHORT = "Username must be at least 3 characters long!";
    private static final String MSG_INVALID_EMAIL = "Invalid email format!";
    private static final String MSG_INVALID_PASSWORD = "Password must be between 8 and 100 characters long and contain uppercase, lowercase, and numbers!";
    private static final String MSG_PASSWORDS_NOT_MATCH = "Passwords do not match!";
    private static final String MSG_USERNAME_DELETED = "This username is associated with a deleted account and cannot be reused.";
    private static final String MSG_USERNAME_BANNED = "This username is associated with a banned account. Please contact support.";
    private static final String MSG_USERNAME_TAKEN = "Username is already taken!";
    private static final String MSG_EMAIL_DELETED = "This email is associated with a deleted account and cannot be reused.";
    private static final String MSG_EMAIL_BANNED = "This email is associated with a banned account. Please contact support.";
    private static final String MSG_EMAIL_EXISTS = "An account with this email already exists.";
    private static final String MSG_ROLE_NOT_FOUND = "Default user role not found!";
    private static final String MSG_UNEXPECTED_ERROR = "An unexpected error occurred. Please try again later.";

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
        response.sendRedirect(SIGNUP_PAGE);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String repassword = request.getParameter("repassword");

        // Validate input
        String validationError = validateInput(username, email, password, repassword);
        if (validationError != null) {
            forwardWithError(request, response, validationError);
            return;
        }

        try {
            // Check existing users
            String existingUserError = checkExistingUsers(username, email);
            if (existingUserError != null) {
                forwardWithError(request, response, existingUserError);
                return;
            }

            // Create and save user
            User user = createUser(username, email, password);
            userService.add(user);

            // Generate and send OTP
            createAndSendOTP(user);

            // Set session attributes and redirect
            setSessionAttributes(request, user);
            response.sendRedirect(request.getContextPath() + VERIFY_OTP_URL);
            
        } catch (Exception e) {
            forwardWithError(request, response, MSG_UNEXPECTED_ERROR);
        }
    }

    private String validateInput(String username, String email, String password, String repassword) {
        if (username == null || username.trim().isEmpty() || email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty()) {
            return MSG_ALL_FIELDS_REQUIRED;
        }
        if (username.trim().length() < 3) {
            return MSG_USERNAME_TOO_SHORT;
        }
        if (!email.matches(EMAIL_PATTERN)) {
            return MSG_INVALID_EMAIL;
        }
        if (!password.matches(PASSWORD_PATTERN)) {
            return MSG_INVALID_PASSWORD;
        }
        if (!password.equals(repassword)) {
            return MSG_PASSWORDS_NOT_MATCH;
        }
        return null;
    }

    private String checkExistingUsers(String username, String email) {
        User existingUserByUsername = userService.findByUsername(username);
        if (existingUserByUsername != null) {
            return existingUserByUsername.isDeleted() ? MSG_USERNAME_DELETED :
                   existingUserByUsername.isBanned() ? MSG_USERNAME_BANNED : MSG_USERNAME_TAKEN;
        }
        
        User existingUserByEmail = userService.findByEmail(email);
        if (existingUserByEmail != null) {
            return existingUserByEmail.isDeleted() ? MSG_EMAIL_DELETED :
                   existingUserByEmail.isBanned() ? MSG_EMAIL_BANNED : MSG_EMAIL_EXISTS;
        }
        return null;
    }

    private User createUser(String username, String email, String password) throws Exception {
        Role userRole = roleService.findByRoleName(RoleConstants.USER);
        if (userRole == null) {
            throw new Exception(MSG_ROLE_NOT_FOUND);
        }

        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPasswordHash(ObjectUtils.hashPassword(password));
        user.setCreatedDate(LocalDateTime.now());
        user.setStatus(ACTIVE_STATUS);
        user.setUserId(UUID.randomUUID());
        user.setNormalizedUserName(username.toUpperCase());
        user.setNormalizedEmail(email.toUpperCase());
        user.setEmailVerifed(false);
        user.setSecurityStamp(UUID.randomUUID().toString());
        user.setConcurrencyStamp(UUID.randomUUID().toString());
        user.setTwoFactorEnabled(false);
        user.setLockoutEnabled(true);
        user.setAccessFailedCount(0);
        user.setRoleId(userRole.getRoleId());
        
        return user;
    }

    private void createAndSendOTP(User user) throws Exception {
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
    }

    private void setSessionAttributes(HttpServletRequest request, User user) {
        SessionUtil.setSessionAttribute(request, "userId", user.getUserId().toString());
        SessionUtil.setSessionAttribute(request, "email", user.getEmail());
        SessionUtil.setSessionAttribute(request, "username", user.getUsername());
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String errorMsg) 
            throws ServletException, IOException {
        request.setAttribute("error", errorMsg);
        request.getRequestDispatcher(SIGNUP_PAGE).forward(request, response);
    }
}