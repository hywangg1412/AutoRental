package Controller.User.UserAccount;

import java.io.IOException;
import java.io.PrintWriter;
import Model.Entity.User.User;
import Service.User.UserService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "CheckUserNameServlet", urlPatterns = {"/user/check-username"})
public class CheckUserNameServlet extends HttpServlet {
    private final UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String username = request.getParameter("username");
        String userId = request.getParameter("userId"); // optional, để loại trừ user hiện tại khi update
        boolean exists = false;
        if (username != null && !username.trim().isEmpty()) {
            User user = userService.findByUsername(username.trim());
            if (user != null) {
                if (userId == null || userId.isEmpty() || !user.getUserId().toString().equals(userId)) {
                    exists = true;
                }
            }
        }
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"exists\":" + exists + "}");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
