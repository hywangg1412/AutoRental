package Repository.Interfaces.IRole;

import Model.Entity.Role.Role;
import Repository.Interfaces.Repository;
import java.sql.*;

public interface IRoleRepository extends Repository<Role,Integer>{
    Role findByRoleName(String roleName) throws SQLException;
}
