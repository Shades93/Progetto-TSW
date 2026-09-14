<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="title" value="Super User = Gestione Prodotti" />
    <jsp:param name="pageCss" value="admin" />
</jsp:include>

<jsp:include page="/fragments/nav.jsp">
    <jsp:param name="page" value="admin-prodotti" />
</jsp:include>

<main class="container">
    <div class="admin-topbar">
        <h2>Area Riservata: Catalogo Prodotti</h2>
        <a href="${pageContext.request.contextPath}/admin/modificaProdotto.jsp" class="btn-primary">+ Inserisci Nuovo Prodotto</a>
    </div>

    <c:if test="${param.msg == 'deleted'}"><div class="alert alert-success">Prodotto eliminato con successo.</div></c:if>
    <c:if test="${param.msg == 'updated'}"><div class="alert alert-success">Prodotto aggiornato correttamente.</div></c:if>
    <c:if test="${param.msg == 'inserted'}"><div class="alert alert-success">Nuovo prodotto inserito a catalogo.</div></c:if>

    <table class="data-table">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nome</th>
                <th>Categoria</th>
                <th>Prezzo</th>
                <th>IVA</th>
                <th>Giacenza</th>
                <th>Azioni</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="p" items="${prodotti}">
                <tr>
                    <td>${p.idTe}</td>
                    <td><strong>${p.nomeTe}</strong></td>
                    <td>${p.idCategoria}</td>
                    <td>${p.priceCurrencyFormat}</td>
                    <td>${p.iva}%</td>
                    <td>${p.quantitaDisponibile}</td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/prodotti?action=edit&id=${p.id}" class="btn-sm">Modifica</a>
                        <!-- Conferma di cancellazione obbligatoria da checklist -->
                        <a href="${pageContext.request.contextPath}/admin/prodotti?action=delete&id=${p.id}" 
                           class="btn-sm btn-danger"
                           onclick="return confirm('Sei sicuro di voler cancellare definitivamente questo prodotto? L\'operazione non è reversibile.');">Elimina</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</main>

<jsp:include page="/fragments/footer.jsp" />
