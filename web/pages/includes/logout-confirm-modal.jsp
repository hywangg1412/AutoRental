<!-- Logout Confirmation Modal -->
<div class="modal fade" id="logoutConfirmModal" tabindex="-1" aria-labelledby="logoutConfirmModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered">
    <div class="modal-content custom-modal-content">
      <div class="modal-header border-0 pb-0 justify-content-end">
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body text-center pt-0">
        <h2 class="modal-title fw-bold mb-3" id="logoutConfirmModalLabel" style="font-size: 2rem;">Log out</h2>
        <div class="mb-4" style="font-size: 1.1rem;">Are you sure you want to log out?</div>
        <form action="${pageContext.request.contextPath}/logout" method="get">
          <button type="submit" class="btn btn-save-modal">Log out</button>
        </form>
      </div>
    </div>
  </div>
</div>

<style>
/* =========================== MODAL ANIMATION =========================== */
/* Zoom animation for all modals */
.modal.fade .modal-dialog {
  transition: transform 0.18s cubic-bezier(0.4,0,0.2,1), opacity 0.15s cubic-bezier(0.4,0,0.2,1);
  transform: scale(0.8);
  opacity: 0;
}
.modal.fade.show .modal-dialog {
  transform: scale(1);
  opacity: 1;
}

/* =========================== MODAL CONTENT =========================== */
.modal-content {
    border-radius: 16px !important;
    padding: 0 0 1.5rem 0;
    box-shadow: 0 8px 32px rgba(0,0,0,0.12);
    border: none !important;
}

.custom-modal-content {
  border-radius: 18px;
  box-shadow: 0 8px 32px rgba(60,60,60,0.18);
  padding: 1.5rem 1.5rem 2rem 1.5rem;
  max-width: 400px;
  margin: auto;
  display: flex;
  flex-direction: column;
  align-items: center;
}

/* =========================== MODAL HEADER =========================== */
.modal-header {
    border: none !important;
    padding-top: 1.5rem !important;
    padding-bottom: 1.5rem !important;
    justify-content: center;
}

.custom-modal-content .modal-header {
  border-bottom: none;
  width: 100%;
  justify-content: flex-end;
  padding-bottom: 0;
}

.modal-header .btn-close {
    position: absolute;
    right: 1.5rem;
    top: 1.5rem;
    z-index: 2;
}

.custom-modal-content .btn-close {
  font-size: 1.3rem;
  margin-right: 0.5rem;
  margin-top: 0.5rem;
}

.btn-close {
    top: 1.2rem;
    right: 1.2rem;
    position: absolute;
    z-index: 10;
    opacity: 0.7;
    transition: opacity 0.15s;
}
.btn-close:hover {
    opacity: 1;
}
.btn-close:focus, .btn-close:active {
    outline: none !important;
    box-shadow: none !important;
}

/* =========================== MODAL TITLE =========================== */
.modal-title {
    width: 100%;
    text-align: center;
    font-size: 2rem !important;
    font-weight: 700 !important;
    margin: 0.5rem 0 0.5rem 0;
    color: #222;
    letter-spacing: -0.5px;
}

.custom-modal-content .modal-title {
  font-weight: 700;
  color: #222;
  font-size: 2rem;
  width: 100%;
  text-align: center;
}

/* =========================== MODAL BODY =========================== */
.modal-body {
    padding-top: 0 !important;
    padding-bottom: 0.5rem !important;
}

.custom-modal-content .modal-body {
  width: 100%;
  padding-top: 0;
  padding-bottom: 0;
}

.custom-modal-content .modal-body > div {
  width: 100%;
  text-align: center;
}

.modal-body .form-control,
.modal-body .form-select {
    border-radius: 10px;
    font-size: 1.15rem;
    padding: 0.9rem 1.1rem;
    margin-bottom: 1.2rem;
}

.modal-body .form-label {
    font-size: 1.1rem;
    font-weight: 500;
    margin-bottom: 0.4rem;
}

/* =========================== MODAL FOOTER =========================== */
.modal-footer {
    border: none !important;
    padding-top: 0 !important;
    padding-bottom: 2rem !important;
    background: transparent !important;
}

/* =========================== MODAL BUTTONS =========================== */
.btn-save-modal {
    width: 100%;
    border-radius: 12px !important;
    font-size: 1.3rem;
    font-weight: 600;
    padding: 1.2rem 2rem;
    background: #6fdc8c !important;
    color: #fff !important;
    border: none !important;
    box-shadow: 0 2px 8px rgba(0,0,0,0.07);
    transition: background 0.2s, box-shadow 0.2s;
    line-height: 3 !important;
    text-align: center;
}

.btn-save-modal:hover, .btn-save-modal:focus {
    background: #4ec16e !important;
    color: #fff !important;
    box-shadow: 0 4px 16px rgba(0,0,0,0.13);
}

.custom-modal-content .btn-save-modal {
  background: #4ade80;
  border: none;
  color: #222;
  font-weight: 600;
  transition: background 0.2s;
  border-radius: 12px;
  font-size: 1rem;
  width: 100%;
  padding: 0.5rem 0;
  margin-top: 0.5rem;
}

.custom-modal-content .btn-save-modal:hover {
  background: #22c55e;
  color: #fff;
}

.btn-success.w-100 {
    background: #4ade80 !important;
    color: #fff !important;
    border: none !important;
    border-radius: 12px !important;
    font-size: 1.1rem;
    font-weight: 600;
    box-shadow: 0 2px 8px rgba(16,185,129,0.10);
    transition: background 0.18s, box-shadow 0.18s;
}
.btn-success.w-100:hover, .btn-success.w-100:focus {
    background: #22c55e !important;
    color: #fff !important;
    box-shadow: 0 4px 16px rgba(34,197,94,0.15);
    transform: translateY(-1px);
}

.btn-success.w-100:active {
    transform: translateY(0);
    box-shadow: 0 2px 8px rgba(34,197,94,0.15);
}

/* =========================== MODAL DIALOG =========================== */
.modal-dialog-centered {
    align-items: flex-start !important;
}

.modal-dialog {
    margin-top: 4vh !important;
}

/* Đưa modal lên phía trên màn hình */
#logoutConfirmModal .modal-dialog {
  display: flex;
  align-items: flex-start;
  min-height: 100vh;
}
#logoutConfirmModal .modal-content {
  margin-top: 40px;
}

/* Rút ngắn hiệu ứng fade của modal */
#logoutConfirmModal.modal.fade .modal-dialog {
  transition: transform 0.15s cubic-bezier(0.4,0,0.2,1), opacity 0.15s cubic-bezier(0.4,0,0.2,1);
}

/* Zoom animation for modal */
#logoutConfirmModal .modal-dialog {
  transition: transform 0.18s cubic-bezier(0.4,0,0.2,1), opacity 0.15s cubic-bezier(0.4,0,0.2,1);
  transform: scale(0.8);
  opacity: 0;
}
#logoutConfirmModal.show .modal-dialog {
  transform: scale(1);
  opacity: 1;
}

/* =========================== FILTER MODAL STYLES =========================== */
.filter-modal .modal-header {
    border-bottom: 1px solid var(--border-gray);
    padding: 1.5rem;
}

.filter-modal .modal-body {
    padding: 1.5rem;
}

.filter-modal .modal-footer {
    border-top: 1px solid var(--border-gray);
    padding: 1.5rem;
}

.filter-section {
    margin-bottom: 1.5rem;
}

.filter-label {
    font-weight: 500;
    color: #333;
    margin-bottom: 0.75rem;
    display: block;
}

.filter-options {
    display: flex;
    gap: 1rem;
    margin-bottom: 1rem;
}

.filter-radio {
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.filter-radio input[type="radio"] {
    accent-color: var(--primary-green);
}

.filter-radio label {
    font-size: 0.875rem;
    color: var(--text-gray);
    margin: 0;
}

.filter-radio input[type="radio"]:checked + label {
    color: var(--primary-green);
    font-weight: 500;
}

.btn-clear-filter {
    background: transparent;
    border: 1px solid var(--border-gray);
    color: var(--text-gray);
    padding: 0.75rem 1.5rem;
    border-radius: 6px;
    transition: all 0.2s;
}

.btn-clear-filter:hover {
    background-color: #f3f4f6;
    border-color: var(--text-gray);
    color: var(--text-gray);
}

.btn-apply-filter {
    background-color: var(--primary-green);
    border-color: var(--primary-green);
    color: white;
    padding: 0.75rem 1.5rem;
    border-radius: 6px;
    transition: all 0.2s;
}

.btn-apply-filter:hover {
    background-color: #059669;
    border-color: #059669;
    color: white;
}

/* =========================== MODAL DIVIDERS =========================== */
hr.mt-0.mb-4 {
    margin-top: 0 !important;
    margin-bottom: 0 !important;
    border-top: 1px solid #d1d5db !important;
    opacity: 1 !important;
}

hr.mytrip-divider {
    width: 100%;
    border: none;
    border-top: 1px solid #222 !important;
    margin-top: 0.5rem !important;
    margin-bottom: 1.5rem !important;
    opacity: 1 !important;
}

/* =========================== MODAL SECTIONS =========================== */
.mytrip-modal-section {
    font-size: 1.08rem;
    font-weight: 600;
    color: #222;
    margin-bottom: 0.5rem;
    margin-top: 1.2rem;
    display: flex;
    align-items: center;
    gap: 0.5rem;
}

.mytrip-modal-label {
    color: #888;
    font-size: 1rem;
    font-weight: 500;
    margin-bottom: 0.1rem;
}

.mytrip-modal-value {
    color: #111;
    font-size: 1.05rem;
    font-weight: 600;
    margin-bottom: 0.5rem;
}

/* =========================== STATUS TEXT COLORS =========================== */
.status-text-accepted {
    color: #10b981;
    font-weight: 600;
}
.status-text-pending {
    color: #f59e0b;
    font-weight: 600;
}
.status-text-ongoing {
    color: #2563eb;
    font-weight: 600;
}
.status-text-completed {
    color: #6b7280;
    font-weight: 600;
}
.status-text-cancelled {
    color: #dc2626;
    font-weight: 600;
}

/* =========================== CSS VARIABLES =========================== */
:root {
    --primary-green: #10b981;
    --light-green: #f0fdf4;
    --warning-orange: #f59e0b;
    --danger-red: #dc2626;
    --light-gray: #f8f9fa;
    --border-gray: #e5e7eb;
    --text-gray: #6b7280;
}
</style>

<script>
// Fixed Logout Modal Script
class LogoutModal {
    constructor() {
        this.modal = null;
        this.modalElement = null;
        this.isInitialized = false;
        this.eventListeners = [];
    }

    init() {
        if (this.isInitialized) {
            console.log('Modal already initialized');
            return;
        }

        try {
            this.modalElement = document.getElementById('logoutConfirmModal');
            if (!this.modalElement) {
                console.error('Modal element not found');
                return;
            }

            // Initialize Bootstrap modal
            if (typeof bootstrap !== 'undefined' && bootstrap.Modal) {
                this.modal = new bootstrap.Modal(this.modalElement);
                console.log('Bootstrap modal initialized');
            } else {
                console.warn('Bootstrap not available, using fallback');
            }

            this.attachEventListeners();
            this.isInitialized = true;
            console.log('Logout modal initialized successfully');
        } catch (error) {
            console.error('Modal initialization error:', error);
        }
    }

    attachEventListeners() {
        // Clear existing listeners
        this.removeEventListeners();

        // Logout button listeners
        const logoutButtons = document.querySelectorAll('.logoutBtn, #logoutBtn');
        console.log(`Found ${logoutButtons.length} logout buttons`);

        logoutButtons.forEach((btn, index) => {
            const listener = (e) => {
                e.preventDefault();
                e.stopPropagation();
                console.log(`Logout button ${index + 1} clicked`);
                this.show();
            };
            
            btn.addEventListener('click', listener);
            this.eventListeners.push({ element: btn, event: 'click', listener });
        });

        // Close button listeners
        const closeButtons = this.modalElement.querySelectorAll('.btn-close');
        closeButtons.forEach(btn => {
            const listener = (e) => {
                e.preventDefault();
                e.stopPropagation();
                console.log('Close button clicked');
                this.hide();
            };
            
            btn.addEventListener('click', listener);
            this.eventListeners.push({ element: btn, event: 'click', listener });
        });

        // ESC key handler
        const escListener = (e) => {
            if (e.key === 'Escape' && this.isVisible()) {
                console.log('ESC key pressed');
                this.hide();
            }
        };
        
        document.addEventListener('keydown', escListener);
        this.eventListeners.push({ element: document, event: 'keydown', listener: escListener });

        // Click outside handler
        const outsideListener = (e) => {
            if (e.target === this.modalElement) {
                console.log('Clicked outside modal');
                this.hide();
            }
        };
        
        this.modalElement.addEventListener('click', outsideListener);
        this.eventListeners.push({ element: this.modalElement, event: 'click', listener: outsideListener });
    }

    removeEventListeners() {
        this.eventListeners.forEach(({ element, event, listener }) => {
            element.removeEventListener(event, listener);
        });
        this.eventListeners = [];
    }

    show() {
        try {
            if (this.modal) {
                this.modal.show();
                console.log('Modal shown via Bootstrap');
            } else {
                this.showFallback();
            }
        } catch (error) {
            console.error('Show error:', error);
            this.showFallback();
        }
    }

    hide() {
        try {
            if (this.modal) {
                this.modal.hide();
                console.log('Modal hidden via Bootstrap');
            } else {
                this.hideFallback();
            }
        } catch (error) {
            console.error('Hide error:', error);
            this.hideFallback();
        }
    }

    showFallback() {
        this.modalElement.classList.add('show');
        this.modalElement.style.display = 'block';
        this.modalElement.setAttribute('aria-hidden', 'false');
        document.body.classList.add('modal-open');
        
        // Add backdrop
        if (!document.querySelector('.modal-backdrop[data-logout-modal="true"]')) {
            const backdrop = document.createElement('div');
            backdrop.className = 'modal-backdrop fade show';
            backdrop.setAttribute('data-logout-modal', 'true');
            document.body.appendChild(backdrop);
        }
        
        console.log('Fallback modal shown');
    }

    hideFallback() {
        // Chuyển focus ra ngoài modal trước khi ẩn (fix aria-hidden warning)
        if (document.activeElement && this.modalElement.contains(document.activeElement)) {
            let tempBtn = document.createElement('button');
            tempBtn.style.position = 'fixed';
            tempBtn.style.left = '-9999px';
            document.body.appendChild(tempBtn);
            tempBtn.focus();
            setTimeout(() => tempBtn.remove(), 100);
        }

        this.modalElement.classList.remove('show');
        this.modalElement.style.display = 'none';
        this.modalElement.setAttribute('aria-hidden', 'true');
        document.body.classList.remove('modal-open');
        
        // Remove only our backdrop
        document.querySelectorAll('.modal-backdrop[data-logout-modal="true"]').forEach(backdrop => backdrop.remove());
        
        console.log('Fallback modal hidden');
    }

    isVisible() {
        return this.modalElement && this.modalElement.classList.contains('show');
    }

    destroy() {
        this.removeEventListeners();
        if (this.modal) {
            this.modal.dispose();
        }
        this.isInitialized = false;
        console.log('Modal destroyed');
    }
}

// Global modal instance
let logoutModalInstance = null;

function initializeLogoutModal() {
    // Prevent multiple initializations
    if (logoutModalInstance) {
        console.log('Modal already exists');
        return;
    }

    // Wait for Bootstrap to be available
    const maxWait = 5000; // 5 seconds
    const startTime = Date.now();
    
    const checkAndInit = () => {
        if (typeof bootstrap !== 'undefined' || Date.now() - startTime > maxWait) {
            logoutModalInstance = new LogoutModal();
            logoutModalInstance.init();
        } else {
            setTimeout(checkAndInit, 100);
        }
    };
    
    checkAndInit();
}

// Initialize when DOM is ready
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializeLogoutModal);
} else {
    initializeLogoutModal();
}

// Backup initialization
window.addEventListener('load', () => {
    setTimeout(() => {
        if (!logoutModalInstance) {
            initializeLogoutModal();
        }
    }, 500);
});

// Global functions for testing
window.showLogoutModal = function() {
    if (logoutModalInstance) {
        logoutModalInstance.show();
    } else {
        console.error('Modal not initialized');
    }
};

window.hideLogoutModal = function() {
    if (logoutModalInstance) {
        logoutModalInstance.hide();
    }
};

console.log('Logout modal script loaded');
</script>
