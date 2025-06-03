
package Repository.Interfaces;

import Model.Entity.User;


public interface IUserRepository extends Repository<User, Integer>{
    User findByUsernameAndPassword(String username, String password);
    
    User findByEmail(String email);
}
