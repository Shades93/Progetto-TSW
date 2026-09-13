<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tèrapia E-Commerce</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!--Codice per css specifici per ogni pagina-->
    <c:if test="${not empty param.pageCss}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/${param.pageCss}.css">
    </c:if>
</head>
<body>
<header class="main-header">
    <div class="logo">
        <a href="${pageContext.request.contextPath}/catalogo"><h1>Tèrapia</h1></a>
    </div>

    <!-- Barra di ricerca con AJAX e suggerimenti dinamici -->
    <div class="search-container">
        <input type="text" id="searchInput" placeholder="Cerca un tè..." autocomplete="off">
        <div id="searchSuggestions" class="suggestions-box"></div>
    </div>
</header>
