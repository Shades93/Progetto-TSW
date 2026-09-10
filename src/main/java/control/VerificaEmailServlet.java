package control;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.dao.UserDAO;

@WebServlet("/check-email")
public class VerificaEmailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        boolean exists = false;

        if (email != null && !email.trim().isEmpty()) {
            try {
                exists = userDAO.checkEmailExists(email.trim());
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        // Risposta JSON pura
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print("{\"exists\": " + exists + "}");
        out.flush();
    }
}
