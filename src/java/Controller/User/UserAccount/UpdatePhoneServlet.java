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
import jakarta.servlet.http.HttpSession;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import Service.Role.RoleService;
import Model.Entity.Role.Role;
import Utils.SessionUtil;

@WebServlet(name = "UpdatePhoneServlet", urlPatterns = {"/user/update-phone"})
public class UpdatePhoneServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(UpdatePhoneServlet.class.getName());
    private static final String LOGIN_PAGE = "/pages/authen/SignIn.jsp";
    private UserService userService;
    private RoleService roleService;
    
    @Override
    public void init() {
        userService = new UserService();
        roleService = new RoleService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method is not supported");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) SessionUtil.getSessionAttribute(request, "user");
        
        if (user == null) {
            LOGGER.log(Level.INFO, "User not logged in, redirecting to login page");
            response.sendRedirect(request.getContextPath() + LOGIN_PAGE);
            return;
        }

        try {
            String phoneNumber = request.getParameter("phone");
            
            // Validate phone number
            if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
                SessionUtil.setSessionAttribute(request, "error", "Phone number cannot be empty!");
                response.sendRedirect(request.getContextPath() + "/user/profile");
                return;
            }
            
            // Remove all non-digit characters
            String cleanPhone = phoneNumber.replaceAll("\\D", "");
            
            // Check if contains only digits
            if (!cleanPhone.matches("^\\d+$")) {
                SessionUtil.setSessionAttribute(request, "error", "Phone number can only contain digits!");
                response.sendRedirect(request.getContextPath() + "/user/profile");
                return;
            }
            
            // Vietnamese phone number validation (10-11 digits starting with 0)
            if (!cleanPhone.matches("^0[0-9]{9,10}$")) {
                SessionUtil.setSessionAttribute(request, "error", "Please enter a valid Vietnamese phone number (10-11 digits starting with 0)!");
                response.sendRedirect(request.getContextPath() + "/user/profile");
                return;
            }

            boolean updateSuccess = userService.updatePhoneNumber(user.getUserId(), cleanPhone);
            if (updateSuccess) {
                User updatedUser = userService.findById(user.getUserId());
                SessionUtil.setSessionAttribute(request, "user", updatedUser);
                SessionUtil.setSessionAttribute(request, "success", "Phone number updated successfully!");
                String profileRedirect = "/user/profile";
                try {
                    Role userRole = roleService.findById(updatedUser.getRoleId());
                    if (userRole != null && "Staff".equalsIgnoreCase(userRole.getRoleName())) {
                        profileRedirect = "/staff/profile";
                    }
                } catch (Exception ex) {
                    // Nếu lỗi khi lấy role, giữ nguyên profileRedirect là /user/profile
                }
                response.sendRedirect(request.getContextPath() + profileRedirect);
                return;
            } else {
                SessionUtil.setSessionAttribute(request, "error", "Failed to update phone number!");
            }

        } catch (NotFoundException ex) {
            LOGGER.log(Level.SEVERE, "User not found while updating phone number", ex);
            SessionUtil.setSessionAttribute(request, "error", "User not found!");
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error updating phone number", ex);
            SessionUtil.setSessionAttribute(request, "error", "An error occurred while updating phone number!");
        }
        
        response.sendRedirect(request.getContextPath() + "/user/profile");
    }
}
