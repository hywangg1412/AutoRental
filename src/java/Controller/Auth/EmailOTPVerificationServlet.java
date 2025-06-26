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
import Utils.SessionUtil;

@WebServlet("/verify-otp")
public class EmailOTPVerificationServlet extends HttpServlet {
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
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        UUID userId = null;
        try {
            userId = UUID.fromString(userIdStr);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/login");
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

        if (otp == null || otp.trim().isEmpty() || userIdStr == null || userIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Please enter the OTP code.");
            request.getRequestDispatcher("pages/authen/verify-otp.jsp").forward(request, response);
            return;
        }

        try {
            UUID userId = UUID.fromString(userIdStr);
            boolean isVerified = emailVerificationService.verifyOtp(userId, otp);

            if (isVerified) {
                User pendingUser = (User) session.getAttribute("pendingUser");
                UserLogins pendingUserLogins = (UserLogins) session.getAttribute("pendingUserLogins");
                String roleName = (String) session.getAttribute("pendingUserRoleName");

                User addedUser = userService.findById(userId);

                if (roleName != null && addedUser != null) {
                    Role userRole = roleService.findByRoleName(roleName);
                    if (userRole != null) {
                        UserRole newUserRole = new UserRole(addedUser.getUserId(), userRole.getRoleId());
                        userRoleService.add(newUserRole);
                    }
                }

                if (pendingUserLogins != null && addedUser != null) {
                    pendingUserLogins.setUserId(addedUser.getUserId());
                    userLoginsService.add(pendingUserLogins);
                }

                // Lấy pendingUserType trước khi xóa session
                String pendingUserType = (String) session.getAttribute("pendingUserType");
                session.removeAttribute("pendingUser");
                session.removeAttribute("pendingUserLogins");
                session.removeAttribute("pendingUserRoleName");
                session.removeAttribute("pendingUserType");
                SessionUtil.setSessionAttribute(request, "userId", addedUser.getUserId().toString());

                if ("normal".equals(pendingUserType)) {
                    session.setAttribute("message", "Email verified successfully! Please sign in.");
                    response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
                    return;
                } else {
                    request.setAttribute("success", "Email verified successfully! Please set your password.");
                    request.getRequestDispatcher("/setPassword").forward(request, response);
                    return;
                }
            } else {
                request.setAttribute("error", "OTP verification failed. The code may be expired or invalid.");
                request.setAttribute("message", "Please try again or request a new OTP.");
            }
        } catch (Exception e) {
            System.err.println("Error during OTP verification: " + e.getMessage());
            request.setAttribute("error", "An error occurred during OTP verification. Please try again.");
            request.setAttribute("message", "If the problem persists, please contact support.");
        }
        request.getRequestDispatcher("pages/authen/verify-otp.jsp").forward(request, response);
    }
} 