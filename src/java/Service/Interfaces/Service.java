package Service.Interfaces;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import java.util.UUID;
import java.util.function.Predicate;

public interface Service<T> {
    void display() throws EmptyDataException, EventException;
    
    T add(T entry) throws EventException, InvalidDataException;
    
    boolean delete(UUID id) throws EventException, NotFoundException;
    
    boolean update(T entry) throws EventException, NotFoundException;
    
    T findById(UUID id) throws NotFoundException;
}
