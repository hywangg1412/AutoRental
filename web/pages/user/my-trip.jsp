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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/user-nav.css">
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
        <jsp:include page="/pages/includes/user-nav.jsp" />

        <div class="container">
            <div class="row g-5" style="margin-top:80px">
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
                            <li><a href="${pageContext.request.contextPath}/pages/user/request-delete.jsp" class="nav-link text-dark border-bottom-custom">
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
                                <!-- Main Content -->
                                <div class="main-content p-4 mt-1">
                                    <!-- Page Header -->
                                    <div class="d-flex justify-content-between align-items-center mb-4">
                                        <h1 class="h2 fw-semibold mb-0 text-dark">My trips</h1>
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
                                                                                <span class="badge status-badge status-${trip.status}">
                                                                                    <c:choose>
                                                                                        <c:when test="${trip.status eq 'Confirmed'}">
                                                                                            <i class="bi bi-check-circle-fill"></i> Booking Accepted
                                                                                        </c:when>
                                                                                        <c:when test="${trip.status eq 'Pending'}">
                                                                                            <i class="bi bi-hourglass-split"></i> Awaiting Confirmation
                                                                                        </c:when>
                                                                                        <c:when test="${trip.status eq 'IN_PROGRESS'}">
                                                                                            <i class="bi bi-car-front"></i> Ongoing
                                                                                        </c:when>
                                                                                        <c:when test="${trip.status eq 'Completed'}">
                                                                                            <i class="bi bi-flag-fill"></i> Completed
                                                                                        </c:when>
                                                                                        <c:when test="${trip.status eq 'Cancelled'}">
                                                                                            <i class="bi bi-x-circle-fill"></i> Cancelled
                                                                                        </c:when>
                                                                                        <c:otherwise>${trip.status}</c:otherwise>
                                                                                    </c:choose>
                                                                                </span>
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
                                                                        <button class="btn-mytrip-action btn-detail btn-view-details" data-booking-id="${trip.bookingId}" data-car-model="${trip.carModel}" data-license-plate="${trip.carLicensePlate}" data-pickup="${trip.formattedPickupDateTime}" data-return="${trip.formattedReturnDateTime}" data-total-amount="${trip.totalAmount}" data-status="${trip.status}" data-bs-toggle="modal" data-bs-target="#myTripDetailModal">
                                                                            View Details
                                                                        </button>
                                                                        <c:if test="${trip.status eq BookingStatusConstants.CONFIRMED || trip.status eq BookingStatusConstants.IN_PROGRESS}">
                                                                            <a class="btn-mytrip-action btn-mytrip-green btn-sm"
                                                                               href="${pageContext.request.contextPath}/customer/deposit?bookingId=${trip.bookingId}">
                                                                               Continue to Payment
                                                                            </a>
                                                                        </c:if>
                                                                        <c:if test="${trip.status eq BookingStatusConstants.PENDING}">
                                                                            <button class="btn-mytrip-action btn-mytrip-red btn-sm" data-booking-id="${trip.bookingId}">Cancel Booking</button>
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
                                            <c:choose>
                                                <c:when test="${not empty pastTrips}">
                                                    <div class="row">
                                                        <c:forEach items="${pastTrips}" var="booking">
                                                            <div class="col-12 mb-4">
                                                                <div class="favorite-car-card d-flex align-items-center p-4 rounded shadow-sm bg-white">
                                                                    <div class="car-img-wrapper">
                                                                        <img src="${pageContext.request.contextPath}${booking.carImage}" class="car-img" alt="Car image">
                                                                    </div>
                                                                    <div class="flex-grow-1 ps-3 pe-4">
                                                                        <div class="d-flex align-items-center mb-2">
                                                                            <div class="car-title-badge d-flex align-items-center">
                                                                                <h5 class="mb-0 fw-bold me-3">${booking.carModel}</h5>
                                                                                <span class="badge status-badge status-${booking.status}">
                                                                                    <c:choose>
                                                                                        <c:when test="${booking.status eq 'Confirmed'}">
                                                                                            <i class="bi bi-check-circle-fill"></i> Booking Accepted
                                                                                        </c:when>
                                                                                        <c:when test="${booking.status eq 'Pending'}">
                                                                                            <i class="bi bi-hourglass-split"></i> Awaiting Confirmation
                                                                                        </c:when>
                                                                                        <c:when test="${booking.status eq 'IN_PROGRESS'}">
                                                                                            <i class="bi bi-car-front"></i> Ongoing
                                                                                        </c:when>
                                                                                        <c:when test="${booking.status eq 'Completed'}">
                                                                                            <i class="bi bi-flag-fill"></i> Completed
                                                                                        </c:when>
                                                                                        <c:when test="${booking.status eq 'Cancelled'}">
                                                                                            <i class="bi bi-x-circle-fill"></i> Cancelled
                                                                                        </c:when>
                                                                                        <c:otherwise>${booking.status}</c:otherwise>
                                                                                    </c:choose>
                                                                                </span>
                                                                            </div>
                                                                        </div>
                                                                        <div class="mb-2 text-muted small fs-7 d-flex align-items-center car-info-inline">
                                                                            <span class="me-3"><i class="bi bi-hash me-1"></i>${booking.bookingCode}</span>
                                                                            <span class="me-3"><i class="bi bi-car-front me-1"></i>${booking.carLicensePlate}</span>
                                                                        </div>
                                                                        <div class="mb-2 text-muted small fs-7 d-flex align-items-center car-info-inline">
                                                                            <span class="me-3"><i class="bi bi-calendar me-1"></i>${booking.formattedPickupDateTime} - ${booking.formattedReturnDateTime}</span>
                                                                        </div>
                                                                        <span class="price-new fw-bold fs-6 text-success me-3" style="margin-bottom:0;">
                                                                            <fmt:formatNumber value="${booking.totalAmount}" type="number" pattern="#.###" /> VND
                                                                        </span>
                                                                    </div>
                                                                    <div class="mytrip-btn-group">
                                                                        <button class="btn-mytrip-action btn-detail btn-view-details" data-booking-id="${booking.bookingId}" data-car-model="${booking.carModel}" data-license-plate="${booking.carLicensePlate}" data-pickup="${booking.formattedPickupDateTime}" data-return="${booking.formattedReturnDateTime}" data-total-amount="${booking.totalAmount}" data-status="${booking.status}" data-booking-code="${booking.bookingCode}" data-bs-toggle="modal" data-bs-target="#myTripDetailModal">
                                                                            View Details
                                                                        </button>
                                                                        <a class="btn-mytrip-action btn-mytrip-green btn-sm"
                                                                           href="${pageContext.request.contextPath}/customer/deposit?bookingId=${booking.bookingId}">
                                                                           Continue to Payment
                                                                        </a>
                                                                        <button class="btn-mytrip-action btn-mytrip-blue btn-sm" data-booking-id="${booking.bookingId}">Send review</button>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:forEach>
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="empty-state">
                                                        <i class="bi bi-clock-history" style="font-size: 3rem; color: var(--text-gray); margin-bottom: 1rem;"></i>
                                                        <h5 class="mb-3">No trip history yet</h5>
                                                        <p class="text-muted">Your completed trips will appear here!</p>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
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
        <script src="${pageContext.request.contextPath}/scripts/user/my-trip.js"></script>

        <div class="modal fade" id="myTripDetailModal" tabindex="-1" aria-labelledby="myTripDetailModalLabel" aria-hidden="true">
          <div class="modal-dialog modal-md modal-dialog-centered">
            <div class="modal-content">
              <div class="modal-header border-0 pb-0">
                <h2 class="modal-title w-100 text-center fw-bold" id="myTripDetailModalLabel">Booking Details</h2>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <hr class="mytrip-divider" />
              <div class="modal-body pt-0">
                <div class="mytrip-modal-section"><i class="bi bi-hash"></i> Booking Information</div>
                <div class="row mb-3">
                  <div class="col-md-6">
                    <div class="mytrip-modal-label">Booking Code</div>
                    <div class="mytrip-modal-value" id="modalBookingCode"></div>
                  </div>
                  <div class="col-md-6">
                    <div class="mytrip-modal-label">Status</div>
                    <div class="mytrip-modal-value" id="modalStatus"></div>
                  </div>
                </div>
                <div class="mytrip-modal-section"><i class="bi bi-car-front"></i> Car Information</div>
                <div class="row mb-3">
                  <div class="col-md-6">
                    <div class="mytrip-modal-label">Model</div>
                    <div class="mytrip-modal-value" id="modalCarModel"></div>
                  </div>
                  <div class="col-md-6">
                    <div class="mytrip-modal-label">License Plate</div>
                    <div class="mytrip-modal-value" id="modalLicensePlate"></div>
                  </div>
                </div>
                <div class="mytrip-modal-section"><i class="bi bi-calendar"></i> Rental Details</div>
                <div class="row mb-3">
                  <div class="col-md-6">
                    <div class="mytrip-modal-label">Pick-up Date</div>
                    <div class="mytrip-modal-value" id="modalPickup"></div>
                  </div>
                  <div class="col-md-6">
                    <div class="mytrip-modal-label">Return Date</div>
                    <div class="mytrip-modal-value" id="modalReturn"></div>
                  </div>
                </div>
                <div class="mytrip-modal-label">Total Amount</div>
                <div class="mytrip-modal-value fw-bold" id="modalTotalAmount"></div>
              </div>
              <div class="modal-footer border-0 pt-0 d-flex flex-column gap-2">
                <a class="btn btn-success w-100 py-2"
                   id="modalContinuePaymentBtn"
                   href="#">
                   Continue to Payment
                </a>
              </div>
            </div>
          </div>
        </div>

        <jsp:include page="/pages/includes/logout-confirm-modal.jsp" />
    </body>
</html>