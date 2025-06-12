package Repository.Car;

import Config.DBContext;
import Model.Entity.Car.Car;
import Model.Entity.Car.Car.CarStatus;
import Repository.Interfaces.ICar.ICarRepository;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

public class CarRepository implements ICarRepository {

    private DBContext dbContext;

    public CarRepository() {
        dbContext = new DBContext();
    }

    private Car mapResultSetToCar(ResultSet rs) throws SQLException {
        Car car = new Car();
        car.setCarId(UUID.fromString(rs.getString("CarId")));
        car.setBrandId(UUID.fromString(rs.getString("BrandId")));
        car.setCarModel(rs.getString("CarModel"));
        car.setYearManufactured(rs.getInt("YearManufactured"));
        car.setTransmissionTypeId(UUID.fromString(rs.getString("TransmissionTypeId")));
        car.setFuelTypeId(UUID.fromString(rs.getString("FuelTypeId")));
        car.setLicensePlate(rs.getString("LicensePlate"));
        car.setSeats(rs.getInt("Seats"));
        car.setOdometer(rs.getInt("Odometer"));
        car.setPricePerHour(rs.getBigDecimal("PricePerHour"));
        car.setPricePerDay(rs.getBigDecimal("PricePerDay"));
        car.setPricePerMonth(rs.getBigDecimal("PricePerMonth"));
        car.setStatus(Car.CarStatus.fromDbValue(rs.getString("Status")));
        car.setDescription(rs.getString("Description"));
        car.setCreatedDate(rs.getTimestamp("CreatedDate"));
        
        String categoryId = rs.getString("CategoryId");
        car.setCategoryId(categoryId != null ? UUID.fromString(categoryId) : null);
        
        String lastUpdatedBy = rs.getString("LastUpdatedBy");
        car.setLastUpdatedBy(lastUpdatedBy != null ? UUID.fromString(lastUpdatedBy) : null);

        // Lấy features
        car.setFeatureIds(getCarFeatures(car.getCarId()));
        
        return car;
    }

    @Override
    public Car add(Car entity) throws SQLException {
        String sql = "INSERT INTO Car (CarId, BrandId, CarModel, YearManufactured, TransmissionTypeId, " +
                    "FuelTypeId, LicensePlate, Seats, Odometer, PricePerHour, PricePerDay, PricePerMonth, " +
                    "Status, Description, CreatedDate, CategoryId, LastUpdatedBy) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (var conn = dbContext.getConnection(); var ps = conn.prepareStatement(sql)) {
            ps.setString(1, entity.getCarId().toString());
            ps.setString(2, entity.getBrandId().toString());
            ps.setString(3, entity.getCarModel());
            ps.setInt(4, entity.getYearManufactured());
            ps.setString(5, entity.getTransmissionTypeId().toString());
            ps.setString(6, entity.getFuelTypeId().toString());
            ps.setString(7, entity.getLicensePlate());
            ps.setInt(8, entity.getSeats());
            ps.setInt(9, entity.getOdometer());
            ps.setBigDecimal(10, entity.getPricePerHour());
            ps.setBigDecimal(11, entity.getPricePerDay());
            ps.setBigDecimal(12, entity.getPricePerMonth());
            ps.setString(13, entity.getStatus().getValue());
            ps.setString(14, entity.getDescription());
            ps.setTimestamp(15, new java.sql.Timestamp(entity.getCreatedDate().getTime()));
            ps.setString(16, entity.getCategoryId() != null ? entity.getCategoryId().toString() : null);
            ps.setString(17, entity.getLastUpdatedBy() != null ? entity.getLastUpdatedBy().toString() : null);
            
            ps.executeUpdate();
            
            if (!entity.getFeatureIds().isEmpty()) {
                addCarFeatures(entity.getCarId(), entity.getFeatureIds());
            }
            
            return entity;
        }
    }

    @Override
    public Car findById(UUID Id) throws SQLException {
        String sql = "SELECT * FROM Car WHERE CarId = ?";
        try (var conn = dbContext.getConnection(); var ps = conn.prepareStatement(sql)) {
            ps.setString(1, Id.toString());
            try (var rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCar(rs);
                }
            }
        }
        return null;
    }

    @Override
    public boolean update(Car entity) throws SQLException {
        String sql = "UPDATE Car SET BrandId = ?, CarModel = ?, YearManufactured = ?, " +
                    "TransmissionTypeId = ?, FuelTypeId = ?, LicensePlate = ?, Seats = ?, " +
                    "Odometer = ?, PricePerHour = ?, PricePerDay = ?, PricePerMonth = ?, " +
                    "Status = ?, Description = ?, CategoryId = ?, LastUpdatedBy = ? " +
                    "WHERE CarId = ?";
        
        try (var conn = dbContext.getConnection(); var ps = conn.prepareStatement(sql)) {
            ps.setString(1, entity.getBrandId().toString());
            ps.setString(2, entity.getCarModel());
            ps.setInt(3, entity.getYearManufactured());
            ps.setString(4, entity.getTransmissionTypeId().toString());
            ps.setString(5, entity.getFuelTypeId().toString());
            ps.setString(6, entity.getLicensePlate());
            ps.setInt(7, entity.getSeats());
            ps.setInt(8, entity.getOdometer());
            ps.setBigDecimal(9, entity.getPricePerHour());
            ps.setBigDecimal(10, entity.getPricePerDay());
            ps.setBigDecimal(11, entity.getPricePerMonth());
            ps.setString(12, entity.getStatus().getValue());
            ps.setString(13, entity.getDescription());
            ps.setString(14, entity.getCategoryId() != null ? entity.getCategoryId().toString() : null);
            ps.setString(15, entity.getLastUpdatedBy() != null ? entity.getLastUpdatedBy().toString() : null);
            ps.setString(16, entity.getCarId().toString());
            
            int result = ps.executeUpdate();
            
            if (result > 0) {
                updateCarFeatures(entity.getCarId(), entity.getFeatureIds());
            }
            
            return result > 0;
        }
    }

    @Override
    public boolean delete(UUID Id) throws SQLException {
        String sql = "DELETE FROM Car WHERE CarId = ?";
        try (var conn = dbContext.getConnection(); var ps = conn.prepareStatement(sql)) {
            ps.setString(1, Id.toString());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<Car> findAll() throws SQLException {
        String sql = "SELECT * FROM Car";
        List<Car> cars = new ArrayList<>();
        
        try (var conn = dbContext.getConnection(); 
             var ps = conn.prepareStatement(sql);
             var rs = ps.executeQuery()) {
            
            while (rs.next()) {
                cars.add(mapResultSetToCar(rs));
            }
        }
        return cars;
    }

    // Phương thức hỗ trợ cho việc quản lý features
    private void addCarFeatures(UUID carId, Set<UUID> featureIds) throws SQLException {
        String sql = "INSERT INTO CarFeaturesMapping (CarId, FeatureId) VALUES (?, ?)";
        try (var conn = dbContext.getConnection(); var ps = conn.prepareStatement(sql)) {
            for (UUID featureId : featureIds) {
                ps.setString(1, carId.toString());
                ps.setString(2, featureId.toString());
                ps.addBatch();
            }
            ps.executeBatch();
        }
    }

    private Set<UUID> getCarFeatures(UUID carId) throws SQLException {
        String sql = "SELECT FeatureId FROM CarFeaturesMapping WHERE CarId = ?";
        Set<UUID> features = new HashSet<>();
        
        try (var conn = dbContext.getConnection(); var ps = conn.prepareStatement(sql)) {
            ps.setString(1, carId.toString());
            try (var rs = ps.executeQuery()) {
                while (rs.next()) {
                    features.add(UUID.fromString(rs.getString("FeatureId")));
                }
            }
        }
        return features;
    }

    private void updateCarFeatures(UUID carId, Set<UUID> newFeatureIds) throws SQLException {
        // Xóa tất cả features cũ
        String deleteSql = "DELETE FROM CarFeaturesMapping WHERE CarId = ?";
        try (var conn = dbContext.getConnection(); var ps = conn.prepareStatement(deleteSql)) {
            ps.setString(1, carId.toString());
            ps.executeUpdate();
        }
        
        // Thêm features mới
        if (!newFeatureIds.isEmpty()) {
            addCarFeatures(carId, newFeatureIds);
        }
    }
}
