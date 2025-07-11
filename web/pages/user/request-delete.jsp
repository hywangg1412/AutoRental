<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Request Account Deletion - Auto Rental</title>
    
    <!-- ===== External CSS Libraries ===== -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap" rel="stylesheet">
    
    <!-- ===== Include Styles ===== -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/user/request-delete.css">
    
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
    <jsp:include page="/pages/includes/nav.jsp" />
    <div class="container">
        <div class="row g-5" style="margin-top: 80px;">
            <!-- Sidebar -->
            <div class="col-lg-3 col-md-4">
                <div class="sidebar">
                    <h2 class="h2 fw-bold mb-3">Hello !</h2>
                    <ul class="sidebar-menu">
                        <li><a href="${pageContext.request.contextPath}/user/profile" class="nav-link text-dark border-top-custom">
                                <i class="bi bi-person text-dark"></i>
                                My account
                            </a></li>
                        <li><a href="${pageContext.request.contextPath}/pages/user/favorite-car.jsp" class="nav-link text-dark">
                                <i class="bi bi-heart text-dark"></i>
                                Favorite cars
                            </a></li>
                        <li><a href="${pageContext.request.contextPath}/user/my-trip" class="nav-link text-dark">
                                <i class="bi bi-car-front text-dark"></i>
                                My trips
                            </a></li>
                        <li><a href="${pageContext.request.contextPath}/pages/user/change-password.jsp" class="nav-link text-dark border-top-custom">
                                <i class="bi bi-lock text-dark"></i>
                                Change password
                            </a></li>
                        <li><a href="${pageContext.request.contextPath}/pages/user/request-delete.jsp" class="nav-link active text-dark border-bottom-custom">
                                <i class="bi bi-trash text-dark"></i>
                                Request account deletion
                            </a></li>
                        <li><a href="#" class="nav-link text-danger logoutBtn">
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
                </div>
            </div>
        </div>
    </div>
    <jsp:include page="/pages/includes/footer.jsp" />
    <jsp:include page="/pages/includes/logout-confirm-modal.jsp" />
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
    <!-- Account deletion script -->
    <script src="${pageContext.request.contextPath}/scripts/user/request-delete.js"></script>
</body>
</html>