package Repository.Interfaces.IAuth;

import Model.Entity.OAuth.UserLogins;
import Repository.Interfaces.Repository;
import java.sql.*;

public interface IUserLoginsRepository extends Repository<UserLogins, Integer>{
    UserLogins findByProviderAndKey(String provider, String key) throws SQLException;
}
