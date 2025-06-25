package Service.Auth;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.OAuth.EmailVerificationToken;
import Model.Entity.User.User;
import Repository.Auth.EmailVerificationrRepository;
import Repository.User.UserRepository;
import Service.Interfaces.IAuth.IEmailVerificationTokenService;
import Service.MailService;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public class EmailVerificationService implements IEmailVerificationTokenService {

    private final EmailVerificationrRepository tokenRepository;
    private final UserRepository userRepository;
    private final MailService mailService;
    private final int TOKEN_EXPIRE_MINUTES = 10;

    public EmailVerificationService() {
        this.tokenRepository = new EmailVerificationrRepository();
        this.userRepository = new UserRepository();
        this.mailService = new MailService();
    }

    @Override
    public EmailVerificationToken findByToken(String token) throws NotFoundException {
        try {
            EmailVerificationToken verificationToken = tokenRepository.findByToken(token);
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
            List<EmailVerificationToken> tokens = tokenRepository.findAll();
            if (tokens.isEmpty()) {
                throw new EmptyDataException("No email verification tokens found");
            }
            // Display logic here if needed
        } catch (SQLException e) {
            throw new EventException("Error displaying email verification tokens: " + e.getMessage());
        }
    }

    @Override
    public EmailVerificationToken add(EmailVerificationToken entry) throws EventException, InvalidDataException {
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
            EmailVerificationToken token = tokenRepository.findById(id);
            if (token == null) {
                throw new NotFoundException("Email verification token not found");
            }
            return tokenRepository.delete(id);
        } catch (SQLException e) {
            throw new EventException("Error deleting email verification token: " + e.getMessage());
        }
    }

    @Override
    public boolean update(EmailVerificationToken entry) throws EventException, NotFoundException {
        try {
            if (entry == null || entry.getId() == null) {
                throw new NotFoundException("Email verification token not found");
            }
            
            EmailVerificationToken existingToken = tokenRepository.findById(entry.getId());
            if (existingToken == null) {
                throw new NotFoundException("Email verification token not found");
            }
            
            return tokenRepository.update(entry);
        } catch (SQLException e) {
            throw new EventException("Error updating email verification token: " + e.getMessage());
        }
    }

    @Override
    public EmailVerificationToken findById(UUID id) throws NotFoundException {
        try {
            EmailVerificationToken token = tokenRepository.findById(id);
            if (token == null) {
                throw new NotFoundException("Email verification token not found");
            }
            return token;
        } catch (SQLException e) {
            throw new NotFoundException("Error finding email verification token: " + e.getMessage());
        }
    }

    @Override
    public EmailVerificationToken findByUserId(UUID userId) {
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

    // Additional methods for email verification functionality
    
    public String generateToken() {
        return UUID.randomUUID().toString();
    }

    public boolean sendVerificationEmail(String email, String token, String username) {
        String verificationLink = "http://localhost:8080/autorental/verifyEmail?token=" + token;
        return mailService.sendVerificationEmail(email, verificationLink, username);
    }

    public boolean verifyToken(String token) {
        try {
            EmailVerificationToken verificationToken = findByToken(token);
            
            if (verificationToken.isIsUsed()) {
                return false; // Token đã được sử dụng
            }
            
            if (LocalDateTime.now().isAfter(verificationToken.getExpiryTime())) {
                return false; // Token đã hết hạn
            }
            
            // Cập nhật trạng thái token thành đã sử dụng
            verificationToken.setIsUsed(true);
            update(verificationToken);
            
            // Cập nhật trạng thái email verified của user
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
            // Xóa token cũ nếu có
            deleteByUserId(userId);
            
            // Tạo token mới
            String token = generateToken();
            LocalDateTime expiryTime = LocalDateTime.now().plusMinutes(TOKEN_EXPIRE_MINUTES);
            
            EmailVerificationToken verificationToken = new EmailVerificationToken(
                UUID.randomUUID(),
                token,
                expiryTime,
                false,
                userId,
                LocalDateTime.now()
            );
            
            add(verificationToken);
            
            // Gửi email xác thực
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
            List<EmailVerificationToken> allTokens = tokenRepository.findAll();
            LocalDateTime now = LocalDateTime.now();
            
            for (EmailVerificationToken token : allTokens) {
                if (now.isAfter(token.getExpiryTime())) {
                    delete(token.getId());
                }
            }
        } catch (Exception e) {
            System.err.println("Error deleting expired tokens: " + e.getMessage());
        }
    }
} 