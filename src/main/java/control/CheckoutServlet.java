package control;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.CarrelloBean;
import model.DettaglioOrdineBean;
import model.ItemCarrelloBean;
import model.OrdineBean;
import model.TeBean;
import model.UserBean;
import model.dao.OrdineDAO;
import model.dao.TeDAO;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String ULTIMO_ORDINE = "ultimoOrdine";
    private OrdineDAO ordineDAO;
    private TeDAO teDAO;

    @Override
    public void init() {
        ordineDAO = new OrdineDAO();
        teDAO = new TeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Integer idOrdine = (session != null) ? (Integer) session.getAttribute(ULTIMO_ORDINE) : null;

        if (idOrdine == null) {
            response.sendRedirect(request.getContextPath() + "/carrello");
            return;
        }
        request.setAttribute("orderId", idOrdine);
        request.getRequestDispatcher("/confermaOrdine.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        UserBean user = (session != null) ? (UserBean) session.getAttribute("user") : null;
        CarrelloBean carrello = (session != null) ? (CarrelloBean) session.getAttribute("carrello") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?redirect=checkout");
            return;
        }

        if (carrello == null || carrello.getItems().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/catalogo");
            return;
        }

        // Parametri dal form di checkout (se assenti impostiamo valori di fallback)
        String indirizzo = request.getParameter("indirizzo");
        if (indirizzo == null || indirizzo.trim().isEmpty()) {
            indirizzo = "Indirizzo registrato profilo";
        }
        String metodoPagamento = request.getParameter("metodoPagamento");
        if (metodoPagamento == null || metodoPagamento.trim().isEmpty()) {
            metodoPagamento = "Carta di Credito";
        }

        try {
            for (ItemCarrelloBean item : carrello.getItems()) {
                TeBean attuale = teDAO.doRetrieveByKey(item.getProdotto().getIdTe());
                if (attuale == null || !attuale.isAttivo() || attuale.getQuantitaDisponibile() < item.getQuantita()) {
                    rifiuta(request, response, "Il prodotto \"" + item.getProdotto().getNomeTe()
                            + "\" non è più disponibile nella quantità richiesta. Modifica il carrello e riprova.");
                    return;
                }
            }

            // Costruzione dell'oggetto testata Ordine
            OrdineBean ordine = new OrdineBean();
            ordine.setUserId(user.getUserId());
            ordine.setTotale(carrello.getTotale());
            ordine.setStato("In elaborazione");
            ordine.setIndirizzoSpedizione(indirizzo);
            ordine.setMetodoPagamento(metodoPagamento);

            // Righe storiche: prezzo e IVA del momento. I prezzi sono IVA inclusa,
            // quindi l'IVA contenuta in una riga è: importo * aliquota / (100 + aliquota)
            double totaleIva = 0;
            for (ItemCarrelloBean item : carrello.getItems()) {
                DettaglioOrdineBean det = new DettaglioOrdineBean();
                det.setIdTe(item.getProdotto().getIdTe());
                det.setQuantita(item.getQuantita());
                det.setPrezzoStorico(item.getProdotto().getPrezzo());
                det.setIvaStorica(item.getProdotto().getIva());
                det.setNomeTe(item.getProdotto().getNomeTe());
                ordine.getDettagli().add(det);

                double aliquota = item.getProdotto().getIva();
                totaleIva += item.getSubtotale() * aliquota / (100 + aliquota);
            }
            ordine.setTotaleIva(Math.round(totaleIva * 100) / 100.0);

            // Salvataggio transazionale (ACID)
            ordineDAO.doSaveOrder(ordine);

            // Svuotamento obbligatorio del carrello
            carrello.clear();

            session.setAttribute(ULTIMO_ORDINE, ordine.getIdOrdine());
            response.sendRedirect(request.getContextPath() + "/checkout");

        } catch (SQLException e) {
            e.printStackTrace();
            rifiuta(request, response, "Impossibile completare l'ordine. Controlla la disponibilità dei prodotti e riprova.");
        }
    }

    private void rifiuta(HttpServletRequest request, HttpServletResponse response, String messaggio)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", messaggio);
        request.getRequestDispatcher("/carrello.jsp").forward(request, response);
    }
}
