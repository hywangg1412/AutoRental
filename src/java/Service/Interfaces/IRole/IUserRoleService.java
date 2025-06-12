package Service.Interfaces.IRole;

import Exception.NotFoundException;
import Model.Entity.Role.UserRole;
import Service.Interfaces.Service;
import java.util.List;
import java.util.UUID;

public interface IUserRoleService extends Service<UserRole> {

    UserRole findByUserId(UUID roleId) throws NotFoundException;

    List<UserRole> findByRoleId(UUID roleId) throws NotFoundException;

    boolean existsByUserIdAndRoleId(UUID userId, UUID roleId) throws NotFoundException;
}
