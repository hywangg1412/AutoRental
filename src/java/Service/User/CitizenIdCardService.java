package Service.User;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.User.CitizenIdCard;
import Repository.User.CitizenIdCardRepository;
import Service.Interfaces.IUser.ICitizenIdCardService;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public class CitizenIdCardService implements ICitizenIdCardService {
    private final CitizenIdCardRepository repo = new CitizenIdCardRepository();

    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            List<CitizenIdCard> list = repo.findAll();
            if (list.isEmpty()) throw new EmptyDataException("No Citizen ID cards found.");
            list.forEach(System.out::println);
        } catch (SQLException e) {
            throw new EventException("Database error: " + e.getMessage());
        }
    }

    @Override
    public CitizenIdCard add(CitizenIdCard entry) throws EventException, InvalidDataException {
        try {
            if (entry.getCitizenIdNumber() == null || entry.getCitizenIdNumber().length() != 12)
                throw new InvalidDataException("Citizen ID number must be 12 digits.");
            return repo.add(entry);
        } catch (SQLException e) {
            throw new EventException("Database error: " + e.getMessage());
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            CitizenIdCard card = repo.findById(id);
            if (card == null) throw new NotFoundException("Citizen ID card not found.");
            return repo.delete(id);
        } catch (SQLException e) {
            throw new EventException("Database error: " + e.getMessage());
        }
    }

    @Override
    public boolean update(CitizenIdCard entry) throws EventException, NotFoundException {
        try {
            CitizenIdCard card = repo.findById(entry.getId());
            if (card == null) throw new NotFoundException("Citizen ID card not found.");
            return repo.update(entry);
        } catch (SQLException e) {
            throw new EventException("Database error: " + e.getMessage());
        }
    }

    @Override
    public CitizenIdCard findById(UUID id) throws NotFoundException {
        try {
            CitizenIdCard card = repo.findById(id);
            if (card == null) throw new NotFoundException("Citizen ID card not found.");
            return card;
        } catch (SQLException e) {
            throw new NotFoundException("Database error: " + e.getMessage());
        }
    }
    @Override
    public CitizenIdCard findByUserId(UUID userId) throws NotFoundException {
        try {
            CitizenIdCard card = repo.findByUserId(userId);
            if (card == null) throw new NotFoundException("Citizen ID card not found.");
            return card;
        } catch (SQLException e) {
            throw new NotFoundException("Database error: " + e.getMessage());
        }
    }
}
