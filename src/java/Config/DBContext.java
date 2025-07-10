package Config;

import static Config.DBInfo.*;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBContext {
    private static final Logger LOGGER = Logger.getLogger(DBContext.class.getName());

    public DBContext() {
    }

    public Connection getConnection() throws SQLException {
        try {
            Class.forName(DRIVER_NAME); 
            Connection conn = DriverManager.getConnection(URL, USERNAME, PASSWORD);
            // LOGGER.info("Database connected successfully"); // Bật khi cần debug
            return conn;
        } catch (ClassNotFoundException e) {
            LOGGER.log(Level.SEVERE, "JDBC Driver not found", e);
            throw new SQLException("Driver not found", e);
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database connection failed: " + e.getMessage(), e);
            throw e;
        }
    }

    public void close(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null && !rs.isClosed()) rs.close();
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error closing ResultSet", e);
        }

        try {
            if (ps != null && !ps.isClosed()) ps.close();
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error closing PreparedStatement", e);
        }

        try {
            if (conn != null && !conn.isClosed()) conn.close();
        } catch (SQLException e) {
            LOGGER.log(Level.WARNING, "Error closing Connection", e);
        }
    }

    public void close(Connection conn, PreparedStatement ps) {
        close(conn, ps, null);
    }

    public void close(PreparedStatement ps) {
        close(null, ps, null);
    }
}
