package Service;

import Exception.EmptyDataException;
import Exception.EventException;
import Exception.InvalidDataException;
import Exception.NotFoundException;
import Model.Entity.Contract;
import Service.Interfaces.IContractService;
import java.util.UUID;
import java.util.function.Predicate;

public class ContractService implements IContractService {

    @Override
    public void display() throws EmptyDataException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public Contract add(Contract entry) throws EventException, InvalidDataException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean delete(UUID id) throws EventException, NotFoundException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean update(Contract entry) throws EventException, NotFoundException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public Contract findById(UUID id) throws NotFoundException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
