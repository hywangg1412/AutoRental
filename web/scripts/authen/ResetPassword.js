// Hàm kiểm tra password mạnh
function isStrongPassword(password) {
    const passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,100}$/;
    return passwordRegex.test(password);
}

// Hàm show lỗi dưới input (hỗ trợ input nằm trong .input-row)
function showError(input, message) {
    // input: DOM element
    let errorDiv;
    // Nếu input nằm trong .input-row thì chèn lỗi sau .input-row
    const inputRow = input.closest('.input-row');
    if (inputRow) {
        errorDiv = inputRow.parentElement.querySelector('.error-message');
        if (!errorDiv) {
            errorDiv = document.createElement('div');
            errorDiv.className = 'error-message';
            inputRow.parentElement.appendChild(errorDiv);
        }
    } else {
        errorDiv = input.parentElement.querySelector('.error-message');
        if (!errorDiv) {
            errorDiv = document.createElement('div');
            errorDiv.className = 'error-message';
            input.parentElement.appendChild(errorDiv);
        }
    }
    errorDiv.textContent = message;
    input.classList.add('input-invalid');
}

// Hàm clear lỗi
function clearError(input) {
    const inputRow = input.closest('.input-row');
    let errorDiv;
    if (inputRow) {
        errorDiv = inputRow.parentElement.querySelector('.error-message');
    } else {
        errorDiv = input.parentElement.querySelector('.error-message');
    }
    if (errorDiv) errorDiv.remove();
    input.classList.remove('input-invalid');
}

document.addEventListener('DOMContentLoaded', function() {
    const form = document.querySelector('.reset-form');
    if (!form) return;

    const newPasswordInput = form.querySelector('input[name="newPassword"]');
    const confirmPasswordInput = form.querySelector('input[name="confirmPassword"]');

    form.addEventListener('submit', function(e) {
        let isValid = true;
        // Validate new password
        if (!newPasswordInput.value.trim()) {
            showError(newPasswordInput, 'Password cannot be empty.');
            isValid = false;
        } else if (!isStrongPassword(newPasswordInput.value)) {
            showError(newPasswordInput, 'Password must be between 8 and 100 characters long and contain uppercase, lowercase, and numbers.');
            isValid = false;
        } else {
            clearError(newPasswordInput);
        }
        // Validate confirm password
        if (!confirmPasswordInput.value.trim()) {
            showError(confirmPasswordInput, 'Please confirm your password.');
            isValid = false;
        } else if (newPasswordInput.value !== confirmPasswordInput.value) {
            showError(confirmPasswordInput, 'Passwords do not match.');
            isValid = false;
        } else {
            clearError(confirmPasswordInput);
        }
        if (!isValid) e.preventDefault();
    });

    // Realtime validate
    newPasswordInput.addEventListener('input', function() {
        if (!this.value.trim()) {
            showError(this, 'Password cannot be empty.');
        } else if (!isStrongPassword(this.value)) {
            showError(this, 'Password must be between 8 and 100 characters long and contain uppercase, lowercase, and numbers.');
        } else {
            clearError(this);
        }
    });
    confirmPasswordInput.addEventListener('input', function() {
        if (!this.value.trim()) {
            showError(this, 'Please confirm your password.');
        } else if (this.value !== newPasswordInput.value) {
            showError(this, 'Passwords do not match.');
        } else {
            clearError(this);
        }
    });
});
