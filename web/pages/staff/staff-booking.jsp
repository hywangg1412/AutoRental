<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AutoRental - Staff</title>
        
        <!-- ===== External CSS Libraries ===== -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
        
        <!-- ===== Custom Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/staff/staff-booking.css">
    </head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <div class="brand-logo">
                    <i class="fas fa-car"></i>
                </div>
                <div class="brand-info">
                    <h5 class="brand-title">AutoRental</h5>
                    <small class="brand-subtitle">Staff Dashboard</small>
                </div>
            </div>
            
            <div class="sidebar-content">
                <h6 class="nav-heading">Navigation</h6>
                <nav class="sidebar-nav">
                    <a href="staff-dashboard.jsp" class="nav-item">
                        <i class="fas fa-home"></i>
                        <span>Dashboard</span>
                    </a>
                    <a href="staff-booking.jsp" class="nav-item active">
                        <i class="fas fa-calendar-alt"></i>
                        <span>Booking Requests</span>
                    </a>
                    <a href="car-condition.jsp" class="nav-item">
                        <i class="fas fa-car"></i>
                        <span>Car Condition</span>
                    </a>
                    <a href="car-availability.jsp" class="nav-item">
                        <i class="fas fa-clipboard-list"></i>
                        <span>Car Availability</span>
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-shield-alt"></i>
                        <span>Damage Reports</span>
                    </a>
                    <a href="customer-support.jsp" class="nav-item">
                        <i class="fas fa-comment"></i>
                        <span>Customer Feedback</span>
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-users"></i>
                        <span>Support Users</span>
                    </a>
                </nav>
                
                <div class="sidebar-footer">
                    <a href="#" class="nav-item logout">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Logout</span>
                    </a>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <div class="content-header">
                <div class="header-left">
                    <h1 class="page-title">Booking Requests</h1>
                    <p class="page-subtitle">Manage incoming rental requests and bookings</p>
                </div>
                <div class="header-right">
                    <button class="btn btn-outline-secondary btn-sm me-2">
                        <i class="fas fa-bell"></i>
                        Notifications
                    </button>
                    <div class="user-profile">
                        <div class="user-avatar">JS</div>
                        <span class="user-name">John Staff</span>
                    </div>
                </div>
            </div>

            <!-- Booking Requests Section -->
            <section id="booking-requests" class="section">
                <div class="row g-4 mb-4">
                    <div class="col-md-6 col-lg-2">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h6 class="card-title mb-0">Total Requests</h6>
                                    <i class="fas fa-calendar text-muted"></i>
                                </div>
                                <h3 class="card-text">24</h3>
                                <small class="text-muted">Today</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-2">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h6 class="card-title mb-0">Accepted</h6>
                                    <i class="fas fa-check-circle text-success"></i>
                                </div>
                                <h3 class="card-text text-success">18</h3>
                                <small class="text-muted">Confirmed</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-2">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h6 class="card-title mb-0">Pending</h6>
                                    <i class="fas fa-clock text-warning"></i>
                                </div>
                                <h3 class="card-text text-warning">6</h3>
                                <small class="text-muted">Awaiting</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-2">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h6 class="card-title mb-0">Rejected</h6>
                                    <i class="fas fa-times-circle text-danger"></i>
                                </div>
                                <h3 class="card-text text-danger">2</h3>
                                <small class="text-muted">Declined</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-2">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h6 class="card-title mb-0">Revenue</h6>
                                    <i class="fas fa-dollar-sign text-muted"></i>
                                </div>
                                <h3 class="card-text">$4250</h3>
                                <small class="text-muted">Today</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Booking Requests</h5>
                        <small class="text-muted">Manage and process rental requests</small>
                    </div>
                    <div class="card-body">
                        <div class="d-flex flex-column flex-sm-row gap-3 mb-4">
                            <div class="input-group flex-grow-1">
                                <span class="input-group-text"><i class="fas fa-search"></i></span>
                                <input type="text" class="form-control" placeholder="Search by customer name or booking ID...">
                            </div>
                            <select class="form-select w-auto">
                                <option value="all">All Status</option>
                                <option value="pending">Pending</option>
                                <option value="accepted">Accepted</option>
                                <option value="rejected">Rejected</option>
                            </select>
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
                                    <c:if test="${not empty error}">
                                        <tr>
                                            <td colspan="8" class="text-center text-danger">
                                                ${error}
                                            </td>
                                        </tr>
                                    </c:if>
                                    <c:forEach var="booking" items="${requestScope.pendingBookings}">
                                        <c:if test="${booking.approvalStatus == 'Pending'}">
                                            <tr>
                                                <td>${booking.bookingCode}</td>
                                                <td>
                                                    <div>${booking.customerName}</div>
                                                    <small class="text-muted">${booking.customerEmail}</small>
                                                </td>
                                                <td>
                                                    <div>${booking.carModel}</div>
                                                    <small class="text-muted">${booking.licensePlate}</small>
                                                </td>
                                                <td>${booking.pickupDateTime}</td>
                                                <td>${booking.returnDateTime}</td>
                                                <td><span class="badge badge-pending"><i class="fas fa-clock me-1"></i>pending</span></td>
                                                <td>${booking.totalAmount}</td>
                                                <td>
                                                    <div class="d-flex gap-2">
                                                        <form action="${pageContext.request.contextPath}/staff/booking-approval" method="post" style="display:inline;">
                                                            <input type="hidden" name="bookingId" value="${booking.bookingId}" />
                                                            <input type="hidden" name="action" value="accept" />
                                                            <button class="btn btn-success btn-sm" type="submit" onclick="this.form.action.value='accept'">
                                                                <i class="fas fa-check"></i> Accept
                                                            </button>
                                                            <button class="btn btn-outline-danger btn-sm" type="submit" onclick="this.form.action.value='decline'">
                                                                <i class="fas fa-times"></i> Decline
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:if>
                                    </c:forEach>
                                    <c:if test="${empty requestScope.pendingBookings}">
                                        <tr>
                                            <td colspan="8" class="text-center text-muted">No pending booking requests.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>

     <!-- Booking Details Modal -->
     <div class="modal fade" id="bookingModal" tabindex="-1" aria-labelledby="bookingModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="bookingModalLabel">Booking Details - BK001</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <h6 class="mb-3"><i class="fas fa-user me-2"></i>Customer Information</h6>
            <div class="row g-3 mb-4">
              <div class="col-md-6">
                <label class="form-label">Name</label>
                <p>John Smith</p>
              </div>
              <div class="col-md-6">
                <label class="form-label">Phone</label>
                <p><i class="fas fa-phone me-1"></i>+1 (555) 123-4567</p>
              </div>
              <div class="col-12">
                <label class="form-label">Email</label>
                <p><i class="fas fa-envelope me-1"></i>john.smith@email.com</p>
              </div>
            </div>
            <h6 class="mb-3"><i class="fas fa-car me-2"></i>Vehicle Information</h6>
            <div class="row g-3 mb-4">
              <div class="col-md-6">
                <label class="form-label">Model</label>
                <p>Toyota Camry</p>
              </div>
              <div class="col-md-6">
                <label class="form-label">License Plate</label>
                <p>ABC-123</p>
              </div>
              <div class="col-md-6">
                <label class="form-label">Current Status</label>
                <span class="badge badge-available">available</span>
              </div>
            </div>
            <h6 class="mb-3"><i class="fas fa-calendar me-2"></i>Rental Details</h6>
            <div class="row g-3 mb-4">
              <div class="col-md-6">
                <label class="form-label">Pick-up Date</label>
                <p>Nov 20, 2025</p>
              </div>
              <div class="col-md-6">
                <label class="form-label">Return Date</label>
                <p>Nov 25, 2025</p>
              </div>
              <div class="col-md-6">
                <label class="form-label">Duration</label>
                <p>5 days</p>
              </div>
              <div class="col-md-6">
                <label class="form-label">Total Amount</label>
                <p class="fw-bold">$250</p>
              </div>
            </div>
            <h6 class="mb-3"><i class="fas fa-dollar-sign me-2"></i>Payment Information</h6>
            <div class="mb-4">
              <label class="form-label">Deposit Status</label>
              <span class="badge badge-paid">paid</span>
            </div>
            <h6 class="mb-3"><i class="fas fa-file-alt me-2"></i>Documents</h6>
            <div class="mb-4">
              <label class="form-label">Driving License</label>
              <img src="/placeholder.svg?height=200&width=300" alt="Driving License" class="img-fluid rounded border" style="max-height: 192px;">
            </div>
            <div>
              <label class="form-label">Contract Status</label>
              <div class="d-flex align-items-center gap-2">
                <span class="badge badge-pending">pending</span>
              </div>
            </div>
          </div>
          <div class="modal-footer">
            <button class="btn btn-outline-danger" data-bs-toggle="modal" data-bs-target="#declineModal"><i class="fas fa-times me-1"></i>Decline</button>
            <button class="btn btn-success" data-bs-toggle="modal" data-bs-target="#acceptModal"><i class="fas fa-check me-1"></i>Accept</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Accept Modal -->
    <div class="modal fade" id="acceptModal" tabindex="-1" aria-labelledby="acceptModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="acceptModalLabel">Accept Booking Request</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            Are you sure you want to accept this booking request? This will confirm the rental and generate a contract.
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            <button type="button" class="btn btn-success">Accept & Generate Contract</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Decline Modal -->
    <div class="modal fade" id="declineModal" tabindex="-1" aria-labelledby="declineModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="declineModalLabel">Decline Booking Request</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <p>Are you sure you want to decline this booking request? This action cannot be undone.</p>
            <div class="mb-3">
              <label for="decline-reason" class="form-label">Reason (Optional)</label>
              <textarea class="form-control" id="decline-reason" rows="4" placeholder="Provide a reason for declining this request..."></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
            <button type="button" class="btn btn-danger">Decline Request</button>
          </div>
        </div>
      </div>
    </div>


    <!-- ===== External JavaScript Libraries ===== -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- ===== Custom JavaScript ===== -->
    <script src="${pageContext.request.contextPath}/scripts/staff/staff-booking.js"></script>
</body>
</html>