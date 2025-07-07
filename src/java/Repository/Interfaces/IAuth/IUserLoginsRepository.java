package Repository.Interfaces.IAuth;

import Model.Entity.OAuth.UserLogins;
import Repository.Interfaces.Repository;
import java.sql.*;
import java.util.List;
import java.util.UUID;

public interface IUserLoginsRepository extends Repository<UserLogins, Integer>{
    UserLogins findByProviderAndKey(String provider, String key) throws SQLException;
    List<UserLogins> findByUserId(UUID userId) throws SQLException;
    UserLogins findByUserIdAndProvider(UUID userId, String provider) throws SQLException;
    boolean deleteByProviderAndKey(String provider, String key) throws SQLException;
}
