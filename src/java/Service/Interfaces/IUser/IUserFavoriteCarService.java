package Service.Interfaces.IUser;

import Model.Entity.User.UserFavoriteCar;
import Service.Interfaces.Service;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public interface IUserFavoriteCarService extends Service<UserFavoriteCar>{
    public List<UserFavoriteCar> findByUserId(UUID userId) throws SQLException;
}
