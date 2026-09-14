<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="title" value="Registrati - Tèrapia" />
    <jsp:param name="pageCss" value="login" />
</jsp:include>

<jsp:include page="/fragments/nav.jsp">
    <jsp:param name="page" value="registrazione" />
</jsp:include>

<main class="container">
    <div class="auth-card">
        <h2>Registrazione Nuovo Account</h2>

        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger">${errorMessage}</div>
        </c:if>

        <form id="registrationForm" action="${pageContext.request.contextPath}/registrazione" method="post" class="form-standard">
            <div class="form-group">
                <label for="nome">Nome:</label>
                <input type="text" id="nome" name="nome" value="${param.nome}" placeholder="Es. Mario" required>
                <span id="nomeError" class="error-inline"></span>
            </div>

            <div class="form-group">
                <label for="cognome">Cognome:</label>
                <input type="text" id="cognome" name="cognome" value="${param.cognome}" placeholder="Es. Rossi" required>
                <span id="cognomeError" class="error-inline"></span>
            </div>

            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="${param.email}" placeholder="esempio@dominio.it" required>
                <span id="emailError" class="error-inline"></span>
            </div>

            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" placeholder="Almeno 8 caratteri con lettere e numeri" required>
                <span id="passwordError" class="error-inline"></span>
            </div>

            <div class="form-group">
                <label for="indirizzo">Indirizzo Spedizione:</label>
                <input type="text" id="indirizzo" name="indirizzo" value="${param.indirizzo}" placeholder="Via, Città, CAP" required>
            </div>

            <button type="submit" class="btn-primary">Registrati</button>
            <p class="form-footer-note">Hai già un account? <a href="${pageContext.request.contextPath}/login.jsp">Accedi qui</a>.</p>
        </form>
    </div>
</main>

<script src="${pageContext.request.contextPath}/js/validation-registration.js"></script>
<jsp:include page="/fragments/footer.jsp" />
