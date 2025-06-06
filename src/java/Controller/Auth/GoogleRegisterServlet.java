package Controller.Auth;

import Mapper.UserMapper;
import Model.Entity.OAuth.GoogleUser;
import Model.Entity.User;
import Model.Entity.OAuth.UserLogins;
import Service.UserService;
import Service.auth.GoogleAuthService;
import Service.auth.UserLoginsService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Util.SessionUtil;

// googleRegister
public class GoogleRegisterServlet extends HttpServlet {

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
            response.sendRedirect(googleAuthService.getAuthorizationRegisterUrl());
            return;
        }
        try {
            GoogleUser googleUser = googleAuthService.getUserInfoRegister(code);
            User existingUser = userService.findByEmail(googleUser.getEmail());
            if (existingUser != null) {
                String errorMsg = existingUser.isBanned() ?
                    "This email is associated with a banned account. Please contact support." :
                    "Email already exists!";
                request.setAttribute("error", errorMsg);
                request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
                return;
            }

            User newUser = userMapper.mapGoogleUserToUser(googleUser);
            User addedUser = userService.add(newUser);
            if (addedUser != null) {
                UserLogins userLogins = new UserLogins();
                userLogins.setUserId(addedUser.getUserId());
                userLogins.setLoginProvider("google");
                userLogins.setProviderKey(googleUser.getGoogleId());
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
            request.setAttribute("error", "Google register failed - " + e.getMessage());
            request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

}
