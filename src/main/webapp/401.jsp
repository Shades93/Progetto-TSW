<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<% response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="title" value="401 - Non Autorizzato" />
</jsp:include>
<jsp:include page="/fragments/nav.jsp" />

<main class="container text-center">
    <div style="padding: 4rem 1rem; text-align: center;">
        <h1 style="font-size: 3rem; margin-bottom: 1rem; color: #2b4213;">401 - Accesso Negato</h1>
        <p style="font-size: 1.2rem; margin-bottom: 2rem; color: #555;">
            Non sei autenticato.<br>Questa pagina è riservata agli utenti registrati o con privilegi specifici.
        </p>
        <a href="${pageContext.request.contextPath}/login.jsp" class="btn-primary" style="display: inline-block; width: auto; padding: 0.8rem 1.6rem; text-decoration: none;">Vai al Login</a>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />