package Service.Car;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Car.CarFeaturesMapping;
import Repository.Car.CarFeaturesMappingRepository;
import Service.Interfaces.ICar.ICarFeaturesMappingService;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CarFeaturesMappingService implements ICarFeaturesMappingService {
    private CarFeaturesMappingRepository repository;

    public CarFeaturesMappingService() {
        repository = new CarFeaturesMappingRepository();
    }

    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            List<CarFeaturesMapping> mappings = repository.findAll();
            if (mappings.isEmpty()) {
                throw new EmptyDataException("No car feature mappings found");
            }
            for (CarFeaturesMapping mapping : mappings) {
                System.out.println(mapping);
            }
        } catch (SQLException e) {
            throw new EventException("Error displaying car feature mappings: " + e.getMessage());
        }
    }

    private void validateCarFeaturesMapping(CarFeaturesMapping entry) throws InvalidDataException {
        if (entry == null) {
            throw new InvalidDataException("Car feature mapping cannot be null");
        }
        if (entry.getCarId() == null) {
            throw new InvalidDataException("Car ID cannot be null");
        }
        if (entry.getFeatureId() == null) {
            throw new InvalidDataException("Feature ID cannot be null");
        }
    }

    @Override
    public CarFeaturesMapping add(CarFeaturesMapping entry) throws EventException, InvalidDataException {
        try {
            validateCarFeaturesMapping(entry);
            return repository.add(entry);
        } catch (SQLException e) {
            throw new EventException("Error adding car feature mapping: " + e.getMessage());
        } catch (InvalidDataException ex) {
            Logger.getLogger(CarFeaturesMappingService.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            CarFeaturesMapping mapping = repository.findById(id);
            if (mapping == null) {
                throw new NotFoundException("Car feature mapping not found with ID: " + id);
            }
            return repository.delete(id);
        } catch (SQLException e) {
            throw new EventException("Error deleting car feature mapping: " + e.getMessage());
        }
    }

    @Override
    public boolean update(CarFeaturesMapping entry) throws EventException, NotFoundException {
        try {
            validateCarFeaturesMapping(entry);
            CarFeaturesMapping existingMapping = repository.findById(entry.getCarId());
            if (existingMapping == null) {
                throw new NotFoundException("Car feature mapping not found with ID: " + entry.getCarId());
            }
            return repository.update(entry);
        } catch (SQLException e) {
            throw new EventException("Error updating car feature mapping: " + e.getMessage());
        } catch (InvalidDataException ex) {
            Logger.getLogger(CarFeaturesMappingService.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    @Override
    public CarFeaturesMapping findById(UUID id) throws NotFoundException {
        try {
            CarFeaturesMapping mapping = repository.findById(id);
            if (mapping == null) {
                throw new NotFoundException("Car feature mapping not found with ID: " + id);
            }
            return mapping;
        } catch (SQLException e) {
            Logger.getLogger(CarFeaturesMappingService.class.getName()).log(Level.SEVERE, "Error finding car feature mapping: " + e.getMessage(), e);
            return null;
        }
    }

    public boolean deleteByCarAndFeature(UUID carId, UUID featureId) throws Exception {
        return repository.deleteByCarAndFeature(carId, featureId);
    }

    public void addMapping(UUID carId, UUID featureId) throws Exception {
        CarFeaturesMapping mapping = new CarFeaturesMapping(carId, featureId);
        repository.add(mapping);
    }
} 