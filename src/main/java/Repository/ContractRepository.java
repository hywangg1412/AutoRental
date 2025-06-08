package Repository;

import Model.Entity.Contract;
import Repository.Interfaces.IContractRepository;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public class ContractRepository implements IContractRepository{

    @Override
    public Contract add(Contract entity) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public Contract findById(UUID Id) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean update(Contract entity) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean delete(UUID Id) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public List<Contract> findAll() throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    
}
