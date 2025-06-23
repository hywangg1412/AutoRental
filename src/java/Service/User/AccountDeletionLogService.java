package Service.User;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.User.AccountDeletionLog;
import Repository.User.AccountDeletionLogRepository;
import Service.Interfaces.IUser.IAccountDeletionLogService;

import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class AccountDeletionLogService implements IAccountDeletionLogService {
    private AccountDeletionLogRepository logRepository;
    private static final Logger LOGGER = Logger.getLogger(AccountDeletionLogService.class.getName());

    public AccountDeletionLogService() {
        this.logRepository = new AccountDeletionLogRepository();
    }

    private void validateAccountDeletionLog(AccountDeletionLog entry) throws InvalidDataException {
        if (entry == null) {
            throw new InvalidDataException("Account deletion log cannot be null");
        }
        if (entry.getUserId() == null) {
            throw new InvalidDataException("User ID cannot be null");
        }
        if (entry.getDeletionReason() == null || entry.getDeletionReason().trim().isEmpty()) {
            throw new InvalidDataException("Deletion reason cannot be empty");
        }
    }

    @Override
    public AccountDeletionLog add(AccountDeletionLog entry) throws EventException, InvalidDataException {
        try {
            validateAccountDeletionLog(entry);
            
            if (entry.getLogId() == null) {
                entry.setLogId(UUID.randomUUID());
            }
            
            if (entry.getTimestamp() == null) {
                entry.setTimestamp(java.time.LocalDateTime.now());
            }
            
            return logRepository.add(entry);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding account deletion log", e);
            throw new EventException("Error adding account deletion log: " + e.getMessage());
        } catch (InvalidDataException ex) {
            LOGGER.log(Level.SEVERE, null, ex);
            return null;
        }
    }

    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            List<AccountDeletionLog> logs = logRepository.findAll();
            if (logs.isEmpty()) {
                throw new EmptyDataException("No account deletion logs found");
            }
            for (AccountDeletionLog log : logs) {
                System.out.println(log);
            }
        } catch (SQLException e) {
            throw new EventException("Error displaying account deletion logs: " + e.getMessage());
        }
    }

    @Override
    public boolean update(AccountDeletionLog entry) throws EventException, NotFoundException {
        try {
            validateAccountDeletionLog(entry);
            AccountDeletionLog existingLog = logRepository.findById(entry.getLogId());
            if (existingLog == null) {
                throw new NotFoundException("Account deletion log not found with ID: " + entry.getLogId());
            }
            return logRepository.update(entry);
        } catch (SQLException e) {
            throw new EventException("Error updating account deletion log: " + e.getMessage());
        } catch (InvalidDataException ex) {
            LOGGER.log(Level.SEVERE, null, ex);
            return false;
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            AccountDeletionLog existingLog = logRepository.findById(id);
            if (existingLog == null) {
                throw new NotFoundException("Account deletion log not found with ID: " + id);
            }
            return logRepository.delete(id);
        } catch (SQLException e) {
            throw new EventException("Error deleting account deletion log: " + e.getMessage());
        }
    }

    @Override
    public AccountDeletionLog findById(UUID id) throws NotFoundException {
        try {
            AccountDeletionLog log = logRepository.findById(id);
            if (log == null) {
                throw new NotFoundException("Account deletion log not found with ID: " + id);
            }
            return log;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding account deletion log", e);
        }
        return null;
    }
} 