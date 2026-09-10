package model;

import java.io.Serializable;

public class CategoriaBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idCategoria;
    private String nomeCategoria;
    private String descrizione;

    public CategoriaBean() {}

    public CategoriaBean(int idCategoria, String nomeCategoria, String descrizione) {
        this.idCategoria = idCategoria;
        this.nomeCategoria = nomeCategoria;
        this.descrizione = descrizione;
    }

    public int getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getNomeCategoria() {
        return nomeCategoria;
    }

    public void setNomeCategoria(String nomeCategoria) {
        this.nomeCategoria = nomeCategoria;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }
}
