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
import model.UserBean;
import model.dao.OrdineDAO;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrdineDAO ordineDAO;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/carrello");
    }

    @Override
    public void init() {
        ordineDAO = new OrdineDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	request.setCharacterEncoding("UTF-8");
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
            // Costruzione dell'oggetto testata Ordine
            OrdineBean ordine = new OrdineBean();
            ordine.setUserId(user.getUserId());
            ordine.setTotale(carrello.getTotale());
            ordine.setTotaleIva(carrello.getTotale() * 0.22); // Scorporo o imposta calcolata
            ordine.setStato("In elaborazione");
            ordine.setIndirizzoSpedizione(indirizzo);
            ordine.setMetodoPagamento(metodoPagamento);

            // Popolamento delle righe storiche (integrità storica checklist)
            for (ItemCarrelloBean item : carrello.getItems()) {
                DettaglioOrdineBean det = new DettaglioOrdineBean();
                det.setIdTe(item.getProdotto().getIdTe());
                det.setQuantita(item.getQuantita());
                det.setPrezzoStorico(item.getProdotto().getPrezzo());
                det.setIvaStorica(item.getProdotto().getIva());
                det.setNomeTe(item.getProdotto().getNomeTe());
                ordine.getDettagli().add(det);
            }

            // Salvataggio transazionale (ACID)
            ordineDAO.doSaveOrder(ordine);

            // Svuotamento obbligatorio del carrello
            carrello.clear();

            request.setAttribute("orderId", ordine.getIdOrdine());
            request.setAttribute("successMessage", "Ordine #" + ordine.getIdOrdine() + " effettuato con successo!");
            request.getRequestDispatcher("/confermaOrdine.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Impossibile completare l'ordine.");
        }
    }
}
