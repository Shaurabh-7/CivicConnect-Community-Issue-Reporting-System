package civicconnect.utils;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Handles database connectivity for the application.
 * Contains configuration details to connect to the MySQL database.
 */
public class DBConnection {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/civicconnect";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";

    /**
     * Connects to the system database using MySQL JDBC Driver.
     *
     * @return A live java.sql.Connection object to perform database actions.
     * @throws Exception If loading the driver fails or database credentials are incorrect.
     */
    public static Connection getConnection() throws Exception {
        Class.forName("com.mysql.cj.jdbc.Driver");
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }
}
