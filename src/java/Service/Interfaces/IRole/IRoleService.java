package Service.Interfaces.IRole;

import Exception.EventException;
import Exception.NotFoundException;
import Model.Entity.Role.Role;
import Service.Interfaces.Service;

public interface IRoleService extends Service<Role> {
    Role findByRoleName(String roleName) throws EventException, NotFoundException;
}
