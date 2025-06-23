package Service.Interfaces.IUser;

import Model.Entity.User.User;
import Service.Interfaces.Service;
import java.util.UUID;

public interface IUserService extends Service<User>{
    User findByEmail(String email);
    
    boolean isEmailExist(String email);

    boolean updateUserInfo(UUID userId, String username, String dob, String gender);

    boolean updatePhoneNumber(UUID userId, String phoneNumber);

    boolean updateUserAvatar(UUID userId, String avatarUrl);
}
