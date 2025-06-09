package Repository.Interfaces;

import Model.Entity.OAuth.UserLogins;
import java.sql.*;

public interface IUserLoginsRepository extends Repository<UserLogins, Integer>{
    UserLogins findByProviderAndKey(String provider, String key) throws SQLException;
}
