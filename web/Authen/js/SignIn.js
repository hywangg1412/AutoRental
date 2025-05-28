document.addEventListener('DOMContentLoaded', function () {
    const eyeIcon = document.querySelector('.input-icon-eye i');
    const passwordInput = document.getElementById('password');
    const eyeSpan = document.querySelector('.input-icon-eye');

    if (eyeSpan) {
        eyeSpan.style.display = 'none';
    }

    if (passwordInput) {
        passwordInput.addEventListener('input', function () {
            if (this.value.length > 0) {
                eyeSpan.style.display = 'inline-block';
            } else {
                eyeSpan.style.display = 'none';
            }
        });
    }

    if (eyeIcon && passwordInput && eyeSpan) {
        eyeSpan.addEventListener('click', function () {
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                eyeIcon.classList.remove('fa-regular fa-eye-slash');
                eyeIcon.classList.add('fa-regular fa-eye');
            } else {
                passwordInput.type = 'password';
                eyeIcon.classList.remove('fa-regular fa-eye');
                eyeIcon.classList.add('fa-regular fa-eye-slash');
            }
        });
    }
});

function generateState() {
    return Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
}


function showLoading() {
    const googleBtn = document.querySelector('.social-btn.google');
    if (googleBtn) {
        googleBtn.disabled = true;
        googleBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
    }
}

function hideLoading() {
    const googleBtn = document.querySelector('.social-btn.google');
    if (googleBtn) {
        googleBtn.disabled = false;
        googleBtn.innerHTML = '<i class="fab fa-google"></i> Login with Google';
    }
}

function loginWithGoogle() {
    try {
        showLoading();
        
        const state = generateState();
        sessionStorage.setItem('oauth_state', state);
        
        const params = {
            scope: GOOGLE_CONFIG.scope,
            redirect_uri: GOOGLE_CONFIG.redirectUri,
            response_type: GOOGLE_CONFIG.responseType,
            client_id: GOOGLE_CONFIG.clientId,
            approval_prompt: GOOGLE_CONFIG.approvalPrompt,
            state: state
        };

        const url = GOOGLE_CONFIG.authEndpoint + '?' + new URLSearchParams(params).toString();
        window.location.href = url;
    } catch (error) {
        console.error('Error during Google login:', error);
        hideLoading();
    }
}

function showError(message) {
    let errorDiv = document.querySelector('.google-login-error');
    if (!errorDiv) {
        errorDiv = document.createElement('div');
        errorDiv.className = 'google-login-error';
        const googleBtn = document.querySelector('.social-btn.google');
        googleBtn.parentNode.insertBefore(errorDiv, googleBtn.nextSibling);
    }
    errorDiv.textContent = message;
    errorDiv.style.display = 'block';
}

function hideError() {
    const errorDiv = document.querySelector('.google-login-error');
    if (errorDiv) {
        errorDiv.style.display = 'none';
    }
}