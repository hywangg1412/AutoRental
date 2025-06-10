package Config;

import java.sql.*;

public class TestDBConnection {
    public static void main(String[] args) {
        DBContext dbContext = new DBContext();
        try (Connection conn = dbContext.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT TOP 5 ba.ApprovalId, ba.BookingId, ba.StaffId, ba.ApprovalStatus, ba.ApprovalDate, ba.Note, ba.RejectionReason, " +
                                            "b.BookingCode, u.Email as CustomerEmail " +
                                            "FROM BookingApproval ba " +
                                            "JOIN Booking b ON ba.BookingId = b.BookingId " +
                                            "JOIN Users u ON b.UserId = u.UserId")) {

            System.out.println("SAMPLE BOOKING APPROVAL DATA:");
            while (rs.next()) {
                System.out.println(
                    "ApprovalId: " + rs.getString("ApprovalId") +
                    ", BookingId: " + rs.getString("BookingId") +
                    ", StaffId: " + rs.getString("StaffId") +
                    ", Status: " + rs.getString("ApprovalStatus") +
                    ", ApprovalDate: " + rs.getTimestamp("ApprovalDate") +
                    ", Note: " + rs.getString("Note") +
                    ", RejectionReason: " + rs.getString("RejectionReason") +
                    ", BookingCode: " + rs.getString("BookingCode") +
                    ", CustomerEmail: " + rs.getString("CustomerEmail")
                );
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi truy vấn dữ liệu:");
            e.printStackTrace();
        }
    }
}