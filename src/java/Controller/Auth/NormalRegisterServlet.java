package Controller.Auth;

import Model.Entity.User;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Util.SessionUtil;
import Utils.ObjectUtils;
import java.time.LocalDateTime;
import java.util.Date;
import Service.UserService;
import java.util.UUID;
import java.sql.SQLException;

// /normalRegister
public class NormalRegisterServlet extends HttpServlet {

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

        if (username == null || username.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            request.setAttribute("errMsg", "All fields are required!");
            request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
            return;
        }

        if (username.trim().length() < 3) {
            request.setAttribute("errMsg", "Username must be at least 3 characters long!");
            request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
            return;
        }

        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            request.setAttribute("errMsg", "Invalid email format!");
            request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
            return;
        }

        if (!password.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,100}$")) {
            request.setAttribute("errMsg", "Password must be between 8 and 100 characters long and contain uppercase, lowercase, and numbers!");
            request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
            return;
        }

        if (!password.equals(repassword)) {
            request.setAttribute("errMsg", "Passwords do not match!");
            request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
            return;
        }

        UserService userService = new UserService();
        if (userService.isEmailExist(email)) {
            request.setAttribute("errMsg", "Email already exists!");
            request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
            return;
        }

        try {
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPasswordHash(ObjectUtils.hashPassword(password));
            user.setCreatedDate(LocalDateTime.now());
            user.setStatus("ACTIVE");
            user.setUserId(UUID.randomUUID());
            user.setNormalizedUserName(username.toUpperCase());
            user.setNormalizedEmail(email.toUpperCase());
            user.setEmailVerifed(false);
            user.setSecurityStamp(UUID.randomUUID().toString());
            user.setConcurrencyStamp(UUID.randomUUID().toString());
            user.setTwoFactorEnabled(false);
            user.setLockoutEnabled(true);
            user.setAccessFailedCount(0);
            user.setBanned(false);

            userService.add(user);

            SessionUtil.setSessionAttribute(request, "user", user);
//            SessionUtil.setSessionAttribute(request, "isLoggedIn", true);
            SessionUtil.setSessionAttribute(request, "successMsg", "Registration successful! Please login to continue.");
            SessionUtil.setCookie(response, "userId", user.getUserId().toString(), 30 * 24 * 60 * 60, true, false, "/");

            response.sendRedirect(request.getContextPath() + "/pages/index.jsp");

        } catch (Exception e) {
            e.printStackTrace();

            String errorMessage;
            if (e instanceof SQLException) {
                errorMessage = "Database error occurred. Please try again later.";
            } else if (e instanceof IllegalArgumentException) {
                errorMessage = "Invalid input data. Please check your information.";
            } else {
                errorMessage = "An unexpected error occurred. Please try again later.";
            }

            request.setAttribute("errMsg", errorMessage);
            request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
        }
    }
}
