<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="title" value="Accedi - Tèrapia" />
    <jsp:param name="pageCss" value="login" />
</jsp:include>

<jsp:include page="/fragments/nav.jsp">
    <jsp:param name="page" value="login" />
</jsp:include>

<main class="container">
    <div class="auth-card">
        <h2>Accedi al tuo Account</h2>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="alert alert-success">${successMessage}</div>
        </c:if>
        <c:if test="${param.logout == 'true'}">
            <div class="alert alert-success">Sessione terminata con successo. A presto!</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" class="form-standard">
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email"
                       value="${not empty param.email ? param.email : email}"
                       placeholder="esempio@dominio.it" required autofocus>
            </div>

            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password"
                       placeholder="Inserisci la password" required>
            </div>

            <button type="submit" class="btn-primary">Accedi</button>
            <p class="form-footer-note">Non hai un account? <a href="${pageContext.request.contextPath}/registrazione.jsp">Registrati ora</a>.</p>
        </form>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />



