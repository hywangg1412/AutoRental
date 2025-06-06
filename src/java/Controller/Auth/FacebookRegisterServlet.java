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
import Model.Entity.OAuth.UserLogins;
import Service.auth.UserLoginsService;

//facebookLogin
public class FacebookRegisterServlet extends HttpServlet {

    private FacebookAuthService facebookAuthService;
    private UserMapper userMapper;
    private UserService userService;
    private UserLoginsService userLoginsService;

    @Override
    public void init() {
        facebookAuthService = new FacebookAuthService();
        userMapper = new UserMapper();
        userService = new UserService();
        userLoginsService = new UserLoginsService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null) {
            response.sendRedirect(facebookAuthService.getAuthorizationRegisterUrl());
            return;
        }
        try {
            FacebookUser facebookUser = facebookAuthService.getRegisterUserInfo(code);
            User existingUser = userService.findByEmail(facebookUser.getEmail());
            if (existingUser != null) {
                String errorMsg = existingUser.isBanned() ?
                    "This email is associated with a banned account. Please contact support." :
                    "Email already exists!";
                request.setAttribute("error", errorMsg);
                request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
                return;
            }
            User newUser = userMapper.mapFacebookUserToUser(facebookUser);
            User addedUser = userService.add(newUser);
            if (addedUser != null) {
                // Tạo UserLogins cho Facebook
                UserLogins userLogins = new UserLogins();
                userLogins.setUserId(addedUser.getUserId());
                userLogins.setLoginProvider("facebook");
                userLogins.setProviderKey(facebookUser.getFacebookId());
                try {
                    userLoginsService.add(userLogins);
                    response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
                } catch (Exception ex) {
                    userService.delete(addedUser.getUserId());
                    request.setAttribute("error", "Register failed (user login): " + ex.getMessage());
                    request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
                }
            } else {
                request.setAttribute("error", "Register failed. Please try again.");
                request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Facebook register failed - " + e.getMessage());
            request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
        }
    }

}
