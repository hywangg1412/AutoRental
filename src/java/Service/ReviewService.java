package Service;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Review;
import Service.Interfaces.IReviewService;
import java.util.UUID;
import java.util.function.Predicate;

public class ReviewService implements IReviewService{

    @Override
    public void display() throws EmptyDataException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Review add(Review entry) throws EventException, InvalidDataException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean update(Review entry) throws EventException, NotFoundException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public Review findById(UUID id) throws NotFoundException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
