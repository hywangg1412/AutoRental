
package Repository.Interfaces;

import Model.User;


public interface IUserRepository extends Repository<User, Integer>{
    User findByUsernameAndPassword(String username, String password);
}
