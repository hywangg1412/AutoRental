package Repository.Car;

import Config.DBContext;
import Model.Entity.Car.FuelType;
import Repository.Interfaces.ICar.IFuelTypeRepository;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class FuelTypeRepository implements IFuelTypeRepository{
    private DBContext dbContext;

    public FuelTypeRepository() {
        dbContext = new DBContext();
    }

    @Override
    public FuelType add(FuelType entity) throws SQLException {
        String sql = "INSERT INTO FuelType (FuelTypeId, FuelName) VALUES (?, ?)";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getFuelTypeId());
            ps.setString(2, entity.getFuelName());
            ps.executeUpdate();
            return entity;
        }
    }

    @Override
    public FuelType findById(UUID Id) throws SQLException {
        String sql = "SELECT * FROM FuelType WHERE FuelTypeId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, Id);
            var rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToFuelType(rs);
            }
            return null;
        }
    }

    @Override
    public boolean update(FuelType entity) throws SQLException {
        String sql = "UPDATE FuelType SET FuelName = ? WHERE FuelTypeId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setString(1, entity.getFuelName());
            ps.setObject(2, entity.getFuelTypeId());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(UUID Id) throws SQLException {
        String sql = "DELETE FROM FuelType WHERE FuelTypeId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, Id);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<FuelType> findAll() throws SQLException {
        String sql = "SELECT * FROM FuelType";
        List<FuelType> fuelTypes = new ArrayList<>();
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql);
             var rs = ps.executeQuery()) {
            while (rs.next()) {
                fuelTypes.add(mapResultSetToFuelType(rs));
            }
        }
        return fuelTypes;
    }

    private FuelType mapResultSetToFuelType(ResultSet rs) throws SQLException {
        FuelType fuelType = new FuelType();
        fuelType.setFuelTypeId(UUID.fromString(rs.getString("FuelTypeId")));
        fuelType.setFuelName(rs.getString("FuelName"));
        return fuelType;
    }
}
