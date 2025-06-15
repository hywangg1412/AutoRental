package Controller.Auth;

import Model.Entity.OAuth.PasswordResetToken;
import Model.Entity.User;
import Service.Auth.PasswordResetTokenService;
import Service.ResetPasswordService;
import Service.UserService;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.time.LocalDateTime;
import java.util.UUID;

// /requestPassword
public class RequestPasswordServlet extends HttpServlet {

    private UserService userService;
    private ResetPasswordService resetPasswordService;
    private PasswordResetTokenService PRTService;

    @Override
    public void init() {
        userService = new UserService();
        resetPasswordService = new ResetPasswordService();
        PRTService = new PasswordResetTokenService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/authen/RequestPassword.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        if (email == null || email.trim().isEmpty()) {
            forwardWithError(request, response, "Please enter your email address.");
            return;
        }
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";
        if (!email.matches(emailRegex)) {
            forwardWithError(request, response, "Please enter a valid email address.");
            return;
        }
        try {
            User user = userService.findByEmail(email);
            if (user == null) {
                request.setAttribute("error", "Email not found!");
                request.getRequestDispatcher("pages/authen/RequestPassword.jsp").forward(request, response);
                return;
            }
            if (user.isBanned()) {
                request.setAttribute("error", "This account has been banned. Please contact support.");
                request.getRequestDispatcher("pages/authen/RequestPassword.jsp").forward(request, response);
                return;
            }
            String token = resetPasswordService.generateToken();
            String resetLink = "http://localhost:8080/autorental/resetPassword?token=" + token;
            PasswordResetToken newToken = new PasswordResetToken(
                    user.getUserId(), token, false, resetPasswordService.getExpireDateTime(), LocalDateTime.now());
            newToken.setId(UUID.randomUUID());

            boolean sent = resetPasswordService.sendResetEmail(user.getEmail(), resetLink, user.getUsername());
            if (sent) {
                request.setAttribute("message", "A password reset link has been sent to your email address. Please check your inbox (and spam folder).");
                PRTService.add(newToken);
            } else {
                request.setAttribute("error", "Failed to send reset email. Please try again later.");
            }
        } catch (Exception e) {
            request.setAttribute("error", "An error occurred while processing your request. Please try again later.");
        }
        request.getRequestDispatcher("/pages/authen/RequestPassword.jsp").forward(request, response);
    }

    private void forwardWithError(HttpServletRequest request, HttpServletResponse response, String errorMsg)
            throws ServletException, IOException {
        request.setAttribute("error", errorMsg);
        request.getRequestDispatcher("/pages/authen/RequestPassword.jsp").forward(request, response);
    }

}
