package control;

import java.io.IOException;
import java.sql.SQLException;
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

@WebServlet("/admin/ordini")
public class AdminOrdiniServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrdineDAO ordineDAO;

    @Override
    public void init() {
        ordineDAO = new OrdineDAO();
    }

    // Verifica dei permessi da amministratore
    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        UserBean user = (session != null) ? (UserBean) session.getAttribute("user") : null;

        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accesso non autorizzato.");
            return false;
        }
        return true;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Blocco di sicurezza attivo
        if (!checkAdmin(request, response)) {
            return;
        }

        String dataInizio = request.getParameter("dataInizio");
        String dataFine = request.getParameter("dataFine");
        String clienteIdStr = request.getParameter("clienteId");

        try {
            Integer clienteId = null;
            if (clienteIdStr != null && !clienteIdStr.trim().isEmpty()) {
                clienteId = Integer.parseInt(clienteIdStr.trim());
            }

            List<OrdineBean> ordini = ordineDAO.doRetrieveByFilters(clienteId, dataInizio, dataFine);

            request.setAttribute("ordini", ordini);
            request.getRequestDispatcher("/admin/ordini.jsp").forward(request, response);

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
