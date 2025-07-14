<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String successMessage = (String) session.getAttribute("success");
    String errorMessage = (String) session.getAttribute("error");
    
    // Debug: Log messages to console
    if (successMessage != null) {
        System.out.println("DEBUG: Success message found: " + successMessage);
    }
    if (errorMessage != null) {
        System.out.println("DEBUG: Error message found: " + errorMessage);
    }
    
    // Remove attributes after logging
    session.removeAttribute("success");
    session.removeAttribute("error");
%>

<!-- Toast CSS -->
<style>
/* Toast Container */
.toast-container {
    z-index: 9999;
    position: fixed;
    bottom: 0;
    right: 0;
    padding: 1rem;
}

/* Toast Styling */
.toast {
    border-radius: 10px !important;
    box-shadow: 0 4px 24px rgba(0,0,0,0.12), 0 1.5px 4px rgba(0,0,0,0.08);
    font-family: 'Poppins', Arial, sans-serif;
    font-size: 1.05rem;
    padding: 1rem 1.5rem;
    min-width: 320px;
    max-width: 400px;
    margin-bottom: 1.2rem;
    opacity: 1;
    transition: box-shadow 0.2s, transform 0.2s;
    background: #01d28e !important;
    border: none !important;
}

.toast.bg-danger {
    background: linear-gradient(90deg, #e74c3c 0%, #c0392b 100%) !important;
}

.toast.bg-warning {
    background: linear-gradient(90deg, #f39c12 0%, #e67e22 100%) !important;
}

.toast.bg-info {
    background: linear-gradient(90deg, #3498db 0%, #2980b9 100%) !important;
}

.toast .toast-body {
    font-weight: 500;
    letter-spacing: 0.01em;
    display: flex;
    align-items: center;
    color: white !important;
}

.toast .fa-check-circle, 
.toast .fa-exclamation-circle,
.toast .fa-exclamation-triangle,
.toast .fa-info-circle {
    font-size: 1.3em;
    margin-right: 0.7em;
}

.toast .btn-close {
    filter: invert(1);
    opacity: 0.7;
    transition: opacity 0.2s;
}

.toast .btn-close:hover {
    opacity: 1;
}

/* Slide In Animation */
@keyframes slideInRight {
    0% {
        opacity: 0;
        transform: translateX(100%);
    }
    100% {
        opacity: 1;
        transform: translateX(0);
    }
}

.toast.slide-in {
    animation: slideInRight 0.5s ease-out forwards;
}

/* Slide Out Animation */
@keyframes slideOutRight {
    0% {
        opacity: 1;
        transform: translateX(0);
    }
    100% {
        opacity: 0;
        transform: translateX(120%);
    }
}

.toast.slide-out {
    animation: slideOutRight 0.7s forwards;
}

/* Responsive */
@media (max-width: 576px) {
    .toast-container {
        padding: 0.5rem;
    }
    
    .toast {
        min-width: 280px;
        max-width: calc(100vw - 1rem);
        font-size: 0.95rem;
        padding: 0.8rem 1.2rem;
    }
}
</style>

<!-- Toast Container -->
<div class="toast-container position-fixed bottom-0 end-0 p-3" id="toastContainer">
    <% if (successMessage != null) { %>
    <div class="toast align-items-center text-white bg-success border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-check-circle me-2"></i>
                <%= successMessage %>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
    <% } %>
    
    <% if (errorMessage != null) { %>
    <div class="toast align-items-center text-white bg-danger border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex">
            <div class="toast-body">
                <i class="fas fa-exclamation-circle me-2"></i>
                <%= errorMessage %>
            </div>
            <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
    <% } %>
</div>

<!-- Toast JavaScript -->
<script>
// Toast notification system
(function() {
    // Initialize existing toasts on page load
    function initializeExistingToasts() {
        console.log('DEBUG: Initializing existing toasts...');
        var toastElList = [].slice.call(document.querySelectorAll('.toast'));
        console.log('DEBUG: Found', toastElList.length, 'existing toasts');
        
        var toastList = toastElList.map(function(toastEl) {
            toastEl.classList.add('slide-in');
            toastEl.addEventListener('animationend', function handler(e) {
                if (e.animationName === 'slideInRight') {
                    toastEl.classList.remove('slide-in');
                    toastEl.removeEventListener('animationend', handler);
                }
            });
            
            if (typeof bootstrap !== 'undefined' && bootstrap.Toast) {
                console.log('DEBUG: Bootstrap Toast available');
                var bsToast = new bootstrap.Toast(toastEl, {
                    animation: true,
                    autohide: true,
                    delay: 3000 
                });
                toastEl.addEventListener('hide.bs.toast', () => {
                    toastEl.classList.add('slide-out');
                });
                toastEl.addEventListener('hidden.bs.toast', () => {
                    toastEl.remove();
                });
                return bsToast;
            }
            return null;
        });
        
        // Show toasts after a short delay to ensure animations work
        setTimeout(() => {
            console.log('DEBUG: Showing', toastList.length, 'toasts');
            toastList.forEach((toast, index) => {
                if (toast) {
                    console.log('DEBUG: Showing toast', index);
                    toast.show();
                }
            });
        }, 100);
    }

    // Global showToast function
    window.showToast = function(message, type = 'success', duration = 3000) {
        console.log('showToast called:', message, type); // Debug log
        
        let container = document.querySelector('.toast-container');
        if (!container) {
            container = document.createElement('div');
            container.className = 'toast-container position-fixed bottom-0 end-0 p-3';
            container.id = 'toastContainer';
            document.body.appendChild(container);
        }
        
        // Determine background class and icon based on type
        let bgClass, iconClass;
        switch(type) {
            case 'success':
                bgClass = 'bg-success';
                iconClass = 'fa-check-circle';
                break;
            case 'error':
                bgClass = 'bg-danger';
                iconClass = 'fa-exclamation-circle';
                break;
            case 'warning':
                bgClass = 'bg-warning';
                iconClass = 'fa-exclamation-triangle';
                break;
            case 'info':
                bgClass = 'bg-info';
                iconClass = 'fa-info-circle';
                break;
            default:
                bgClass = 'bg-success';
                iconClass = 'fa-check-circle';
        }
        
        const toast = document.createElement('div');
        toast.className = `toast align-items-center text-white border-0 ${bgClass} slide-in`;
        toast.setAttribute('role', 'alert');
        toast.setAttribute('aria-live', 'assertive');
        toast.setAttribute('aria-atomic', 'true');
        toast.innerHTML = `
            <div class="d-flex">
                <div class="toast-body">
                    <i class="fas ${iconClass} me-2"></i>
                    ${message}
                </div>
                <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
        `;
        
        container.appendChild(toast);
        
        // Handle animation end
        toast.addEventListener('animationend', function handler(e) {
            if (e.animationName === 'slideInRight') {
                toast.classList.remove('slide-in');
                toast.removeEventListener('animationend', handler);
            }
        });
        
        // Use Bootstrap Toast if available, otherwise use custom implementation
        if (typeof bootstrap !== 'undefined' && bootstrap.Toast) {
            const bsToast = new bootstrap.Toast(toast, {
                animation: true,
                autohide: true,
                delay: duration
            });
            
            toast.addEventListener('hide.bs.toast', () => {
                toast.classList.add('slide-out');
            });
            
            toast.addEventListener('hidden.bs.toast', () => {
                if (toast.parentNode) {
                    toast.parentNode.removeChild(toast);
                }
            });
            
            bsToast.show();
        } else {
            // Fallback: custom toast implementation
            setTimeout(() => {
                toast.classList.add('slide-out');
                setTimeout(() => {
                    if (toast.parentNode) {
                        toast.parentNode.removeChild(toast);
                    }
                }, 700);
            }, duration);
        }
    };

    // Initialize when DOM is ready
    function initializeToasts() {
        console.log('DEBUG: Initializing toasts, readyState:', document.readyState);
        if (document.readyState === 'loading') {
            console.log('DEBUG: DOM still loading, adding event listener');
            document.addEventListener('DOMContentLoaded', initializeExistingToasts);
        } else {
            console.log('DEBUG: DOM already ready, initializing immediately');
            initializeExistingToasts();
        }
    }
    
    console.log('DEBUG: Toast system script loaded');
    initializeToasts();
})();
</script>
