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
import model.TeBean;
import model.dao.TeDAO;

@WebServlet("/carrello")
public class CarrelloServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String ERRORE_ATTR = "erroreCarrello";

    private TeDAO teDAO;

    @Override
    public void init() {
        teDAO = new TeDAO();
    }

    private CarrelloBean getCarrello(HttpSession session) {
        CarrelloBean carrello = (CarrelloBean) session.getAttribute("carrello");
        if (carrello == null) {
            carrello = new CarrelloBean();
            session.setAttribute("carrello", carrello);
        }
        return carrello;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        getCarrello(session);

        String errore = (String) session.getAttribute(ERRORE_ATTR);
        if (errore != null) {
            request.setAttribute("errorMessage", errore);
            session.removeAttribute(ERRORE_ATTR);
        }
        request.getRequestDispatcher("/carrello.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        CarrelloBean carrello = getCarrello(session);

        String action = request.getParameter("action");
        boolean ajax = "fetch".equals(request.getHeader("X-Requested-With"));
        String errore = null;

        try {
            if ("add".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int quantita = leggiQuantita(request.getParameter("quantita"));
                TeBean p = teDAO.doRetrieveByKey(id);

                if (p == null || !p.isAttivo() || quantita < 1) {
                    errore = "Prodotto non disponibile.";
                } else {
                    int aggiungibili = Math.min(quantita, p.getQuantitaDisponibile() - carrello.getQuantita(id));
                    if (aggiungibili < 1) {
                        errore = "Disponibilità massima raggiunta per \"" + p.getNomeTe() + "\".";
                    } else {
                        carrello.addProduct(p, aggiungibili);
                        if (aggiungibili < quantita) {
                            errore = "Disponibilità limitata: aggiunti solo " + aggiungibili + " pezzi di \"" + p.getNomeTe() + "\".";
                        }
                    }
                }

                if (ajax) {
                    response.setContentType("text/plain");
                    response.setCharacterEncoding("UTF-8");
                    response.getWriter().write(String.valueOf(carrello.getCount()));
                    return;
                }
            } else if ("update".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int quantita = Integer.parseInt(request.getParameter("quantita"));
                if (quantita > 0) {
                    TeBean p = teDAO.doRetrieveByKey(id);
                    if (p != null && quantita > p.getQuantitaDisponibile()) {
                        quantita = p.getQuantitaDisponibile();
                        errore = "Disponibilità limitata a " + quantita + " pezzi di \"" + p.getNomeTe() + "\".";
                    }
                }
                carrello.updateQuantity(id, quantita);
            } else if ("remove".equals(action)) {
                carrello.removeProduct(Integer.parseInt(request.getParameter("id")));
            } else if ("clear".equals(action)) {
                carrello.clear();
            }
        } catch (NumberFormatException e) {
            errore = "Richiesta non valida.";
        } catch (SQLException e) {
            e.printStackTrace();
            errore = "Errore durante l'elaborazione del carrello.";
        }

        if (ajax) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }
        if (errore != null) {
            session.setAttribute(ERRORE_ATTR, errore);
        }
        response.sendRedirect(request.getContextPath() + "/carrello");
    }

    private int leggiQuantita(String valore) {
        if (valore == null || valore.trim().isEmpty()) {
            return 1;
        }
        return Integer.parseInt(valore.trim());
    }
}
