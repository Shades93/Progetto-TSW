package model;

import java.io.Serializable;

public class IndirizzoBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idIndirizzo;
    private int userId;
    private String via;
    private String numero;
    private String citta;
    private String cap;

    public IndirizzoBean() {}

    public IndirizzoBean(int idIndirizzo, int userId, String via, String numero, String citta, String cap) {
        this.idIndirizzo = idIndirizzo;
        this.userId = userId;
        this.via = via;
        this.numero = numero;
        this.citta = citta;
        this.cap = cap;
    }

    public int getIdIndirizzo() {
        return idIndirizzo;
    }

    public void setIdIndirizzo(int idIndirizzo) {
        this.idIndirizzo = idIndirizzo;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getVia() {
        return via;
    }

    public void setVia(String via) {
        this.via = via;
    }

    public String getNumero() {
        return numero;
    }

    public void setNumero(String numero) {
        this.numero = numero;
    }

    public String getCitta() {
        return citta;
    }

    public void setCitta(String citta) {
        this.citta = citta;
    }

    public String getCap() {
        return cap;
    }

    public void setCap(String cap) {
        this.cap = cap;
    }

    // Stringa formattata utile per il campo 'indirizzo_spedizione' di Ordine
    public String getIndirizzoCompleto() {
        return via + " " + numero + ", " + cap + " " + citta;
    }
}
