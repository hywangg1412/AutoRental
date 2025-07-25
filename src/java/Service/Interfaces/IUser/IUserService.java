package Service.Interfaces.IUser;

import Model.Entity.User.User;
import Service.Interfaces.Service;
import java.util.UUID;
import java.util.List;

public interface IUserService extends Service<User> {

    User findByEmail(String email);

    boolean isEmailExist(String email);

    boolean updateUserInfo(UUID userId, String username, String dob, String gender);

    boolean updatePhoneNumber(UUID userId, String phoneNumber);

    boolean updateUserAvatar(UUID userId, String avatarUrl);

    boolean updateStatus(UUID userId, String status) throws Exception;
    
    User findByUsername(String username);

    String generateUniqueUsername(String baseUsername);

    List<User> findByRoleId(UUID roleId) throws Exception;
}
