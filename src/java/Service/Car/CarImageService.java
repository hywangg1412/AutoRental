package Service.Car;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Car.CarImage;
import Repository.Interfaces.ICar.ICarImageRepository;
import Repository.Car.CarImageRepository;
import Service.Interfaces.ICar.ICarImageService;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;


public class CarImageService implements ICarImageService{
    private static final Logger LOGGER = Logger.getLogger(CarImageService.class.getName());
    private final CarImageRepository carImageRepository = new CarImageRepository();

    @Override
    public String getMainImageUrlByCarId(UUID carId) {
        try {
            CarImage image = carImageRepository.findMainImageByCarId(carId);
            if (image != null && image.getImageUrl() != null) {
                return image.getImageUrl();
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error getting main image URL by carId: " + carId, e);
        }
        return "/images/car-default.jpg";
    }

    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            var images = carImageRepository.findAll();
            if (images.isEmpty()) {
                throw new EmptyDataException("No car images found");
            }
            for (CarImage img : images) {
                System.out.println(img);
            }
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error displaying car images", e);
            throw new EventException("Error displaying car images: " + e.getMessage());
        }
    }

    @Override
    public CarImage add(CarImage entry) throws EventException, InvalidDataException {
        try {
            return carImageRepository.add(entry);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error adding car image: " + entry, e);
            throw new EventException("Error adding car image: " + e.getMessage());
        }
    }

    @Override
    public boolean update(CarImage entry) throws EventException, NotFoundException {
        try {
            return carImageRepository.update(entry);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error updating car image: " + entry, e);
            throw new EventException("Error updating car image: " + e.getMessage());
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            return carImageRepository.delete(id);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error deleting car image by id: " + id, e);
            throw new EventException("Error deleting car image: " + e.getMessage());
        }
    }

    @Override
    public CarImage findById(UUID id) throws NotFoundException {
        try {
            CarImage image = carImageRepository.findById(id);
            if (image == null) {
                throw new NotFoundException("Car image not found with id: " + id);
            }
            return image;
        } catch (NotFoundException e) {
            throw e;
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding car image by id: " + id, e);
            throw new NotFoundException("Error finding car image: " + e.getMessage());
        }
    }
}
