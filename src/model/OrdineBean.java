package model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class OrdineBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idOrdine;
    private int userId;
    private Timestamp data;
    private double totale;
    private double totaleIva;
    private String stato;
    private String indirizzoSpedizione;
    private String metodoPagamento;

    // Lista righe d'ordine (Dettaglio_ordine)
    private List<DettaglioOrdineBean> dettagli = new ArrayList<>();

    public OrdineBean() {}

    public int getIdOrdine() {
        return idOrdine;
    }

    public void setIdOrdine(int idOrdine) {
        this.idOrdine = idOrdine;
    }

    // Alias per JSP (${ord.id})
    public int getId() {
        return idOrdine;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Timestamp getData() {
        return data;
    }

    public void setData(Timestamp data) {
        this.data = data;
    }

    // Alias per JSP (${ord.dataOrdine})
    public Timestamp getDataOrdine() {
        return data;
    }

    public double getTotale() {
        return totale;
    }

    public void setTotale(double totale) {
        this.totale = totale;
    }

    public double getTotaleIva() {
        return totaleIva;
    }

    public void setTotaleIva(double totaleIva) {
        this.totaleIva = totaleIva;
    }

    public String getStato() {
        return stato;
    }

    public void setStato(String stato) {
        this.stato = stato;
    }

    public String getIndirizzoSpedizione() {
        return indirizzoSpedizione;
    }

    public void setIndirizzoSpedizione(String indirizzoSpedizione) {
        this.indirizzoSpedizione = indirizzoSpedizione;
    }

    public String getMetodoPagamento() {
        return metodoPagamento;
    }

    public void setMetodoPagamento(String metodoPagamento) {
        this.metodoPagamento = metodoPagamento;
    }

    public List<DettaglioOrdineBean> getDettagli() {
        return dettagli;
    }

    public void setDettagli(List<DettaglioOrdineBean> dettagli) {
        this.dettagli = dettagli;
    }
}
