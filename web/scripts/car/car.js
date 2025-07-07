// Car page JavaScript - Form submit thông thường (không dùng AJAX)

document.addEventListener('DOMContentLoaded', function() {
    console.log('Car page loaded - using traditional form submit');
    
    // Lấy form chứa sort/filter
    const sortSelect = document.getElementById('sortSelect');
    const filterForm = sortSelect ? sortSelect.closest('form') : null;
    const filterCheckboxes = document.querySelectorAll('.dropdown-menu input[type="checkbox"]');
    const resetFilterBtn = document.getElementById('resetFilterBtn');

    // Xử lý sort select - tự động submit khi thay đổi
    if (sortSelect && filterForm) {
        sortSelect.addEventListener('change', function() {
            filterForm.submit();
        });
    }

    // Xử lý filter checkbox - tự động submit khi thay đổi
    filterCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            if (filterForm) filterForm.submit();
        });
    });

    // Xử lý reset filter button
    if (resetFilterBtn && filterForm) {
        resetFilterBtn.addEventListener('click', function() {
            // Reset tất cả checkbox
            filterCheckboxes.forEach(checkbox => {
                checkbox.checked = false;
            });
            // Reset sort select
            if (sortSelect) sortSelect.value = '';
            // Reset keyword
            const keywordInput = filterForm.querySelector('input[name="keyword"]');
            if (keywordInput) keywordInput.value = '';
            // Submit form
            filterForm.submit();
        });
    }

    // Xử lý pagination links
    const paginationLinks = document.querySelectorAll('.pagination-link');
    paginationLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            console.log('Pagination clicked:', this.dataset.page);
            
            // Tạo form tạm thời cho pagination
            const form = document.createElement('form');
            form.method = 'GET';
            form.action = contextPath + '/pages/car';
            
            // Thêm page
            const pageField = document.createElement('input');
            pageField.type = 'hidden';
            pageField.name = 'page';
            pageField.value = this.dataset.page;
            form.appendChild(pageField);
            
            // Thêm các filter hiện tại
            const filterData = [
                { name: 'keyword', value: this.dataset.keyword },
                { name: 'sort', value: this.dataset.sort },
                { name: 'brandId', value: this.dataset.brandIds },
                { name: 'fuelTypeId', value: this.dataset.fuelIds },
                { name: 'categoryId', value: this.dataset.categoryIds },
                { name: 'status', value: this.dataset.statusValues },
                { name: 'featureId', value: this.dataset.featureIds },
                { name: 'transmissionTypeId', value: this.dataset.transmissionIds }
            ];
            
            filterData.forEach(item => {
                if (item.value && item.value.trim()) {
                    const values = item.value.split(',');
                    values.forEach(value => {
                        if (value.trim()) {
                            const field = document.createElement('input');
                            field.type = 'hidden';
                            field.name = item.name;
                            field.value = value.trim();
                            form.appendChild(field);
                        }
                    });
                }
            });
            
            // Submit form
            document.body.appendChild(form);
            form.submit();
        });
    });
    
    // Hiển thị số lượng filter đã chọn
    function updateFilterCount() {
        const checkedFilters = document.querySelectorAll('.dropdown-menu input[type="checkbox"]:checked');
        checkedFilters.forEach(checkbox => {
            const dropdown = checkbox.closest('.dropdown');
            const button = dropdown.querySelector('.filter-btn');
            const count = dropdown.querySelectorAll('input[type="checkbox"]:checked').length;
            
            if (count > 0) {
                button.innerHTML = button.innerHTML.replace(/\(\d+\)/, '') + ` (${count})`;
            } else {
                button.innerHTML = button.innerHTML.replace(/\(\d+\)/, '');
            }
        });
    }
    
    updateFilterCount();
    
    // =========================== BRAND FILTER MODAL ===========================
    
    // Xử lý modal Brand filter
    const brandFilterModal = document.getElementById('brandFilterModal');
    if (brandFilterModal) {
        // Khi modal mở
        brandFilterModal.addEventListener('show.bs.modal', function() {
            document.body.classList.add('modal-open');
        });
        // Khi modal đóng
        brandFilterModal.addEventListener('hidden.bs.modal', function() {
            document.body.classList.remove('modal-open');
        });
    }
    
    // =========================== CATEGORY FILTER MODAL ===========================
    
    // Xử lý modal Category filter
    const categoryFilterModal = document.getElementById('categoryFilterModal');
    if (categoryFilterModal) {
        categoryFilterModal.addEventListener('show.bs.modal', function() {
            document.body.classList.add('modal-open');
        });
        categoryFilterModal.addEventListener('hidden.bs.modal', function() {
            document.body.classList.remove('modal-open');
        });
    }
    
    // =========================== ADVANCED FILTER MODAL ===========================
    // Xử lý modal Advanced Filter
    const advancedFilterModal = document.getElementById('advancedFilterModal');
    if (advancedFilterModal) {
        advancedFilterModal.addEventListener('show.bs.modal', function() {
            document.body.classList.add('modal-open');
        });
        advancedFilterModal.addEventListener('hidden.bs.modal', function() {
            document.body.classList.remove('modal-open');
        });
    }
    
    console.log('Car page JavaScript initialized successfully');
});

// Dual range slider cho filter giá (không dùng noUiSlider)
window.addEventListener('DOMContentLoaded', function() {
    function createDualSlider(minId, maxId, trackId, rangeDisplayId, minInputId, maxInputId, suffix = '') {
        const minSlider = document.getElementById(minId);
        const maxSlider = document.getElementById(maxId);
        const track = document.getElementById(trackId);
        const rangeDisplay = document.getElementById(rangeDisplayId);
        const minInput = document.getElementById(minInputId);
        const maxInput = document.getElementById(maxInputId);
        function formatK(val) {
            if (val < 1000) return val + 'K';
            return (val/1000).toLocaleString('vi-VN', {maximumFractionDigits:1}) + 'K';
        }
        function updateTrack() {
            const min = parseInt(minSlider.min);
            const max = parseInt(maxSlider.max);
            const minVal = parseInt(minSlider.value);
            const maxVal = parseInt(maxSlider.value);
            const leftPercent = ((minVal - min) / (max - min)) * 100;
            const rightPercent = ((maxVal - min) / (max - min)) * 100;
            track.style.left = leftPercent + '%';
            track.style.width = (rightPercent - leftPercent) + '%';
        }
        function updateDisplay() {
            const minVal = parseInt(minSlider.value);
            const maxVal = parseInt(maxSlider.value);
            rangeDisplay.textContent = formatK(minVal) + ' - ' + formatK(maxVal);
            minInput.value = minVal;
            maxInput.value = maxVal;
        }
        minSlider.addEventListener('input', function() {
            if (parseInt(minSlider.value) > parseInt(maxSlider.value)) {
                maxSlider.value = minSlider.value;
            }
            updateTrack();
            updateDisplay();
        });
        maxSlider.addEventListener('input', function() {
            if (parseInt(maxSlider.value) < parseInt(minSlider.value)) {
                minSlider.value = maxSlider.value;
            }
            updateTrack();
            updateDisplay();
        });
        updateTrack();
        updateDisplay();
    }
    // Initialize price range slider
    createDualSlider(
        'priceHourMinSlider', 'priceHourMaxSlider', 'priceTrack',
        'priceHourRangeDisplay',
        'minPricePerHourInput', 'maxPricePerHourInput', 'K'
    );
});

// Giảm z-index nav bar khi mở modal, trả lại khi đóng modal
(function() {
    document.addEventListener('DOMContentLoaded', function() {
        var modals = document.querySelectorAll('.modal');
        var navbar = document.querySelector('.ftco-navbar-light');
        var originalZ = navbar ? navbar.style.zIndex : '';
        modals.forEach(function(modal) {
            modal.addEventListener('show.bs.modal', function() {
                if (navbar) {
                    navbar.style.zIndex = '100'; // nhỏ hơn modal
                }
            });
            modal.addEventListener('hidden.bs.modal', function() {
                if (navbar) {
                    navbar.style.zIndex = originalZ; // trả lại như cũ
                }
            });
        });
    });
})();

$(document).on('click', '#selectAllTransmission', function() {
    const $btn = $(this);
    const $checkboxes = $('.transmission-checkbox');
    if ($checkboxes.filter(':checked').length === $checkboxes.length) return;
    $checkboxes.prop('checked', true);
    updateSelectAllBtn('transmission');
});
$(document).on('click', '#clearAllTransmission', function() {
    $('.transmission-checkbox').prop('checked', false);
    updateSelectAllBtn('transmission');
});
$(document).on('change', '.transmission-checkbox', function() {
    updateSelectAllBtn('transmission');
});

$(document).on('click', '#selectAllFuel', function() {
    const $btn = $(this);
    const $checkboxes = $('.fuel-checkbox');
    if ($checkboxes.filter(':checked').length === $checkboxes.length) return;
    $checkboxes.prop('checked', true);
    updateSelectAllBtn('fuel');
});
$(document).on('click', '#clearAllFuel', function() {
    $('.fuel-checkbox').prop('checked', false);
    updateSelectAllBtn('fuel');
});
$(document).on('change', '.fuel-checkbox', function() {
    updateSelectAllBtn('fuel');
});

$(document).on('click', '#selectAllStatus', function() {
    const $btn = $(this);
    const $checkboxes = $('.status-checkbox');
    if ($checkboxes.filter(':checked').length === $checkboxes.length) return;
    $checkboxes.prop('checked', true);
    updateSelectAllBtn('status');
});
$(document).on('click', '#clearAllStatus', function() {
    $('.status-checkbox').prop('checked', false);
    updateSelectAllBtn('status');
});
$(document).on('change', '.status-checkbox', function() {
    updateSelectAllBtn('status');
});

$('#transmissionFilterModal').on('shown.bs.modal', function() { updateSelectAllBtn('transmission'); });
$('#fuelFilterModal').on('shown.bs.modal', function() { updateSelectAllBtn('fuel'); });
$('#statusFilterModal').on('shown.bs.modal', function() { updateSelectAllBtn('status'); });

$(document).on('click', '#selectAllBrand', function() {
    const $btn = $(this);
    const $checkboxes = $('.form-check-input[name="brandId"]');
    if ($checkboxes.filter(':checked').length === $checkboxes.length) return;
    $checkboxes.prop('checked', true);
    updateSelectAllBtn('brand');
});
$(document).on('click', '#clearAllBrand', function() {
    $('.form-check-input[name="brandId"]').prop('checked', false);
    updateSelectAllBtn('brand');
});
$(document).on('change', '.form-check-input[name="brandId"]', function() {
    updateSelectAllBtn('brand');
});

// Select All / Clear All for Category
$(document).on('click', '#selectAllCategory', function() {
    const $btn = $(this);
    const $checkboxes = $('.form-check-input[name="categoryId"]');
    if ($checkboxes.filter(':checked').length === $checkboxes.length) return;
    $checkboxes.prop('checked', true);
    updateSelectAllBtn('category');
});
$(document).on('click', '#clearAllCategory', function() {
    $('.form-check-input[name="categoryId"]').prop('checked', false);
    updateSelectAllBtn('category');
});
$(document).on('change', '.form-check-input[name="categoryId"]', function() {
    updateSelectAllBtn('category');
});

$('#brandFilterModal').on('shown.bs.modal', function() { updateSelectAllBtn('brand'); });
$('#categoryFilterModal').on('shown.bs.modal', function() { updateSelectAllBtn('category'); });

function updateSelectAllBtn(type) {
    let checkboxClass = '';
    let btnId = '';
    if (type === 'transmission') {
        checkboxClass = '.transmission-checkbox';
        btnId = '#selectAllTransmission';
    } else if (type === 'fuel') {
        checkboxClass = '.fuel-checkbox';
        btnId = '#selectAllFuel';
    } else if (type === 'status') {
        checkboxClass = '.status-checkbox';
        btnId = '#selectAllStatus';
    } else if (type === 'brand') {
        checkboxClass = '.form-check-input[name="brandId"]';
        btnId = '#selectAllBrand';
    } else if (type === 'category') {
        checkboxClass = '.form-check-input[name="categoryId"]';
        btnId = '#selectAllCategory';
    }
    const $btn = $(btnId);
    const $checkboxes = $(checkboxClass);
    const $text = $btn.find('.select-all-text');
    const $icon = $btn.find('i');
    if ($checkboxes.length && $checkboxes.filter(':checked').length === $checkboxes.length) {
        $btn.removeClass('btn-outline-success btn-outline-secondary').addClass('btn-success');
        $text.text('All Selected');
        $icon.removeClass().addClass('bi bi-check2-circle me-2');
    } else if ($checkboxes.filter(':checked').length > 0) {
        $btn.removeClass('btn-success btn-outline-success').addClass('btn-outline-secondary');
        $text.text($checkboxes.filter(':checked').length + ' Selected');
        $icon.removeClass().addClass('bi bi-check2 me-2');
    } else {
        $btn.removeClass('btn-success btn-outline-secondary').addClass('btn-outline-success');
        $text.text('Select All');
        $icon.removeClass().addClass('bi bi-check2-circle me-2');
    }
}

document.addEventListener('DOMContentLoaded', function() {
    var sortSelect = document.getElementById('sortSelect');
    if (sortSelect) {
        sortSelect.addEventListener('change', function() {
            var form = sortSelect.closest('form');
            if (form) form.submit();
        });
    }
});