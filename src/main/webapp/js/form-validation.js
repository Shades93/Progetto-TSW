// Validazione lato client dei form marcati con l'attributo data-validate.
(function () {
    'use strict';

    var MSG_EMAIL = 'Formato email non valido (es. utente@dominio.it).';
    var contatore = 0;

    function campiDi(form) {
        return Array.prototype.filter.call(form.elements, function (el) {
            return /^(INPUT|SELECT|TEXTAREA)$/.test(el.tagName)
                && !/^(hidden|submit|button|reset|image)$/.test(el.type)
                && !el.disabled;
        });
    }

    function isTestuale(el) {
        return el.tagName === 'TEXTAREA' || /^(text|search|tel|url|email|password)$/.test(el.type);
    }

    function errore(el) {
        if (el.type === 'file') {
            var file = el.files && el.files[0];
            if (!file) return el.required ? 'Seleziona un file.' : '';
            if (file.type.indexOf('image/') !== 0) return 'Seleziona un file immagine (JPG, PNG o GIF).';
            var max = parseInt(el.getAttribute('data-max-bytes'), 10);
            if (max && file.size > max) {
                return 'Immagine troppo grande (massimo ' + Math.round(max / 1048576) + ' MB).';
            }
            return '';
        }

        var v = el.validity;
        var obbligatorio = el.getAttribute('data-msg-required') || 'Campo obbligatorio.';

        // "   " passa il required nativo: lo trattiamo come vuoto
        if (el.required && isTestuale(el) && el.value.trim() === '') return obbligatorio;
        if (v.valueMissing) return obbligatorio;

        if (el.type === 'email' && (v.typeMismatch || v.patternMismatch)) return MSG_EMAIL;
        if (v.patternMismatch || v.typeMismatch) return el.getAttribute('data-msg') || 'Formato non valido.';
        if (v.badInput) return 'Inserisci un numero valido.';
        if (v.rangeUnderflow) return 'Il valore minimo è ' + el.min + '.';
        if (v.rangeOverflow) return 'Il valore massimo è ' + el.max + '.';
        if (v.stepMismatch) return 'Valore non valido.';
        if (v.tooShort) return 'Servono almeno ' + el.minLength + ' caratteri.';
        return '';
    }

    function slotDi(el) {
        if (el._slotErrore) return el._slotErrore;
        var slot = document.createElement('span');
        slot.className = 'error-inline field-error';
        slot.id = 'field-error-' + (++contatore);
        var gruppo = el.closest('.form-group');
        if (gruppo) gruppo.appendChild(slot);
        else el.insertAdjacentElement('afterend', slot);
        el._slotErrore = slot;
        return slot;
    }

    function mostra(el, messaggio) {
        var slot = (messaggio || el._slotErrore) ? slotDi(el) : null;
        if (messaggio) {
            slot.textContent = messaggio;
            el.classList.add('input-invalid');
            el.setAttribute('aria-invalid', 'true');
            el.setAttribute('aria-describedby', slot.id);
        } else if (slot) {
            slot.textContent = '';
            el.classList.remove('input-invalid');
            el.removeAttribute('aria-invalid');
            el.removeAttribute('aria-describedby');
        }
    }

    function valida(el) {
        var messaggio = errore(el);
        mostra(el, messaggio);
        return !messaggio;
    }

    function formValidato(el) {
        return el.form && el.form.hasAttribute('data-validate') ? el.form : null;
    }

    Array.prototype.forEach.call(document.querySelectorAll('form[data-validate]'), function (form) {
        form.noValidate = true;
    });

    // Fase di cattura: gira prima dei listener del form (per esempio il fetch dell'aggiunta al carrello)
    document.addEventListener('submit', function (e) {
        var form = e.target;
        if (!form.hasAttribute || !form.hasAttribute('data-validate')) return;

        var primoErrato = null;
        campiDi(form).forEach(function (el) {
            if (!valida(el) && !primoErrato) primoErrato = el;
        });

        if (primoErrato) {
            e.preventDefault();
            e.stopPropagation();
            primoErrato.focus();
        }
    }, true);

    function ricontrolla(e) {
        var el = e.target;
        if (formValidato(el) && el.getAttribute('aria-invalid') === 'true') valida(el);
    }
    document.addEventListener('input', ricontrolla);
    document.addEventListener('change', function (e) {
        var el = e.target;
        if (!formValidato(el)) return;
        if (el.type === 'file' || el.getAttribute('aria-invalid') === 'true') valida(el);
    });

    document.addEventListener('focusout', function (e) {
        var el = e.target;
        if (formValidato(el) && el.type !== 'file' && el.value !== '') valida(el);
    });
})();
