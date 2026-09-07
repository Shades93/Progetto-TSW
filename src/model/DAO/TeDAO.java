package model.dao;

import model.TeBean;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class TeDAO {

    private Connection getConnection() throws SQLException {
        return database.DatabaseConnection.getConnection();
    }

    // Catalogo pubblico: recupera solo i prodotti attivi
    public List<TeBean> doRetrieveAllActive() throws SQLException {
        String sql = "SELECT * FROM te WHERE attivo = TRUE";
        List<TeBean> list = new ArrayList<>();

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapResultSetToBean(rs));
            }
        }
        return list;
    }

    // Ricerca per ID
    public TeBean doRetrieveByKey(int idTe) throws SQLException {
        String sql = "SELECT * FROM te WHERE id_te = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idTe);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapResultSetToBean(rs);
                }
            }
        }
        return null;
    }

    // Ricerca prodotti per categoria
public List<TeBean> doRetrieveByCategoria(int idCategoria) throws SQLException {
    String sql = "SELECT * FROM te WHERE id_categoria = ? AND attivo = TRUE";
    List<TeBean> list = new ArrayList<>();

    try (Connection con = getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, idCategoria);
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapResultSetToBean(rs));
            }
        }
    }
    return list;
}




    // Barra di ricerca con suggerimenti dinamici AJAX
    public List<TeBean> doRetrieveBySearch(String query) throws SQLException {
        String sql = "SELECT * FROM te WHERE nome_te LIKE ? AND attivo = TRUE LIMIT 5";
        List<TeBean> list = new ArrayList<>();

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, "%" + query + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToBean(rs));
                }
            }
        }
        return list;
    }

    // Area Admin: Inserimento nuovo prodotto
    public void doSave(TeBean te) throws SQLException {
        String sql = "INSERT INTO te (id_categoria, nome_te, descrizione, prezzo, iva, quantita_disponibile, peso, provenienza, immagine, attivo) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, te.getIdCategoria());
            ps.setString(2, te.getNomeTe());
            ps.setString(3, te.getDescrizione());
            ps.setDouble(4, te.getPrezzo());
            ps.setDouble(5, te.getIva());
            ps.setInt(6, te.getQuantitaDisponibile());
            ps.setDouble(7, te.getPeso());
            ps.setString(8, te.getProvenienza());
            ps.setString(9, te.getImmagine());
            ps.setBoolean(10, te.isAttivo());

            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    te.setIdTe(rs.getInt(1));
                }
            }
        }
    }

    // Area Admin: Modifica prodotto
    public void doUpdate(TeBean te) throws SQLException {
        String sql = "UPDATE te SET id_categoria = ?, nome_te = ?, descrizione = ?, prezzo = ?, iva = ?, "
                   + "quantita_disponibile = ?, peso = ?, provenienza = ?, immagine = ?, attivo = ? WHERE id_te = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, te.getIdCategoria());
            ps.setString(2, te.getNomeTe());
            ps.setString(3, te.getDescrizione());
            ps.setDouble(4, te.getPrezzo());
            ps.setDouble(5, te.getIva());
            ps.setInt(6, te.getQuantitaDisponibile());
            ps.setDouble(7, te.getPeso());
            ps.setString(8, te.getProvenienza());
            ps.setString(9, te.getImmagine());
            ps.setBoolean(10, te.isAttivo());
            ps.setInt(11, te.getIdTe());

            ps.executeUpdate();
        }
    }

    // Cancellazione
    public void doDelete(int idTe) throws SQLException {
        // Disattivazione logica per evitare errori di vincolo con gli ordini passati
        String sql = "UPDATE te SET attivo = FALSE WHERE id_te = ?";

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, idTe);
            ps.executeUpdate();
        }
    }

    private TeBean mapResultSetToBean(ResultSet rs) throws SQLException {
        TeBean te = new TeBean();
        te.setIdTe(rs.getInt("id_te"));
        te.setIdCategoria(rs.getInt("id_categoria"));
        te.setNomeTe(rs.getString("nome_te"));
        te.setDescrizione(rs.getString("descrizione"));
        te.setPrezzo(rs.getDouble("prezzo"));
        te.setIva(rs.getDouble("iva"));
        te.setQuantitaDisponibile(rs.getInt("quantita_disponibile"));
        te.setPeso(rs.getDouble("peso"));
        te.setProvenienza(rs.getString("provenienza"));
        te.setImmagine(rs.getString("immagine"));
        te.setAttivo(rs.getBoolean("attivo"));
        return te;
    }
}
