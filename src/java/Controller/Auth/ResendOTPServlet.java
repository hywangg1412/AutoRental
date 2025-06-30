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
import Model.Entity.OAuth.EmailOTPVerification;
import Model.Entity.User.User;
import Service.Auth.EmailOTPVerificationService;
import Service.External.MailService;
import java.util.logging.Level;
import java.util.logging.Logger;
import Utils.SessionUtil;

@WebServlet(name = "ResendOTPServlet", urlPatterns = {"/resend-otp"})
public class ResendOTPServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(ResendOTPServlet.class.getName());
    private static final int MAX_RESEND = 4;
    private static final int BLOCK_MINUTES = 30;
    
    private EmailOTPVerificationService otpService;
    private MailService mailService;
    private Service.User.UserService userService;

    @Override
    public void init() {
        otpService = new EmailOTPVerificationService();
        mailService = new MailService();
        userService = new Service.User.UserService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleResendOTP(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        handleResendOTP(request, response);
    }

    protected void handleResendOTP(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userIdStr = (String) SessionUtil.getSessionAttribute(request, "userId");
        if (userIdStr == null) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }

        UUID userId;
        try {
            userId = UUID.fromString(userIdStr);
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
            return;
        }

        User user = null;
        try {
            user = userService.findById(userId);
        } catch (NotFoundException ex) {
            LOGGER.log(Level.SEVERE, "User not found for ID: " + userId, ex);
        }
        if (user == null) {
            SessionUtil.setSessionAttribute(request, "error", "User not found. Please try again.");
            response.sendRedirect(request.getContextPath() + "/verify-otp");
            return;
        }

        EmailOTPVerification otp = null;
        try {
            otp = otpService.findByUserId(userId);
        } catch (EventException ex) {
            LOGGER.log(Level.SEVERE, "Error finding OTP for user ID: " + userId, ex);
        }
        if (otp == null) {
            SessionUtil.setSessionAttribute(request, "error", "OTP session not found. Please try again.");
            response.sendRedirect(request.getContextPath() + "/verify-otp");
            return;
        }

        LocalDateTime now = LocalDateTime.now();
        if (otp.getResendBlockUntil() != null && otp.getResendBlockUntil().isAfter(now)) {
            long minutesLeft = java.time.Duration.between(now, otp.getResendBlockUntil()).toMinutes();
            SessionUtil.setSessionAttribute(request, "error", "You have sent too many times. Please try again after " + minutesLeft + " minutes.");
            response.sendRedirect(request.getContextPath() + "/verify-otp");
            return;
        }

        if (otp.getResendCount() >= MAX_RESEND) {
            otp.setResendBlockUntil(now.plusMinutes(BLOCK_MINUTES));
            otp.setResendCount(0);
            otp.setLastResendTime(now);
            try {
                otpService.update(otp);
            } catch (Exception ex) {
                LOGGER.log(Level.SEVERE, "Error updating OTP", ex);
            }
            SessionUtil.setSessionAttribute(request, "error", "You have sent too many times. Please try again after 30 minutes.");
            response.sendRedirect(request.getContextPath() + "/verify-otp");
            return;
        }

        otp.setResendCount(otp.getResendCount() + 1);
        otp.setLastResendTime(now);
        otp.setOtp(otpService.generateOtp());
        otp.setExpiryTime(now.plusMinutes(10));
        try {
            otpService.update(otp);
            mailService.sendOtpEmail(user.getEmail(), otp.getOtp(), user.getUsername());
            SessionUtil.setSessionAttribute(request, "success", "OTP has been resent to your email.");
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error resending OTP", ex);
            SessionUtil.setSessionAttribute(request, "error", "Failed to resend OTP. Please try again.");
        }
        response.sendRedirect(request.getContextPath() + "/verify-otp");
    }
}
