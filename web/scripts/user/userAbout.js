document.addEventListener('DOMContentLoaded', function() {
    const editBtn = document.querySelector('.btn-edit');
    const cancelBtn = document.querySelector('.btn-cancel');
    const saveBtn = document.querySelector('.btn-save');
    const inputs = document.querySelectorAll('.driver-license-input');

    editBtn.addEventListener('click', function() {
        inputs.forEach(input => input.disabled = false);
        editBtn.classList.add('d-none');
        cancelBtn.classList.remove('d-none');
        saveBtn.classList.remove('d-none');
    });

    cancelBtn.addEventListener('click', function() {
        inputs.forEach(input => input.disabled = true);
        editBtn.classList.remove('d-none');
        cancelBtn.classList.add('d-none');
        saveBtn.classList.add('d-none');
    });

    saveBtn.addEventListener('click', function() {
        // Xử lý lưu dữ liệu ở đây nếu cần
        inputs.forEach(input => input.disabled = true);
        editBtn.classList.remove('d-none');
        cancelBtn.classList.add('d-none');
        saveBtn.classList.add('d-none');
    });
});