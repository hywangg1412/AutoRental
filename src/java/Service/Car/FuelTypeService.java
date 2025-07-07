package Service.Car;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Car.FuelType;
import Repository.Car.FuelTypeRepository;
import Service.Interfaces.ICar.IFuelTypeService;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class FuelTypeService implements IFuelTypeService {
    private FuelTypeRepository repository;

    public FuelTypeService() {
        repository = new FuelTypeRepository();
    }

    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            List<FuelType> fuelTypes = repository.findAll();
            if (fuelTypes.isEmpty()) {
                throw new EmptyDataException("No fuel types found");
            }
            for (FuelType fuelType : fuelTypes) {
                System.out.println(fuelType);
            }
        } catch (Exception e) {
            throw new EventException("Error displaying fuel types: " + e.getMessage());
        }
    }

    private void validateFuelType(FuelType entry) throws InvalidDataException {
        if (entry == null) {
            throw new InvalidDataException("Fuel type cannot be null");
        }
        if (entry.getFuelName() == null || entry.getFuelName().trim().isEmpty()) {
            throw new InvalidDataException("Fuel type name cannot be empty");
        }
    }

    @Override
    public FuelType add(FuelType entry) throws EventException, InvalidDataException {
        try {
            validateFuelType(entry);
            return repository.add(entry);
        } catch (SQLException e) {
            throw new EventException("Error adding fuel type: " + e.getMessage());
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            FuelType fuelType = repository.findById(id);
            if (fuelType == null) {
                throw new NotFoundException("Fuel type not found with ID: " + id);
            }
            return repository.delete(id);
        } catch (SQLException e) {
            throw new EventException("Error deleting fuel type: " + e.getMessage());
        }
    }

    @Override
    public boolean update(FuelType entry) throws EventException, NotFoundException {
        try {
            validateFuelType(entry);
            FuelType existingFuelType = repository.findById(entry.getFuelTypeId());
            if (existingFuelType == null) {
                throw new NotFoundException("Fuel type not found with ID: " + entry.getFuelTypeId());
            }
            return repository.update(entry);
        } catch (InvalidDataException ex) {
            Logger.getLogger(FuelTypeService.class.getName()).log(Level.SEVERE, "Invalid data: " + ex.getMessage(), ex);
            return false;
        } catch (SQLException e) {
            throw new EventException("Error updating fuel type: " + e.getMessage());
        }
    }

    @Override
    public FuelType findById(UUID id) throws NotFoundException {
        try {
            FuelType fuelType = repository.findById(id);
            if (fuelType == null) {
                throw new NotFoundException("Fuel type not found with ID: " + id);
            }
            return fuelType;
        } catch (SQLException e) {
            Logger.getLogger(FuelTypeService.class.getName()).log(Level.SEVERE, "Error finding fuel type: " + e.getMessage(), e);
        }
        return null;
    }

    public List<FuelType> getAll() {
        return repository.findAll();
    }
} 