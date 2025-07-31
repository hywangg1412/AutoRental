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
import Service.Role.RoleService;
import Model.Entity.Role.Role;
import Utils.SessionUtil;

@WebServlet(name = "UpdateInfoServlet", urlPatterns = {"/user/update-info"})
public class UpdateInfoServlet extends HttpServlet {
    private static final String GENDER_MALE = "Male";
    private static final String GENDER_FEMALE = "Female";
    private static final String ROLE_STAFF = "Staff";
    private static final String USER_PROFILE_URL = "/user/profile";
    private static final String STAFF_PROFILE_URL = "/staff/profile";
    private static final String SIGNIN_PAGE = "/pages/authen/SignIn.jsp";
    private static final String USER_PROFILE_JSP = "/pages/user/user-profile.jsp";
    private static final String SUCCESS_MESSAGE = "Update information successfully!";
    private static final String UPDATE_FAILED_MESSAGE = "Update information failed!";
    
    private UserService userService;
    private RoleService roleService;
    private static final Logger LOGGER = Logger.getLogger(UpdateInfoServlet.class.getName());
    
    @Override
    public void init() {
        userService = new UserService();
        roleService = new RoleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) SessionUtil.getSessionAttribute(request, "user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + SIGNIN_PAGE);
            return;
        }

        // Re-check user status from DB to prevent actions from banned/deleted accounts with active sessions
        if (!isUserActive(user)) {
            SessionUtil.invalidateSession(request);
            request.setAttribute("error", "Your account is no longer active.");
            request.getRequestDispatcher(SIGNIN_PAGE).forward(request, response);
            return;
        }

        UUID userId = user.getUserId();
        String username = request.getParameter("username");
        String dob = request.getParameter("dob");
        String gender = request.getParameter("gender");

        Map<String, String> errors = new HashMap<>();
        errors.putAll(validateUsername(username, userId));
        errors.putAll(validateDateOfBirth(dob));
        errors.putAll(validateGender(gender));

        if (!errors.isEmpty()) {
            setErrorAttributes(request, errors, username, dob, gender);
            request.getRequestDispatcher(USER_PROFILE_JSP).forward(request, response);
            return;
        }

        // Format dob for database
        String formattedDob = formatDateForDatabase(dob);
        boolean updateSuccess = userService.updateUserInfo(userId, username, formattedDob, gender);

        if (updateSuccess) {
            handleSuccessfulUpdate(request, response, userId);
        } else {
            request.setAttribute("dobError", UPDATE_FAILED_MESSAGE);
            request.getRequestDispatcher(USER_PROFILE_JSP).forward(request, response);
        }
    }

    private boolean isUserActive(User user) {
        try {
            User freshUser = userService.findById(user.getUserId());
            return !freshUser.isBanned() && !freshUser.isDeleted();
        } catch (NotFoundException e) {
            return false;
        }
    }

    private Map<String, String> validateUsername(String username, UUID userId) {
        Map<String, String> errors = new HashMap<>();
        
        if (username == null || username.trim().isEmpty()) {
            errors.put("usernameError", "Username cannot be empty.");
            return errors;
        }
        
        if (username.length() < 3 || username.length() > 30) {
            errors.put("usernameError", "Username must be 3-30 characters.");
        }
        
        if (!username.matches("^[\\p{L}0-9 ]+$")) {
            errors.put("usernameError", "Username must not contain special characters.");
        }
        
        User userWithSameUsername = userService.findByUsername(username);
        if (userWithSameUsername != null && !userWithSameUsername.getUserId().equals(userId)) {
            errors.put("usernameError", "Username is already taken by another user.");
        }
        
        return errors;
    }

    private Map<String, String> validateDateOfBirth(String dob) {
        Map<String, String> errors = new HashMap<>();
        
        if (dob == null || dob.trim().isEmpty()) {
            errors.put("dobError", "Date of birth cannot be empty.");
            return errors;
        }
        
        try {
            DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            LocalDate birthDate = LocalDate.parse(dob, inputFormatter);
            int age = Period.between(birthDate, LocalDate.now()).getYears();
            
            if (age < 18) {
                errors.put("dobError", "You must be at least 18 years old!");
            }
        } catch (DateTimeParseException e) {
            errors.put("dobError", "Invalid date format!");
        }
        
        return errors;
    }

    private Map<String, String> validateGender(String gender) {
        Map<String, String> errors = new HashMap<>();
        
        if (gender == null || !(gender.equals(GENDER_MALE) || gender.equals(GENDER_FEMALE))) {
            errors.put("genderError", "Gender is required.");
        }
        
        return errors;
    }

    private String formatDateForDatabase(String dob) {
        try {
            DateTimeFormatter inputFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
            LocalDate birthDate = LocalDate.parse(dob, inputFormatter);
            return birthDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        } catch (DateTimeParseException e) {
            return dob; // Return original if parsing fails
        }
    }

    private void setErrorAttributes(HttpServletRequest request, Map<String, String> errors, 
                                  String username, String dob, String gender) {
        for (Map.Entry<String, String> entry : errors.entrySet()) {
            request.setAttribute(entry.getKey(), entry.getValue());
        }
        request.setAttribute("profile_username", username);
        request.setAttribute("profile_userDOB", dob);
        request.setAttribute("profile_gender", gender);
    }

    private void handleSuccessfulUpdate(HttpServletRequest request, HttpServletResponse response, UUID userId) 
            throws ServletException, IOException {
        try {
            User updatedUser = userService.findById(userId);
            SessionUtil.setSessionAttribute(request, "user", updatedUser);
            String profileRedirect = getProfileRedirectUrl(updatedUser);
            SessionUtil.setSessionAttribute(request, "success", SUCCESS_MESSAGE);
            response.sendRedirect(request.getContextPath() + profileRedirect);
        } catch (NotFoundException ex) {
            LOGGER.log(Level.SEVERE, "User not found after update", ex);
            SessionUtil.setSessionAttribute(request, "success", SUCCESS_MESSAGE);
            response.sendRedirect(request.getContextPath() + USER_PROFILE_URL);
        }
    }

    private String getProfileRedirectUrl(User user) {
        try {
            Role userRole = roleService.findById(user.getRoleId());
            if (userRole != null && ROLE_STAFF.equalsIgnoreCase(userRole.getRoleName())) {
                return STAFF_PROFILE_URL;
            }
        } catch (Exception ex) {
            LOGGER.log(Level.WARNING, "Error getting user role", ex);
        }
        return USER_PROFILE_URL;
    }
}
