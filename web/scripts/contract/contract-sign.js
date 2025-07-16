// Auto-resize iframe height để hiển thị toàn bộ hợp đồng
// Tất cả logic ký hợp đồng được chuyển từ contract-sign.jsp sang file này

document.addEventListener('DOMContentLoaded', function () {
    const iframe = document.getElementById('contractTemplateFrame');
    if (iframe) {
        iframe.onload = function () {
            iframe.style.height = '3590px';
        };
    }
    // Enable/disable nút Sign dựa vào checkbox
const acceptTerms = document.getElementById('acceptTerms');
const signBtn = document.getElementById('signBtn');
    if (acceptTerms && signBtn) {
        acceptTerms.addEventListener('change', function () {
            signBtn.disabled = !acceptTerms.checked;
        });
        signBtn.disabled = !acceptTerms.checked;
    }
    // Chuyển đổi giữa ký trực tiếp, upload ảnh và nhập chữ ký (không còn radio button)
    document.querySelectorAll('.signature-method-option').forEach(function (opt) {
        opt.addEventListener('click', function () {
            document.querySelectorAll('.signature-method-option').forEach(function (o) { o.classList.remove('selected'); });
            this.classList.add('selected');
            var method = this.getAttribute('data-method');
            document.getElementById('drawSignatureBox').style.display = method === 'draw' ? '' : 'none';
            document.getElementById('uploadSignatureBox').style.display = method === 'upload' ? '' : 'none';
            document.getElementById('typeSignatureBox').style.display = method === 'type' ? '' : 'none';
            document.getElementById('signatureMethodHidden').value = method;

            // Clear dữ liệu của các phương thức khác
            if (method !== 'type') {
                // Clear Type
                document.getElementById('typedSignatureInput').value = '';
                document.getElementById('typedFullNameInput').value = '';
                const iframe = document.getElementById('contractTemplateFrame');
                if (iframe && iframe.contentWindow) {
                    iframe.contentWindow.postMessage({ type: 'UPDATE_SIGNATURE', signature: '' }, '*');
                    iframe.contentWindow.postMessage({ type: 'UPDATE_FULLNAME', fullName: '' }, '*');
                }
            }
            if (method !== 'draw' && window.SignaturePad && document.getElementById('signature-pad')) {
                // Clear Draw
                var signaturePadDraw = new window.SignaturePad(document.getElementById('signature-pad'));
                signaturePadDraw.clear();
                const iframe = document.getElementById('contractTemplateFrame');
                if (iframe && iframe.contentWindow) {
                    iframe.contentWindow.postMessage({ type: 'UPDATE_SIGNATURE_IMAGE', signatureImage: '' }, '*');
                }
            }
            if (method !== 'upload') {
                // Clear Upload
                document.getElementById('signatureImageInput').value = '';
                document.getElementById('signatureImagePreview').src = '';
                document.getElementById('signatureImagePreview').style.display = 'none';
                document.querySelector('.upload-label').style.display = 'block';
                const iframe = document.getElementById('contractTemplateFrame');
                if (iframe && iframe.contentWindow) {
                    iframe.contentWindow.postMessage({ type: 'UPDATE_SIGNATURE_IMAGE', signatureImage: '' }, '*');
                }
            }
        });
    });
    // Preview ảnh chữ ký
    document.getElementById('signatureImageInput').addEventListener('change', function (e) {
        const file = e.target.files[0];
        const preview = document.getElementById('signatureImagePreview');
        if (file) {
            const allowedTypes = ['image/png', 'image/jpeg', 'image/jpg'];
            if (!allowedTypes.includes(file.type)) {
                alert('Only PNG and JPG images are allowed!');
                e.target.value = '';
                preview.src = '';
                preview.style.display = 'none';
                document.querySelector('.upload-label').style.display = 'block';
                return;
            }
            if (file.size > 1024 * 1024) { // 1MB
                alert('Signature image must be less than 1MB!');
                e.target.value = '';
                preview.src = '';
                preview.style.display = 'none';
                document.querySelector('.upload-label').style.display = 'block';
                // Không gửi gì sang contract-template
                return;
            }
            const reader = new FileReader();
            reader.onload = function (evt) {
                preview.src = evt.target.result;
                preview.style.display = 'block';
                document.querySelector('.upload-label').style.display = 'none';
                // Gửi ảnh base64 sang contract-template để hiển thị
                const iframe = document.getElementById('contractTemplateFrame');
                if (iframe && iframe.contentWindow) {
                    iframe.contentWindow.postMessage({ type: 'UPDATE_SIGNATURE_IMAGE', signatureImage: evt.target.result }, '*');
                }
            };
            reader.readAsDataURL(file);
        } else {
            preview.src = '';
            preview.style.display = 'none';
            document.querySelector('.upload-label').style.display = 'block';
            // Không gửi gì sang contract-template ở đây
        }
    });
    // Đã ẩn preview chữ ký nhập
    // Khi submit form: lấy ảnh base64 nếu upload, nếu không thì lấy canvas hoặc text
const signForm = document.getElementById('signForm');
    if (signForm) {
        signForm.addEventListener('submit', function (e) {
            const method = document.getElementById('signatureMethodHidden').value;
            if (method === 'upload' && document.getElementById('signatureImageInput').files.length > 0) {
                // Lấy base64 ảnh upload
                e.preventDefault();
                const file = document.getElementById('signatureImageInput').files[0];
                const reader = new FileReader();
                reader.onload = function (evt) {
                    document.getElementById('signatureData').value = evt.target.result;
                    signForm.submit();
                };
                reader.readAsDataURL(file);
            } else if (method === 'type') {
                // Lấy text nhập làm signatureData
                const typed = document.getElementById('typedSignatureInput').value.trim();
                const fullName = document.getElementById('typedFullNameInput').value.trim();
                if (!typed) {
                    e.preventDefault();
                    document.getElementById('signStatus').textContent = 'Please enter your name as signature.';
                    return;
                }
                if (!fullName) {
        e.preventDefault();
                    document.getElementById('signStatus').textContent = 'Please enter your full name.';
                    return;
                }
                document.getElementById('signatureData').value = typed;
                document.getElementById('fullNameHidden').value = fullName;
            } else {
                // Lấy base64 từ canvas (giữ nguyên logic cũ trong contract-sign.js)
                // Nếu đã có logic này trong contract-sign.js thì không cần xử lý lại ở đây
            }
        });
    }
    // Sửa nút Clear cho Type Signature
    document.getElementById('clearBtn').addEventListener('click', function () {
        const method = document.getElementById('signatureMethodHidden').value;
        if (method === 'type') {
            document.getElementById('typedSignatureInput').value = '';
            document.getElementById('typedFullNameInput').value = '';
            const iframe = document.getElementById('contractTemplateFrame');
            if (iframe && iframe.contentWindow) {
                iframe.contentWindow.postMessage({ type: 'UPDATE_SIGNATURE', signature: '' }, '*');
                iframe.contentWindow.postMessage({ type: 'UPDATE_FULLNAME', fullName: '' }, '*');
                iframe.contentWindow.postMessage({ type: 'UPDATE_SIGNATURE_IMAGE', signatureImage: '' }, '*');
            }
        }
        if (method === 'upload') {
            // Xóa input file
            document.getElementById('signatureImageInput').value = '';
            // Ẩn preview ảnh
            document.getElementById('signatureImagePreview').src = '';
            document.getElementById('signatureImagePreview').style.display = 'none';
            // Hiện lại label upload
            document.querySelector('.upload-label').style.display = 'block';
            // Gửi ảnh rỗng sang contract-template
            const iframe = document.getElementById('contractTemplateFrame');
            if (iframe && iframe.contentWindow) {
                iframe.contentWindow.postMessage({ type: 'UPDATE_SIGNATURE_IMAGE', signatureImage: '' }, '*');
            }
        }
        // Nếu có logic clear cho draw thì giữ nguyên phía dưới (contract-sign.js)
    });
    // Gửi chữ ký realtime sang iframe contract template
    const signStatus = document.getElementById('signStatus');
    const typedSignatureInput = document.getElementById('typedSignatureInput');
    const typedSignatureError = document.getElementById('typedSignatureError');
    const typedFullNameInput = document.getElementById('typedFullNameInput');
    const typedFullNameError = document.getElementById('typedFullNameError');

    // Chặn phím không hợp lệ ngay khi gõ cho type signature
    typedSignatureInput.addEventListener('keydown', function (e) {
        if (
            e.key.length === 1 &&
            !e.key.match(/[a-zA-Z\sÀ-ỹà-ỹ]/)
        ) {
            e.preventDefault();
            typedSignatureError.textContent = 'Can only contain letters and spaces';
            typedSignatureError.classList.add('show');
            typedSignatureInput.classList.add('input-error');
        }
    });
    // Xử lý khi paste hoặc nhập nhanh cho type signature
    typedSignatureInput.addEventListener('input', function (e) {
        let value = this.value;
        let valid = value.replace(/[^a-zA-Z\sÀ-ỹà-ỹ]/g, '');
        if (value !== valid) {
            this.value = valid;
            typedSignatureError.textContent = 'Can only contain letters and spaces';
            typedSignatureError.classList.add('show');
            typedSignatureInput.classList.add('input-error');
        } else {
            typedSignatureError.classList.remove('show');
            setTimeout(() => {
                typedSignatureError.textContent = '';
            }, 250);
            typedSignatureInput.classList.remove('input-error');
        }
        const signature = this.value;
        const iframe = document.getElementById('contractTemplateFrame');
        if (iframe && iframe.contentWindow) {
            iframe.contentWindow.postMessage(
                { type: 'UPDATE_SIGNATURE', signature: signature },
                '*'
            );
        }
    });
    // Chặn phím không hợp lệ ngay khi gõ cho full name
    typedFullNameInput.addEventListener('keydown', function (e) {
        if (
            e.key.length === 1 &&
            !e.key.match(/[a-zA-Z\sÀ-ỹà-ỹ]/)
        ) {
            e.preventDefault();
            typedFullNameError.textContent = 'Full name can only contain letters and spaces';
            typedFullNameError.classList.add('show');
            typedFullNameInput.classList.add('input-error');
        }
    });
    // Xử lý khi paste hoặc nhập nhanh cho full name
    typedFullNameInput.addEventListener('input', function (e) {
        let value = this.value;
        let valid = value.replace(/[^a-zA-Z\sÀ-ỹà-ỹ]/g, '');
        if (value !== valid) {
            this.value = valid;
            typedFullNameError.textContent = 'Full name can only contain letters and spaces';
            typedFullNameError.classList.add('show');
            typedFullNameInput.classList.add('input-error');
        } else {
            typedFullNameError.classList.remove('show');
            setTimeout(() => {
                typedFullNameError.textContent = '';
            }, 250);
            typedFullNameInput.classList.remove('input-error');
        }
        const fullName = this.value;
        const iframe = document.getElementById('contractTemplateFrame');
        if (iframe && iframe.contentWindow) {
            iframe.contentWindow.postMessage(
                { type: 'UPDATE_FULLNAME', fullName: fullName },
                '*'
            );
        }
    });
    document.getElementById('typedFullNameInput').addEventListener('input', function (e) {
        const fullName = this.value;
        const iframe = document.getElementById('contractTemplateFrame');
        if (iframe && iframe.contentWindow) {
            iframe.contentWindow.postMessage(
                { type: 'UPDATE_FULLNAME', fullName: fullName },
                '*'
            );
        }
    });

    // Hàm kiểm tra điều kiện để enable nút Sign
    function updateSignButtonState() {
        const method = document.getElementById('signatureMethodHidden').value;
        const acceptTerms = document.getElementById('acceptTerms').checked;
        let valid = false;
        if (method === 'draw') {
            if (window.signaturePadDraw && !window.signaturePadDraw.isEmpty()) {
                valid = true;
            }
        } else if (method === 'upload') {
            const file = document.getElementById('signatureImageInput').files[0];
            if (file) valid = true;
        } else if (method === 'type') {
            const typed = document.getElementById('typedSignatureInput').value.trim();
            const fullName = document.getElementById('typedFullNameInput').value.trim();
            if (typed.length > 0 && fullName.length > 0) valid = true;
        }
        const signBtn = document.getElementById('signBtn');
        signBtn.disabled = !(valid && acceptTerms);
        if (valid && acceptTerms) {
            signBtn.classList.add('enabled');
        } else {
            signBtn.classList.remove('enabled');
        }
    }

    // Gọi khi đổi phương thức, nhập/chọn/chỉnh chữ ký, tick điều khoản
    document.getElementById('acceptTerms').addEventListener('change', updateSignButtonState);
    document.querySelectorAll('.signature-method-option').forEach(function (opt) {
        opt.addEventListener('click', function () {
            // ... code chuyển đổi phương thức ...
            setTimeout(updateSignButtonState, 10); // Đợi DOM cập nhật
        });
    });
    // Draw
    if (window.signaturePadDraw) {
        ['mouseup','touchend','mouseleave'].forEach(evt => {
            document.getElementById('signature-pad').addEventListener(evt, updateSignButtonState);
        });
    }
    // Upload
    document.getElementById('signatureImageInput').addEventListener('change', updateSignButtonState);
    // Type
    document.getElementById('typedSignatureInput').addEventListener('input', updateSignButtonState);
    // Khi clear
    document.getElementById('clearBtn').addEventListener('click', function () {
        setTimeout(updateSignButtonState, 10);
    });
    // Gọi khi load trang
    updateSignButtonState();
});
var canvasDraw = document.getElementById('signature-pad');
if (canvasDraw && window.SignaturePad) {
    var signaturePadDraw = new window.SignaturePad(canvasDraw);
    window.signaturePadDraw = signaturePadDraw;
    function sendDrawSignatureToIframe() {
        if (document.getElementById('signatureMethodHidden').value !== 'draw') return;
        if (!signaturePadDraw.isEmpty()) {
            var dataUrl = signaturePadDraw.toDataURL();
            const iframe = document.getElementById('contractTemplateFrame');
            if (iframe && iframe.contentWindow) {
                iframe.contentWindow.postMessage({ type: 'UPDATE_SIGNATURE_IMAGE', signatureImage: dataUrl }, '*');
            }
        } else {
            const iframe = document.getElementById('contractTemplateFrame');
            if (iframe && iframe.contentWindow) {
                iframe.contentWindow.postMessage({ type: 'UPDATE_SIGNATURE_IMAGE', signatureImage: '' }, '*');
            }
        }
    }
    canvasDraw.addEventListener('mouseup', sendDrawSignatureToIframe);
    canvasDraw.addEventListener('touchend', sendDrawSignatureToIframe);
    canvasDraw.addEventListener('mouseleave', sendDrawSignatureToIframe);
    document.getElementById('clearBtn').addEventListener('click', function () {
        if (document.getElementById('signatureMethodHidden').value === 'draw') {
            signaturePadDraw.clear();
            const iframe = document.getElementById('contractTemplateFrame');
            if (iframe && iframe.contentWindow) {
                iframe.contentWindow.postMessage({ type: 'UPDATE_SIGNATURE_IMAGE', signatureImage: '' }, '*');
            }
        }
    });
}


