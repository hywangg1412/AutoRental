package Repository.Interfaces.IUser;

import Model.Entity.User.UserFavoriteCar;
import Repository.Interfaces.Repository;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public interface IUserFavoriteCarRepository extends Repository<UserFavoriteCar, UUID>{
    public List<UserFavoriteCar> findByUserId(UUID userId) throws SQLException;
}
