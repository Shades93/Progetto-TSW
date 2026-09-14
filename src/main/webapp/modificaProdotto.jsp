<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/fragments/header.jsp" />
<jsp:include page="/fragments/nav.jsp" />

<main class="container">
    <h2>${prodotto != null ? 'Modifica Scheda Prodotto' : 'Inserimento Nuovo Prodotto'}</h2>

    <form action="${pageContext.request.contextPath}/admin/prodotti" method="post" class="form-standard">
        <input type="hidden" name="action" value="${prodotto != null ? 'update' : 'insert'}">
        <c:if test="${prodotto != null}">
            <input type="hidden" name="id" value="${prodotto.id}">
        </c:if>

        <div class="form-group">
            <label for="nome">Nome Prodotto:</label>
            <input type="text" id="nome" name="nome" value="${prodotto != null ? prodotto.nome : ''}" required>
        </div>

        <div class="form-group">
            <label for="descrizione">Descrizione Completa:</label>
            <textarea id="descrizione" name="descrizione" rows="4" style="width:100%;" required>${prodotto != null ? prodotto.descrizione : ''}</textarea>
        </div>

        <div class="form-group">
        <label for="idCategoria">Categoria:</label>
        <select id="idCategoria" name="idCategoria" required>
            <option value="1" ${prodotto.idCategoria == 1 ? 'selected' : ''}>Tè Verde</option>
            <option value="2" ${prodotto.idCategoria == 2 ? 'selected' : ''}>Tè Nero</option>
            <option value="3" ${prodotto.idCategoria == 3 ? 'selected' : ''}>Tisane</option>
        </select>
        </div>

        <div class="form-group">
            <label for="prezzo">Prezzo Unitario (€):</label>
            <input type="number" id="prezzo" name="prezzo" step="0.01" min="0.01" value="${prodotto != null ? prodotto.prezzo : ''}" required>
        </div>

        <div class="form-group">
            <label for="iva">Aliquota IVA (%):</label>
            <input type="number" id="iva" name="iva" step="0.5" min="0" value="${prodotto != null ? prodotto.iva : '22.0'}" required>
        </div>

        <div class="form-group">
            <label for="quantitaDisponibile">Giacenza Magazzino:</label>
            <input type="number" id="quantitaDisponibile" name="quantitaDisponibile" min="0" value="${prodotto != null ? prodotto.quantitaDisponibile : '0'}" required>
        </div>

        <div class="form-group">
            <label for="immagine">Nome File Immagine:</label>
            <input type="text" id="immagine" name="immagine" value="${prodotto != null ? prodotto.immagine : ''}" placeholder="nomefoto.jpg">
        </div>

        <button type="submit" class="btn-primary">${prodotto != null ? 'Aggiorna Prodotto' : 'Salva nel Catalogo'}</button>
        <a href="${pageContext.request.contextPath}/admin/prodotti" class="btn-secondary">Annulla</a>
    </form>
</main>

<jsp:include page="/fragments/footer.jsp" />
