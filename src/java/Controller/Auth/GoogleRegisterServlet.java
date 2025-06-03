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
            String authUrl = googleAuthService.getAuthorizationRegisterUrl();
            response.sendRedirect(authUrl);
        } else {

            try {
                GoogleUser googleUser = googleAuthService.getUserInfoRegister(code);
                User user = userService.findByEmail(googleUser.getEmail());

                if (user != null) {
                    if (user.isBanned()) {
                        request.setAttribute("error", "This account has been banned. Please contact support.");
                        request.getRequestDispatcher("pages/authen/SignIn.jsp").forward(request, response);
                        return;
                    }
                    request.setAttribute("errMsg", "Email with this account already exist");
                    request.getRequestDispatcher("/pages/authen/SignUp.jsp").forward(request, response);
                    return;
                }

                user = userMapper.mapGoogleUserToUser(googleUser);
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
                System.out.println("Google register failed");
                request.setAttribute("errorMsg", "Google register failed - " + e.getMessage());
                request.getRequestDispatcher("pages/Error.jsp").forward(request, response);
            }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

}
