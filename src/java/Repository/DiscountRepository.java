package Repository;

import Model.Entity.Discount;
import Repository.Interfaces.IDiscountRepository;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public class DiscountRepository implements IDiscountRepository{

    @Override
    public Discount add(Discount entity) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public Discount findById(UUID Id) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public boolean update(Discount entity) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public boolean delete(UUID Id) throws SQLException {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    @Override
    public List<Discount> findAll() throws SQLException {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
