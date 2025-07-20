/**
 * Car Single Page JavaScript
 * Handles car details page functionality including reviews/feedback
 */

document.addEventListener('DOMContentLoaded', function() {
    // Initialize review form submission
    initReviewForm();
    
    // Initialize edit feedback functionality
    initEditFeedback();
    
    // Initialize new review form functionality
    initNewReviewForm();
});

/**
 * Initialize the review form submission
 */
function initReviewForm() {
    const reviewForm = document.getElementById('reviewForm');
    if (reviewForm) {
        reviewForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Get form data
            const formData = new FormData(reviewForm);
            const carId = formData.get('carId');
            const rating = formData.get('rating');
            const content = formData.get('content');
            
            // Get the eligible booking ID for this review
            getEligibleBookingId(carId).then(bookingId => {
                if (bookingId) {
                    // Nếu có bookingId, gửi đánh giá ngay
                    submitReview(carId, bookingId, rating, content);
                } else {
                    // Nếu không có bookingId ngay lập tức, có thể đã được xử lý trong modal
                    // Không cần làm gì thêm vì đã xử lý trong showBookingSelectionModal
                    console.log('Waiting for booking selection from modal...');
                }
            });
        });
    }
}

/**
 * Initialize the new review form functionality
 */
function initNewReviewForm() {
    const showNewReviewFormBtn = document.getElementById('showNewReviewFormBtn');
    const newReviewFormContainer = document.getElementById('newReviewFormContainer');
    const cancelNewReviewBtn = document.getElementById('cancelNewReviewBtn');
    const newReviewForm = document.getElementById('newReviewForm');
    
    if (showNewReviewFormBtn && newReviewFormContainer) {
        // Show form when button is clicked
        showNewReviewFormBtn.addEventListener('click', function() {
            showNewReviewFormBtn.style.display = 'none';
            newReviewFormContainer.style.display = 'block';
        });
        
        // Hide form when cancel button is clicked
        if (cancelNewReviewBtn) {
            cancelNewReviewBtn.addEventListener('click', function() {
                newReviewFormContainer.style.display = 'none';
                showNewReviewFormBtn.style.display = 'block';
            });
        }
        
        // Handle form submission
        if (newReviewForm) {
            newReviewForm.addEventListener('submit', function(e) {
                e.preventDefault();
                
                // Get form data
                const formData = new FormData(newReviewForm);
                const carId = formData.get('carId');
                const rating = formData.get('rating');
                const content = formData.get('content');
                
                // Get the eligible booking ID for this review
                getEligibleBookingId(carId).then(bookingId => {
                    if (bookingId) {
                        // Nếu có bookingId, gửi đánh giá ngay
                        submitReview(carId, bookingId, rating, content);
                    } else {
                        // Nếu không có bookingId ngay lập tức, có thể đã được xử lý trong modal
                        // Không cần làm gì thêm vì đã xử lý trong showBookingSelectionModal
                        console.log('Waiting for booking selection from modal...');
                    }
                });
            });
        }
    }
}

/**
 * Get the eligible booking ID for a review
 * @param {string} carId - The car ID
 * @returns {Promise<string|null>} - The booking ID
 */
function getEligibleBookingId(carId) {
    return fetch(`${contextPath}/feedback?action=getEligibleBooking&carId=${carId}`)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Nếu có nhiều booking ID, hiển thị dropdown để người dùng chọn
                if (data.bookingIds && data.bookingIds.length > 1) {
                    showBookingSelectionModal(data.bookingIds);
                    return null; // Sẽ xử lý trong modal
                }
                return data.bookingId;
            } else {
                console.error('Error getting eligible booking:', data.message);
                return null;
            }
        })
        .catch(error => {
            console.error('Error fetching eligible booking:', error);
            return null;
        });
}

/**
 * Hiển thị modal cho người dùng chọn booking để đánh giá
 * @param {Array<string>} bookingIds - Danh sách booking ID
 */
function showBookingSelectionModal(bookingIds) {
    // Tạo modal nếu chưa có
    if (!document.getElementById('bookingSelectionModal')) {
        const modalHtml = `
        <div class="modal fade" id="bookingSelectionModal" tabindex="-1" aria-labelledby="bookingSelectionModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="bookingSelectionModalLabel">Select Booking to Review</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <p>You have multiple completed bookings for this car. Please select which booking you want to review:</p>
                        <select class="form-select" id="bookingSelector">
                            ${bookingIds.map((id, index) => `<option value="${id}">Booking ${index + 1}</option>`).join('')}
                        </select>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="button" class="btn btn-primary" id="selectBookingBtn">Continue</button>
                    </div>
                </div>
            </div>
        </div>`;
        
        // Thêm modal vào body
        document.body.insertAdjacentHTML('beforeend', modalHtml);
        
        // Xử lý sự kiện khi người dùng chọn booking
        document.getElementById('selectBookingBtn').addEventListener('click', function() {
            const selectedBookingId = document.getElementById('bookingSelector').value;
            const modal = bootstrap.Modal.getInstance(document.getElementById('bookingSelectionModal'));
            modal.hide();
            
            // Lấy thông tin từ form đánh giá
            const reviewForm = document.getElementById('reviewForm');
            const formData = new FormData(reviewForm);
            const carIdValue = formData.get('carId');
            const rating = formData.get('rating');
            const content = formData.get('content');
            
            // Gửi đánh giá với booking ID đã chọn
            submitReview(carIdValue, selectedBookingId, rating, content);
        });
    }
    
    // Hiển thị modal
    const modal = new bootstrap.Modal(document.getElementById('bookingSelectionModal'));
    modal.show();
}

/**
 * Submit a new review
 * @param {string} carId - The car ID
 * @param {string} bookingId - The booking ID
 * @param {number} rating - The rating (1-5)
 * @param {string} content - The review content
 */
function submitReview(carId, bookingId, rating, content) {
    const data = {
        carId: carId,
        bookingId: bookingId,
        rating: rating,
        content: content
    };
    
    fetch(`${contextPath}/feedback`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: new URLSearchParams(data)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Show success message
            const successModal = new bootstrap.Modal(document.getElementById('successModal'));
            successModal.show();
            
            // Reload the page after 2 seconds to show the new review
            setTimeout(() => {
                window.location.reload();
            }, 2000);
        } else {
            showError(data.message || 'Error submitting review');
        }
    })
    .catch(error => {
        console.error('Error submitting review:', error);
        showError('An unexpected error occurred. Please try again.');
    });
}

/**
 * Initialize edit feedback functionality
 */
function initEditFeedback() {
    // Set up edit feedback buttons
    const editButtons = document.querySelectorAll('.edit-feedback');
    editButtons.forEach(button => {
        button.addEventListener('click', function(e) {
            e.preventDefault();
            
            const feedbackId = this.getAttribute('data-feedback-id');
            const rating = this.getAttribute('data-rating');
            const content = this.getAttribute('data-content');
            
            // Set values in the edit form
            document.getElementById('editFeedbackId').value = feedbackId;
            document.getElementById('editRating').value = rating;
            document.getElementById('editContent').value = content;
            
            // Show the edit modal
            const editModal = new bootstrap.Modal(document.getElementById('editFeedbackModal'));
            editModal.show();
        });
    });
    
    // Set up edit form submission
    const editForm = document.getElementById('editFeedbackForm');
    if (editForm) {
        editForm.addEventListener('submit', function(e) {
            e.preventDefault();
            
            const feedbackId = document.getElementById('editFeedbackId').value;
            const rating = document.getElementById('editRating').value;
            const content = document.getElementById('editContent').value;
            
            updateFeedback(feedbackId, rating, content);
        });
    }
}

/**
 * Update an existing feedback
 * @param {string} feedbackId - The feedback ID
 * @param {number} rating - The rating (1-5)
 * @param {string} content - The review content
 */
function updateFeedback(feedbackId, rating, content) {
    const data = {
        feedbackId: feedbackId,
        rating: rating,
        content: content,
        action: 'update'
    };
    
    fetch(`${contextPath}/feedback`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: new URLSearchParams(data)
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            // Hide the edit modal
            const editModal = document.getElementById('editFeedbackModal');
            bootstrap.Modal.getInstance(editModal).hide();
            
            // Show success message
            const updateSuccessModal = new bootstrap.Modal(document.getElementById('updateSuccessModal'));
            updateSuccessModal.show();
            
            // Reload the page after 2 seconds to show the updated review
            setTimeout(() => {
                window.location.reload();
            }, 2000);
        } else {
            showError(data.message || 'Error updating review', 'editFeedbackMessage');
        }
    })
    .catch(error => {
        console.error('Error updating review:', error);
        showError('An unexpected error occurred. Please try again.', 'editFeedbackMessage');
    });
}

/**
 * Show an error message
 * @param {string} message - The error message
 * @param {string} elementId - The ID of the element to show the message in (optional)
 */
function showError(message, elementId = null) {
    if (elementId) {
        const element = document.getElementById(elementId);
        if (element) {
            element.textContent = message;
            element.classList.remove('d-none');
            element.classList.add('alert-danger');
            
            // Hide the message after 5 seconds
            setTimeout(() => {
                element.classList.add('d-none');
            }, 5000);
        }
    } else {
        alert(message);
    }
}

/**
 * Add a car to cart
 * @param {string} carId - The car ID
 */
function addToCart(carId) {
    // Get the current cart from localStorage
    let cart = JSON.parse(localStorage.getItem('cart')) || [];
    
    // Check if the car is already in the cart
    const existingCar = cart.find(item => item.id === carId);
    if (existingCar) {
        alert('This car is already in your cart.');
        return;
    }
    
    // Add the car to the cart
    cart.push({
        id: carId,
        timestamp: new Date().getTime()
    });
    
    // Save the cart to localStorage
    localStorage.setItem('cart', JSON.stringify(cart));
    
    // Show success message
    alert('Car added to cart successfully!');
}