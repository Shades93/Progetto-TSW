package model;

import java.io.Serializable;
import java.sql.Timestamp;

public class RecensioneBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idRecensione;
    private int userId;
    private int idTe;
    private int voto;
    private String commento;
    private Timestamp data;

    public RecensioneBean() {}

    public RecensioneBean(int idRecensione, int userId, int idTe, int voto, String commento, Timestamp data) {
        this.idRecensione = idRecensione;
        this.userId = userId;
        this.idTe = idTe;
        this.voto = voto;
        this.commento = commento;
        this.data = data;
    }

    public int getIdRecensione() {
        return idRecensione;
    }

    public void setIdRecensione(int idRecensione) {
        this.idRecensione = idRecensione;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getIdTe() {
        return idTe;
    }

    public void setIdTe(int idTe) {
        this.idTe = idTe;
    }

    public int getVoto() {
        return voto;
    }

    public void setVoto(int voto) {
        this.voto = voto;
    }

    public String getCommento() {
        return commento;
    }

    public void setCommento(String commento) {
        this.commento = commento;
    }

    public Timestamp getData() {
        return data;
    }

    public void setData(Timestamp data) {
        this.data = data;
    }
}
