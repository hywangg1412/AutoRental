package Controller.Auth;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Model.Entity.User.User;
import Service.User.UserService;
import Utils.ObjectUtils;
import java.util.UUID;

// /setPassword
public class SetPasswordServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() {
        System.out.println("Debug - SetPasswordServlet initialized");
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/authen/SetPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        System.out.println("Debug - SetPasswordServlet doPost called");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        System.out.println("Debug - newPassword: " + (newPassword != null ? "not null" : "null"));
        System.out.println("Debug - confirmPassword: " + (confirmPassword != null ? "not null" : "null"));
        HttpSession session = request.getSession();
        String userIdStr = (String) session.getAttribute("userId");
        System.out.println("Debug - userId from session: " + userIdStr);
        if (userIdStr == null || userIdStr.isEmpty()) {
            request.setAttribute("error", "Invalid user information.");
            request.getRequestDispatcher("/pages/authen/SetPassword.jsp").forward(request, response);
            return;
        }
        if (newPassword == null || confirmPassword == null || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Password fields cannot be empty.");
            request.getRequestDispatcher("/pages/authen/SetPassword.jsp").forward(request, response);
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/pages/authen/SetPassword.jsp").forward(request, response);
            return;
        }
        if (!newPassword.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d).{8,100}$")) {
            request.setAttribute("error", "Password must be between 8 and 100 characters long and contain uppercase, lowercase, and numbers.");
            request.getRequestDispatcher("/pages/authen/SetPassword.jsp").forward(request, response);
            return;
        }
        try {
            UUID userId = UUID.fromString(userIdStr);
            User user = userService.findById(userId);
            if (user == null) {
                request.setAttribute("error", "User not found.");
                request.getRequestDispatcher("/pages/authen/SetPassword.jsp").forward(request, response);
                return;
            }
            String hashedPassword = ObjectUtils.hashPassword(newPassword);
            System.out.println("Debug - Hashed password: " + hashedPassword);
            user.setPasswordHash(hashedPassword);
            boolean updated = userService.update(user);
            System.out.println("Debug - Update result: " + updated);
            session.removeAttribute("userId");
            session.setAttribute("message", "Password set successfully. Please login.");
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
        } catch (Exception ex) {
            ex.printStackTrace();
            request.setAttribute("error", "An error occurred: " + ex.getMessage());
            request.getRequestDispatcher("/pages/authen/SetPassword.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Set password for new account";
    }
}
