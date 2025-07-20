document.addEventListener('DOMContentLoaded', function () {
    // Handle Unlike button clicks (no alert/confirmation)
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('btn-unlike') || 
            e.target.closest('.btn-unlike')) {
            const form = e.target.closest('form');
            if (form) {
                form.submit();
            }
        }
    });

    // Handle View Details button clicks
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('btn-detail') || 
            e.target.closest('.btn-detail')) {
            // Link will be handled naturally, but we can add loading state
            const link = e.target.closest('a');
            if (link) {
                link.style.opacity = '0.7';
                link.style.pointerEvents = 'none';
                
                // Reset after a short delay
                setTimeout(() => {
                    link.style.opacity = '';
                    link.style.pointerEvents = '';
                }, 1000);
            }
        }
    });

    // Handle Browse Cars button
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('btn-browse-cars') || 
            e.target.closest('.btn-browse-cars')) {
            // Add loading animation
            const button = e.target.closest('.btn-browse-cars');
            if (button) {
                button.style.transform = 'scale(0.95)';
                setTimeout(() => {
                    button.style.transform = '';
                }, 150);
            }
        }
    });

    // Add hover effects for better UX
    document.querySelectorAll('.btn-unlike, .btn-detail').forEach(function(btn) {
        btn.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-1px)';
            this.style.boxShadow = '0 4px 12px rgba(0,0,0,0.15)';
        });
        
        btn.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = '';
        });

        btn.addEventListener('mousedown', function() {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = '0 2px 4px rgba(0,0,0,0.1)';
        });

        btn.addEventListener('mouseup', function() {
            this.style.transform = 'translateY(-1px)';
            this.style.boxShadow = '0 4px 12px rgba(0,0,0,0.15)';
        });
    });

    // Add hover effects for favorite car cards
    document.querySelectorAll('.favorite-car-card').forEach(function(card) {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-2px)';
            this.style.boxShadow = '0 8px 25px rgba(0,0,0,0.1)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = '';
        });
    });

    // Add hover effects for pagination
    document.querySelectorAll('.pagination .page-link').forEach(function(link) {
        link.addEventListener('mouseenter', function() {
            this.style.transform = 'scale(1.05)';
        });
        
        link.addEventListener('mouseleave', function() {
            this.style.transform = 'scale(1)';
        });
    });

    // Add hover effects for status badges
    document.querySelectorAll('.status-badge').forEach(function(badge) {
        badge.addEventListener('mouseenter', function() {
            this.style.transform = 'scale(1.05)';
        });
        
        badge.addEventListener('mouseleave', function() {
            this.style.transform = 'scale(1)';
        });
    });

    // Remove confirmation for form submissions (unlike)
    document.querySelectorAll('form').forEach(function(form) {
        form.addEventListener('submit', function(e) {
            // No confirmation, submit immediately
        });
    });

    // Add loading states for buttons
    document.querySelectorAll('.btn-unlike, .btn-detail, .btn-browse-cars').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            // Add loading state
            const originalText = this.innerHTML;
            this.innerHTML = '<i class="bi bi-arrow-clockwise spin"></i> Loading...';
            this.disabled = true;
            
            // Reset after a delay (in case of navigation)
            setTimeout(() => {
                this.innerHTML = originalText;
                this.disabled = false;
            }, 2000);
        });
    });

    // Add smooth scrolling for pagination
    document.querySelectorAll('.pagination .page-link').forEach(function(link) {
        link.addEventListener('click', function(e) {
            // Smooth scroll to top
            window.scrollTo({
                top: 0,
                behavior: 'smooth'
            });
        });
    });

    // Add keyboard navigation support
    document.addEventListener('keydown', function(e) {
        // Handle Enter key for buttons
        if (e.key === 'Enter') {
            const activeElement = document.activeElement;
            if (activeElement.classList.contains('btn-unlike') || 
                activeElement.classList.contains('btn-detail') ||
                activeElement.classList.contains('btn-browse-cars')) {
                activeElement.click();
            }
        }
    });

    // Add focus styles for accessibility
    document.querySelectorAll('.btn-unlike, .btn-detail, .btn-browse-cars, .page-link').forEach(function(element) {
        element.addEventListener('focus', function() {
            this.style.outline = '2px solid #10b981';
            this.style.outlineOffset = '2px';
        });
        
        element.addEventListener('blur', function() {
            this.style.outline = '';
            this.style.outlineOffset = '';
        });
    });

    // Add error handling for broken images
    document.querySelectorAll('.car-img').forEach(function(img) {
        img.addEventListener('error', function() {
            this.style.display = 'none';
            this.parentElement.style.background = '#f8f9fa url("data:image/svg+xml,<svg xmlns=\'http://www.w3.org/2000/svg\' viewBox=\'0 0 24 24\' fill=\'%23ccc\'><path d=\'M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z\'/></svg>") center/50% no-repeat';
        });
    });

    // Add animation for empty state
    const emptyState = document.querySelector('.text-center.py-5');
    if (emptyState) {
        emptyState.style.opacity = '0';
        emptyState.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            emptyState.style.transition = 'all 0.5s ease';
            emptyState.style.opacity = '1';
            emptyState.style.transform = 'translateY(0)';
        }, 100);
    }

    // Add animation for car cards
    document.querySelectorAll('.favorite-car-card').forEach(function(card, index) {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            card.style.transition = 'all 0.5s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, 100 + (index * 100));
    });
});
