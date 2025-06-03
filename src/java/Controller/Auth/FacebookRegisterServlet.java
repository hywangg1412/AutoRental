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

//facebookLogin
public class FacebookRegisterServlet extends HttpServlet {

    private FacebookAuthService facebookAuthService;
    private UserMapper userMapper;
    private UserService userService;

    @Override
    public void init() {
        facebookAuthService = new FacebookAuthService();
        userMapper = new UserMapper();
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null) {
            String authUrl = facebookAuthService.getAuthorizationRegisterUrl();
            response.sendRedirect(authUrl);
        } else {
            try {
                FacebookUser facebookUser = facebookAuthService.getRegisterUserInfo(code);
                User user = userService.findByEmail(facebookUser.getEmail());
                if (user.isBanned()) {
                    request.setAttribute("error", "This account has been banned. Please contact support.");
                    request.getRequestDispatcher("pages/authen/SignUp.jsp").forward(request, response);
                    return;
                }

                if (user != null) {
                    request.setAttribute("errMsg", "An account with this facebook already exists.");
                    request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
                    return;
                }
                user = userMapper.mapFacebookUserToUser(facebookUser);
                try {
                    userService.add(user);
                    SessionUtil.removeSessionAttribute(request, "user");
                    SessionUtil.setSessionAttribute(request, "user", user);
                    SessionUtil.setCookie(response, "userId", user.getUserId().toString(), 30 * 24 * 60 * 60, true, false, "/");
                    response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
                } catch (Exception ex) {
                    System.out.println("Can't add user to the system");
                    request.setAttribute("errorMsg", "Can't add user to the system - " + ex.getMessage());
                    request.getRequestDispatcher("pages/Error.jsp").forward(request, response);
                }
            } catch (Exception e) {
                request.setAttribute("errorMsg", "Facebook login failed - " + e.getMessage());
                request.getRequestDispatcher("pages/Error.jsp").forward(request, response);
            }
        }
    }

}
