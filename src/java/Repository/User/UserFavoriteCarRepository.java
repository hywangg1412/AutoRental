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
import java.math.BigDecimal;

public class UserFavoriteCarRepository implements IUserFavoriteCarRepository{

    private static final Logger LOGGER = Logger.getLogger(UserFavoriteCarRepository.class.getName());
    private final DBContext dbContext = new DBContext();

    public UserFavoriteCarRepository() {
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
    
    public List<Model.DTO.User.FavoriteCarDTO> findFavoriteCarDetailsByUserId(UUID userId) throws SQLException {
        List<Model.DTO.User.FavoriteCarDTO> list = new ArrayList<>();
        String sql = """
            SELECT 
                c.CarId,
                c.CarModel,
                cb.BrandName,
                ci.ImageUrl as MainImageUrl,
                tt.TransmissionName,
                c.Seats,
                ft.FuelName,
                c.PricePerHour,
                c.Status,
                CASE 
                    WHEN c.Status = 'Available' THEN 'Available'
                    WHEN c.Status = 'Rented' THEN 'Rented'
                    WHEN c.Status = 'Unavailable' THEN 'Unavailable'
                    ELSE 'Unknown'
                END as StatusDisplay
            FROM UserFavoriteCars ufc
            INNER JOIN Car c ON ufc.CarId = c.CarId
            INNER JOIN CarBrand cb ON c.BrandId = cb.BrandId
            INNER JOIN TransmissionType tt ON c.TransmissionTypeId = tt.TransmissionTypeId
            INNER JOIN FuelType ft ON c.FuelTypeId = ft.FuelTypeId
            LEFT JOIN (
                SELECT CarId, ImageUrl, ROW_NUMBER() OVER (PARTITION BY CarId ORDER BY IsMain DESC, ImageId) as rn
                FROM CarImages
            ) ci ON c.CarId = ci.CarId AND ci.rn = 1
            WHERE ufc.UserId = ?
            ORDER BY c.CreatedDate DESC
        """;
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userId.toString());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(new Model.DTO.User.FavoriteCarDTO(
                        UUID.fromString(rs.getString("CarId")),
                        rs.getString("CarModel"),
                        rs.getString("BrandName"),
                        rs.getString("MainImageUrl"),
                        rs.getString("TransmissionName"),
                        rs.getInt("Seats"),
                        rs.getString("FuelName"),
                        rs.getBigDecimal("PricePerHour"),
                        rs.getString("Status"),
                        rs.getString("StatusDisplay")
                    ));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error fetching favorite car details by userId", e);
            throw e;
        }
        return list;
    }
}
