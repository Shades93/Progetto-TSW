<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="title" value="I Miei Ordini - Tèrapia" />
    <jsp:param name="pageCss" value="catalogo" />
</jsp:include>

<jsp:include page="/fragments/nav.jsp">
    <jsp:param name="page" value="ordini" />
</jsp:include>

<main class="container main-content orders-page">
    <div class="orders-header-bar">
        <div>
            <h2 class="orders-title">I miei Ordini</h2>
            <p class="orders-subtitle">Visualizza lo storico dei tuoi acquisti e scarica le ricevute</p>
        </div>
    </div>

    <c:choose>
        <c:when test="${empty ordini}">
            <div class="orders-empty-card">
                <div class="empty-icon">🍃</div>
                <h3>Nessun ordine trovato</h3>
                <p>Non hai ancora effettuato nessun ordine nel nostro shop.</p>
                <a href="${pageContext.request.contextPath}/catalogo" class="btn-orders-catalog">
                    Scopri il Catalogo
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="orders-table-card">
                <table class="orders-table">
                    <thead>
                        <tr>
                            <th style="width: 100px;">ID Ordine</th>
                            <th>Data</th>
                            <th>Totale</th>
                            <th>Stato</th>
                            <th style="text-align: right;">Documento</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ord" items="${ordini}">
                            <tr>
                                <td class="order-id">#${ord.id}</td>
                                <td class="order-date">
                                    <fmt:formatDate value="${ord.dataOrdine}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td class="order-total">
                                    € <fmt:formatNumber value="${ord.totale}" minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                                <td>
                                    <c:set var="statusClass" value="status-in-attesa" />
                                    <c:if test="${ord.stato == 'Completato' || ord.stato == 'Consegnato'}">
                                        <c:set var="statusClass" value="status-completato" />
                                    </c:if>
                                    <c:if test="${ord.stato == 'In elaborazione' || ord.stato == 'Spedito'}">
                                        <c:set var="statusClass" value="status-spedito" />
                                    </c:if>
                                    <c:if test="${ord.stato == 'Annullato'}">
                                        <c:set var="statusClass" value="status-annullato" />
                                    </c:if>

                                    <span class="order-status-pill ${statusClass}">
                                        ${ord.stato}
                                    </span>
                                </td>
                                <td style="text-align: right;">
                                    <a href="${pageContext.request.contextPath}/ordini?id=${ord.id}" class="btn-invoice">
                                        <span>Fattura</span> 🧾
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/fragments/footer.jsp" />
