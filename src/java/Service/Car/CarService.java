package Service.Car;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Car.Car;
import Service.Interfaces.ICar.ICarService;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import java.util.function.Predicate;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CarService implements ICarService {

    private final Repository.Car.CarRepository carRepository = new Repository.Car.CarRepository();

    private void validateCar(Car entry) throws InvalidDataException {
        if (entry == null) {
            throw new InvalidDataException("Car cannot be null");
        }
    }

    @Override
    public void display() throws EmptyDataException {
        try {
            var cars = carRepository.findAll();
            if (cars.isEmpty()) {
                throw new EmptyDataException("No cars found");
            }
            for (Car car : cars) {
                System.out.println(car);
            }
        } catch (SQLException e) {
            throw new EmptyDataException("Error displaying cars: " + e.getMessage());
        }
    }

    @Override
    public Car add(Car entry) throws EventException, InvalidDataException {
        try {
            validateCar(entry);
            return carRepository.add(entry);
        } catch (SQLException e) {
            throw new EventException("Error adding car: " + e.getMessage());
        } catch (InvalidDataException ex) {
            Logger.getLogger(CarService.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            Car car = carRepository.findById(id);
            if (car == null) {
                throw new NotFoundException("Car not found with ID: " + id);
            }
            return carRepository.delete(id);
        } catch (SQLException e) {
            throw new EventException("Error deleting car: " + e.getMessage());
        }
    }

    @Override
    public boolean update(Car entry) throws EventException, NotFoundException {
        try {
            validateCar(entry);
            Car existingCar = carRepository.findById(entry.getCarId());
            if (existingCar == null) {
                throw new NotFoundException("Car not found with ID: " + entry.getCarId());
            }
            return carRepository.update(entry);
        } catch (SQLException e) {
            throw new EventException("Error updating car: " + e.getMessage());
        } catch (InvalidDataException ex) {
            Logger.getLogger(CarService.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    @Override
    public Car findById(UUID id) throws NotFoundException {
        try {
            Car car = carRepository.findById(id);
            if (car == null) {
                throw new NotFoundException("Car not found with ID: " + id);
            }
            return car;
        } catch (SQLException e) {
            Logger.getLogger(CarService.class.getName()).log(Level.SEVERE, "Error finding car: " + e.getMessage(), e);
            return null;
        }
    }

    @Override
    public List<Car> findAll() throws SQLException {
        return carRepository.findAll();
    }

    @Override
    public List<Car> findByPage(int offset, int limit) throws SQLException {
        return carRepository.findByPage(offset, limit);
    }

    @Override
    public int countAll() throws SQLException {
        return carRepository.countAll();
    }

    @Override
    public List<Car> searchByKeyword(String keyword, int offset, int limit) throws SQLException {
        return carRepository.searchByKeyword(keyword, offset, limit);
    }

    @Override
    public int countByKeyword(String keyword) throws SQLException {
        return carRepository.countByKeyword(keyword);
    }

    @Override
    public List<Car> filterCars(
        String[] brandIds, String[] fuelTypeIds, String[] seats, String[] categoryIds,
        String[] statuses, String[] featureIds, String[] transmissionTypeIds, String sort, String keyword,
        Integer minPricePerHour, Integer maxPricePerHour,
        Integer minSeats, Integer maxSeats,
        Integer minYear, Integer maxYear,
        Integer minOdometer, Integer maxOdometer,
        Integer minDistance, Integer maxDistance,
        int offset, int limit
    ) throws SQLException {
        return carRepository.filterCars(brandIds, fuelTypeIds, seats, categoryIds, statuses, featureIds, transmissionTypeIds, sort, keyword, minPricePerHour, maxPricePerHour, minSeats, maxSeats, minYear, maxYear, minOdometer, maxOdometer, minDistance, maxDistance, offset, limit);
    }

    @Override
    public int countFilteredCars(
        String[] brandIds, String[] fuelTypeIds, String[] seats, String[] categoryIds,
        String[] statuses, String[] featureIds, String[] transmissionTypeIds, String keyword,
        Integer minPricePerHour, Integer maxPricePerHour,
        Integer minSeats, Integer maxSeats,
        Integer minYear, Integer maxYear,
        Integer minOdometer, Integer maxOdometer,
        Integer minDistance, Integer maxDistance
    ) throws SQLException {
        return carRepository.countFilteredCars(brandIds, fuelTypeIds, seats, categoryIds, statuses, featureIds, transmissionTypeIds, keyword, minPricePerHour, maxPricePerHour, minSeats, maxSeats, minYear, maxYear, minOdometer, maxOdometer, minDistance, maxDistance);
    }

    public List<Integer> getAllSeatNumbers() {
        return carRepository.getAllSeatNumbers();
    }

}
