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
            <input type="hidden" name="csrf" value="${sessionScope.csrfToken}">
            <div class="form-group">
                <label for="nome">Nome:</label>
                <input type="text" id="nome" name="nome" value="<c:out value="${param.nome}"/>" placeholder="Es. Mario" required>
                <span id="nomeError" class="error-inline"></span>
            </div>

            <div class="form-group">
                <label for="cognome">Cognome:</label>
                <input type="text" id="cognome" name="cognome" value="<c:out value="${param.cognome}"/>" placeholder="Es. Rossi" required>
                <span id="cognomeError" class="error-inline"></span>
            </div>

            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" value="<c:out value="${param.email}"/>" placeholder="esempio@dominio.it" required>
                <span id="emailError" class="error-inline"></span>
            </div>

            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" placeholder="Almeno 3" required>
                <span id="passwordError" class="error-inline"></span>
            </div>
            
            <!-- CONFERMA PASSWORD -->
			<div class="form-group">
			    <label for="confirmPassword">Conferma Password:</label>
			    <input type="password" id="confirmPassword" name="confirmPassword" placeholder="Ripeti la password" required>
			    <span id="confirmPasswordError" class="error-inline"></span>
			</div>

            <div class="form-group">
			    <label for="numeroTelefono">Numero di Telefono:</label>
			    <div style="display: flex; gap: 8px;">
			        <select name="prefisso" id="prefisso" style="width: 35%; padding: 8px;">
			            <option value="+39" selected>🇮🇹 +39 (IT)</option>
			            <option value="+33">🇫🇷 +33 (FR)</option>
			            <option value="+49">🇩🇪 +49 (DE)</option>
			            <option value="+44">🇬🇧 +44 (UK)</option>
			            <option value="+1">🇺🇸 +1 (US)</option>
			        </select>
			        <input type="tel" id="numeroTelefono" name="numeroTelefono" 
			               pattern="[0-9]{8,12}" placeholder="Es. 3401234567" required 
			               style="flex: 1; padding: 8px;">
			    </div>
			</div>

            <button type="submit" class="btn-primary">Registrati</button>
            <p class="form-footer-note">Hai già un account? <a href="${pageContext.request.contextPath}/login.jsp">Accedi qui</a>.</p>
        </form>
    </div>
</main>

<script>
	document.addEventListener('DOMContentLoaded', function () {
	    const form = document.getElementById('registrationForm');
	    const emailInput = document.getElementById('email');
	    const emailFeedback = document.getElementById('emailError');
	    let isEmailAlreadyTaken = false;
	
	    if (!emailInput || !emailFeedback) return;
	
	    emailInput.addEventListener('blur', function () {
	        const emailVal = this.value.trim();
	        if (emailVal === '') {
	            emailFeedback.textContent = '';
	            emailInput.style.borderColor = '';
	            isEmailAlreadyTaken = false;
	            return;
	        }
	
	        fetch('${pageContext.request.contextPath}/check-email?email=' + encodeURIComponent(emailVal))
	            .then(res => res.json())
	            .then(data => {
	                if (data.exists) {
	                    isEmailAlreadyTaken = true;
	                    emailFeedback.textContent = 'Questa email è già registrata!';
	                    emailFeedback.style.color = '#b33927';
	                    emailInput.style.borderColor = '#b33927';
	                } else {
	                    isEmailAlreadyTaken = false;
	                    emailFeedback.textContent = 'Email disponibile';
	                    emailFeedback.style.color = '#2e7d32';
	                    emailInput.style.borderColor = '#2e7d32';
	                }
	            })
	            .catch(err => console.error('Errore controllo email:', err));
	    });
	
	    
	    if (form) {
	        form.addEventListener('submit', function (e) {
	            if (isEmailAlreadyTaken) {
	                e.preventDefault();
	                emailFeedback.textContent = 'Non puoi registrarti con un\'email già in uso!';
	                emailFeedback.style.color = '#b33927';
	                emailInput.focus();
	            }
	        });
	    }
	});
</script>
<script src="${pageContext.request.contextPath}/js/validation-registration.js"></script>

<jsp:include page="/fragments/footer.jsp" />
