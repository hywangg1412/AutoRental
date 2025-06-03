package Service;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.User;
import Repository.UserRepository;
import Service.Interfaces.IUserService;
import java.sql.SQLException;
import java.util.UUID;
import java.util.function.Predicate;
import java.util.logging.Level;
import java.util.logging.Logger;

public class UserService implements IUserService {

    private UserRepository userRepsitory;

    public UserService() {
        userRepsitory = new UserRepository();
    }

    @Override
    public void display() throws EmptyDataException {
        try {
            userRepsitory.findAll();
        } catch (SQLException ex) {
            System.out.println("Error while display all user - " + ex.getMessage());
        }
    }

    @Override
    public void add(User entry) throws EventException, InvalidDataException {
        try {
            userRepsitory.add(entry);
        } catch (SQLException ex) {
            System.out.println("Error while adding user - " + ex.getMessage());
        }
    }

    @Override
    public void update(User entry) throws EventException, NotFoundException {
        try {
            userRepsitory.update(entry);
        } catch (Exception ex) {
            System.out.println("Error while updating user - " + ex.getMessage());
        }
    }

    @Override
    public User search(Predicate<User> p) throws NotFoundException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(UUID id) throws EventException, NotFoundException {
        try {
            userRepsitory.delete(id);
        } catch (Exception ex) {
            System.out.println("Error while adding user - " + ex.getMessage());
        }
    }

    @Override
    public User findById(UUID id) throws NotFoundException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public User findByEmail(String email) {
        return userRepsitory.findByEmail(email);
    }

    @Override
    public boolean isEmailExist(String email) {
        return findByEmail(email) != null;
    }

}
