// Avviso temporaneo in basso: window.showToast('testo', 'success' | 'error')
(function () {
    var DURATA_MS = 2800;
    var contenitore = null;

    window.showToast = function (messaggio, tipo) {
        if (!contenitore) {
            contenitore = document.createElement('div');
            contenitore.className = 'toast-container';
            contenitore.setAttribute('role', 'status');
            contenitore.setAttribute('aria-live', 'polite');
            document.body.appendChild(contenitore);
        }

        var toast = document.createElement('div');
        toast.className = 'toast toast-' + (tipo || 'success');
        toast.textContent = messaggio;
        contenitore.appendChild(toast);

        void toast.offsetWidth;
        toast.classList.add('toast-show');

        setTimeout(function () {
            toast.classList.remove('toast-show');
            setTimeout(function () {
                if (toast.parentNode) toast.parentNode.removeChild(toast);
            }, 300);
        }, DURATA_MS);
    };
})();
