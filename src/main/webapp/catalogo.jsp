<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="title" value="I Nostri Tè - Catalogo" />
    <jsp:param name="pageCss" value="catalogo" />
</jsp:include>

<jsp:include page="/fragments/nav.jsp">
    <jsp:param name="page" value="catalogo" />
</jsp:include>

<jsp:include page="/fragments/barra.jsp" />

<main class="container">
    <h2>I Nostri Prodotti</h2>

    <c:if test="${not empty param.msg}">
        <div class="alert alert-success">Operazione completata con successo!</div>
    </c:if>

    <div class="product-grid">
        <c:forEach var="p" items="${prodotti}">
            <div class="product-card">
                <img src="${pageContext.request.contextPath}/images/${p.immagine != null && !p.immagine.isEmpty() ? p.immagine : 'default.jpg'}" alt="${p.nome}" class="product-thumb">
                <h3>${p.nome}</h3>
                <p class="product-category">${p.idCategoria}</p>
                <p class="product-price">${p.prezzo}</p>
                
                <div class="card-actions">
                    <a href="${pageContext.request.contextPath}/prodotto?id=${p.id}" class="btn-secondary">Dettagli</a>
                    <c:choose>
                        <c:when test="${p.quantitaDisponibile > 0}">
                            <a href="${pageContext.request.contextPath}/carrello?action=add&id=${p.id}&quantita=1" class="btn-primary">Aggiungi</a>
                        </c:when>
                        <c:otherwise>
                            <span class="badge-soldout">Esaurito</span>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </c:forEach>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />
