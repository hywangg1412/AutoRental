package Repository.Interfaces;

import Model.Entity.OAuth.PasswordResetToken;

public interface IPasswordResetToken extends Repository<PasswordResetToken,Integer>{
    public PasswordResetToken findByToken(String token);
}
