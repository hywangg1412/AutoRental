package Controller.User.UserAccount;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Model.Entity.User.User;
import Service.User.UserService;
import Utils.ObjectUtils;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/user/change-password"})
public class ChangePasswordServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/pages/user/change-password.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        Map<String, String> errors = new HashMap<>();

        if (currentPassword == null || currentPassword.isEmpty()) {
            errors.put("currentPasswordError", "Current password cannot be empty.");
        }
        if (newPassword == null || newPassword.isEmpty()) {
            errors.put("newPasswordError", "New password cannot be empty.");
        }
        if (confirmPassword == null || confirmPassword.isEmpty()) {
            errors.put("confirmPasswordError", "Confirm password cannot be empty.");
        }

        if (!ObjectUtils.verifyPassword(currentPassword, user.getPasswordHash())) {
            errors.put("currentPasswordError", "Current password is incorrect.");
        }

//        if (newPassword != null && !newPassword.matches("^(?=.*[a-z])(?=.*[A-Z])(?=.*\\d)(?=.*[!@#$%^&*()_+\-=[\]{};':\"\\|,.<>/?]).{8,100}$")) {
//            errors.put("newPasswordError", "Password must be 8-100 characters, có chữ hoa, chữ thường, số và ký tự đặc biệt.");
//        }
        if (newPassword != null && newPassword.equals(currentPassword)) {
            errors.put("newPasswordError", "New password must be different from current password.");
        }
        if (newPassword != null && !newPassword.equals(confirmPassword)) {
            errors.put("confirmPasswordError", "Passwords do not match.");
        }

        if (!errors.isEmpty()) {
            for (Map.Entry<String, String> entry : errors.entrySet()) {
                request.setAttribute(entry.getKey(), entry.getValue());
            }
            String fromStaffProfile = request.getParameter("fromStaffProfile");
            if ("true".equals(fromStaffProfile)) {
                request.getRequestDispatcher("/pages/staff/profile/staff-change-password.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/pages/user/change-password.jsp").forward(request, response);
            }
            return;
        }

        try {
            user.setPasswordHash(ObjectUtils.hashPassword(newPassword));
            userService.update(user);
            request.getSession().invalidate();
            request.setAttribute("success", "Password changed successfully. Please login again.");
            String fromStaffProfile = request.getParameter("fromStaffProfile");
            if ("true".equals(fromStaffProfile)) {
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
            }
        } catch (Exception ex) {
            request.setAttribute("error", "An error occurred: " + ex.getMessage());
            String fromStaffProfile = request.getParameter("fromStaffProfile");
            if ("true".equals(fromStaffProfile)) {
                request.getRequestDispatcher("/pages/staff/profile/staff-change-password.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("/pages/user/change-password.jsp").forward(request, response);
            }
        }
    }
}
