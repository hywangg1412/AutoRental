package Controller.Auth;

import Model.Entity.User.User;
import Model.Entity.Role.Role;
import Model.Entity.Role.UserRole;
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

// /normalRegister
public class NormalRegisterServlet extends HttpServlet {

    private UserService userService;
    private RoleService roleService;
    private UserRoleService userRoleService;

    @Override
    public void init() {
        userService = new UserService();
        roleService = new RoleService();
        userRoleService = new UserRoleService();
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
            User existingUser = userService.findByEmail(email);
            if (existingUser != null) {
                String errorMsg = existingUser.isBanned() ?
                    "This email is associated with a banned account. Please contact support." :
                    "Email already exists!";
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

            User addedUser = userService.add(user);
            if (addedUser != null) {
                Role userRole = roleService.findByRoleName("User");
                if (userRole != null) {
                    UserRole newUserRole = new UserRole(addedUser.getUserId(), userRole.getRoleId());
                    userRoleService.add(newUserRole);
                }
                
                request.getSession().setAttribute("message", "Registration successful! Please login to continue.");
                response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            } else {
                request.setAttribute("error", "Register failed. Please try again.");
                request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
            }
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
