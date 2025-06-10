package Repository.Car;

import Config.DBContext;
import Model.Entity.Car.TransmissionType;
import Repository.Interfaces.Icar.ITransmissionTypeRepository;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class TranmissionTypeRepository implements ITransmissionTypeRepository{
    private DBContext dbContext;

    public TranmissionTypeRepository() {
        dbContext = new DBContext();
    }
    
    @Override
    public TransmissionType add(TransmissionType entity) throws SQLException {
        String sql = "INSERT INTO TransmissionType (TransmissionTypeId, TransmissionName) VALUES (?, ?)";
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getTranmissionTypeId());
            ps.setString(2, entity.getTranmissionName());
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
            ps.setString(1, entity.getTranmissionName());
            ps.setObject(2, entity.getTranmissionTypeId());
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
    public List<TransmissionType> findAll() throws SQLException {
        String sql = "SELECT * FROM TransmissionType";
        List<TransmissionType> transmissionTypes = new ArrayList<>();
        try (var conn = dbContext.getConnection();
             var ps = conn.prepareStatement(sql);
             var rs = ps.executeQuery()) {
            while (rs.next()) {
                transmissionTypes.add(mapResultSetToTransmissionType(rs));
            }
        }
        return transmissionTypes;
    }

    private TransmissionType mapResultSetToTransmissionType(ResultSet rs) throws SQLException {
        TransmissionType transmissionType = new TransmissionType();
        transmissionType.setTranmissionTypeId(UUID.fromString(rs.getString("TransmissionTypeId")));
        transmissionType.setTranmissionName(rs.getString("TransmissionName"));
        return transmissionType;
    }
}
