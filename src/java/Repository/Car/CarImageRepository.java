package Repository.Car;

import Config.DBContext;
import Model.Entity.Car.CarImage;
import Repository.Interfaces.ICar.ICarImageRepository;

import java.sql.*;
import java.util.*;

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

    private CarImage map(ResultSet rs) throws SQLException {
        CarImage image = new CarImage();
        image.setImageId(UUID.fromString(rs.getString("ImageId")));
        image.setCarId(UUID.fromString(rs.getString("CarId")));
        image.setImageUrl(rs.getString("ImageUrl"));
        image.setIsMain(rs.getBoolean("IsMain"));
        return image;
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

}
