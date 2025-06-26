document.addEventListener('DOMContentLoaded', function() {
    const dropdowns = document.querySelectorAll('.dropdown');
    
    dropdowns.forEach(dropdown => {
        const toggle = dropdown.querySelector('.dropdown-toggle');
        const menu = dropdown.querySelector('.dropdown-menu');
        let hoverTimeout;
        
        // Click handler (giữ nguyên chức năng click)
        toggle.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            
            // Đóng tất cả dropdown khác
            dropdowns.forEach(otherDropdown => {
                if (otherDropdown !== dropdown) {
                    otherDropdown.classList.remove('show');
                }
            });
            
            // Toggle dropdown hiện tại
            dropdown.classList.toggle('show');
        });
        
        // Hover handlers
        dropdown.addEventListener('mouseenter', function() {
            clearTimeout(hoverTimeout);
            dropdown.classList.add('show');
        });
        
        dropdown.addEventListener('mouseleave', function() {
            // Delay ẩn dropdown một chút để user có thời gian di chuyển chuột
            hoverTimeout = setTimeout(() => {
                dropdown.classList.remove('show');
            }, 150); // 150ms delay
        });
        
        // Giữ dropdown hiển thị khi hover vào menu
        menu.addEventListener('mouseenter', function() {
            clearTimeout(hoverTimeout);
            dropdown.classList.add('show');
        });
        
        menu.addEventListener('mouseleave', function() {
            hoverTimeout = setTimeout(() => {
                dropdown.classList.remove('show');
            }, 150);
        });
    });
    
    // Click outside để đóng dropdown
    document.addEventListener('click', function(e) {
        dropdowns.forEach(dropdown => {
            if (!dropdown.contains(e.target)) {
                dropdown.classList.remove('show');
            }
        });
    });
    
    // ESC key để đóng dropdown
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') {
            dropdowns.forEach(dropdown => {
                dropdown.classList.remove('show');
            });
        }
    });
});