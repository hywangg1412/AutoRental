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
    private static final String SESSION_USER = "user";
    private static final String SESSION_IS_LOGGED_IN = "isLoggedIn";
    private static final String COOKIE_USER_ID = "userId";
    private static final String COOKIE_PATH = "/";

    private UserService userService;
    private static final java.util.logging.Logger LOGGER = java.util.logging.Logger.getLogger(LogoutServlet.class.getName());

    @Override
    public void init() throws ServletException {
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) SessionUtil.getSessionAttribute(request, SESSION_USER);
        if (user != null) {
            userService.updateStatus(user.getUserId(), UserStatusConstants.INACTIVE);
            LOGGER.info("User logged out: " + user.getUserId());
        }
        SessionUtil.invalidateSession(request);
        SessionUtil.deleteCookie(response, COOKIE_USER_ID, COOKIE_PATH);
        response.sendRedirect(request.getContextPath() + "/pages/home");
    }
} 