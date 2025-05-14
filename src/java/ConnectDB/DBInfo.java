package ConnectDB;

public interface DBInfo {
    String DRIVER_NAME = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    String URL = "jdbc:sqlserver://localhost:1433;databaseName=AutoRental;encrypt=true;trustServerCertificate=true";
    String USER = "sa";
    String PASS = "123";
}
