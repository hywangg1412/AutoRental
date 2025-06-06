package Service.Interfaces;

import Model.Entity.OAuth.UserLogins;

public interface IUserLoginsService extends Service<UserLogins>{
    UserLogins findByProviderAndKey(String provider, String key) throws Exception;
}
