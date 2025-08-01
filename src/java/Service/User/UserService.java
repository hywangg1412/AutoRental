package Service.User;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Constants.UserStatusConstants;
import Model.Entity.User.User;
import Repository.User.UserRepository;
import Service.Interfaces.IUser.IUserService;
import Utils.ObjectUtils;
import java.sql.SQLException;
import java.util.UUID;
import java.util.function.Predicate;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.List;

public class UserService implements IUserService {

    private UserRepository userRepsitory;
    private static final Logger LOGGER = Logger.getLogger(UserService.class.getName());

    public UserService() {
        userRepsitory = new UserRepository();
    }

    @Override
    public void display() throws EmptyDataException {
        try {
            userRepsitory.findAll();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error while displaying all users", ex);
        }
    }

    @Override
    public User add(User entry) throws EventException, InvalidDataException {
        try {
            if (entry.getRoleId() == null) {
                throw new InvalidDataException("User must have a roleId");
            }
            return userRepsitory.add(entry);
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error while adding user", ex);
            return null;
        }
    }

    @Override
    public boolean update(User entry) throws EventException, NotFoundException {
        try {
            if (entry.getRoleId() == null) {
                throw new NotFoundException("User must have a roleId");
            }
            return userRepsitory.update(entry);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error while updating user", ex);
            return false;
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            return userRepsitory.delete(id);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error while deleting user", ex);
            return false;
        }
    }

    @Override
    public User findById(UUID id) throws NotFoundException {
        try {
            User user = userRepsitory.findById(id);
            if (user == null) {
                throw new NotFoundException("User not found");
            }
            return user;
        } catch (SQLException ex) {
            Logger.getLogger(UserService.class.getName()).log(Level.SEVERE, null, ex);
            throw new NotFoundException("Error finding user: " + ex.getMessage());
        }
    }

    @Override
    public User findByEmail(String email) {
        try {
            return userRepsitory.findByEmail(email);
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error while finding user by email", ex);
            return null;
        }
    }

    @Override
    public boolean isEmailExist(String email) {
        try {
            return findByEmail(email) != null;
        } catch (Exception ex) {
            LOGGER.log(Level.SEVERE, "Error while checking if email exists", ex);
            return false;
        }
    }


    @Override
    public boolean updateUserInfo(UUID userId, String username, String dob, String gender) {
        try {
            return userRepsitory.updateUserInfo(userId, username, dob, gender);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating user info for userId: " + userId, e);
            return false;
        }
    }

    @Override
    public boolean updatePhoneNumber(UUID userId, String phoneNumber) {
        try {
            return userRepsitory.updatePhoneNumber(userId, phoneNumber);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating phone number for userId: " + userId, e);
            return false;
        }
    }   

    @Override
    public boolean updateUserAvatar(UUID userId, String avatarUrl) {
        try {
            return userRepsitory.updateUserAvatar(userId, avatarUrl);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating user avatar for userId: " + userId, e);
            return false;
        }
    }

    public boolean verifyPassword(UUID userId, String password) throws NotFoundException {
        User user = findById(userId);
        return ObjectUtils.verifyPassword(password, user.getPasswordHash());
    }

    public boolean markUserAsDeleted(UUID userId) {
        try {
            User user = userRepsitory.findById(userId);
            if (user == null) {
                LOGGER.log(Level.WARNING, "Attempted to delete non-existent user. UserId: {0}", userId);
                return false;
            }
            
            boolean updated = userRepsitory.updateStatus(userId, UserStatusConstants.DELETED);
            if (updated) {
                LOGGER.log(Level.INFO, "User successfully marked as deleted: {0}", userId);
            } else {
                LOGGER.log(Level.SEVERE, "Failed to mark user as deleted: {0}", userId);
            }
            return updated;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error marking user as deleted: {0}", new Object[]{userId, e});
            return false;
        }
    }

    public boolean anonymizeDeletedUser(UUID userId) {
        try {
            User user = userRepsitory.findById(userId);
            if (user == null || !user.isDeleted()) {
                LOGGER.log(Level.WARNING, "Attempted to anonymize a user who is not marked as deleted or does not exist. UserId: {0}", userId);
                return false;
            }
            
            return userRepsitory.anonymize(userId);

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error during user anonymization service call", e);
            return false;
        }
    }
    
    @Override
    public boolean updateStatus(UUID userId, String status) {
        try {
            return userRepsitory.updateStatus(userId, status);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating user status for userId: " + userId, e);
            return false;
        }
    }

    @Override
    public User findByUsername(String username) {
        try {
            return userRepsitory.findByUsername(username);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding user by username: " + username, e);
            return null;
        }
    }

    public String generateUniqueUsername(String baseUsername) {
        List<String> existingUsernames = userRepsitory.findAllUsernamesLike(baseUsername);
        
        int maxNumber = 0;
        for (String username : existingUsernames) {
            if (username.toLowerCase().startsWith(baseUsername.toLowerCase())) {
                String suffix = username.substring(baseUsername.length());
                if (suffix.matches("\\d+")) {
                    maxNumber = Math.max(maxNumber, Integer.parseInt(suffix));
                }
            }
        }
        
        return maxNumber == 0 ? baseUsername : baseUsername + (maxNumber + 1);
    }

    public List<User> findByRoleId(UUID roleId) throws Exception {
        return userRepsitory.findByRoleId(roleId);
    }
    
    public List<User> getAllUsers() throws SQLException{
        return userRepsitory.findAll();
    }
    
    // New optimized filter methods
    public List<User> getUsersWithFilters(String roleFilter, String statusFilter, String searchTerm) throws SQLException {
        return userRepsitory.findWithFilters(roleFilter, statusFilter, searchTerm);
    }
    
    public List<User> getUsersByStatus(String status) throws SQLException {
        return userRepsitory.findByStatus(status);
    }
    
    public List<User> searchUsers(String searchTerm) throws SQLException {
        return userRepsitory.searchUsers(searchTerm);
    }
     public User findByPhoneNumber(String phoneNumber) {
        try {
            if (phoneNumber == null || phoneNumber.isEmpty()) {
                return null;
            }
            return userRepsitory.findByPhoneNumber(phoneNumber);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding user by phone number: " + phoneNumber, e);
            return null;
        }
    }
    
    /**
     * Check if phone number is unique (for new users) or unique for a specific user (for updates)
     * @param phoneNumber the phone number to check
     * @param excludeUserId the user ID to exclude from the check (for updates)
     * @return true if phone number is unique, false otherwise
     */
    public boolean isPhoneNumberUnique(String phoneNumber, UUID excludeUserId) {
        try {
            if (phoneNumber == null || phoneNumber.trim().isEmpty()) {
                return true; // Empty phone numbers are considered unique
            }
            
            User existingUser = findByPhoneNumber(phoneNumber.trim());
            if (existingUser == null) {
                return true; // No user found with this phone number
            }
            
            // If excludeUserId is provided, check if the existing user is the same user
            if (excludeUserId != null) {
                return existingUser.getUserId().equals(excludeUserId);
            }
            
            return false; // Phone number exists and belongs to a different user
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking phone number uniqueness: " + phoneNumber, e);
            return false; // In case of error, assume not unique for safety
        }
    }
}
