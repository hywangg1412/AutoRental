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
                                                                                            <i class="bi bi-credit-card"></i> Awaiting Payment
                                                                                        </c:when>
                                                                                        <c:when test="${trip.status eq 'DepositPaid'}">
                                                                                            <i class="bi bi-check-circle-fill"></i> Deposit Paid
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
                                                                                        <c:when test="${trip.status eq 'ContractSigned'}">
                                                                                            <i class="bi bi-pencil-square"></i> Contract Signed
                                                                                        </c:when>
                                                                                        <c:when test="${trip.status eq 'WAITING_RETURN_CONFIRM'}">
                                                                                            <span class="badge status-badge status-waiting-return">
                                                                                                <i class="bi bi-arrow-repeat me-1"></i> Waiting Return Confirm
                                                                                            </span>
                                                                                        </c:when>
                                                                                        <c:when test="${trip.status eq 'PendingInspection'}">
                                                                                            <i class="bi bi-search"></i> Pending Inspection
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
                                                                            <fmt:formatNumber value="${trip.totalAmount * 1000}" type="number" groupingUsed="true" pattern="#,##0" /> VND
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
                                                                        <c:if test="${trip.status eq 'DepositPaid'}">
                                                                            <a class="btn-mytrip-action btn-mytrip-green btn-sm"
                                                                               href="${pageContext.request.contextPath}/contract/create?bookingId=${trip.bookingId}">
                                                                               Sign Contract
                                                                            </a>
                                                                        </c:if>
                                                                        <c:if test="${trip.status eq 'ContractSigned'}">
                                                                            <button class="btn-mytrip-action btn-mytrip-blue btn-sm return-car-btn" 
                                                                                    data-booking-id="${trip.bookingId}" 
                                                                                    data-car-model="${trip.carModel}" 
                                                                                    data-license-plate="${trip.carLicensePlate}">
                                                                                Return Car
                                                                            </button>
                                                                        </c:if>
                                                                        <c:if test="${trip.status eq 'IN_PROGRESS'}">
                                                                            <button class="btn-mytrip-action btn-mytrip-blue btn-sm return-car-btn"
                                                                                    data-booking-id="${trip.bookingId}"
                                                                                    data-car-model="${trip.carModel}"
                                                                                    data-license-plate="${trip.carLicensePlate}">
                                                                                Return Car
                                                                            </button>
                                                                        </c:if>
                                                                        <c:if test="${trip.status eq 'WAITING_RETURN_CONFIRM'}">
                                                                            <button class="btn-mytrip-action btn-mytrip-blue btn-sm return-car-btn"
                                                                                    data-booking-id="${trip.bookingId}"
                                                                                    data-car-model="${trip.carModel}"
                                                                                    data-license-plate="${trip.carLicensePlate}">
                                                                                Return Car
                                                                            </button>
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
                                                            <c:if test="${booking.status ne 'DepositPaid'}">
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
                                                                                            <c:when test="${booking.status == 'WAITING_RETURN_CONFIRM'}">
                                                                                                <span class="badge status-badge status-waiting-return">
                                                                                                    <i class="bi bi-arrow-repeat me-1"></i> Waiting Return Confirm
                                                                                                </span>
                                                                                            </c:when>
                                                                                            <c:when test="${booking.status eq 'Rejected'}">
                                                                                                <span class="badge status-badge status-reject">
                                                                                                    <i class="bi bi-x-circle-fill me-1"></i> Rejected
                                                                                                </span>
                                                                                            </c:when>
                                                                                            <c:when test="${booking.status eq 'PendingInspection'}">
                                                                                                <i class="bi bi-search"></i> Pending Inspection
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
                                                                                <fmt:formatNumber value="${booking.totalAmount * 1000}" type="number" groupingUsed="true" pattern="#,##0" /> VND
                                                                            </span>
                                                                        </div>
                                                                        <div class="mytrip-btn-group">
                                                                            <button class="btn-mytrip-action btn-detail btn-view-details" data-booking-id="${booking.bookingId}" data-car-model="${booking.carModel}" data-license-plate="${booking.carLicensePlate}" data-pickup="${booking.formattedPickupDateTime}" data-return="${booking.formattedReturnDateTime}" data-total-amount="${booking.totalAmount}" data-status="${booking.status}" data-booking-code="${booking.bookingCode}" data-bs-toggle="modal" data-bs-target="#myTripDetailModal">
                                                                                View Details
                                                                            </button>
                                                                            <c:choose>
                                                                                <c:when test="${booking.hasFeedback}">
                                                                                    <button class="btn-mytrip-action btn-mytrip-green btn-sm" data-booking-id="${booking.bookingId}" data-car-id="${booking.carId}">View feedback</button>
                                                                                </c:when>
                                                                                <c:otherwise>
                                                                                    <button class="btn-mytrip-action btn-mytrip-blue btn-sm" data-booking-id="${booking.bookingId}" data-car-id="${booking.carId}">Send review</button>
                                                                                </c:otherwise>
                                                                            </c:choose>
                                                                        </div>
                                                                    </div>
                                                                </div>
                                                            </c:if>
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
        <script>
            var contextPath = '${pageContext.request.contextPath}';
            console.log('Context Path:', contextPath);
        </script>
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
              </div>
            </div>
          </div>
        </div>

        <!-- Cancel Booking Confirmation Modal -->
        <div class="modal fade" id="cancelBookingModal" tabindex="-1" aria-labelledby="cancelBookingModalLabel" aria-hidden="true">
          <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content custom-modal-content">
              <div class="modal-header border-0 pb-0 justify-content-end">
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
              </div>
              <div class="modal-body text-center pt-0">
                <h2 class="modal-title fw-bold mb-3" id="cancelBookingModalLabel" style="font-size: 2rem;">Cancel Booking</h2>
                <div class="mb-4" style="font-size: 1.1rem;">Are you sure you want to cancel this booking?</div>
                <form id="cancelBookingForm" method="post" action="${pageContext.request.contextPath}/user/booking-cancel">
                  <input type="hidden" name="bookingId" id="cancelBookingIdInput" value="">
                  <button type="submit" class="btn btn-danger w-100" id="confirmCancelBookingBtn">Yes, Cancel Booking</button>
                  <button type="button" class="btn btn-secondary w-100 mt-2" data-bs-dismiss="modal">No, Keep Booking</button>
                </form>
              </div>
            </div>
          </div>
        </div>

        <!-- Modal xác nhận trả xe -->
        <div class="modal fade" id="returnCarModal" tabindex="-1" aria-labelledby="returnCarModalLabel" aria-hidden="true">
          <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title" id="returnCarModalLabel">Return Car</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
              </div>
              <div class="modal-body text-center">
                <p>Are you sure you want to return car?</p>
                <div id="returnCarModalMessage" class="text-success d-none"></div>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" id="confirmReturnCarBtn">Return Car</button>
              </div>
            </div>
          </div>
        </div>
    </body>
</html>