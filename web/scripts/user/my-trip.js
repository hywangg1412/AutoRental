document.addEventListener('DOMContentLoaded', function () {
    // Fix for LogoutModal error
    if (document.getElementById('logoutConfirmModal')) {
        console.log('LogoutModal element found');
    } else {
        console.log('LogoutModal element not found, this is expected if it was included via JSP include');
    }

    let bookingIdToCancel = null;
    let bookingIdToReturn = null;
    // Khi ấn nút Return Car
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('return-car-btn')) {
            bookingIdToReturn = e.target.getAttribute('data-booking-id');
            $('#returnCarModal').modal('show');
        }
    });

    // Khi xác nhận trả xe trong modal
    document.getElementById('confirmReturnCarBtn').addEventListener('click', function() {
        if (!bookingIdToReturn) return;
        fetch(contextPath + '/booking/return-car-request', {
            method: 'POST',
            headers: {'Content-Type': 'application/x-www-form-urlencoded'},
            body: 'bookingId=' + encodeURIComponent(bookingIdToReturn)
        })
        .then(res => res.json())
        .then(data => {
            if (data.success) {
                document.getElementById('returnCarModalMessage').textContent = "Wait for confirmation from staff";
                document.getElementById('returnCarModalMessage').classList.remove('d-none');
                setTimeout(() => { location.reload(); }, 1500);
            } else {
                document.getElementById('returnCarModalMessage').textContent = data.message || "Có lỗi xảy ra!";
                document.getElementById('returnCarModalMessage').classList.remove('d-none');
            }
        })
        .catch(() => {
            document.getElementById('returnCarModalMessage').textContent = "Có lỗi xảy ra!";
            document.getElementById('returnCarModalMessage').classList.remove('d-none');
        });
    });

    // Handle Cancel Booking buttons
    document.addEventListener('click', function(e) {
        const btn = e.target.closest('.btn-mytrip-red');
        if (btn) {
            // Kiểm tra status
            const card = btn.closest('.favorite-car-card');
            const statusBadge = card.querySelector('.status-badge');
            if (statusBadge && statusBadge.textContent.includes('Awaiting Confirmation')) {
                bookingIdToCancel = btn.getAttribute('data-booking-id');
                document.getElementById('cancelBookingIdInput').value = bookingIdToCancel;
                const modal = new bootstrap.Modal(document.getElementById('cancelBookingModal'));
                modal.show();
            }
        }
    });

    // Handle Send Review and View Feedback buttons
    document.addEventListener('click', function(e) {
        if (e.target.classList.contains('btn-mytrip-blue') || 
            e.target.closest('.btn-mytrip-blue') ||
            e.target.classList.contains('btn-mytrip-green') ||
            e.target.closest('.btn-mytrip-green')) {
            
            const button = e.target.classList.contains('btn-mytrip-blue') || e.target.classList.contains('btn-mytrip-green') ? 
                e.target : e.target.closest('.btn-mytrip-blue, .btn-mytrip-green');
            
            if (!button) return;
            
            const bookingId = button.getAttribute('data-booking-id');
            const carId = button.getAttribute('data-car-id');
            const buttonText = button.textContent.trim();
            
            console.log('Button clicked:', buttonText);
            console.log('Booking ID:', bookingId);
            console.log('Car ID:', carId);
            
            if (!carId) {
                console.error('Missing car ID for button:', button);
                alert('Error: Car ID is missing. Please try again later.');
                return;
            }
            
            if (buttonText === 'Send review') {
                if (confirm('Do you want to send a review for this trip?')) {
                    try {
                        // Redirect to car-single.jsp with the review section active
                        console.log('Redirecting to:', contextPath + '/pages/car-single?id=' + carId + '&bookingId=' + bookingId + '#pills-review');
                        window.location.href = contextPath + '/pages/car-single?id=' + carId + '&bookingId=' + bookingId + '#pills-review';
                    } catch (error) {
                        console.error('Error redirecting to review page:', error);
                        alert('Error redirecting to review page. Please try again later.');
                    }
                }
            } else if (buttonText === 'View feedback') {
                try {
                    // Redirect to car-single.jsp with the review section active
                    console.log('Redirecting to:', contextPath + '/pages/car-single?id=' + carId + '&viewFeedback=true&bookingId=' + bookingId + '#pills-review');
                    window.location.href = contextPath + '/pages/car-single?id=' + carId + '&viewFeedback=true&bookingId=' + bookingId + '#pills-review';
                } catch (error) {
                    console.error('Error redirecting to feedback page:', error);
                    alert('Error redirecting to feedback page. Please try again later.');
                }
            }
        }
    });

    // Show/hide filter button based on active tab
    const filterBtn = document.getElementById('filterBtn');
    const tripHistoryTab = document.getElementById('trip-history-tab');
    const currentTripTab = document.getElementById('current-trip-tab');
    if (filterBtn && tripHistoryTab && currentTripTab) {
        tripHistoryTab.addEventListener('shown.bs.tab', function () {
            filterBtn.classList.remove('d-none');
        });
        currentTripTab.addEventListener('shown.bs.tab', function () {
            filterBtn.classList.add('d-none');
        });
    }

    // Clear filter functionality
    const clearFilterBtn = document.querySelector('.btn-clear-filter');
    if (clearFilterBtn) {
        clearFilterBtn.addEventListener('click', function () {
            document.querySelectorAll('#filterModal input[type="radio"]').forEach(radio => {
                if (radio.value === 'all')
                    radio.checked = true;
                else
                    radio.checked = false;
            });
            document.querySelectorAll('#filterModal input[type="text"]').forEach(input => {
                input.value = '';
            });
            document.querySelectorAll('#filterModal select').forEach(select => {
                select.selectedIndex = 0;
            });
        });
    }

    // Add smooth transition effect for tab switching
    document.querySelectorAll('[data-bs-toggle="tab"]').forEach(tab => {
        tab.addEventListener('shown.bs.tab', function (e) {
            const targetPane = document.querySelector(e.target.getAttribute('data-bs-target'));
            if (targetPane) {
                targetPane.style.animation = 'none';
                targetPane.offsetHeight; // Trigger reflow
                targetPane.style.animation = 'fadeIn 0.3s ease-in-out';
            }
        });
    });

    // Handle View Details button clicks
    document.querySelectorAll('.btn-view-details').forEach(function(btn) {
        btn.addEventListener('click', function() {
            document.getElementById('modalBookingCode').textContent = btn.getAttribute('data-booking-code') || 'N/A';
            document.getElementById('modalCarModel').textContent = btn.getAttribute('data-car-model');
            document.getElementById('modalLicensePlate').textContent = btn.getAttribute('data-license-plate');
            document.getElementById('modalPickup').textContent = btn.getAttribute('data-pickup');
            document.getElementById('modalReturn').textContent = btn.getAttribute('data-return');
            document.getElementById('modalTotalAmount').textContent = btn.getAttribute('data-total-amount') + ' VND';

            // Xử lý status
            const status = btn.getAttribute('data-status');
            let statusHtml = '';
            if (status === 'Confirmed') {
                statusHtml = '<span class="status-text-accepted"><i class="bi bi-check-circle-fill"></i> Booking Accepted</span>';
            } else if (status === 'Pending') {
                statusHtml = '<span class="status-text-pending"><i class="bi bi-hourglass-split"></i> Awaiting Confirmation</span>';
            } else if (status === 'IN_PROGRESS') {
                statusHtml = '<span class="status-text-ongoing"><i class="bi bi-car-front"></i> Ongoing</span>';
            } else if (status === 'Completed') {
                statusHtml = '<span class="status-text-completed"><i class="bi bi-flag-fill"></i> Completed</span>';
            } else if (status === 'Cancelled') {
                statusHtml = '<span class="status-text-cancelled"><i class="bi bi-x-circle-fill"></i> Cancelled</span>';
            } else {
                statusHtml = status;
            }
            document.getElementById('modalStatus').innerHTML = statusHtml;

            // Set booking ID for modal return car button
            const bookingId = btn.getAttribute('data-booking-id');
            const modalReturnBtn = document.getElementById('modalReturnCarBtn');
            if (modalReturnBtn) {
                modalReturnBtn.setAttribute('data-booking-id', bookingId);
            }
        });
    });

    // Add hover effects for better UX
    document.querySelectorAll('.btn-mytrip-action').forEach(function(btn) {
        btn.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-1px)';
            this.style.boxShadow = '0 4px 12px rgba(0,0,0,0.15)';
        });
        
        btn.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = '';
        });
    });

    // Prevent default behavior for disabled buttons
    document.querySelectorAll('.btn-mytrip-action:disabled').forEach(function(btn) {
        btn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
        });
    });
});
