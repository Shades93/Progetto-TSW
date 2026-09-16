package control;

import model.UserBean;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter(urlPatterns = {"/admin/*", "/adminProdotti", "/adminOrdini"})
public class AdminFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        UserBean user = (session != null) ? (UserBean) session.getAttribute("user") : null;

        // Se l'utente non è loggato o non è contrassegnato come admin nel DB
        if (user == null || !user.isAdmin()) {
            res.sendRedirect(req.getContextPath() + "/login.jsp?error=unauthorized");
            return;
        }

        // Accesso autorizzato
        chain.doFilter(request, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}

    @Override
    public void destroy() {}
}
