    package Controller.Auth;

import Exception.EventException;
import Exception.NotFoundException;
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
    import Service.Role.RoleService;
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
        private MailService mailService;
        private EmailOTPVerificationService emailOTPService;

        @Override
        public void init() {
            facebookAuthService = new FacebookAuthService();
            userMapper = new UserMapper();
            userService = new UserService();
            userLoginsService = new UserLoginsService();
            roleService = new RoleService();
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
                String email = facebookUser.getEmail();
                
                if (email == null || email.trim().isEmpty()) {
                    request.setAttribute("error", "Cannot retrieve email from Facebook account. Please try again or contact support.");
                    request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                    return;
                }
                
                // Step 1: Check if this Facebook account is already linked to any user
                UserLogins userLogin = userLoginsService.findByProviderAndKey("facebook", facebookUser.getFacebookId());
                User user = null;
                
                if (userLogin != null) {
                    // Facebook account is already linked - proceed with login
                    user = userService.findById(userLogin.getUserId());
                    if (user == null) {
                        request.setAttribute("error", "Linked account not found. Please contact support.");
                        request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                        return;
                    }
                } else {
                    // Facebook account is not linked - check if email exists
                    User existingUser = userService.findByEmail(email);
                    
                    if (existingUser != null) {
                        // Email exists - allow login and optionally link the account
                        user = existingUser;
                        
                        // Optionally auto-link the Facebook account to the existing user
                        try {
                            UserLogins newUserLogin = new UserLogins();
                            newUserLogin.setUserId(user.getUserId());
                            newUserLogin.setLoginProvider("facebook");
                            newUserLogin.setProviderKey(facebookUser.getFacebookId());
                            newUserLogin.setProviderDisplayName(facebookUser.getFullName());
                            userLoginsService.add(newUserLogin);
                        } catch (Exception e) {
                            // If linking fails, still allow login but log the error
                            System.err.println("Failed to auto-link Facebook account: " + e.getMessage());
                        }
                    } else {
                        // Email doesn't exist - redirect to registration
                        request.setAttribute("error", "No account found with email " + email + ". Please register first.");
                        request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                        return;
                    }
                }
                
                // Process user login
                if (processUserLogin(request, response, user)) {
                    return; // Login successful, redirect handled in processUserLogin
                }
                
            } catch (Exception e) {
                request.setAttribute("error", "Facebook login failed: " + e.getMessage());
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
            }
        }

        /**
         * Process user login after authentication
         * Returns true if login was successful and redirect was handled
         */
        private boolean processUserLogin(HttpServletRequest request, HttpServletResponse response, User user) 
                throws ServletException, IOException, EventException, NotFoundException {
            
            // Check if account is deleted
            if (user.isDeleted()) {
                request.setAttribute("error", "This account has been deleted. Please contact support if this is an error.");
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                return true;
            }
            
            // Check if account is banned
            if (user.isBanned()) {
                request.setAttribute("error", "This account has been banned. Please contact support for more information.");
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                return true;
            }
            
            // Reset failed login attempts
            if (user.getAccessFailedCount() > 0) {
                user.setAccessFailedCount(0);
                userService.update(user);
            }
            
            // Activate account if inactive
            if (!user.isActive()) {
                user.setStatus(UserStatusConstants.ACTIVE);
                userService.update(user);
            }
            
            // Check email verification
            if (!user.isEmailVerifed()) {
                EmailOTPVerification otp = emailOTPService.findByUserId(user.getUserId());
                if (otp != null) {
                    mailService.sendOtpEmail(user.getEmail(), otp.getOtp(), user.getUsername());
                }
                request.setAttribute("error", "Your email has not been verified. A new verification code has been sent to your email.");
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                return true;
            }
            
            // Login successful - set session and redirect
            SessionUtil.removeSessionAttribute(request, "user");
            SessionUtil.setSessionAttribute(request, "user", user);
            SessionUtil.setSessionAttribute(request, "userId", user.getUserId().toString());
            SessionUtil.setSessionAttribute(request, "isLoggedIn", true);
            SessionUtil.setCookie(response, "userId", user.getUserId().toString(), 30 * 24 * 60 * 60, true, false, "/");
            
            String redirectUrl = "/pages/home";
            try {
                Role userRole = roleService.findById(user.getRoleId());
                if (userRole != null) {
                    String roleName = userRole.getRoleName();
                    if ("Staff".equalsIgnoreCase(roleName)) {
                        redirectUrl = "/staff/dashboard";
                    } else if ("Admin".equalsIgnoreCase(roleName)) {
                        redirectUrl = "/admin/dashboard";
                    }
                }
            } catch (Exception ex) {
                // If error getting role, keep default redirectUrl
            }
            
            response.sendRedirect(request.getContextPath() + redirectUrl);
            return true;
        }

        @Override
        protected void doPost(HttpServletRequest request, HttpServletResponse response)
                throws ServletException, IOException {
        }
    }
