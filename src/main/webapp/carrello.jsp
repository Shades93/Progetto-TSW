<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<jsp:include page="/fragments/header.jsp">
    <jsp:param name="title" value="Il tuo Carrello - Tèrapia" />
    <jsp:param name="pageCss" value="carrello" />
</jsp:include>

<jsp:include page="/fragments/nav.jsp">
    <jsp:param name="page" value="carrello" />
</jsp:include>

<main class="container">
    <div class="cart-container">
        <h2 class="cart-title">Il tuo Carrello</h2>

        <c:if test="${not empty errorMessage}">
            <div class="alert-error">
                <c:out value="${errorMessage}"/>
            </div>
        </c:if>

        <c:choose>
            <c:when test="${empty carrello || empty carrello.items}">
                <div class="cart-empty">
                    <p>Il carrello è attualmente vuoto.</p>
                    <a href="${pageContext.request.contextPath}/catalogo" class="btn-catalog">
                        Scopri i nostri tè
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <table class="cart-table">
                    <thead>
                        <tr>
                            <th>Prodotto</th>
                            <th>Prezzo unitario</th>
                            <th class="col-center">Quantità</th>
                            <th class="col-right">Subtotale</th>
                            <th class="col-center">Azione</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${carrello.items}" var="item">
                            <tr>
                                <td class="cell-name">
                                    <strong><c:out value="${item.prodotto.nomeTe}"/></strong>
                                </td>
                                <td data-label="Prezzo unitario">
                                    <fmt:formatNumber value="${item.prodotto.prezzo}" type="currency" currencySymbol="€"/>
                                </td>
                                <td class="col-center" data-label="Quantità">
                                    <form action="${pageContext.request.contextPath}/carrello" method="post" class="form-update-qty" data-validate>
                                        <input type="hidden" name="csrf" value="${sessionScope.csrfToken}">
                                        <input type="hidden" name="action" value="update">
                                        <input type="hidden" name="id" value="${item.prodotto.idTe}">
                                        <input type="number" name="quantita" value="${item.quantita}" min="1" max="${item.prodotto.quantitaDisponibile}" class="input-qty">
                                        <button type="submit" title="Aggiorna quantità" class="btn-update">↺</button>
                                    </form>
                                </td>
                                <td class="col-right" data-label="Subtotale">
                                    <fmt:formatNumber value="${item.prodotto.prezzo * item.quantita}" type="currency" currencySymbol="€"/>
                                </td>
                                <td class="col-center" data-label="Rimuovi">
                                    <a href="${pageContext.request.contextPath}/carrello"
                                       data-post-url="${pageContext.request.contextPath}/carrello"
                                       data-fields="action=remove&amp;id=${item.prodotto.idTe}"
                                       class="btn-remove" title="Rimuovi prodotto">&times;</a>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>

                <div class="cart-footer">
                    <a href="${pageContext.request.contextPath}/carrello"
                       data-post-url="${pageContext.request.contextPath}/carrello"
                       data-fields="action=clear"
                       data-confirm="Sei sicuro di voler svuotare il carrello?"
                       class="btn-clear">
                       Svuota carrello
                    </a>

                    <div class="cart-summary">
                        <p class="cart-total">
                            Totale: <strong class="total-price"><fmt:formatNumber value="${carrello.totale}" type="currency" currencySymbol="€"/></strong>
                        </p>
                        
                        <form action="${pageContext.request.contextPath}/checkout" method="post" class="form-checkout" data-validate>
						    <input type="hidden" name="csrf" value="${sessionScope.csrfToken}">
						    <div>
						        <label for="indirizzo" style="display: block; font-weight: bold; margin-bottom: 4px;">Indirizzo di Spedizione:</label>
						        <input type="text" id="indirizzo" name="indirizzo" required maxlength="255"
							               pattern="(?=.*[A-Za-zÀ-ÿ])(?=.*[0-9]).{5,255}"
							               data-msg="Inserisci un indirizzo completo (via, civico, città, CAP)."
							               placeholder="Via, Civico, Città, CAP" style="width: 100%; padding: 8px; box-sizing: border-box;">
						    </div>
						    
						    <div>
						        <label for="metodoPagamento" style="display: block; font-weight: bold; margin-bottom: 4px;">Metodo di Pagamento:</label>
						        <select id="metodoPagamento" name="metodoPagamento" required style="width: 100%; padding: 8px; box-sizing: border-box;">
						            <option value="Carta di Credito (Visa)">Carta di Credito (Visa)</option>
						            <option value="Carta di Credito (Mastercard)">Carta di Credito (Mastercard)</option>
						            <option value="PayPal">PayPal</option>
						            <option value="Bonifico Bancario">Bonifico Bancario</option>
						        </select>
						    </div>
						
						    <button type="submit" class="btn-checkout" style="margin-top: 10px;">
						        Procedi al Checkout &rarr;
						    </button>
						</form>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</main>

<jsp:include page="/fragments/footer.jsp" />