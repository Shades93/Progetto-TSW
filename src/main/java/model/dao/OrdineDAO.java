package model.dao;

import model.OrdineBean;
import model.DettaglioOrdineBean;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrdineDAO {

    private Connection getConnection() throws SQLException {
        return database.DatabaseConnection.getConnection();
    }

    // Requisito Checklist: Salvataggio transazionale dell'ordine e delle righe storiche
    public void doSaveOrder(OrdineBean ordine) throws SQLException {
        String sqlOrdine = "INSERT INTO ordine (user_id, totale, totale_iva, stato, indirizzo_spedizione, metodo_pagamento) "
                         + "VALUES (?, ?, ?, ?, ?, ?)";
        String sqlDettaglio = "INSERT INTO dettaglio_ordine (id_ordine, id_te, quantita, prezzo_storico, iva_storica) "
                            + "VALUES (?, ?, ?, ?, ?)";
        String sqlGiacenza = "UPDATE te SET quantita_disponibile = quantita_disponibile - ? "
                           + "WHERE id_te = ? AND quantita_disponibile >= ?";

        Connection con = null;
        try {
            con = getConnection();
            con.setAutoCommit(false);

            // 1. Inserimento testata ordine
            try (PreparedStatement psOrd = con.prepareStatement(sqlOrdine, Statement.RETURN_GENERATED_KEYS)) {
                psOrd.setInt(1, ordine.getUserId());
                psOrd.setDouble(2, ordine.getTotale());
                psOrd.setDouble(3, ordine.getTotaleIva());
                psOrd.setString(4, ordine.getStato());
                psOrd.setString(5, ordine.getIndirizzoSpedizione());
                psOrd.setString(6, ordine.getMetodoPagamento());
                psOrd.executeUpdate();

                try (ResultSet rs = psOrd.getGeneratedKeys()) {
                    if (rs.next()) {
                        ordine.setIdOrdine(rs.getInt(1));
                    }
                }
            }

            // 2. Inserimento righe di dettaglio e aggiornamento della quantita
            try (PreparedStatement psDet = con.prepareStatement(sqlDettaglio);
                 PreparedStatement psGiac = con.prepareStatement(sqlGiacenza)) {

                for (DettaglioOrdineBean item : ordine.getDettagli()) {
                    // Dettaglio storico
                    psDet.setInt(1, ordine.getIdOrdine());
                    psDet.setInt(2, item.getIdTe());
                    psDet.setInt(3, item.getQuantita());
                    psDet.setDouble(4, item.getPrezzoStorico());
                    psDet.setDouble(5, item.getIvaStorica());
                    psDet.executeUpdate();

                    // Scalo disponibilità magazzino: l'UPDATE è condizionato, quindi è atomico.
                    // Se la giacenza non basta più non modifica nessuna riga e l'ordine viene annullato.
                    psGiac.setInt(1, item.getQuantita());
                    psGiac.setInt(2, item.getIdTe());
                    psGiac.setInt(3, item.getQuantita());
                    if (psGiac.executeUpdate() != 1) {
                        throw new SQLException("Giacenza insufficiente per il prodotto " + item.getIdTe());
                    }
                }
            }

            con.commit(); // Convalida transazione
        } catch (SQLException e) {
            if (con != null) {
                con.rollback(); // Annulla modifiche in caso di errore
            }
            throw e;
        } finally {
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
    }

    // Storico ordini cliente
    public List<OrdineBean> doRetrieveByUserId(int userId) throws SQLException {
        String sql = "SELECT * FROM ordine WHERE user_id = ? ORDER BY data DESC";
        List<OrdineBean> list = new ArrayList<>();

        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToOrdine(rs));
                }
            }
        }
        return list;
    }

    // Dettaglio singolo ordine con righe storiche (per la fattura)
    public OrdineBean doRetrieveByKey(int idOrdine) throws SQLException {
        String sqlOrd = "SELECT * FROM ordine WHERE id_ordine = ?";
        String sqlDet = "SELECT d.*, t.nome_te FROM dettaglio_ordine d "
                      + "JOIN te t ON d.id_te = t.id_te WHERE d.id_ordine = ?";

        OrdineBean ordine = null;

        try (Connection con = getConnection();
             PreparedStatement psOrd = con.prepareStatement(sqlOrd);
             PreparedStatement psDet = con.prepareStatement(sqlDet)) {

            psOrd.setInt(1, idOrdine);
            try (ResultSet rs = psOrd.executeQuery()) {
                if (rs.next()) {
                    ordine = mapResultSetToOrdine(rs);
                }
            }

            if (ordine != null) {
                psDet.setInt(1, idOrdine);
                try (ResultSet rsDet = psDet.executeQuery()) {
                    while (rsDet.next()) {
                        DettaglioOrdineBean item = new DettaglioOrdineBean();
                        item.setIdOrdine(rsDet.getInt("id_ordine"));
                        item.setIdTe(rsDet.getInt("id_te"));
                        item.setQuantita(rsDet.getInt("quantita"));
                        item.setPrezzoStorico(rsDet.getDouble("prezzo_storico"));
                        item.setIvaStorica(rsDet.getDouble("iva_storica"));
                        item.setNomeTe(rsDet.getString("nome_te"));
                        ordine.getDettagli().add(item);
                    }
                }
            }
        }
        return ordine;
    }

        public OrdineBean doRetrieveByKeyAndUser(int idOrdine, int userId) throws SQLException {
        String sql = "SELECT * FROM ordine WHERE id_ordine = ? AND user_id = ?";
        OrdineBean ordine = null;

        try (Connection con = database.DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idOrdine);
            ps.setInt(2, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    ordine = new OrdineBean();
                    ordine.setIdOrdine(rs.getInt("id_ordine"));
                    ordine.setUserId(rs.getInt("user_id"));
                    ordine.setData(rs.getTimestamp("data"));
                    ordine.setTotale(rs.getDouble("totale"));
                    ordine.setTotaleIva(rs.getDouble("totale_iva"));
                    ordine.setStato(rs.getString("stato"));
                    ordine.setIndirizzoSpedizione(rs.getString("indirizzo_spedizione"));
                    ordine.setMetodoPagamento(rs.getString("metodo_pagamento"));

                    // Carica anche i dettagli (le righe prodotto) dell'ordine
                    ordine.setDettagli(doRetrieveDettagli(idOrdine));
                }
            }
        }
        return ordine;
    }

    // Metodo di supporto per caricare le righe della fattura con prezzo storico
    private List<DettaglioOrdineBean> doRetrieveDettagli(int idOrdine) throws SQLException {
        String sql = "SELECT d.*, t.nome_te FROM dettaglio_ordine d "
                + "JOIN te t ON d.id_te = t.id_te WHERE d.id_ordine = ?";
        List<DettaglioOrdineBean> list = new ArrayList<>();

        try (Connection con = database.DatabaseConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, idOrdine);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    DettaglioOrdineBean item = new DettaglioOrdineBean();
                    item.setIdOrdine(rs.getInt("id_ordine"));
                    item.setIdTe(rs.getInt("id_te"));
                    item.setNomeTe(rs.getString("nome_te"));
                    item.setQuantita(rs.getInt("quantita"));
                    item.setPrezzoStorico(rs.getDouble("prezzo_storico"));
                    item.setIvaStorica(rs.getDouble("iva_storica"));
                    list.add(item);
                }
            }
        }
        return list;
    }




    // Visualizzazione ordini admin con filtri per data e cliente
    public List<OrdineBean> doRetrieveByFilters(Integer userId, String dataInizio, String dataFine) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT * FROM ordine WHERE 1=1 ");
        List<Object> params = new ArrayList<>();

        if (userId != null) {
            sql.append("AND user_id = ? ");
            params.add(userId);
        }
        if (dataInizio != null && !dataInizio.trim().isEmpty()) {
            sql.append("AND data >= ? ");
            params.add(dataInizio + " 00:00:00");
        }
        if (dataFine != null && !dataFine.trim().isEmpty()) {
            sql.append("AND data <= ? ");
            params.add(dataFine + " 23:59:59");
        }
        sql.append("ORDER BY data DESC");

        List<OrdineBean> list = new ArrayList<>();
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapResultSetToOrdine(rs));
                }
            }
        }
        return list;
    }

    private OrdineBean mapResultSetToOrdine(ResultSet rs) throws SQLException {
        OrdineBean o = new OrdineBean();
        o.setIdOrdine(rs.getInt("id_ordine"));
        o.setUserId(rs.getInt("user_id"));
        o.setData(rs.getTimestamp("data"));
        o.setTotale(rs.getDouble("totale"));
        o.setTotaleIva(rs.getDouble("totale_iva"));
        o.setStato(rs.getString("stato"));
        o.setIndirizzoSpedizione(rs.getString("indirizzo_spedizione"));
        o.setMetodoPagamento(rs.getString("metodo_pagamento"));
        return o;
    }
}
