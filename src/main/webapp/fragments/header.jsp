<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><c:out value="${empty param.title ? 'Tèrapia' : param.title}"/></title>
    <meta name="csrf-token" content="${sessionScope.csrfToken}">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <!--Codice per css specifici per ogni pagina-->
    <c:if test="${not empty param.pageCss}">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/<c:out value="${param.pageCss}"/>.css">
    </c:if>
</head>
<body>
	<header class="main-header">
	    <div class="logo">
	    	<h1>
	    		<a href="${pageContext.request.contextPath}/index.jsp">Tèrapia</a>
	    		<img src="${pageContext.request.contextPath}/immagini/logo.png" alt="Logo" class="site-logo">
	    	</h1> 
	    </div>
	</header>


