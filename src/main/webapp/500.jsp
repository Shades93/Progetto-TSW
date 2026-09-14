<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<% response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="title" value="500 - Errore Server | Tèrapia" />
</jsp:include>
<jsp:include page="/fragments/nav.jsp" />

<main class="container text-center">
    <div style="padding: 4rem 1rem;">
        <h1 style="font-size: 3rem; margin-bottom: 1rem;">500 - Errore del Server</h1>
        <p style="font-size: 1.2rem; margin-bottom: 2rem;">Si è verificata un'anomalia imprevista durante l'elaborazione dei dati.</p>
        <a href="${pageContext.request.contextPath}/catalogo" class="btn-primary">Torna alla Home</a>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />
