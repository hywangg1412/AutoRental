<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    String successMessage = (String) session.getAttribute("success");
    String errorMessage = (String) session.getAttribute("error");
    
    // Remove attributes after logging
    session.removeAttribute("success");
    session.removeAttribute("error");
%>

<!-- Toast CSS -->
<style>
.toast-container {
    z-index: 12000;
    position: fixed;
    bottom: 0;
    right: 0;
    padding: 1.2rem;
}
.toast.custom-toast {
    background: #fff !important;
    border: 1.5px solid #e0e0e0 !important;
    box-shadow: 0 4px 24px rgba(60,60,60,0.10);
    border-radius: 14px !important;
    min-width: 260px;
    max-width: 380px;
    padding: 0;
    color: #222 !important;
    font-family: 'Poppins', Arial, sans-serif;
    font-size: 0.98rem;
    margin-bottom: 1.2rem;
    opacity: 1;
    transition: box-shadow 0.2s, transform 0.2s;
}
.toast.custom-toast .toast-body {
    font-size: 0.98rem;
    color: #222 !important;
    font-weight: 600;
    letter-spacing: 0.01em;
    flex: 1;
    display: flex;
    align-items: center;
    padding: 0.7rem 1.1rem 0.7rem 1rem;
}
.toast.custom-toast .icon-success {
    color: #4caf50;
    font-size: 1.1em;
    margin-right: 0.7em;
    vertical-align: -2px;
}
.toast.custom-toast .icon-error {
    color: #d32f2f;
    font-size: 1.1em;
    margin-right: 0.7em;
    vertical-align: -2px;
}
.toast.custom-toast .btn-close {
    filter: none;
    opacity: 0.6;
    margin-left: 0.5rem;
    margin-right: 0.2rem;
    margin-top: 0.1rem;
}
.toast.custom-toast .btn-close:hover {
    opacity: 1;
}
@keyframes slideInRight {
    0% { opacity: 0; transform: translateX(100%); }
    100% { opacity: 1; transform: translateX(0); }
}
.toast.slide-in {
    animation: slideInRight 0.5s ease-out forwards;
}
@keyframes slideOutRight {
    0% { opacity: 1; transform: translateX(0); }
    100% { opacity: 0; transform: translateX(120%); }
}
.toast.slide-out {
    animation: slideOutRight 0.7s forwards;
}
@media (max-width: 576px) {
    .toast-container { padding: 0.5rem; }
    .toast.custom-toast { min-width: 200px; max-width: calc(100vw - 1rem); font-size: 0.93rem; }
    .toast.custom-toast .toast-body { font-size: 0.93rem; padding: 0.6rem 0.7rem 0.6rem 0.7rem; }
}
</style>

<!-- Toast Container -->
<div class="toast-container position-fixed bottom-0 end-0 p-3" id="toastContainer">
    <% if (successMessage != null) { %>
    <div class="toast custom-toast align-items-center border-0 slide-in" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex align-items-center">
            <div class="toast-body">
                <i class="bi bi-check-circle-fill icon-success"></i>
                <%= successMessage %>
            </div>
            <button type="button" class="btn-close ms-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
    </div>
    <% } %>
    <% if (errorMessage != null) { %>
    <div class="toast custom-toast align-items-center border-0 slide-in" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="d-flex align-items-center">
            <div class="toast-body" style="color: #d32f2f !important;">
                <i class="bi bi-x-circle-fill icon-error"></i>
                <%= errorMessage %>
            </div>
            <button type="button" class="btn-close ms-2 m-auto" data-bs-dismiss="toast" aria-label="Close"></button>
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
        var toastElList = [].slice.call(document.querySelectorAll('.toast'));
        var toastList = toastElList.map(function(toastEl) {
            toastEl.classList.add('slide-in');
            toastEl.addEventListener('animationend', function handler(e) {
                if (e.animationName === 'slideInRight') {
                    toastEl.classList.remove('slide-in');
                    toastEl.removeEventListener('animationend', handler);
                }
            });
            if (typeof bootstrap !== 'undefined' && bootstrap.Toast) {
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
        setTimeout(() => {
            toastList.forEach((toast) => {
                if (toast) {
                    toast.show();
                }
            });
        }, 100);
    }

    // Global showToast function
    window.showToast = function(message, type = 'success', duration = 3000) {
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
        toast.addEventListener('animationend', function handler(e) {
            if (e.animationName === 'slideInRight') {
                toast.classList.remove('slide-in');
                toast.removeEventListener('animationend', handler);
            }
        });
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
    function initializeToasts() {
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', initializeExistingToasts);
        } else {
            initializeExistingToasts();
        }
    }
    initializeToasts();
})();
</script>
