package Validator;

import Exception.InvalidDataException;
import Model.Entity.Role.Role;
import Repository.Role.RoleRepository;
import java.sql.SQLException;

public class RoleValidator {
    private final RoleRepository roleRepository;

    public RoleValidator() {
        this.roleRepository = new RoleRepository();
    }

    public void validateAdd(Role role) throws InvalidDataException, SQLException {
        if (role == null) {
            throw new InvalidDataException("Role cannot be null");
        }
        
        if (role.getRoleName() == null || role.getRoleName().trim().isEmpty()) {
            throw new InvalidDataException("Role name cannot be empty");
        }
        
        // Check if role with same name already exists
        Role existingRole = roleRepository.findByRoleName(role.getRoleName());
        if (existingRole != null) {
            throw new InvalidDataException("Role with this name already exists");
        }
    }

    public void validateUpdate(Role role) throws InvalidDataException, SQLException {
        if (role == null) {
            throw new InvalidDataException("Role cannot be null");
        }
        
        if (role.getRoleId() == null) {
            throw new InvalidDataException("Role ID cannot be null");
        }
        
        if (role.getRoleName() == null || role.getRoleName().trim().isEmpty()) {
            throw new InvalidDataException("Role name cannot be empty");
        }
        
        // Check if role exists
        Role existingRole = roleRepository.findById(role.getRoleId());
        if (existingRole == null) {
            throw new InvalidDataException("Role not found with ID: " + role.getRoleId());
        }
    }
} 