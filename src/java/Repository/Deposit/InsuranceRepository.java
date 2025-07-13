/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository.Deposit;

/**
 *
 * @author admin
 */
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

import Config.DBContext;
import Model.Entity.Booking.BookingInsurance;
import Model.Entity.Deposit.Insurance;
import Repository.Interfaces.IDeposit.IInsuranceRepository;

/**
 * Repository xử lý các thao tác database cho Insurance 
 * Chỉ truy xuất dữ liệu, không có logic tính toán
 */
public class InsuranceRepository implements IInsuranceRepository {

    private static final Logger LOGGER = Logger.getLogger(InsuranceRepository.class.getName());
    private final DBContext dbContext;

    // SQL queries
    private static final String SQL_FIND_ACTIVE
            = "SELECT * FROM Insurance WHERE IsActive = 1";

    private static final String SQL_FIND_BY_TYPE_AND_SEATS
            = "SELECT * FROM Insurance WHERE InsuranceType = ? AND IsActive = 1 "
            + "AND (ApplicableCarSeats IS NULL OR ApplicableCarSeats LIKE ?)";

    private static final String SQL_FIND_BY_TYPE
            = "SELECT * FROM Insurance WHERE InsuranceType = ? AND IsActive = 1";

    private static final String SQL_FIND_BOOKING_INSURANCE
            = "SELECT * FROM BookingInsurance WHERE BookingId = ?";

    private static final String SQL_FIND_BY_ID
            = "SELECT * FROM Insurance WHERE InsuranceId = ?";

    private static final String SQL_FIND_ALL
            = "SELECT * FROM Insurance";

    public InsuranceRepository() {
        this.dbContext = new DBContext();
    }

    @Override
    public List<Insurance> findActiveInsurances() throws SQLException {
        List<Insurance> insurances = new ArrayList<>();

        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_ACTIVE); 
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                insurances.add(mapResultSetToInsurance(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding active insurances", e);
            throw e;
        }

        return insurances;
    }

    @Override
    public Insurance findByTypeAndCarSeats(String insuranceType, int carSeats) throws SQLException {
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_TYPE_AND_SEATS)) {

            ps.setString(1, insuranceType);
            ps.setString(2, "%" + carSeats + "%"); // Tìm kiếm pattern trong ApplicableCarSeats

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToInsurance(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding insurance by type and car seats", e);
            throw e;
        }
    }

    /**
     * Tìm tất cả bảo hiểm theo type (không quan tâm số chỗ)
     */
    public List<Insurance> findByType(String insuranceType) throws SQLException {
        List<Insurance> insurances = new ArrayList<>();
        
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_TYPE)) {

            ps.setString(1, insuranceType);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    insurances.add(mapResultSetToInsurance(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding insurance by type: " + insuranceType, e);
            throw e;
        }
        
        return insurances;
    }

    @Override
    public List<BookingInsurance> findBookingInsuranceByBookingId(UUID bookingId) throws SQLException {
        List<BookingInsurance> bookingInsurances = new ArrayList<>();

        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BOOKING_INSURANCE)) {

            ps.setObject(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookingInsurances.add(mapResultSetToBookingInsurance(rs));
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding booking insurance by booking ID: " + bookingId, e);
            throw e;
        }

        return bookingInsurances;
    }

    @Override
    public Insurance add(Insurance entity) throws SQLException {
        // Implementation cho thêm insurance mới (nếu cần)
        throw new UnsupportedOperationException("Add insurance not implemented yet");
    }

    @Override
    public Insurance findById(UUID id) throws SQLException {
        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_BY_ID)) {

            ps.setObject(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToInsurance(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding insurance by ID: " + id, e);
            throw e;
        }
    }

    @Override
    public boolean update(Insurance entity) throws SQLException {
        throw new UnsupportedOperationException("Update insurance not implemented yet");
    }

    @Override
    public boolean delete(UUID id) throws SQLException {
        throw new UnsupportedOperationException("Delete insurance not implemented yet");
    }

    @Override
    public List<Insurance> findAll() throws SQLException {
        List<Insurance> insurances = new ArrayList<>();

        try (Connection conn = dbContext.getConnection(); 
             PreparedStatement ps = conn.prepareStatement(SQL_FIND_ALL); 
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                insurances.add(mapResultSetToInsurance(rs));
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding all insurances", e);
            throw e;
        }

        return insurances;
    }

    // ========== HELPER METHODS ==========
    /**
     * Map ResultSet sang Insurance object
     */
    private Insurance mapResultSetToInsurance(ResultSet rs) throws SQLException {
        Insurance insurance = new Insurance();

        insurance.setInsuranceId(UUID.fromString(rs.getString("InsuranceId")));
        insurance.setInsuranceName(rs.getString("InsuranceName"));
        insurance.setInsuranceType(rs.getString("InsuranceType"));
        insurance.setBaseRatePerDay(rs.getDouble("BaseRatePerDay"));
        insurance.setPercentageRate(rs.getDouble("PercentageRate"));
        insurance.setCoverageAmount(rs.getDouble("CoverageAmount"));
        insurance.setApplicableCarSeats(rs.getString("ApplicableCarSeats"));
        insurance.setDescription(rs.getString("Description"));
        insurance.setActive(rs.getBoolean("IsActive"));
        insurance.setCreatedDate(rs.getTimestamp("CreatedDate").toLocalDateTime());

        return insurance;
    }

    /**
     * Map ResultSet sang BookingInsurance object
     */
    private BookingInsurance mapResultSetToBookingInsurance(ResultSet rs) throws SQLException {
        BookingInsurance bookingInsurance = new BookingInsurance();

        bookingInsurance.setBookingInsuranceId(UUID.fromString(rs.getString("BookingInsuranceId")));
        bookingInsurance.setBookingId(UUID.fromString(rs.getString("BookingId")));
        bookingInsurance.setInsuranceId(UUID.fromString(rs.getString("InsuranceId")));
        bookingInsurance.setPremiumAmount(rs.getDouble("PremiumAmount"));
        bookingInsurance.setRentalDays(rs.getDouble("RentalDays"));
        bookingInsurance.setCarSeats(rs.getInt("CarSeats"));
        bookingInsurance.setEstimatedCarValue(rs.getDouble("EstimatedCarValue"));
        bookingInsurance.setCreatedAt(rs.getTimestamp("CreatedAt").toLocalDateTime());

        return bookingInsurance;
    }
}
