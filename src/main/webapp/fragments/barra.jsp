<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="top-bar">
    <!-- Categorie/Filtri tè -->
    <div class="categorie-filtri">
	    <a href="${pageContext.request.contextPath}/catalogo" class="${empty categoriaSelezionata ? 'active' : ''}">Tutti</a>
	    <a href="${pageContext.request.contextPath}/catalogo?categoriaId=1" class="${categoriaSelezionata == 1 ? 'active' : ''}">Tè Verde</a>
	    <a href="${pageContext.request.contextPath}/catalogo?categoriaId=2" class="${categoriaSelezionata == 2 ? 'active' : ''}">Tè Nero</a>
	    <a href="${pageContext.request.contextPath}/catalogo?categoriaId=3" class="${categoriaSelezionata == 3 ? 'active' : ''}">Matcha</a>
	</div>
<div class="top-bar-actions">
    <!-- Barra di ricerca AJAX -->
    <div class="search-bar">
        <input type="text" id="searchInput" placeholder="Cerca" autocomplete="off">
        <div id="searchSuggestions" class="suggestions-box">
    </div>
    <a href="${pageContext.request.contextPath}/carrello.jsp" class="top-cart-btn" title="Visualizza Carrello">
    		<svg xmlns="http://www.w3.org/2000/svg" height="35px" viewBox="0 -960 960 960" width="35px" fill="currentColor">
                <path d="M223.5-103.5Q200-127 200-160t23.5-56.5Q247-240 280-240t56.5 23.5Q360-193 360-160t-23.5 56.5Q313-80 280-80t-56.5-23.5Zm400 0Q600-127 600-160t23.5-56.5Q647-240 680-240t56.5 23.5Q760-193 760-160t-23.5 56.5Q713-80 680-80t-56.5-23.5ZM246-720l96 200h280l110-200H246Zm-38-80h590q23 0 35 20.5t1 41.5L692-482q-11 20-29.5 31T622-440H324l-44 80h480v80H280q-45 0-68-39.5t-2-78.5l54-98-144-304H40v-80h130l38 80Zm134 280h280-280Z"/>
            </svg>
            <c:if test="${not empty sessionScope.carrello && sessionScope.carrello.count > 0}">
                <span class="cart-badge">${sessionScope.carrello.count}</span>
            </c:if>
            <!-- Fallback di test se il carrello non è ancora dinamico: -->
            <c:if test="${empty sessionScope.carrello}">
                <span class="cart-badge">4</span>
            </c:if>
        </a>
   </div>
</div>
</div>