package Service.Car;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Car.CarBrand;
import Repository.Car.CarBrandRepository;
import Service.Interfaces.ICar.ICarBrandService;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CarBrandService implements ICarBrandService {
    private CarBrandRepository repository;

    public CarBrandService() {
        repository = new CarBrandRepository();
    }

    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            List<CarBrand> brands = repository.findAll();
            if (brands.isEmpty()) {
                throw new EmptyDataException("No car brands found");
            }
            for (CarBrand brand : brands) {
                System.out.println(brand);
            }
        } catch (SQLException e) {
            throw new EventException("Error displaying car brands: " + e.getMessage());
        }
    }

    private void validateCarBrand(CarBrand entry) throws InvalidDataException {
        if (entry == null) {
            throw new InvalidDataException("Car brand cannot be null");
        }
        if (entry.getBrandName() == null || entry.getBrandName().trim().isEmpty()) {
            throw new InvalidDataException("Car brand name cannot be empty");
        }
    }

    @Override
    public CarBrand add(CarBrand entry) throws EventException, InvalidDataException {
        try {
            validateCarBrand(entry);
            return repository.add(entry);
        } catch (SQLException e) {
            throw new EventException("Error adding car brand: " + e.getMessage());
        } catch (InvalidDataException ex) {
            Logger.getLogger(CarBrandService.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            CarBrand brand = repository.findById(id);
            if (brand == null) {
                throw new NotFoundException("Car brand not found with ID: " + id);
            }
            return repository.delete(id);
        } catch (SQLException e) {
            throw new EventException("Error deleting car brand: " + e.getMessage());
        }
    }

    @Override
    public boolean update(CarBrand entry) throws EventException, NotFoundException {
        try {
            validateCarBrand(entry);
            CarBrand existingBrand = repository.findById(entry.getBrandId());
            if (existingBrand == null) {
                throw new NotFoundException("Car brand not found with ID: " + entry.getBrandId());
            }
            return repository.update(entry);
        } catch (SQLException e) {
            throw new EventException("Error updating car brand: " + e.getMessage());
        } catch (InvalidDataException ex) {
            Logger.getLogger(CarBrandService.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    @Override
    public CarBrand findById(UUID id) throws NotFoundException {
        try {
            CarBrand brand = repository.findById(id);
            if (brand == null) {
                throw new NotFoundException("Car brand not found with ID: " + id);
            }
            return brand;
        } catch (SQLException e) {
            Logger.getLogger(CarBrandService.class.getName()).log(Level.SEVERE, "Error finding car brand: " + e.getMessage(), e);
            return null;
        }
    }
} 