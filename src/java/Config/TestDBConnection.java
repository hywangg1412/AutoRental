package Config;

import java.sql.*;

public class TestDBConnection {
    public static void main(String[] args) {
        DBContext dbContext = new DBContext();
        try (Connection conn = dbContext.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT TOP 5 UserId, Username, Email, Status FROM Users")) {

            System.out.println("SAMPLE DATA:");
            while (rs.next()) {
                System.out.println(
                    "UserId: " + rs.getString("UserId") +
                    ", Username: " + rs.getString("Username") +
                    ", Email: " + rs.getString("Email") +
                    ", Status: " + rs.getString("Status")
                );
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi truy vấn dữ liệu:");
            e.printStackTrace();
        }
    }
}