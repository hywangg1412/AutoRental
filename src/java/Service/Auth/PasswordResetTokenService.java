package Service.Auth;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.OAuth.PasswordResetToken;
import Repository.Auth.PasswordResetTokenRepository;
import Service.Interfaces.IAuth.IPasswordResetTokenService;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import java.util.function.Predicate;

public class PasswordResetTokenService implements IPasswordResetTokenService{

    private PasswordResetTokenRepository PRTRepository;
    
    public PasswordResetTokenService(){
        PRTRepository = new PasswordResetTokenRepository();
    }
    
    @Override
    public void display() throws EmptyDataException {
        try {
            List<PasswordResetToken> tokens = PRTRepository.findAll();
            if (tokens.isEmpty()) {
                throw new EmptyDataException("No password reset tokens found.");
            }
            for (PasswordResetToken token : tokens) {
                System.out.println(token);
            }
        } catch (SQLException e) {
            throw new EmptyDataException("Error retrieving tokens: " + e.getMessage());
        }
    }

    @Override
    public PasswordResetToken add(PasswordResetToken entry) throws EventException, InvalidDataException {
        if (entry == null) throw new InvalidDataException("Token entry is null");
        try {
            return PRTRepository.add(entry);
        } catch (SQLException e) {
            throw new EventException("Error adding token: " + e.getMessage());
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            PasswordResetToken token = PRTRepository.findById(id);
            if (token == null) throw new NotFoundException("Token not found");
            return PRTRepository.delete(id);
        } catch (SQLException e) {
            throw new EventException("Error deleting token: " + e.getMessage());
        }
    }

    @Override
    public boolean update(PasswordResetToken entry) throws EventException, NotFoundException {
        if (entry == null) throw new NotFoundException("Token entry is null");
        try {
            PasswordResetToken token = PRTRepository.findById(entry.getId());
            if (token == null) throw new NotFoundException("Token not found");
            return PRTRepository.update(entry);
        } catch (SQLException e) {
            throw new EventException("Error updating token: " + e.getMessage());
        }
    }

    @Override
    public PasswordResetToken findById(UUID id) throws NotFoundException {
        try {
            PasswordResetToken token = PRTRepository.findById(id);
            if (token == null) throw new NotFoundException("Token not found");
            return token;
        } catch (SQLException e) {
            throw new NotFoundException("Error finding token: " + e.getMessage());
        }
    }

    @Override
    public PasswordResetToken findByToken(String token) throws NotFoundException {
        PasswordResetToken tokenObj = PRTRepository.findByToken(token);
        if (tokenObj == null) {
            throw new NotFoundException("Token not found");
        }
        return tokenObj;
    }
    
}
