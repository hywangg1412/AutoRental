package Controller.Auth;

import Service.auth.GoogleOAuthService;
import Model.Entity.OAuth.GoogleUser;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class GoogleLoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        GoogleOAuthService gg = new GoogleOAuthService();
        String accessToken = gg.getToken(code);
        System.out.println(accessToken);
        GoogleUser usser = gg.getUserInfo(accessToken);
        System.out.println(usser);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    }

}
