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

function continueWithFacebook() {
    try {
        console.log('=== FACEBOOK LOGIN DEBUG ===');
        console.log('Starting Facebook login process...');

        console.log('FACEBOOK_CONFIG:', FACEBOOK_CONFIG);
        console.log('FACEBOOK_REGISTER_CONFIG:', FACEBOOK_REGISTER_CONFIG);

        showLoading('facebook');

        const state = generateState();
        console.log('Generated state:', state);

        try {
            sessionStorage.setItem('oauth_state', state);
            console.log('SessionStorage set successfully');
        } catch (storageError) {
            console.error('SessionStorage error:', storageError);
        }

        const params = {
            scope: FACEBOOK_CONFIG.scope,
            redirect_uri: FACEBOOK_REGISTER_CONFIG.redirectUri,
            response_type: FACEBOOK_CONFIG.responseType,
            client_id: FACEBOOK_CONFIG.clientId,
            state: state
        };

        console.log('OAuth params:', params);

        const url = FACEBOOK_CONFIG.authEndpoint + '?' + new URLSearchParams(params).toString();
        console.log('Final URL:', url);
        console.log('Attempting redirect...');

        window.location.href = url;

    } catch (error) {
        console.error('=== ERROR IN FACEBOOK LOGIN ===');
        console.error('Error details:', error);
        console.error('Error stack:', error.stack);
        hideLoading('facebook');
        showError('Facebook register failed. Please try again.');
    }
}

// Thêm hàm kiểm tra khi trang load
window.addEventListener('DOMContentLoaded', function () {
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

// Function to validate email format
function isValidEmail(email) {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailRegex.test(email);
}

// Function to validate password strength
function isStrongPassword(password) {
    // At least 8 characters, 1 uppercase, 1 lowercase, 1 number, max 100 characters
    const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,100}$/;
    return passwordRegex.test(password);
}

// Function to show error message
function showError(elementId, message) {
    const element = document.getElementById(elementId);
    const errorDiv = document.createElement('div');
    errorDiv.className = 'error-message';
    errorDiv.textContent = message;
    
    // Remove any existing error message
    const existingError = element.parentElement.querySelector('.error-message');
    if (existingError) {
        existingError.remove();
    }
    
    element.parentElement.appendChild(errorDiv);
    element.classList.add('error');
}

// Function to clear error message
function clearError(elementId) {
    const element = document.getElementById(elementId);
    const errorDiv = element.parentElement.querySelector('.error-message');
    if (errorDiv) {
        errorDiv.remove();
    }
    element.classList.remove('error');
}

// Add form validation
document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('.signup-form');
    
    form.addEventListener('submit', function(event) {
        let isValid = true;
        
        // Get form values
        const username = document.getElementById('username').value.trim();
        const email = document.getElementById('email').value.trim();
        const password = document.getElementById('password').value;
        const repassword = document.getElementById('repassword').value;
        
        // Validate username
        if (username.length < 3) {
            showError('username', 'Username must be at least 3 characters long');
            isValid = false;
        } else {
            clearError('username');
        }
        
        // Validate email
        if (!isValidEmail(email)) {
            showError('email', 'Please enter a valid email address');
            isValid = false;
        } else {
            clearError('email');
        }
        
        // Validate password
        if (!isStrongPassword(password)) {
            showError('password', 'Password must be between 8 and 100 characters long and contain uppercase, lowercase, and numbers');
            isValid = false;
        } else {
            clearError('password');
        }
        
        // Validate password match
        if (password !== repassword) {
            showError('repassword', 'Passwords do not match');
            isValid = false;
        } else {
            clearError('repassword');
        }
        
        // Prevent form submission if validation fails
        if (!isValid) {
            event.preventDefault();
        }
    });
    
    // Add real-time validation on input
    const inputs = form.querySelectorAll('input');
    inputs.forEach(input => {
        input.addEventListener('input', function() {
            const value = this.value.trim();
            
            switch(this.id) {
                case 'username':
                    if (value.length < 3) {
                        showError('username', 'Username must be at least 3 characters long');
                    } else {
                        clearError('username');
                    }
                    break;
                    
                case 'email':
                    if (!isValidEmail(value)) {
                        showError('email', 'Please enter a valid email address');
                    } else {
                        clearError('email');
                    }
                    break;
                    
                case 'password':
                    if (!isStrongPassword(value)) {
                        showError('password', 'Password must be between 8 and 100 characters long and contain uppercase, lowercase, and numbers');
                    } else {
                        clearError('password');
                    }
                    break;
                    
                case 'repassword':
                    const password = document.getElementById('password').value;
                    if (value !== password) {
                        showError('repassword', 'Passwords do not match');
                    } else {
                        clearError('repassword');
                    }
                    break;
            }
        });
    });
});