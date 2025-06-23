let isEditingUserInfo = false;
let isEditingDriverLicense = false;

document.addEventListener('DOMContentLoaded', function() {
    const form = document.getElementById('updateUserInfoForm');
    if (form) {
        form.addEventListener('submit', function(e) {
            form.querySelectorAll('.text-danger').forEach(el => el.remove());
            let hasError = false;
            let username = form.querySelector('input[name="username"]').value.trim();
            let dob = form.querySelector('input[name="dob"]').value.trim();
            let gender = form.querySelector('select[name="gender"]').value;
            let usernameError = '';
            let dobError = '';
            let genderError = '';

            if (!username) {
                usernameError = 'Username cannot be empty.';
                hasError = true;
            } else {
                if (username.length < 3 || username.length > 30) {
                    usernameError = 'Username must be 3-30 characters.';
                    hasError = true;
                }
                if (!/^[\p{L}0-9 ]+$/u.test(username)) {
                    usernameError = 'Username must not contain special characters and can include Vietnamese letters.';
                    hasError = true;
                }
            }

            if (!dob) {
                dobError = 'Date of birth cannot be empty.';
                hasError = true;
            } else {
                let birthDate = new Date(dob);
                let today = new Date();
                let age = today.getFullYear() - birthDate.getFullYear();
                let m = today.getMonth() - birthDate.getMonth();
                if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
                    age--;
                }
                if (age < 18) {
                    dobError = 'You must be at least 18 years old!';
                    hasError = true;
                }
            }

            if (!gender || (gender !== 'Male' && gender !== 'Female')) {
                genderError = 'Gender is required.';
                hasError = true;
            }

            if (usernameError) form.querySelector('input[name="username"]').parentElement.insertAdjacentHTML('beforeend', `<div class="text-danger">${usernameError}</div>`);
            if (dobError) form.querySelector('input[name="dob"]').parentElement.insertAdjacentHTML('beforeend', `<div class="text-danger">${dobError}</div>`);
            if (genderError) form.querySelector('select[name="gender"]').parentElement.insertAdjacentHTML('beforeend', `<div class="text-danger">${genderError}</div>`);

            if (hasError) e.preventDefault();
            isEditingUserInfo = false;
        });
    }

    const closeBtn = document.querySelector('#editUserInfoModal .btn-close');
    if (closeBtn) {
        closeBtn.addEventListener('click', function() {
            const modal = bootstrap.Modal.getInstance(document.getElementById('editUserInfoModal'));
            if (modal) {
                modal.hide();
            }
        });
    }

    const editBtn = document.getElementById('editDriverLicenseBtn');
    const cancelBtn = document.getElementById('cancelDriverLicenseBtn');
    const saveBtn = document.getElementById('saveDriverLicenseBtn');
    const inputs = [
        document.getElementById('licenseNumber'),
        document.getElementById('fullName'),
        document.getElementById('dob')
    ];
    const formDL = document.getElementById('driverLicenseInfoForm');
    const licenseImageInput = document.getElementById('licenseImageInput');

    if (editBtn && cancelBtn && saveBtn && formDL) {
        let originalValues = {};
        
        function storeOriginalValues() {
            inputs.forEach(input => {
                originalValues[input.id] = input.value;
            });
        }

        function resetToOriginalValues() {
            inputs.forEach((input, idx) => {
                input.value = originalValues[input.id];
                input.disabled = true;
            });
        }

        function validateDriverLicenseFields() {
            let valid = true;
            document.getElementById('licenseNumberError').textContent = '';
            document.getElementById('fullNameError').textContent = '';
            document.getElementById('dobError').textContent = '';

            const licenseNumberVal = inputs[0].value.trim();
            const fullNameVal = inputs[1].value.trim();
            const dobVal = inputs[2].value;

            if (!licenseNumberVal) {
                document.getElementById('licenseNumberError').textContent = 'License number is required';
                valid = false;
            } else if (!/^[0-9]{12}$/.test(licenseNumberVal)) {
                document.getElementById('licenseNumberError').textContent = 'License number must be exactly 12 digits and contain only numbers';
                valid = false;
            }

            if (!fullNameVal) {
                document.getElementById('fullNameError').textContent = 'Full name is required';
                valid = false;
            } else if (!/^[\p{L} ]+$/u.test(fullNameVal)) {
                document.getElementById('fullNameError').textContent = 'Full name must not contain special characters or numbers';
                valid = false;
            }

            if (!dobVal) {
                document.getElementById('dobError').textContent = 'Date of birth is required';
                valid = false;
            } else {
                const dob = new Date(dobVal);
                const today = new Date();
                if (dob > today) {
                    document.getElementById('dobError').textContent = 'Date of birth cannot be in the future';
                    valid = false;
                } else {
                    let age = today.getFullYear() - dob.getFullYear();
                    let m = today.getMonth() - dob.getMonth();
                    if (m < 0 || (m === 0 && today.getDate() < dob.getDate())) {
                        age--;
                    }
                    if (age < 18) {
                        document.getElementById('dobError').textContent = 'You must be at least 18 years old';
                        valid = false;
                    }
                }
            }
            saveBtn.disabled = !valid;
            return valid;
        }

        editBtn.addEventListener('click', function() {
            storeOriginalValues();
            inputs.forEach(input => input.disabled = false);
            cancelBtn.classList.remove('d-none');
            saveBtn.classList.remove('d-none');
            saveBtn.disabled = true;
            editBtn.classList.add('d-none');
            isEditingDriverLicense = true;
        });

        cancelBtn.addEventListener('click', function() {
            resetToOriginalValues();
            inputs.forEach(input => input.disabled = true);
            cancelBtn.classList.add('d-none');
            saveBtn.classList.add('d-none');
            editBtn.classList.remove('d-none');
            isEditingDriverLicense = false;
        });

        inputs.forEach(input => {
            input.addEventListener('input', validateDriverLicenseFields);
        });

        licenseImageInput.addEventListener('change', function(e) {
            if (this.files && this.files[0]) {
                const formData = new FormData();
                formData.append('licenseImage', this.files[0]);
                formData.append('action', 'uploadImage');

                fetch(formDL.action, {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (response.redirected) {
                        window.location.href = response.url;
                    } else {
                        return response.text();
                    }
                })
                .then(data => {
                    if (data) {
                        try {
                            const result = JSON.parse(data);
                            if (result.success) {
                                // Update image preview
                                const preview = document.querySelector('.driver-license-img-preview');
                                if (preview) {
                                    preview.src = result.imageUrl;
                                } else {
                                    const uploadArea = document.querySelector('.driver-license-upload-area');
                                    uploadArea.innerHTML = `
                                        <img src="${result.imageUrl}" alt="Driver License Image" class="driver-license-img-preview">
                                        <span class="driver-license-upload-icon">
                                            <i class="bi bi-camera-fill"></i>
                                        </span>
                                    `;
                                }
                                showToast('Driver license image updated successfully!', 'success');
                            } else {
                                showToast(result.message || 'Failed to upload image', 'error');
                            }
                        } catch (e) {
                            window.location.reload();
                        }
                    }
                })
                .catch(error => {
                    showToast('Failed to upload image. Please try again.', 'error');
                });
            }
        });

        saveBtn.addEventListener('click', function() {
            if (validateDriverLicenseFields()) {
                inputs.forEach(input => input.disabled = false);
                
                const formData = new FormData();
                formData.append('action', 'updateInfo');
                formData.append('licenseNumber', inputs[0].value);
                formData.append('fullName', inputs[1].value);
                formData.append('dob', inputs[2].value);
                
                fetch(formDL.action, {
                    method: 'POST',
                    body: formData
                })
                .then(response => {
                    if (response.redirected) {
                        window.location.href = response.url;
                    } else {
                        return response.text();
                    }
                })
                .then(data => {
                    if (data) {
                        try {
                            const result = JSON.parse(data);
                            if (result.success) {
                                showToast('Driver license information updated successfully!', 'success');
                                inputs.forEach(input => input.disabled = true);
                                editBtn.classList.remove('d-none');
                                cancelBtn.classList.add('d-none');
                                saveBtn.classList.add('d-none');
                                isEditingDriverLicense = false;
                            } else {
                                showToast(result.message || 'Failed to update information', 'error');
                            }
                        } catch (e) {
                            window.location.reload();
                        }
                    }
                })
                .catch(error => {
                    showToast('Failed to update information. Please try again.', 'error');
                });
            }
        });

        inputs.forEach(input => {
            input.addEventListener('input', function() {
                if (!input.disabled) isEditingDriverLicense = true;
            });
        });
    }

    const userInfoModal = document.getElementById('editUserInfoModal');
    const userInfoForm = document.getElementById('updateUserInfoForm');
    if (userInfoForm) {
        userInfoForm.querySelectorAll('input, select').forEach(input => {
            input.addEventListener('input', function() {
                isEditingUserInfo = true;
            });
        });
        userInfoForm.addEventListener('submit', function() {
            isEditingUserInfo = false;
        });
    }
    if (userInfoModal) {
        userInfoModal.addEventListener('hide.bs.modal', function() {
            isEditingUserInfo = false;
        });
    }
});

(function() {
    function waitForBootstrap() {
        if (typeof bootstrap !== 'undefined' && bootstrap.Toast) {
            var toastElList = [].slice.call(document.querySelectorAll('.toast'));
            var toastList = toastElList.map(function(toastEl) {
                toastEl.classList.add('slide-in');
                toastEl.addEventListener('animationend', function handler(e) {
                    if (e.animationName === 'slideInRight') {
                        toastEl.classList.remove('slide-in');
                        toastEl.removeEventListener('animationend', handler);
                    }
                });
                var bsToast = new bootstrap.Toast(toastEl, {
                    animation: true,
                    autohide: true,
                    delay: 3000 
                });
                toastEl.addEventListener('hide.bs.toast', () => {
                    toastEl.classList.add('slide-out');
                });
                toastEl.addEventListener('hidden.bs.toast', () => {
                    toastEl.remove();
                });
                return bsToast;
            });
            toastList.forEach(toast => toast.show());

            window.showToast = function(message, type = 'success', duration = 3000) {
                let container = document.querySelector('.toast-container');
                if (!container) {
                    container = document.createElement('div');
                    container.className = 'toast-container position-fixed bottom-0 end-0 p-3';
                    document.body.appendChild(container);
                }
                const toast = document.createElement('div');
                toast.className = `toast align-items-center text-white border-0 ${type == 'success' ? 'bg-success' : 'bg-danger'} slide-in`;
                toast.setAttribute('role', 'alert');
                toast.setAttribute('aria-live', 'assertive');
                toast.setAttribute('aria-atomic', 'true');
                toast.innerHTML = `
                    <div class="d-flex">
                        <div class="toast-body">
                            <i class="fas ${type == 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'} me-2"></i>
                            ${message}
                        </div>
                        <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
                    </div>
                `;
                container.appendChild(toast);
                toast.addEventListener('animationend', function handler(e) {
                    if (e.animationName === 'slideInRight') {
                        toast.classList.remove('slide-in');
                        toast.removeEventListener('animationend', handler);
                    }
                });
                const bsToast = new bootstrap.Toast(toast, {
                    animation: true,
                    autohide: true,
                    delay: duration
                });
                toast.addEventListener('hide.bs.toast', () => {
                    toast.classList.add('slide-out');
                });
                toast.addEventListener('hidden.bs.toast', () => {
                    toast.remove();
                });
                bsToast.show();
            };
        } else {
            setTimeout(waitForBootstrap, 100);
        }
    }
    document.addEventListener('DOMContentLoaded', waitForBootstrap);
})();

window.addEventListener('beforeunload', function (e) {
    console.log('beforeunload', isEditingUserInfo, isEditingDriverLicense);
    if (isEditingUserInfo || isEditingDriverLicense) {
        e.preventDefault();
        e.returnValue = '';
    }
});
