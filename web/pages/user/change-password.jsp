<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password - Auto Rental</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/user/change-password.css">
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
                        <li><a href="FavouriteCar.jsp" class="nav-link">
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
                        <li><a href="change-password.jsp" class="nav-link active">
                            <i class="bi bi-lock"></i>
                            Change password
                        </a></li>
                        <li><a href="request-delete.jsp" class="nav-link">
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
                        <h1 class="h4 fw-semibold mb-1">Change Password</h1>
                        <p class="text-muted mb-0">Update your password to keep your account secure</p>
                    </div>

                    <!-- Success/Error Messages -->
                    <div id="alertContainer"></div>

                    <!-- Password Change Form -->
                    <div class="password-form-container">
                        <form id="passwordForm">
                            <!-- Current Password -->
                            <div class="form-group">
                                <label for="currentPassword" class="form-label">Current Password *</label>
                                <div class="password-input-group">
                                    <input type="password" class="form-control" id="currentPassword" required>
                                    <button type="button" class="password-toggle" onclick="togglePassword('currentPassword')">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                </div>
                            </div>

                            <!-- New Password -->
                            <div class="form-group">
                                <label for="newPassword" class="form-label">New Password *</label>
                                <div class="password-input-group">
                                    <input type="password" class="form-control" id="newPassword" required>
                                    <button type="button" class="password-toggle" onclick="togglePassword('newPassword')">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                </div>
                                
                                <!-- Password Strength Meter -->
                                <div class="strength-meter">
                                    <div class="strength-fill" id="strengthFill"></div>
                                </div>
                                <div class="strength-text" id="strengthText"></div>

                                <!-- Password Requirements -->
                                <div class="password-requirements">
                                    <div class="requirement invalid" id="lengthReq">
                                        <div class="requirement-icon">
                                            <i class="bi bi-check"></i>
                                        </div>
                                        <span>At least 8 characters long</span>
                                    </div>
                                    <div class="requirement invalid" id="uppercaseReq">
                                        <div class="requirement-icon">
                                            <i class="bi bi-check"></i>
                                        </div>
                                        <span>Contains uppercase letter (A-Z)</span>
                                    </div>
                                    <div class="requirement invalid" id="lowercaseReq">
                                        <div class="requirement-icon">
                                            <i class="bi bi-check"></i>
                                        </div>
                                        <span>Contains lowercase letter (a-z)</span>
                                    </div>
                                    <div class="requirement invalid" id="numberReq">
                                        <div class="requirement-icon">
                                            <i class="bi bi-check"></i>
                                        </div>
                                        <span>Contains number (0-9)</span>
                                    </div>
                                    <div class="requirement invalid" id="specialReq">
                                        <div class="requirement-icon">
                                            <i class="bi bi-check"></i>
                                        </div>
                                        <span>Contains special character (!@#$%^&*)</span>
                                    </div>
                                </div>
                            </div>

                            <!-- Confirm Password -->
                            <div class="form-group">
                                <label for="confirmPassword" class="form-label">Confirm New Password *</label>
                                <div class="password-input-group">
                                    <input type="password" class="form-control" id="confirmPassword" required>
                                    <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                        <i class="bi bi-eye"></i>
                                    </button>
                                </div>
                                <div id="passwordMatchMessage" class="mt-2"></div>
                            </div>

                            <!-- Submit Button -->
                            <button type="submit" class="btn btn-primary-custom" id="submitBtn" disabled>
                                <i class="bi bi-shield-check me-2"></i>Update Password
                            </button>
                        </form>

                        <!-- Security Tips -->
                        <div class="security-tips">
                            <h6><i class="bi bi-shield-exclamation me-2"></i>Security Tips</h6>
                            <ul>
                                <li>Use a unique password that you don't use for other accounts</li>
                                <li>Consider using a password manager to generate and store strong passwords</li>
                                <li>Never share your password with anyone</li>
                                <li>Change your password regularly, especially if you suspect it's been compromised</li>
                                <li>Avoid using personal information like names, birthdays, or common words</li>
                            </ul>
                        </div>
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

        // Password strength checker
        function checkPasswordStrength(password) {
            let score = 0;
            const requirements = {
                length: password.length >= 8,
                uppercase: /[A-Z]/.test(password),
                lowercase: /[a-z]/.test(password),
                number: /[0-9]/.test(password),
                special: /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password)
            };

            // Update requirement indicators
            Object.keys(requirements).forEach(req => {
                const element = document.getElementById(req + 'Req');
                if (requirements[req]) {
                    element.classList.remove('invalid');
                    element.classList.add('valid');
                    score++;
                } else {
                    element.classList.remove('valid');
                    element.classList.add('invalid');
                }
            });

            // Update strength meter
            const strengthFill = document.getElementById('strengthFill');
            const strengthText = document.getElementById('strengthText');
            
            strengthFill.className = 'strength-fill';
            
            if (score === 0) {
                strengthText.textContent = '';
            } else if (score <= 2) {
                strengthFill.classList.add('strength-weak');
                strengthText.textContent = 'Weak';
                strengthText.style.color = 'var(--danger-red)';
            } else if (score <= 3) {
                strengthFill.classList.add('strength-fair');
                strengthText.textContent = 'Fair';
                strengthText.style.color = 'var(--warning-orange)';
            } else if (score <= 4) {
                strengthFill.classList.add('strength-good');
                strengthText.textContent = 'Good';
                strengthText.style.color = 'var(--blue)';
            } else {
                strengthFill.classList.add('strength-strong');
                strengthText.textContent = 'Strong';
                strengthText.style.color = 'var(--primary-green)';
            }

            return score;
        }

        // Password match checker
        function checkPasswordMatch() {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const messageDiv = document.getElementById('passwordMatchMessage');
            
            if (confirmPassword === '') {
                messageDiv.innerHTML = '';
                return false;
            }
            
            if (newPassword === confirmPassword) {
                messageDiv.innerHTML = '<small class="text-success"><i class="bi bi-check-circle me-1"></i>Passwords match</small>';
                return true;
            } else {
                messageDiv.innerHTML = '<small class="text-danger"><i class="bi bi-x-circle me-1"></i>Passwords do not match</small>';
                return false;
            }
        }

        // Form validation
        function validateForm() {
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const submitBtn = document.getElementById('submitBtn');
            
            const strengthScore = checkPasswordStrength(newPassword);
            const passwordsMatch = checkPasswordMatch();
            
            const isValid = currentPassword !== '' && 
                           newPassword !== '' && 
                           confirmPassword !== '' &&
                           strengthScore >= 4 && 
                           passwordsMatch &&
                           currentPassword !== newPassword;
            
            submitBtn.disabled = !isValid;
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
        document.getElementById('newPassword').addEventListener('input', validateForm);
        document.getElementById('confirmPassword').addEventListener('input', validateForm);
        document.getElementById('currentPassword').addEventListener('input', validateForm);

        // Form submission
        document.getElementById('passwordForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const currentPassword = document.getElementById('currentPassword').value;
            const newPassword = document.getElementById('newPassword').value;
            
            // Check if new password is different from current
            if (currentPassword === newPassword) {
                showAlert('New password must be different from your current password.', 'error');
                return;
            }
            
            // Simulate API call
            const submitBtn = document.getElementById('submitBtn');
            const originalText = submitBtn.innerHTML;
            
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="bi bi-arrow-clockwise spin me-2"></i>Updating...';
            
            setTimeout(() => {
                // Simulate success
                showAlert('Password updated successfully! Please log in again with your new password.', 'success');
                
                // Reset form
                document.getElementById('passwordForm').reset();
                document.getElementById('passwordMatchMessage').innerHTML = '';
                document.getElementById('strengthText').textContent = '';
                document.getElementById('strengthFill').className = 'strength-fill';
                
                // Reset requirements
                document.querySelectorAll('.requirement').forEach(req => {
                    req.classList.remove('valid');
                    req.classList.add('invalid');
                });
                
                submitBtn.innerHTML = originalText;
                submitBtn.disabled = true;
            }, 2000);
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
    </script>
</body>
</html>