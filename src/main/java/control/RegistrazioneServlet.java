package control;

import java.io.IOException;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Pattern;
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

    // À-ÿ = lettere accentate
    private static final Pattern NOME = Pattern.compile("^[A-Za-z\\u00C0-\\u00FF\\s']{2,40}$");
    private static final Pattern EMAIL = Pattern.compile("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$");
    private static final Pattern PASSWORD = Pattern.compile("^.{3,30}$");
    private static final Pattern TELEFONO = Pattern.compile("^[0-9]{8,12}$");
    private static final List<String> PREFISSI = Arrays.asList("+39", "+33", "+49", "+44", "+1");

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
        String nome = testo(request, "nome");
        String cognome = testo(request, "cognome");
        String email = testo(request, "email");
        String password = request.getParameter("password");
        String conferma = request.getParameter("confirmPassword");
        String prefisso = testo(request, "prefisso");
        String numeroTelefono = testo(request, "numeroTelefono");

        String errore = validazione(nome, cognome, email, password, conferma, prefisso, numeroTelefono);
        if (errore != null) {
            rifiuta(request, response, errore);
            return;
        }

        try {     // Verifica che l'email non esista già
            if (userDAO.doRetrieveByEmail(email) != null) {
                rifiuta(request, response, "Email già presente nei nostri sistemi.");
                return;
            }

            UserBean nuovoUtente = new UserBean();
            nuovoUtente.setNome(nome);
            nuovoUtente.setCognome(cognome);
            nuovoUtente.setEmail(email);
            nuovoUtente.setPassword(PasswordHasher.toHash(password));
            nuovoUtente.setAdmin(false);

            if (!numeroTelefono.isEmpty()) {
                nuovoUtente.setTelefono(prefisso + " " + numeroTelefono);
            }

            userDAO.doSave(nuovoUtente);

            // Conferma di registrazione completata
            request.setAttribute("successMessage", "Registrazione completata con successo. Effettua il login.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);

        } catch (SQLIntegrityConstraintViolationException e) {
            rifiuta(request, response, "Email già presente nei nostri sistemi.");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    private String validazione(String nome, String cognome, String email, String password,
                               String conferma, String prefisso, String numeroTelefono) {
        if (!NOME.matcher(nome).matches()) {
            return "Nome non valido: da 2 a 40 lettere, senza numeri.";
        }
        if (!NOME.matcher(cognome).matches()) {
            return "Cognome non valido: da 2 a 40 lettere, senza numeri.";
        }
        if (email.length() > 100 || !EMAIL.matcher(email).matches()) {
            return "Formato email non valido.";
        }
        if (password == null || !PASSWORD.matcher(password).matches()) {
            return "La password deve avere tra 3 e 30 caratteri.";
        }
        if (!password.equals(conferma)) {
            return "Le password non coincidono.";
        }
        if (!numeroTelefono.isEmpty() && (!PREFISSI.contains(prefisso) || !TELEFONO.matcher(numeroTelefono).matches())) {
            return "Numero di telefono non valido: servono da 8 a 12 cifre.";
        }
        return null;
    }

    private String testo(HttpServletRequest request, String nome) {
        String valore = request.getParameter(nome);
        return (valore == null) ? "" : valore.trim();
    }

    private void rifiuta(HttpServletRequest request, HttpServletResponse response, String messaggio)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", messaggio);
        request.getRequestDispatcher("/registrazione.jsp").forward(request, response);
    }
}
