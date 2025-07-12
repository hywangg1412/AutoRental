package Repository.Car;

import Config.DBContext;
import Model.Entity.Car.CarImage;
import Repository.Interfaces.ICar.ICarImageRepository;

import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.HashMap;

public class CarImageRepository implements ICarImageRepository {

    private final DBContext dbContext = new DBContext();

    @Override
    public CarImage add(CarImage entity) throws SQLException {
        String sql = "INSERT INTO CarImages (ImageId, CarId, ImageUrl, IsMain) VALUES (?, ?, ?, ?)";
        try (var conn = dbContext.getConnection(); var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getImageId());
            ps.setObject(2, entity.getCarId());
            ps.setString(3, entity.getImageUrl());
            ps.setBoolean(4, entity.isMain());
            ps.executeUpdate();
            return entity;
        }
    }

    @Override
    public CarImage findById(UUID id) throws SQLException {
        String sql = "SELECT * FROM CarImages WHERE ImageId = ?";
        try (var conn = dbContext.getConnection(); var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    @Override
    public boolean update(CarImage entity) throws SQLException {
        String sql = "UPDATE CarImages SET CarId = ?, ImageUrl = ?, IsMain = ? WHERE ImageId = ?";
        try (var conn = dbContext.getConnection(); var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getCarId());
            ps.setString(2, entity.getImageUrl());
            ps.setBoolean(3, entity.isMain());
            ps.setObject(4, entity.getImageId());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(UUID id) throws SQLException {
        String sql = "DELETE FROM CarImages WHERE ImageId = ?";
        try (var conn = dbContext.getConnection(); var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, id);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<CarImage> findAll() throws SQLException {
        String sql = "SELECT * FROM CarImages";
        List<CarImage> list = new ArrayList<>();
        try (var conn = dbContext.getConnection(); var ps = conn.prepareStatement(sql); var rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    @Override
    public CarImage findMainImageByCarId(UUID carId) throws SQLException {
        String sql = "SELECT TOP 1 * FROM CarImages WHERE CarId = ? AND IsMain = 1";
        try (var conn = dbContext.getConnection(); var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, carId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return map(rs);
                }
            }
        }
        return null;
    }

    @Override
    public List<CarImage> findByCarId(UUID carId) throws SQLException {
        String sql = "SELECT * FROM CarImages WHERE CarId = ?";
        List<CarImage> images = new ArrayList<>();
        try (var conn = dbContext.getConnection(); var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, carId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    images.add(map(rs));
                }
            }
        }
        return images;
    }

    public Map<UUID, CarImage> findMainImagesByCarIds(List<UUID> carIds) throws SQLException {
        Map<UUID, CarImage> map = new HashMap<>();
        if (carIds == null || carIds.isEmpty()) {
            return map;
        }
        StringBuilder sql = new StringBuilder("SELECT * FROM CarImages WHERE CarId IN (");
        sql.append(String.join(",", Collections.nCopies(carIds.size(), "?"))).append(") AND IsMain = 1");
        try (var conn = dbContext.getConnection(); var ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < carIds.size(); i++) {
                ps.setObject(i + 1, carIds.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CarImage image = map(rs);
                    map.put(image.getCarId(), image);
                }
            }
        }
        return map;
    }

    private CarImage map(ResultSet rs) throws SQLException {
        CarImage image = new CarImage();
        image.setImageId(UUID.fromString(rs.getString("ImageId")));
        image.setCarId(UUID.fromString(rs.getString("CarId")));
        image.setImageUrl(rs.getString("ImageUrl"));
        image.setIsMain(rs.getBoolean("IsMain"));
        return image;
    }
}
