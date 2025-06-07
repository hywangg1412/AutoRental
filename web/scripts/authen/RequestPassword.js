function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('.forgot-form');
    const emailInput = document.getElementById('email');

    form.addEventListener('submit', function(e) {
        let serverErrorDiv = document.querySelector('.error-message');
        if (serverErrorDiv && serverErrorDiv.textContent.trim() !== '') {
            return;
        }
        const email = emailInput.value.trim();
        let error = '';
        if (!email) {
            error = 'Please enter your email address.';
        } else if (!isValidEmail(email)) {
            error = 'Please enter a valid email address.';
        }
        let errorDiv = emailInput.parentElement.querySelector('.error-message');
        if (error) {
            e.preventDefault();
            if (!errorDiv) {
                errorDiv = document.createElement('div');
                errorDiv.className = 'error-message';
                emailInput.parentElement.appendChild(errorDiv);
            }
            errorDiv.textContent = error;
            errorDiv.style.display = 'block';
            emailInput.classList.add('error');
        } else {
            if (errorDiv) {
                errorDiv.remove();
            }
            emailInput.classList.remove('error');
        }
    });

    emailInput.addEventListener('input', function() {
        let serverErrorDiv = document.querySelector('.error-message');
        if (serverErrorDiv && serverErrorDiv.parentElement !== emailInput.parentElement) {
            serverErrorDiv.style.display = 'none';
        }
        const email = emailInput.value.trim();
        let error = '';
        if (!email) {
            error = 'Please enter your email address.';
        } else if (!isValidEmail(email)) {
            error = 'Please enter a valid email address.';
        }
        let errorDiv = emailInput.parentElement.querySelector('.error-message');
        if (error) {
            if (!errorDiv) {
                errorDiv = document.createElement('div');
                errorDiv.className = 'error-message';
                emailInput.parentElement.appendChild(errorDiv);
            }
            errorDiv.textContent = error;
            errorDiv.style.display = 'block';
            emailInput.classList.add('error');
        } else {
            if (errorDiv) {
                errorDiv.remove();
            }
            emailInput.classList.remove('error');
        }
    });
});
