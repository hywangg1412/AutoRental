package Repository.Car;

import Config.DBContext;
import Model.Entity.Car.CarCategories;
import Repository.Interfaces.ICar.ICarCategoriesRepository;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class CarCategoriesRepository implements ICarCategoriesRepository{
    private DBContext dbContext;

    public CarCategoriesRepository() {
        dbContext = new DBContext();
    }

    @Override
    public CarCategories add(CarCategories entity) throws SQLException {
        String sql = "INSERT INTO CarCategories (CategoryId, CategoryName) VALUES (?, ?)";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getCategoryId());
            ps.setString(2, entity.getCategoryName());
            ps.executeUpdate();
            return entity;
        }
    }

    @Override
    public CarCategories findById(UUID Id) throws SQLException {
        String sql = "SELECT * FROM CarCategories WHERE CategoryId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, Id);
            var rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToCarCategories(rs);
            }
            return null;
        }
    }

    @Override
    public boolean update(CarCategories entity) throws SQLException {
        String sql = "UPDATE CarCategories SET CategoryName = ? WHERE CategoryId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setString(1, entity.getCategoryName());
            ps.setObject(2, entity.getCategoryId());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(UUID Id) throws SQLException {
        String sql = "DELETE FROM CarCategories WHERE CategoryId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, Id);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<CarCategories> findAll() throws SQLException {
        String sql = "SELECT * FROM CarCategories";
        List<CarCategories> categories = new ArrayList<>();
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql);
             var rs = ps.executeQuery()) {
            while (rs.next()) {
                categories.add(mapResultSetToCarCategories(rs));
            }
        }
        return categories;
    }

    private CarCategories mapResultSetToCarCategories(ResultSet rs) throws SQLException {
        CarCategories category = new CarCategories();
        category.setCategoryId(UUID.fromString(rs.getString("CategoryId")));
        category.setCategoryName(rs.getString("CategoryName"));
        return category;
    }
}
