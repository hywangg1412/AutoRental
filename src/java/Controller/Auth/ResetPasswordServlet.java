package Controller.Auth;

import Exception.NotFoundException;
import Model.Entity.OAuth.PasswordResetToken;
import Model.Entity.User;
import Service.PasswordResetTokenService;
import Service.ResetPasswordService;
import Service.UserService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import Util.SessionUtil;
import Utils.ObjectUtils;

// /resetPassword
public class ResetPasswordServlet extends HttpServlet {

    private PasswordResetTokenService PRTService;
    private ResetPasswordService resetService;
    private UserService userService;

    @Override
    public void init() {
        PRTService = new PasswordResetTokenService();
        resetService = new ResetPasswordService();
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Token is missing");
            request.getRequestDispatcher("pages/authen/RequestPassword.jsp").forward(request, response);
            return;
        }
        try {
            PasswordResetToken rToken = PRTService.findByToken(token);
            if (rToken.isIsUsed()) {
                request.setAttribute("error", "Token is already used");
                request.getRequestDispatcher("pages/authen/RequestPassword.jsp").forward(request, response);
                return;
            }
            if (resetService.isExpired(rToken.getExpiryTime())) {
                request.setAttribute("error", "Token is expired");
                request.getRequestDispatcher("pages/authen/RequestPassword.jsp").forward(request, response);
                return;
            }
            User user = userService.findById(rToken.getUserId());
            SessionUtil.setSessionAttribute(request, "user", user);
            SessionUtil.setSessionAttribute(request, "token", rToken.getToken());
            request.getRequestDispatcher("pages/authen/ResetPassword.jsp").forward(request, response);

        } catch (NotFoundException ex) {
            request.setAttribute("error", "Token is invalid");
            request.getRequestDispatcher("pages/authen/RequestPassword.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        User user = (User) Util.SessionUtil.getSessionAttribute(request, "user");
        String token = (String) Util.SessionUtil.getSessionAttribute(request, "token");

        if (newPassword == null || confirmPassword == null || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            request.setAttribute("error", "Password fields cannot be empty.");
            request.getRequestDispatcher("pages/authen/ResetPassword.jsp").forward(request, response);
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("pages/authen/ResetPassword.jsp").forward(request, response);
            return;
        }
        if (user == null || token == null) {
            request.setAttribute("error", "Session expired or invalid.");
            request.getRequestDispatcher("pages/authen/RequestPassword.jsp").forward(request, response);
            return;
        }

        try {
            String hashedPassword = ObjectUtils.hashPassword(newPassword);
            user.setPasswordHash(hashedPassword);
            userService.update(user);

            PasswordResetToken rToken = PRTService.findByToken(token);
            rToken.setIsUsed(true);
            PRTService.update(rToken);

            Util.SessionUtil.removeSessionAttribute(request, "user");
            Util.SessionUtil.removeSessionAttribute(request, "token");

            request.setAttribute("message", "Password changed successfully. Please login.");
            request.getRequestDispatcher("pages/authen/SignIn.jsp").forward(request, response);
        } catch (Exception ex) {
            request.setAttribute("error", "An error occurred: " + ex.getMessage());
            request.getRequestDispatcher("pages/authen/ResetPassword.jsp").forward(request, response);
        }
    }

}
