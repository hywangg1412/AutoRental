package Service;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Car;
import Service.Interfaces.ICarService;
import java.util.UUID;
import java.util.function.Predicate;

public class CarService implements ICarService{

    @Override
    public void display() throws EmptyDataException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Car add(Car entry) throws EventException, InvalidDataException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean update(Car entry) throws EventException, NotFoundException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public Car findById(UUID id) throws NotFoundException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
