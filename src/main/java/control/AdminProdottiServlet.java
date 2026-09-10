package control;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.TeBean;
import model.dao.TeDAO;

@WebServlet("/admin/prodotti")
public class AdminProdottiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TeDAO teDAO;

    @Override
    public void init() {
        teDAO = new TeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                // Cancellazione sicura (disattivazione logica da checklist)
                teDAO.doDelete(id);
                response.sendRedirect(request.getContextPath() + "/admin/prodotti?msg=deleted");
                return;
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                TeBean p = teDAO.doRetrieveByKey(id);
                request.setAttribute("prodotto", p);
                request.getRequestDispatcher("/admin/modificaProdotto.jsp").forward(request, response);
                return;
            }

            // Visualizzazione catalogo completo per l'amministratore
            List<TeBean> prodotti = teDAO.doRetrieveAll();
            request.setAttribute("prodotti", prodotti);
            request.getRequestDispatcher("/admin/prodotti.jsp").forward(request, response);
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            TeBean p = new TeBean();
            p.setNomeTe(request.getParameter("nome"));
            p.setDescrizione(request.getParameter("descrizione"));
            p.setPrezzo(Double.parseDouble(request.getParameter("prezzo")));
            p.setIva(Double.parseDouble(request.getParameter("iva")));
            p.setQuantitaDisponibile(Integer.parseInt(request.getParameter("quantitaDisponibile")));
            p.setIdCategoria(Integer.parseInt(request.getParameter("categoria")));
            p.setImmagine(request.getParameter("immagine"));
            p.setAttivo(true);

            // Campi facoltativi specifici del tè
            String pesoStr = request.getParameter("peso");
            if (pesoStr != null && !pesoStr.trim().isEmpty()) {
                p.setPeso(Double.parseDouble(pesoStr));
            }
            p.setProvenienza(request.getParameter("provenienza"));

            if ("update".equals(action)) {
                p.setIdTe(Integer.parseInt(request.getParameter("id")));
                teDAO.doUpdate(p);
                response.sendRedirect(request.getContextPath() + "/admin/prodotti?msg=updated");
            } else {
                teDAO.doSave(p);
                response.sendRedirect(request.getContextPath() + "/admin/prodotti?msg=inserted");
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
