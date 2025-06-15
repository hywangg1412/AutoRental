package Service.Car;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Car.CarCategories;
import Repository.Car.CarCategoriesRepository;
import Service.Interfaces.ICar.ICarCategoriesService;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CarCategoriesService implements ICarCategoriesService {
    private CarCategoriesRepository repository;

    public CarCategoriesService() {
        repository = new CarCategoriesRepository();
    }

    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            List<CarCategories> categories = repository.findAll();
            if (categories.isEmpty()) {
                throw new EmptyDataException("No car categories found");
            }
            for (CarCategories category : categories) {
                System.out.println(category);
            }
        } catch (SQLException e) {
            throw new EventException("Error displaying car categories: " + e.getMessage());
        }
    }

    private void validateCarCategories(CarCategories entry) throws InvalidDataException {
        if (entry == null) {
            throw new InvalidDataException("Car category cannot be null");
        }
        if (entry.getCategoryName() == null || entry.getCategoryName().trim().isEmpty()) {
            throw new InvalidDataException("Car category name cannot be empty");
        }
    }

    @Override
    public CarCategories add(CarCategories entry) throws EventException, InvalidDataException {
        try {
            validateCarCategories(entry);
            return repository.add(entry);
        } catch (SQLException e) {
            throw new EventException("Error adding car category: " + e.getMessage());
        } catch (InvalidDataException ex) {
            Logger.getLogger(CarCategoriesService.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            CarCategories category = repository.findById(id);
            if (category == null) {
                throw new NotFoundException("Car category not found with ID: " + id);
            }
            return repository.delete(id);
        } catch (SQLException e) {
            throw new EventException("Error deleting car category: " + e.getMessage());
        }
    }

    @Override
    public boolean update(CarCategories entry) throws EventException, NotFoundException {
        try {
            validateCarCategories(entry);
            CarCategories existingCategory = repository.findById(entry.getCategoryId());
            if (existingCategory == null) {
                throw new NotFoundException("Car category not found with ID: " + entry.getCategoryId());
            }
            return repository.update(entry);
        } catch (SQLException e) {
            throw new EventException("Error updating car category: " + e.getMessage());
        } catch (InvalidDataException ex) {
            Logger.getLogger(CarCategoriesService.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    @Override
    public CarCategories findById(UUID id) throws NotFoundException {
        try {
            CarCategories category = repository.findById(id);
            if (category == null) {
                throw new NotFoundException("Car category not found with ID: " + id);
            }
            return category;
        } catch (SQLException e) {
            Logger.getLogger(CarCategoriesService.class.getName()).log(Level.SEVERE, "Error finding car category: " + e.getMessage(), e);
            return null;
        }
    }
}