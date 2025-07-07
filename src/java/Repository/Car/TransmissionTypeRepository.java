package Repository.Car;

import Config.DBContext;
import Model.Entity.Car.TransmissionType;
import Repository.Interfaces.ICar.ITransmissionTypeRepository;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class TransmissionTypeRepository implements ITransmissionTypeRepository{
    private DBContext dbContext;

    public TransmissionTypeRepository() {
        dbContext = new DBContext();
    }
    
    @Override
    public TransmissionType add(TransmissionType entity) throws SQLException {
        String sql = "INSERT INTO TransmissionType (TransmissionTypeId, TransmissionName) VALUES (?, ?)";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getTransmissionTypeId());
            ps.setString(2, entity.getTransmissionName());
            ps.executeUpdate();
            return entity;
        }
    }

    @Override
    public TransmissionType findById(UUID Id) throws SQLException {
        String sql = "SELECT * FROM TransmissionType WHERE TransmissionTypeId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, Id);
            var rs = ps.executeQuery();
            if (rs.next()) {
                return mapResultSetToTransmissionType(rs);
            }
            return null;
        }
    }

    @Override
    public boolean update(TransmissionType entity) throws SQLException {
        String sql = "UPDATE TransmissionType SET TransmissionName = ? WHERE TransmissionTypeId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setString(1, entity.getTransmissionName());
            ps.setObject(2, entity.getTransmissionTypeId());
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean delete(UUID Id) throws SQLException {
        String sql = "DELETE FROM TransmissionType WHERE TransmissionTypeId = ?";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, Id);
            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public List<TransmissionType> findAll() {
        List<TransmissionType> list = new ArrayList<>();
        String sql = "SELECT * FROM TransmissionType";
        try (var conn = new DBContext().getConnection();
             var ps = conn.prepareStatement(sql);
             var rs = ps.executeQuery()) {
            while (rs.next()) {
                TransmissionType t = new TransmissionType();
                t.setTransmissionTypeId(UUID.fromString(rs.getString("TransmissionTypeId")));
                t.setTransmissionName(rs.getString("TransmissionName"));
                list.add(t);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private TransmissionType mapResultSetToTransmissionType(ResultSet rs) throws SQLException {
        TransmissionType transmissionType = new TransmissionType();
        transmissionType.setTransmissionTypeId(UUID.fromString(rs.getString("TransmissionTypeId")));
        transmissionType.setTransmissionName(rs.getString("TransmissionName"));
        return transmissionType;
    }
}
