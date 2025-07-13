package Service;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Payment;
import Service.Interfaces.IPaymentService;
import java.util.UUID;
import java.util.function.Predicate;

public class PaymentService implements IPaymentService{

    @Override
    public void display() throws EmptyDataException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Payment add(Payment entry) throws EventException, InvalidDataException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean update(Payment entry) throws EventException, NotFoundException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public Payment findById(UUID id) throws NotFoundException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
