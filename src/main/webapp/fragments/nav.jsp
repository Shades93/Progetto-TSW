<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<nav class="main-nav">
    <ul>
        <li><a href="${pageContext.request.contextPath}/catalogo">Catalogo</a></li>
        <li><a href="${pageContext.request.contextPath}/carrello">Carrello (${sessionScope.carrello != null ? sessionScope.carrello.count : 0})</a></li>

        <c:choose>
            <c:when test="${not empty sessionScope.user}">
                <li><a href="${pageContext.request.contextPath}/ordini">I miei ordini</a></li>
                <c:if test="${sessionScope.user.admin}">
                    <li class="admin-link"><a href="${pageContext.request.contextPath}/admin/prodotti">Gestione Prodotti</a></li>
                    <li class="admin-link"><a href="${pageContext.request.contextPath}/admin/ordini">Gestione Ordini</a></li>
                </c:if>
                <li><span class="user-greeting">Ciao, ${sessionScope.user.nome}</span></li>
                <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </c:when>
            <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/login.jsp">Accedi</a></li>
                <li><a href="${pageContext.request.contextPath}/registrazione.jsp">Registrati</a></li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>