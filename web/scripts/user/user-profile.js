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

// === BOOTSTRAP TOAST ===
function showBootstrapToast({title = 'Thông báo', message = '', delay = 3000, icon = null}) {
    const toastContainer = document.getElementById('toastContainer');
    if (!toastContainer) return;
    const toast = document.createElement('div');
    toast.className = 'toast align-items-center';
    toast.setAttribute('role', 'alert');
    toast.setAttribute('aria-live', 'assertive');
    toast.setAttribute('aria-atomic', 'true');
    toast.setAttribute('data-bs-delay', delay);
    toast.innerHTML = `
      <div class="toast-header">
        ${icon ? `<img src="${icon}" class="rounded me-2" alt="icon" style="width:20px;height:20px;">` : ''}
        <strong class="me-auto">${title}</strong>
        <small class="text-body-secondary">just now</small>
        <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
      </div>
      <div class="toast-body">
        ${message}
      </div>
    `;
    toastContainer.appendChild(toast);
    const bsToast = new bootstrap.Toast(toast);
    bsToast.show();
    toast.addEventListener('hidden.bs.toast', () => {
        toast.remove();
    });
}

// Main initialization
document.addEventListener('DOMContentLoaded', function() {
    var serverToast = document.getElementById('serverToast');
    if (serverToast) {
        var bsToast = new bootstrap.Toast(serverToast);
        bsToast.show();
    }

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
            // Enable file input when editing
            const licenseImageInput = document.getElementById('licenseImageInput');
            if (licenseImageInput) licenseImageInput.disabled = false;
            driverLicenseElements.cancelBtn.classList.remove('d-none');
            driverLicenseElements.saveBtn.classList.remove('d-none');
            driverLicenseElements.saveBtn.disabled = true;
            driverLicenseElements.editBtn.classList.add('d-none');
            isEditingDriverLicense = true;
        });

        driverLicenseElements.cancelBtn.addEventListener('click', function() {
            resetToOriginalValues();
            // Disable file input when cancel
            const licenseImageInput = document.getElementById('licenseImageInput');
            if (licenseImageInput) licenseImageInput.disabled = true;
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
                            // Xóa các lệnh showBootstrapToast trong fetch cập nhật driver license
                            // giữ lại logic cập nhật UI, không show toast ở đây
                            driverLicenseElements.inputs.forEach(input => input.element.disabled = true);
                            driverLicenseElements.editBtn.classList.remove('d-none');
                            driverLicenseElements.cancelBtn.classList.add('d-none');
                            driverLicenseElements.saveBtn.classList.add('d-none');
                            isEditingDriverLicense = false;
                        } else {
                            showBootstrapToast(result.message || 'Failed to update information', 'error');
                        }
                    }
                })
                .catch(error => {
                    showBootstrapToast('Failed to update information. Please try again.', 'error');
                });
            }
        });
    }

    // Citizen ID Form
    const citizenIdElements = {
        editBtn: document.getElementById('editCitizenIdBtn'),
        cancelBtn: document.getElementById('cancelCitizenIdBtn'),
        saveBtn: document.getElementById('saveCitizenIdBtn'),
        form: document.getElementById('citizenIdInfoForm'),
        inputs: [
            document.getElementById('citizenIdNumber'),
            document.getElementById('citizenFullName'),
            document.getElementById('citizenDob'),
            document.getElementById('citizenIssueDate'),
            document.getElementById('citizenPlaceOfIssue'),
            document.getElementById('citizenIdImageInput'),
            document.getElementById('citizenIdBackImageInput')
        ]
    };

    if (citizenIdElements.editBtn && citizenIdElements.form) {
        let originalValues = {};
        function storeOriginalValues() {
            citizenIdElements.inputs.forEach(input => {
                if (input) originalValues[input.id] = input.value;
            });
        }
        function resetToOriginalValues() {
            citizenIdElements.inputs.forEach(input => {
                if (input) {
                    input.value = originalValues[input.id];
                    input.disabled = true;
                }
            });
            // Disable file inputs when cancel
            const citizenIdImageInput = document.getElementById('citizenIdImageInput');
            const citizenIdBackImageInput = document.getElementById('citizenIdBackImageInput');
            if (citizenIdImageInput) citizenIdImageInput.disabled = true;
            if (citizenIdBackImageInput) citizenIdBackImageInput.disabled = true;
            citizenIdElements.saveBtn.classList.add('d-none');
            citizenIdElements.cancelBtn.classList.add('d-none');
            citizenIdElements.editBtn.classList.remove('d-none');
        }
        citizenIdElements.editBtn.addEventListener('click', function() {
            storeOriginalValues();
            citizenIdElements.inputs.forEach(input => { if (input) input.disabled = false; });
            // Enable file inputs when editing
            const citizenIdImageInput = document.getElementById('citizenIdImageInput');
            const citizenIdBackImageInput = document.getElementById('citizenIdBackImageInput');
            if (citizenIdImageInput) citizenIdImageInput.disabled = false;
            if (citizenIdBackImageInput) citizenIdBackImageInput.disabled = false;
            citizenIdElements.saveBtn.classList.remove('d-none');
            citizenIdElements.cancelBtn.classList.remove('d-none');
            citizenIdElements.editBtn.classList.add('d-none');
        });
        citizenIdElements.cancelBtn.addEventListener('click', function() {
            resetToOriginalValues();
        });
        citizenIdElements.saveBtn.addEventListener('click', function(e) {
            const citizenIdImageInput = document.getElementById('citizenIdImageInput');
            const citizenIdBackImageInput = document.getElementById('citizenIdBackImageInput');
            // Kiểm tra: mỗi mặt chỉ cần có ảnh cũ hoặc ảnh mới
            const hasFrontImage = (citizenIdImageInput && citizenIdImageInput.files.length > 0) || !!document.getElementById('citizenIdImg');
            const hasBackImage = (citizenIdBackImageInput && citizenIdBackImageInput.files.length > 0) || !!document.getElementById('citizenIdBackImg');
            if (!hasFrontImage || !hasBackImage) {
                if (typeof showBootstrapToast === 'function') {
                    showBootstrapToast({message: 'Both front and back images are required', title: 'Error'});
                } else {
                    alert('Both front and back images are required');
                }
                return; // Không submit form
            }
            if (citizenIdImageInput) citizenIdImageInput.disabled = false;
            if (citizenIdBackImageInput) citizenIdBackImageInput.disabled = false;
            citizenIdElements.form.submit();
        });
    }

    // --- Đảm bảo gửi đúng action khi cập nhật bằng lái xe ---
    const saveBtn = document.getElementById('saveDriverLicenseBtn');
    const licenseImageInput = document.getElementById('licenseImageInput');
    const driverLicenseForm = document.getElementById('driverLicenseInfoForm');
    const actionInput = driverLicenseForm ? driverLicenseForm.querySelector('input[name="action"]') : null;
    if (saveBtn && driverLicenseForm && licenseImageInput && actionInput) {
        saveBtn.addEventListener('click', function(e) {
            e.preventDefault();
            if (licenseImageInput.files && licenseImageInput.files.length > 0) {
                actionInput.value = 'uploadImage';
            } else {
                actionInput.value = 'updateInfo';
            }
            driverLicenseForm.submit();
        });
    }

    // === IMAGE PREVIEW ===
    // Giữ lại duy nhất hàm setupImageUploadPreview và các lệnh gọi hàm này, xóa các đoạn preview ảnh, enable/disable input file, reset preview cũ cho driver license và citizen id
    function setupImageUploadPreview({inputId, areaClass, imgId, emptyHtml, editBtnId, cancelBtnId, saveBtnId}) {
        const input = document.getElementById(inputId);
        const uploadArea = input ? input.closest(areaClass) : null;
        const saveBtn = saveBtnId ? document.getElementById(saveBtnId) : null;
        let originalImgSrc = null;

        if (input && uploadArea) {
            // Lưu lại src gốc khi load trang (nếu có ảnh)
            const img = uploadArea.querySelector(`#${imgId}`);
            originalImgSrc = img ? img.src : null;

            input.addEventListener('change', function() {
                if (this.files && this.files[0]) {
                    const reader = new FileReader();
                    reader.onload = function(e) {
                        let img = uploadArea.querySelector(`#${imgId}`);
                        if (!img) {
                            // Nếu chưa có img, xóa upload-area-empty và tạo img mới
                            const emptyDiv = uploadArea.querySelector('.upload-area-empty');
                            if (emptyDiv) emptyDiv.remove();
                            img = document.createElement('img');
                            img.id = imgId;
                            img.className = input.classList.contains('citizen-id-input') ? 'citizen-id-img-preview' : 'driver-license-img-preview';
                            img.alt = 'Image Preview';
                            uploadArea.prepend(img);
                        }
                        img.src = e.target.result;
                    };
                    reader.readAsDataURL(this.files[0]);
                }
                if (saveBtn) {
                    if (this.files && this.files[0]) {
                        saveBtn.disabled = false;
                    } else {
                        saveBtn.disabled = true;
                    }
                }
            });

            // Khi bấm Edit: enable input file
            const editBtn = document.getElementById(editBtnId);
            if (editBtn) {
                editBtn.addEventListener('click', function() {
                    input.disabled = false;
                });
            }

            // Khi bấm Cancel: reset preview về trạng thái ban đầu
            const cancelBtn = document.getElementById(cancelBtnId);
            if (cancelBtn) {
                cancelBtn.addEventListener('click', function() {
                    input.value = '';
                    let img = uploadArea.querySelector(`#${imgId}`);
                    if (originalImgSrc) {
                        // Nếu có ảnh gốc, reset lại src
                        if (!img) {
                            img = document.createElement('img');
                            img.id = imgId;
                            img.className = input.classList.contains('citizen-id-input') ? 'citizen-id-img-preview' : 'driver-license-img-preview';
                            img.alt = 'Image Preview';
                            uploadArea.prepend(img);
                        }
                        img.src = originalImgSrc;
                    } else {
                        // Nếu không có ảnh gốc, hiện lại upload-area-empty
                        if (img) img.remove();
                        if (!uploadArea.querySelector('.upload-area-empty')) {
                            const emptyDiv = document.createElement('div');
                            emptyDiv.className = 'upload-area-empty';
                            emptyDiv.innerHTML = emptyHtml;
                            uploadArea.prepend(emptyDiv);
                        }
                    }
                    input.disabled = true;
                    if (saveBtn) saveBtn.disabled = true;
                });
            }
        }
    }

    // Áp dụng cho từng loại ảnh:
    setupImageUploadPreview({
        inputId: 'licenseImageInput',
        areaClass: '.driver-license-upload-area',
        imgId: 'driverLicenseImg',
        emptyHtml: `
            <div class="upload-icon"><i class="bi bi-upload"></i></div>
            <div class="upload-text">Click to upload</div>
        `,
        editBtnId: 'editDriverLicenseBtn',
        cancelBtnId: 'cancelDriverLicenseBtn',
        saveBtnId: 'saveDriverLicenseBtn'
    });

    setupImageUploadPreview({
        inputId: 'citizenIdImageInput',
        areaClass: '.citizen-id-upload-area',
        imgId: 'citizenIdImg',
        emptyHtml: `
            <div class="upload-icon"><i class="bi bi-upload"></i></div>
            <div class="upload-text">Click to upload CCCD front image</div>
        `,
        editBtnId: 'editCitizenIdBtn',
        cancelBtnId: 'cancelCitizenIdBtn'
    });

    setupImageUploadPreview({
        inputId: 'citizenIdBackImageInput',
        areaClass: '.citizen-id-upload-area',
        imgId: 'citizenIdBackImg',
        emptyHtml: `
            <div class="upload-icon"><i class="bi bi-upload"></i></div>
            <div class="upload-text">Click to upload CCCD back image</div>
        `,
        editBtnId: 'editCitizenIdBtn',
        cancelBtnId: 'cancelCitizenIdBtn'
    });

    // === VALIDATE CITIZEN ID FORM ===
    // Regex rules
    const citizenIdNumberRegex = /^\d{12}$/;
    const citizenNameRegex = /^[\p{L} ]+$/u;
    const citizenPlaceRegex = /^[\p{L} ]+$/u;
    const dateRegex = /^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[0-2])\/\d{4}$/;

    // Validate function for CCCD
    function validateCitizenIdFields() {
        let valid = true;
        const idInput = document.getElementById('citizenIdNumber');
        const idError = document.getElementById('citizenIdNumberError');
        const nameInput = document.getElementById('citizenFullName');
        const nameError = document.getElementById('citizenFullNameError');
        const placeInput = document.getElementById('citizenPlaceOfIssue');
        const placeError = document.getElementById('citizenPlaceOfIssueError');
        const dobInput = document.getElementById('citizenDob');
        const dobError = document.getElementById('citizenDobError');
        const issueDateInput = document.getElementById('citizenIssueDate');
        const issueDateError = document.getElementById('citizenIssueDateError');

        // ID number
        if (!citizenIdNumberRegex.test(idInput.value.trim())) {
            errorManager.showError(idInput, idError, 'ID number must be exactly 12 digits');
            valid = false;
        } else {
            errorManager.clearError(idInput, idError);
        }
        // Full name
        if (!citizenNameRegex.test(nameInput.value.trim())) {
            errorManager.showError(nameInput, nameError, 'Full name must not contain numbers or special characters');
            valid = false;
        } else {
            errorManager.clearError(nameInput, nameError);
        }
        // Place of issue
        if (!citizenPlaceRegex.test(placeInput.value.trim())) {
            errorManager.showError(placeInput, placeError, 'Place of issue must not contain numbers or special characters');
            valid = false;
        } else {
            errorManager.clearError(placeInput, placeError);
        }
        // Date of birth
        if (!dateRegex.test(dobInput.value.trim())) {
            errorManager.showError(dobInput, dobError, 'Date of birth must be in dd/MM/yyyy format');
            valid = false;
        } else {
            errorManager.clearError(dobInput, dobError);
        }
        // Issue date
        if (!dateRegex.test(issueDateInput.value.trim())) {
            errorManager.showError(issueDateInput, issueDateError, 'Issue date must be in dd/MM/yyyy format');
            valid = false;
        } else {
            errorManager.clearError(issueDateInput, issueDateError);
        }
        return valid;
    }

    // Real-time validation for CCCD fields
    ['citizenIdNumber', 'citizenFullName', 'citizenPlaceOfIssue', 'citizenDob', 'citizenIssueDate'].forEach(function(id) {
        const input = document.getElementById(id);
        const errorDiv = document.getElementById(id + 'Error');
        if (input && errorDiv) {
            input.addEventListener('input', function() {
                validateCitizenIdFields();
            });
            input.addEventListener('blur', function() {
                validateCitizenIdFields();
            });
        }
    });

    // Chặn submit nếu có lỗi
    const citizenIdForm = document.getElementById('citizenIdInfoForm');
    if (citizenIdForm) {
        citizenIdForm.addEventListener('submit', function(e) {
            if (!validateCitizenIdFields()) {
                e.preventDefault();
            }
        });
    }
});