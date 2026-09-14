document.addEventListener("DOMContentLoaded", () => {
    const searchInput = document.getElementById("searchInput");
    const suggestionsBox = document.getElementById("searchSuggestions");

    if (!searchInput || !suggestionsBox) return;

    const contextPath = window.location.pathname.split('/')[1] ? ('/' + window.location.pathname.split('/')[1]) : '';
    let currentFocusIndex = -1;

    searchInput.addEventListener("input", () => {
        const query = searchInput.value.trim();
        currentFocusIndex = -1;

        if (query.length < 2) {
            suggestionsBox.innerHTML = "";
            suggestionsBox.style.display = "none";
            return;
        }

        fetch(`${contextPath}/search-suggestions?q=${encodeURIComponent(query)}`)
        .then(response => {
            if (!response.ok) throw new Error("Errore di rete");
            return response.json();
        })
        .then(data => {
            suggestionsBox.innerHTML = "";
            currentFocusIndex = -1;

            if (data.length === 0) {
                suggestionsBox.style.display = "none";
                return;
            }

            data.forEach(item => {
                const div = document.createElement("div");
                div.className = "suggestion-item";
                div.textContent = item.nome;
                div.dataset.id = item.id;

                div.style.padding = "0.6rem 1rem";
                div.style.cursor = "pointer";
                div.style.color = "#2b3a1a";
                div.style.borderBottom = "1px solid #eee";
                div.style.fontSize = "0.95rem";
                div.style.transition = "background-color 0.1s";

                div.addEventListener("mouseenter", () => {
                    removeHighlight();
                    div.style.backgroundColor = "#f1f6eb";
                });
                div.addEventListener("mouseleave", () => {
                    div.style.backgroundColor = "#ffffff";
                });

                div.addEventListener("click", () => {
                    window.location.href = `${contextPath}/prodotto?id=${item.id}`;
                });

                suggestionsBox.appendChild(div);
            });

            suggestionsBox.style.display = "block";
            suggestionsBox.style.position = "absolute";
            suggestionsBox.style.top = "calc(100% + 5px)";
            suggestionsBox.style.left = "0";
            suggestionsBox.style.width = "100%";
            suggestionsBox.style.minWidth = "220px";
            suggestionsBox.style.backgroundColor = "#ffffff";
            suggestionsBox.style.borderRadius = "8px";
            suggestionsBox.style.boxShadow = "0 4px 15px rgba(0,0,0,0.25)";
            suggestionsBox.style.zIndex = "10000";
            suggestionsBox.style.overflow = "hidden";
        })
        .catch(err => console.error("Errore AJAX:", err));
    });

    // Gestione navigazione con Frecce e Invio
    searchInput.addEventListener("keydown", (e) => {
        const items = suggestionsBox.querySelectorAll(".suggestion-item");
        if (!items || items.length === 0 || suggestionsBox.style.display === "none") return;

        if (e.key === "ArrowDown") {
            e.preventDefault();
            currentFocusIndex++;
            if (currentFocusIndex >= items.length) currentFocusIndex = 0;
            updateHighlight(items);
        } else if (e.key === "ArrowUp") {
            e.preventDefault();
            currentFocusIndex--;
            if (currentFocusIndex < 0) currentFocusIndex = items.length - 1;
            updateHighlight(items);
        } else if (e.key === "Enter") {
            e.preventDefault();
            if (currentFocusIndex > -1 && items[currentFocusIndex]) {
                items[currentFocusIndex].click();
            } else if (items.length > 0) {
                // Se premi Invio senza aver usato le frecce, seleziona il primo risultato
                items[0].click();
            }
        } else if (e.key === "Escape") {
            suggestionsBox.style.display = "none";
            currentFocusIndex = -1;
        }
    });

    function updateHighlight(items) {
        removeHighlight();
        if (currentFocusIndex > -1 && items[currentFocusIndex]) {
            items[currentFocusIndex].style.backgroundColor = "#e4eed7"; // Verde chiaro evidenziatore
            items[currentFocusIndex].scrollIntoView({ block: "nearest" });
        }
    }

    function removeHighlight() {
        const items = suggestionsBox.querySelectorAll(".suggestion-item");
        items.forEach(el => el.style.backgroundColor = "#ffffff");
    }

    // Nasconde se si clicca fuori
    document.addEventListener("click", (e) => {
        if (!searchInput.contains(e.target) && !suggestionsBox.contains(e.target)) {
            suggestionsBox.style.display = "none";
            currentFocusIndex = -1;
        }
    });
});