package Config;

public interface DBInfo {
    public static final String DRIVER_NAME = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    public static final String URL = "jdbc:sqlserver://localhost:1433;databaseName=AutoRental4;encrypt=true;trustServerCertificate=true;integratedSecurity=false;";
    public static final String USERNAME = "sa";
    public static final String PASSWORD = "123";
}
