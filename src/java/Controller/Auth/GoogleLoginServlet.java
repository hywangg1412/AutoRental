package Controller.Auth;

import Service.auth.GoogleAuthService;
import Model.Entity.OAuth.GoogleUser;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// google/login
public class GoogleLoginServlet extends HttpServlet {

    private GoogleAuthService googleAuthService;

    @Override
    public void init() {
        googleAuthService = new GoogleAuthService();
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
                
                // Test if login success or not
                System.out.println("User login: " + googleUser.toString());
                // Session control here
                HttpSession session = request.getSession();
                session.setAttribute("googleUser", googleUser);

                response.sendRedirect(request.getContextPath() + "/pages/index.jsp");
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
