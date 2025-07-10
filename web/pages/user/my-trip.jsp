<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="Model.Constants.BookingStatusConstants" %>
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
        <!-- <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/user/favorite-car.css"> -->
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
                            <li><a href="${pageContext.request.contextPath}/user/favorite-car-page" class="nav-link text-dark">
                                    <i class="bi bi-heart text-dark"></i>
                                    Favorite cars
                                </a></li>
                            <li><a href="${pageContext.request.contextPath}/user/my-trip" class="nav-link active text-dark">
                                    <i class="bi bi-car-front text-dark"></i>
                                    My trips
                                </a></li>
                            <li><a href="${pageContext.request.contextPath}/user/change-password" class="nav-link text-dark border-top-custom">
                                    <i class="bi bi-lock text-dark"></i>
                                    Change password
                                </a></li>
                            <li><a href="${pageContext.request.contextPath}/user/request-delete" class="nav-link text-dark border-bottom-custom">
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
                                            <c:choose>
                                                <c:when test="${not empty currentTrips}">
                                                    <div class="row">
                                                        <c:forEach var="trip" items="${currentTrips}">
                                                            <div class="col-12 mb-4">
                                                                <div class="favorite-car-card d-flex align-items-center p-4 rounded shadow-sm bg-white">
                                                                    <div class="car-img-wrapper">
                                                                        <img src="${pageContext.request.contextPath}${trip.carImage}" class="car-img" alt="Car image">
                                                                    </div>
                                                                    <div class="flex-grow-1 ps-3 pe-4">
                                                                        <div class="d-flex align-items-center mb-2">
                                                                            <div class="car-title-badge d-flex align-items-center">
                                                                                <h5 class="mb-0 fw-bold me-3">${trip.carModel}</h5>
                                                                                <span class="badge status-badge ms-0">${trip.status}</span>
                                                                            </div>
                                                                        </div>
                                                                        <div class="mb-2 text-muted small fs-7 d-flex align-items-center car-info-inline">
                                                                            <span class="me-3"><i class="bi bi-car-front me-1"></i>${trip.carLicensePlate}</span>
                                                                        </div>
                                                                        <div class="mb-2 text-muted small fs-7 d-flex align-items-center car-info-inline">
                                                                            <span class="me-3"><i class="bi bi-calendar me-1"></i>${trip.formattedPickupDateTime} - ${trip.formattedReturnDateTime}</span>
                                                                        </div>
                                                                        <span class="price-new fw-bold fs-6 text-success me-3" style="margin-bottom:0;">
                                                                            <fmt:formatNumber value="${trip.totalAmount}" type="number" pattern="#.###" /> VND
                                                                        </span>
                                                                    </div>
                                                                    <div class="mytrip-btn-group">
                                                                        <button class="btn-mytrip-action btn-detail" data-bs-toggle="modal" data-bs-target="#modal-${trip.bookingId}">
                                                                            View Details
                                                                        </button>
                                                                        <c:if test="${trip.status eq BookingStatusConstants.CONFIRMED || trip.status eq BookingStatusConstants.IN_PROGRESS}">
                                                                            <button class="btn-mytrip-action btn-mytrip-green btn-sm">Return Car</button>
                                                                        </c:if>
                                                                        <c:if test="${trip.status eq BookingStatusConstants.PENDING}">
                                                                            <button class="btn-mytrip-action btn-mytrip-red btn-sm">Cancel Booking</button>
                                                                        </c:if>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="empty-state">
                                                        <i class="bi bi-car-front" style="font-size: 3rem; color: var(--text-gray); margin-bottom: 1rem;"></i>
                                                        <h5 class="mb-3">You have no trip yet</h5>
                                                        <p class="text-muted">Start your first trip by booking a car!</p>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>

                                        <!-- Trip History Tab -->
                                        <div class="tab-pane fade" id="trip-history" role="tabpanel">
                                            <div class="table-responsive">
                                                <table class="table">
                                                    <thead>
                                                        <tr>
                                                            <th>Booking code</th>
                                                            <th>Car</th>
                                                            <th>Pick-up date</th>
                                                            <th>Return date</th>
                                                            <th>Status</th>
                                                            <th>Amount</th>
                                                            <th>Action</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                    <c:choose>
                                                        <c:when test="${not empty bookingRequests}">
                                                            <c:forEach items="${bookingRequests}" var="booking">
                                                                <tr>
                                                                    <!-- Booking detail modal (like staff) -->
                                                                    <div class="modal fade" id="modal-${booking.bookingId}" tabindex="-1" aria-labelledby="modalLabel-${booking.bookingId}" aria-hidden="true">
                                                                        <div class="modal-dialog modal-lg">
                                                                            <div class="modal-content">
                                                                                <div class="modal-header">
                                                                                    <h5 class="modal-title" id="modalLabel-${booking.bookingId}">Booking details - ${booking.bookingCode}</h5>
                                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                                </div>
                                                                                <div class="modal-body">
                                                                                    <!-- Booking details, like staff -->
                                                                                    <h6>Car information</h6>
                                                                                    <p>Model: ${booking.carModel}</p>
                                                                                    <p>License plate: ${booking.carLicensePlate}</p>
                                                                                    <h6>Rental period</h6>
                                                                                    <p>Pick-up: ${booking.formattedPickupDateTime}</p>
                                                                                    <p>Return: ${booking.formattedReturnDateTime}</p>
                                                                                    <h6>Customer</h6>
                                                                                    <p>${booking.customerName} - ${booking.customerPhone}</p>
                                                                                    <p>Email: ${booking.customerEmail}</p>
                                                                                    <h6>Status: ${booking.status}</h6>
                                                                                    <h6>Amount: ${booking.totalAmount}.000 VND</h6>
                                                                                </div>
                                                                                <div class="modal-footer">
                                                                                    <c:choose>
                                                                                        <c:when test="${booking.status eq 'Pending'}">
                                                                                            <button class="btn btn-danger">Cancel Booking</button>
                                                                                        </c:when>
                                                                                        <c:when test="${booking.status eq 'Confirmed' || booking.status eq 'Đang thuê'}">
                                                                                            <button class="btn btn-primary">Return Car</button>
                                                                                        </c:when>
                                                                                    </c:choose>
                                                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    <!-- Table row -->
                                                                    <td>${booking.bookingCode}</td>
                                                                    <td>${booking.carModel} <br><small>${booking.carLicensePlate}</small></td>
                                                                    <td>${booking.formattedPickupDateTime}</td>
                                                                    <td>${booking.formattedReturnDateTime}</td>
                                                                    <td>
                                                                        <span class="badge">${booking.status}</span>
                                                                    </td>
                                                                    <td>${booking.totalAmount}.000 VND</td>
                                                                    <td>
                                                                        <button class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#modal-${booking.bookingId}">
                                                                            <i class="fas fa-eye"></i> View
                                                                        </button>
                                                                        <c:if test="${booking.status eq 'Pending'}">
                                                                            <button class="btn btn-danger btn-sm">Cancel Booking</button>
                                                                        </c:if>
                                                                        <c:if test="${booking.status eq 'Confirmed' || booking.status eq 'Đang thuê'}">
                                                                            <button class="btn btn-primary btn-sm">Return Car</button>
                                                                        </c:if>
                                                                    </td>
                                                                </tr>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <tr>
                                                                <td colspan="7" class="text-center">You have no booking history.</td>
                                                            </tr>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    </tbody>
                                                </table>
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