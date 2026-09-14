<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<% response.setStatus(HttpServletResponse.SC_NOT_FOUND); %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="title" value="404 - Non Trovato | Tèrapia" />
</jsp:include>
<jsp:include page="/fragments/nav.jsp" />

<main class="container text-center">
    <div style="padding: 4rem 1rem;">
        <h1 style="font-size: 3rem; margin-bottom: 1rem;">404 - Pagina Non Trovata</h1>
        <p style="font-size: 1.2rem; margin-bottom: 2rem;">Il prodotto o la pagina richiesta non esiste o è stata rimossa.</p>
        <a href="${pageContext.request.contextPath}/catalogo" class="btn-primary">Torna al Catalogo</a>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />
