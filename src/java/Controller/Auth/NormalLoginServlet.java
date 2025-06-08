package Controller.Auth;

import Model.Entity.User;
import Service.UserService;
import Utils.SessionUtil;
import Utils.ObjectUtils;
import java.io.IOException;
import java.time.LocalDateTime;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// /normalLogin
public class NormalLoginServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("pages/authen/SignIn.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required!");
            request.getRequestDispatcher("pages/authen/SignIn.jsp").forward(request, response);
            return;
        }
        try {
            User user = userService.findByEmail(email);
            if (user == null) {
                request.setAttribute("error", "Email not found!");
                request.getRequestDispatcher("pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            if (user.isBanned()) {
                request.setAttribute("error", "This account has been banned. Please contact support.");
                request.getRequestDispatcher("pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            if (user.isLockoutEnabled() && user.getAccessFailedCount() >= 5) {
                user.setStatus("Banned");
                user.setAccessFailedCount(0);
                userService.update(user);
                request.setAttribute("error", "Account is locked due to too many failed attempts. Please contact support.");
                request.getRequestDispatcher("pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            if (!ObjectUtils.verifyPassword(password, user.getPasswordHash())) {
                user.setAccessFailedCount(user.getAccessFailedCount() + 1);
                if (user.isLockoutEnabled() && user.getAccessFailedCount() >= 5) {
                    user.setStatus("Banned");
                    user.setAccessFailedCount(0);
                    userService.update(user);
                    request.setAttribute("error", "Account is locked due to too many failed attempts. Please contact support.");
                } else {
                    userService.update(user);
                    request.setAttribute("error", "Invalid password! " + (5 - user.getAccessFailedCount()) + " attempts remaining.");
                }
                request.getRequestDispatcher("pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            if (user.getAccessFailedCount() > 0) {
                user.setAccessFailedCount(0);
                userService.update(user);
            }
            SessionUtil.setSessionAttribute(request, "user", user);
            SessionUtil.setSessionAttribute(request, "isLoggedIn", true);
            SessionUtil.setCookie(response, "userId", user.getUserId().toString(), 30 * 24 * 60 * 60, true, false, "/");
            response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred during login. Please try again later.");
            request.getRequestDispatcher("pages/authen/SignIn.jsp").forward(request, response);
        }
    }
}
