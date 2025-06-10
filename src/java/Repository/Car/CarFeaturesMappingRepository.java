package Repository.Car;

import Config.DBContext;
import Model.Entity.Car.CarFeaturesMapping;
import Repository.Interfaces.Icar.ICarFeaturesMappingRepository;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class CarFeaturesMappingRepository implements ICarFeaturesMappingRepository{
    private DBContext dbContext;

    public CarFeaturesMappingRepository() {
        dbContext = new DBContext();
    }

    @Override
    public CarFeaturesMapping add(CarFeaturesMapping entity) throws SQLException {
        String sql = "INSERT INTO CarFeaturesMapping (CarId, FeatureId) VALUES (?, ?)";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getCarId());
            ps.setObject(2, entity.getFeatureId());
            ps.executeUpdate();
            return entity;
        }
    }

    @Override
    public CarFeaturesMapping findById(UUID Id) throws SQLException {
        String sql = "SELECT * FROM CarFeaturesMapping WHERE CarId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, Id);
            var rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToCarFeaturesMapping(rs);
            }
            return null;
        }
    }

    @Override
    public boolean update(CarFeaturesMapping entity) throws SQLException {
        String sql = "UPDATE CarFeaturesMapping SET FeatureId = ? WHERE CarId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getFeatureId());
            ps.setObject(2, entity.getCarId());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(UUID Id) throws SQLException {
        String sql = "DELETE FROM CarFeaturesMapping WHERE CarId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, Id);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<CarFeaturesMapping> findAll() throws SQLException {
        String sql = "SELECT * FROM CarFeaturesMapping";
        List<CarFeaturesMapping> mappings = new ArrayList<>();
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql);
             var rs = ps.executeQuery()) {
            while (rs.next()) {
                mappings.add(mapResultSetToCarFeaturesMapping(rs));
            }
        }
        return mappings;
    }

    private CarFeaturesMapping mapResultSetToCarFeaturesMapping(ResultSet rs) throws SQLException {
        CarFeaturesMapping mapping = new CarFeaturesMapping();
        mapping.setCarId(UUID.fromString(rs.getString("CarId")));
        mapping.setFeatureId(UUID.fromString(rs.getString("FeatureId")));
        return mapping;
    }
}
