package control;

import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.List;
import javax.imageio.IIOException;
import javax.imageio.ImageIO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import model.TeBean;
import model.UserBean;
import model.dao.TeDAO;
import javax.servlet.annotation.MultipartConfig;

@MultipartConfig(
	    fileSizeThreshold = 1024 * 1024 * 1, // 1 MB
	    maxFileSize = 1024 * 1024 * 10,      // 10 MB
	    maxRequestSize = 1024 * 1024 * 15    // 15 MB
	)

@WebServlet("/admin/prodotti")
public class AdminProdottiServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private TeDAO teDAO;

    @Override
    public void init() {
        teDAO = new TeDAO();
    }

    // Verifica dei permessi da amministratore
    private boolean checkAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession(false);
        UserBean user = (session != null) ? (UserBean) session.getAttribute("user") : null;

        if (user == null || !user.isAdmin()) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accesso non autorizzato.");
            return false;
        }
        return true;
    }

    // Legge il file del campo "foto". Ritorna null se non è stato scelto nessun file,
    // IllegalArgumentException se il contenuto non è un'immagine (JPG, PNG o GIF).
    private BufferedImage leggiFoto(HttpServletRequest request) throws IOException, ServletException {
        Part foto = request.getPart("foto");
        if (foto == null || foto.getSize() == 0) {
            return null;
        }
        try (InputStream in = foto.getInputStream()) {
            BufferedImage img = ImageIO.read(in);
            if (img == null) {
                throw new IllegalArgumentException("File non valido");
            }
            return img;
        } catch (IIOException e) {
            throw new IllegalArgumentException("Immagine danneggiata", e);
        }
    }

    private String salvaFoto(BufferedImage img, int idTe) throws IOException {
        String cartella = getServletContext().getRealPath("/immagini");
        if (cartella == null) {
            throw new IOException("Cartella immagini non raggiungibile");
        }
        BufferedImage rgb = new BufferedImage(img.getWidth(), img.getHeight(), BufferedImage.TYPE_INT_RGB);
        Graphics2D g = rgb.createGraphics();
        g.drawImage(img, 0, 0, Color.WHITE, null);
        g.dispose();

        String nomeFile = idTe + "_1.jpg";
        ImageIO.write(rgb, "jpg", new File(cartella, nomeFile));
        return nomeFile;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Controllo sicurezza
        if (!checkAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                TeBean p = teDAO.doRetrieveByKey(id);
                request.setAttribute("prodotto", p);
                request.getRequestDispatcher("/admin/modificaProdotto.jsp").forward(request, response);
                return;
            }

            // Visualizzazione catalogo completo per l'amministratore
            List<TeBean> prodotti = teDAO.doRetrieveAll();
            request.setAttribute("prodotti", prodotti);
            request.getRequestDispatcher("/admin/prodotti.jsp").forward(request, response);

        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Controllo sicurezza
        if (!checkAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        try {
            if ("delete".equals(action)) {
                teDAO.doDelete(Integer.parseInt(request.getParameter("id")));
                response.sendRedirect(request.getContextPath() + "/admin/prodotti?msg=deleted");
                return;
            }

            TeBean p = new TeBean();

            // Accetta sia "nome" sia "nomeTe" per evitare errori tra form e servlet
            String nome = request.getParameter("nomeTe");
            if (nome == null) nome = request.getParameter("nome");
            p.setNomeTe(nome);

            p.setDescrizione(request.getParameter("descrizione"));
            p.setPrezzo(Double.parseDouble(request.getParameter("prezzo")));
            p.setIva(Double.parseDouble(request.getParameter("iva")));
            p.setQuantitaDisponibile(Integer.parseInt(request.getParameter("quantitaDisponibile")));

            // Corretto: legge "idCategoria" dal form <select name="idCategoria">
            String catParam = request.getParameter("idCategoria");
            if (catParam == null) catParam = request.getParameter("categoria");
            p.setIdCategoria(Integer.parseInt(catParam));

            p.setAttivo(true);

            // Campi facoltativi specifici del tè
            String pesoStr = request.getParameter("peso");
            if (pesoStr != null && !pesoStr.trim().isEmpty()) {
                p.setPeso(Double.parseDouble(pesoStr));
            }
            p.setProvenienza(request.getParameter("provenienza"));

            BufferedImage nuovaFoto;
            try {
                nuovaFoto = leggiFoto(request);
            } catch (IllegalArgumentException e) {
                response.sendRedirect(request.getContextPath() + "/admin/prodotti?msg=badimage");
                return;
            }

            if ("update".equals(action)) {
                String idParam = request.getParameter("id");
                if (idParam == null) idParam = request.getParameter("idTe");
                p.setIdTe(Integer.parseInt(idParam));

                TeBean attuale = teDAO.doRetrieveByKey(p.getIdTe());
                String nomeImmagine = (attuale != null) ? attuale.getImmagine() : null;

                if (nuovaFoto != null) {
                    nomeImmagine = salvaFoto(nuovaFoto, p.getIdTe());
                } else if (nomeImmagine == null || nomeImmagine.trim().isEmpty()) {
                    nomeImmagine = p.getIdTe() + "_1.jpg";
                }
                p.setImmagine(nomeImmagine);

                teDAO.doUpdate(p);
                response.sendRedirect(request.getContextPath() + "/admin/prodotti?msg=updated");
            } else {
                teDAO.doSave(p);
                if (nuovaFoto != null) {
                    p.setImmagine(salvaFoto(nuovaFoto, p.getIdTe()));
                    teDAO.doUpdate(p);
                }
                response.sendRedirect(request.getContextPath() + "/admin/prodotti?msg=inserted");
            }
        } catch (IllegalStateException e) {
            // Tomcat lo lancia quando il file supera i limiti di @MultipartConfig
            response.sendRedirect(request.getContextPath() + "/admin/prodotti?msg=badimage");
        } catch (SQLException | NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        }
    }
}
