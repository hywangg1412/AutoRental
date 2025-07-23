package Repository.Car;

import Config.DBContext;
import Model.Entity.Car.CarConditionLogs;
import Repository.Interfaces.ICar.ICarConditionLogsRepository;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

public class CarConditionLogsRepository implements ICarConditionLogsRepository {
    private static final Logger LOGGER = Logger.getLogger(CarConditionLogsRepository.class.getName());
    private final DBContext dbContext;
    
    public CarConditionLogsRepository() {
        this.dbContext = new DBContext();
    }
    
    @Override
    public CarConditionLogs add(CarConditionLogs entity) throws SQLException {
        String sql = "INSERT INTO CarConditionLogs (LogId, BookingId, CarId, StaffId, CheckType, " +
                     "CheckTime, Odometer, FuelLevel, ConditionStatus, ConditionDescription, " +
                     "DamageImages, Note) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, entity.getLogId());
            ps.setObject(2, entity.getBookingId());
            ps.setObject(3, entity.getCarId());
            ps.setObject(4, entity.getStaffId());
            ps.setString(5, entity.getCheckType());
            ps.setTimestamp(6, Timestamp.valueOf(entity.getCheckTime()));
            ps.setInt(7, entity.getOdometer() != null ? entity.getOdometer() : 0);
            ps.setString(8, entity.getFuelLevel());
            ps.setString(9, entity.getConditionStatus());
            ps.setString(10, entity.getConditionDescription());
            ps.setString(11, entity.getDamageImages());
            ps.setString(12, entity.getNote());
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                return entity;
            }
        }
        return null;
    }
    
    @Override
    public CarConditionLogs findById(UUID id) throws SQLException {
        String sql = "SELECT * FROM CarConditionLogs WHERE LogId = ?";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToCarConditionLogs(rs);
                }
            }
        }
        return null;
    }
    
    @Override
    public boolean update(CarConditionLogs entity) throws SQLException {
        String sql = "UPDATE CarConditionLogs SET BookingId = ?, CarId = ?, StaffId = ?, " +
                     "CheckType = ?, CheckTime = ?, Odometer = ?, FuelLevel = ?, " +
                     "ConditionStatus = ?, ConditionDescription = ?, DamageImages = ?, " +
                     "Note = ? WHERE LogId = ?";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, entity.getBookingId());
            ps.setObject(2, entity.getCarId());
            ps.setObject(3, entity.getStaffId());
            ps.setString(4, entity.getCheckType());
            ps.setTimestamp(5, Timestamp.valueOf(entity.getCheckTime()));
            ps.setInt(6, entity.getOdometer() != null ? entity.getOdometer() : 0);
            ps.setString(7, entity.getFuelLevel());
            ps.setString(8, entity.getConditionStatus());
            ps.setString(9, entity.getConditionDescription());
            ps.setString(10, entity.getDamageImages());
            ps.setString(11, entity.getNote());
            ps.setObject(12, entity.getLogId());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    @Override
    public boolean delete(UUID id) throws SQLException {
        String sql = "DELETE FROM CarConditionLogs WHERE LogId = ?";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, id);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    @Override
    public List<CarConditionLogs> findAll() throws SQLException {
        String sql = "SELECT * FROM CarConditionLogs ORDER BY CheckTime DESC";
        List<CarConditionLogs> logsList = new ArrayList<>();
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                logsList.add(mapResultSetToCarConditionLogs(rs));
            }
        }
        return logsList;
    }
    
    @Override
    public List<CarConditionLogs> findByBookingId(UUID bookingId) throws SQLException {
        String sql = "SELECT * FROM CarConditionLogs WHERE BookingId = ? ORDER BY CheckTime DESC";
        List<CarConditionLogs> logsList = new ArrayList<>();
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    logsList.add(mapResultSetToCarConditionLogs(rs));
                }
            }
        }
        return logsList;
    }
    
    @Override
    public List<CarConditionLogs> findByCarId(UUID carId) throws SQLException {
        String sql = "SELECT * FROM CarConditionLogs WHERE CarId = ? ORDER BY CheckTime DESC";
        List<CarConditionLogs> logsList = new ArrayList<>();
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setObject(1, carId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    logsList.add(mapResultSetToCarConditionLogs(rs));
                }
            }
        }
        return logsList;
    }
    
    @Override
    public List<CarConditionLogs> findRecentInspections(int limit) throws SQLException {
        String sql = "SELECT TOP(?) * FROM CarConditionLogs ORDER BY CheckTime DESC";
        List<CarConditionLogs> logsList = new ArrayList<>();
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, limit);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    logsList.add(mapResultSetToCarConditionLogs(rs));
                }
            }
        }
        return logsList;
    }
    
    @Override
    public List<CarConditionLogs> findPendingInspections() throws SQLException {
        // Join with Booking table to get bookings with PendingInspection status
        String sql = "SELECT cl.* FROM CarConditionLogs cl " +
                     "JOIN Booking b ON cl.BookingId = b.BookingId " +
                     "WHERE b.Status = 'PendingInspection' " +
                     "ORDER BY cl.CheckTime DESC";
        
        List<CarConditionLogs> logsList = new ArrayList<>();
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                logsList.add(mapResultSetToCarConditionLogs(rs));
            }
        }
        return logsList;
    }
    
    @Override
    public boolean updateConditionStatus(UUID logId, String status) throws SQLException {
        String sql = "UPDATE CarConditionLogs SET ConditionStatus = ? WHERE LogId = ?";
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setObject(2, logId);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    private CarConditionLogs mapResultSetToCarConditionLogs(ResultSet rs) throws SQLException {
        CarConditionLogs logs = new CarConditionLogs();
        
        logs.setLogId(UUID.fromString(rs.getString("LogId")));
        logs.setBookingId(UUID.fromString(rs.getString("BookingId")));
        logs.setCarId(UUID.fromString(rs.getString("CarId")));
        
        String staffIdStr = rs.getString("StaffId");
        if (staffIdStr != null) {
            logs.setStaffId(UUID.fromString(staffIdStr));
        }
        
        logs.setCheckType(rs.getString("CheckType"));
        logs.setCheckTime(rs.getTimestamp("CheckTime").toLocalDateTime());
        logs.setOdometer(rs.getInt("Odometer"));
        logs.setFuelLevel(rs.getString("FuelLevel"));
        logs.setConditionStatus(rs.getString("ConditionStatus"));
        logs.setConditionDescription(rs.getString("ConditionDescription"));
        logs.setDamageImages(rs.getString("DamageImages"));
        logs.setNote(rs.getString("Note"));
        
        return logs;
    }
} 