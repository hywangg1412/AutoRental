package Service.Car;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Car.TransmissionType;
import Repository.Car.TransmissionTypeRepository;
import Service.Interfaces.ICar.ITransmissionTypeService;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TransmissionTypeService implements ITransmissionTypeService {
    private final TransmissionTypeRepository repository = new TransmissionTypeRepository();

    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            List<TransmissionType> transmissionTypes = repository.findAll();
            if (transmissionTypes.isEmpty()) {
                throw new EmptyDataException("No transmission types found");
            }
            for (TransmissionType transmissionType : transmissionTypes) {
                System.out.println(transmissionType);
            }
        } catch (Exception e) {
            throw new EventException("Error displaying transmission types: " + e.getMessage());
        }
    }

    @Override
    public TransmissionType add(TransmissionType entry) throws EventException, InvalidDataException {
        try {
            validateTransmissionType(entry);
            return repository.add(entry);
        } catch (SQLException e) {
            throw new EventException("Error adding transmission type: " + e.getMessage());
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            TransmissionType transmissionType = repository.findById(id);
            if (transmissionType == null) {
                throw new NotFoundException("Transmission type not found with ID: " + id);
            }
            return repository.delete(id);
        } catch (SQLException e) {
            throw new EventException("Error deleting transmission type: " + e.getMessage());
        }
    }

    @Override
    public boolean update(TransmissionType entry) throws EventException, NotFoundException {
        try {
            try {
                validateTransmissionType(entry);
            } catch (InvalidDataException ex) {
                Logger.getLogger(TransmissionTypeService.class.getName()).log(Level.SEVERE, null, ex);
            }
            TransmissionType existingTransmissionType = repository.findById(entry.getTransmissionTypeId());
            if (existingTransmissionType == null) {
                throw new NotFoundException("Transmission type not found with ID: " + entry.getTransmissionTypeId());
            }
            return repository.update(entry);
        } catch (SQLException e) {
            throw new EventException("Error updating transmission type: " + e.getMessage());
        }
    }

    @Override
    public TransmissionType findById(UUID id) throws NotFoundException {
        try {
          
            TransmissionType transmissionType = repository.findById(id);
            if (transmissionType == null) {
                throw new NotFoundException("Transmission type not found with ID: " + id);
            }
            return transmissionType;
        } catch (SQLException e) {
            Logger.getLogger(TransmissionTypeService.class.getName()).log(Level.SEVERE, "Error finding transmission type: " + e.getMessage(), e);
            return null;
        }
    }

    public List<TransmissionType> getAll() {
        return repository.findAll();
    }

    private void validateTransmissionType(TransmissionType entry) throws InvalidDataException {
        if (entry == null) {
            throw new InvalidDataException("Transmission type cannot be null");
        }
        if (entry.getTransmissionTypeId() == null) {
            throw new InvalidDataException("Transmission type ID cannot be null");
        }
        if (entry.getTransmissionName() == null || entry.getTransmissionName().trim().isEmpty()) {
            throw new InvalidDataException("Transmission type name cannot be empty");
        }
    }
} 