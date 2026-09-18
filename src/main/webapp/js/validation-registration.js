document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('registrationForm');
    if (!form) return;

    // Regole Regex
    const nameRegex = /^[A-Za-zÀ-ÿ\s']{2,40}$/;
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
	const passwordRegex = /^.{3,30}$/;

    // Riferimenti ai campi e agli span di errore
    const fields = {
        nome: {
            input: document.getElementById('nome'),
            error: document.getElementById('nomeError'),
            validate: val => nameRegex.test(val.trim()),
            message: 'Inserisci un nome valido (almeno 2 lettere, senza numeri).'
        },
        cognome: {
            input: document.getElementById('cognome'),
            error: document.getElementById('cognomeError'),
            validate: val => nameRegex.test(val.trim()),
            message: 'Inserisci un cognome valido (almeno 2 lettere, senza numeri).'
        },
        email: {
            input: document.getElementById('email'),
            error: document.getElementById('emailError'),
            validate: val => emailRegex.test(val.trim()),
            message: 'Formato email non valido (es. utente@dominio.it).'
        },
		password: {
		    input: document.getElementById('password'),
		    error: document.getElementById('passwordError'),
		    validate: val => passwordRegex.test(val),
		    message: 'La password deve contenere almeno 3 caratteri.'
		}
    };

    // Pulisce l'errore non appena l'utente digita
    Object.values(fields).forEach(item => {
        if (item.input) {
            item.input.addEventListener('input', function () {
                item.error.textContent = '';
                item.input.style.borderColor = '';
            });
        }
    });
	
	const passwordInput = document.getElementById('password');
	const confirmPasswordInput = document.getElementById('confirmPassword');
	const confirmPasswordError = document.getElementById('confirmPasswordError');

	// Controllo in tempo reale durante la digitazione
	if (confirmPasswordInput) {
	    confirmPasswordInput.addEventListener('input', function () {
	        if (this.value !== passwordInput.value) {
	            confirmPasswordError.textContent = 'Le password non coincidono.';
	            confirmPasswordError.style.color = '#b33927';
	            confirmPasswordInput.style.borderColor = '#b33927';
	        } else {
	            confirmPasswordError.textContent = '';
	            confirmPasswordInput.style.borderColor = '#2e7d32';
	        }
	    });
	}

    // Controllo al submit
    form.addEventListener('submit', function (e) {
        let firstInvalidField = null;

        // Valida ogni campo dall'alto verso il basso
        for (const key of Object.keys(fields)) {
            const item = fields[key];
            if (!item.input) continue;

            const isValid = item.validate(item.input.value);

            if (!isValid) {
                e.preventDefault();
                item.error.textContent = item.message;
                item.error.style.color = '#b33927';
                item.input.style.borderColor = '#b33927';

                if (!firstInvalidField) {
                    firstInvalidField = item.input;
                }
            }
        }
		
		if (confirmPasswordInput && confirmPasswordInput.value !== passwordInput.value) {
				    e.preventDefault();
				    confirmPasswordError.textContent = 'Le password non coincidono.';
				    confirmPasswordError.style.color = '#b33927';
				    confirmPasswordInput.style.borderColor = '#b33927';
				    if (!firstInvalidField) firstInvalidField = confirmPasswordInput;
				}

        // Imposta il focus sul primo campo errato
        if (firstInvalidField) {
            firstInvalidField.focus();
        }
    });
});