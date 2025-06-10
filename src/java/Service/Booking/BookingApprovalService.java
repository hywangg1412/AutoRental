package Service.Booking;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Booking.BookingApproval;
import Repository.Booking.BookingApprovalRepository;
import Service.Interfaces.IBooking.IBookingApprovalService;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class BookingApprovalService implements IBookingApprovalService{
    private static final Logger LOGGER = Logger.getLogger(BookingApprovalService.class.getName());
    private final BookingApprovalRepository bookingApprovalRepository = new BookingApprovalRepository();

    @Override
    public void display() throws EmptyDataException, EventException {
        try {
            List<BookingApproval> approvals = bookingApprovalRepository.findAll();
            if (approvals.isEmpty()) {
                throw new EmptyDataException("No booking approvals found.");
            }
            approvals.forEach(approval -> LOGGER.info(approval.toString()));
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error displaying booking approvals", e);
            throw new EventException("Error displaying booking approvals: " + e.getMessage());
        }
    }

    @Override
    public BookingApproval add(BookingApproval entry) throws EventException, InvalidDataException {
        validateBookingApproval(entry);
        try {
            return bookingApprovalRepository.add(entry);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding booking approval", e);
            throw new EventException("Error adding booking approval: " + e.getMessage());
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            BookingApproval approval = bookingApprovalRepository.findById(id);
            if (approval == null) {
                throw new NotFoundException("Booking approval not found with ID: " + id);
            }
            return bookingApprovalRepository.delete(id);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting booking approval", e);
            throw new EventException("Error deleting booking approval: " + e.getMessage());
        }
    }

    @Override
    public boolean update(BookingApproval entry) throws EventException, NotFoundException {
        try {
            validateBookingApproval(entry);
            BookingApproval approval = bookingApprovalRepository.findById(entry.getApprovalId());
            if (approval == null) {
                throw new NotFoundException("Booking approval not found with ID: " + entry.getApprovalId());
            }
            return bookingApprovalRepository.update(entry);
        } catch (InvalidDataException e) {
            LOGGER.log(Level.SEVERE, "Invalid booking approval data", e);
            throw new EventException("Invalid booking approval data: " + e.getMessage());
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating booking approval", e);
            throw new EventException("Error updating booking approval: " + e.getMessage());
        }
    }

    @Override
    public BookingApproval findById(UUID id) throws NotFoundException {
        try {
            BookingApproval approval = bookingApprovalRepository.findById(id);
            if (approval == null) {
                throw new NotFoundException("Booking approval not found with ID: " + id);
            }
            return approval;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding booking approval", e);
            throw new NotFoundException("Error finding booking approval: " + e.getMessage());
        }
    }

    @Override
    public List<BookingApproval> findByStatus(String status) throws EventException {
        try {
            return bookingApprovalRepository.findByStatus(status);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding booking approvals by status", e);
            throw new EventException("Error finding booking approvals by status: " + e.getMessage());
        }
    }

    @Override
    public BookingApproval findByBookingId(UUID bookingId) throws EventException {
        try {
            return bookingApprovalRepository.findByBookingId(bookingId);
        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error finding booking approval by booking ID", e);
            throw new EventException("Error finding booking approval by booking ID: " + e.getMessage());
        }
    }

    private void validateBookingApproval(BookingApproval approval) throws InvalidDataException {
        if (approval == null) {
            throw new InvalidDataException("BookingApproval cannot be null");
        }
        if (approval.getBookingId() == null) {
            throw new InvalidDataException("BookingId is required");
        }
        if (approval.getStaffId() == null) {
            throw new InvalidDataException("StaffId is required");
        }
        if (approval.getApprovalStatus() == null || approval.getApprovalStatus().isEmpty()) {
            throw new InvalidDataException("ApprovalStatus is required");
        }
    }
}
