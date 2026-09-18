<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="title" value="Super User - Gestione Prodotti" />
    <jsp:param name="pageCss" value="admin" />
</jsp:include>

<jsp:include page="/fragments/nav.jsp">
    <jsp:param name="page" value="admin-prodotti" />
</jsp:include>

<jsp:include page="/fragments/barraAdmin.jsp" />

<main class="container admin-container">
    <div class="admin-header-bar">
        <div>
            <h2 class="admin-title">Area Riservata: Catalogo Prodotti</h2>
            <p class="admin-subtitle">Gestisci lo stock, aggiorna i prezzi o inserisci nuovi arrivi</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin/modificaProdotto.jsp" class="btn-primary">+ Inserisci Nuovo Prodotto</a>
    </div>

    
    <c:if test="${param.msg == 'deleted'}"><div class="admin-alert alert-danger">Prodotto eliminato con successo.</div></c:if>
    <c:if test="${param.msg == 'updated'}"><div class="admin-alert alert-success">Prodotto aggiornato correttamente.</div></c:if>
    <c:if test="${param.msg == 'inserted'}"><div class="admin-alert alert-success">Nuovo prodotto inserito a catalogo.</div></c:if>

    
    <div class="table-card">
        <table class="admin-table">
            <thead>
                <tr>
                    <th style="width: 60px;">ID</th>
                    <th>Prodotto</th>
                    <th>Categoria</th>
                    <th>Prezzo</th>
                    <th>IVA</th>
                    <th>Giacenza</th>
                    <th style="text-align: right;">Azioni</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="p" items="${prodotti}">
                    <tr>
                        <td class="cell-id">#${p.idTe}</td>
                        <td class="cell-product">
                            <strong>${p.nomeTe}</strong>
                        </td>
                        <td>
                            <span class="pill-category">${not empty p.nomeCategoria ? p.nomeCategoria : ('Cat #' += p.idCategoria)}</span>
                        </td>
                        <td class="cell-price">${p.priceCurrencyFormat}</td>
                        <td class="cell-iva">${p.iva}%</td>
                        <td>
                            <c:choose>
                                <c:when test="${p.quantitaDisponibile == 0}">
                                    <span class="stock-pill stock-out">Esaurito</span>
                                </c:when>
                                <c:when test="${p.quantitaDisponibile <= 5}">
                                    <span class="stock-pill stock-low">${p.quantitaDisponibile} pz</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="stock-pill stock-ok">${p.quantitaDisponibile} pz</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="cell-actions">
                            <a href="${pageContext.request.contextPath}/admin/prodotti?action=edit&id=${p.idTe}" class="btn-action btn-edit">Modifica</a>
                            <a href="${pageContext.request.contextPath}/admin/prodotti?action=delete&id=${p.idTe}" 
                               class="btn-action btn-delete"
                               onclick="return confirm('Sei sicuro di voler cancellare definitivamente questo prodotto? L\'operazione non è reversibile.');">Elimina</a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />