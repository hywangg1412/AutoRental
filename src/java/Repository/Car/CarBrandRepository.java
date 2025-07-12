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
    public List<CarBrand> findAll() {
        List<CarBrand> list = new ArrayList<>();
        String sql = "SELECT * FROM CarBrand";
        try (var conn = new DBContext().getConnection();
             var ps = conn.prepareStatement(sql);
             var rs = ps.executeQuery()) {
            while (rs.next()) {
                CarBrand brand = new CarBrand();
                brand.setBrandId(UUID.fromString(rs.getString("BrandId")));
                brand.setBrandName(rs.getString("BrandName"));
                list.add(brand);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<CarBrand> findByIds(List<UUID> ids) throws SQLException {
        List<CarBrand> list = new ArrayList<>();
        if (ids == null || ids.isEmpty()) return list;
        StringBuilder sql = new StringBuilder("SELECT * FROM CarBrand WHERE BrandId IN (");
        sql.append(String.join(",", java.util.Collections.nCopies(ids.size(), "?"))).append(")");
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < ids.size(); i++) {
                ps.setObject(i + 1, ids.get(i));
            }
            try (var rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToCarBrand(rs));
                }
            }
        }
        return list;
    }

    private CarBrand mapResultSetToCarBrand(ResultSet rs) throws SQLException {
        CarBrand brand = new CarBrand();
        brand.setBrandId(UUID.fromString(rs.getString("BrandId")));
        brand.setBrandName(rs.getString("BrandName"));
        return brand;
    }
}
