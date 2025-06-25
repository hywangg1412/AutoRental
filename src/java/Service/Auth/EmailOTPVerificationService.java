package Service.Auth;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.OAuth.EmailOTPVerification;
import Model.Entity.User.User;
import Repository.Auth.EmailOTPVerificationRepository;
import Repository.User.UserRepository;
import Service.External.MailService;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import Service.Interfaces.IAuth.IEmailOTPVerificationService;

public class EmailOTPVerificationService implements IEmailOTPVerificationService {

    private final EmailOTPVerificationRepository tokenRepository;
    private final UserRepository userRepository;
    private final MailService mailService;
    private final int TOKEN_EXPIRE_MINUTES = 10;

    public EmailOTPVerificationService() {
        this.tokenRepository = new EmailOTPVerificationRepository();
        this.userRepository = new UserRepository();
        this.mailService = new MailService();
    }

    @Override
    public EmailOTPVerification findByOtp(String otp) throws NotFoundException {
        try {
            EmailOTPVerification verificationToken = tokenRepository.findByOTP(otp);
            if (verificationToken == null) {
                throw new NotFoundException("Email verification token not found");
            }
            return verificationToken;
        } catch (Exception e) {
            throw new NotFoundException("Error finding email verification token: " + e.getMessage());
        }
    }

    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            List<EmailOTPVerification> tokens = tokenRepository.findAll();
            if (tokens.isEmpty()) {
                throw new EmptyDataException("No email verification tokens found");
            }
        } catch (SQLException e) {
            throw new EventException("Error displaying email verification tokens: " + e.getMessage());
        }
    }

    @Override
    public EmailOTPVerification add(EmailOTPVerification entry) throws EventException, InvalidDataException {
        try {
            if (entry == null) {
                throw new InvalidDataException("Email verification token cannot be null");
            }
            if (entry.getOtp() == null || entry.getOtp().trim().isEmpty()) {
                throw new InvalidDataException("OTP cannot be empty");
            }
            if (entry.getUserId() == null) {
                throw new InvalidDataException("User ID cannot be null");
            }
            
            return tokenRepository.add(entry);
        } catch (SQLException e) {
            throw new EventException("Error adding email verification token: " + e.getMessage());
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            EmailOTPVerification token = tokenRepository.findById(id);
            if (token == null) {
                throw new NotFoundException("Email verification token not found");
            }
            return tokenRepository.delete(id);
        } catch (SQLException e) {
            throw new EventException("Error deleting email verification token: " + e.getMessage());
        }
    }

    @Override
    public boolean update(EmailOTPVerification entry) throws EventException, NotFoundException {
        try {
            if (entry == null || entry.getId() == null) {
                throw new NotFoundException("Email verification token not found");
            }
            
            EmailOTPVerification existingToken = tokenRepository.findById(entry.getId());
            if (existingToken == null) {
                throw new NotFoundException("Email verification token not found");
            }
            
            return tokenRepository.update(entry);
        } catch (SQLException e) {
            throw new EventException("Error updating email verification token: " + e.getMessage());
        }
    }

    @Override
    public EmailOTPVerification findById(UUID id) throws NotFoundException {
        try {
            EmailOTPVerification token = tokenRepository.findById(id);
            if (token == null) {
                throw new NotFoundException("Email verification token not found");
            }
            return token;
        } catch (SQLException e) {
            throw new NotFoundException("Error finding email verification token: " + e.getMessage());
        }
    }

    @Override
    public EmailOTPVerification findByUserId(UUID userId) {
        try {
            return tokenRepository.findByUserId(userId);
        } catch (Exception e) {
            System.err.println("Error finding email verification token by user ID: " + e.getMessage());
            return null;
        }
    }

    @Override
    public void deleteByUserId(UUID userId) {
        try {
            tokenRepository.deleteByUserId(userId);
        } catch (Exception e) {
            System.err.println("Error deleting email verification tokens by user ID: " + e.getMessage());
        }
    }

    public String generateToken() {
        return UUID.randomUUID().toString();
    }

    public boolean verifyOtp(UUID userId, String otp) {
        if (userId == null || otp == null || otp.trim().isEmpty()) return false;
        EmailOTPVerification verificationToken = null;
        try {
            verificationToken = findByUserId(userId);
        } catch (Exception e) {
            System.err.println("Error finding OTP by userId: " + e.getMessage());
            return false;
        }
        if (verificationToken == null) return false;
        if (!otp.equals(verificationToken.getOtp())) return false;
        if (verificationToken.isIsUsed()) return false;
        if (LocalDateTime.now().isAfter(verificationToken.getExpiryTime())) return false;

        verificationToken.setIsUsed(true);
        try {
            update(verificationToken);
        } catch (Exception e) {
            System.err.println("Error updating OTP as used: " + e.getMessage());
            return false;
        }

        try {
            User user = userRepository.findById(userId);
            if (user != null) {
                user.setEmailVerifed(true);
                userRepository.update(user);
                return true;
            }
        } catch (Exception e) {
            System.err.println("Error updating user email verified: " + e.getMessage());
        }
        return false;
    }

    public String generateOtp() {
        return String.format("%06d", new java.util.Random().nextInt(999999));
    }
} 