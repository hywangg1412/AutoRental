package Repository.Car;

import Config.DBContext;
import Model.Entity.Car.CarBrand;
import Repository.Interfaces.ICar.ICarBrandRepository;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class CarBrandRepository implements ICarBrandRepository{
    private DBContext dbContext;

    public CarBrandRepository() {
        dbContext = new DBContext();
    }

    @Override
    public CarBrand add(CarBrand entity) throws SQLException {
        String sql = "INSERT INTO CarBrand (BrandId, BrandName) VALUES (?, ?)";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getBrandId());
            ps.setString(2, entity.getBrandName());
            ps.executeUpdate();
            return entity;
        }
    }

    @Override
    public CarBrand findById(UUID Id) throws SQLException {
        String sql = "SELECT * FROM CarBrand WHERE BrandId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, Id);
            var rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToCarBrand(rs);
            }
            return null;
        }
    }

    @Override
    public boolean update(CarBrand entity) throws SQLException {
        String sql = "UPDATE CarBrand SET BrandName = ? WHERE BrandId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setString(1, entity.getBrandName());
            ps.setObject(2, entity.getBrandId());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(UUID Id) throws SQLException {
        String sql = "DELETE FROM CarBrand WHERE BrandId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, Id);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<CarBrand> findAll() throws SQLException {
        String sql = "SELECT * FROM CarBrand";
        List<CarBrand> brands = new ArrayList<>();
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql);
             var rs = ps.executeQuery()) {
            while (rs.next()) {
                brands.add(mapResultSetToCarBrand(rs));
            }
        }
        return brands;
    }

    private CarBrand mapResultSetToCarBrand(ResultSet rs) throws SQLException {
        CarBrand brand = new CarBrand();
        brand.setBrandId(UUID.fromString(rs.getString("BrandId")));
        brand.setBrandName(rs.getString("BrandName"));
        return brand;
    }
}
