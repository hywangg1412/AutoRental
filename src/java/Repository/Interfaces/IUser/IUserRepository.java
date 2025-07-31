package Repository.Interfaces.IUser;

import Model.Entity.User.User;
import Repository.Interfaces.Repository;
import java.util.List;
import java.util.UUID;
import java.sql.SQLException;


public interface IUserRepository extends Repository<User, Integer>{
    User findByUsernameAndPassword(String username, String password);
    
    User findByEmail(String email);

    boolean updateUserInfo(UUID userId, String username, String dob, String gender);

    boolean updatePhoneNumber(UUID userId, String phoneNumber);

    boolean updateUserAvatar(UUID userId, String avatarUrl);
    
    boolean anonymize(UUID userId);

    boolean updateStatus(UUID userId, String status);
    
    User findByUsername(String username);

    List<String> findAllUsernamesLike(String baseUsername);

    List<User> findByRoleId(UUID roleId) throws SQLException;
    
    // New optimized filter methods
    List<User> findWithFilters(String roleFilter, String statusFilter, String searchTerm) throws SQLException;
    
    List<User> findByStatus(String status) throws SQLException;
    
    List<User> searchUsers(String searchTerm) throws SQLException;
    User findByPhoneNumber(String phoneNumber);
    
    // Additional methods
    User findById(UUID userId) throws SQLException;
}