package Controller.Auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Utils.SessionUtil;
import java.io.IOException;
import Model.Constants.UserStatusConstants;
import Model.Entity.User.User;
import Service.User.UserService;

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    private UserService userService;

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) SessionUtil.getSessionAttribute(request, "user");
        if (user != null) {
            userService.updateStatus(user.getUserId(), UserStatusConstants.INACTIVE);
        }
        SessionUtil.removeSessionAttribute(request, "user");
        SessionUtil.removeSessionAttribute(request, "isLoggedIn");
        
        SessionUtil.deleteCookie(response, "userId", "/");
        
        response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
    }
} 