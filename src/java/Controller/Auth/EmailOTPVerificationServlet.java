package Controller.Auth;

import Model.Entity.OAuth.UserLogins;
import Model.Entity.Role.Role;
import Model.Entity.Role.UserRole;
import Model.Entity.User.User;
import Service.Auth.EmailOTPVerificationService;
import Service.Auth.UserLoginsService;
import Service.Role.RoleService;
import Service.Role.UserRoleService;
import Service.User.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;
import java.util.logging.Logger;
import java.util.logging.Level;
import Utils.SessionUtil;

@WebServlet("/verify-otp")
public class EmailOTPVerificationServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(EmailOTPVerificationServlet.class.getName());
    private static final String OTP_PATTERN = "^\\d{6}$";
    
    private EmailOTPVerificationService emailVerificationService;
    private UserService userService;
    private RoleService roleService;
    private UserRoleService userRoleService;
    private UserLoginsService userLoginsService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.emailVerificationService = new EmailOTPVerificationService();
        this.userService = new UserService();
        this.roleService = new RoleService();
        this.userRoleService = new UserRoleService();
        this.userLoginsService = new UserLoginsService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        Object pendingUserLogins = session.getAttribute("pendingUserLogins");
        Object pendingUserType = session.getAttribute("pendingUserType");
        if (pendingUserLogins != null && "normal".equals(pendingUserType)) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }
        
        String userIdStr = (String) SessionUtil.getSessionAttribute(request, "userId");
        if (userIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }
        
        try {
            UUID.fromString(userIdStr);
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Invalid UUID format in session: " + userIdStr);
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }
        
        request.getRequestDispatcher("pages/authen/verify-otp.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String otp = request.getParameter("otp");
        HttpSession session = request.getSession();
        String userIdStr = (String) SessionUtil.getSessionAttribute(request, "userId");

        if (!validateInput(otp, userIdStr)) {
            forwardWithError(request, response, "Please enter a valid 6-digit OTP code.");
            return;
        }

        try {
            UUID userId = UUID.fromString(userIdStr);
            boolean isVerified = emailVerificationService.verifyOtp(userId, otp);

            if (isVerified) {
                handleSuccessfulVerification(request, response, session, userId);
            } else {
                forwardWithError(request, response, "OTP verification failed. The code may be expired or invalid. Please try again or request a new OTP.");
            }
        } catch (IllegalArgumentException e) {
            LOGGER.log(Level.WARNING, "Invalid UUID format: " + userIdStr, e);
            forwardWithError(request, response, "Invalid session. Please try logging in again.");
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during OTP verification", e);
            forwardWithError(request, response, "An error occurred during OTP verification. Please try again. If the problem persists, please contact support.");
        }
    }

    private boolean validateInput(String otp, String userIdStr) {
        if (otp == null || otp.trim().isEmpty() || userIdStr == null || userIdStr.trim().isEmpty()) {
            return false;
        }
        return otp.trim().matches(OTP_PATTERN);
    }

    private void handleSuccessfulVerification(HttpServletRequest request, HttpServletResponse response, 
                                            HttpSession session, UUID userId) throws ServletException, IOException {
        try {
            User addedUser = userService.findById(userId);
            if (addedUser == null) {
                forwardWithError(request, response, "User not found. Please try logging in again.");
                return;
            }

            // Process user login info (for OAuth users)
            UserLogins pendingUserLogins = (UserLogins) session.getAttribute("pendingUserLogins");
            if (pendingUserLogins != null) {
                pendingUserLogins.setUserId(addedUser.getUserId());
                userLoginsService.add(pendingUserLogins);
            }

            SessionUtil.setSessionAttribute(request, "userId", addedUser.getUserId().toString());

            clearPendingSessionAttributes(session);

            forwardWithSuccess(request, response, 
                "Email verified successfully! Please sign in.", 
                "/pages/authen/SignIn.jsp");
            
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error processing successful verification", e);
            forwardWithError(request, response, "Verification successful but there was an error processing your account. Please contact support.");
        }
    }

    private void clearPendingSessionAttributes(HttpSession session) {
        session.removeAttribute("pendingUser");
        session.removeAttribute("pendingUserLogins");
        session.removeAttribute("pendingUserType");
        session.removeAttribute("email");
        session.removeAttribute("username");
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String errorMsg) 
            throws ServletException, IOException {
        request.setAttribute("error", errorMsg);
        request.getRequestDispatcher("pages/authen/verify-otp.jsp").forward(request, response);
    }

    private void forwardWithSuccess(HttpServletRequest request, HttpServletResponse response, 
                                  String successMsg, String redirectPath) throws ServletException, IOException {
        request.setAttribute("success", successMsg);
        request.getRequestDispatcher(redirectPath).forward(request, response);
    }
} 