package Repository.Interfaces.ICar;

import Model.Entity.Car.CarConditionLogs;
import Repository.Interfaces.Repository;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

public interface ICarConditionLogsRepository extends Repository<CarConditionLogs, UUID> {
    List<CarConditionLogs> findByBookingId(UUID bookingId) throws SQLException;
    List<CarConditionLogs> findByCarId(UUID carId) throws SQLException;
    List<CarConditionLogs> findRecentInspections(int limit) throws SQLException;
    List<CarConditionLogs> findPendingInspections() throws SQLException;
    boolean updateConditionStatus(UUID logId, String status) throws SQLException;
} 