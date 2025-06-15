package Service.Interfaces.IAuth;

import Model.Entity.OAuth.UserLogins;
import Service.Interfaces.Service;
import java.util.List;
import java.util.UUID;

public interface IUserLoginsService extends Service<UserLogins>{
    UserLogins findByProviderAndKey(String provider, String key) throws Exception;
    List<UserLogins> findByUserId(UUID userId) throws Exception;
}
