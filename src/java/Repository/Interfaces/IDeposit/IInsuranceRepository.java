/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Repository.Interfaces.IDeposit;

/**
 *
 * @author admin
 */
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

import Model.Entity.Booking.BookingInsurance;
import Model.Entity.Deposit.Insurance;

/**
 * Interface cho InsuranceRepository 
 * Xử lý các thao tác database liên quan đến bảo hiểm
 * Chỉ truy xuất dữ liệu, không có logic tính toán
 */
public interface IInsuranceRepository {

    /**
     * Lấy tất cả bảo hiểm đang active
     *
     * @return List các Insurance
     */
    List<Insurance> findActiveInsurances() throws SQLException;

    /**
     * Lấy bảo hiểm theo loại và số chỗ ngồi
     *
     * @param insuranceType Loại bảo hiểm (TNDS, VatChat, TaiNan)
     * @param carSeats Số chỗ ngồi
     * @return Insurance object hoặc null
     */
    Insurance findByTypeAndCarSeats(String insuranceType, int carSeats) throws SQLException;

    /**
     * Lấy booking insurance theo booking ID
     *
     * @param bookingId ID của booking
     * @return List các BookingInsurance
     */
    List<BookingInsurance> findBookingInsuranceByBookingId(UUID bookingId) throws SQLException;

    // ========== BASIC CRUD METHODS ==========
    /**
     * Thêm insurance mới
     */
    Insurance add(Insurance entity) throws SQLException;

    /**
     * Tìm insurance theo ID
     */
    Insurance findById(UUID id) throws SQLException;

    /**
     * Cập nhật insurance
     */
    boolean update(Insurance entity) throws SQLException;

    /**
     * Xóa insurance
     */
    boolean delete(UUID id) throws SQLException;

    /**
     * Lấy tất cả insurance
     */
    List<Insurance> findAll() throws SQLException;
}
