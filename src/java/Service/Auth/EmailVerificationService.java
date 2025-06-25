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

public class EmailVerificationService implements IEmailOTPVerificationService {

    private final EmailOTPVerificationRepository tokenRepository;
    private final UserRepository userRepository;
    private final MailService mailService;
    private final int TOKEN_EXPIRE_MINUTES = 10;

    public EmailVerificationService() {
        this.tokenRepository = new EmailOTPVerificationRepository();
        this.userRepository = new UserRepository();
        this.mailService = new MailService();
    }

    @Override
    public EmailOTPVerification findByToken(String token) throws NotFoundException {
        try {
            EmailOTPVerification verificationToken = tokenRepository.findByToken(token);
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
            if (entry.getToken() == null || entry.getToken().trim().isEmpty()) {
                throw new InvalidDataException("Token cannot be empty");
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

    public boolean sendVerificationEmail(String email, String token, String username) {
        String verificationLink = "http://localhost:8080/autorental/verifyEmail?token=" + token;
        return mailService.sendVerificationEmail(email, verificationLink, username);
    }

    public boolean verifyToken(String token) {
        try {
            EmailOTPVerification verificationToken = findByToken(token);
            
            if (verificationToken.isIsUsed()) {
                return false; 
            }
            
            if (LocalDateTime.now().isAfter(verificationToken.getExpiryTime())) {
                return false; 
            }
            
            verificationToken.setIsUsed(true);
            update(verificationToken);
            
            User user = userRepository.findById(verificationToken.getUserId());
            if (user != null) {
                user.setEmailVerifed(true);
                userRepository.update(user);
                return true;
            }
            
            return false;
        } catch (NotFoundException e) {
            System.err.println("Token not found: " + e.getMessage());
            return false;
        } catch (Exception e) {
            System.err.println("Error verifying token: " + e.getMessage());
            return false;
        }
    }

    public void createVerificationToken(UUID userId) {
        try {
            deleteByUserId(userId);
            
            String token = generateToken();
            LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(TOKEN_EXPIRE_MINUTES);
            
            EmailOTPVerification verificationToken = new EmailOTPVerification(
                UUID.randomUUID(),
                token,
                expiryTime,
                false,
                userId,
                LocalDateTime.now()
            );
            
            add(verificationToken);
            
            User user = userRepository.findById(userId);
            if (user != null) {
                sendVerificationEmail(user.getEmail(), token, user.getUsername());
            }
        } catch (Exception e) {
            System.err.println("Error creating verification token: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void deleteExpiredTokens() {
        try {
            List<EmailOTPVerification> allTokens = tokenRepository.findAll();
            LocalDateTime now = LocalDateTime.now();
            
            for (EmailOTPVerification token : allTokens) {
                if (now.isAfter(token.getExpiryTime())) {
                    delete(token.getId());
                }
            }
        } catch (Exception e) {
            System.err.println("Error deleting expired tokens: " + e.getMessage());
        }
    }
} 