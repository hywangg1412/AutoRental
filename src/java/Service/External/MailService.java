package Service.External;

import jakarta.mail.Authenticator;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Message;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;
import java.util.Properties;
import java.time.LocalDateTime;
import java.util.UUID;
import Model.Constants.OAuthConstants;

public class MailService {

    private final int TOKEN_EXPIRE_MINUTES = 10;
    private final String from = OAuthConstants.SENDER_EMAIL;
    private final String password = OAuthConstants.SENDER_EMAIL_PASSWORD;

    public String generateToken() {
        return UUID.randomUUID().toString();
    }

    public LocalDateTime getExpireDateTime() {
        return LocalDateTime.now().plusMinutes(TOKEN_EXPIRE_MINUTES);
    }

    public boolean isExpired(LocalDateTime time) {
        return LocalDateTime.now().isAfter(time);
    }

    public boolean sendResetEmail(String to, String link, String name) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };

        Session session = Session.getInstance(props, auth);

        try {
            Message msg = new MimeMessage(session);
            msg.addHeader("Content-type", "text/html; charset=UTF-8");
            msg.setFrom(new InternetAddress(from));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            msg.setSubject("Reset Password");
            String content = ""
                    + "<div style=\"font-family: 'Montserrat', Arial, sans-serif; background: #f7faff; padding: 32px; border-radius: 12px; max-width: 480px; margin: auto;\">"
                    + "  <h2 style=\"color: #2176ff; text-align: center; margin-bottom: 8px;\">AutoRental</h2>"
                    + "  <h3 style=\"color: #181f32; text-align: center; margin-top: 0;\">Password Reset Request</h3>"
                    + "  <p>Hi <b>" + name + "</b>,</p>"
                    + "  <p>We received a request to reset your password for your <b>AutoRental</b> account.</p>"
                    + "  <p style=\"text-align: center; margin: 32px 0;\">"
                    + "    <a href=\"" + link + "\" style=\"background: #2176ff; color: #fff; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: bold; font-size: 1.1rem;\">"
                    + "      Reset Password"
                    + "    </a>"
                    + "  </p>"
                    + "  <p>If you did not request a password reset, please ignore this email. This link will expire in 10 minutes for your security.</p>"
                    + "  <hr style=\"border: none; border-top: 1px solid #e0e7ef; margin: 24px 0;\">"
                    + "  <p style=\"font-size: 0.95rem; color: #6b7280;\">"
                    + "    Need help? Contact <a href=\"mailto:support@autorental.com\" style=\"color: #2176ff;\">support@autorental.com</a><br>"
                    + "    &copy; " + java.time.Year.now() + " AutoRental. All rights reserved."
                    + "  </p>"
                    + "</div>";
            msg.setContent(content, "text/html; charset=UTF-8");
            Transport.send(msg);
            System.out.println("Send successfully");
            return true;
        } catch (Exception e) {
            System.out.println("Send error");
            System.out.println(e);
            return false;
        }
    }

    public boolean sendContactEmail(String adminEmail, String userEmail, String userName, String subject, String messageBody) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };

        Session session = Session.getInstance(props, auth);

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(adminEmail, false));
            msg.setSubject("Customer Contact: " + subject);
            msg.setReplyTo(InternetAddress.parse(userEmail, false));
            String content = ""
                + "<div style=\"font-family: 'Poppins', Arial, sans-serif; background: #f7faff; padding: 32px; border-radius: 12px; max-width: 520px; margin: auto; border: 1px solid #e0e7ef;\">"
                + "  <h2 style=\"color: #2176ff; text-align: center; margin-bottom: 8px;\">AutoRental</h2>"
                + "  <h3 style=\"color: #181f32; text-align: center; margin-top: 0;\">New Contact Message</h3>"
                + "  <p style=\"font-size: 1.05rem; color: #222;\">Hello Admin,</p>"
                + "  <p style=\"font-size: 1.05rem; color: #222;\">You have received a new contact message from the AutoRental website. Here are the details:</p>"
                + "  <table style=\"width: 100%; background: #fff; border-radius: 8px; border-collapse: collapse; margin: 24px 0; font-size: 1rem;\">"
                + "    <tr><td style=\"padding: 8px 0; color: #888; width: 120px;\"><b>Name:</b></td><td style=\"padding: 8px 0; color: #181f32;\">" + userName + "</td></tr>"
                + "    <tr><td style=\"padding: 8px 0; color: #888;\"><b>Email:</b></td><td style=\"padding: 8px 0; color: #181f32;\">" + userEmail + "</td></tr>"
                + "    <tr><td style=\"padding: 8px 0; color: #888;\"><b>Subject:</b></td><td style=\"padding: 8px 0; color: #181f32;\">" + subject + "</td></tr>"
                + "    <tr><td style=\"padding: 8px 0; color: #888; vertical-align: top;\"><b>Message:</b></td><td style=\"padding: 8px 0; color: #181f32; white-space: pre-line;\">" + messageBody + "</td></tr>"
                + "  </table>"
                + "  <p style=\"font-size: 0.98rem; color: #444;\"><b>To reply to the customer, simply reply to this email.</b></p>"
                + "  <hr style=\"border: none; border-top: 1px solid #e0e7ef; margin: 24px 0;\">"
                + "  <p style=\"font-size: 0.95rem; color: #6b7280; text-align: center;\">Best regards,<br>AutoRental Team</p>"
                + "</div>";

            msg.setContent(content, "text/html; charset=UTF-8");

            Transport.send(msg);
            return true;
        } catch (Exception e) {
            System.out.println("Send error: " + e);
            return false;
        }
    }

    public boolean sendVerificationEmail(String to, String verificationLink, String username) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };

        Session session = Session.getInstance(props, auth);

        try {
            Message msg = new MimeMessage(session);
            msg.addHeader("Content-type", "text/html; charset=UTF-8");
            msg.setFrom(new InternetAddress(from));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            msg.setSubject("Verify Your Email - AutoRental");
            String content = ""
                    + "<div style=\"font-family: 'Montserrat', Arial, sans-serif; background: #f7faff; padding: 32px; border-radius: 12px; max-width: 480px; margin: auto;\">"
                    + "  <h2 style=\"color: #2176ff; text-align: center; margin-bottom: 8px;\">AutoRental</h2>"
                    + "  <h3 style=\"color: #181f32; text-align: center; margin-top: 0;\">Email Verification</h3>"
                    + "  <p>Hi <b>" + username + "</b>,</p>"
                    + "  <p>Welcome to <b>AutoRental</b>! Please verify your email address to complete your registration.</p>"
                    + "  <p style=\"text-align: center; margin: 32px 0;\">"
                    + "    <a href=\"" + verificationLink + "\" style=\"background: #2176ff; color: #fff; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: bold; font-size: 1.1rem;\">"
                    + "      Verify Email"
                    + "    </a>"
                    + "  </p>"
                    + "  <p>If you did not create an account with AutoRental, please ignore this email.</p>"
                    + "  <p><strong>This verification link will expire in 10 minutes for your security.</strong></p>"
                    + "  <hr style=\"border: none; border-top: 1px solid #e0e7ef; margin: 24px 0;\">"
                    + "  <p style=\"font-size: 0.95rem; color: #6b7280;\">"
                    + "    Need help? Contact <a href=\"mailto:support@autorental.com\" style=\"color: #2176ff;\">support@autorental.com</a><br>"
                    + "    &copy; " + java.time.Year.now() + " AutoRental. All rights reserved."
                    + "  </p>"
                    + "</div>";
            msg.setContent(content, "text/html; charset=UTF-8");
            Transport.send(msg);
            System.out.println("Verification email sent successfully to: " + to);
            return true;
        } catch (Exception e) {
            System.out.println("Failed to send verification email to: " + to);
            System.out.println("Error: " + e.getMessage());
            return false;
        }
    }

    public boolean sendOtpEmail(String to, String otp, String username) {
        String subject = "Your OTP Code - AutoRental";
        String content = ""
            + "<div style=\"font-family: 'Montserrat', Arial, sans-serif; background: #f7faff; padding: 32px; border-radius: 12px; max-width: 480px; margin: auto;\">"
            + "  <h2 style=\"color: #2176ff; text-align: center; margin-bottom: 8px;\">AutoRental</h2>"
            + "  <h3 style=\"color: #181f32; text-align: center; margin-top: 0;\">Email Verification - OTP</h3>"
            + "  <p>Hi <b>" + username + "</b>,</p>"
            + "  <p>Thank you for registering with <b>AutoRental</b>!</p>"
            + "  <p style=\"font-size: 1.1rem; text-align: center; margin: 32px 0;\">"
            + "    <span style=\"display: inline-block; background: #2176ff; color: #fff; padding: 14px 32px; border-radius: 8px; font-weight: bold; font-size: 1.5rem; letter-spacing: 4px;\">" + otp + "</span>"
            + "  </p>"
            + "  <p style=\"text-align: center;\">Enter this OTP code on the website to verify your email address.</p>"
            + "  <p><strong>This OTP will expire in 10 minutes for your security.</strong></p>"
            + "  <hr style=\"border: none; border-top: 1px solid #e0e7ef; margin: 24px 0;\">"
            + "  <p style=\"font-size: 0.95rem; color: #6b7280;\">"
            + "    Need help? Contact <a href=\"mailto:support@autorental.com\" style=\"color: #2176ff;\">support@autorental.com</a><br>"
            + "    &copy; " + java.time.Year.now() + " AutoRental. All rights reserved."
            + "  </p>"
            + "</div>";

        try {
            Properties props = new Properties();
            props.put("mail.smtp.host", "smtp.gmail.com");
            props.put("mail.smtp.port", "587");
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");

            Authenticator auth = new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(from, password);
                }
            };

            Session session = Session.getInstance(props, auth);

            Message msg = new MimeMessage(session);
            msg.addHeader("Content-type", "text/html; charset=UTF-8");
            msg.setFrom(new InternetAddress(from));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            msg.setSubject(subject);
            msg.setContent(content, "text/html; charset=UTF-8");
            Transport.send(msg);
            System.out.println("OTP email sent successfully to: " + to);
            return true;
        } catch (Exception e) {
            System.out.println("Failed to send OTP email to: " + to);
            System.out.println("Error: " + e.getMessage());
            return false;
        }
    }

    /**
     * Gửi email hợp đồng PDF cho user
     */
    public boolean sendContractEmail(String to, String subject, String pdfUrl) {
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.gmail.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");

        Authenticator auth = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(from, password);
            }
        };

        Session session = Session.getInstance(props, auth);

        try {
            Message msg = new MimeMessage(session);
            msg.setFrom(new InternetAddress(from));
            msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to, false));
            msg.setSubject(subject);
            String content = ""
                + "<div style=\"font-family: 'Montserrat', Arial, sans-serif; background: #f7faff; padding: 32px; border-radius: 12px; max-width: 480px; margin: auto;\">"
                + "  <h2 style=\"color: #2176ff; text-align: center; margin-bottom: 8px;\">AutoRental</h2>"
                + "  <h3 style=\"color: #181f32; text-align: center; margin-top: 0;\">Hợp đồng thuê xe của bạn đã được ký thành công!</h3>"
                + "  <p>Chào bạn,</p>"
                + "  <p>Hợp đồng thuê xe của bạn đã được ký thành công. Bạn có thể tải hợp đồng tại đây:</p>"
                + "  <p style=\"text-align: center; margin: 32px 0;\">"
                + "    <a href='" + pdfUrl + "' style=\"background: #2176ff; color: #fff; padding: 14px 32px; border-radius: 8px; text-decoration: none; font-weight: bold; font-size: 1.1rem;\">Xem hợp đồng PDF</a>"
                + "  </p>"
                + "  <p>Nếu bạn có bất kỳ thắc mắc nào, vui lòng liên hệ <a href=\"mailto:support@autorental.com\" style=\"color: #2176ff;\">support@autorental.com</a>.</p>"
                + "  <hr style=\"border: none; border-top: 1px solid #e0e7ef; margin: 24px 0;\">"
                + "  <p style=\"font-size: 0.95rem; color: #6b7280;\">&copy; " + java.time.Year.now() + " AutoRental. All rights reserved.</p>"
                + "</div>";
            msg.setContent(content, "text/html; charset=UTF-8");
            Transport.send(msg);
            return true;
        } catch (Exception e) {
            System.out.println("Send error: " + e);
            return false;
        }
    }
}
