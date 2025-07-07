package Repository.Interfaces.IAuth;

import Model.Entity.OAuth.EmailOTPVerification;
import Repository.Interfaces.Repository;
import java.util.UUID;

public interface IEmailOTPVerificationRepository extends Repository<EmailOTPVerification, UUID> {
    EmailOTPVerification findByOTP(String otp);
    EmailOTPVerification findByUserId(UUID userId);
    void deleteByUserId(UUID userId);
}
