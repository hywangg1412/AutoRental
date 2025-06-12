package Repository.Interfaces.IRole;

import Model.Entity.Role.UserRole;
import Repository.Interfaces.Repository;
import java.util.List;
import java.util.UUID;
import java.sql.*;

public interface IUserRoleRepository extends Repository<UserRole, Integer> {

    UserRole findByUserId(UUID userId) throws SQLException;

    List<UserRole> findByRoleId(UUID roleId) throws SQLException;

    boolean existsByUserIdAndRoleId(UUID userId, UUID roleId) throws SQLException;
}
