// Unified Error Display System
class ErrorDisplayManager {
    constructor() {
        this.animationClasses = ['animate__animated', 'animate__fadeInDown'];
        this.errorStyles = {
            fontFamily: 'Poppins, Arial, sans-serif',
            fontSize: '0.78rem',
            fontWeight: '500',
            display: 'block'
        };
    }

    // Show error with animation
    showError(input, errorDiv, message) {
        if (!input || !errorDiv) return;
        
        // Style input as invalid
        input.classList.add('is-invalid', 'input-error');
        
        // Set error message and styles
        errorDiv.textContent = message;
        errorDiv.classList.add('text-danger', 'show', ...this.animationClasses);
        
        // Apply styles
        Object.assign(errorDiv.style, this.errorStyles);
        
        // Reset animation for replay
        this.resetAnimation(errorDiv);
    }

    // Clear error with animation
    clearError(input, errorDiv) {
        if (!input || !errorDiv) return;
        
        input.classList.remove('is-invalid', 'input-error');
        errorDiv.classList.remove('show', ...this.animationClasses);
        
        setTimeout(() => {
            errorDiv.textContent = '';
            errorDiv.style.display = 'none';
        }, 250);
    }

    // Reset animation for replay
    resetAnimation(element) {
        element.classList.remove(...this.animationClasses);
        void element.offsetWidth; // Force reflow
        element.classList.add(...this.animationClasses);
    }

    // Batch clear errors
    clearAllErrors(errorElements) {
        errorElements.forEach(errorDiv => {
            errorDiv.textContent = '';
            errorDiv.classList.remove('text-danger', 'show', ...this.animationClasses);
            errorDiv.style.display = 'none';
        });
    }
}

// Validation Rules
const ValidationRules = {
    username: {
        required: 'Username cannot be empty.',
        length: 'Username must be 3-30 characters.',
        format: 'Username must not contain special characters and can include Vietnamese letters.',
        pattern: /^[\p{L}0-9 ]+$/u
    },
    licenseNumber: {
        required: 'License number is required',
        format: 'License number must be exactly 12 digits and contain only numbers',
        pattern: /^[0-9]{12}$/,
        inputPattern: /[0-9]/
    },
    fullName: {
        required: 'Full name is required',
        format: 'Full name must not contain special characters or numbers',
        pattern: /^[\p{L} ]+$/u,
        inputPattern: /[a-zA-Z\p{L}\sÀ-ỹà-ỹ]/u
    },
    dob: {
        required: 'Date of birth is required',
        future: 'Date of birth cannot be in the future',
        age: 'You must be at least 18 years old'
    },
    gender: {
        required: 'Gender is required.'
    }
};

// Validation Functions
class ValidationManager {
    constructor(errorManager) {
        this.errorManager = errorManager;
    }

    validateUsername(value) {
        const rules = ValidationRules.username;
        
        if (!value) return rules.required;
        if (value.length < 3 || value.length > 30) return rules.length;
        if (!rules.pattern.test(value)) return rules.format;
        
        return null;
    }

    validateLicenseNumber(value) {
        const rules = ValidationRules.licenseNumber;
        
        if (!value) return rules.required;
        if (!rules.pattern.test(value)) return rules.format;
        
        return null;
    }

    validateFullName(value) {
        const rules = ValidationRules.fullName;
        
        if (!value) return rules.required;
        if (!rules.pattern.test(value)) return rules.format;
        
        return null;
    }

    validateDateOfBirth(value) {
        const rules = ValidationRules.dob;
        
        if (!value) return rules.required;
        
        const birthDate = new Date(value);
        const today = new Date();
        
        if (birthDate > today) return rules.future;
        
        const age = this.calculateAge(birthDate, today);
        if (age < 18) return rules.age;
        
        return null;
    }

    validateGender(value) {
        if (!value || (value !== 'Male' && value !== 'Female')) {
            return ValidationRules.gender.required;
        }
        return null;
    }

    calculateAge(birthDate, today) {
        let age = today.getFullYear() - birthDate.getFullYear();
        const monthDiff = today.getMonth() - birthDate.getMonth();
        
        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birthDate.getDate())) {
            age--;
        }
        
        return age;
    }

    // Real-time validation for specific input
    validateInput(input, errorDiv, validationType) {
        const value = input.value.trim();
        let error = null;

        switch (validationType) {
            case 'username':
                error = this.validateUsername(value);
                break;
            case 'licenseNumber':
                error = this.validateLicenseNumber(value);
                break;
            case 'fullName':
                error = this.validateFullName(value);
                break;
            case 'dob':
                error = this.validateDateOfBirth(value);
                break;
            case 'gender':
                error = this.validateGender(value);
                break;
        }

        if (error) {
            this.errorManager.showError(input, errorDiv, error);
            return false;
        } else {
            this.errorManager.clearError(input, errorDiv);
            return true;
        }
    }
}

// Initialize managers
const errorManager = new ErrorDisplayManager();
const validationManager = new ValidationManager(errorManager);

// Input Restrictions
class InputRestrictions {
    static setupNumericInput(input, errorDiv, maxLength = 12) {
        input.addEventListener('keydown', function(e) {
            // Chỉ cho nhập số, các phím điều hướng, xóa, tab
            const allowedKeys = ['Backspace', 'Delete', 'ArrowLeft', 'ArrowRight', 'Tab'];
            if (!e.ctrlKey && !e.metaKey && !e.altKey && 
                e.key.length === 1 && !/[0-9]/.test(e.key)) {
                e.preventDefault();
                errorManager.showError(input, errorDiv, 'Only digits are allowed');
            }
            // Nếu đã đủ maxLength và không phải phím xóa, điều hướng thì chặn
            if (
                this.value.length >= maxLength &&
                !allowedKeys.includes(e.key) &&
                // Nếu bôi đen 1 phần để ghi đè thì vẫn cho nhập
                !(typeof this.selectionStart === 'number' && typeof this.selectionEnd === 'number' && this.selectionStart !== this.selectionEnd)
            ) {
                e.preventDefault();
            }
        });

        input.addEventListener('input', function() {
            let cleanValue = this.value.replace(/[^0-9]/g, '');
            if (cleanValue.length > maxLength) {
                cleanValue = cleanValue.slice(0, maxLength);
            }
            if (this.value !== cleanValue) {
                this.value = cleanValue;
            }
            const errorMsg = validationManager.validateLicenseNumber(this.value.trim());
            if (errorMsg) {
                errorManager.showError(input, errorDiv, errorMsg);
            } else {
                errorManager.clearError(input, errorDiv);
            }
        });
    }

    static setupTextInput(input, errorDiv) {
        input.addEventListener('keydown', function(e) {
            if (
                !e.ctrlKey && !e.metaKey && !e.altKey &&
                e.key.length === 1 && !e.key.match(/[a-zA-Z\p{L}\sÀ-ỹà-ỹ]/u)
            ) {
                e.preventDefault();
                errorManager.showError(input, errorDiv, 'Full name can only contain letters and spaces');
            }
        });

        input.addEventListener('input', function() {
            let cleanValue = this.value.replace(/[^a-zA-Z\sÀ-ỹà-ỹ]/g, '');
            if (this.value !== cleanValue) {
                this.value = cleanValue;
            }
            const errorMsg = validationManager.validateFullName(this.value.trim());
            if (errorMsg) {
                errorDiv.classList.remove('animate__fadeInDown');
                errorDiv.classList.add('animate__slideInLeft'); // hoặc class bạn muốn
                errorManager.showError(input, errorDiv, errorMsg);
            } else {
                errorManager.clearError(input, errorDiv);
            }
        });

        input.addEventListener('blur', function() {
            // Validate lại khi blur
            const errorMsg = validationManager.validateFullName(this.value.trim());
            if (errorMsg) {
                errorManager.showError(input, errorDiv, errorMsg);
            } else {
                errorManager.clearError(input, errorDiv);
            }
        });
    }
}

// Enhanced form validation
function validateForm(form, validationRules) {
    const errors = errorManager.clearAllErrors(form.querySelectorAll('.text-danger'));
    let hasError = false;

    validationRules.forEach(rule => {
        const input = form.querySelector(`[name="${rule.field}"]`);
        const errorDiv = form.querySelector(`#${rule.field}Error`) || 
                        input.parentElement.querySelector('.text-danger');
        
        if (!validationManager.validateInput(input, errorDiv, rule.type)) {
            hasError = true;
        }
    });

    return !hasError;
}

// Main initialization
document.addEventListener('DOMContentLoaded', function() {
    let isEditingUserInfo = false;
    let isEditingDriverLicense = false;

    // User Info Form
    const userInfoForm = document.getElementById('updateUserInfoForm');
    if (userInfoForm) {
        const userInfoRules = [
            { field: 'username', type: 'username' },
            { field: 'dob', type: 'dob' },
            { field: 'gender', type: 'gender' }
        ];

        userInfoForm.addEventListener('submit', function(e) {
            if (!validateForm(userInfoForm, userInfoRules)) {
                e.preventDefault();
            }
            isEditingUserInfo = false;
        });

        // Track editing state
        userInfoForm.querySelectorAll('input, select').forEach(input => {
            input.addEventListener('input', () => { isEditingUserInfo = true; });
        });
    }

    // Driver License Form
    const driverLicenseElements = {
        editBtn: document.getElementById('editDriverLicenseBtn'),
        cancelBtn: document.getElementById('cancelDriverLicenseBtn'),
        saveBtn: document.getElementById('saveDriverLicenseBtn'),
        form: document.getElementById('driverLicenseInfoForm'),
        inputs: [
            { element: document.getElementById('licenseNumber'), type: 'licenseNumber' },
            { element: document.getElementById('fullName'), type: 'fullName' },
            { element: document.getElementById('dob'), type: 'dob' }
        ]
    };

    if (driverLicenseElements.editBtn && driverLicenseElements.form) {
        let originalValues = {};

        function storeOriginalValues() {
            driverLicenseElements.inputs.forEach(input => {
                originalValues[input.element.id] = input.element.value;
            });
        }

        function resetToOriginalValues() {
            driverLicenseElements.inputs.forEach(input => {
                input.element.value = originalValues[input.element.id];
                input.element.disabled = true;
            });
        }

        function validateDriverLicenseFields() {
            let allValid = true;
            
            driverLicenseElements.inputs.forEach(input => {
                const errorDiv = document.getElementById(`${input.element.id}Error`);
                const isValid = validationManager.validateInput(input.element, errorDiv, input.type);
                if (!isValid) allValid = false;
            });

            driverLicenseElements.saveBtn.disabled = !allValid;
            return allValid;
        }

        // Setup input restrictions
        InputRestrictions.setupNumericInput(
            driverLicenseElements.inputs[0].element,
            document.getElementById('licenseNumberError')
        );
        
        InputRestrictions.setupTextInput(
            driverLicenseElements.inputs[1].element,
            document.getElementById('fullNameError')
        );

        // Event listeners
        driverLicenseElements.editBtn.addEventListener('click', function() {
            storeOriginalValues();
            driverLicenseElements.inputs.forEach(input => input.element.disabled = false);
            driverLicenseElements.cancelBtn.classList.remove('d-none');
            driverLicenseElements.saveBtn.classList.remove('d-none');
            driverLicenseElements.saveBtn.disabled = true;
            driverLicenseElements.editBtn.classList.add('d-none');
            isEditingDriverLicense = true;
        });

        driverLicenseElements.cancelBtn.addEventListener('click', function() {
            resetToOriginalValues();
            driverLicenseElements.cancelBtn.classList.add('d-none');
            driverLicenseElements.saveBtn.classList.add('d-none');
            driverLicenseElements.editBtn.classList.remove('d-none');
            isEditingDriverLicense = false;
        });

        // Real-time validation
        driverLicenseElements.inputs.forEach(input => {
            input.element.addEventListener('input', function() {
                const errorDiv = document.getElementById(`${input.element.id}Error`);
                validationManager.validateInput(input.element, errorDiv, input.type);
                validateDriverLicenseFields();
                if (!input.element.disabled) isEditingDriverLicense = true;
            });
        });

        // Save functionality
        driverLicenseElements.saveBtn.addEventListener('click', function() {
            if (validateDriverLicenseFields()) {
                const formData = new FormData();
                formData.append('action', 'updateInfo');
                formData.append('licenseNumber', driverLicenseElements.inputs[0].element.value);
                formData.append('fullName', driverLicenseElements.inputs[1].element.value);
                formData.append('dob', driverLicenseElements.inputs[2].element.value);

                fetch(driverLicenseElements.form.action, {
                    method: 'POST',
                    body: formData
                })
                .then(response => response.redirected ? 
                    window.location.href = response.url : response.text())
                .then(data => {
                    if (data) {
                        const result = JSON.parse(data);
                        if (result.success) {
                            showToast('Driver license information updated successfully!', 'success');
                            driverLicenseElements.inputs.forEach(input => input.element.disabled = true);
                            driverLicenseElements.editBtn.classList.remove('d-none');
                            driverLicenseElements.cancelBtn.classList.add('d-none');
                            driverLicenseElements.saveBtn.classList.add('d-none');
                            isEditingDriverLicense = false;
                        } else {
                            showToast(result.message || 'Failed to update information', 'error');
                        }
                    }
                })
                .catch(error => {
                    showToast('Failed to update information. Please try again.', 'error');
                });
            }
        });
    }
});