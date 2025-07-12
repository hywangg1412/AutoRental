package Controller.Home;

import Model.Constants.OAuthConstants;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Service.External.MailService;

@WebServlet(name = "ContactServlet", urlPatterns = {"/contact"})
public class ContactServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/pages/contact.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String subject = request.getParameter("subject");
        String message = request.getParameter("message");

        // Validate input
        if (isNullOrEmpty(name) || isNullOrEmpty(email) || isNullOrEmpty(subject) || isNullOrEmpty(message)) {
            request.setAttribute("error", "Please fill in all required fields.");
            request.getRequestDispatcher("/pages/contact.jsp").forward(request, response);
            return;
        }

        String adminEmail = OAuthConstants.SENDER_EMAIL;
        MailService mailService = new MailService();
        boolean sent = mailService.sendContactEmail(adminEmail, email, name, subject, message);

        if (sent) {
            request.setAttribute("success", "Your message has been sent successfully!");
        } else {
            request.setAttribute("error", "There was an error sending your message. Please try again later.");
        }
        request.getRequestDispatcher("/pages/contact.jsp").forward(request, response);
    }

    private boolean isNullOrEmpty(String s) {
        return s == null || s.trim().isEmpty();
    }
}
