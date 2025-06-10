package Repository.Interfaces.IAuth;

import Model.Entity.OAuth.PasswordResetToken;
import Repository.Interfaces.Repository;

public interface IPasswordResetToken extends Repository<PasswordResetToken,Integer>{
    public PasswordResetToken findByToken(String token);
}
