package control;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.SecureRandom;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebFilter("/*")
public class SicurezzaFilter implements Filter {

    public static final String TOKEN_ATTR = "csrfToken";
    private static final SecureRandom RANDOM = new SecureRandom();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        String path = req.getServletPath();
        if (path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/immagini/")) {
            chain.doFilter(request, response);
            return;
        }

        // La codifica va impostata prima che qualcuno legga i parametri
        req.setCharacterEncoding("UTF-8");

        HttpSession session = req.getSession();
        String token = (String) session.getAttribute(TOKEN_ATTR);
        if (token == null) {
            token = nuovoToken();
            session.setAttribute(TOKEN_ATTR, token);
        }

        String metodo = req.getMethod();
        boolean modifica = !"GET".equals(metodo) && !"HEAD".equals(metodo) && !"OPTIONS".equals(metodo);
        if (modifica) {
            String ricevuto = req.getHeader("X-CSRF-Token");
            if (ricevuto == null) {
                ricevuto = req.getParameter("csrf");
            }
            if (!coincide(token, ricevuto)) {
                res.sendError(HttpServletResponse.SC_FORBIDDEN, "Token CSRF non valido");
                return;
            }
        }
        chain.doFilter(request, response);
    }

    private static String nuovoToken() {
        byte[] bytes = new byte[32];
        RANDOM.nextBytes(bytes);
        StringBuilder sb = new StringBuilder();
        for (byte b : bytes) {
            sb.append(String.format("%02x", b));
        }
        return sb.toString();
    }

    // Confronto a tempo costante, per non rivelare il token tramite i tempi di risposta
    private static boolean coincide(String atteso, String ricevuto) {
        if (ricevuto == null) {
            return false;
        }
        return MessageDigest.isEqual(atteso.getBytes(StandardCharsets.UTF_8), ricevuto.getBytes(StandardCharsets.UTF_8));
    }
}
