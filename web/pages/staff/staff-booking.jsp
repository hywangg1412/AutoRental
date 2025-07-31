<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AutoRental - Booking Requests</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/staff/staff-booking.css">
    </head>
    <body>
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="p-4 border-bottom">
                <div class="d-flex align-items-center gap-2">
                    <div class="bg-primary text-white rounded d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;">
                        <i class="fas fa-car fa-sm"></i>
                    </div>
                    <div>
                        <h5 class="mb-0">
                            <span style="font-weight: bold; color: #111;">AUTO</span><span style="font-weight: bold; color: #3b82f6;">RENTAL</span>
                        </h5>
                        <small class="text-muted">Staff Dashboard</small>
                    </div>
                </div>
            </div>
            <div class="p-3">
                <h6 class="px-3 mb-2 text-muted">Navigation</h6>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/staff/dashboard">
                            <i class="fas fa-home"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link active" href="${pageContext.request.contextPath}/staff/booking-approval-list">
                            <i class="fas fa-calendar"></i> Booking Requests
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/staff/car-condition">
                            <i class="fas fa-car"></i> Car Condition
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/pages/staff/staff-car-availability.jsp">
                            <i class="fas fa-clipboard-list"></i> Car Availability
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/staff/feedback-reply">
                            <i class="fas fa-comment"></i> Customer Feedback
                        </a>
                    </li>
                </ul>
                <hr>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link text-danger" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Updated Header Design -->
            <header class="header bg-white border-bottom shadow-sm">
                <div class="container-fluid px-4 py-3">
                    <div class="row align-items-center">
                        <!-- Left: Page Title -->
                        <div class="col text-start">
                            <h4 class="mb-0 fw-bold">Booking Requests</h4>
                            <small class="text-muted">Manage incoming rental requests and bookings</small>
                        </div>

                        <!-- Right: Notifications and User -->
                        <%@ include file="/pages/includes/staff-header.jsp" %>
                    </div>
                </div>
            </header>

            <!-- Booking Requests Section -->
            <section id="booking-requests" class="section">
                <!-- Your static stats cards here -->
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Booking Requests</h5>
                        <small class="text-muted">Manage and process rental requests</small>
                    </div>
                    <div class="card-body">
                        <!-- Hiển thị thông báo success/error -->
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        </c:if>
                        
                        <div class="d-flex flex-column flex-sm-row gap-3 mb-4">
                            <form class="d-flex flex-column flex-sm-row gap-3 w-100" method="get" action="">
                                <div class="input-group flex-grow-1">
                                    <span class="input-group-text"><i class="fas fa-search"></i></span>
                                    <input type="text" class="form-control" name="keyword" placeholder="Search by customer name or booking ID..." value="${searchKeyword != null ? searchKeyword : ''}">
                                </div>
                                <select class="form-select w-auto" name="status">
                                    <option value="all" ${selectedStatus == null || selectedStatus == 'all' ? 'selected' : ''}>All Status</option>
                                    <c:forEach var="status" items="${bookingStatuses}">
                                        <option value="${status}" ${selectedStatus == status ? 'selected' : ''}>${status}</option>
                                    </c:forEach>
                                </select>
                                <button type="submit" class="btn btn-primary">Search</button>
                            </form>
                        </div>
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Customer</th>
                                        <th>Vehicle</th>
                                        <th>Pick-up Date</th>
                                        <th>Return Date</th>
                                        <th>Status</th>
                                        <th>Amount</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:choose>
                                        <c:when test="${not empty bookingRequests}">
                                            <c:forEach items="${bookingRequests}" var="booking">
                                                <c:if test="${booking.status ne 'PendingInspection'}">
                                                    <tr>
                                                        <!-- =================== MODAL CHI TIẾT BOOKING (KẾT HỢP CŨ + MỚI) =================== -->
                                            <div class="modal fade" id="modal-${booking.bookingId}" tabindex="-1" aria-labelledby="modalLabel-${booking.bookingId}" aria-hidden="true">
                                                <div class="modal-dialog modal-lg">
                                                    <div class="modal-content">
                                                        <div class="modal-header">
                                                            <h5 class="modal-title" id="modalLabel-${booking.bookingId}">Booking Details - ${booking.bookingCode}</h5>
                                                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                                        </div>
                                                        <div class="modal-body">
                                                            <!-- Customer Info -->
                                                            <h6 class="mb-3"><i class="fas fa-user me-2"></i>Customer Information</h6>
                                                            <div class="row g-3 mb-4">
                                                                <div class="col-md-6">
                                                                    <label class="form-label">Name</label>
                                                                    <p>${booking.customerName}</p>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <label class="form-label">Phone</label>
                                                                    <p>${booking.customerPhone}</p>
                                                                </div>
                                                                <div class="col-12">
                                                                    <label class="form-label">Email</label>
                                                                    <p>${booking.customerEmail}</p>
                                                                </div>
                                                            </div>
                                                            <!-- Car Info -->
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
                                                                <div class="col-md-6">
                                                                    <label class="form-label">Car Status</label>
                                                                    <span class="badge badge-available">${booking.carStatus}</span>
                                                                </div>
                                                            </div>
                                                            <!-- Rental Details -->
                                                            <h6 class="mb-3"><i class="fas fa-calendar me-2"></i>Rental Details</h6>
                                                            <div class="row g-3 mb-4">
                                                                <div class="col-md-6">
                                                                    <label class="form-label">Pick-up Date</label>
                                                                    <p>${booking.pickupDateTime}</p>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <label class="form-label">Return Date</label>
                                                                    <p>${booking.returnDateTime}</p>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <label class="form-label">Rental Type</label>
                                                                    <c:choose>
                                                                        <c:when test="${booking.rentalType == 'hourly'}">
                                                                            <span class="badge rental-type hourly">
                                                                                <i class="fas fa-clock me-1"></i>Hourly
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${booking.rentalType == 'daily'}">
                                                                            <span class="badge rental-type daily">
                                                                                <i class="fas fa-calendar-day me-1"></i>Daily
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${booking.rentalType == 'monthly'}">
                                                                            <span class="badge rental-type monthly">
                                                                                <i class="fas fa-calendar-alt me-1"></i>Monthly
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="badge rental-type unknown">
                                                                                <i class="fas fa-question-circle me-1"></i>${booking.rentalType}
                                                                            </span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <label class="form-label">Duration</label>
                                                                    <p>${booking.formattedDuration}</p>
                                                                </div>
                                                                <div class="col-md-6">
                                                                    <label class="form-label">Total Amount</label>
                                                                    <p class="fw-bold">${booking.formattedTotalAmount}</p>
                                                                </div>
                                                            </div>
                                                            <!-- Payment Info -->
                                                            <h6 class="mb-3"><i class="fas fa-dollar-sign me-2"></i>Payment Information</h6>
                                                            <div class="mb-4">
                                                                <label class="form-label">Deposit Status</label>
                                                                <c:choose>
                                                                    <c:when test="${booking.depositStatus == 'Not Applicable'}">
                                                                        <span class="badge deposit-status not-applicable">
                                                                            <i class="fas fa-info-circle me-1"></i>Not Applicable
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${booking.depositStatus == 'Awaiting Payment'}">
                                                                        <span class="badge deposit-status awaiting-payment">
                                                                            <i class="fas fa-clock me-1"></i>Awaiting Payment
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${booking.depositStatus == 'Paid'}">
                                                                        <span class="badge deposit-status paid">
                                                                            <i class="fas fa-check-circle me-1"></i>Paid
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${booking.depositStatus == 'Cancelled'}">
                                                                        <span class="badge deposit-status cancelled">
                                                                            <i class="fas fa-times-circle me-1"></i>Cancelled
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge deposit-status unknown">
                                                                            <i class="fas fa-question-circle me-1"></i>${booking.depositStatus}
                                                                        </span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                            <!-- Documents -->
                                                            <h6 class="mb-3"><i class="fas fa-file-alt me-2"></i>Documents</h6>
                                                            <div class="mb-4">
                                                                <label class="form-label">Driver License</label>
                                                                <c:choose>
                                                                    <c:when test="${not empty booking.driverLicenseImageUrl}">
                                                                        <img src="${booking.driverLicenseImageUrl}" alt="Driver License" class="img-fluid rounded border" style="max-height: 200px;">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <p>No driver license image</p>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                            <div>
                                                                <label class="form-label">Contract Status</label>
                                                                <c:choose>
                                                                    <c:when test="${booking.contractStatus == 'Not Applicable'}">
                                                                        <span class="badge contract-status not-applicable">
                                                                            <i class="fas fa-info-circle me-1"></i>Not Applicable
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${booking.contractStatus == 'Not Created'}">
                                                                        <span class="badge contract-status not-created">
                                                                            <i class="fas fa-file me-1"></i>Not Created
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${booking.contractStatus == 'Ready to Sign'}">
                                                                        <span class="badge contract-status ready-to-sign">
                                                                            <i class="fas fa-pen me-1"></i>Ready to Sign
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${booking.contractStatus == 'Signed'}">
                                                                        <span class="badge contract-status signed">
                                                                            <i class="fas fa-check-circle me-1"></i>Signed
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${booking.contractStatus == 'Completed'}">
                                                                        <span class="badge contract-status completed">
                                                                            <i class="fas fa-flag-checkered me-1"></i>Completed
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${booking.contractStatus == 'Cancelled'}">
                                                                        <span class="badge contract-status cancelled">
                                                                            <i class="fas fa-times-circle me-1"></i>Cancelled
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${booking.contractStatus == 'Pending'}">
                                                                        <span class="badge contract-status pending">
                                                                            <i class="fas fa-clock me-1"></i>Pending
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${booking.status == 'WAITING_RETURN_CONFIRM'}">
                                                                        <span class="badge contract-status waiting-return-confirm">
                                                                            <i class="fas fa-clock me-1"></i>Chờ xác nhận trả xe
                                                                        </span>
                                                                    </c:when>
                                                                    <c:when test="${booking.status == 'RETURN_REJECTED'}">
                                                                        <span class="badge contract-status return-rejected">
                                                                            <i class="fas fa-times-circle me-1"></i>Từ chối trả xe
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="badge contract-status unknown">
                                                                            <i class="fas fa-question-circle me-1"></i>${booking.contractStatus}
                                                                        </span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </div>
                                                        </div>
                                                        <!-- ======= Modal Footer: Nút Accept/Reject/Close ======= -->
                                                        <div class="modal-footer">
                                                            <c:choose>
                                                                <c:when test="${booking.status eq 'Pending'}">
                                                                    <!-- Nút Reject: mở popup nhập lý do từ chối -->
                                                                    <button id="btnDecline-${booking.bookingId}" type="button" class="btn btn-outline-danger"
                                                                            data-bs-toggle="modal"
                                                                            data-bs-target="#declineModal-${booking.bookingId}"
                                                                            data-booking-id="${booking.bookingId}">
                                                                        <i class="fas fa-times me-1"></i>Reject
                                                                    </button>
                                                                    <!-- Nút Accept: Form submit trực tiếp -->
                                                                    <form action="${pageContext.request.contextPath}/staff/approve-booking" method="POST" style="display: inline;">
                                                                        <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                                                        <input type="hidden" name="action" value="approve">
                                                                        <button type="submit" class="btn btn-success">
                                                                            <i class="fas fa-check me-1"></i>Accept
                                                                        </button>
                                                                    </form>
                                                                </c:when>
                                                                <c:when test="${booking.status == 'WAITING_RETURN_CONFIRM'}">
                                                                    <form action="${pageContext.request.contextPath}/staff/return-car-approval" method="POST" style="display:inline;">
                                                                        <input type="hidden" name="bookingId" value="${booking.bookingId}" />
                                                                        <input type="hidden" name="action" value="approve" />
                                                                        <button type="submit" class="btn btn-success btn-sm">Xác nhận trả xe</button>
                                                                    </form>
                                                                </c:when>
                                                            </c:choose>
                                                            <!-- Nút Close luôn hiển thị -->
                                                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- =================== END MODAL CHI TIẾT BOOKING =================== -->
                                            <td>${booking.bookingCode}</td>
                                            <td>
                                                <div>${booking.customerName}</div>
                                                <small class="text-muted">${booking.customerEmail}</small>
                                            </td>
                                            <td>
                                                <div>${booking.carModel}</div>
                                                <small class="text-muted">${booking.carLicensePlate}</small>
                                            </td>
                                            <td>
                                                ${booking.formattedPickupDateTime}
                                            </td>
                                            <td>
                                                ${booking.formattedReturnDateTime}
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${booking.status == 'Pending'}">
                                                        <span class="badge badge-pending">
                                                            <i class="fas fa-clock me-1"></i>Pending
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'Confirmed'}">
                                                        <span class="badge badge-accepted">
                                                            <i class="fas fa-check-circle me-1"></i>Confirmed
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'Rejected'}">
                                                        <span class="badge badge-rejected">
                                                            <i class="fas fa-times-circle me-1"></i>Rejected
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'Completed'}">
                                                        <span class="badge badge-completed">
                                                            <i class="fas fa-flag-checkered me-1"></i>Completed
                                                        </span>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'WAITING_RETURN_CONFIRM'}">
                                                        <span class="badge bg-warning">Chờ xác nhận trả xe</span>
                                                    </c:when>
                                                    <c:when test="${booking.status == 'RETURN_REJECTED'}">
                                                        <span class="badge bg-danger">Từ chối trả xe</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${booking.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                ${booking.formattedTotalAmount}
                                            </td>
                                            <td>
                                                <div class="d-flex gap-2">
                                                    <!-- Nút View mở modal riêng cho từng booking -->
                                                    <button class="btn btn-outline-secondary btn-sm" 
                                                            data-bs-toggle="modal" 
                                                            data-bs-target="#modal-${booking.bookingId}">
                                                        <i class="fas fa-eye"></i> View
                                                    </button>
                                                    <c:choose>
                                                        <c:when test="${booking.status == 'Pending'}">
                                                            <!-- Hiển thị nút Accept/Reject chỉ khi Pending -->
                                                            <form action="${pageContext.request.contextPath}/staff/approve-booking" method="POST" style="display: inline;">
                                                                <input type="hidden" name="bookingId" value="${booking.bookingId}">
                                                                <input type="hidden" name="action" value="approve">
                                                                <button type="submit" class="btn btn-success btn-sm" title="Accept Booking">
                                                                    <i class="fas fa-check"></i> Accept
                                                                </button>
                                                            </form>
                                                            <!-- Nút Reject: mở popup nhập lý do từ chối -->
                                                            <button type="button" class="btn btn-danger btn-sm" title="Reject Booking"
                                                                    data-bs-toggle="modal"
                                                                    data-bs-target="#declineModal-${booking.bookingId}">
                                                                <i class="fas fa-times"></i> Reject
                                                            </button>
                                                        </c:when>

                                                    </c:choose>
                                                </div>
                                            </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <tr>
                                            <td colspan="8" class="text-center">No booking requests found.</td>
                                        </tr>
                                    </c:otherwise>
                                </c:choose>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
        </div>
    </section>

    <!-- =================== DECLINE MODAL CHO TỪNG BOOKING (COPY TỪ MẪU staff-booking1.jsp) =================== -->
    <c:forEach items="${bookingRequests}" var="booking">
        <div class="modal fade" id="declineModal-${booking.bookingId}" tabindex="-1" aria-labelledby="declineModalLabel-${booking.bookingId}" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form id="declineForm-${booking.bookingId}" method="post" action="${pageContext.request.contextPath}/staff/approve-booking">
                        <div class="modal-header">
                            <h5 class="modal-title" id="declineModalLabel-${booking.bookingId}">Decline Booking Request</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p>Are you sure you want to decline this booking request? This action cannot be undone.</p>
                            <div class="mb-3">
                                <label for="decline-reason-${booking.bookingId}" class="form-label">Reason <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="decline-reason-${booking.bookingId}" name="declineReason" rows="4" required placeholder="Provide a reason for declining this request..."></textarea>
                            </div>
                            <input type="hidden" name="bookingId" value="${booking.bookingId}">
                            <input type="hidden" name="action" value="reject">
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                            <button type="submit" class="btn btn-danger">Decline Request</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </c:forEach>
    <!-- =================== END DECLINE MODAL =================== -->

    <!-- ========== PHÂN TRANG ========== -->
    <c:if test="${totalPages > 1}">
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                        <a class="page-link" href="?page=${i}&keyword=${searchKeyword}&status=${selectedStatus}">${i}</a>
                    </li>
                </c:forEach>
            </ul>
        </nav>
    </c:if>
    <!-- ========== END PHÂN TRANG ========== -->

</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>