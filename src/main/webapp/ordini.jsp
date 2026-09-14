<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="title" value="Admin - Gestione Ordini" />
    <jsp:param name="pageCss" value="admin" />
</jsp:include>

<jsp:include page="/fragments/nav.jsp">
    <jsp:param name="page" value="admin-ordini" />
</jsp:include>

<main class="container">
    <h2>Pannello Super User Elenco Ordini Complessivi</h2>

    <!-- Filtri richiesti da checklist -->
    <div class="filter-panel">
        <form action="${pageContext.request.contextPath}/admin/ordini" method="get" class="filter-form">
            <div class="filter-group">
                <label for="dataInizio">Da Data:</label>
                <input type="date" id="dataInizio" name="dataInizio" value="${param.dataInizio}">
            </div>
            <div class="filter-group">
                <label for="dataFine">A Data:</label>
                <input type="date" id="dataFine" name="dataFine" value="${param.dataFine}">
            </div>
            <div class="filter-group">
                <label for="clienteId">ID Cliente:</label>
                <input type="number" id="clienteId" name="clienteId" placeholder="Es. 3" value="${param.clienteId}">
            </div>
            <button type="submit" class="btn-primary">Applica Filtri</button>
            <a href="${pageContext.request.contextPath}/admin/ordini" class="btn-secondary">Reset</a>
        </form>
    </div>

    <table class="data-table">
        <thead>
            <tr>
                <th>ID Ordine</th>
                <th>Data Registrazione</th>
                <th>ID Cliente</th>
                <th>Totale</th>
                <th>IVA Applicata</th>
                <th>Stato</th>
                <th>Azioni</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="ord" items="${ordini}">
                <tr>
                    <td>#${ord.id}</td>
                    <td><fmt:formatDate value="${ord.dataOrdine}" pattern="dd/MM/yyyy HH:mm"/></td>
                    <td>${ord.userId}</td>
                    <td>€ <fmt:formatNumber value="${ord.totale}" minFractionDigits="2" maxFractionDigits="2"/></td>
                    <td>€ <fmt:formatNumber value="${ord.totaleIva}" minFractionDigits="2" maxFractionDigits="2"/></td>
                    <td><span class="badge-status">${ord.stato}</span></td>
                    <td>
                        <a href="${pageContext.request.contextPath}/ordini?id=${ord.id}" class="btn-sm">Fattura</a>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</main>

<jsp:include page="/fragments/footer.jsp" />
