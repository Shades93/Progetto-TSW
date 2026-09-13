<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<nav class="main-nav">
    <ul class="nav-list">
        <li class="${param.page == 'catalogo' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/catalogo" ${param.page == 'catalogo' ? 'aria-current="page"' : ''}>
                Catalogo
            </a>
        </li>

        <li class="${param.page == 'carrello' ? 'active' : ''}">
            <a href="${pageContext.request.contextPath}/carrello" ${param.page == 'carrello' ? 'aria-current="page"' : ''}>
                Carrello (${sessionScope.carrello != null ? sessionScope.carrello.count : 0})
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

                <li><span class="user-greeting">Ciao, ${sessionScope.user.nome}</span></li>
                <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </c:when>

            <c:otherwise>
                <li class="${param.page == 'login' ? 'active' : ''}">
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
