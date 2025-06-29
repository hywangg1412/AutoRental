package Repository.Car;

import Config.DBContext;
import Model.Entity.Car.Car;
import Model.Entity.Car.Car.CarStatus;
import Repository.Interfaces.ICar.ICarRepository;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
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

    public List<Car> findByPage(int offset, int limit) throws SQLException {
        String sql = "SELECT * FROM Car ORDER BY CreatedDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        List<Car> cars = new ArrayList<>();
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (var rs = ps.executeQuery()) {
                while (rs.next()) {
                    cars.add(mapResultSetToCar(rs));
                }
            }
        }
        return cars;
    }

    public int countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM Car";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql);
             var rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    @Override
    public List<Car> searchByKeyword(String keyword, int offset, int limit) throws SQLException {
        List<Car> cars = new ArrayList<>();
        String sql = "SELECT * FROM Car WHERE CarModel LIKE ? OR BrandId IN (SELECT BrandId FROM CarBrand WHERE BrandName LIKE ?) ORDER BY CreatedDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            ps.setInt(3, offset);
            ps.setInt(4, limit);
            try (var rs = ps.executeQuery()) {
                while (rs.next()) {
                    cars.add(mapResultSetToCar(rs));
                }
            }
        }
        return cars;
    }

    @Override
    public int countByKeyword(String keyword) throws SQLException {
        String sql = "SELECT COUNT(*) FROM Car WHERE CarModel LIKE ? OR BrandId IN (SELECT BrandId FROM CarBrand WHERE BrandName LIKE ?)";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setString(1, "%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");
            try (var rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    @Override
    public List<Car> filterCars(
        String[] brandIds, String[] fuelTypeIds, String[] seats, String[] categoryIds,
        String[] statuses, String[] featureIds, String[] transmissionTypeIds, String sort, String keyword,
        Integer minPricePerHour, Integer maxPricePerHour,
        Integer minSeats, Integer maxSeats,
        Integer minYear, Integer maxYear,
        Integer minOdometer, Integer maxOdometer,
        Integer minDistance, Integer maxDistance,
        int offset, int limit
    ) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT DISTINCT c.* FROM Car c ");
        List<Object> params = new ArrayList<>();
        if (featureIds != null && featureIds.length > 0) {
            sql.append("JOIN CarFeaturesMapping fm ON c.CarId = fm.CarId ");
        }
        sql.append("WHERE 1=1 ");
        
        // Existing filters
        if (brandIds != null && brandIds.length > 0) {
            sql.append("AND c.BrandId IN (").append(String.join(",", Collections.nCopies(brandIds.length, "?"))).append(") ");
            Collections.addAll(params, brandIds);
        }
        if (fuelTypeIds != null && fuelTypeIds.length > 0) {
            sql.append("AND c.FuelTypeId IN (").append(String.join(",", Collections.nCopies(fuelTypeIds.length, "?"))).append(") ");
            Collections.addAll(params, fuelTypeIds);
        }
        if (transmissionTypeIds != null && transmissionTypeIds.length > 0) {
            sql.append("AND c.TransmissionTypeId IN (").append(String.join(",", Collections.nCopies(transmissionTypeIds.length, "?"))).append(") ");
            Collections.addAll(params, transmissionTypeIds);
        }
        if (seats != null && seats.length > 0) {
            sql.append("AND c.Seats IN (").append(String.join(",", Collections.nCopies(seats.length, "?"))).append(") ");
            for (String s : seats) params.add(Integer.parseInt(s));
        }
        if (categoryIds != null && categoryIds.length > 0) {
            sql.append("AND c.CategoryId IN (").append(String.join(",", Collections.nCopies(categoryIds.length, "?"))).append(") ");
            Collections.addAll(params, categoryIds);
        }
        if (statuses != null && statuses.length > 0) {
            sql.append("AND c.Status IN (").append(String.join(",", Collections.nCopies(statuses.length, "?"))).append(") ");
            Collections.addAll(params, statuses);
        }
        if (featureIds != null && featureIds.length > 0) {
            sql.append("AND fm.FeatureId IN (").append(String.join(",", Collections.nCopies(featureIds.length, "?"))).append(") ");
            Collections.addAll(params, featureIds);
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (c.CarModel LIKE ? OR c.BrandId IN (SELECT BrandId FROM CarBrand WHERE BrandName LIKE ?)) ");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        
        // New range filters
        if (minPricePerHour != null) {
            sql.append("AND c.PricePerHour >= ? ");
            params.add(minPricePerHour);
        }
        if (maxPricePerHour != null) {
            sql.append("AND c.PricePerHour <= ? ");
            params.add(maxPricePerHour);
        }
        if (minSeats != null) {
            sql.append("AND c.Seats >= ? ");
            params.add(minSeats);
        }
        if (maxSeats != null) {
            sql.append("AND c.Seats <= ? ");
            params.add(maxSeats);
        }
        if (minYear != null) {
            sql.append("AND c.YearManufactured >= ? ");
            params.add(minYear);
        }
        if (maxYear != null) {
            sql.append("AND c.YearManufactured <= ? ");
            params.add(maxYear);
        }
        if (minOdometer != null) {
            sql.append("AND c.Odometer >= ? ");
            params.add(minOdometer);
        }
        if (maxOdometer != null) {
            sql.append("AND c.Odometer <= ? ");
            params.add(maxOdometer);
        }
        if (minDistance != null) {
            // Note: This would need location data to implement properly
            // For now, we'll skip this filter or implement it later
            // sql.append("AND distance >= ? ");
            // params.add(minDistance);
        }
        if (maxDistance != null) {
            // Note: This would need location data to implement properly
            // For now, we'll skip this filter or implement it later
            // sql.append("AND distance <= ? ");
            // params.add(maxDistance);
        }
        
        // Sort
        if (sort != null) {
            switch (sort) {
                case "priceAsc": sql.append("ORDER BY c.PricePerHour ASC "); break;
                case "priceDesc": sql.append("ORDER BY c.PricePerHour DESC "); break;
                case "nameAsc": sql.append("ORDER BY c.CarModel ASC "); break;
                case "nameDesc": sql.append("ORDER BY c.CarModel DESC "); break;
                case "yearDesc": sql.append("ORDER BY c.YearManufactured DESC "); break;
                case "yearAsc": sql.append("ORDER BY c.YearManufactured ASC "); break;
                default: sql.append("ORDER BY c.CreatedDate DESC "); break;
            }
        } else {
            sql.append("ORDER BY c.CreatedDate DESC ");
        }
        sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add(offset);
        params.add(limit);

        List<Car> cars = new ArrayList<>();
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (var rs = ps.executeQuery()) {
                while (rs.next()) {
                    cars.add(mapResultSetToCar(rs));
                }
            }
        }
        return cars;
    }

    @Override
    public int countFilteredCars(
        String[] brandIds, String[] fuelTypeIds, String[] seats, String[] categoryIds,
        String[] statuses, String[] featureIds, String[] transmissionTypeIds, String keyword,
        Integer minPrice, Integer maxPrice,
        Integer minSeats, Integer maxSeats,
        Integer minYear, Integer maxYear,
        Integer minOdometer, Integer maxOdometer,
        Integer minDistance, Integer maxDistance
    ) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT COUNT(DISTINCT c.CarId) FROM Car c ");
        List<Object> params = new ArrayList<>();
        if (featureIds != null && featureIds.length > 0) {
            sql.append("JOIN CarFeaturesMapping fm ON c.CarId = fm.CarId ");
        }
        sql.append("WHERE 1=1 ");
        
        // Existing filters
        if (brandIds != null && brandIds.length > 0) {
            sql.append("AND c.BrandId IN (").append(String.join(",", Collections.nCopies(brandIds.length, "?"))).append(") ");
            Collections.addAll(params, brandIds);
        }
        if (fuelTypeIds != null && fuelTypeIds.length > 0) {
            sql.append("AND c.FuelTypeId IN (").append(String.join(",", Collections.nCopies(fuelTypeIds.length, "?"))).append(") ");
            Collections.addAll(params, fuelTypeIds);
        }
        if (transmissionTypeIds != null && transmissionTypeIds.length > 0) {
            sql.append("AND c.TransmissionTypeId IN (").append(String.join(",", Collections.nCopies(transmissionTypeIds.length, "?"))).append(") ");
            Collections.addAll(params, transmissionTypeIds);
        }
        if (seats != null && seats.length > 0) {
            sql.append("AND c.Seats IN (").append(String.join(",", Collections.nCopies(seats.length, "?"))).append(") ");
            for (String s : seats) params.add(Integer.parseInt(s));
        }
        if (categoryIds != null && categoryIds.length > 0) {
            sql.append("AND c.CategoryId IN (").append(String.join(",", Collections.nCopies(categoryIds.length, "?"))).append(") ");
            Collections.addAll(params, categoryIds);
        }
        if (statuses != null && statuses.length > 0) {
            sql.append("AND c.Status IN (").append(String.join(",", Collections.nCopies(statuses.length, "?"))).append(") ");
            Collections.addAll(params, statuses);
        }
        if (featureIds != null && featureIds.length > 0) {
            sql.append("AND fm.FeatureId IN (").append(String.join(",", Collections.nCopies(featureIds.length, "?"))).append(") ");
            Collections.addAll(params, featureIds);
        }
        if (keyword != null && !keyword.isEmpty()) {
            sql.append("AND (c.CarModel LIKE ? OR c.BrandId IN (SELECT BrandId FROM CarBrand WHERE BrandName LIKE ?)) ");
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }
        
        // New range filters
        if (minPrice != null) {
            sql.append("AND c.PricePerHour >= ? ");
            params.add(minPrice);
        }
        if (maxPrice != null) {
            sql.append("AND c.PricePerHour <= ? ");
            params.add(maxPrice);
        }
        if (minSeats != null) {
            sql.append("AND c.Seats >= ? ");
            params.add(minSeats);
        }
        if (maxSeats != null) {
            sql.append("AND c.Seats <= ? ");
            params.add(maxSeats);
        }
        if (minYear != null) {
            sql.append("AND c.YearManufactured >= ? ");
            params.add(minYear);
        }
        if (maxYear != null) {
            sql.append("AND c.YearManufactured <= ? ");
            params.add(maxYear);
        }
        if (minOdometer != null) {
            sql.append("AND c.Odometer >= ? ");
            params.add(minOdometer);
        }
        if (maxOdometer != null) {
            sql.append("AND c.Odometer <= ? ");
            params.add(maxOdometer);
        }
        if (minDistance != null) {
            // Note: This would need location data to implement properly
            // For now, we'll skip this filter or implement it later
            // sql.append("AND distance >= ? ");
            // params.add(minDistance);
        }
        if (maxDistance != null) {
            // Note: This would need location data to implement properly
            // For now, we'll skip this filter or implement it later
            // sql.append("AND distance <= ? ");
            // params.add(maxDistance);
        }
        
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (var rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    public List<Integer> getAllSeatNumbers() {
        List<Integer> seatList = new ArrayList<>();
        String sql = "SELECT DISTINCT Seats FROM Car ORDER BY Seats ASC";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql);
             var rs = ps.executeQuery()) {
            while (rs.next()) {
                seatList.add(rs.getInt("Seats"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return seatList;
    }
}
