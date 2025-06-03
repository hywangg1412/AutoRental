package Service.Interfaces;

import Model.Entity.User;

public interface IUserService extends Service<User>{
    User findByEmail(String email);
    
    boolean isEmailExist(String email);
}
