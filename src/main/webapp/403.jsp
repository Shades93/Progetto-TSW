<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<% response.setStatus(HttpServletResponse.SC_FORBIDDEN); %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="title" value="403 - Accesso Negato | Tèrapia" />
</jsp:include>

<jsp:include page="/fragments/nav.jsp" />

<main class="container text-center">
    <div style="padding: 4rem 1rem;">
        <h1 style="font-size: 3rem; margin-bottom: 1rem;">403 - Accesso Negato</h1>
        <p style="font-size: 1.2rem; margin-bottom: 2rem;">
            Non disponi delle autorizzazioni necessarie per visualizzare quest'area riservata.
        </p>
        <a href="${pageContext.request.contextPath}/catalogo" class="btn-primary">Torna al Catalogo</a>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />
