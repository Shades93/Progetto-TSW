package control;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.UserBean;
import model.dao.UserDAO;
import util.PasswordHasher;

@WebServlet("/registrazione")
public class RegistrazioneServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/registrazione.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String nome = request.getParameter("nome");
        String cognome = request.getParameter("cognome");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String prefisso = request.getParameter("prefisso");
        String numeroTelefono = request.getParameter("numeroTelefono");

        try {     // Verifica che l'email non esista già
            if (userDAO.doRetrieveByEmail(email) != null) {
                request.setAttribute("errorMessage", "Email già presente nei nostri sistemi.");
                request.getRequestDispatcher("/registrazione.jsp").forward(request, response);
                return;
            }

            UserBean nuovoUtente = new UserBean();
            nuovoUtente.setNome(nome);
            nuovoUtente.setCognome(cognome);
            nuovoUtente.setEmail(email);
            nuovoUtente.setPassword(PasswordHasher.toHash(password));
            nuovoUtente.setAdmin(false);
            
            if (numeroTelefono != null && !numeroTelefono.trim().isEmpty()) {
                nuovoUtente.setTelefono((prefisso != null ? prefisso : "") + " " + numeroTelefono.trim());
            }
            
            

            userDAO.doSave(nuovoUtente);

            // Conferma di registrazione completata
            request.setAttribute("successMessage", "Registrazione completata con successo. Effettua il login.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}