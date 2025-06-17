document.addEventListener('DOMContentLoaded', function() {
    const toastElList = document.querySelectorAll('.toast');
    
    toastElList.forEach(function(toastEl, index) {
        // Thêm class dựa vào nội dung
        const message = toastEl.querySelector('.toast-body').textContent.trim().toLowerCase();
        toastEl.classList.add(message.includes('success') ? 'success' : 'error');
        
        // Khởi tạo toast
        const toast = new bootstrap.Toast(toastEl, {
            animation: true,
            autohide: true,
            delay: 3000
        });
        
        // Hiển thị toast với delay
        setTimeout(() => {
            toast.show();
        }, index * 300);
        
        // Xử lý animation khi ẩn
        toastEl.addEventListener('hide.bs.toast', () => {
            toastEl.classList.add('hide');
        });
    });

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
                if (!/^(0[1-9]|[12][0-9]|3[01])\/(0[1-9]|1[0-2])\/\d{4}$/.test(dob)) {
                    dobError = 'Invalid date format!';
                    hasError = true;
                } else {
                    let parts = dob.split('/');
                    let birthDate = new Date(parts[2], parts[1] - 1, parts[0]);
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
            }

            if (!gender || (gender !== 'Male' && gender !== 'Female')) {
                genderError = 'Gender is required.';
                hasError = true;
            }

            if (usernameError) form.querySelector('input[name="username"]').parentElement.insertAdjacentHTML('beforeend', `<div class="text-danger">${usernameError}</div>`);
            if (dobError) form.querySelector('input[name="dob"]').parentElement.insertAdjacentHTML('beforeend', `<div class="text-danger">${dobError}</div>`);
            if (genderError) form.querySelector('select[name="gender"]').parentElement.insertAdjacentHTML('beforeend', `<div class="text-danger">${genderError}</div>`);

            if (hasError) e.preventDefault();
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
});
