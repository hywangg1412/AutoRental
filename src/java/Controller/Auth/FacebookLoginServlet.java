package Controller.Auth;

import Mapper.UserMapper;
import Model.Entity.OAuth.FacebookUser;
import Model.Entity.User;
import Service.UserService;
import Service.auth.FacebookAuthService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Util.SessionUtil;

// facebookLogin
public class FacebookLoginServlet extends HttpServlet {

    private FacebookAuthService facebookAuthService;
    private UserMapper userMapper;
    private UserService UserService;

    @Override
    public void init() {
        facebookAuthService = new FacebookAuthService();
        userMapper = new UserMapper();
        UserService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null) {
            String authUrl = facebookAuthService.getAuthorizationUrl();
            response.sendRedirect(authUrl);
        } else {
            try {
                FacebookUser facebookUser = facebookAuthService.getUserInfo(code);
                User user = UserService.findByEmail(facebookUser.getEmail());
                if (user != null) {
                    SessionUtil.removeSessionAttribute(request, "user");
                    SessionUtil.setSessionAttribute(request, "user", user);
                    SessionUtil.setCookie(response, "userId", user.getUserId().toString(), 30 * 24 * 60 * 60, true, false, "/");
                    response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
                } else {
                    request.setAttribute("errMsg", "No account associated with this Facebook. Please sign up first.");
                    request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
                }

            } catch (Exception e) {
                request.setAttribute("errorMsg", "Facebook login failed - " + e.getMessage());
                request.getRequestDispatcher("pages/Error.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

}
