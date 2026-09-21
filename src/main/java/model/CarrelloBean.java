package model;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

public class CarrelloBean implements Serializable {
    private static final long serialVersionUID = 1L;

    private List<ItemCarrelloBean> items;

    public CarrelloBean() {
        this.items = new ArrayList<>();
    }

    public List<ItemCarrelloBean> getItems() {
        return items;
    }

    public void addProduct(TeBean prodotto, int quantita) {
        for (ItemCarrelloBean item : items) {
            if (item.getProdotto().getIdTe() == prodotto.getIdTe()) {
                item.setQuantita(item.getQuantita() + quantita);
                return;
            }
        }
        items.add(new ItemCarrelloBean(prodotto, quantita));
    }

    public int getQuantita(int idTe) {
        for (ItemCarrelloBean item : items) {
            if (item.getProdotto().getIdTe() == idTe) {
                return item.getQuantita();
            }
        }
        return 0;
    }

    public void updateQuantity(int idTe, int quantita) {
        if (quantita <= 0) {
            removeProduct(idTe);
            return;
        }
        for (ItemCarrelloBean item : items) {
            if (item.getProdotto().getIdTe() == idTe) {
                item.setQuantita(quantita);
                return;
            }
        }
    }

    public void removeProduct(int idTe) {
        items.removeIf(item -> item.getProdotto().getIdTe() == idTe);
    }

    public void clear() {
        items.clear();
    }

    public double getTotale() {
        double tot = 0.0;
        for (ItemCarrelloBean item : items) {
            tot += item.getSubtotale();
        }
        return tot;
    }

    public int getCount() {
        int count = 0;
        for (ItemCarrelloBean item : items) {
            count += item.getQuantita();
        }
        return count;
    }
}
