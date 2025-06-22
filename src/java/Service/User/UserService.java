package Service.User;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.User.User;
import Repository.User.UserRepository;
import Service.Interfaces.IUser.IUserService;
import Utils.ObjectUtils;
import java.sql.SQLException;
import java.util.UUID;
import java.util.function.Predicate;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserService implements IUserService {

    private UserRepository userRepsitory;

    public UserService() {
        userRepsitory = new UserRepository();
    }

    @Override
    public void display() throws EmptyDataException {
        try {
            userRepsitory.findAll();
        } catch (SQLException ex) {
            System.out.println("Error while display all user - " + ex.getMessage());
        }
    }

    @Override
    public User add(User entry) throws EventException, InvalidDataException {
        try {
            return userRepsitory.add(entry);
        } catch (SQLException ex) {
            System.out.println("Error while adding user - " + ex.getMessage());
            return null;
        }
    }

    @Override
    public boolean update(User entry) throws EventException, NotFoundException {
        try {
            return userRepsitory.update(entry);
        } catch (Exception ex) {
            System.out.println("Error while updating user - " + ex.getMessage());
            return false;
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            return userRepsitory.delete(id);
        } catch (Exception ex) {
            System.out.println("Error while deleting user - " + ex.getMessage());
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
            System.out.println("Error while finding user by email - " + ex.getMessage());
            return null;
        }
    }

    @Override
    public boolean isEmailExist(String email) {
        try {
            return findByEmail(email) != null;
        } catch (Exception ex) {
            System.out.println("Error while checking if email exists - " + ex.getMessage());
            return false;
        }
    }


    @Override
    public boolean updateUserInfo(UUID userId, String username, String dob, String gender) {
        try {
            return userRepsitory.updateUserInfo(userId, username, dob, gender);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    @Override
    public boolean updatePhoneNumber(UUID userId, String phoneNumber) {
        try {
            return userRepsitory.updatePhoneNumber(userId, phoneNumber);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }   

    @Override
    public boolean updateUserAvatar(UUID userId, String avatarUrl) {
        try {
            return userRepsitory.updateUserAvatar(userId, avatarUrl);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean verifyPassword(UUID userId, String password) throws NotFoundException {
        User user = findById(userId);
        return ObjectUtils.verifyPassword(password, user.getPasswordHash());
    }

    public boolean deactivateUser(UUID userId) {
        try {
            // First check if user exists
            User user = userRepsitory.findById(userId);
            if (user == null) {
                System.out.println("User not found with ID: " + userId);
                return false;
            }
            
            // Use soft delete - update status to "Deleted" instead of hard delete
            // This avoids foreign key constraint issues
            boolean updated = userRepsitory.updateStatus(userId, "Deleted");
            if (updated) {
                System.out.println("User successfully marked as deleted: " + userId);
            } else {
                System.out.println("Failed to mark user as deleted: " + userId);
            }
            return updated;
        } catch (Exception e) {
            System.out.println("Error marking user as deleted: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
