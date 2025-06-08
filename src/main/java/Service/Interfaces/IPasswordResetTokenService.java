package Service.Interfaces;

import Exception.NotFoundException;
import Model.Entity.OAuth.PasswordResetToken;

public interface IPasswordResetTokenService extends Service<PasswordResetToken> {
    public PasswordResetToken findByToken(String token) throws NotFoundException;
}
