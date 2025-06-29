document.addEventListener('DOMContentLoaded', function() {
    console.log('Car.js loaded successfully');
    console.log('Current URL:', window.location.href);
    console.log('Current pathname:', window.location.pathname);
    
    // Kiểm tra contextPath
    if (typeof contextPath === 'undefined') {
        console.error('contextPath is undefined! Please check if it is defined in JSP.');
        return;
    }
    console.log('Context path:', contextPath);
    
    // Debug function to check all elements
    function debugElements() {
        console.log('=== DEBUG ELEMENTS ===');
        console.log('Container exists:', !!document.getElementById('car-list-container'));
        console.log('Form exists:', !!document.querySelector('form[action*="car-list-fragment"]'));
        console.log('Sort select exists:', !!document.querySelector('.sort-select'));
        console.log('Reset button exists:', !!document.getElementById('resetFilterBtn'));
        console.log('Pagination links:', document.querySelectorAll('.pagination-link').length);
        console.log('Filter checkboxes:', document.querySelectorAll('.dropdown-menu input[type="checkbox"]').length);
    }
    
    debugElements();
    
    // FIX 1: Cải thiện hàm lấy tất cả filter params
    function getAllFilterParams() {
        const params = new URLSearchParams();
        
        // Lấy keyword từ search input
        const searchInput = document.querySelector('input[name="keyword"]');
        if (searchInput && searchInput.value.trim()) {
            params.append('keyword', searchInput.value.trim());
        }

        // Lấy sort value
        const sortSelect = document.querySelector('.sort-select') || document.querySelector('select[name="sort"]');
        if (sortSelect && sortSelect.value) {
            params.append('sort', sortSelect.value);
        }

        // Lấy tất cả checkbox filter đã checked
        const filterCheckboxes = document.querySelectorAll('.dropdown-menu input[type="checkbox"]:checked');
        filterCheckboxes.forEach(checkbox => {
            params.append(checkbox.name, checkbox.value);
        });

        // Lấy các filter nâng cao từ modal
        const advancedFilters = ['minPrice', 'maxPrice', 'minYear', 'maxYear'];
        advancedFilters.forEach(name => {
            const input = document.querySelector(`input[name="${name}"]`);
            if (input && input.value.trim()) {
                params.append(name, input.value.trim());
            }
        });

        console.log('Filter params:', params.toString());
        return params.toString();
    }

    function showCarListLoader() {
        console.log('Showing loader...');
        const container = document.getElementById('car-list-container');
        if (container) {
            container.innerHTML = `
                <div class="text-center py-5">
                    <div class="spinner-border text-primary" role="status" style="width: 3rem; height: 3rem;">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mt-3 text-muted">Loading cars...</p>
                </div>
            `;
        }
    }

    // FIX 2: Cải thiện hàm reloadCarList với error handling tốt hơn
    function reloadCarList(params, callback) {
        console.log('=== RELOAD CAR LIST ===');
        console.log('Params:', params);
        
        showCarListLoader();
        
        let url = contextPath + '/pages/car-list-fragment';
        if (params) {
            url += '?' + params;
        }
        
        console.log('Fetching URL:', url);
        
        fetch(url, {
            method: 'GET',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Cache-Control': 'no-cache'
            }
        })
        .then(response => {
            console.log('Response status:', response.status);
            console.log('Response headers:', response.headers);
            
            if (!response.ok) {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }
            return response.text();
        })
        .then(html => {
            console.log('Received HTML length:', html.length);
            console.log('HTML preview:', html.substring(0, 200) + '...');
            
            const container = document.getElementById('car-list-container');
            if (!container) {
                throw new Error('Car list container not found');
            }
            
            // Update container content
            container.innerHTML = html;

            // Debug: Số lượng card xe và trạng thái hiệu ứng
            const carWraps = document.querySelectorAll('.car-wrap');
            const ftcoAnimates = document.querySelectorAll('.ftco-animate');
            console.log('Số lượng .car-wrap:', carWraps.length);
            console.log('Số lượng .ftco-animate:', ftcoAnimates.length);
            ftcoAnimates.forEach((e, idx) => {
                console.log(`Trước contentWayPoint .ftco-animate[${idx}]:`, e.className, '| opacity:', window.getComputedStyle(e).opacity, '| visibility:', window.getComputedStyle(e).visibility);
            });

            // Remove các class hiệu ứng cũ trước khi khởi tạo lại
            ftcoAnimates.forEach(e => {
                e.classList.remove('ftco-animated', 'fadeIn', 'fadeInLeft', 'fadeInRight', 'fadeInUp', 'item-animate');
            });
            console.log('Đã remove các class hiệu ứng cũ cho .ftco-animate');

            // Re-initialize event listeners
            initializeEventListeners();

            // Khởi động lại hiệu ứng ftco-animate nếu có
            if (typeof contentWayPoint === 'function') {
                console.log('Gọi lại contentWayPoint...');
                contentWayPoint();
            } else {
                console.warn('contentWayPoint không tồn tại!');
            }

            // Debug: Trạng thái class sau khi gọi contentWayPoint
            document.querySelectorAll('.ftco-animate').forEach((e, idx) => {
                console.log(`Sau contentWayPoint .ftco-animate[${idx}]:`, e.className, '| opacity:', window.getComputedStyle(e).opacity, '| visibility:', window.getComputedStyle(e).visibility);
            });

            // Khởi động lại hiệu ứng AOS nếu có
            if (window.AOS && typeof AOS.refresh === 'function') {
                console.log('Refreshing AOS...');
                AOS.refresh();
            } else {
                console.warn('AOS hoặc AOS.refresh không tồn tại!');
            }

            // Force trigger scroll để waypoint nhận diện lại vị trí
            console.log('Force trigger scroll event...');
            window.dispatchEvent(new Event('scroll'));
            
            // Execute callback
            if (callback) callback();
            
            console.log('Car list updated successfully');
        })
        .catch(error => {
            console.error('Error reloading car list:', error);
            const container = document.getElementById('car-list-container');
            if (container) {
                container.innerHTML = `
                    <div class="alert alert-danger text-center">
                        <i class="bi bi-exclamation-triangle me-2"></i>
                        Error loading car list: ${error.message}
                        <br><small class="text-muted">Please check browser console for more details.</small>
                        <br><button class="btn btn-outline-danger btn-sm mt-2" onclick="location.reload()">Reload Page</button>
                    </div>
                `;
            }
        });
    }

    // FIX 3: Tách riêng hàm khởi tạo event listeners
    function initializeEventListeners() {
        console.log('Initializing event listeners...');
        
        // Pagination links
        attachPaginationListeners();
        
        // Filter checkboxes
        attachCheckboxListeners();
        
        // Advanced filter modal
        attachAdvancedFilterListener();
    }

    // FIX 4: Cải thiện hàm xử lý pagination
    function attachPaginationListeners() {
        const paginationLinks = document.querySelectorAll('.pagination-link');
        console.log('Attaching pagination listeners:', paginationLinks.length);
        
        paginationLinks.forEach(link => {
            // Remove existing listeners
            link.removeEventListener('click', paginationClickHandler);
            link.addEventListener('click', paginationClickHandler);
        });
    }
    
    function paginationClickHandler(e) {
        e.preventDefault();
        console.log('Pagination clicked');
        
        const page = this.getAttribute('data-page');
        if (!page) {
            console.error('Page number not found');
            return;
        }
        
        const currentParams = getAllFilterParams();
        const newParams = currentParams ? `${currentParams}&page=${page}` : `page=${page}`;
        
        console.log('Loading page:', page);
        reloadCarList(newParams);
    }

    // FIX 5: Cải thiện hàm xử lý filter checkboxes
    function attachCheckboxListeners() {
        const filterCheckboxes = document.querySelectorAll('.dropdown-menu input[type="checkbox"]');
        console.log('Attaching checkbox listeners:', filterCheckboxes.length);
        
        filterCheckboxes.forEach(checkbox => {
            checkbox.removeEventListener('change', checkboxChangeHandler);
            checkbox.addEventListener('change', checkboxChangeHandler);
        });
    }
    
    function checkboxChangeHandler(e) {
        console.log('Checkbox changed:', this.name, this.value, this.checked);
        
        // Debounce để tránh gọi quá nhiều request
        clearTimeout(window.filterTimeout);
        window.filterTimeout = setTimeout(() => {
            reloadCarList(getAllFilterParams());
        }, 300);
    }

    // FIX 6: Xử lý advanced filter modal
    function attachAdvancedFilterListener() {
        const advancedFilterForm = document.querySelector('#advancedFilterModal form');
        if (advancedFilterForm) {
            advancedFilterForm.removeEventListener('submit', advancedFilterSubmitHandler);
            advancedFilterForm.addEventListener('submit', advancedFilterSubmitHandler);
        }
    }
    
    function advancedFilterSubmitHandler(e) {
        e.preventDefault();
        console.log('Advanced filter form submitted');
        
        reloadCarList(getAllFilterParams());
        
        // Close modal
        try {
            const modal = bootstrap.Modal.getInstance(document.getElementById('advancedFilterModal'));
            if (modal) {
                modal.hide();
            }
        } catch (error) {
            console.error('Error closing modal:', error);
        }
    }

    // FIX 7: Xử lý search form
    function initializeSearchForm() {
        const searchForm = document.querySelector('form[action*="car-list-fragment"]') || 
                          document.querySelector('form[method="get"]');
        
        if (searchForm) {
            console.log('Search form found');
            
            searchForm.addEventListener('submit', function(e) {
                e.preventDefault();
                console.log('Search form submitted');
                reloadCarList(getAllFilterParams());
            });
            
            // Handle sort select change
            const sortSelect = searchForm.querySelector('.sort-select') || 
                              searchForm.querySelector('select[name="sort"]');
            
            if (sortSelect) {
                sortSelect.addEventListener('change', function() {
                    console.log('Sort changed to:', this.value);
                    reloadCarList(getAllFilterParams());
                });
            }
        } else {
            console.error('Search form not found');
        }
    }

    // FIX 8: Xử lý reset filter button
    function initializeResetButton() {
        const resetBtn = document.getElementById('resetFilterBtn');
        
        if (resetBtn) {
            console.log('Reset button found');
            
            resetBtn.addEventListener('click', function(e) {
                e.preventDefault();
                console.log('Reset button clicked');
                
                // Clear all inputs
                clearAllFilters();
                
                // Reload with empty params
                reloadCarList('');
            });
        } else {
            console.error('Reset button not found');
        }
    }
    
    function clearAllFilters() {
        // Clear checkboxes
        document.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
            checkbox.checked = false;
        });
        
        // Clear search input
        const searchInput = document.querySelector('input[name="keyword"]');
        if (searchInput) searchInput.value = '';
        
        // Reset sort select
        const sortSelect = document.querySelector('.sort-select') || document.querySelector('select[name="sort"]');
        if (sortSelect) sortSelect.value = '';
        
        // Clear advanced filter inputs
        ['minPrice', 'maxPrice', 'minYear', 'maxYear'].forEach(name => {
            const input = document.querySelector(`input[name="${name}"]`);
            if (input) input.value = '';
        });
    }

    // FIX 9: Khởi tạo tất cả các components
    function initializeAllComponents() {
        console.log('Initializing all components...');
        
        try {
            initializeSearchForm();
            initializeResetButton();
            initializeEventListeners();
            
            console.log('All components initialized successfully');
        } catch (error) {
            console.error('Error initializing components:', error);
        }
    }

    // FIX 10: Khởi tạo ban đầu
    initializeAllComponents();
    
    // Global function để có thể gọi từ bên ngoài
    window.reloadCarList = reloadCarList;
    window.getAllFilterParams = getAllFilterParams;
    
    console.log('Car.js initialization completed');
});