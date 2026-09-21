// Link che eseguono un'operazione con una richiesta POST (con token anti-CSRF).
// Uso: <a href="..." data-post-url="/app/carrello" data-fields="action=remove&id=3" data-confirm="Sei sicuro?">
document.addEventListener("click", (e) => {
    const link = e.target.closest("a[data-post-url]");
    if (!link) return;
    e.preventDefault();

    const messaggio = link.dataset.confirm;
    if (messaggio && !window.confirm(messaggio)) return;

    const form = document.createElement("form");
    form.method = "post";
    form.action = link.dataset.postUrl;

    const campi = new URLSearchParams(link.dataset.fields || "");
    const meta = document.querySelector('meta[name="csrf-token"]');
    if (meta) campi.set("csrf", meta.content);

    campi.forEach((valore, nome) => {
        const input = document.createElement("input");
        input.type = "hidden";
        input.name = nome;
        input.value = valore;
        form.appendChild(input);
    });

    document.body.appendChild(form);
    form.submit();
});
