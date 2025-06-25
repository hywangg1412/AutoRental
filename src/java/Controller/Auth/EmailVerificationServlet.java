package Controller.Auth;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import Service.Auth.EmailVerificationService;

@WebServlet("/verifyEmail")
public class EmailVerificationServlet extends HttpServlet {
    
    private final EmailVerificationService emailVerificationService;
    
    public EmailVerificationServlet() {
        this.emailVerificationService = new EmailVerificationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String token = request.getParameter("token");
        
        if (token == null || token.trim().isEmpty()) {
            request.setAttribute("error", "Invalid verification link. Token is missing.");
            request.getRequestDispatcher("pages/authen/EmailVerificationResult.jsp").forward(request, response);
            return;
        }
        
        try {
            boolean isVerified = emailVerificationService.verifyToken(token);
            
            if (isVerified) {
                request.setAttribute("success", "Email verified successfully! You can now log in to your account.");
                request.setAttribute("message", "Your email has been verified. Welcome to AutoRental!");
            } else {
                request.setAttribute("error", "Email verification failed. The link may be expired or invalid.");
                request.setAttribute("message", "Please try registering again or contact support if the problem persists.");
            }
            
        } catch (Exception e) {
            System.err.println("Error during email verification: " + e.getMessage());
            request.setAttribute("error", "An error occurred during email verification. Please try again.");
            request.setAttribute("message", "If the problem persists, please contact support.");
        }
        
        request.getRequestDispatcher("pages/authen/EmailVerificationResult.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 