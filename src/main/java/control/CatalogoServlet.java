package control;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.TeBean;
import model.dao.TeDAO;

@WebServlet(urlPatterns = {"/catalogo", "/prodotto"})
public class CatalogoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TeDAO teDAO;

    @Override
    public void init() {
        teDAO = new TeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String servletPath = request.getServletPath();

        try {
            if ("/prodotto".equals(servletPath)) {
                // Scheda singolo prodotto
                int id = Integer.parseInt(request.getParameter("id"));
                TeBean p = teDAO.doRetrieveByKey(id);
                if (p == null) {
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Prodotto inesistente");
                    return;
                }
                request.setAttribute("prodotto", p);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/dettaglioProdotto.jsp");
                dispatcher.forward(request, response);
            } else {
                // Catalogo generale o filtrato per categoria
                String catParam = request.getParameter("categoriaId");
                List<TeBean> prodotti;

                if (catParam != null && !catParam.trim().isEmpty()) {
                    int idCategoria = Integer.parseInt(catParam.trim());
                    prodotti = teDAO.doRetrieveByCategoria(idCategoria);
                    request.setAttribute("categoriaSelezionata", idCategoria);
                } else {
                    prodotti = teDAO.doRetrieveAll();
                }

                request.setAttribute("prodotti", prodotti);
                RequestDispatcher dispatcher = request.getRequestDispatcher("/catalogo.jsp");
                dispatcher.forward(request, response);
            }
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
