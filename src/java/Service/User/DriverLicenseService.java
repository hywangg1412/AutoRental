package Service.User;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.User.DriverLicense;
import Repository.User.DriverLicenseRepository;
import Service.Interfaces.IUser.IDriverLicenseService;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public class DriverLicenseService implements IDriverLicenseService {
    private final DriverLicenseRepository repository;

    public DriverLicenseService() {
        repository = new DriverLicenseRepository();
    }

    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            List<DriverLicense> list = repository.findAll();
            if (list == null || list.isEmpty()) {
                throw new EmptyDataException("No driver licenses found.");
            }
            list.forEach(System.out::println);
        } catch (SQLException e) {
            System.err.println("[DriverLicenseService] Error displaying: " + e.getMessage());
            throw new EventException("Error displaying driver licenses.");
        }
    }

    @Override
    public DriverLicense add(DriverLicense entry) throws EventException, InvalidDataException {
        if (entry == null) throw new InvalidDataException("DriverLicense cannot be null");
        try {
            DriverLicense result = repository.add(entry);
            if (result == null) throw new EventException("Failed to add driver license");
            return result;
        } catch (SQLException e) {
            System.err.println("[DriverLicenseService] Error adding: " + e.getMessage());
            throw new EventException("Error adding driver license.");
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        if (id == null) throw new NotFoundException("Id cannot be null");
        try {
            boolean deleted = repository.delete(id);
            if (!deleted) throw new NotFoundException("DriverLicense not found for delete");
            return true;
        } catch (SQLException e) {
            System.err.println("[DriverLicenseService] Error deleting: " + e.getMessage());
            throw new EventException("Error deleting driver license.");
        }
    }

    @Override
    public boolean update(DriverLicense entry) throws EventException, NotFoundException {
        if (entry == null || entry.getLicenseId() == null) throw new NotFoundException("DriverLicense or LicenseId cannot be null");
        try {
            boolean updated = repository.update(entry);
            if (!updated) throw new NotFoundException("DriverLicense not found for update");
            return true;
        } catch (SQLException e) {
            System.err.println("[DriverLicenseService] Error updating: " + e.getMessage());
            throw new EventException("Error updating driver license.");
        }
    }

    @Override
    public DriverLicense findById(UUID id) throws NotFoundException {
        if (id == null) throw new NotFoundException("Id cannot be null");
        try {
            DriverLicense dl = repository.findById(id);
            if (dl == null) throw new NotFoundException("DriverLicense not found");
            return dl;
        } catch (SQLException e) {
            System.err.println("[DriverLicenseService] Error finding by id: " + e.getMessage());
            throw new NotFoundException("Error finding driver license.");
        }
    }

    public DriverLicense findByUserId(UUID userId) throws NotFoundException {
        if (userId == null) throw new NotFoundException("UserId cannot be null");
        try {
            DriverLicense dl = repository.findByUserId(userId);
            if (dl == null) throw new NotFoundException("DriverLicense not found for userId");
            return dl;
        } catch (SQLException e) {
            System.err.println("[DriverLicenseService] Error finding by userId: " + e.getMessage());
            throw new NotFoundException("Error finding driver license by userId.");
        }
    }

    /**
     * Creates a default driver license for a new user
     * @param userId The user ID
     * @return The created driver license
     * @throws EventException If creation fails
     */
    public DriverLicense createDefaultForUser(UUID userId) throws EventException {
        if (userId == null) throw new EventException("UserId cannot be null");
        try {
            DriverLicense license = new DriverLicense();
            license.setLicenseId(UUID.randomUUID());
            license.setUserId(userId);
            license.setCreatedDate(java.time.LocalDateTime.now());
            // Other fields (LicenseNumber, FullName, DOB, LicenseImage) will be null initially
            
            DriverLicense result = repository.add(license);
            if (result == null) throw new EventException("Failed to create default driver license");
            return result;
        } catch (SQLException e) {
            System.err.println("[DriverLicenseService] Error creating default driver license: " + e.getMessage());
            throw new EventException("Error creating default driver license.");
        }
    }
}
