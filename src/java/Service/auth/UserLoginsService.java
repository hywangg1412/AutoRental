package Service.Auth;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.OAuth.UserLogins;
import Repository.Auth.UserLoginsRepository;
import Service.Interfaces.IAuth.IUserLoginsService;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserLoginsService implements IUserLoginsService {

    private static final Logger LOGGER = Logger.getLogger(UserLoginsService.class.getName());
    private final UserLoginsRepository userLoginsRepository;

    public UserLoginsService() {
        this.userLoginsRepository = new UserLoginsRepository();
    }

    @Override
    public void display() throws EmptyDataException {
        try {
            List<UserLogins> userLogins = userLoginsRepository.findAll();
            if (userLogins.isEmpty()) {
                LOGGER.log(Level.INFO, "No user login records found");
                throw new EmptyDataException("No user login records found.");
            }
            LOGGER.log(Level.INFO, "Successfully retrieved {0} user login records", userLogins.size());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error displaying user logins", e);
            throw new EmptyDataException("Error displaying user logins: " + e.getMessage());
        }
    }

    @Override
    public UserLogins add(UserLogins entry) throws EventException, InvalidDataException {
        try {
            if (entry == null) {
                LOGGER.log(Level.WARNING, "Attempt to add null user login entry");
                throw new InvalidDataException("User login entry cannot be null");
            }

            UserLogins addedLogin = userLoginsRepository.add(entry);
            if (addedLogin == null) {
                LOGGER.log(Level.SEVERE, "Failed to add user login for user ID: {0}", entry.getUserId());
                throw new EventException("Failed to add user login");
            }
            LOGGER.log(Level.INFO, "Successfully added user login for user ID: {0}", entry.getUserId());
            return addedLogin;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding user login for user ID: " + entry.getUserId(), e);
            throw new EventException("Error adding user login: " + e.getMessage());
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            if (id == null) {
                LOGGER.log(Level.WARNING, "Attempt to delete user login with null ID");
                throw new NotFoundException("User ID cannot be null");
            }

            UserLogins userLogin = userLoginsRepository.findById(id);
            if (userLogin == null) {
                LOGGER.log(Level.WARNING, "User login not found with ID: {0}", id);
                throw new NotFoundException("User login not found with ID: " + id);
            }

            boolean deleted = userLoginsRepository.delete(id);
            if (deleted) {
                LOGGER.log(Level.INFO, "Successfully deleted user login with ID: {0}", id);
            } else {
                LOGGER.log(Level.WARNING, "Failed to delete user login with ID: {0}", id);
            }
            return deleted;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting user login with ID: " + id, e);
            throw new EventException("Error deleting user login: " + e.getMessage());
        }
    }

    @Override
    public boolean update(UserLogins entry) throws EventException, NotFoundException {
        try {
            if (entry == null) {
                LOGGER.log(Level.WARNING, "Attempt to update null user login entry");
                throw new NotFoundException("User login entry cannot be null");
            }

            UserLogins existingLogin = userLoginsRepository.findById(entry.getUserId());
            if (existingLogin == null) {
                LOGGER.log(Level.WARNING, "User login not found with ID: {0}", entry.getUserId());
                throw new NotFoundException("User login not found with ID: " + entry.getUserId());
            }

            boolean updated = userLoginsRepository.update(entry);
            if (updated) {
                LOGGER.log(Level.INFO, "Successfully updated user login with ID: {0}", entry.getUserId());
            } else {
                LOGGER.log(Level.WARNING, "Failed to update user login with ID: {0}", entry.getUserId());
            }
            return updated;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating user login with ID: " + entry.getUserId(), e);
            throw new EventException("Error updating user login: " + e.getMessage());
        }
    }

    @Override
    public UserLogins findById(UUID id) throws NotFoundException {
        try {
            if (id == null) {
                LOGGER.log(Level.WARNING, "Attempt to find user login with null ID");
                throw new NotFoundException("User ID cannot be null");
            }

            UserLogins userLogin = userLoginsRepository.findById(id);
            if (userLogin == null) {
                LOGGER.log(Level.WARNING, "User login not found with ID: {0}", id);
                throw new NotFoundException("User login not found with ID: " + id);
            }
            LOGGER.log(Level.INFO, "Successfully found user login with ID: {0}", id);
            return userLogin;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding user login with ID: " + id, e);
            throw new NotFoundException("Error finding user login: " + e.getMessage());
        }
    }

    @Override
    public UserLogins findByProviderAndKey(String provider, String key) throws Exception {
        try {
            return userLoginsRepository.findByProviderAndKey(provider, key);
        } catch (SQLException e) {
            throw new Exception("Error finding user login: " + e.getMessage());
        }
    }

    @Override
    public List<UserLogins> findByUserId(UUID userId) throws Exception {
        try {
            return userLoginsRepository.findByUserId(userId);
        } catch (SQLException e) {
            throw new Exception("Error finding user login: " + e.getMessage());
        }
    }

    @Override
    public UserLogins findByUserIdAndProvider(UUID userId, String provider) throws Exception {
        try {
            return userLoginsRepository.findByUserIdAndProvider(userId, provider);
        } catch (SQLException e) {
            throw new Exception("Error finding user login: " + e.getMessage());
        }
    }

    @Override
    public boolean deleteByProviderAndKey(String provider, String key) throws Exception {
        try {
            return userLoginsRepository.deleteByProviderAndKey(provider, key);
        } catch (SQLException e) {
            throw new Exception("Error deleting user login: " + e.getMessage());
        }
    }

}