package Repository.Interfaces.IAuth;

import Model.Entity.OAuth.EmailOTPVerification;
import Repository.Interfaces.Repository;
import java.util.UUID;

public interface IEmailOTPVerificationRepository extends Repository<EmailOTPVerification, UUID> {
    EmailOTPVerification findByToken(String token);
    EmailOTPVerification findByUserId(UUID userId);
    void deleteByUserId(UUID userId);
}
