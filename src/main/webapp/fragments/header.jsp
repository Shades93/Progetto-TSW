<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <!-- Requisito checklist: Responsive design -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tea Time E-Commerce</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
<header class="main-header">
    <div class="logo">
        <a href="${pageContext.request.contextPath}/catalogo"><h1>Tea Time Shop</h1></a>
    </div>

    <!-- Barra di ricerca con AJAX e suggerimenti dinamici -->
    <div class="search-container">
        <input type="text" id="searchInput" placeholder="Cerca un tè..." autocomplete="off">
        <div id="searchSuggestions" class="suggestions-box"></div>
    </div>
</header>