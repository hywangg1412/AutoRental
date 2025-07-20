/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository.Booking;

/**
 *
 * @author admin
 */
import Config.DBContext;
import Model.DTO.Deposit.InsuranceDetailDTO;
import Model.Entity.Booking.BookingInsurance;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Repository xử lý các thao tác database cho BookingInsurance
 * Quản lý bảo hiểm áp dụng cho từng booking
 */
public class BookingInsuranceRepository {
    
    private static final Logger LOGGER = Logger.getLogger(BookingInsuranceRepository.class.getName());
    private final DBContext dbContext;
    
    // SQL queries
    private static final String SQL_INSERT = 
        "INSERT INTO BookingInsurance (BookingInsuranceId, BookingId, InsuranceId, " +
        "PremiumAmount, RentalDays, CarSeats, EstimatedCarValue, CreatedAt) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
    
    private static final String SQL_FIND_BY_BOOKING = 
        "SELECT * FROM BookingInsurance WHERE BookingId = ?";
    
    private static final String SQL_FIND_WITH_INSURANCE_DETAILS = 
        "SELECT bi.*, i.InsuranceName, i.InsuranceType, i.Description " +
        "FROM BookingInsurance bi " +
        "INNER JOIN Insurance i ON bi.InsuranceId = i.InsuranceId " +
        "WHERE bi.BookingId = ?";
    
    private static final String SQL_DELETE_BY_BOOKING = 
        "DELETE FROM BookingInsurance WHERE BookingId = ?";
    
    private static final String SQL_FIND_BY_ID = 
        "SELECT * FROM BookingInsurance WHERE BookingInsuranceId = ?";
    
    private static final String SQL_UPDATE = 
        "UPDATE BookingInsurance SET BookingId = ?, InsuranceId = ?, PremiumAmount = ?, " +
        "RentalDays = ?, CarSeats = ?, EstimatedCarValue = ? WHERE BookingInsuranceId = ?";
    
    private static final String SQL_DELETE = 
        "DELETE FROM BookingInsurance WHERE BookingInsuranceId = ?";
    
    private static final String SQL_GET_TOTAL_PREMIUM = 
        "SELECT SUM(PremiumAmount) as Total FROM BookingInsurance WHERE BookingId = ?";
    
    public BookingInsuranceRepository() {
        this.dbContext = new DBContext();
    }
    
    /**
     * Thêm bảo hiểm cho booking
     */
    public BookingInsurance add(BookingInsurance entity) throws SQLException {
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_INSERT)) {
            
            ps.setObject(1, entity.getBookingInsuranceId());
            ps.setObject(2, entity.getBookingId());
            ps.setObject(3, entity.getInsuranceId());
            ps.setDouble(4, entity.getPremiumAmount());
            ps.setDouble(5, entity.getRentalDays());
            ps.setInt(6, entity.getCarSeats());
            ps.setDouble(7, entity.getEstimatedCarValue());
            ps.setTimestamp(8, Timestamp.valueOf(entity.getCreatedAt()));
            
            int affectedRows = ps.executeUpdate();
            if (affectedRows > 0) {
                return entity;
            }
            return null;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error adding booking insurance", e);
            throw e;
        }
    }
    
    /**
     * Lấy tất cả bảo hiểm của một booking
     */
    public List<BookingInsurance> findByBookingId(UUID bookingId) throws SQLException {
        List<BookingInsurance> insurances = new ArrayList<>();
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_BOOKING)) {
            
            ps.setObject(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    insurances.add(mapResultSetToBookingInsurance(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding insurances by booking ID: " + bookingId, e);
            throw e;
        }
        
        return insurances;
    }
    
    /**
     * Lấy chi tiết bảo hiểm với thông tin Insurance (cho DepositPageDTO)
     */
    public List<InsuranceDetailDTO> getInsuranceDetailsForDeposit(UUID bookingId) throws SQLException {
        List<InsuranceDetailDTO> details = new ArrayList<>();
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_WITH_INSURANCE_DETAILS)) {
            
            ps.setObject(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InsuranceDetailDTO dto = new InsuranceDetailDTO();
                    dto.setInsuranceName(rs.getString("InsuranceName"));
                    dto.setInsuranceType(rs.getString("InsuranceType"));
                    dto.setPremiumAmount(rs.getDouble("PremiumAmount"));
                    dto.setDescription(rs.getString("Description"));
                    
                    details.add(dto);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting insurance details for deposit", e);
            throw e;
        }
        
        return details;
    }
    
    /**
     * Xóa tất cả bảo hiểm của booking (dùng khi tính lại)
     */
    public boolean deleteByBookingId(UUID bookingId) throws SQLException {
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_DELETE_BY_BOOKING)) {
            
            ps.setObject(1, bookingId);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting insurances by booking ID", e);
            throw e;
        }
    }
    
    /**
     * Tính tổng phí bảo hiểm của booking
     */
    public double getTotalPremiumAmount(UUID bookingId) throws SQLException {
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_GET_TOTAL_PREMIUM)) {
            
            ps.setObject(1, bookingId);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("Total");
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error calculating total premium amount", e);
            throw e;
        }
        
        return 0.0;
    }
    
    // ========== BASIC CRUD METHODS ==========
    
    public BookingInsurance findById(UUID id) throws SQLException {
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_ID)) {
            
            ps.setObject(1, id);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBookingInsurance(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding insurance by ID: " + id, e);
            throw e;
        }
    }
    
    public boolean update(BookingInsurance entity) throws SQLException {
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_UPDATE)) {
            
            ps.setObject(1, entity.getBookingId());
            ps.setObject(2, entity.getInsuranceId());
            ps.setDouble(3, entity.getPremiumAmount());
            ps.setDouble(4, entity.getRentalDays());
            ps.setInt(5, entity.getCarSeats());
            ps.setDouble(6, entity.getEstimatedCarValue());
            ps.setObject(7, entity.getBookingInsuranceId());
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error updating booking insurance", e);
            throw e;
        }
    }
    
    public boolean delete(UUID id) throws SQLException {
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(SQL_DELETE)) {
            
            ps.setObject(1, id);
            
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error deleting booking insurance", e);
            throw e;
        }
    }
    
    /**
     * Cập nhật tất cả bản ghi BookingInsurance có InsuranceId thuộc danh sách vehicleInsuranceIds, đặt premiumAmount = 0
     * 
     * @param vehicleInsuranceIds Danh sách ID của các bảo hiểm vật chất
     * @return Số bản ghi đã cập nhật
     * @throws SQLException nếu có lỗi khi thực hiện truy vấn
     */
    public int updateAllVehicleInsurancePremiums(List<UUID> vehicleInsuranceIds) throws SQLException {
        if (vehicleInsuranceIds == null || vehicleInsuranceIds.isEmpty()) {
            return 0;
        }
        
        // Tạo câu truy vấn SQL với danh sách IN (?)
        StringBuilder sqlBuilder = new StringBuilder();
        sqlBuilder.append("UPDATE BookingInsurance SET PremiumAmount = 0 WHERE InsuranceId IN (");
        
        // Thêm các dấu ? tương ứng với số lượng ID
        for (int i = 0; i < vehicleInsuranceIds.size(); i++) {
            if (i > 0) {
                sqlBuilder.append(", ");
            }
            sqlBuilder.append("?");
        }
        sqlBuilder.append(")");
        
        String sql = sqlBuilder.toString();
        
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            // Đặt các giá trị cho các tham số ?
            for (int i = 0; i < vehicleInsuranceIds.size(); i++) {
                ps.setObject(i + 1, vehicleInsuranceIds.get(i));
            }
            
            // Thực hiện truy vấn và lấy số bản ghi đã cập nhật
            int affectedRows = ps.executeUpdate();
            LOGGER.info("Đã cập nhật " + affectedRows + " bản ghi BookingInsurance với premiumAmount = 0");
            
            return affectedRows;
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Lỗi khi cập nhật premiumAmount cho bảo hiểm vật chất", e);
            throw e;
        }
    }
    
    // ========== HELPER METHODS ==========
    
    /**
     * Map ResultSet sang BookingInsurance object
     */
    private BookingInsurance mapResultSetToBookingInsurance(ResultSet rs) throws SQLException {
        BookingInsurance insurance = new BookingInsurance();
        
        insurance.setBookingInsuranceId(UUID.fromString(rs.getString("BookingInsuranceId")));
        insurance.setBookingId(UUID.fromString(rs.getString("BookingId")));
        insurance.setInsuranceId(UUID.fromString(rs.getString("InsuranceId")));
        insurance.setPremiumAmount(rs.getDouble("PremiumAmount"));
        insurance.setRentalDays(rs.getDouble("RentalDays"));
        insurance.setCarSeats(rs.getInt("CarSeats"));
        insurance.setEstimatedCarValue(rs.getDouble("EstimatedCarValue"));
        insurance.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());
        
        return insurance;
    }
}