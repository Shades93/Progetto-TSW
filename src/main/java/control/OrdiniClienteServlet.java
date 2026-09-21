package control;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.OrdineBean;
import model.UserBean;
import model.dao.OrdineDAO;

@WebServlet("/ordini")
public class OrdiniClienteServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrdineDAO ordineDAO;

    @Override
    public void init() {
        ordineDAO = new OrdineDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        UserBean user = (session != null) ? (UserBean) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String idStr = request.getParameter("id");
        try {
            if (idStr != null) {
                int idOrdine = Integer.parseInt(idStr);
                OrdineBean ordine;

                // Logica autorizzativa: l'admin vede tutto, l'utente solo il suo
                if (user.isAdmin()) {
                    ordine = ordineDAO.doRetrieveByKey(idOrdine);
                } else {
                    ordine = ordineDAO.doRetrieveByKeyAndUser(idOrdine, user.getUserId());
                }

                if (ordine == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Ordine non trovato.");
                    return;
                }

                request.setAttribute("ordine", ordine);
                request.getRequestDispatcher("/dettaglioOrdine.jsp").forward(request, response);
            } else {
                // Storico ordini dell'utente
                List<OrdineBean> ordini = ordineDAO.doRetrieveByUserId(user.getUserId());
                request.setAttribute("ordini", ordini);
                request.getRequestDispatcher("/storicoOrdini.jsp").forward(request, response);
            }
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Ordine non trovato.");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
