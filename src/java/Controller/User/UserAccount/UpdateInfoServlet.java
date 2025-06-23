package Controller.User.UserAccount;

import Exception.NotFoundException;
import Model.Entity.User.User;
import Service.User.UserService;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.time.LocalDate;
import java.time.Period;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.HashMap;
import java.util.Map;

//@WebServlet(name = "UpdateInfoServlet", urlPatterns = {"/user/update-info"})
public class UpdateInfoServlet extends HttpServlet {
    private UserService userService;
    
    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }

        // Re-check user status from DB to prevent actions from banned/deleted accounts with active sessions
        try {
            User freshUser = userService.findById(user.getUserId());
            if (freshUser.isBanned() || freshUser.isDeleted()) {
                request.getSession().invalidate(); // Log them out
                response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp?error=Your+account+is+no+longer+active.");
                return;
            }
        } catch (NotFoundException e) {
            request.getSession().invalidate(); // Log them out
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp?error=User+not+found.");
            return;
        }

        UUID userId = user.getUserId();
        String username = request.getParameter("username");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");

        Map<String, String> errors = new HashMap<>();

        if (username == null || username.trim().isEmpty()) {
            errors.put("usernameError", "Username cannot be empty.");
        } else {
            if (username.length() < 3 || username.length() > 30) {
                errors.put("usernameError", "Username must be 3-30 characters.");
            }
            if (!username.matches("^[\\p{L}0-9 ]+$")) {
                errors.put("usernameError", "Username must not contain special characters.");
            }
        }

        if (dob == null || dob.trim().isEmpty()) {
            errors.put("dobError", "Date of birth cannot be empty.");
        } else {
            try {
                DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                LocalDate birthDate = LocalDate.parse(dob, inputFormatter);
                int age = Period.between(birthDate, LocalDate.now()).getYears();
                if (age < 18) {
                    errors.put("dobError", "You must be at least 18 years old!");
                }
                dob = birthDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
            } catch (DateTimeParseException e) {
                errors.put("dobError", "Invalid date format!");
            }
        }

        if (gender == null || !(gender.equals("Male") || gender.equals("Female"))) {
            errors.put("genderError", "Gender is required.");
        }

        if (!errors.isEmpty()) {
            for (Map.Entry<String, String> entry : errors.entrySet()) {
                request.setAttribute(entry.getKey(), entry.getValue());
            }
            request.setAttribute("profile_username", username);
            request.setAttribute("profile_userDOB", request.getParameter("dob")); // giữ lại định dạng nhập
            request.setAttribute("profile_gender", gender);
            request.getRequestDispatcher("/pages/user/user-profile.jsp").forward(request, response);
            return;
        }

        boolean updateSuccess = userService.updateUserInfo(userId, username, dob, gender);

        if (updateSuccess) {
            try {
                User updatedUser = userService.findById(userId);
                request.getSession().setAttribute("user", updatedUser);
            } catch (NotFoundException ex) {
                Logger.getLogger(UpdateInfoServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            request.getSession().setAttribute("success", "Update information successfully!");
            response.sendRedirect(request.getContextPath() + "/user/profile");
        } else {
            request.setAttribute("dobError", "Update information failed!");
            request.getRequestDispatcher("/pages/user/user-profile.jsp").forward(request, response);
        }
    }
}
