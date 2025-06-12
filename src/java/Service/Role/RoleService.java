package Service.Role;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Role.Role;
import Repository.Role.RoleRepository;
import Service.Interfaces.IRole.IRoleService;
import Validator.RoleValidator;
import java.util.*;
import java.util.logging.*;

public class RoleService implements IRoleService {
    private final RoleRepository roleRepository;
    private final RoleValidator roleValidator;
    private static final Logger LOGGER = Logger.getLogger(RoleService.class.getName());

    public RoleService() {
        this.roleRepository = new RoleRepository();
        this.roleValidator = new RoleValidator();
    }

    @Override
    public Role findByRoleName(String roleName) throws EventException, NotFoundException {
        try {
            Role role = roleRepository.findByRoleName(roleName);
            if (role == null) throw new NotFoundException("Role not found with name: " + roleName);
            return role;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding role by name", e);
            throw new EventException("Error finding role by name: " + e.getMessage());
        }
    }

    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            roleRepository.findAll();
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error displaying roles", e);
            throw new EventException("Error displaying roles: " + e.getMessage());
        }
    }

    @Override
    public Role add(Role entry) throws EventException, InvalidDataException {
        try {
            roleValidator.validateAdd(entry);
            return roleRepository.add(entry);
        } catch (InvalidDataException e) {
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding role", e);
            throw new EventException("Error adding role: " + e.getMessage());
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            Role role = roleRepository.findById(id);
            if (role == null) throw new NotFoundException("Role not found with ID: " + id);
            return roleRepository.delete(id);
        } catch (NotFoundException e) {
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting role", e);
            throw new EventException("Error deleting role: " + e.getMessage());
        }
    }

    @Override
    public boolean update(Role entry) throws EventException, NotFoundException {
        try {
            roleValidator.validateUpdate(entry);
            Role role = roleRepository.findById(entry.getRoleId());
            if (role == null) throw new NotFoundException("Role not found with ID: " + entry.getRoleId());
            return roleRepository.update(entry);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating role", e);
            throw new EventException("Error updating role: " + e.getMessage());
        }
    }

    @Override
    public Role findById(UUID id) throws NotFoundException {
        try {
            Role role = roleRepository.findById(id);
            if (role == null) throw new NotFoundException("Role not found with ID: " + id);
            return role;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding role by id", e);
            throw new NotFoundException("Error finding role by id: " + e.getMessage());
        }
    }
}
