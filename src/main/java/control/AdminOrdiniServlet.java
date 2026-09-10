package control;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.OrdineBean;
import model.dao.OrdineDAO;

@WebServlet("/admin/ordini")
public class AdminOrdiniServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrdineDAO ordineDAO;

    @Override
    public void init() {
        ordineDAO = new OrdineDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String dataInizio = request.getParameter("dataInizio");
        String dataFine = request.getParameter("dataFine");
        String clienteIdStr = request.getParameter("clienteId");

        try {
            Integer clienteId = null;
            if (clienteIdStr != null && !clienteIdStr.trim().isEmpty()) {
                clienteId = Integer.parseInt(clienteIdStr.trim());
            }

            // Il metodo doRetrieveByFilters gestisce tutti i casi: filtri combinati o lista completa se i campi sono null
            List<OrdineBean> ordini = ordineDAO.doRetrieveByFilters(clienteId, dataInizio, dataFine);

            request.setAttribute("ordini", ordini);
            request.getRequestDispatcher("/admin/ordini.jsp").forward(request, response);

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
