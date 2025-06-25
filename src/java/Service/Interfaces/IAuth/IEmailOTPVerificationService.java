package Service.Interfaces.IAuth;

import Exception.NotFoundException;
import Model.Entity.OAuth.EmailOTPVerification;
import Service.Interfaces.Service;
import java.util.UUID;

public interface IEmailOTPVerificationService extends Service<EmailOTPVerification>{
    public EmailOTPVerification findByOtp(String otp) throws NotFoundException;
    EmailOTPVerification findByUserId(UUID userId);
    void deleteByUserId(UUID userId);

} 