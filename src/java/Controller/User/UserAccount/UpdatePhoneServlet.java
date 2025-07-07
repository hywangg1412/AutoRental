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

@WebServlet(name = "UpdatePhoneServlet", urlPatterns = {"/user/update-phone"})
public class UpdatePhoneServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(UpdatePhoneServlet.class.getName());
    private static final String LOGIN_PAGE = "/pages/authen/SignIn.jsp";
    private UserService userService;
    
    @Override
    public void init() {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "GET method is not supported");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null) {
            LOGGER.log(Level.INFO, "User not logged in, redirecting to login page");
            response.sendRedirect(request.getContextPath() + LOGIN_PAGE);
            return;
        }

        try {
            String phoneNumber = request.getParameter("phone");
            if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
                session.setAttribute("error", "Phone number cannot be empty!");
                response.sendRedirect(request.getContextPath() + "/user/profile");
                return;
            }

            boolean updateSuccess = userService.updatePhoneNumber(user.getUserId(), phoneNumber);
            if (updateSuccess) {
                User updatedUser = userService.findById(user.getUserId());
                session.setAttribute("user", updatedUser);
                session.setAttribute("success", "Phone number updated successfully!");
            } else {
                session.setAttribute("error", "Failed to update phone number!");
            }

        } catch (NotFoundException ex) {
            LOGGER.log(Level.SEVERE, "User not found while updating phone number", ex);
            session.setAttribute("error", "User not found!");
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error updating phone number", ex);
            session.setAttribute("error", "An error occurred while updating phone number!");
        }
        
        response.sendRedirect(request.getContextPath() + "/user/profile");
    }
}
