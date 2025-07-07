package Service.Interfaces.IAuth;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.OAuth.EmailOTPVerification;
import Service.Interfaces.Service;
import java.util.UUID;

public interface IEmailOTPVerificationService extends Service<EmailOTPVerification>{
    public EmailOTPVerification findByOtp(String otp) throws NotFoundException;
    EmailOTPVerification findByUserId(UUID userId) throws EventException;
    void deleteByUserId(UUID userId) throws EventException;
    String generateToken();
    boolean verifyOtp(UUID userId, String otp) throws EventException;
    String generateOtp();
} 