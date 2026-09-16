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

<main class="container admin-container">
    <div class="admin-header-bar">
        <div>
            <h2 class="admin-title">Registro Ordini Complessivi</h2>
            <p class="admin-subtitle">Monitora le vendite, filtra per data o cerca gli ordini per utente</p>
        </div>
    </div>

    
    <div class="filter-card">
        <form action="${pageContext.request.contextPath}/admin/ordini" method="get" class="admin-filter-form">
            <div class="filter-field">
                <label for="dataInizio">Da Data</label>
                <input type="date" id="dataInizio" name="dataInizio" value="${param.dataInizio}">
            </div>
            
            <div class="filter-field">
                <label for="dataFine">A Data</label>
                <input type="date" id="dataFine" name="dataFine" value="${param.dataFine}">
            </div>
            
            <div class="filter-field">
                <label for="clienteId">ID Cliente</label>
                <input type="number" id="clienteId" name="clienteId" placeholder="Es. 3" min="1" value="${param.clienteId}">
            </div>

            <div class="filter-actions">
                <button type="submit" class="btn-primary">Filtra</button>
                <a href="${pageContext.request.contextPath}/admin/ordini" class="btn-secondary">Reset</a>
            </div>
        </form>
    </div>

    
    <div class="table-card">
        <table class="admin-table">
            <thead>
                <tr>
                    <th style="width: 80px;">ID Ordine</th>
                    <th>Data &amp; Ora</th>
                    <th>Cliente</th>
                    <th>Totale</th>
                    <th>IVA</th>
                    <th>Stato</th>
                    <th style="text-align: right;">Documento</th>
                </tr>
            </thead>
            <tbody>
                <c:choose>
                    <c:when test="${not empty ordini}">
                        <c:forEach var="ord" items="${ordini}">
                            <tr>
                                <td class="cell-id">#${ord.id}</td>
                                <td class="cell-date">
                                    <fmt:formatDate value="${ord.dataOrdine}" pattern="dd/MM/yyyy HH:mm"/>
                                </td>
                                <td>
                                    <span class="user-pill">Utente #${ord.userId}</span>
                                </td>
                                <td class="cell-price">
                                    € <fmt:formatNumber value="${ord.totale}" minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                                <td class="cell-iva">
                                    € <fmt:formatNumber value="${ord.totaleIva}" minFractionDigits="2" maxFractionDigits="2"/>
                                </td>
                                <td>
                                    <!-- Badge dinamico in base allo stato -->
                                    <span class="status-pill status-${ord.stato.toLowerCase()}">
                                        ${ord.stato}
                                    </span>
                                </td>
                                <td class="cell-actions">
                                    <a href="${pageContext.request.contextPath}/ordini?id=${ord.id}" class="btn-action btn-edit">
                                        Fattura 🧾
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <tr>
                            <td colspan="7" class="empty-table-msg">
                                Nessun ordine trovato con i criteri selezionati.
                            </td>
                        </tr>
                    </c:otherwise>
                </c:choose>
            </tbody>
        </table>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />