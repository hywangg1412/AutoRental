<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Change Password - Auto Rental</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap" rel="stylesheet">
    <!-- ===== Include Styles ===== -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/userNav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/user/change-password.css">
    <!-- ===== Custom Styles ===== -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/open-iconic-bootstrap.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animate.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owl.carousel.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owl.theme.default.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/magnific-popup.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/aos.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ionicons.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap-datepicker.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/jquery.timepicker.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/flaticon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/icomoon.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
    <!-- Header -->
    <jsp:include page="/pages/includes/staff-profile-nav.jsp" />
    <div class="container">
        <div class="row g-5" style="margin-top: 80px;">
            <!-- Sidebar -->
            <div class="col-lg-3 col-md-4">
                <div class="sidebar">
                    <h2 class="h2 fw-bold mb-3">Hello !</h2>
                    <ul class="sidebar-menu">
                        <li><a href="${pageContext.request.contextPath}/staff/profile" class="nav-link text-dark border-top-custom">
                                <i class="bi bi-person text-dark"></i>
                                My account
                            </a></li>
                        <li><a href="${pageContext.request.contextPath}/pages/staff/profile/staff-change-password.jsp" class="nav-link active text-dark border-top-custom">
                                <i class="bi bi-lock text-dark"></i>
                                Change password
                            </a></li>
                        <li><a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger">
                                <i class="bi bi-box-arrow-right"></i>
                                Log out
                            </a></li>
                    </ul>
                </div>
            </div>
            <!-- Main content -->
            <div class="col-lg-9 col-md-8">
                <div class="main-content">
                    <div class="container mt-4">
                        <div class="row g-5">
                            <div class="main-content p-4 mt-1">
                                <div class="account-info-block mb-4 p-4 bg-white rounded shadow-sm w-100" style="max-width:900px;margin-left:auto;margin-right:auto;">
                                    <!-- Page Header -->
                                    <div class="mb-4">
                                        <h1 class="h4 fw-semibold mb-1">Change Password</h1>
                                        <p class="text-muted mb-0">Update your password to keep your account secure</p>
                                    </div>
                                    <!-- Success/Error Messages -->
                                    <div id="alertContainer"></div>
                                    <!-- Password Change Form -->
                                    <div class="password-form-container">
                                        <form id="passwordForm" action="${pageContext.request.contextPath}/user/change-password" method="post">
                                            <input type="hidden" name="fromStaffProfile" value="true" />
                                            <!-- Current Password -->
                                            <div class="form-group">
                                                <label for="currentPassword" class="form-label">Current Password *</label>
                                                <div class="password-input-group">
                                                    <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                                                    <button type="button" class="password-toggle" onclick="togglePassword('currentPassword')">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                </div>
                                            </div>
                                            <!-- New Password -->
                                            <div class="form-group">
                                                <label for="newPassword" class="form-label">New Password *</label>
                                                <div class="password-input-group">
                                                    <input type="password" class="form-control" id="newPassword" name="newPassword" required>
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
                                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" required>
                                                    <button type="button" class="password-toggle" onclick="togglePassword('confirmPassword')">
                                                        <i class="bi bi-eye"></i>
                                                    </button>
                                                </div>
                                                <div id="passwordMatchMessage" class="mt-2"></div>
                                            </div>
                                            <!-- Submit Button -->
                                            <button type="submit" class="btn btn-save-modal w-100 d-flex align-items-center justify-content-center gap-2" id="submitBtn" disabled>
                                                <i class="bi bi-shield-check"></i>
                                                Update Password
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
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/pages/includes/footer.jsp" />
    <!-- Bootstrap JS & Custom Scripts giống UserAbout -->
    <div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/></svg></div>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery-migrate-3.0.1.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.easing.1.3.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.waypoints.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.stellar.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/aos.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.animateNumber.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap-datepicker.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.timepicker.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scrollax.min.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBVWaKrjvy3MaE7SQ74_uJiULgl1JY0H2s&sensor=false"></script>
    <script src="${pageContext.request.contextPath}/assets/js/google-map.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Giữ lại các script quản lý password như cũ -->
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