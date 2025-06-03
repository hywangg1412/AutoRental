package Controller.Auth;

import Mapper.UserMapper;
import Model.Entity.OAuth.GoogleUser;
import Model.Entity.User;
import Service.UserService;
import Service.auth.GoogleAuthService;
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
            response.sendRedirect(googleAuthService.getAuthorizationRegisterUrl());
            return;
        }
        try {
            GoogleUser googleUser = googleAuthService.getUserInfoRegister(code);
            User existingUser = userService.findByEmail(googleUser.getEmail());
            if (existingUser != null) {
                String errorMsg = existingUser.isBanned() ?
                        "This account has been banned. Please contact support." :
                        "An account with this Google account already exists.";
                request.setAttribute("error", errorMsg);
                request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
                return;
            }
            User newUser = userMapper.mapGoogleUserToUser(googleUser);
            User addedUser = userService.add(newUser);
            if (addedUser != null) {
                response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
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
