<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="title" value="Tèrapia - Tè pregiati, con cura" />
    <jsp:param name="pageCss" value="index" />
</jsp:include>

<jsp:include page="/fragments/nav.jsp">
    <jsp:param name="page" value="home" />
</jsp:include>

<main class="container home-page">
    <section class="hero">
        <div class="hero-text">
            <p class="hero-eyebrow">Tèrapia</p>
            <h1 class="hero-title">Perché ogni tazza<br/>è un po' di terapia.</h1>
            <p class="hero-sub">
                Tè verdi, neri e matcha selezionati per qualità e provenienza, con le indicazioni
                di preparazione di ogni singola foglia: temperatura, tempo e dose giusti.
            </p>
            <div class="hero-actions">
                <a href="${pageContext.request.contextPath}/catalogo" class="btn-hero-primary">Scopri il Catalogo</a>
                <c:if test="${empty sessionScope.user}">
                    <a href="${pageContext.request.contextPath}/registrazione.jsp" class="btn-hero-secondary">Crea un account</a>
                </c:if>
            </div>
        </div>
        <div class="hero-image">
            <img src="${pageContext.request.contextPath}/immagini/home.jpg" alt="Tazza di tè verde con foglie di menta fresca">
        </div>
    </section>

    <section class="home-categories">
        <h2 class="section-title">Le nostre categorie</h2>
        <div class="category-grid">
            <a class="category-card" href="${pageContext.request.contextPath}/catalogo?categoriaId=1">
                <span class="category-icon" aria-hidden="true">🍵</span>
                <h3>Tè Verde</h3>
                <p>Non fermentati, ricchi di antiossidanti.</p>
            </a>
            <a class="category-card" href="${pageContext.request.contextPath}/catalogo?categoriaId=2">
                <span class="category-icon" aria-hidden="true">🫖</span>
                <h3>Tè Nero</h3>
                <p>Completamente ossidati, dal sapore deciso.</p>
            </a>
            <a class="category-card" href="${pageContext.request.contextPath}/catalogo?categoriaId=3">
                <span class="category-icon" aria-hidden="true">🥣</span>
                <h3>Matcha</h3>
                <p>La maggior percentuale di antiossidanti, in polvere finissima.</p>
            </a>
        </div>
    </section>

    <section class="home-features">
        <div class="feature">
            <h3>Provenienza tracciata</h3>
            <p>Ogni scheda prodotto indica da dove arriva il tè: Giappone, India e non solo.</p>
        </div>
        <div class="feature">
            <h3>Preparazione guidata</h3>
            <p>Temperatura, tempo di infusione e dose consigliata per ogni tè, scritti da chi lo conosce.</p>
        </div>
        <div class="feature">
            <h3>Giacenza reale</h3>
            <p>La disponibilità mostrata nel catalogo è aggiornata a ogni ordine: se la vedi, c'è in magazzino.</p>
        </div>
    </section>

    <section class="home-cta">
        <h2 class="section-title section-title-light">Pronto per la tua prima tazza?</h2>
        <a href="${pageContext.request.contextPath}/catalogo" class="btn-hero-primary btn-cta-light">Vai al Catalogo</a>
    </section>
</main>

<jsp:include page="/fragments/footer.jsp" />
