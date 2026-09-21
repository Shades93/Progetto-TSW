package control;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.UserBean;
import model.dao.UserDAO;
import util.PasswordHasher;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || password == null || email.trim().isEmpty() || password.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Campi obbligatori mancanti.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        try {
            // Hash password prima del confronto nel DB
            String passwordHash = PasswordHasher.toHash(password);
            UserBean user = userDAO.doRetrieveByCredentials(email, passwordHash);

            if (user != null) {
                HttpSession session = request.getSession(true);
                request.changeSessionId(); // nuovo identificatore dopo il login: difende dalla session fixation
                session.setAttribute("user", user);
                session.setMaxInactiveInterval(30 * 60);

                // Reindirizzamento basato sul ruolo
                if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/admin/prodotti");
                } else {
                    response.sendRedirect(request.getContextPath() + "/catalogo");
                }
            } else {
                request.setAttribute("errorMessage", "Email o password non corretti.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}