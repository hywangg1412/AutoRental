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

// googleLogin
public class GoogleLoginServlet extends HttpServlet {

    private GoogleAuthService googleAuthService;
    private UserMapper userMapper;
    private UserService userService;

    @Override
    public void init() {
        googleAuthService = new GoogleAuthService();
        userMapper = new UserMapper();
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");

        if (code == null) {
            String authUrl = googleAuthService.getAuthorizationUrl();
            response.sendRedirect(authUrl);
        } else {
            try {
                GoogleUser googleUser = googleAuthService.getUserInfo(code);
                User user = userService.findByEmail(googleUser.getEmail());
                if (user != null) {
                    SessionUtil.removeSessionAttribute(request, "user");
                    SessionUtil.setSessionAttribute(request, "user", user);
                    SessionUtil.setCookie(response, "userId", user.getUserId().toString(), 30 * 24 * 60 * 60, true, false, "/");
                    response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
                } else {
                    request.setAttribute("errMsg", "No account associated with this Google account. Please sign up first.");
                    request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
                }
            } catch (Exception e) {
                request.setAttribute("errorMsg", "Google login failed - " + e.getMessage());
                request.getRequestDispatcher("pages/Error.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

}
