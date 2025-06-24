package Controller.Auth;

import Exception.NotFoundException;
import Model.Entity.OAuth.PasswordResetToken;
import Model.Entity.User.User;
import Service.Auth.PasswordResetTokenService;
import Service.MailService;
import Service.User.UserService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;
import Utils.SessionUtil;
import Utils.ObjectUtils;

// /resetPassword
public class ResetPasswordServlet extends HttpServlet {

    private PasswordResetTokenService PRTService;
    private MailService resetService;
    private UserService userService;

    @Override
    public void init() {
        PRTService = new PasswordResetTokenService();
        resetService = new MailService();
        userService = new UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String token = request.getParameter("token");
        if (token == null || token.trim().isEmpty()) {
            forwardWithError(request, response, "Token is missing", "pages/authen/RequestPassword.jsp");
            return;
        }
        try {
            PasswordResetToken rToken = PRTService.findByToken(token);
            if (rToken.isIsUsed()) {
                forwardWithError(request, response, "Token is already used", "pages/authen/RequestPassword.jsp");
                return;
            }
            if (resetService.isExpired(rToken.getExpiryTime())) {
                forwardWithError(request, response, "Token is expired", "pages/authen/RequestPassword.jsp");
                return;
            }
            User user = userService.findById(rToken.getUserId());
            SessionUtil.setSessionAttribute(request, "user", user);
            SessionUtil.setSessionAttribute(request, "token", rToken.getToken());
            request.getRequestDispatcher("pages/authen/ResetPassword.jsp").forward(request, response);
        } catch (NotFoundException ex) {
            forwardWithError(request, response, "Token is invalid", "pages/authen/RequestPassword.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");
        User user = (User) SessionUtil.getSessionAttribute(request, "user");
        String token = (String) SessionUtil.getSessionAttribute(request, "token");

        if (newPassword == null || confirmPassword == null || newPassword.isEmpty() || confirmPassword.isEmpty()) {
            forwardWithError(request, response, "Password fields cannot be empty.", "pages/authen/ResetPassword.jsp");
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            forwardWithError(request, response, "Passwords do not match.", "pages/authen/ResetPassword.jsp");
            return;
        }
        if (user == null || token == null) {
            forwardWithError(request, response, "Session expired or invalid.", "pages/authen/RequestPassword.jsp");
            return;
        }
        try {
            String hashedPassword = ObjectUtils.hashPassword(newPassword);
            user.setPasswordHash(hashedPassword);
            userService.update(user);

            PasswordResetToken rToken = PRTService.findByToken(token);
            PRTService.delete(rToken.getId());

            SessionUtil.removeSessionAttribute(request, "user");
            SessionUtil.removeSessionAttribute(request, "token");

            request.setAttribute("message", "Password changed successfully. Please login.");
            request.getRequestDispatcher("pages/authen/SignIn.jsp").forward(request, response);
        } catch (Exception ex) {
            forwardWithError(request, response, "An error occurred: " + ex.getMessage(), "pages/authen/ResetPassword.jsp");
        }
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String errorMsg, String page)
            throws ServletException, IOException {
        request.setAttribute("error", errorMsg);
        request.getRequestDispatcher(page).forward(request, response);
    }

}
