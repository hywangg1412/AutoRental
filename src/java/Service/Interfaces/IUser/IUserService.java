package Service.Interfaces.IUser;

import Model.Entity.User.User;
import Service.Interfaces.Service;
import java.util.UUID;
import java.util.List;
import java.sql.SQLException;

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
    
    boolean verifyPassword(UUID userId, String password) throws Exception;
    
    boolean markUserAsDeleted(UUID userId);
    
    boolean anonymizeDeletedUser(UUID userId);
    
    List<User> getAllUsers() throws SQLException;
    
    List<User> getUsersWithFilters(String roleFilter, String statusFilter, String searchTerm) throws SQLException;
    
    List<User> getUsersByStatus(String status) throws SQLException;
    
    List<User> searchUsers(String searchTerm) throws SQLException;
}
