package Service.Interfaces;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import java.util.UUID;
import java.util.function.Predicate;

public interface Service<T> {
    void display() throws EmptyDataException;
    
    void add(T entry) throws EventException, InvalidDataException;
    
    void delete(UUID id) throws EventException, NotFoundException;
    
    void update(T entry) throws EventException, NotFoundException;
    
    T search(Predicate<T> p) throws NotFoundException;
    
    T findById(UUID id) throws NotFoundException;
}
