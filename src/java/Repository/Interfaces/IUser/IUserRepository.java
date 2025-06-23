package Repository.Interfaces.IUser;

import Model.Entity.User.User;
import Repository.Interfaces.Repository;
import java.util.UUID;


public interface IUserRepository extends Repository<User, Integer>{
    User findByUsernameAndPassword(String username, String password);
    
    User findByEmail(String email);

    boolean updateUserInfo(UUID userId, String username, String dob, String gender);

    boolean updatePhoneNumber(UUID userId, String phoneNumber);

    boolean updateUserAvatar(UUID userId, String avatarUrl);
    
    boolean anonymize(UUID userId);
}
