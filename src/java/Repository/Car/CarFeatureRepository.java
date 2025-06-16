package Repository.Car;

import Config.DBContext;
import Model.Entity.Car.CarFeature;
import Repository.Interfaces.ICar.ICarFeatureRepository;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class CarFeatureRepository implements ICarFeatureRepository{
    private DBContext dbContext;

    public CarFeatureRepository() {
        dbContext = new DBContext();
    }

    @Override
    public CarFeature add(CarFeature entity) throws SQLException {
        String sql = "INSERT INTO CarFeature (FeatureId, FeatureName) VALUES (?, ?)";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getFeatureId());
            ps.setString(2, entity.getFetureName());
            ps.executeUpdate();
            return entity;
        }
    }

    @Override
    public CarFeature findById(UUID Id) throws SQLException {
        String sql = "SELECT * FROM CarFeature WHERE FeatureId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, Id);
            var rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToCarFeature(rs);
            }
            return null;
        }
    }

    @Override
    public boolean update(CarFeature entity) throws SQLException {
        String sql = "UPDATE CarFeature SET FeatureName = ? WHERE FeatureId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setString(1, entity.getFetureName());
            ps.setObject(2, entity.getFeatureId());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(UUID Id) throws SQLException {
        String sql = "DELETE FROM CarFeature WHERE FeatureId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, Id);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<CarFeature> findAll() throws SQLException {
        String sql = "SELECT * FROM CarFeature";
        List<CarFeature> features = new ArrayList<>();
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql);
             var rs = ps.executeQuery()) {
            while (rs.next()) {
                features.add(mapResultSetToCarFeature(rs));
            }
        }
        return features;
    }

    public List<CarFeature> findByCarId(UUID carId) throws SQLException {
        String sql = "SELECT f.FeatureId, f.FeatureName FROM CarFeaturesMapping m JOIN CarFeature f ON m.FeatureId = f.FeatureId WHERE m.CarId = ?";
        List<CarFeature> features = new ArrayList<>();
        try (var conn = dbContext.getConnection(); var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, carId);
            try (var rs = ps.executeQuery()) {
                while (rs.next()) {
                    features.add(mapResultSetToCarFeature(rs));
                }
            }
        }
        return features;
    }

    private CarFeature mapResultSetToCarFeature(ResultSet rs) throws SQLException {
        CarFeature feature = new CarFeature();
        feature.setFeatureId(UUID.fromString(rs.getString("FeatureId")));
        feature.setFetureName(rs.getString("FeatureName"));
        return feature;
    }
}