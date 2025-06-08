package Service;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Discount;
import Service.Interfaces.IDiscountService;
import java.util.UUID;
import java.util.function.Predicate;

public class DiscountService implements IDiscountService{

    @Override
    public void display() throws EmptyDataException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Discount add(Discount entry) throws EventException, InvalidDataException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean update(Discount entry) throws EventException, NotFoundException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public Discount findById(UUID id) throws NotFoundException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
