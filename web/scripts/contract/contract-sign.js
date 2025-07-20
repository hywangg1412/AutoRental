// Khởi tạo SignaturePad
const canvas = document.getElementById('signature-pad');
const signaturePad = new SignaturePad(canvas, {
    backgroundColor: '#f8f9fa',
    penColor: 'black'
});

document.getElementById('clearBtn').onclick = function() {
    signaturePad.clear();
};

const acceptTerms = document.getElementById('acceptTerms');
const confirmInfo = document.getElementById('confirmInfo');
const signBtn = document.getElementById('signBtn');
const signForm = document.getElementById('signForm');
const statusDiv = document.getElementById('signStatus');

function updateSignBtnState() {
    signBtn.disabled = !(acceptTerms.checked && confirmInfo.checked);
}

acceptTerms.addEventListener('change', updateSignBtnState);
confirmInfo.addEventListener('change', updateSignBtnState);

updateSignBtnState();

// Khi submit form
signForm.onsubmit = function(e) {
    statusDiv.innerHTML = '';
    if (signaturePad.isEmpty()) {
        statusDiv.innerHTML = '<span class="text-danger">Please provide your signature before signing.</span>';
        e.preventDefault();
        return false;
    }
    // Gán dữ liệu chữ ký vào input hidden
    document.getElementById('signatureData').value = signaturePad.toDataURL();
    // Cho phép submit form (POST truyền thống)
    return true;
};

// Collapse/Expand logic for terms
document.querySelectorAll('.terms-title-btn').forEach(function(btn) {
    btn.addEventListener('click', function() {
        const section = btn.closest('.terms-section');
        const body = section.querySelector('.terms-body');
        const expanded = btn.getAttribute('aria-expanded') === 'true';

        // Collapse all others (optional)
        document.querySelectorAll('.terms-title-btn').forEach(b => {
            b.setAttribute('aria-expanded', 'false');
            b.closest('.terms-section').classList.remove('active');
            b.closest('.terms-section').querySelector('.terms-body').classList.remove('show');
        });

        if (!expanded) {
            btn.setAttribute('aria-expanded', 'true');
            section.classList.add('active');
            body.classList.add('show');
        }
    });
});

// Show first section by default (optional)
const firstBtn = document.querySelector('.terms-title-btn');
if (firstBtn) {
    firstBtn.click();
}

// Bootstrap collapse compatibility
document.querySelectorAll('.terms-body').forEach(function(body) {
    if (!body.classList.contains('show')) {
        body.style.display = 'none';
    }
});
const observer = new MutationObserver(function(mutations) {
    mutations.forEach(function(mutation) {
        if (mutation.target.classList.contains('show')) {
            mutation.target.style.display = '';
        } else {
            mutation.target.style.display = 'none';
        }
    });
});
document.querySelectorAll('.terms-body').forEach(function(body) {
    observer.observe(body, { attributes: true, attributeFilter: ['class'] });
});
