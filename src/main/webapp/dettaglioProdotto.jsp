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
                        <img src="${pageContext.request.contextPath}/immagini/${prodotto.id}_1.jpg" alt="${prodotto.nome}">
                        <img src="${pageContext.request.contextPath}/immagini/${prodotto.id}_2.jpg" alt="${prodotto.nome}">
                        <img src="${pageContext.request.contextPath}/immagini/${prodotto.id}_3.jpg" alt="${prodotto.nome}">
                        <img src="${pageContext.request.contextPath}/immagini/${prodotto.id}_4.jpg" alt="${prodotto.nome}">
                    </div>
                </div>

                <div class="img-select">
                    <div class="img-item">
                        <a href="javascript:void(0)" data-id="1">
                            <img src="${pageContext.request.contextPath}/immagini/${prodotto.id}_1.jpg" alt="${prodotto.nome}">
                        </a>
                    </div>
                    <div class="img-item">
                        <a href="javascript:void(0)" data-id="2">
                            <img src="${pageContext.request.contextPath}/immagini/${prodotto.id}_2.jpg" alt="${prodotto.nome}">
                        </a>
                    </div>
                    <div class="img-item">
                        <a href="javascript:void(0)" data-id="3">
                            <img src="${pageContext.request.contextPath}/immagini/${prodotto.id}_3.jpg" alt="${prodotto.nome}">
                        </a>
                    </div>
                    <div class="img-item">
                        <a href="javascript:void(0)" data-id="4">
                            <img src="${pageContext.request.contextPath}/immagini/${prodotto.id}_4.jpg" alt="${prodotto.nome}">
                        </a>
                    </div>
                </div>
            </div>

            <!-- Contenuto Prodotto -->
            <div class="product-content">
                <h2 class="product-title">${prodotto.nome}</h2>
                <span class="product-category-tag">Categoria: #${prodotto.idCategoria}</span>

                <div class="product-price">
                    <p class="new-price">Prezzo: <span>${prodotto.priceCurrencyFormat}</span> <small>(IVA ${prodotto.iva}% inclusa)</small></p>
                </div>

                <div class="product-detail">
                    <h3>Descrizione e Preparazione</h3>
                    <div class="product-desc-text">
                        ${prodotto.descrizione}
                    </div>
                    <p class="stock-info">Disponibilità a magazzino: <strong>${prodotto.quantitaDisponibile}</strong> pezzi</p>
                </div>

                <div class="purchase-info">
                    <c:choose>
                        <c:when test="${prodotto.quantitaDisponibile > 0}">
                            <form action="${pageContext.request.contextPath}/carrello" method="get" class="form-add-detail">
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

<jsp:include page="/fragments/footer.jsp" />