package Controller.Auth;

import Mapper.UserMapper;
import Service.auth.GoogleAuthService;
import Model.Entity.OAuth.GoogleUser;
import Service.UserService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Util.SessionUtil;
import Model.Entity.User;
import Model.Entity.OAuth.UserLogins;
import Service.auth.UserLoginsService;

// googleLogin
public class GoogleLoginServlet extends HttpServlet {

    private GoogleAuthService googleAuthService;
    private UserMapper userMapper;
    private UserService userService;
    private UserLoginsService userLoginsService;

    @Override
    public void init() {
        googleAuthService = new GoogleAuthService();
        userMapper = new UserMapper();
        userService = new UserService();
        userLoginsService = new UserLoginsService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect(googleAuthService.getAuthorizationUrl());
            return;
        }
        try {
            GoogleUser googleUser = googleAuthService.getUserInfo(code);
            String email = googleUser.getEmail();
            if (email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Cannot retrieve email from Google account.");
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            UserLogins userLogin = userLoginsService.findByProviderAndKey("google", googleUser.getGoogleId());
            if (userLogin == null) {
                request.setAttribute("error", "This Google account has not been registered.");
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            User user = userService.findById(userLogin.getUserId());
            if (user == null) {
                request.setAttribute("error", "This account does not exist.");
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            if (user.isBanned()) {
                request.setAttribute("error", "This account has been banned. Please contact support.");
                request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
                return;
            }
            if (user.getAccessFailedCount() > 0) {
                user.setAccessFailedCount(0);
                userService.update(user);
            }
            SessionUtil.removeSessionAttribute(request, "user");
            SessionUtil.setSessionAttribute(request, "user", user);
            SessionUtil.setCookie(response, "userId", user.getUserId().toString(), 30 * 24 * 60 * 60, true, false, "/");
            response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
        } catch (Exception e) {
            request.setAttribute("error", "Google login failed - " + e.getMessage());
            request.getRequestDispatcher("/pages/authen/SignIn.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

}
