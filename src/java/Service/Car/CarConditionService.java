package Service.Car;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Constants.BookingStatusConstants;
import Model.Entity.Booking.Booking;
import Model.Entity.Car.CarConditionLogs;
import Repository.Booking.BookingRepository;
import Repository.Car.CarConditionLogsRepository;
import Service.Interfaces.ICar.ICarConditionService;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CarConditionService implements ICarConditionService {
    private static final Logger LOGGER = Logger.getLogger(CarConditionService.class.getName());
    private final CarConditionLogsRepository carConditionLogsRepository;
    private final BookingRepository bookingRepository;
    
    public CarConditionService() {
        this.carConditionLogsRepository = new CarConditionLogsRepository();
        this.bookingRepository = new BookingRepository();
    }
    
    @Override
    public List<CarConditionLogs> findByBookingId(UUID bookingId) throws NotFoundException {
        try {
            List<CarConditionLogs> logs = carConditionLogsRepository.findByBookingId(bookingId);
            if (logs.isEmpty()) {
                throw new NotFoundException("No condition logs found for booking: " + bookingId);
            }
            return logs;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding condition logs by booking ID: {0}", e.getMessage());
            throw new NotFoundException("Error finding condition logs: " + e.getMessage());
        }
    }
    
    @Override
    public List<CarConditionLogs> findByCarId(UUID carId) throws NotFoundException {
        try {
            List<CarConditionLogs> logs = carConditionLogsRepository.findByCarId(carId);
            if (logs.isEmpty()) {
                throw new NotFoundException("No condition logs found for car: " + carId);
            }
            return logs;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding condition logs by car ID: {0}", e.getMessage());
            throw new NotFoundException("Error finding condition logs: " + e.getMessage());
        }
    }
    
    @Override
    public List<CarConditionLogs> findRecentInspections(int limit) throws EmptyDataException {
        try {
            List<CarConditionLogs> logs = carConditionLogsRepository.findRecentInspections(limit);
            if (logs.isEmpty()) {
                throw new EmptyDataException("No recent inspections found");
            }
            return logs;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding recent inspections: {0}", e.getMessage());
            throw new EmptyDataException("Error finding recent inspections: " + e.getMessage());
        }
    }
    
    @Override
    public List<CarConditionLogs> findPendingInspections() throws EmptyDataException {
        try {
            List<CarConditionLogs> logs = carConditionLogsRepository.findPendingInspections();
            if (logs.isEmpty()) {
                throw new EmptyDataException("No pending inspections found");
            }
            return logs;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding pending inspections: {0}", e.getMessage());
            throw new EmptyDataException("Error finding pending inspections: " + e.getMessage());
        }
    }
    
    @Override
    public boolean updateConditionStatus(UUID logId, String status) throws NotFoundException, InvalidDataException {
        try {
            if (status == null || status.trim().isEmpty()) {
                throw new InvalidDataException("Status cannot be empty");
            }
            
            CarConditionLogs log = carConditionLogsRepository.findById(logId);
            if (log == null) {
                throw new NotFoundException("Condition log not found: " + logId);
            }
            
            log.setConditionStatus(status);
            return carConditionLogsRepository.update(log);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating condition status: {0}", e.getMessage());
            throw new InvalidDataException("Error updating condition status: " + e.getMessage());
        }
    }
    
    @Override
    public CarConditionLogs createInspection(UUID bookingId, UUID carId, UUID staffId, String checkType, 
                                           Integer odometer, String fuelLevel, String conditionStatus, 
                                           String conditionDescription, String damageImages, String note) 
                                           throws InvalidDataException, EventException {
        try {
            if (bookingId == null || carId == null || staffId == null) {
                throw new InvalidDataException("Booking ID, Car ID, and Staff ID are required");
            }
            
            CarConditionLogs log = new CarConditionLogs();
            log.setLogId(UUID.randomUUID());
            log.setBookingId(bookingId);
            log.setCarId(carId);
            log.setStaffId(staffId);
            log.setCheckType(checkType);
            log.setCheckTime(LocalDateTime.now());
            log.setOdometer(odometer);
            log.setFuelLevel(fuelLevel);
            log.setConditionStatus(conditionStatus);
            log.setConditionDescription(conditionDescription);
            log.setDamageImages(damageImages);
            log.setNote(note);
            
            return carConditionLogsRepository.add(log);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating inspection: {0}", e.getMessage());
            throw new EventException("Error creating inspection: " + e.getMessage());
        }
    }
    
    @Override
    public boolean acceptReturnCar(UUID bookingId, UUID logId) throws NotFoundException, EventException {
        try {
            // Validate parameters
            if (bookingId == null || logId == null) {
                throw new InvalidDataException("Booking ID and Log ID are required");
            }
            
            // Get the booking
            Booking booking = bookingRepository.findById(bookingId);
            if (booking == null) {
                throw new NotFoundException("Booking not found: " + bookingId);
            }
            
            // Get the condition log
            CarConditionLogs log = carConditionLogsRepository.findById(logId);
            if (log == null) {
                throw new NotFoundException("Condition log not found: " + logId);
            }
            
            // Update booking status to COMPLETED
            booking.setStatus(BookingStatusConstants.COMPLETED);
            boolean bookingUpdated = bookingRepository.update(booking);
            
            // Return true if booking was updated successfully
            return bookingUpdated;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error accepting return car: {0}", e.getMessage());
            throw new EventException("Error accepting return car: " + e.getMessage());
        } catch (InvalidDataException e) {
            LOGGER.log(Level.SEVERE, "Invalid data: {0}", e.getMessage());
            throw new EventException("Invalid data: " + e.getMessage());
        }
    }
    
    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            List<CarConditionLogs> logs = carConditionLogsRepository.findAll();
            if (logs.isEmpty()) {
                throw new EmptyDataException("No condition logs found");
            }
            
            for (CarConditionLogs log : logs) {
                System.out.println(log.toString());
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error displaying condition logs: {0}", e.getMessage());
            throw new EventException("Error displaying condition logs: " + e.getMessage());
        }
    }
    
    @Override
    public CarConditionLogs add(CarConditionLogs entity) throws EventException, InvalidDataException {
        try {
            return carConditionLogsRepository.add(entity);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding condition log: {0}", e.getMessage());
            throw new EventException("Error adding condition log: " + e.getMessage());
        }
    }
    
    @Override
    public boolean update(CarConditionLogs entity) throws EventException, NotFoundException {
        try {
            return carConditionLogsRepository.update(entity);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating condition log: {0}", e.getMessage());
            throw new EventException("Error updating condition log: " + e.getMessage());
        }
    }
    
    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            return carConditionLogsRepository.delete(id);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting condition log: {0}", e.getMessage());
            throw new EventException("Error deleting condition log: " + e.getMessage());
        }
    }
    
    @Override
    public CarConditionLogs findById(UUID id) throws NotFoundException {
        try {
            CarConditionLogs log = carConditionLogsRepository.findById(id);
            if (log == null) {
                throw new NotFoundException("Condition log not found: " + id);
            }
            return log;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding condition log by ID: {0}", e.getMessage());
            throw new NotFoundException("Error finding condition log: " + e.getMessage());
        }
    }
} 