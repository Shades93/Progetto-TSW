<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="title" value="I Miei Ordini - Tèrapia" />
    <jsp:param name="pageCss" value="ordini" />
</jsp:include>

<jsp:include page="/fragments/nav.jsp">
    <jsp:param name="page" value="ordini" />
</jsp:include>

<main class="container">
    <h2>I Miei Ordini</h2>

    <c:choose>
        <c:when test="${empty ordini}">
            <div class="empty-state" style="padding: 2rem 0;">
                <p>Non hai ancora effettuato nessun ordine. <a href="${pageContext.request.contextPath}/catalogo" class="btn-primary" style="display:inline-block; margin-left: 10px;">Inizia ora</a></p>
            </div>
        </c:when>
        <c:otherwise>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Numero Ordine</th>
                        <th>Data</th>
                        <th>Totale</th>
                        <th>Stato</th>
                        <th>Dettagli / Ricevuta</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="ord" items="${ordini}">
                        <tr>
                            <td>#${ord.id}</td>
                            <td><fmt:formatDate value="${ord.dataOrdine}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td>€ <fmt:formatNumber value="${ord.totale}" minFractionDigits="2" maxFractionDigits="2"/></td>
                            <td><span class="badge-status">${ord.stato}</span></td>
                            <td>
                                <a href="${pageContext.request.contextPath}/ordini?id=${ord.id}" class="btn-sm">Visualizza Fattura</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/fragments/footer.jsp" />
