package Service.Car;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Car.CarFeature;
import Repository.Car.CarFeatureRepository;
import Service.Interfaces.ICar.ICarFeatureService;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CarFeatureService implements ICarFeatureService {

    private CarFeatureRepository repository;

    public CarFeatureService() {
        repository = new CarFeatureRepository();
    }

    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            List<CarFeature> features = repository.findAll();
            if (features.isEmpty()) {
                throw new EmptyDataException("No car features found");
            }
            for (CarFeature feature : features) {
                System.out.println(feature);
            }
        } catch (SQLException e) {
            throw new EventException("Error displaying car features: " + e.getMessage());
        }
    }

    private void validateCarFeature(CarFeature entry) throws InvalidDataException {
        if (entry == null) {
            throw new InvalidDataException("Car feature cannot be null");
        }
        if (entry.getFeatureName() == null || entry.getFeatureName().trim().isEmpty()) {
            throw new InvalidDataException("Car feature name cannot be empty");
        }
    }

    @Override
    public CarFeature add(CarFeature entry) throws EventException, InvalidDataException {
        try {
            validateCarFeature(entry);
            return repository.add(entry);
        } catch (SQLException e) {
            throw new EventException("Error adding car feature: " + e.getMessage());
        } catch (InvalidDataException ex) {
            Logger.getLogger(CarFeatureService.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            CarFeature feature = repository.findById(id);
            if (feature == null) {
                throw new NotFoundException("Car feature not found with ID: " + id);
            }
            return repository.delete(id);
        } catch (SQLException e) {
            throw new EventException("Error deleting car feature: " + e.getMessage());
        }
    }

    @Override
    public boolean update(CarFeature entry) throws EventException, NotFoundException {
        try {
            validateCarFeature(entry);
            CarFeature existingFeature = repository.findById(entry.getFeatureId());
            if (existingFeature == null) {
                throw new NotFoundException("Car feature not found with ID: " + entry.getFeatureId());
            }
            return repository.update(entry);
        } catch (SQLException e) {
            throw new EventException("Error updating car feature: " + e.getMessage());
        } catch (InvalidDataException ex) {
            Logger.getLogger(CarFeatureService.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    @Override
    public CarFeature findById(UUID id) throws NotFoundException {
        try {
            CarFeature feature = repository.findById(id);
            if (feature == null) {
                throw new NotFoundException("Car feature not found with ID: " + id);
            }
            return feature;
        } catch (SQLException e) {
            Logger.getLogger(CarFeatureService.class.getName()).log(Level.SEVERE, "Error finding car feature: " + e.getMessage(), e);
            return null;
        }
    }

    public List<CarFeature> findByCarId(UUID carId) throws SQLException {
        return repository.findByCarId(carId);
    }

    public List<CarFeature> findAll() throws SQLException {
        return repository.findAll();
    }
}
