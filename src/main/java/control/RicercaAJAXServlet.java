package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.TeBean;
import model.dao.TeDAO;

@WebServlet("/search-suggestions")
public class RicercaAJAXServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TeDAO teDAO;

    @Override
    public void init() {
        teDAO = new TeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String query = request.getParameter("q");

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        if (query == null || query.trim().length() < 2) {
            out.print("[]");
            out.flush();
            return;
        }

        try {
            List<TeBean> matches = teDAO.doRetrieveBySearch(query.trim());
            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < matches.size(); i++) {
                TeBean p = matches.get(i);
                json.append("{")
                    .append("\"id\":").append(p.getIdTe()).append(",")
                    .append("\"nome\":\"").append(p.getNomeTe().replace("\"", "\\\"")).append("\",")
                    .append("\"prezzo\":").append(p.getPrezzo())
                    .append("}");
                if (i < matches.size() - 1) {
                    json.append(",");
                }
            }
            json.append("]");
            out.print(json.toString());
        } catch (SQLException e) {
            e.printStackTrace();
            out.print("[]");
        }
        out.flush();
    }
}
