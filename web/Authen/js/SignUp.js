function continueWithGoogle() {
    try {
        console.log('=== GOOGLE LOGIN DEBUG ===');
        console.log('Starting Google login process...');
        
        console.log('GOOGLE_CONFIG:', GOOGLE_CONFIG);
        console.log('GOOGLE_REGISTER_CONFIG:', GOOGLE_REGISTER_CONFIG);
        
        showLoading('google');

        const state = generateState();
        console.log('Generated state:', state);
        
        try {
            sessionStorage.setItem('oauth_state', state);
            console.log('SessionStorage set successfully');
        } catch (storageError) {
            console.error('SessionStorage error:', storageError);
        }

        const params = {
            scope: GOOGLE_CONFIG.scope,
            redirect_uri: GOOGLE_REGISTER_CONFIG.redirectUri,
            response_type: GOOGLE_CONFIG.responseType,
            client_id: GOOGLE_CONFIG.clientId,
            approval_prompt: GOOGLE_CONFIG.approvalPrompt,
            state: state
        };
        console.log('OAuth params:', params);

        const url = GOOGLE_CONFIG.authEndpoint + '?' + new URLSearchParams(params).toString();
        console.log('Final URL:', url);
        console.log('Attempting redirect...');
        
        window.location.href = url;
        
    } catch (error) {
        console.error('=== ERROR IN GOOGLE LOGIN ===');
        console.error('Error details:', error);
        console.error('Error stack:', error.stack);
        hideLoading('google');
        showError('Google register failed. Please try again.');
    }
}

// Thêm hàm kiểm tra khi trang load
window.addEventListener('DOMContentLoaded', function() {
    console.log('=== PAGE LOADED - CONFIG CHECK ===');
    console.log('GOOGLE_CONFIG exists:', typeof GOOGLE_CONFIG !== 'undefined');
    console.log('GOOGLE_REGISTER_CONFIG exists:', typeof GOOGLE_REGISTER_CONFIG !== 'undefined');
    
    if (typeof GOOGLE_CONFIG !== 'undefined') {
        console.log('Google Client ID:', GOOGLE_CONFIG.clientId);
        console.log('Google Auth Endpoint:', GOOGLE_CONFIG.authEndpoint);
    }
    
    // Kiểm tra button
    const googleBtn = document.querySelector('.social-btn.google');
    console.log('Google button found:', !!googleBtn);
    
    if (googleBtn) {
        console.log('Google button onclick:', googleBtn.getAttribute('onclick'));
    }
});

// Giữ nguyên các hàm khác
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
            button.innerHTML = '<i class="fab fa-google"></i> Continue with Google';
        } else if (buttonType === 'facebook') {
            button.innerHTML = '<i class="fab fa-facebook-f"></i> Continue with Facebook';
        }
    }
}

function showError(message) {
    let errorDiv = document.querySelector('.social-login-error');
    if (!errorDiv) {
        errorDiv = document.createElement('div');
        errorDiv.className = 'social-login-error';
        const socialButtons = document.querySelector('.social-login-col');
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