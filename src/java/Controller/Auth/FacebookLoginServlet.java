package Controller.Auth;

import Model.Entity.OAuth.FacebookUser;
import Service.auth.FacebookAuthService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// facebookLogin
public class FacebookLoginServlet extends HttpServlet {

    private FacebookAuthService facebookAuthService;

    @Override
    public void init() {
        facebookAuthService = new FacebookAuthService();
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

                System.out.println("User login" + facebookUser.toString());

                HttpSession session = request.getSession();
                session.setAttribute("facebookUser", facebookUser);

                response.sendRedirect(request.getContextPath() + "/pages/index.jsp");

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
