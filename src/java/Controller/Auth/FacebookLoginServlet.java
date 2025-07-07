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
                UserLogins userLogin = userLoginsService.findByProviderAndKey("facebook", facebookUser.getFacebookId());
                User user = null;
                if (userLogin == null) {
                    user = userService.findByEmail(email);
                    if (user != null) {
                        request.setAttribute("error", "This email is already registered. Please log in with your email and link your Facebook account from your profile.");
                        request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                        return;
                    } else {
                        request.setAttribute("error", "This Facebook account has not been registered.");
                        request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                        return;
                    }
                } else {
                    user = userService.findById(userLogin.getUserId());
                }
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

                String redirectUrl = "/pages/home";
                if (user.getRoleId() != null) {
                    String roleIdStr = user.getRoleId().toString();
                    if (roleIdStr.equals("550e8400-e29b-41d4-a716-446655440000")) { // Staff
                        redirectUrl = "/pages/staff/staff-dashboard.jsp";
                    } else if (roleIdStr.equals("7c9e6679-7425-40de-944b-e07fc1f90ae7")) { // Admin
                        redirectUrl = "/pages/admin/admin-dashboard.jsp";
                    }
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
