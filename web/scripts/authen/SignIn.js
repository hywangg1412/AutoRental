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

function showLoading(buttonType) {
    const button = document.querySelector(`.social-btn.${buttonType}`);
    if (button) {
        button.disabled = true;
        button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
    }
}

function hideLoading(buttonType) {
    const button = document.querySelector(`.social-btn.${buttonType}`);
    if (button) {
        button.disabled = false;
        if (buttonType === 'google') {
            button.innerHTML = '<i class="fab fa-google"></i> Login with Google';
        } else if (buttonType === 'facebook') {
            button.innerHTML = '<i class="fab fa-facebook-f"></i> Login with Facebook';
        }
    }
}

function loginWithGoogle() {
    try {
        showLoading('google');
        
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
        hideLoading('google');
        showError('Google login failed. Please try again.');
    }
}

function loginWithFacebook() {
    try {
        showLoading('facebook');
        
        const state = generateState();
        sessionStorage.setItem('oauth_state', state);
        
        const params = {
            client_id: FACEBOOK_CONFIG.clientId,
            redirect_uri: FACEBOOK_CONFIG.redirectUri,
            scope: FACEBOOK_CONFIG.scope,
            response_type: 'code',
            state: state
        };

        const url = FACEBOOK_CONFIG.authEndpoint + '?' + new URLSearchParams(params).toString();
        window.location.href = url;
    } catch (error) {
        console.error('Error during Facebook login:', error);
        hideLoading('facebook');
        showError('Facebook login failed. Please try again.');
    }
}

function showError(message) {
    let errorDiv = document.querySelector('.social-login-error');
    if (!errorDiv) {
        errorDiv = document.createElement('div');
        errorDiv.className = 'social-login-error';
        const socialButtons = document.querySelector('.social-login-row');
        socialButtons.parentNode.insertBefore(errorDiv, socialButtons.nextSibling);
    }
    errorDiv.textContent = message;
    errorDiv.style.display = 'block';
}

function hideError() {
    const errorDiv = document.querySelector('.social-login-error');
    if (errorDiv) {
        errorDiv.style.display = 'none';
    }
}

if (loginForm) {
    loginForm.addEventListener('submit', function() {
        if (loginBtn && loginSpinner && loginBtnText) {
            loginBtn.disabled = true;
            loginSpinner.classList.remove('d-none');
            loginBtnText.textContent = 'Loading...';
        }
    });
}