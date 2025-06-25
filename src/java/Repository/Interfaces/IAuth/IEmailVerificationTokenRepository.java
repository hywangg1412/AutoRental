package Repository.Interfaces.IAuth;

import Model.Entity.OAuth.EmailVerificationToken;
import Repository.Interfaces.Repository;
import java.util.UUID;

public interface IEmailVerificationTokenRepository extends Repository<EmailVerificationToken, UUID> {
    EmailVerificationToken findByToken(String token);
    EmailVerificationToken findByUserId(UUID userId);
    void deleteByUserId(UUID userId);
}
