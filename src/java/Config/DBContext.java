package Repository;

import Config.DBInfo;
import static Config.DBInfo.DRIVER_NAME;
import static Config.DBInfo.PASS;
import static Config.DBInfo.URL;
import static Config.DBInfo.USER;
import java.sql.*;

public class DBContext implements DBInfo {

    public DBContext() {
    }

    public Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER_NAME);
            Connection conn = DriverManager.getConnection(URL, USER, PASS);
            if (conn != null) {
                System.out.println("Database connected successfully");
            }
            return conn;
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver not found: " + e.getMessage());
            throw new SQLException("Driver not found", e);
        } catch (SQLException e) {
            System.err.println("Database connection failed: " + e.getMessage());
            throw e;
        }
    }

    public void close(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null && !rs.isClosed()) {
                rs.close();
            }
            if (ps != null && !ps.isClosed()) {
                ps.close();
            }
            if (conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch (SQLException e) {
            System.err.println("Error closing resources: " + e.getMessage());
        }
    }
}
