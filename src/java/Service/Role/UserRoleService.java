package Service.Role;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Role.UserRole;
import Repository.Role.UserRoleRepository;
import Service.Interfaces.IRole.IUserRoleService;
import Validator.UserRoleValidator;
import java.util.*;
import java.util.logging.*;

public class UserRoleService implements IUserRoleService {

    private final UserRoleRepository userRoleRepository;
    private final UserRoleValidator userRoleValidator;
    private static final Logger LOGGER = Logger.getLogger(UserRoleService.class.getName());

    public UserRoleService() {
        this.userRoleRepository = new UserRoleRepository();
        this.userRoleValidator = new UserRoleValidator();
    }

    @Override
    public UserRole findByUserId(UUID userId) throws NotFoundException {
        try {
            UserRole userRoles = userRoleRepository.findByUserId(userId);
            if (userRoles == null) {
                throw new NotFoundException("No user roles found for user ID: " + userId);
            }
            return userRoles;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding user roles by user ID", e);
            throw new NotFoundException("Error finding user roles by user ID: " + e.getMessage());
        }
    }

    @Override
    public List<UserRole> findByRoleId(UUID roleId) throws NotFoundException {
        try {
            List<UserRole> userRoles = userRoleRepository.findByRoleId(roleId);
            if (userRoles == null || userRoles.isEmpty()) {
                throw new NotFoundException("No user roles found for role ID: " + roleId);
            }
            return userRoles;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding user roles by role ID", e);
            throw new NotFoundException("Error finding user roles by role ID: " + e.getMessage());
        }
    }

    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            userRoleRepository.findAll();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error displaying user roles", e);
            throw new EventException("Error displaying user roles: " + e.getMessage());
        }
    }

    @Override
    public UserRole add(UserRole entry) throws EventException, InvalidDataException {
        try {
            userRoleValidator.validateAdd(entry);
            return userRoleRepository.add(entry);
        } catch (InvalidDataException e) {
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding user role", e);
            throw new EventException("Error adding user role: " + e.getMessage());
        }
    }

    public boolean delete(UUID userId, UUID roleId) throws EventException, NotFoundException {
        try {
            UserRole userRole = userRoleRepository.findById(userId, roleId);
            if (userRole == null) {
                throw new NotFoundException("User role not found with UserId: " + userId + " and RoleId: " + roleId);
            }
            return userRoleRepository.delete(userId, roleId);
        } catch (NotFoundException e) {
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting user role", e);
            throw new EventException("Error deleting user role: " + e.getMessage());
        }
    }

    public UserRole findById(UUID userId, UUID roleId) throws NotFoundException {
        try {
            UserRole userRole = userRoleRepository.findById(userId, roleId);
            if (userRole == null) {
                throw new NotFoundException("User role not found with UserId: " + userId + " and RoleId: " + roleId);
            }
            return userRole;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding user role by userId and roleId", e);
            throw new NotFoundException("Error finding user role by userId and roleId: " + e.getMessage());
        }
    }
    
    @Override
    public boolean existsByUserIdAndRoleId(UUID userId, UUID roleId) throws NotFoundException {
        try {
            return userRoleRepository.existsByUserIdAndRoleId(userId, roleId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error checking if user has role", e);
            throw new NotFoundException("Error checking if user has role: " + e.getMessage());
        }
    }

    // Không implement 3 method này vì UserRole chỉ có 2 trường là khóa chính, không có trường nào để implemetn
    @Override
    public boolean update(UserRole entry) throws EventException, NotFoundException {
        throw new UnsupportedOperationException("Update is not supported for UserRoles composite key.");
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        throw new UnsupportedOperationException("Update is not supported for UserRoles composite key.");
    }

    @Override
    public UserRole findById(UUID id) throws NotFoundException {
        throw new UnsupportedOperationException("Update is not supported for UserRoles composite key.");
    }

    
}
