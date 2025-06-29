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
    
    // Cập nhật số lượng filter khi trang load
    updateFilterCount();
    
    console.log('Car page JavaScript initialized successfully');
});