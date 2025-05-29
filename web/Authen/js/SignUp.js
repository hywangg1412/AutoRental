function togglePassword(id, btn) {
    const eyeIcon = document.querySelector('.input-icon-eye i');
    const passwordInput = document.getElementById('password');
    const eyeSpan = document.querySelector('.input-icon-eye');

    if (eyeSpan) {
        eyeSpan.style.display = 'none';
    }

    if (passwordInput) {
        passwordInput.addEventListener('input', function () {
            if (this.value.length > 0) {
                eyeSpan.style.display = 'inline-flex';
            } else {
                eyeSpan.style.display = 'none';
                eyeIcon.classList.remove('fa-eye-slash');
                eyeIcon.classList.add('fa-eye');
            }
        });
    }

    if (eyeIcon && passwordInput && eyeSpan) {
        eyeSpan.addEventListener('click', function () {
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                eyeIcon.classList.remove('fa-eye');
                eyeIcon.classList.add('fa-eye-slash');
            } else {
                passwordInput.type = 'password';
                eyeIcon.classList.remove('fa-eye-slash');
                eyeIcon.classList.add('fa-eye');
            }
        });
    }
}

function loginWithGoogle() {
    const googleAuthUrl = 'https://accounts.google.com/o/oauth2/auth';
    const params = {
        scope: 'email profile openid',
        redirect_uri: 'http://localhost:8080/LoginEmail/login',
        response_type: 'code',
        client_id: '885594330359qiap8iobv2612lng4j4dertmkgd21164.apps.googleusercontent.com',
        approval_prompt: 'force'
    };

    const url = googleAuthUrl + '?' + new URLSearchParams(params).toString();

    window.location.href = url;
}