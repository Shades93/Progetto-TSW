package control;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.RequestDispatcher;
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
    private TeDAO teDAO;

    @Override
    public void init() throws ServletException {
        teDAO = new TeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        CarrelloBean carrello = (CarrelloBean) session.getAttribute("carrello");
        if (carrello == null) {
            carrello = new CarrelloBean();
            session.setAttribute("carrello", carrello);
        }

        String action = request.getParameter("action");

        try {
            if (action != null) {
                switch (action) {
                    case "add": {
                        int id = Integer.parseInt(request.getParameter("id"));
                        int quantita = 1;
                        String qtaStr = request.getParameter("quantita");
                        if (qtaStr != null && !qtaStr.trim().isEmpty()) {
                            quantita = Integer.parseInt(qtaStr);
                        }

                        TeBean p = teDAO.doRetrieveByKey(id);
                        if (p != null) {
                            carrello.addProduct(p, quantita);
                        }
                        break;
                    }

                    case "update": {
                        int id = Integer.parseInt(request.getParameter("id"));
                        int quantita = Integer.parseInt(request.getParameter("quantita"));
                        carrello.updateQuantity(id, quantita);
                        break;
                    }

                    case "remove": {
                        int id = Integer.parseInt(request.getParameter("id"));
                        carrello.removeProduct(id);
                        break;
                    }

                    case "clear": {
                        carrello.clear();
                        break;
                    }
                }
            }
        } catch (NumberFormatException | SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Errore durante l'elaborazione del carrello.");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/carrello.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
