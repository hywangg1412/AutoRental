// Car page JavaScript - Form submit thông thường (không dùng AJAX)

document.addEventListener('DOMContentLoaded', function() {
    console.log('Car page loaded - using traditional form submit');
    
    // Xử lý filter dropdown - tự động submit khi chọn
    const filterCheckboxes = document.querySelectorAll('.dropdown-menu input[type="checkbox"]');
    filterCheckboxes.forEach(checkbox => {
        checkbox.addEventListener('change', function() {
            console.log('Filter changed:', this.name, this.value, this.checked);
            // Tạo form tạm thời để submit
            submitFilterForm();
        });
    });
    
    // Xử lý sort select - tự động submit khi thay đổi
    const sortSelect = document.getElementById('sortSelect');
    if (sortSelect) {
        sortSelect.addEventListener('change', function() {
            console.log('Sort changed:', this.value);
            submitFilterForm();
        });
    }
    
    // Xử lý reset filter button
    const resetFilterBtn = document.getElementById('resetFilterBtn');
    if (resetFilterBtn) {
        resetFilterBtn.addEventListener('click', function() {
            console.log('Reset filter clicked');
            // Reset tất cả checkbox
            filterCheckboxes.forEach(checkbox => {
                checkbox.checked = false;
            });
            // Reset sort select
            if (sortSelect) {
                sortSelect.value = '';
            }
            // Submit form
            submitFilterForm();
        });
    }
    
    // Hàm submit form filter
    function submitFilterForm() {
        // Tạo form tạm thời
        const form = document.createElement('form');
        form.method = 'GET';
        form.action = contextPath + '/pages/car';
        
        // Thêm keyword nếu có
        const keywordInput = document.querySelector('input[name="keyword"]');
        if (keywordInput && keywordInput.value.trim()) {
            const keywordField = document.createElement('input');
            keywordField.type = 'hidden';
            keywordField.name = 'keyword';
            keywordField.value = keywordInput.value.trim();
            form.appendChild(keywordField);
        }
        
        // Thêm sort nếu có
        if (sortSelect && sortSelect.value) {
            const sortField = document.createElement('input');
            sortField.type = 'hidden';
            sortField.name = 'sort';
            sortField.value = sortSelect.value;
            form.appendChild(sortField);
        }
        
        // Thêm các filter đã chọn
        filterCheckboxes.forEach(checkbox => {
            if (checkbox.checked) {
                const field = document.createElement('input');
                field.type = 'hidden';
                field.name = checkbox.name;
                field.value = checkbox.value;
                form.appendChild(field);
            }
        });
        
        // Thêm advanced filter nếu có
        const minPrice = document.querySelector('input[name="minPrice"]');
        const maxPrice = document.querySelector('input[name="maxPrice"]');
        const minYear = document.querySelector('input[name="minYear"]');
        const maxYear = document.querySelector('input[name="maxYear"]');
        
        if (minPrice && minPrice.value) {
            const field = document.createElement('input');
            field.type = 'hidden';
            field.name = 'minPrice';
            field.value = minPrice.value;
            form.appendChild(field);
        }
        
        if (maxPrice && maxPrice.value) {
            const field = document.createElement('input');
            field.type = 'hidden';
            field.name = 'maxPrice';
            field.value = maxPrice.value;
            form.appendChild(field);
        }
        
        if (minYear && minYear.value) {
            const field = document.createElement('input');
            field.type = 'hidden';
            field.name = 'minYear';
            field.value = minYear.value;
            form.appendChild(field);
        }
        
        if (maxYear && maxYear.value) {
            const field = document.createElement('input');
            field.type = 'hidden';
            field.name = 'maxYear';
            field.value = maxYear.value;
            form.appendChild(field);
        }
        
        // Submit form
        document.body.appendChild(form);
        form.submit();
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
        // Lưu trạng thái checkbox khi modal mở
        let originalCheckboxStates = {};
        
        // Khi modal mở
        brandFilterModal.addEventListener('show.bs.modal', function() {
            console.log('Brand filter modal opening');
            
            // Lưu trạng thái hiện tại của các checkbox
            const checkboxes = brandFilterModal.querySelectorAll('input[type="checkbox"]');
            checkboxes.forEach(checkbox => {
                originalCheckboxStates[checkbox.value] = checkbox.checked;
            });
        });
        
        // Khi modal đóng mà không apply
        brandFilterModal.addEventListener('hidden.bs.modal', function(event) {
            // Nếu modal đóng do click Cancel hoặc click outside
            if (!event.target.classList.contains('btn-primary')) {
                console.log('Brand filter modal closed without applying');
                
                // Khôi phục trạng thái checkbox ban đầu
                const checkboxes = brandFilterModal.querySelectorAll('input[type="checkbox"]');
                checkboxes.forEach(checkbox => {
                    if (originalCheckboxStates.hasOwnProperty(checkbox.value)) {
                        checkbox.checked = originalCheckboxStates[checkbox.value];
                    }
                });
            }
        });
        
        // Xử lý nút Cancel
        const cancelBtn = brandFilterModal.querySelector('.btn-secondary');
        if (cancelBtn) {
            cancelBtn.addEventListener('click', function() {
                console.log('Cancel button clicked');
                
                // Khôi phục trạng thái checkbox ban đầu
                const checkboxes = brandFilterModal.querySelectorAll('input[type="checkbox"]');
                checkboxes.forEach(checkbox => {
                    if (originalCheckboxStates.hasOwnProperty(checkbox.value)) {
                        checkbox.checked = originalCheckboxStates[checkbox.value];
                    }
                });
            });
        }
        
        // Xử lý hover effect cho checkbox labels
        const checkboxLabels = brandFilterModal.querySelectorAll('.form-check-label');
        checkboxLabels.forEach(label => {
            label.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px)';
                this.style.boxShadow = '0 4px 12px rgba(34, 197, 94, 0.15)';
            });
            
            label.addEventListener('mouseleave', function() {
                this.style.transform = '';
                this.style.boxShadow = '';
            });
        });
        
        // Xử lý select all/none functionality (tùy chọn)
        const selectAllBtn = document.createElement('button');
        selectAllBtn.type = 'button';
        selectAllBtn.className = 'btn btn-outline-secondary btn-sm mb-3';
        selectAllBtn.innerHTML = '<i class="bi bi-check-all me-1"></i>Select All';
        
        const selectNoneBtn = document.createElement('button');
        selectNoneBtn.type = 'button';
        selectNoneBtn.className = 'btn btn-outline-secondary btn-sm mb-3 ms-2';
        selectNoneBtn.innerHTML = '<i class="bi bi-x-circle me-1"></i>Clear All';
        
        // Thêm buttons vào modal header
        const modalBody = brandFilterModal.querySelector('.modal-body');
        if (modalBody) {
            const buttonContainer = document.createElement('div');
            buttonContainer.className = 'd-flex justify-content-between align-items-center mb-3';
            buttonContainer.appendChild(selectAllBtn);
            buttonContainer.appendChild(selectNoneBtn);
            
            // Insert buttons vào đầu modal body
            modalBody.insertBefore(buttonContainer, modalBody.firstChild);
        }
        
        // Xử lý select all
        selectAllBtn.addEventListener('click', function() {
            const checkboxes = brandFilterModal.querySelectorAll('input[type="checkbox"]');
            checkboxes.forEach(checkbox => {
                checkbox.checked = true;
            });
            updateSelectAllButtonText();
        });
        
        // Xử lý select none
        selectNoneBtn.addEventListener('click', function() {
            const checkboxes = brandFilterModal.querySelectorAll('input[type="checkbox"]');
            checkboxes.forEach(checkbox => {
                checkbox.checked = false;
            });
            updateSelectAllButtonText();
        });
        
        // Cập nhật text của select all button
        function updateSelectAllButtonText() {
            const checkboxes = brandFilterModal.querySelectorAll('input[type="checkbox"]');
            const checkedCount = Array.from(checkboxes).filter(cb => cb.checked).length;
            
            if (checkedCount === 0) {
                selectAllBtn.innerHTML = '<i class="bi bi-check-all me-1"></i>Select All';
            } else if (checkedCount === checkboxes.length) {
                selectAllBtn.innerHTML = '<i class="bi bi-check-all me-1"></i>All Selected';
            } else {
                selectAllBtn.innerHTML = `<i class="bi bi-check-all me-1"></i>${checkedCount} Selected`;
            }
        }
        
        // Cập nhật text khi checkbox thay đổi
        const checkboxes = brandFilterModal.querySelectorAll('input[type="checkbox"]');
        checkboxes.forEach(checkbox => {
            checkbox.addEventListener('change', updateSelectAllButtonText);
        });
        
        // Khởi tạo text ban đầu
        updateSelectAllButtonText();
    }
    
    // =========================== CATEGORY FILTER MODAL ===========================
    
    // Xử lý modal Category filter
    const categoryFilterModal = document.getElementById('categoryFilterModal');
    if (categoryFilterModal) {
        // Lưu trạng thái checkbox khi modal mở
        let originalCategoryCheckboxStates = {};
        
        // Khi modal mở
        categoryFilterModal.addEventListener('show.bs.modal', function() {
            console.log('Category filter modal opening');
            
            // Lưu trạng thái hiện tại của các checkbox
            const checkboxes = categoryFilterModal.querySelectorAll('input[type="checkbox"]');
            checkboxes.forEach(checkbox => {
                originalCategoryCheckboxStates[checkbox.value] = checkbox.checked;
            });
        });
        
        // Khi modal đóng mà không apply
        categoryFilterModal.addEventListener('hidden.bs.modal', function(event) {
            // Nếu modal đóng do click Cancel hoặc click outside
            if (!event.target.classList.contains('btn-primary')) {
                console.log('Category filter modal closed without applying');
                
                // Khôi phục trạng thái checkbox ban đầu
                const checkboxes = categoryFilterModal.querySelectorAll('input[type="checkbox"]');
                checkboxes.forEach(checkbox => {
                    if (originalCategoryCheckboxStates.hasOwnProperty(checkbox.value)) {
                        checkbox.checked = originalCategoryCheckboxStates[checkbox.value];
                    }
                });
            }
        });
        
        // Xử lý nút Cancel
        const cancelBtn = categoryFilterModal.querySelector('.btn-secondary');
        if (cancelBtn) {
            cancelBtn.addEventListener('click', function() {
                console.log('Category cancel button clicked');
                
                // Khôi phục trạng thái checkbox ban đầu
                const checkboxes = categoryFilterModal.querySelectorAll('input[type="checkbox"]');
                checkboxes.forEach(checkbox => {
                    if (originalCategoryCheckboxStates.hasOwnProperty(checkbox.value)) {
                        checkbox.checked = originalCategoryCheckboxStates[checkbox.value];
                    }
                });
            });
        }
        
        // Xử lý hover effect cho checkbox labels
        const categoryCheckboxLabels = categoryFilterModal.querySelectorAll('.form-check-label');
        categoryCheckboxLabels.forEach(label => {
            label.addEventListener('mouseenter', function() {
                this.style.transform = 'translateY(-2px)';
                this.style.boxShadow = '0 4px 12px rgba(34, 197, 94, 0.15)';
            });
            
            label.addEventListener('mouseleave', function() {
                this.style.transform = '';
                this.style.boxShadow = '';
            });
        });
        
        // Xử lý select all/none functionality
        const categorySelectAllBtn = document.createElement('button');
        categorySelectAllBtn.type = 'button';
        categorySelectAllBtn.className = 'btn btn-outline-secondary btn-sm mb-3';
        categorySelectAllBtn.innerHTML = '<i class="bi bi-check-all me-1"></i>Select All';
        
        const categorySelectNoneBtn = document.createElement('button');
        categorySelectNoneBtn.type = 'button';
        categorySelectNoneBtn.className = 'btn btn-outline-secondary btn-sm mb-3 ms-2';
        categorySelectNoneBtn.innerHTML = '<i class="bi bi-x-circle me-1"></i>Clear All';
        
        // Thêm buttons vào modal header
        const categoryModalBody = categoryFilterModal.querySelector('.modal-body');
        if (categoryModalBody) {
            const categoryButtonContainer = document.createElement('div');
            categoryButtonContainer.className = 'd-flex justify-content-between align-items-center mb-3';
            categoryButtonContainer.appendChild(categorySelectAllBtn);
            categoryButtonContainer.appendChild(categorySelectNoneBtn);
            
            // Insert buttons vào đầu modal body
            categoryModalBody.insertBefore(categoryButtonContainer, categoryModalBody.firstChild);
        }
        
        // Xử lý select all
        categorySelectAllBtn.addEventListener('click', function() {
            const checkboxes = categoryFilterModal.querySelectorAll('input[type="checkbox"]');
            checkboxes.forEach(checkbox => {
                checkbox.checked = true;
            });
            updateCategorySelectAllButtonText();
        });
        
        // Xử lý select none
        categorySelectNoneBtn.addEventListener('click', function() {
            const checkboxes = categoryFilterModal.querySelectorAll('input[type="checkbox"]');
            checkboxes.forEach(checkbox => {
                checkbox.checked = false;
            });
            updateCategorySelectAllButtonText();
        });
        
        // Cập nhật text của select all button
        function updateCategorySelectAllButtonText() {
            const checkboxes = categoryFilterModal.querySelectorAll('input[type="checkbox"]');
            const checkedCount = Array.from(checkboxes).filter(cb => cb.checked).length;
            
            if (checkedCount === 0) {
                categorySelectAllBtn.innerHTML = '<i class="bi bi-check-all me-1"></i>Select All';
            } else if (checkedCount === checkboxes.length) {
                categorySelectAllBtn.innerHTML = '<i class="bi bi-check-all me-1"></i>All Selected';
            } else {
                categorySelectAllBtn.innerHTML = `<i class="bi bi-check-all me-1"></i>${checkedCount} Selected`;
            }
        }
        
        // Cập nhật text khi checkbox thay đổi
        const categoryCheckboxes = categoryFilterModal.querySelectorAll('input[type="checkbox"]');
        categoryCheckboxes.forEach(checkbox => {
            checkbox.addEventListener('change', updateCategorySelectAllButtonText);
        });
        
        // Khởi tạo text ban đầu
        updateCategorySelectAllButtonText();
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