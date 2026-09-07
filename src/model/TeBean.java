package model;

import java.io.Serializable;
import java.text.NumberFormat;
import java.util.Locale;

public class TeBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idTe;
    private int idCategoria;
    private String nomeTe;
    private String descrizione;
    private double prezzo;
    private double iva;
    private int quantitaDisponibile;
    private double peso;
    private String provenienza;
    private String immagine;
    private boolean attivo;

    public TeBean() {}

    public int getIdTe() {
        return idTe;
    }

    public void setIdTe(int idTe) {
        this.idTe = idTe;
    }

    // Alias per compatibilità con le JSP scritte in precedenza (${p.id})
    public int getId() {
        return idTe;
    }

    public int getIdCategoria() {
        return idCategoria;
    }

    public void setIdCategoria(int idCategoria) {
        this.idCategoria = idCategoria;
    }

    public String getNomeTe() {
        return nomeTe;
    }

    public void setNomeTe(String nomeTe) {
        this.nomeTe = nomeTe;
    }

    // Alias per compatibilità con le JSP (${p.nome})
    public String getNome() {
        return nomeTe;
    }

    public String getDescrizione() {
        return descrizione;
    }

    public void setDescrizione(String descrizione) {
        this.descrizione = descrizione;
    }

    public double getPrezzo() {
        return prezzo;
    }

    public void setPrezzo(double prezzo) {
        this.prezzo = prezzo;
    }

    public double getIva() {
        return iva;
    }

    public void setIva(double iva) {
        this.iva = iva;
    }

    public int getQuantitaDisponibile() {
        return quantitaDisponibile;
    }

    public void setQuantitaDisponibile(int quantitaDisponibile) {
        this.quantitaDisponibile = quantitaDisponibile;
    }

    public double getPeso() {
        return peso;
    }

    public void setPeso(double peso) {
        this.peso = peso;
    }

    public String getProvenienza() {
        return provenienza;
    }

    public void setProvenienza(String provenienza) {
        this.provenienza = provenienza;
    }

    public String getImmagine() {
        return immagine;
    }

    public void setImmagine(String immagine) {
        this.immagine = immagine;
    }

    public boolean isAttivo() {
        return attivo;
    }

    public void setAttivo(boolean attivo) {
        this.attivo = attivo;
    }

    // Helper per stampare il prezzo formattato in euro nelle JSP (${p.priceCurrencyFormat})
    public String getPriceCurrencyFormat() {
        NumberFormat nf = NumberFormat.getCurrencyInstance(Locale.ITALY);
        return nf.format(this.prezzo);
    }
}
