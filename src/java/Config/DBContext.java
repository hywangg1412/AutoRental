package Config;

import static Config.DBInfo.*;
import java.sql.*;

public class DBContext {

    public DBContext() {
    }

    public Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER_NAME); 
            Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            System.out.println("Database connected successfully");
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
            if (rs != null && !rs.isClosed()) rs.close();
        } catch (SQLException e) {
            System.err.println("❗ Error closing ResultSet: " + e.getMessage());
        }

        try {
            if (ps != null && !ps.isClosed()) ps.close();
        } catch (SQLException e) {
            System.err.println("❗ Error closing PreparedStatement: " + e.getMessage());
        }

        try {
            if (conn != null && !conn.isClosed()) conn.close();
        } catch (SQLException e) {
            System.err.println("❗ Error closing Connection: " + e.getMessage());
        }
    }

    public void close(Connection conn, PreparedStatement ps) {
        close(conn, ps, null);
    }

    public void close(PreparedStatement ps) {
        close(null, ps, null);
    }
}
