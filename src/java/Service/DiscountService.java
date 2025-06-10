package Service;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Discount;
import Repository.DiscountRepository;
import Service.Interfaces.IDiscountService;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DiscountService implements IDiscountService{
    private DiscountRepository repository;
    
    public DiscountService(){
        repository = new DiscountRepository();
    }
  
    @Override
    public void display() throws EmptyDataException {
        try {
            List<Discount> discounts = repository.findAll();
            if (discounts.isEmpty()) {
                throw new EmptyDataException("No discounts found");
            }
            for (Discount d : discounts) {
                System.out.println(d);
            }
        } catch (SQLException e) {
            throw new EmptyDataException("Error displaying discounts: " + e.getMessage());
        }
    }

    @Override
    public Discount add(Discount entry) throws EventException, InvalidDataException {
        try {
            validateDiscount(entry);
            return repository.add(entry);
        } catch (SQLException e) {
            throw new EventException("Error adding discount: " + e.getMessage());
        } catch (InvalidDataException ex) {
            Logger.getLogger(DiscountService.class.getName()).log(Level.SEVERE, null, ex);
            return null;
        }
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        try {
            Discount discount = repository.findById(id);
            if (discount == null) {
                throw new NotFoundException("Discount not found with ID: " + id);
            }
            return repository.delete(id);
        } catch (SQLException e) {
            throw new EventException("Error deleting discount: " + e.getMessage());
        }
    }

    @Override
    public boolean update(Discount entry) throws EventException, NotFoundException {
        try {
            validateDiscount(entry);
            Discount existingDiscount = repository.findById(entry.getDiscountId());
            if (existingDiscount == null) {
                throw new NotFoundException("Discount not found with ID: " + entry.getDiscountId());
            }
            return repository.update(entry);
        } catch (SQLException e) {
            throw new EventException("Error updating discount: " + e.getMessage());
        } catch (InvalidDataException ex) {
            Logger.getLogger(DiscountService.class.getName()).log(Level.SEVERE, null, ex);
            return false;
        }
    }

    @Override
    public Discount findById(UUID id) throws NotFoundException {
        try {
            Discount discount = repository.findById(id);
            if (discount == null) {
                throw new NotFoundException("Discount not found with ID: " + id);
            }
            return discount;
        } catch (SQLException e) {
            Logger.getLogger(DiscountService.class.getName()).log(Level.SEVERE, "Error finding discount: " + e.getMessage(), e);
            return null;
        }
    }
    
      private void validateDiscount(Discount discount) throws InvalidDataException {
        if (discount == null) {
            throw new InvalidDataException("Discount cannot be null");
        }
        if (discount.getDiscountName() == null || discount.getDiscountName().trim().isEmpty()) {
            throw new InvalidDataException("Discount name cannot be empty");
        }
        if (discount.getDiscountType() == null ||
            (!discount.getDiscountType().equals("Percent") && !discount.getDiscountType().equals("Fixed"))) {
            throw new InvalidDataException("Discount type must be 'Percent' or 'Fixed'");
        }
        if (discount.getDiscountType().equals("Percent")) {
            if (discount.getDiscountValue().compareTo(java.math.BigDecimal.ZERO) < 0 ||
                discount.getDiscountValue().compareTo(new java.math.BigDecimal("100")) > 0) {
                throw new InvalidDataException("Percent discount value must be between 0 and 100");
            }
        } else if (discount.getDiscountType().equals("Fixed")) {
            if (discount.getDiscountValue().compareTo(java.math.BigDecimal.ZERO) < 0) {
                throw new InvalidDataException("Fixed discount value must be >= 0");
            }
        }
        if (discount.getEndDate().isBefore(discount.getStartDate())) {
            throw new InvalidDataException("End date must be after or equal to start date");
        }
    }
}
