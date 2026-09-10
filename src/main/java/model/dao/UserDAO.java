package model.dao;

import model.UserBean;
import java.sql.*;

public class UserDAO {

    private Connection getConnection() throws SQLException {
        return database.DatabaseConnection.getConnection();
    }

    // Autenticazione: verifica email e password cifrata
    public UserBean doRetrieveByCredentials(String email, String passwordHash) throws SQLException {
        String sql = "SELECT * FROM utente WHERE email = ? AND password = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, passwordHash);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBean(rs);
                }
            }
        }
        return null;
    }
    public UserBean doRetrieveByEmail(String email) throws SQLException {
        String sql = "SELECT * FROM utente WHERE email = ?";
        try (Connection con = database.DatabaseConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    UserBean u = new UserBean();
                    u.setUserId(rs.getInt("user_id"));
                    u.setNome(rs.getString("nome"));
                    u.setCognome(rs.getString("cognome"));
                    u.setEmail(rs.getString("email"));
                    u.setPassword(rs.getString("password"));
                    u.setTelefono(rs.getString("telefono"));
                    u.setAdmin(rs.getBoolean("is_admin"));
                    return u;
                }
            }
        }
        return null;
    }

    // Verifica asincrona dell'email durante la registrazione
    public boolean checkEmailExists(String email) throws SQLException {
        String sql = "SELECT user_id FROM utente WHERE email = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }
    
    
    
    
    
    // Registrazione nuovo utente
    public void doSave(UserBean user) throws SQLException {
        String sql = "INSERT INTO utente (nome, cognome, email, password, telefono, is_admin) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, user.getNome());
            ps.setString(2, user.getCognome());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getTelefono());
            ps.setBoolean(6, user.isAdmin());

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    user.setUserId(rs.getInt(1));
                }
            }
        }
    }

    private UserBean mapResultSetToBean(ResultSet rs) throws SQLException {
        UserBean user = new UserBean();
        user.setUserId(rs.getInt("user_id"));
        user.setNome(rs.getString("nome"));
        user.setCognome(rs.getString("cognome"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setTelefono(rs.getString("telefono"));
        user.setAdmin(rs.getBoolean("is_admin"));
        return user;
    }
}
