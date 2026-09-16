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

<jsp:include page="/fragments/barra.jsp" />

<main class="invoice-wrapper">
    <div class="no-print invoice-actions">
        <a href="${pageContext.request.contextPath}/ordini" class="btn-action btn-back">&larr; Torna agli Ordini</a>
        <button type="button" onclick="window.print();" class="btn-action btn-print">&#128438; Stampa Fattura</button>
    </div>

    <div class="invoice-box">
        <div class="invoice-header">
            <div class="invoice-brand">
                <h2>TÈRAPIA S.R.L.</h2>
                <p>Via Giovanni Paolo II, 132 &bull; 84084 Fisciano (SA)</p>
                <p>P.IVA: IT01234567890 &bull; info@terapia.it</p>
            </div>
            <div class="invoice-meta">
                <h3>FATTURA</h3>
                <div class="meta-num">Ordine #${ordine.idOrdine}</div>
                <div class="meta-num">
                    <fmt:formatDate value="${ordine.dataOrdine}" pattern="dd MMMM yyyy"/>
                </div>
            </div>
        </div>

        <div class="invoice-intro">
            <div>
                Gentile <strong>${sessionScope.user.nome} ${sessionScope.user.cognome}</strong>,<br>
                grazie per aver acquistato presso la nostra sala da tè.
            </div>
            <div style="text-align: right;">
                Stato Documento:<br>
                <strong style="color: #2f6448;">${ordine.stato}</strong>
            </div>
        </div>

        <table class="invoice-table">
            <thead>
                <tr>
                    <th>Descrizione Articolo</th>
                    <th class="col-center">Codice Tè</th>
                    <th class="col-center">Q.tà</th>
                    <th class="col-right">Prezzo Unit.</th>
                    <th class="col-right">Subtotale</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="item" items="${ordine.dettagli}">
                    <tr>
                        <td><strong>${item.nomeTe}</strong></td>
                        <td class="col-center item-id">#${item.idTe}</td>
                        <td class="col-center">${item.quantita}</td>
                        <td class="col-right">
                            <fmt:formatNumber value="${item.prezzoStorico}" type="currency" currencySymbol="€"/>
                        </td>
                        <td class="col-right">
                            <fmt:formatNumber value="${item.prezzoStorico * item.quantita}" type="currency" currencySymbol="€"/>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>

        <div class="invoice-summary">
            <table class="summary-table">
                <tr>
                    <td>Imponibile Netto</td>
                    <td>
                        <fmt:formatNumber value="${ordine.totale - ordine.totaleIva}" type="currency" currencySymbol="€"/>
                    </td>
                </tr>
                <tr>
                    <td>IVA (Inclusa)</td>
                    <td>
                        <fmt:formatNumber value="${ordine.totaleIva}" type="currency" currencySymbol="€"/>
                    </td>
                </tr>
                <tr>
                    <td>Spedizione</td>
                    <td>Gratuita</td>
                </tr>
                <tr class="row-total">
                    <td>Totale</td>
                    <td>
                        <fmt:formatNumber value="${ordine.totale}" type="currency" currencySymbol="€"/>
                    </td>
                </tr>
            </table>
        </div>

        <div class="invoice-footer-blocks">
            <div class="footer-block">
                <h5>Destinazione e Spedizione</h5>
                <p>
                    ${sessionScope.user.nome} ${sessionScope.user.cognome}<br>
                    ${ordine.indirizzoSpedizione}<br>
                    Email: ${sessionScope.user.email}
                </p>
            </div>
            <div class="footer-block">
                <h5>Dettagli Pagamento</h5>
                <p>
                    Metodo: <strong>${ordine.metodoPagamento}</strong><br>
                    Transazione: Eseguita con successo<br>
                    Ricevuta fiscale conforme Art. 22 D.P.R. 633/72
                </p>
            </div>
        </div>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />