package Service.Booking;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Booking.Booking;
import Repository.Booking.BookingRepository;
import Service.Interfaces.IBooking.IBookingService;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookingService implements IBookingService {
    private static final Logger LOGGER = Logger.getLogger(BookingService.class.getName());
    private final BookingRepository bookingRepository;
    
    private static final String[] VALID_STATUSES = {"Pending", "Confirmed", "Cancelled", "Completed"};
    private static final String DEFAULT_STATUS = "Pending";

    public BookingService() {
        this.bookingRepository = new BookingRepository();
    }

    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            List<Booking> bookings = bookingRepository.findAll();
            if (bookings.isEmpty()) {
                throw new EmptyDataException("No bookings found.");
            }
            bookings.forEach(booking -> LOGGER.info(booking.toString()));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error displaying bookings", e);
            throw new EventException("Error displaying bookings: " + e.getMessage());
        }
    }

    @Override
    public Booking add(Booking entry) throws EventException, InvalidDataException {
        try {
            validateBooking(entry);
            prepareNewBooking(entry);
            return bookingRepository.add(entry);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding booking", e);
            throw new EventException("Error adding booking: " + e.getMessage());
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            validateBookingExists(id);
            return bookingRepository.delete(id);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting booking", e);
            throw new EventException("Error deleting booking: " + e.getMessage());
        }
    }

    @Override
    public boolean update(Booking entry) throws EventException, NotFoundException {
        try {
            validateBookingExists(entry.getBookingId());
            validateBooking(entry);
            return bookingRepository.update(entry);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating booking", e);
            throw new EventException("Error updating booking: " + e.getMessage());
        } catch (InvalidDataException e) {
            LOGGER.log(Level.SEVERE, "Invalid booking data", e);
            throw new EventException("Invalid booking data: " + e.getMessage());
        }
    }

    @Override
    public Booking findById(UUID id) throws NotFoundException {
        if (id == null) {
            throw new NotFoundException("Booking ID cannot be null");
        }
        
        try {
            Booking booking = bookingRepository.findById(id);
            if (booking == null) {
                throw new NotFoundException("Booking not found with ID: " + id);
            }
            return booking;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding booking with ID: " + id, e);
            throw new RuntimeException("Error finding booking: " + e.getMessage(), e);
        }
    }

    @Override
    public List<Booking> findByStatus(String status) throws SQLException {
        return bookingRepository.findByStatus(status);
    }

    private void validateBooking(Booking booking) throws InvalidDataException {
        if (booking == null) {
            throw new InvalidDataException("Booking cannot be null");
        }
        
        validateRequiredFields(booking);
        validateDates(booking);
        validateAmount(booking);
        validateStatus(booking);
    }

    private void validateRequiredFields(Booking booking) throws InvalidDataException {
        if (booking.getUserId() == null) {
            throw new InvalidDataException("User ID is required");
        }
        if (booking.getCarId() == null) {
            throw new InvalidDataException("Car ID is required");
        }
    }

    private void validateDates(Booking booking) throws InvalidDataException {
        if (booking.getPickupDateTime() == null) {
            throw new InvalidDataException("Pickup date/time is required");
        }
        if (booking.getReturnDateTime() == null) {
            throw new InvalidDataException("Return date/time is required");
        }
        if (booking.getPickupDateTime().isAfter(booking.getReturnDateTime())) {
            throw new InvalidDataException("Pickup date/time must be before return date/time");
        }
        if (booking.getPickupDateTime().isBefore(LocalDateTime.now())) {
            throw new InvalidDataException("Pickup date/time cannot be in the past");
        }
    }

    private void validateAmount(Booking booking) throws InvalidDataException {
        if (booking.getTotalAmount() < 0) {
            throw new InvalidDataException("Total amount cannot be negative");
        }
    }

    private void validateStatus(Booking booking) throws InvalidDataException {
        if (booking.getStatus() != null && !isValidStatus(booking.getStatus())) {
            throw new InvalidDataException("Invalid booking status. Must be one of: " + String.join(", ", VALID_STATUSES));
        }
    }

    private boolean isValidStatus(String status) {
        for (String validStatus : VALID_STATUSES) {
            if (validStatus.equals(status)) {
                return true;
            }
        }
        return false;
    }

    private void validateBookingExists(UUID id) throws NotFoundException, SQLException {
        if (bookingRepository.findById(id) == null) {
            throw new NotFoundException("Booking not found with ID: " + id);
        }
    }

    private void prepareNewBooking(Booking booking) {
        booking.setCreatedDate(LocalDateTime.now());
        if (booking.getStatus() == null || booking.getStatus().isEmpty()) {
            booking.setStatus(DEFAULT_STATUS);
        }
    }
}

