<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="main-nav">
    <ul class="nav-list">
    	<li class="${param.page == 'home' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/index.jsp" ${param.page == 'home' ? 'aria-current="page"' : ''}>
                Home
            </a>
        </li>
        <!-- Voci di navigazione a sinistra -->
        <li class="${param.page == 'catalogo' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/catalogo" ${param.page == 'catalogo' ? 'aria-current="page"' : ''}>
                Catalogo
            </a>
        </li>

        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <li class="${param.page == 'ordini' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/ordini" ${param.page == 'ordini' ? 'aria-current="page"' : ''}>
                        I miei ordini
                    </a>
                </li>

                <c:if test="${sessionScope.user.admin}">
                    <li class="admin-link ${param.page == 'admin-prodotti' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/admin/prodotti">Gestione Prodotti</a>
                    </li>
                    <li class="admin-link ${param.page == 'admin-ordini' ? 'active' : ''}">
                        <a href="${pageContext.request.contextPath}/admin/ordini">Gestione Ordini</a>
                    </li>
                </c:if>

                <li class="user-greeting">
				    <span class="user-pill">
				        <span class="user-icon">🌿</span> Ciao, <strong>${sessionScope.user.nome}</strong>
				    </span>
				</li>
                <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </c:when>

            <c:otherwise>
                <li class="nav-auth ${param.page == 'login' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/login.jsp" ${param.page == 'login' ? 'aria-current="page"' : ''}>
                        Accedi
                    </a>
                </li>
                <li class="${param.page == 'registrazione' ? 'active' : ''}">
                    <a href="${pageContext.request.contextPath}/registrazione.jsp" ${param.page == 'registrazione' ? 'aria-current="page"' : ''}>
                        Registrati
                    </a>
                </li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>