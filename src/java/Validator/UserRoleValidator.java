package Validator;

import Exception.InvalidDataException;
import Model.Entity.Role.Role;
import Model.Entity.Role.UserRole;
import Repository.Role.RoleRepository;
import Repository.Role.UserRoleRepository;
import java.sql.SQLException;
import java.util.List;

public class UserRoleValidator {
    private final UserRoleRepository userRoleRepository;
    private final RoleRepository roleRepository;

    public UserRoleValidator() {
        this.userRoleRepository = new UserRoleRepository();
        this.roleRepository = new RoleRepository();
    }

    public void validateAdd(UserRole userRole) throws InvalidDataException, SQLException {
        if (userRole == null) {
            throw new InvalidDataException("User role cannot be null");
        }
        
        if (userRole.getUserId() == null) {
            throw new InvalidDataException("User ID cannot be null");
        }
        
        if (userRole.getRoleId() == null) {
            throw new InvalidDataException("Role ID cannot be null");
        }

        // Check if role exists
        Role role = roleRepository.findById(userRole.getRoleId());
        if (role == null) {
            throw new InvalidDataException("Role not found with ID: " + userRole.getRoleId());
        }

        // Check if user already has this role
        UserRole existingRole = userRoleRepository.findByUserId(userRole.getUserId());
        if (existingRole != null && existingRole.getRoleId().equals(userRole.getRoleId())) {
            throw new InvalidDataException("User already has this role");
        }
    }

    public void validateUpdate(UserRole userRole) throws InvalidDataException, SQLException {
        if (userRole == null) {
            throw new InvalidDataException("User role cannot be null");
        }
        
        if (userRole.getUserId() == null) {
            throw new InvalidDataException("User ID cannot be null");
        }
        
        if (userRole.getRoleId() == null) {
            throw new InvalidDataException("Role ID cannot be null");
        }

        // Check if user role exists
        UserRole existingUserRole = userRoleRepository.findById(userRole.getUserId());
        if (existingUserRole == null) {
            throw new InvalidDataException("User role not found with ID: " + userRole.getUserId());
        }

        // Check if new role exists
        Role role = roleRepository.findById(userRole.getRoleId());
        if (role == null) {
            throw new InvalidDataException("Role not found with ID: " + userRole.getRoleId());
        }
    }
} 