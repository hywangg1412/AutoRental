package Service.User;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.User.UserFavoriteCar;
import Service.Interfaces.IUser.IUserFavoriteCarService;
import java.util.UUID;
import Repository.User.UserFavoriteCarRepository;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserFavoriteCarService implements IUserFavoriteCarService {

    private static final Logger LOGGER = Logger.getLogger(UserFavoriteCarService.class.getName());
    private final UserFavoriteCarRepository repository;

    public UserFavoriteCarService() {
        repository = new UserFavoriteCarRepository();
    }

    @Override
    public void display() throws EmptyDataException, EventException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public UserFavoriteCar add(UserFavoriteCar entry) throws EventException, InvalidDataException {
        try {
            // Kiểm tra xem đã yêu thích chưa
            List<UserFavoriteCar> existingFavorites = repository.findByUserId(entry.getUserId());
            boolean alreadyExists = existingFavorites.stream()
                .anyMatch(fav -> fav.getCarId().equals(entry.getCarId()));
            
            if (alreadyExists) {
                throw new InvalidDataException("Car is already in favorites");
            }
            
            return repository.add(entry);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding favorite car", e);
            throw new EventException("Database error: " + e.getMessage());
        }
    }

    public boolean delete(UUID userId, UUID carId) throws EventException, NotFoundException {
        try {
            boolean result = repository.delete(userId, carId);
            if (!result) {
                LOGGER.warning("Favorite car not found for deletion: userId=" + userId + ", carId=" + carId);
                throw new NotFoundException("Favorite car not found");
            }
            return result;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting favorite car", e);
            throw new EventException("Database error: " + e.getMessage());
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        throw new UnsupportedOperationException("Use delete(userId, carId)");
    }

    @Override
    public boolean update(UserFavoriteCar entry) throws EventException, NotFoundException {
        throw new UnsupportedOperationException("Update not supported for UserFavoriteCar");
    }

    @Override
    public UserFavoriteCar findById(UUID id) throws NotFoundException {
        throw new UnsupportedOperationException("Use findByUserId or custom method");
    }

    @Override
    public List<UserFavoriteCar> findByUserId(UUID userId) throws SQLException {
        try {
            return repository.findByUserId(userId);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding favorite cars by userId", e);
            throw e;
        }
    }
    
}
