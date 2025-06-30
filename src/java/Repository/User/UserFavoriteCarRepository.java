package Repository.User;

import Model.Entity.User.UserFavoriteCar;
import Repository.Interfaces.IUser.IUserFavoriteCarRepository;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import Config.DBContext;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserFavoriteCarRepository implements IUserFavoriteCarRepository{

    private static final Logger LOGGER = Logger.getLogger(UserFavoriteCarRepository.class.getName());
    private final DBContext dbContext;

    public UserFavoriteCarRepository() {
        dbContext = new DBContext();
    }

    @Override
    public UserFavoriteCar add(UserFavoriteCar entity) throws SQLException {
        String sql = "INSERT INTO UserFavoriteCars (UserId, CarId) VALUES (?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, entity.getUserId().toString());
            ps.setString(2, entity.getCarId().toString());
            ps.executeUpdate();
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding favorite car", e);
            throw e;
        }
        return entity;
    }

    @Override
    public UserFavoriteCar findById(UUID id) throws SQLException {
        throw new UnsupportedOperationException("Use findByUserId or custom method with both keys");
    }

    @Override
    public boolean update(UserFavoriteCar entity) throws SQLException {
        throw new UnsupportedOperationException("Update not supported for UserFavoriteCar");
    }

    @Override
    public boolean delete(UUID id) throws SQLException {
        throw new UnsupportedOperationException("Use delete(userId, carId)");
    }

    public boolean delete(UUID userId, UUID carId) throws SQLException {
        String sql = "DELETE FROM UserFavoriteCars WHERE UserId = ? AND CarId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId.toString());
            ps.setString(2, carId.toString());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting favorite car", e);
            throw e;
        }
    }

    @Override
    public List<UserFavoriteCar> findAll() throws SQLException {
        List<UserFavoriteCar> list = new ArrayList<>();
        String sql = "SELECT UserId, CarId FROM UserFavoriteCars";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new UserFavoriteCar(
                    UUID.fromString(rs.getString("UserId")),
                    UUID.fromString(rs.getString("CarId"))
                ));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching all favorite cars", e);
            throw e;
        }
        return list;
    }

    @Override
    public List<UserFavoriteCar> findByUserId(UUID userId) throws SQLException {
        List<UserFavoriteCar> list = new ArrayList<>();
        String sql = "SELECT UserId, CarId FROM UserFavoriteCars WHERE UserId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId.toString());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new UserFavoriteCar(
                        UUID.fromString(rs.getString("UserId")),
                        UUID.fromString(rs.getString("CarId"))
                    ));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching favorite cars by userId", e);
            throw e;
        }
        return list;
    }
    
}
