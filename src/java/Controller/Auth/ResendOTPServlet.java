package Controller.Auth;

import Exception.EventException;
import Exception.NotFoundException;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Model.Entity.OAuth.EmailOTPVerification;
import Service.Auth.EmailOTPVerificationService;
import Service.External.MailService;
import java.util.logging.Level;
import java.util.logging.Logger;
import Utils.SessionUtil;

@WebServlet(name = "ResendOTPServlet", urlPatterns = {"/resend-otp"})
public class ResendOTPServlet extends HttpServlet {

    private static final int MAX_RESEND = 5;
    private static final int BLOCK_MINUTES = 15;
    private EmailOTPVerificationService otpService;
    private MailService mailService;

    @Override
    public void init() {
        otpService = new EmailOTPVerificationService();
        mailService = new MailService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userIdStr = (String) SessionUtil.getSessionAttribute(request, "userId");
        String username = (String) SessionUtil.getSessionAttribute(request, "username");
        String email = (String) SessionUtil.getSessionAttribute(request, "email");
        if (userIdStr == null || email == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        UUID userId = null;
        try {
            userId = UUID.fromString(userIdStr);
        } catch (Exception e) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        EmailOTPVerification otp = otpService.findByUserId(userId);
        LocalDateTime now = LocalDateTime.now();
        if (otp == null) {
            session.setAttribute("error", "OTP session not found. Please try again.");
            response.sendRedirect(request.getContextPath() + "/pages/authen/verify-otp.jsp");
            return;
        }
        if (otp.getResendBlockUntil() != null && otp.getResendBlockUntil().isAfter(now)) {
            long minutesLeft = java.time.Duration.between(now, otp.getResendBlockUntil()).toMinutes();
            session.setAttribute("error", "You have sent too many times. Please try again after " + minutesLeft + " minutes.");
            response.sendRedirect(request.getContextPath() + "/pages/authen/verify-otp.jsp");
            return;
        }
        if (otp.getResendCount() >= MAX_RESEND) {
            otp.setResendBlockUntil(now.plusMinutes(BLOCK_MINUTES));
            otp.setResendCount(0);
            try {
                otpService.update(otp);
            } catch (EventException ex) {
                Logger.getLogger(ResendOTPServlet.class.getName()).log(Level.SEVERE, null, ex);
            } catch (NotFoundException ex) {
                Logger.getLogger(ResendOTPServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
            session.setAttribute("error", "You have sent too many times. Please try again after 15 minutes.");
            response.sendRedirect(request.getContextPath() + "/pages/authen/verify-otp.jsp");
            return;
        }
        otp.setResendCount(otp.getResendCount() + 1);
        otp.setLastResendTime(now);
        try {
            otpService.update(otp);
        } catch (EventException ex) {
            Logger.getLogger(ResendOTPServlet.class.getName()).log(Level.SEVERE, null, ex);
        } catch (NotFoundException ex) {
            Logger.getLogger(ResendOTPServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        mailService.sendOtpEmail(email, otp.getOtp(), username);
        session.setAttribute("success", "OTP has been resent to your email.");
        response.sendRedirect(request.getContextPath() + "/pages/authen/verify-otp.jsp");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }
}
