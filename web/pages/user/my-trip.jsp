<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/user/my-trip-final.css">

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

        <style>
            /* Inline styles to ensure bullet points are removed and navbar is fixed */
            .sidebar-menu,
            .sidebar-menu li,
            .sidebar ul,
            .sidebar li {
                list-style: none !important;
                list-style-type: none !important;
                margin: 0 !important;
                padding-left: 0 !important;
            }
            
            .sidebar-menu li::before,
            .sidebar-menu li::after {
                display: none !important;
                content: none !important;
            }
            
            /* Force navbar visibility */
            .ftco-navbar-light .navbar-nav > .nav-item > .nav-link,
            .ftco-navbar-light .navbar-brand,
            .ftco-navbar-light .bi-bell,
            .ftco-navbar-light .bi-chat-dots,
            .navbar-brand .text-dark,
            .navbar-brand .text-success {
                opacity: 1 !important;
                visibility: visible !important;
                color: #374151 !important;
            }
            
            .navbar-brand .text-success {
                color: #10b981 !important;
            }
            
            /* Sidebar active state */
            .sidebar-menu .nav-link.active {
                border-left: 3px solid #10b981;
                padding-left: 1.375rem;
                background-color: #f9fafb !important;
                color: #333 !important;
                font-weight: 600;
            }
            
            .sidebar-menu .nav-link.active i {
                color: #10b981 !important;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="/pages/includes/nav.jsp" />

        <div class="container-fluid">
            <div class="row" style="margin-top:80px">
                <!-- Sidebar -->
                <div class="col-lg-2 col-md-3">
                    <div class="sidebar">
                        <h2>Hello !</h2>
                        <ul class="sidebar-menu">
                            <li><a href="${pageContext.request.contextPath}/user/profile" class="nav-link">
                                    <i class="bi bi-person"></i>
                                    My account
                                </a></li>
                            <li><a href="${pageContext.request.contextPath}/pages/user/favorite-car.jsp" class="nav-link">
                                    <i class="bi bi-heart"></i>
                                    Favorite cars
                                </a></li>
                            <li><a href="${pageContext.request.contextPath}/user/my-trip" class="nav-link active">
                                    <i class="bi bi-car-front"></i>
                                    My trips
                                </a></li>
                            <li><a href="${pageContext.request.contextPath}/pages/user/change-password.jsp" class="nav-link">
                                    <i class="bi bi-lock"></i>
                                    Change password
                                </a></li>
                            <li><a href="${pageContext.request.contextPath}/pages/user/request-delete.jsp" class="nav-link">
                                    <i class="bi bi-trash"></i>
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
                <div class="col-lg-10 col-md-9">
                    <div class="main-content">
                        <div class="card">
                            <div class="card-body">
                                <!-- Page Header -->
                                <div class="page-header">
                                    <h1 class="page-title">MY TRIPS</h1>
                                    <p class="page-subtitle">Manage and view your rental bookings</p>
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
                                        <div class="table-container">
                                            <table class="table">
                                                <thead>
                                                    <tr>
                                                        <th class="col-id">ID</th>
                                                        <th class="col-vehicle">VEHICLE</th>
                                                        <th class="col-pickup">PICK-UP DATE</th>
                                                        <th class="col-return">RETURN DATE</th>
                                                        <th class="col-status">STATUS</th>
                                                        <th class="col-amount">AMOUNT</th>
                                                        <th class="col-actions">ACTIONS</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                <c:choose>
                                                    <c:when test="${not empty bookingRequests}">
                                                        <c:forEach items="${bookingRequests}" var="booking">
                                                            <c:if test="${booking.status == 'Pending' || booking.status == 'Confirmed' || booking.status == 'AwaitingPayment' || booking.status == 'DepositPaid' || booking.status == 'ContractSigned' || booking.status == 'FullyPaid' || booking.status == 'InProgress'}">
                                                                <tr>
                                                                    <!-- Modal chi tiết booking -->
                                                                    <div class="modal fade" id="modal-${booking.bookingId}" tabindex="-1" aria-labelledby="modalLabel-${booking.bookingId}" aria-hidden="true">
                                                                        <div class="modal-dialog modal-lg">
                                                                            <div class="modal-content">
                                                                                <div class="modal-header">
                                                                                    <h5 class="modal-title" id="modalLabel-${booking.bookingId}">Booking Details - ${booking.bookingCode}</h5>
                                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                                </div>
                                                                                <div class="modal-body">
                                                                                    <h6 class="mb-3"><i class="fas fa-car me-2"></i>Car Information</h6>
                                                                                    <div class="row g-3 mb-4">
                                                                                        <div class="col-md-6">
                                                                                            <label class="form-label">Model</label>
                                                                                            <p>${booking.carModel}</p>
                                                                                        </div>
                                                                                        <div class="col-md-6">
                                                                                            <label class="form-label">License Plate</label>
                                                                                            <p>${booking.carLicensePlate}</p>
                                                                                        </div>
                                                                                    </div>
                                                                                    <h6 class="mb-3"><i class="fas fa-calendar me-2"></i>Rental Details</h6>
                                                                                    <div class="row g-3 mb-4">
                                                                                        <div class="col-md-6">
                                                                                            <label class="form-label">Pick-up Date</label>
                                                                                            <p>${booking.formattedPickupDateTime}</p>
                                                                                        </div>
                                                                                        <div class="col-md-6">
                                                                                            <label class="form-label">Return Date</label>
                                                                                            <p>${booking.formattedReturnDateTime}</p>
                                                                                        </div>
                                                                                        <div class="col-md-6">
                                                                                            <label class="form-label">Total Amount</label>
                                                                                            <p class="fw-bold">${booking.totalAmount}.000 VND</p>
                                                                                        </div>
                                                                                    </div>
                                                                                    <h6 class="mb-3"><i class="fas fa-info-circle me-2"></i>Status</h6>
                                                                                    <span class="status-badge status-${booking.status.toLowerCase()}">
                                                                                        <c:choose>
                                                                                            <c:when test='${booking.status == "Pending"}'>
                                                                                                <i class="fas fa-clock"></i>
                                                                                            </c:when>
                                                                                            <c:when test='${booking.status == "Confirmed"}'>
                                                                                                <i class="fas fa-check-circle"></i>
                                                                                            </c:when>
                                                                                            <c:when test='${booking.status == "Rejected"}'>
                                                                                                <i class="fas fa-times-circle"></i>
                                                                                            </c:when>
                                                                                            <c:when test='${booking.status == "Completed"}'>
                                                                                                <i class="fas fa-flag-checkered"></i>
                                                                                            </c:when>
                                                                                            <c:when test='${booking.status == "Cancelled"}'>
                                                                                                <i class="fas fa-ban"></i>
                                                                                            </c:when>
                                                                                            <c:when test='${booking.status == "InProgress"}'>
                                                                                                <i class="fas fa-car-side"></i>
                                                                                            </c:when>
                                                                                            <c:when test='${booking.status == "AwaitingPayment"}'>
                                                                                                <i class="fas fa-wallet"></i>
                                                                                            </c:when>
                                                                                            <c:when test='${booking.status == "DepositPaid"}'>
                                                                                                <i class="fas fa-money-bill-wave"></i>
                                                                                            </c:when>
                                                                                            <c:when test='${booking.status == "ContractSigned"}'>
                                                                                                <i class="fas fa-file-signature"></i>
                                                                                            </c:when>
                                                                                            <c:when test='${booking.status == "FullyPaid"}'>
                                                                                                <i class="fas fa-coins"></i>
                                                                                            </c:when>
                                                                                        </c:choose>
                                                                                        ${booking.status}
                                                                                    </span>
                                                                                </div>
                                                                                <div class="modal-footer">
                                                                                    <c:if test="${booking.status == 'Pending' || booking.status == 'AwaitingPayment' || booking.status == 'InProgress'}">
                                                                                        <button class="btn btn-danger-action">Cancel Booking</button>
                                                                                    </c:if>
                                                                                    <c:if test="${booking.status == 'Confirmed'}">
                                                                                        <button class="btn btn-primary-action">Return Car</button>
                                                                                    </c:if>
                                                                                    <button type="button" class="btn btn-view" data-bs-dismiss="modal">Close</button>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    
                                                                    <!-- Table row -->
                                                                    <td>${booking.bookingCode}</td>
                                                                    <td>
                                                                        <div class="vehicle-info">${booking.carModel}</div>
                                                                        <div class="vehicle-plate">${booking.carLicensePlate}</div>
                                                                    </td>
                                                                    <td class="date-display">${booking.formattedPickupDateTime}</td>
                                                                    <td class="date-display">${booking.formattedReturnDateTime}</td>
                                                                    <td>
                                                                        <span class="status-badge status-${booking.status.toLowerCase()}">
                                                                            <c:choose>
                                                                                <c:when test='${booking.status == "Pending"}'>
                                                                                    <i class="fas fa-clock"></i>
                                                                                </c:when>
                                                                                <c:when test='${booking.status == "Confirmed"}'>
                                                                                    <i class="fas fa-check-circle"></i>
                                                                                </c:when>
                                                                                <c:when test='${booking.status == "InProgress"}'>
                                                                                    <i class="fas fa-car-side"></i>
                                                                                </c:when>
                                                                                <c:when test='${booking.status == "AwaitingPayment"}'>
                                                                                    <i class="fas fa-wallet"></i>
                                                                                </c:when>
                                                                                <c:when test='${booking.status == "DepositPaid"}'>
                                                                                    <i class="fas fa-money-bill-wave"></i>
                                                                                </c:when>
                                                                                <c:when test='${booking.status == "ContractSigned"}'>
                                                                                    <i class="fas fa-file-signature"></i>
                                                                                </c:when>
                                                                                <c:when test='${booking.status == "FullyPaid"}'>
                                                                                    <i class="fas fa-coins"></i>
                                                                                </c:when>
                                                                            </c:choose>
                                                                            ${booking.status}
                                                                        </span>
                                                                    </td>
                                                                    <td class="amount-display">VND${booking.totalAmount}.000</td>
                                                                    <td>
                                                                        <div class="action-buttons">
                                                                            <button class="btn-action btn-view" data-bs-toggle="modal" data-bs-target="#modal-${booking.bookingId}">
                                                                                <i class="fas fa-eye"></i> View
                                                                            </button>
                                                                            <c:if test="${booking.status == 'Pending' || booking.status == 'AwaitingPayment' || booking.status == 'InProgress'}">
                                                                                <button class="btn-action btn-danger-action">Cancel</button>
                                                                            </c:if>
                                                                            <c:if test="${booking.status == 'Confirmed'}">
                                                                                <button class="btn-action btn-primary-action">Return</button>
                                                                            </c:if>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <tr>
                                                            <td colspan="7" class="text-center empty-state">
                                                                <i class="fas fa-car"></i>
                                                                <p>You have no current trips.</p>
                                                            </td>
                                                        </tr>
                                                    </c:otherwise>
                                                </c:choose>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                    <!-- Trip History Tab -->
                                    <div class="tab-pane fade" id="trip-history" role="tabpanel">
                                        <div class="table-container">
                                            <table class="table">
                                                <thead>
                                                    <tr>
                                                        <th class="col-id">ID</th>
                                                        <th class="col-vehicle">VEHICLE</th>
                                                        <th class="col-pickup">PICK-UP DATE</th>
                                                        <th class="col-return">RETURN DATE</th>
                                                        <th class="col-status">STATUS</th>
                                                        <th class="col-amount">AMOUNT</th>
                                                        <th class="col-actions">ACTIONS</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                <c:choose>
                                                    <c:when test="${not empty bookingRequests}">
                                                        <c:forEach items="${bookingRequests}" var="booking">
                                                            <c:if test="${booking.status == 'Completed' || booking.status == 'Cancelled' || booking.status == 'Rejected'}">
                                                                <tr>
                                                                    <!-- Modal for history -->
                                                                    <div class="modal fade" id="modal-history-${booking.bookingId}" tabindex="-1" aria-labelledby="modalLabel-history-${booking.bookingId}" aria-hidden="true">
                                                                        <div class="modal-dialog modal-lg">
                                                                            <div class="modal-content">
                                                                                <div class="modal-header">
                                                                                    <h5 class="modal-title" id="modalLabel-history-${booking.bookingId}">Booking Details - ${booking.bookingCode}</h5>
                                                                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                                                </div>
                                                                                <div class="modal-body">
                                                                                    <h6 class="mb-3"><i class="fas fa-car me-2"></i>Car Information</h6>
                                                                                    <div class="row g-3 mb-4">
                                                                                        <div class="col-md-6">
                                                                                            <label class="form-label">Model</label>
                                                                                            <p>${booking.carModel}</p>
                                                                                        </div>
                                                                                        <div class="col-md-6">
                                                                                            <label class="form-label">License Plate</label>
                                                                                            <p>${booking.carLicensePlate}</p>
                                                                                        </div>
                                                                                    </div>
                                                                                    <h6 class="mb-3"><i class="fas fa-calendar me-2"></i>Rental Details</h6>
                                                                                    <div class="row g-3 mb-4">
                                                                                        <div class="col-md-6">
                                                                                            <label class="form-label">Pick-up Date</label>
                                                                                            <p>${booking.formattedPickupDateTime}</p>
                                                                                        </div>
                                                                                        <div class="col-md-6">
                                                                                            <label class="form-label">Return Date</label>
                                                                                            <p>${booking.formattedReturnDateTime}</p>
                                                                                        </div>
                                                                                        <div class="col-md-6">
                                                                                            <label class="form-label">Total Amount</label>
                                                                                            <p class="fw-bold">${booking.totalAmount}.000 VND</p>
                                                                                        </div>
                                                                                    </div>
                                                                                    <h6 class="mb-3"><i class="fas fa-info-circle me-2"></i>Status</h6>
                                                                                    <span class="status-badge status-${booking.status.toLowerCase()}">
                                                                                        <c:choose>
                                                                                            <c:when test='${booking.status == "Completed"}'>
                                                                                                <i class="fas fa-flag-checkered"></i>
                                                                                            </c:when>
                                                                                            <c:when test='${booking.status == "Cancelled"}'>
                                                                                                <i class="fas fa-ban"></i>
                                                                                            </c:when>
                                                                                            <c:when test='${booking.status == "Rejected"}'>
                                                                                                <i class="fas fa-times-circle"></i>
                                                                                            </c:when>
                                                                                        </c:choose>
                                                                                        ${booking.status}
                                                                                    </span>
                                                                                </div>
                                                                                <div class="modal-footer">
                                                                                    <button type="button" class="btn btn-view" data-bs-dismiss="modal">Close</button>
                                                                                </div>
                                                                            </div>
                                                                        </div>
                                                                    </div>
                                                                    
                                                                    <!-- Table row -->
                                                                    <td>${booking.bookingCode}</td>
                                                                    <td>
                                                                        <div class="vehicle-info">${booking.carModel}</div>
                                                                        <div class="vehicle-plate">${booking.carLicensePlate}</div>
                                                                    </td>
                                                                    <td class="date-display">${booking.formattedPickupDateTime}</td>
                                                                    <td class="date-display">${booking.formattedReturnDateTime}</td>
                                                                    <td>
                                                                        <span class="status-badge status-${booking.status.toLowerCase()}">
                                                                            <c:choose>
                                                                                <c:when test='${booking.status == "Completed"}'>
                                                                                    <i class="fas fa-flag-checkered"></i>
                                                                                </c:when>
                                                                                <c:when test='${booking.status == "Cancelled"}'>
                                                                                    <i class="fas fa-ban"></i>
                                                                                </c:when>
                                                                                <c:when test='${booking.status == "Rejected"}'>
                                                                                    <i class="fas fa-times-circle"></i>
                                                                                </c:when>
                                                                            </c:choose>
                                                                            ${booking.status}
                                                                        </span>
                                                                    </td>
                                                                    <td class="amount-display">VND${booking.totalAmount}.000</td>
                                                                    <td>
                                                                        <div class="action-buttons">
                                                                            <button class="btn-action btn-view" data-bs-toggle="modal" data-bs-target="#modal-history-${booking.bookingId}">
                                                                                <i class="fas fa-eye"></i> View
                                                                            </button>
                                                                        </div>
                                                                    </td>
                                                                </tr>
                                                            </c:if>
                                                        </c:forEach>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <tr>
                                                            <td colspan="7" class="text-center empty-state">
                                                                <i class="fas fa-history"></i>
                                                                <p>You have no booking history.</p>
                                                            </td>
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

        <jsp:include page="/pages/includes/footer.jsp" />

        <!-- Scripts -->
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
            // Tab switching animation
            document.querySelectorAll('[data-bs-toggle="tab"]').forEach(tab => {
                tab.addEventListener('shown.bs.tab', function (e) {
                    const targetPane = document.querySelector(e.target.getAttribute('data-bs-target'));
                    targetPane.style.animation = 'none';
                    targetPane.offsetHeight;
                    targetPane.style.animation = 'fadeIn 0.3s ease-in-out';
                });
            });
        </script>
    </body>
</html>
