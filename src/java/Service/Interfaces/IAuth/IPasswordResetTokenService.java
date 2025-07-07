package Service.Interfaces.IAuth;

import Exception.NotFoundException;
import Model.Entity.OAuth.PasswordResetToken;
import Service.Interfaces.Service;

public interface IPasswordResetTokenService extends Service<PasswordResetToken> {
    public PasswordResetToken findByToken(String token) throws NotFoundException;
}
