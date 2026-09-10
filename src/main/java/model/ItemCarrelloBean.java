package model;

import java.io.Serializable;

public class ItemCarrelloBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private TeBean prodotto;
    private int quantita;

    public ItemCarrelloBean() {}

    public ItemCarrelloBean(TeBean prodotto, int quantita) {
        this.prodotto = prodotto;
        this.quantita = quantita;
    }

    public TeBean getProdotto() {
        return prodotto;
    }

    public void setProdotto(TeBean prodotto) {
        this.prodotto = prodotto;
    }

    public int getQuantita() {
        return quantita;
    }

    public void setQuantita(int quantita) {
        this.quantita = quantita;
    }

    public double getSubtotale() {
        if (prodotto != null) {
            return prodotto.getPrezzo() * quantita;
        }
        return 0.0;
    }
}
