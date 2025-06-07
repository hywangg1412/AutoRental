document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('.reset-form');
    if (!form) return;

    const errorDiv = form.querySelector('.form-error');

    function showError(msg) {
        if (errorDiv) {
            errorDiv.textContent = msg;
        }
    }

    function isStrongPassword(password) {
        const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,100}$/;
        return passwordRegex.test(password);
    }

    form.addEventListener('submit', function(e) {
        const newPassword = form.querySelector('input[name="newPassword"]');
        const confirmPassword = form.querySelector('input[name="confirmPassword"]');

        if (!newPassword.value.trim() || !confirmPassword.value.trim()) {
            showError('Password fields cannot be empty.');
            e.preventDefault();
            return;
        }
        if (!isStrongPassword(newPassword.value)) {
            showError('Password must be between 8 and 100 characters long and contain uppercase, lowercase, and numbers.');
            e.preventDefault();
            return;
        }
        if (newPassword.value !== confirmPassword.value) {
            showError('Passwords do not match.');
            e.preventDefault();
            return;
        }
        showError(''); // Xóa lỗi nếu hợp lệ
    });
});
