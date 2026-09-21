<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="title" value="Ordine Confermato - Tèrapia" />
    <jsp:param name="pageCss" value="dettaglio-ordine" />
</jsp:include>

<jsp:include page="/fragments/nav.jsp">
    <jsp:param name="page" value="ordini" />
</jsp:include>

<main class="container text-center">
    <div class="confirmation-box">
        <div class="confirm-icon">✓</div>
        <h2 class="text-success">Ordine Confermato!</h2>

        <c:choose>
            <c:when test="${not empty orderId}">
                <p>Grazie per il tuo acquisto. Il tuo ordine è stato registrato nel nostro database con codice identificativo:</p>
                <h1 class="order-number">#${orderId}</h1>
                <p>Tutti gli articoli del carrello sono stati riservati e la spedizione è in preparazione.</p>

                <div class="confirmation-actions">
                    <a href="${pageContext.request.contextPath}/ordini?id=${orderId}" class="btn-primary">Visualizza Ricevuta / Fattura</a>
                    <a href="${pageContext.request.contextPath}/catalogo" class="btn-secondary">Torna allo shopping</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-warning" style="margin-top: 1.5rem;">
                    Non risulta alcun nuovo ordine da confermare.
                    <br><br>
                    <a href="${pageContext.request.contextPath}/ordini" class="btn-primary">Consulta lo storico ordini</a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />
