<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="title" value="${prodotto.nome} - Tèrapia" />
    <jsp:param name="pageCss" value="dettaglio-prodotto" />
</jsp:include>

<jsp:include page="/fragments/nav.jsp">
    <jsp:param name="page" value="catalogo" />
</jsp:include>

<jsp:include page="/fragments/barra.jsp" />

<main class="container">
    <div class="card-wrapper">
        <div class="card">
            
<!-- Galleria Immagini a carosello-->
            <div class="product-imgs">
                <div class="img-display">
                    <div class="img-showcase">
                        <img src="${pageContext.request.contextPath}/immagini/${prodotto.id}_1.jpg" alt="<c:out value="${prodotto.nome}"/>"
                             onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/immagini/default.jpg';">
                        <img src="${pageContext.request.contextPath}/immagini/${prodotto.id}_2.jpg" alt="<c:out value="${prodotto.nome}"/>"
                             onerror="this.remove();">
                        <img src="${pageContext.request.contextPath}/immagini/${prodotto.id}_3.jpg" alt="<c:out value="${prodotto.nome}"/>"
                             onerror="this.remove();">
                        <img src="${pageContext.request.contextPath}/immagini/${prodotto.id}_4.jpg" alt="<c:out value="${prodotto.nome}"/>"
                             onerror="this.remove();">
                    </div>
                </div>

                <div class="img-select">
                    <div class="img-item">
                        <a href="javascript:void(0)" data-id="1">
                            <img src="${pageContext.request.contextPath}/immagini/${prodotto.id}_1.jpg" alt="<c:out value="${prodotto.nome}"/>"
                                 onerror="this.onerror=null; this.src='${pageContext.request.contextPath}/immagini/default.jpg';">
                        </a>
                    </div>
                    <div class="img-item" id="thumb-2">
                        <a href="javascript:void(0)" data-id="2">
                            <img src="${pageContext.request.contextPath}/immagini/${prodotto.id}_2.jpg" alt="<c:out value="${prodotto.nome}"/>"
                                 onerror="document.getElementById('thumb-2').remove();">
                        </a>
                    </div>
                    <div class="img-item" id="thumb-3">
                        <a href="javascript:void(0)" data-id="3">
                            <img src="${pageContext.request.contextPath}/immagini/${prodotto.id}_3.jpg" alt="<c:out value="${prodotto.nome}"/>"
                                 onerror="document.getElementById('thumb-3').remove();">
                        </a>
                    </div>
                    <div class="img-item" id="thumb-4">
                        <a href="javascript:void(0)" data-id="4">
                            <img src="${pageContext.request.contextPath}/immagini/${prodotto.id}_4.jpg" alt="<c:out value="${prodotto.nome}"/>"
                                 onerror="document.getElementById('thumb-4').remove();">
                        </a>
                    </div>
                </div>
            </div>


            <!-- Contenuto Prodotto -->
            <div class="product-content">
                <h2 class="product-title"><c:out value="${prodotto.nome}"/></h2>
                <span class="product-category-tag">Categoria: #${prodotto.idCategoria}</span>

                <div class="product-price">
                    <p class="new-price">Prezzo: <span>${prodotto.priceCurrencyFormat}</span> <small>(IVA ${prodotto.iva}% inclusa)</small></p>
                </div>

                <div class="product-detail">
                    <h3>Descrizione e Preparazione</h3>
                    <div class="product-desc-text">
                        <%-- HTML voluto (<br>, <strong>) scritto dall'admin: non va escapato --%>
                        ${prodotto.descrizione}
                    </div>
                    <p class="stock-info">Disponibilità a magazzino: <strong>${prodotto.quantitaDisponibile}</strong> pezzi</p>
                </div>

                <div class="purchase-info">
                    <c:choose>
                        <c:when test="${prodotto.quantitaDisponibile > 0}">
                            <form action="${pageContext.request.contextPath}/carrello" method="post" class="form-add-detail" data-validate>
                                <input type="hidden" name="csrf" value="${sessionScope.csrfToken}">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="id" value="${prodotto.id}">
                                
                                <div class="form-row">
                                    <label for="quantita">Quantità:</label>
                                    <input type="number" id="quantita" name="quantita" value="1" min="1" max="${prodotto.quantitaDisponibile}">
                                    <button type="submit" class="btn">Aggiungi al Carrello 🛒</button>
                                </div>
                            </form>
                        </c:when>
                        <c:otherwise>
                            <div class="alert alert-warning">Prodotto momentaneamente non disponibile a magazzino.</div>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="action-links">
                    <a href="${pageContext.request.contextPath}/catalogo" class="link-back">&larr; Torna al catalogo</a>
                </div>
            </div>

        </div>
    </div>
</main>

<script src="${pageContext.request.contextPath}/js/slider.js"></script>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('.form-add-detail');
    if (!form) return;

    form.addEventListener('submit', function(e) {
        e.preventDefault();

        // getAttribute evita il conflitto con l'input name="action"
        const baseUrl = this.getAttribute('action');
        const params = new URLSearchParams(new FormData(this));
        const csrf = document.querySelector('meta[name="csrf-token"]').content;

        fetch(baseUrl, {
            method: 'POST',
            headers: { 'X-CSRF-Token': csrf, 'X-Requested-With': 'fetch' },
            body: params
        })
            .then(response => {
                if (!response.ok) {
                    throw new Error("Errore server: " + response.status);
                }
                return response.text();
            })
            .then(count => {
                let badge = document.querySelector('.cart-badge');
                if (!badge) {
                    badge = document.createElement('span');
                    badge.className = 'cart-badge';
                    const cartBtn = document.querySelector('.top-cart-btn');
                    if (cartBtn) cartBtn.appendChild(badge);
                }
                if (badge) {
                    badge.textContent = count.trim();
                }
                showToast('Prodotto aggiunto al carrello');
            })
            .catch(err => {
                console.error("Errore fetch carrello:", err);
                showToast('Impossibile aggiungere il prodotto. Riprova.', 'error');
            });
    });
});
</script>

<jsp:include page="/fragments/footer.jsp" />