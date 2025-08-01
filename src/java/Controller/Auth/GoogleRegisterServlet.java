package Controller.Auth;

import Mapper.UserMapper;
import Model.Entity.OAuth.EmailOTPVerification;
import Model.Entity.OAuth.GoogleUser;
import Model.Entity.User.User;
import Model.Entity.OAuth.UserLogins;
import Model.Entity.Role.Role;
import Model.Constants.RoleConstants;
import Service.Auth.EmailOTPVerificationService;
import Service.User.UserService;
import Service.Auth.GoogleAuthService;
import Service.Auth.UserLoginsService;
import Service.External.MailService;
import Service.Role.RoleService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Utils.SessionUtil;
import java.util.UUID;
import java.time.LocalDateTime;

// googleRegister
public class GoogleRegisterServlet extends HttpServlet {

    private GoogleAuthService googleAuthService;
    private UserMapper userMapper;
    private UserService userService;
    private UserLoginsService userLoginsService;
    private RoleService roleService;
    private MailService mailService;
    private EmailOTPVerificationService emailOTP;

    @Override
    public void init() {
        googleAuthService = new GoogleAuthService();
        userMapper = new UserMapper();
        userService = new UserService();
        userLoginsService = new UserLoginsService();
        roleService = new RoleService();
        mailService = new MailService();
        emailOTP = new EmailOTPVerificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect(googleAuthService.getAuthorizationRegisterUrl());
            return;
        }
        try {
            GoogleUser googleUser = googleAuthService.getUserInfoRegister(code);
            String email = googleUser.getEmail();
            
            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Cannot retrieve email from Google account. Please try again or contact support.");
                request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
                return;
            }
            
            // Step 1: Check if this Google account is already linked to any user
            UserLogins existingUserLogin = userLoginsService.findByProviderAndKey("google", googleUser.getGoogleId());
            
            if (existingUserLogin != null) {
                // Google account is already linked to another user
                request.setAttribute("error", "This Google account is already linked to another user. Please use a different Google account or log in with the existing account.");
                request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
                return;
            }
            
            // Step 2: Check if email already exists in our system
            User existingUser = userService.findByEmail(email);
            if (existingUser != null) {
                String errorMsg;
                if (existingUser.isDeleted()) {
                    errorMsg = "This email is associated with a deleted account and cannot be reused.";
                } else if (existingUser.isBanned()) {
                    errorMsg = "This email is associated with a banned account. Please contact support.";
                } else {
                    errorMsg = "An account with email " + email + " already exists. Please log in with your existing account or use a different Google account.";
                }
                request.setAttribute("error", errorMsg);
                request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
                return;
            }

            // Step 3: Proceed with registration
            User newUser = userMapper.mapGoogleUserToUser(googleUser, userService);
            newUser.setEmailVerifed(true);
            Role userRole = roleService.findByRoleName(RoleConstants.USER);
            if (userRole == null) {
                request.setAttribute("error", "Default user role not found!");
                request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
                return;
            }
            newUser.setRoleId(userRole.getRoleId());
            userService.add(newUser);
            
            request.getSession().setAttribute("userId", newUser.getUserId().toString());
            UserLogins userLogins = userMapper.mapGoogleUserToUserLogins(googleUser, newUser);
            userLoginsService.add(userLogins);

            response.sendRedirect(request.getContextPath() + "/setPassword");
            return;
        } catch (Exception e) {
            request.setAttribute("error", "Google registration failed: " + e.getMessage());
            request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }
}
