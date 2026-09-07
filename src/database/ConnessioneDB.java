package util;

import java.sql.Connection;
import java.sql.SQLException;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class DatabaseConnection {

    private static DataSource ds;

    static {
        try {
            InitialContext initContext = new InitialContext();
            // Cerca il pool configurato in Tomcat
            ds = (DataSource) initContext.lookup("java:/comp/env/jdbc/EcommerceDB");
        } catch (NamingException e) {
            throw new RuntimeException("Impossibile trovare il DataSource", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return ds.getConnection(); // Prende in prestito una connessione dal pool
    }
}
