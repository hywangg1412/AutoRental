package Service.Interfaces.IAuth;

import Exception.NotFoundException;
import Model.Entity.OAuth.EmailVerificationToken;
import Service.Interfaces.Service;
import java.util.UUID;

public interface IEmailVerificationTokenService extends Service<EmailVerificationToken>{
    public EmailVerificationToken findByToken(String token) throws NotFoundException;
    EmailVerificationToken findByUserId(UUID userId);
    void deleteByUserId(UUID userId);

} 