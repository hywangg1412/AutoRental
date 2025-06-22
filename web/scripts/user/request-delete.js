// Password visibility toggle
function togglePassword(fieldId) {
    const field = document.getElementById(fieldId);
    const button = field.nextElementSibling;
    const icon = button.querySelector('i');
    
    if (field.type === 'password') {
        field.type = 'text';
        icon.className = 'bi bi-eye-slash';
    } else {
        field.type = 'password';
        icon.className = 'bi bi-eye';
    }
}

// Confirmation text validation
function validateConfirmationText() {
    const input = document.getElementById('confirmationText');
    const expectedText = 'DELETE MY ACCOUNT';
    const isValid = input.value === expectedText;
    
    input.classList.remove('valid', 'invalid');
    if (input.value !== '') {
        input.classList.add(isValid ? 'valid' : 'invalid');
    }
    
    return isValid;
}

// Form validation
function validateForm() {
    const reason = document.getElementById('deletionReason').value;
    const password = document.getElementById('passwordConfirm').value;
    const confirmationText = validateConfirmationText();
    const dataCheck = document.getElementById('dataUnderstanding').checked;
    const bookingCheck = document.getElementById('bookingUnderstanding').checked;
    const finalCheck = document.getElementById('finalConfirmation').checked;
    
    console.log('Form validation:', {
        reason: reason,
        password: password ? 'filled' : 'empty',
        confirmationText: confirmationText,
        dataCheck: dataCheck,
        bookingCheck: bookingCheck,
        finalCheck: finalCheck
    });
    
    const isValid = reason !== '' && 
                   password !== '' && 
                   confirmationText &&
                   dataCheck && 
                   bookingCheck && 
                   finalCheck;
    
    console.log('Form is valid:', isValid);
    document.getElementById('deleteBtn').disabled = !isValid;
}

function showAlert(message, type) {
    console.log('Showing alert:', message, type);
    const alertContainer = document.getElementById('alertContainer');
    const alertClass = type === 'success' ? 'alert-success-custom' : 'alert-danger-custom';
    const icon = type === 'success' ? 'bi-check-circle' : 'bi-exclamation-triangle';
    
    alertContainer.innerHTML = `
        <div class="alert-custom ${alertClass}">
            <i class="bi ${icon} me-2"></i>${message}
        </div>
    `;
    
    // Auto-hide after 5 seconds
    setTimeout(() => {
        alertContainer.innerHTML = '';
    }, 5000);
}

// Test function for debugging
function testFunction() {
    console.log('Test function called');
    showAlert('JavaScript is working! This is a test message.', 'success');
    
    // Test form validation
    validateForm();
    
    // Test if all elements exist
    const elements = [
        'deletionReason',
        'passwordConfirm', 
        'confirmationText',
        'dataUnderstanding',
        'bookingUnderstanding',
        'finalConfirmation',
        'deleteBtn',
        'deletionForm'
    ];
    
    elements.forEach(id => {
        const element = document.getElementById(id);
        console.log(`${id}:`, element ? 'Found' : 'NOT FOUND');
    });
}

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM loaded, initializing form handlers');
    
    // Event listeners
    document.getElementById('deletionReason').addEventListener('change', validateForm);
    document.getElementById('passwordConfirm').addEventListener('input', validateForm);
    document.getElementById('confirmationText').addEventListener('input', function() {
        validateConfirmationText();
        validateForm();
    });
    document.getElementById('dataUnderstanding').addEventListener('change', validateForm);
    document.getElementById('bookingUnderstanding').addEventListener('change', validateForm);
    document.getElementById('finalConfirmation').addEventListener('change', validateForm);

    // Form submission
    document.getElementById('deletionForm').addEventListener('submit', function(e) {
        e.preventDefault();
        console.log('Form submitted');
        
        // Final confirmation dialog
        const confirmed = confirm(
            'This is your final warning!\\n\\n' +
            'Are you absolutely sure you want to delete your account?\\n\\n' +
            'This action is PERMANENT and CANNOT be undone.\\n\\n' +
            'Click OK to proceed with account deletion, or Cancel to abort.'
        );
        
        if (!confirmed) {
            console.log('User cancelled deletion');
            return;
        }
        
        console.log('User confirmed deletion, proceeding...');
        
        const deleteBtn = document.getElementById('deleteBtn');
        const originalText = deleteBtn.innerHTML;
        
        deleteBtn.disabled = true;
        deleteBtn.innerHTML = '<i class="bi bi-arrow-clockwise spin me-2"></i>Processing Deletion...';

        const formData = new URLSearchParams();
        formData.append('password', document.getElementById('passwordConfirm').value);
        formData.append('reason', document.getElementById('deletionReason').value);
        formData.append('comments', document.getElementById('additionalComments').value);

        // Get the context path dynamically
        const contextPath = window.location.pathname.split('/pages/')[0];
        const deleteUrl = contextPath + '/user/delete-user-account';
        
        console.log('Sending request to:', deleteUrl);
        console.log('Form data:', formData.toString());

        fetch(deleteUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData
        })
        .then(response => {
            console.log('Response status:', response.status);
            console.log('Response headers:', response.headers);
            
            if (!response.ok) {
                return response.json().then(err => { 
                    throw new Error(err.message || `Request failed with status ${response.status}`);
                });
            }
            return response.json();
        })
        .then(data => {
            console.log('Response data:', data);
            
            if (data.status === 'success') {
                showAlert(data.message, 'success');
                document.getElementById('deletionForm').reset();
                document.getElementById('confirmationText').classList.remove('valid', 'invalid');
                deleteBtn.innerHTML = '<i class="bi bi-check-circle me-2"></i>Account Deleted';
                deleteBtn.disabled = true;

                setTimeout(() => {
                    window.location.href = contextPath + '/pages/authen/SignIn.jsp';
                }, 3000);
            } else {
                showAlert(data.message || 'An unknown error occurred.', 'danger');
                deleteBtn.disabled = false;
                deleteBtn.innerHTML = originalText;
            }
        })
        .catch(error => {
            console.error('Error:', error);
            showAlert(error.message || 'A network or server error occurred. Please try again.', 'danger');
            deleteBtn.disabled = false;
            deleteBtn.innerHTML = originalText;
        });
    });

    // Show additional fields for "Other" reason
    document.getElementById('deletionReason').addEventListener('change', function() {
        const commentsGroup = document.getElementById('additionalComments').closest('.form-group');
        const label = commentsGroup.querySelector('label');
        
        if (this.value === 'other') {
            label.innerHTML = 'Please specify your reason *';
            document.getElementById('additionalComments').required = true;
        } else {
            label.innerHTML = 'Additional comments (optional)';
            document.getElementById('additionalComments').required = false;
        }
    });

    // Add CSS for spin animation
    const style = document.createElement('style');
    style.textContent = `
        .spin {
            animation: spin 1s linear infinite;
        }
        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
    `;
    document.head.appendChild(style);
    
    console.log('Form handlers initialized successfully');
});
