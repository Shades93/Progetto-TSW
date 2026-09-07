package model;

import java.io.Serializable;

public class DettaglioOrdineBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private int idOrdine;
    private int idTe;
    private int quantita;
    private double prezzoStorico;
    private double ivaStorica;

    // Campo d'appoggio per visualizzare il nome nelle JSP anche se cancellato dal catalogo
    private String nomeTe;

    public DettaglioOrdineBean() {}

    public DettaglioOrdineBean(int idOrdine, int idTe, int quantita, double prezzoStorico, double ivaStorica) {
        this.idOrdine = idOrdine;
        this.idTe = idTe;
        this.quantita = quantita;
        this.prezzoStorico = prezzoStorico;
        this.ivaStorica = ivaStorica;
    }

    public int getIdOrdine() {
        return idOrdine;
    }

    public void setIdOrdine(int idOrdine) {
        this.idOrdine = idOrdine;
    }

    public int getIdTe() {
        return idTe;
    }

    public void setIdTe(int idTe) {
        this.idTe = idTe;
    }

    public int getQuantita() {
        return quantita;
    }

    public void setQuantita(int quantita) {
        this.quantita = quantita;
    }

    public double getPrezzoStorico() {
        return prezzoStorico;
    }

    public void setPrezzoStorico(double prezzoStorico) {
        this.prezzoStorico = prezzoStorico;
    }

    // Alias per la JSP della fattura (${item.prezzoUnitario})
    public double getPrezzoUnitario() {
        return prezzoStorico;
    }

    public double getIvaStorica() {
        return ivaStorica;
    }

    public void setIvaStorica(double ivaStorica) {
        this.ivaStorica = ivaStorica;
    }

    // Alias per la JSP della fattura (${item.iva})
    public double getIva() {
        return ivaStorica;
    }

    public String getNomeTe() {
        return nomeTe;
    }

    public void setNomeTe(String nomeTe) {
        this.nomeTe = nomeTe;
    }

    // Alias per la JSP della fattura (${item.nomeProdotto})
    public String getNomeProdotto() {
        return (nomeTe != null) ? nomeTe : ("Prodotto #" + idTe);
    }

    public double getSubtotale() {
        return this.prezzoStorico * this.quantita;
    }
}
