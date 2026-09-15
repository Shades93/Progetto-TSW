<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="title" value="Dettaglio Ordine #${ordine.idOrdine}" />
    <jsp:param name="pageCss" value="dettaglio-ordine" />
</jsp:include>

<jsp:include page="/fragments/nav.jsp">
    <jsp:param name="page" value="ordini" />
</jsp:include>

<main class="container">
    <div class="no-print actions-bar">
        <a href="${pageContext.request.contextPath}/ordini" class="link-back">&larr; Torna allo storico</a>
        <button onclick="window.print()" class="btn-primary">Stampa fattura</button>
    </div>

    <!-- Scheda Fattura Formattata -->
    <div class="invoice-card">
        <div class="invoice-header">
            <div>
                <h2>Invoice</h2>
                <p>Numero Ordine: <strong>#${not empty ordine.idOrdine ? ordine.idOrdine : ordine.id}</strong></p>
                <p>Data Emissione: <strong><fmt:formatDate value="${ordine.dataOrdine}" pattern="dd/MM/yyyy"/></strong></p>
            </div>
            <div class="invoice-seller">
                <h3>Tea Shop S.r.l.</h3>
                <p>Via Giovanni Paolo II, 132</p>
                <p>84084 Fisciano (SA)</p>
                <p>P.IVA: IT01234567890</p>
            </div>
        </div>

        <hr class="divider">

		<div class="invoice-customer">
		    <h4>Intestato a:</h4>
		    <p><strong>${sessionScope.user.nome} ${sessionScope.user.cognome}</strong></p>
		    <p>Email: ${sessionScope.user.email}</p>
		    <p>Indirizzo di Spedizione: ${ordine.indirizzoSpedizione}</p>
		</div>

        <table class="invoice-table">
            <thead>
                <tr>
                    <th>Articolo</th>
                    <th>Prezzo Storico</th>
                    <th>Aliquota IVA</th>
                    <th>Quantità</th>
                    <th>Totale Riga</th>
                </tr>
            </thead>
            <tbody>
               <c:forEach var="item" items="${ordine.dettagli}">
                    <tr>
                        <td>${item.nomeProdotto}</td>
                        <td>€ <fmt:formatNumber value="${item.prezzoUnitario}" minFractionDigits="2" maxFractionDigits="2"/></td>
                        <td>${item.iva}%</td>
                        <td>${item.quantita}</td>
                        <td>€ <fmt:formatNumber value="${item.subtotale}" minFractionDigits="2" maxFractionDigits="2"/></td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="invoice-totals">
            <p>Imponibile: € <fmt:formatNumber value="${ordine.totale - ordine.totaleIva}" minFractionDigits="2" maxFractionDigits="2"/></p>
            <p>Totale Imposta IVA: € <fmt:formatNumber value="${ordine.totaleIva}" minFractionDigits="2" maxFractionDigits="2"/></p>
            <h3>Totale Fattura: € <fmt:formatNumber value="${ordine.totale}" minFractionDigits="2" maxFractionDigits="2"/></h3>
        </div>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />
