<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Account Deletion - Auto Rental</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/user/request-delete.css">
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center py-3">
                <div class="logo">
                    <span class="text-dark">AUTO</span><span class="text-success">RENTAL</span>
                </div>
                <div class="d-flex align-items-center gap-4">
                    <nav class="nav-links d-flex gap-4">
                        <a href="#" class="fw-medium">About</a>
                        <a href="#" class="fw-medium">My trips</a>
                    </nav>
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-bell"></i>
                        <i class="bi bi-chat-dots"></i>
                        <div class="dropdown">
                            <button class="btn btn-link text-decoration-none text-dark dropdown-toggle d-flex align-items-center gap-2" 
                                    type="button" data-bs-toggle="dropdown">
                                <div class="user-avatar rounded-circle"></div>
                                <span>hywang1412</span>
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#">Profile</a></li>
                                <li><a class="dropdown-item" href="#">Settings</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="#">Logout</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <div class="container-fluid mt-4">
        <div class="row g-4">
            <!-- Sidebar -->
            <div class="col-lg-3">
                <div class="sidebar p-4">
                    <h2 class="h4 fw-bold mb-4">Hello !</h2>
                    <ul class="sidebar-menu">
                        <li><a href="my-account.jsp" class="nav-link">
                            <i class="bi bi-person"></i>
                            My account
                        </a></li>
                        <li><a href="favorite-car.jsp" class="nav-link">
                            <i class="bi bi-heart"></i>
                            Favorite cars
                        </a></li>
                        <li><a href="my-trip.jsp" class="nav-link">
                            <i class="bi bi-car-front"></i>
                            My trips
                        </a></li>
                        <li><a href="longterm-booking.jsp" class="nav-link">
                            <i class="bi bi-clipboard-check"></i>
                            Long-term car rental orders
                        </a></li>
                        <li><a href="my-address.jsp" class="nav-link">
                            <i class="bi bi-geo-alt"></i>
                            My address
                        </a></li>
                        <li><a href="change-password.jsp" class="nav-link">
                            <i class="bi bi-lock"></i>
                            Change password
                        </a></li>
                        <li><a href="request-delete.jsp" class="nav-link active">
                            <i class="bi bi-trash"></i>
                            Request account deletion
                        </a></li>
                        <li class="mt-3"><a href="#" class="nav-link text-danger">
                            <i class="bi bi-box-arrow-right"></i>
                            Log out
                        </a></li>
                    </ul>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-lg-9">
                <div class="main-content p-4">
                    <!-- Page Header -->
                    <div class="mb-4">
                        <h1 class="h4 fw-semibold mb-1">Request Account Deletion</h1>
                        <p class="text-muted mb-0">Permanently delete your Auto Rental account and all associated data</p>
                    </div>

                    <!-- Step Indicator -->
                    <div class="step-indicator">
                        <div class="step active">
                            <i class="bi bi-exclamation-triangle"></i>
                            <span>Account Deletion Request</span>
                        </div>
                    </div>

                    <!-- Success/Error Messages -->
                    <div id="alertContainer"></div>

                    <!-- Account Deletion Form -->
                    <div class="deletion-form-container">
                        <!-- Warning Section -->
                        <div class="warning-section">
                            <div class="warning-icon">
                                <i class="bi bi-exclamation-triangle"></i>
                            </div>
                            <div class="warning-title">Account Deletion is Permanent</div>
                            <div class="warning-text">
                                Once you delete your account, there is no going back. Please be certain before proceeding.
                            </div>
                        </div>

                        <!-- Consequences Section -->
                        <div class="consequences-section">
                            <div class="consequences-title">
                                <i class="bi bi-x-circle"></i>
                                What will be deleted:
                            </div>
                            <ul class="consequences-list">
                                <li>
                                    <i class="bi bi-dot"></i>
                                    <span>Your profile information and personal data</span>
                                </li>
                                <li>
                                    <i class="bi bi-dot"></i>
                                    <span>All trip history and booking records</span>
                                </li>
                                <li>
                                    <i class="bi bi-dot"></i>
                                    <span>Saved favorite cars and preferences</span>
                                </li>
                                <li>
                                    <i class="bi bi-dot"></i>
                                    <span>Stored addresses and payment methods</span>
                                </li>
                                <li>
                                    <i class="bi bi-dot"></i>
                                    <span>Reviews and ratings you've given</span>
                                </li>
                                <li>
                                    <i class="bi bi-dot"></i>
                                    <span>Loyalty points and rewards</span>
                                </li>
                                <li>
                                    <i class="bi bi-dot"></i>
                                    <span>Access to ongoing or future bookings</span>
                                </li>
                            </ul>
                        </div>

                        <!-- Alternatives Section -->
                        <div class="alternatives-section">
                            <div class="alternatives-title">
                                <i class="bi bi-lightbulb"></i>
                                Consider these alternatives:
                            </div>
                            <ul class="alternatives-list">
                                <li>
                                    <i class="bi bi-pause-circle"></i>
                                    <span><strong>Temporarily deactivate</strong> your account instead of permanent deletion</span>
                                </li>
                                <li>
                                    <i class="bi bi-gear"></i>
                                    <span><strong>Update privacy settings</strong> to limit data collection and usage</span>
                                </li>
                                <li>
                                    <i class="bi bi-bell-slash"></i>
                                    <span><strong>Disable notifications</strong> if you're receiving too many emails</span>
                                </li>
                                <li>
                                    <i class="bi bi-shield-check"></i>
                                    <span><strong>Change your password</strong> if you're concerned about security</span>
                                </li>
                            </ul>
                        </div>

                        <!-- Contact Section -->
                        <div class="contact-section">
                            <div class="contact-title">Need Help?</div>
                            <div class="contact-text">
                                Our support team is here to help resolve any issues you might have. 
                                Consider reaching out before deleting your account.
                            </div>
                            <div class="contact-info">
                                <div class="contact-item">
                                    <i class="bi bi-envelope"></i>
                                    <span>support@autorental.com</span>
                                </div>
                                <div class="contact-item">
                                    <i class="bi bi-telephone"></i>
                                    <span>+84 (0) 123 456 789</span>
                                </div>
                                <div class="contact-item">
                                    <i class="bi bi-chat-dots"></i>
                                    <span>Live Chat</span>
                                </div>
                            </div>
                        </div>

                        <!-- Deletion Form -->
                        <form id="deletionForm">
                            <!-- Reason for Deletion -->
                            <div class="form-group">
                                <label for="deletionReason" class="form-label">Reason for deletion *</label>
                                <select class="form-select" id="deletionReason" required>
                                    <option value="">Please select a reason</option>
                                    <option value="privacy-concerns">Privacy concerns</option>
                                    <option value="not-using-service">Not using the service anymore</option>
                                    <option value="found-alternative">Found an alternative service</option>
                                    <option value="too-expensive">Service is too expensive</option>
                                    <option value="poor-experience">Poor user experience</option>
                                    <option value="technical-issues">Technical issues</option>
                                    <option value="account-security">Account security concerns</option>
                                    <option value="other">Other</option>
                                </select>
                            </div>

                            <!-- Additional Comments -->
                            <div class="form-group">
                                <label for="additionalComments" class="form-label">Additional comments (optional)</label>
                                <textarea class="form-control" id="additionalComments" rows="4" 
                                         placeholder="Help us improve by sharing more details about your decision..."></textarea>
                            </div>

                            <!-- Password Confirmation -->
                            <div class="form-group">
                                <label for="passwordConfirm" class="form-label">Confirm your password *</label>
                                <div class="password-input-group">
                                    <input type="password" class="form-control" id="passwordConfirm" 
                                           placeholder="Enter your current password" required>
                                    <button type="button" class="password-toggle" onclick="togglePassword('passwordConfirm')">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                </div>
                            </div>

                            <!-- Confirmation Section -->
                            <div class="confirmation-section">
                                <div class="confirmation-title">Type "DELETE MY ACCOUNT" to confirm</div>
                                <div class="confirmation-text">
                                    This action cannot be undone. Type the exact phrase below to confirm account deletion:
                                </div>
                                <input type="text" class="form-control confirmation-input" id="confirmationText" 
                                       placeholder="DELETE MY ACCOUNT" required>
                            </div>

                            <!-- Checkboxes -->
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="dataUnderstanding" required>
                                <label class="form-check-label" for="dataUnderstanding">
                                    I understand that all my data will be permanently deleted and cannot be recovered
                                </label>
                            </div>

                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="bookingUnderstanding" required>
                                <label class="form-check-label" for="bookingUnderstanding">
                                    I confirm that I have no active bookings or outstanding payments
                                </label>
                            </div>

                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="finalConfirmation" required>
                                <label class="form-check-label" for="finalConfirmation">
                                    I want to permanently delete my Auto Rental account
                                </label>
                            </div>

                            <!-- Action Buttons -->
                            <button type="button" class="btn btn-outline-custom" onclick="window.history.back()">
                                <i class="bi bi-arrow-left me-2"></i>Cancel and Go Back
                            </button>
                            
                            <button type="submit" class="btn btn-danger-custom" id="deleteBtn" disabled>
                                <i class="bi bi-trash me-2"></i>Delete My Account Permanently
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Password visibility toggle
        function togglePassword(fieldId) {
            const field = document.getElementById(fieldId);
            const button = field.nextElementSibling;
            const icon = button.querySelector('i');
            
            if (field.type === 'password') {
                field.type = 'text';
                icon.className = 'bi bi-eye-slash';
            } else {
                field.type = 'password';
                icon.className = 'bi bi-eye';
            }
        }

        // Confirmation text validation
        function validateConfirmationText() {
            const input = document.getElementById('confirmationText');
            const expectedText = 'DELETE MY ACCOUNT';
            const isValid = input.value === expectedText;
            
            input.classList.remove('valid', 'invalid');
            if (input.value !== '') {
                input.classList.add(isValid ? 'valid' : 'invalid');
            }
            
            return isValid;
        }

        // Form validation
        function validateForm() {
            const reason = document.getElementById('deletionReason').value;
            const password = document.getElementById('passwordConfirm').value;
            const confirmationText = validateConfirmationText();
            const dataCheck = document.getElementById('dataUnderstanding').checked;
            const bookingCheck = document.getElementById('bookingUnderstanding').checked;
            const finalCheck = document.getElementById('finalConfirmation').checked;
            
            const isValid = reason !== '' && 
                           password !== '' && 
                           confirmationText &&
                           dataCheck && 
                           bookingCheck && 
                           finalCheck;
            
            document.getElementById('deleteBtn').disabled = !isValid;
        }

        // Show alert message
        function showAlert(message, type) {
            const alertContainer = document.getElementById('alertContainer');
            const alertClass = type === 'success' ? 'alert-success-custom' : 'alert-danger-custom';
            const icon = type === 'success' ? 'bi-check-circle' : 'bi-exclamation-triangle';
            
            alertContainer.innerHTML = `
                <div class="alert-custom ${alertClass}">
                    <i class="bi ${icon} me-2"></i>${message}
                </div>
            `;
            
            // Auto-hide after 5 seconds
            setTimeout(() => {
                alertContainer.innerHTML = '';
            }, 5000);
        }

        // Event listeners
        document.getElementById('deletionReason').addEventListener('change', validateForm);
        document.getElementById('passwordConfirm').addEventListener('input', validateForm);
        document.getElementById('confirmationText').addEventListener('input', function() {
            validateConfirmationText();
            validateForm();
        });
        document.getElementById('dataUnderstanding').addEventListener('change', validateForm);
        document.getElementById('bookingUnderstanding').addEventListener('change', validateForm);
        document.getElementById('finalConfirmation').addEventListener('change', validateForm);

        // Form submission
        document.getElementById('deletionForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            // Final confirmation dialog
            const confirmed = confirm(
                'This is your final warning!\n\n' +
                'Are you absolutely sure you want to delete your account?\n\n' +
                'This action is PERMANENT and CANNOT be undone.\n\n' +
                'Click OK to proceed with account deletion, or Cancel to abort.'
            );
            
            if (!confirmed) {
                return;
            }
            
            // Simulate API call
            const deleteBtn = document.getElementById('deleteBtn');
            const originalText = deleteBtn.innerHTML;
            
            deleteBtn.disabled = true;
            deleteBtn.innerHTML = '<i class="bi bi-arrow-clockwise spin me-2"></i>Processing Deletion...';
            
            setTimeout(() => {
                // Simulate successful deletion
                showAlert(
                    'Account deletion request submitted successfully. You will receive a confirmation email shortly. ' +
                    'Your account will be permanently deleted within 30 days unless you cancel the request.',
                    'success'
                );
                
                // Reset form
                document.getElementById('deletionForm').reset();
                document.getElementById('confirmationText').classList.remove('valid', 'invalid');
                
                deleteBtn.innerHTML = originalText;
                deleteBtn.disabled = true;
                
                // Redirect after 3 seconds
                setTimeout(() => {
                    window.location.href = 'profile.jsp';
                }, 3000);
            }, 3000);
        });

        // Add CSS for spin animation
        const style = document.createElement('style');
        style.textContent = `
            .spin {
                animation: spin 1s linear infinite;
            }
            @keyframes spin {
                from { transform: rotate(0deg); }
                to { transform: rotate(360deg); }
            }
        `;
        document.head.appendChild(style);

        // Show additional fields for "Other" reason
        document.getElementById('deletionReason').addEventListener('change', function() {
            const commentsGroup = document.getElementById('additionalComments').closest('.form-group');
            const label = commentsGroup.querySelector('label');
            
            if (this.value === 'other') {
                label.innerHTML = 'Please specify your reason *';
                document.getElementById('additionalComments').required = true;
            } else {
                label.innerHTML = 'Additional comments (optional)';
                document.getElementById('additionalComments').required = false;
            }
        });
    </script>
</body>
</html>