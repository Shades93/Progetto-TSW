<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="pageCss" value="admin" />
</jsp:include>
<jsp:include page="/fragments/nav.jsp" />

<jsp:include page="/fragments/barraAdmin.jsp" />

<main class="container admin-container">
    <h2>${prodotto != null ? 'Modifica Scheda Prodotto' : 'Inserimento Nuovo Prodotto'}</h2>

    <form action="${pageContext.request.contextPath}/admin/prodotti" method="post" enctype="multipart/form-data" class="admin-form-card">
        <input type="hidden" name="action" value="${prodotto != null ? 'update' : 'insert'}">
        <c:if test="${prodotto != null}">
            <input type="hidden" name="id" value="${prodotto.idTe}">
        </c:if>

        <div class="form-group">
            <label for="nome">Nome Prodotto</label>
            <input type="text" id="nome" name="nome" value="${prodotto != null ? prodotto.nomeTe : ''}" required>
        </div>

        <div class="form-group">
            <label for="descrizione">Descrizione Completa</label>
            <textarea id="descrizione" name="descrizione" rows="4" required>${prodotto != null ? prodotto.descrizione : ''}</textarea>
        </div>

        <div class="form-row">
            <div class="form-group">
                <label for="idCategoria">Categoria</label>
                <div class="select-wrapper">
                    <select id="idCategoria" name="idCategoria" required>
                        <option value="1" ${prodotto.idCategoria == 1 ? 'selected' : ''}>Tè Verde</option>
                        <option value="2" ${prodotto.idCategoria == 2 ? 'selected' : ''}>Tè Nero</option>
                        <option value="3" ${prodotto.idCategoria == 3 ? 'selected' : ''}>Matcha</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
			    <label>Immagine:</label>
			    
			    <!-- Input nascosto -->
			    <input type="file" id="foto" name="foto" accept="image/*" style="display: none;" onchange="updateFileName(this)">
			    
			    <!-- Pulsante personalizzato color panna -->
<label for="foto" class="btn-custom-upload" style="
    display: inline-flex;
    align-items: center;
    align-self: flex-start;
    gap: 0.5rem;
    cursor: pointer;
    width: fit-content;
    padding: 0.6rem 0.8rem;
    font-size: 0.95rem;
    font-weight: 600;
    color: #2b4213;
    background-color: var(--bg-page, #fdfae9);
    border: 1.5px solid rgba(74, 110, 36, 0.35);
    border-radius: 50px;
    box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
    transition: all 0.2s ease;
">
    📁 Carica Immagine
</label>
			    <span id="nomeFileScelto" style="margin-left: 10px; font-size: 0.9rem; color: #555;">Nessun file selezionato</span>
			
			    <c:if test="${not empty prodotto.immagine}">
			        <small style="display:block; margin-top:6px; color:#555;">
			            Immagine attuale: <strong>${prodotto.immagine}</strong> (lascia vuoto per non cambiarla)
			        </small>
			        <input type="hidden" name="vecchiaImmagine" value="${prodotto.immagine}">
			    </c:if>
			</div>
			
			<script>
			function updateFileName(input) {
			    const display = document.getElementById('nomeFileScelto');
			    if (input.files && input.files[0]) {
			        display.textContent = input.files[0].name;
			    } else {
			        display.textContent = 'Nessun file selezionato';
			    }
			}
			</script>
            
        </div>

        <div class="form-row form-row-three">
            <div class="form-group">
                <label for="prezzo">Prezzo Unitario (€)</label>
                <input type="number" id="prezzo" name="prezzo" step="0.01" min="0.01" value="${prodotto != null ? prodotto.prezzo : ''}" required>
            </div>

            <div class="form-group">
                <label for="iva">Aliquota IVA (%)</label>
                <input type="number" id="iva" name="iva" step="0.5" min="0" value="${prodotto != null ? prodotto.iva : '22.0'}" required>
            </div>

            <div class="form-group">
                <label for="quantitaDisponibile">Giacenza Magazzino</label>
                <input type="number" id="quantitaDisponibile" name="quantitaDisponibile" min="0" value="${prodotto != null ? prodotto.quantitaDisponibile : '0'}" required>
            </div>
        </div>

        <div class="form-actions">
            <button type="submit" class="btn-primary">${prodotto != null ? 'Aggiorna Prodotto' : 'Salva nel Catalogo'}</button>
            <a href="${pageContext.request.contextPath}/admin/prodotti" class="btn-secondary">Annulla</a>
        </div>
    </form>
</main>

<jsp:include page="/fragments/footer.jsp" />