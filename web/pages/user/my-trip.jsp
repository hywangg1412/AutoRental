<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Trips - Auto Rental</title>

        <!-- ===== External CSS Libraries ===== -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap" rel="stylesheet">

        <!-- ===== Include Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/userNav.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/nav.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/user/my-trip.css">

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
            <div class="row g-5" style="margin-top:100px">
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
                            <li><a href="${pageContext.request.contextPath}/pages/user/my-trip.jsp" class="nav-link active text-dark">
                                    <i class="bi bi-car-front text-dark"></i>
                                    My trips
                                </a></li>
                            <li><a href="${pageContext.request.contextPath}/pages/user/change-password.jsp" class="nav-link text-dark border-top-custom">
                                    <i class="bi bi-lock text-dark"></i>
                                    Change password
                                </a></li>
                            <li><a href="${pageContext.request.contextPath}/pages/user/request-delete.jsp" class="nav-link text-dark border-bottom-custom">
                                    <i class="bi bi-trash text-dark"></i>
                                    Request account deletion
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
                                <!-- Main Content -->
                                <div class="main-content p-4 mt-1">
                                    <!-- Page Header -->
                                    <div class="d-flex justify-content-between align-items-center mb-4">
                                        <h1 class="h5 fw-semibold mb-0 text-dark">My trips</h1>
                                        <button class="filter-btn d-none" id="filterBtn" data-bs-toggle="modal" data-bs-target="#filterModal">
                                            <i class="bi bi-funnel me-2"></i>Filter
                                        </button>
                                    </div>

                                    <!-- Custom Tabs -->
                                    <ul class="nav custom-tabs" id="tripTabs" role="tablist">
                                        <li class="nav-item" role="presentation">
                                            <button class="nav-link active" id="current-trip-tab" data-bs-toggle="tab" 
                                                    data-bs-target="#current-trip" type="button" role="tab">
                                                Current trip
                                            </button>
                                        </li>
                                        <li class="nav-item" role="presentation">
                                            <button class="nav-link" id="trip-history-tab" data-bs-toggle="tab" 
                                                    data-bs-target="#trip-history" type="button" role="tab">
                                                Trip history
                                            </button>
                                        </li>
                                    </ul>

                                    <!-- Tab Content -->
                                    <div class="tab-content" id="tripTabContent">
                                        <!-- Current Trip Tab -->
                                        <div class="tab-pane fade show active" id="current-trip" role="tabpanel">
                                            <div class="empty-state">
                                                <i class="bi bi-car-front" style="font-size: 3rem; color: var(--text-gray); margin-bottom: 1rem;"></i>
                                                <h5 class="mb-3">You have no trip yet</h5>
                                                <p class="text-muted">Start your first trip by booking a car!</p>
                                            </div>
                                        </div>

                                        <!-- Trip History Tab -->
                                        <div class="tab-pane fade" id="trip-history" role="tabpanel">
                                            <div class="empty-state">
                                                <i class="bi bi-clock-history" style="font-size: 3rem; color: var(--text-gray); margin-bottom: 1rem;"></i>
                                                <h5 class="mb-3">You have no trip yet</h5>
                                                <p class="text-muted">Your completed trips will appear here.</p>
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

        <!-- Bootstrap JS -->
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
        <script src="${pageContext.request.contextPath}/scripts/user/UserAboutSidebar.js"></script>

        <script>
            // Show/hide filter button based on active tab
            document.addEventListener('DOMContentLoaded', function () {
                const filterBtn = document.getElementById('filterBtn');
                const tripHistoryTab = document.getElementById('trip-history-tab');
                const currentTripTab = document.getElementById('current-trip-tab');

                // Show filter button when Trip history tab is active
                tripHistoryTab.addEventListener('shown.bs.tab', function () {
                    filterBtn.classList.remove('d-none');
                });

                // Hide filter button when Current trip tab is active
                currentTripTab.addEventListener('shown.bs.tab', function () {
                    filterBtn.classList.add('d-none');
                });
            });

            // Clear filter functionality
            document.querySelector('.btn-clear-filter').addEventListener('click', function () {
                // Reset all form elements
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

            // Add smooth transition effect for tab switching
            document.querySelectorAll('[data-bs-toggle="tab"]').forEach(tab => {
                tab.addEventListener('shown.bs.tab', function (e) {
                    const targetPane = document.querySelector(e.target.getAttribute('data-bs-target'));
                    targetPane.style.animation = 'none';
                    targetPane.offsetHeight; // Trigger reflow
                    targetPane.style.animation = 'fadeIn 0.3s ease-in-out';
                });
            });
        </script>
    </body>
</html>