package Repository.Booking;

import Config.DBContext;
import Model.Entity.Booking.Booking;
import Model.Entity.Booking.BookingApproval;
import Repository.Interfaces.IBooking.IBookingApprovalRepository;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class BookingApprovalRepository implements IBookingApprovalRepository{
    private DBContext dbContext;
    
    public BookingApprovalRepository(){
        dbContext = new DBContext();
    }

    @Override
    public BookingApproval add(BookingApproval entity) throws SQLException {
        String sql = "INSERT INTO BookingApproval (ApprovalId, BookingId, StaffId, ApprovalStatus, ApprovalDate, Note, RejectionReason) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getApprovalId());
            ps.setObject(2, entity.getBookingId());
            ps.setObject(3, entity.getStaffId());
            ps.setString(4, entity.getApprovalStatus());
            ps.setObject(5, entity.getApprovalDate());
            ps.setString(6, entity.getNote());
            ps.setString(7, entity.getRejectionReason());
            ps.executeUpdate();
            return entity;
        }
    }

    @Override
    public BookingApproval findById(UUID Id) throws SQLException {
        String sql = "SELECT * FROM BookingApproval WHERE ApprovalId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, Id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBookingApproval(rs);
                }
            }
        }
        return null;
    }

    @Override
    public boolean update(BookingApproval entity) throws SQLException {
        String sql = "UPDATE BookingApproval SET BookingId=?, StaffId=?, ApprovalStatus=?, ApprovalDate=?, Note=?, RejectionReason=? WHERE ApprovalId=?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, entity.getBookingId());
            ps.setObject(2, entity.getStaffId());
            ps.setString(3, entity.getApprovalStatus());
            ps.setObject(4, entity.getApprovalDate());
            ps.setString(5, entity.getNote());
            ps.setString(6, entity.getRejectionReason());
            ps.setObject(7, entity.getApprovalId());
            int affected = ps.executeUpdate();
            return affected > 0;
        }
    }

    @Override
    public boolean delete(UUID Id) throws SQLException {
        String sql = "DELETE FROM BookingApproval WHERE ApprovalId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, Id);
            int affected = ps.executeUpdate();
            return affected > 0;
        }
    }

    @Override
    public List<BookingApproval> findAll() throws SQLException {
        List<BookingApproval> list = new ArrayList<>();
        String sql = "SELECT * FROM BookingApproval";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToBookingApproval(rs));
            }
        }
        return list;
    }
    
    private BookingApproval mapResultSetToBookingApproval(ResultSet rs) throws SQLException {
        UUID approvalId = UUID.fromString(rs.getString("ApprovalId"));
        UUID bookingId = UUID.fromString(rs.getString("BookingId"));
        UUID staffId = UUID.fromString(rs.getString("StaffId"));
        String approvalStatus = rs.getString("ApprovalStatus");
        Timestamp approvalDateTs = rs.getTimestamp("ApprovalDate");
        LocalDateTime approvalDate = approvalDateTs != null ? approvalDateTs.toLocalDateTime() : null;
        String note = rs.getString("Note");
        String rejectionReason = rs.getString("RejectionReason");
        return new BookingApproval(approvalId, bookingId, staffId, approvalStatus, approvalDate, note, rejectionReason);
    }

    @Override
    public List<BookingApproval> findByStatus(String status) throws Exception {
        List<BookingApproval> list = new ArrayList<>();
        String sql = "SELECT * FROM BookingApproval WHERE ApprovalStatus = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, status);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToBookingApproval(rs));
                }
            }
        }
        return list;
    }

    @Override
    public BookingApproval findByBookingId(UUID bookingId) throws Exception {
        String sql = "SELECT * FROM BookingApproval WHERE BookingId = ?";
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setObject(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {    
                if (rs.next()) {
                    return mapResultSetToBookingApproval(rs);
                }
            }
        }
        return null;
    }

    private void setBookingApprovalParameters(PreparedStatement ps, BookingApproval approval) throws SQLException {
        ps.setObject(1, approval.getApprovalId());
        ps.setObject(2, approval.getBookingId());
        ps.setObject(3, approval.getStaffId());
        ps.setString(4, approval.getApprovalStatus());
        ps.setObject(5, approval.getApprovalDate());
        ps.setString(6, approval.getNote());
        ps.setString(7, approval.getRejectionReason());
    }
}
