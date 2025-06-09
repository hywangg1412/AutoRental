<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>CarRental Pro - Staff Dashboard</title>
        
        <!-- ===== External CSS Libraries ===== -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
        
        <!-- ===== Custom Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/staff/staff-dashboard.css">
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
                    <a href="staff-dashboard.jsp" class="nav-item active">
                        <i class="fas fa-home"></i>
                        <span>Dashboard</span>
                    </a>
                    <a href="staff-booking.jsp" class="nav-item">
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
                    <h1 class="page-title">Staff Dashboard</h1>
                    <p class="page-subtitle">Welcome back! Here's your overview for today.</p>
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

            <!-- Dashboard Section -->
            <section id="dashboard" class="section">
                <div class="row g-4 mb-4">
                    <div class="col-md-6 col-lg-3">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h6 class="card-title mb-0">Total Requests</h6>
                                    <i class="fas fa-calendar text-muted"></i>
                                </div>
                                <h3 class="card-text">24</h3>
                                <small class="text-muted">Today's bookings</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h6 class="card-title mb-0">Accepted</h6>
                                    <i class="fas fa-check-circle text-success"></i>
                                </div>
                                <h3 class="card-text text-success">18</h3>
                                <small class="text-muted">Confirmed bookings</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h6 class="card-title mb-0">Pending</h6>
                                    <i class="fas fa-clock text-warning"></i>
                                </div>
                                <h3 class="card-text text-warning">6</h3>
                                <small class="text-muted">Awaiting approval</small>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3">
                        <div class="card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h6 class="card-title mb-0">Revenue</h6>
                                    <i class="fas fa-car text-muted"></i>
                                </div>
                                <h3 class="card-text">$4250</h3>
                                <small class="text-muted">Today's earnings</small>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="row g-4 mb-4">
                    <div class="col-lg-6">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <div>
                                    <h5 class="card-title mb-0">Live Booking Requests</h5>
                                    <small class="text-muted">Recent booking requests requiring attention</small>
                                </div>
                                <select class="form-select w-auto">
                                    <option value="all">All Status</option>
                                    <option value="pending">Pending</option>
                                    <option value="accepted">Accepted</option>
                                </select>
                            </div>
                            <div class="card-body">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Customer</th>
                                            <th>Car</th>
                                            <th>Status</th>
                                            <th>Amount</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>BK001</td>
                                            <td>John Smith</td>
                                            <td>Toyota Camry</td>
                                            <td><span class="badge badge-pending"><i class="fas fa-clock me-1"></i> Pending</span></td>
                                            <td>$250</td>
                                        </tr>
                                        <tr>
                                            <td>BK002</td>
                                            <td>Sarah Johnson</td>
                                            <td>Honda Civic</td>
                                            <td><span class="badge badge-accepted"><i class="fas fa-check-circle me-1"></i> Accepted</span></td>
                                            <td>$180</td>
                                        </tr>
                                        <tr>
                                            <td>BK003</td>
                                            <td>Mike Wilson</td>
                                            <td>BMW X5</td>
                                            <td><span class="badge badge-pending"><i class="fas fa-clock me-1"></i> Pending</span></td>
                                            <td>$450</td>
                                        </tr>
                                        <tr>
                                            <td>BK004</td>
                                            <td>Emily Davis</td>
                                            <td>Nissan Altima</td>
                                            <td><span class="badge badge-accepted"><i class="fas fa-check-circle me-1"></i> Accepted</span></td>
                                            <td>$200</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="card">
                            <div class="card-header d-flex justify-content-between align-items-center">
                                <div>
                                    <h5 class="card-title mb-0">Car Availability</h5>
                                    <small class="text-muted">Current fleet status and locations</small>
                                </div>
                                <select class="form-select w-auto">
                                    <option value="all">All Cars</option>
                                    <option value="available">Available</option>
                                    <option value="rented">Rented</option>
                                    <option value="maintenance">Maintenance</option>
                                </select>
                            </div>
                            <div class="card-body">
                                <table class="table">
                                    <thead>
                                        <tr>
                                            <th>Plate</th>
                                            <th>Model</th>
                                            <th>Status</th>
                                            <th>Location</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr>
                                            <td>ABC-123</td>
                                            <td>Toyota Camry</td>
                                            <td><span class="badge badge-available">Available</span></td>
                                            <td>Downtown</td>
                                        </tr>
                                        <tr>
                                            <td>XYZ-789</td>
                                            <td>Honda Civic</td>
                                            <td><span class="badge badge-rented">Rented</span></td>
                                            <td>Airport</td>
                                        </tr>
                                        <tr>
                                            <td>DEF-456</td>
                                            <td>BMW X5</td>
                                            <td><span class="badge badge-maintenance">Maintenance</span></td>
                                            <td>Service Center</td>
                                        </tr>
                                        <tr>
                                            <td>GHI-012</td>
                                            <td>Nissan Altima</td>
                                            <td><span class="badge badge-available">Available</span></td>
                                            <td>Mall</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <div>
                            <h5 class="card-title mb-0">Damage Reports</h5>
                            <small class="text-muted">Vehicle damage reports and maintenance tracking</small>
                        </div>
                        <button class="btn btn-primary btn-sm"><i class="fas fa-plus me-2"></i>Add Report</button>
                    </div>
                    <div class="card-body">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>Car ID / Plate</th>
                                    <th>Return Date</th>
                                    <th>Damage Description</th>
                                    <th>Severity</th>
                                    <th>Evidence</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        <div>DR001</div>
                                        <small class="text-muted">XYZ-789</small>
                                    </td>
                                    <td>2024-01-14</td>
                                    <td class="text-truncate" style="max-width: 200px;">Minor scratch on rear bumper</td>
                                    <td><span class="badge badge-low"><i class="fas fa-exclamation-triangle me-1"></i>Low</span></td>
                                    <td><img src="/placeholder.svg?height=40&width=40" alt="Damage evidence" class="rounded" style="width: 40px; height: 40px;"></td>
                                    <td><span class="badge badge-pending">New</span></td>
                                    <td>
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-outline-secondary btn-sm"><i class="fas fa-eye"></i></button>
                                            <button class="btn btn-outline-secondary btn-sm"><i class="fas fa-edit"></i></button>
                                            <button class="btn btn-outline-secondary btn-sm"><i class="fas fa-check"></i></button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div>DR002</div>
                                        <small class="text-muted">JKL-345</small>
                                    </td>
                                    <td>2024-01-13</td>
                                    <td class="text-truncate" style="max-width: 200px;">Dent on driver side door</td>
                                    <td><span class="badge badge-medium">Medium</span></td>
                                    <td><img src="/placeholder.svg?height=40&width=40" alt="Damage evidence" class="rounded" style="width: 40px; height: 40px;"></td>
                                    <td><span class="badge badge-pending">Reviewed</span></td>
                                    <td>
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-outline-secondary btn-sm"><i class="fas fa-eye"></i></button>
                                            <button class="btn btn-outline-secondary btn-sm"><i class="fas fa-edit"></i></button>
                                            <button class="btn btn-outline-secondary btn-sm"><i class="fas fa-check"></i></button>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div>DR003</div>
                                        <small class="text-muted">MNO-678</small>
                                    </td>
                                    <td>2024-01-12</td>
                                    <td class="text-truncate" style="max-width: 200px;">Broken headlight</td>
                                    <td><span class="badge badge-high">High</span></td>
                                    <td><img src="/placeholder.svg?height=40&width=40" alt="Damage evidence" class="rounded" style="width: 40px; height: 40px;"></td>
                                    <td><span class="badge badge-accepted">Resolved</span></td>
                                    <td>
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-outline-secondary btn-sm"><i class="fas fa-eye"></i></button>
                                            <button class="btn btn-outline-secondary btn-sm"><i class="fas fa-edit"></i></button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <div class="row g-4 mt-4">
                    <div class="col-lg-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Customer Feedback</h5>
                                <small class="text-muted">Verified reviews from completed rentals - Reply or moderate as needed</small>
                            </div>
                            <div class="card-body">
                                <div class="feedback-card">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="fw-medium">Alice Brown</span>
                                            <span class="badge bg-outline-secondary text-dark border"><i class="fas fa-check-circle me-1"></i>Verified Rental</span>
                                            <div class="star-rating">
                                                <i class="fas fa-star checked"></i>
                                                <i class="fas fa-star checked"></i>
                                                <i class="fas fa-star checked"></i>
                                                <i class="fas fa-star checked"></i>
                                                <i class="fas fa-star checked"></i>
                                            </div>
                                        </div>
                                        <span class="badge badge-accepted">Approved</span>
                                    </div>
                                    <p class="text-muted small mb-2">Excellent service and clean car! The pickup process was smooth and the car was in perfect condition.</p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <small class="text-muted">2024-01-14</small>
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-outline-secondary btn-sm"><i class="fas fa-comment me-1"></i>Reply</button>
                                            <button class="btn btn-outline-danger btn-sm"><i class="fas fa-times-circle me-1"></i>Delete</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="feedback-card">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="fw-medium">Bob Green</span>
                                            <span class="badge bg-outline-secondary text-dark border"><i class="fas fa-check-circle me-1"></i>Verified Rental</span>
                                            <div class="star-rating">
                                                <i class="fas fa-star checked"></i>
                                                <i class="fas fa-star checked"></i>
                                                <i class="fas fa-star checked"></i>
                                                <i class="fas fa-star checked"></i>
                                                <i class="fas fa-star"></i>
                                            </div>
                                        </div>
                                        <span class="badge badge-pending">Pending</span>
                                    </div>
                                    <p class="text-muted small mb-2">Good experience overall, minor delay in pickup but staff was very helpful and apologetic.</p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <small class="text-muted">2024-01-13</small>
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-outline-secondary btn-sm"><i class="fas fa-comment me-1"></i>Reply</button>
                                            <button class="btn btn-outline-danger btn-sm"><i class="fas fa-times-circle me-1"></i>Delete</button>
                                        </div>
                                    </div>
                                </div>
                                <div class="feedback-card">
                                    <div class="d-flex justify-content-between align-items-center mb-2">
                                        <div class="d-flex align-items-center gap-2">
                                            <span class="fw-medium">Carol White</span>
                                            <span class="badge bg-outline-secondary text-dark border"><i class="fas fa-check-circle me-1"></i>Verified Rental</span>
                                            <div class="star-rating">
                                                <i class="fas fa-star checked"></i>
                                                <i class="fas fa-star checked"></i>
                                                <i class="fas fa-star checked"></i>
                                                <i class="fas fa-star"></i>
                                                <i class="fas fa-star"></i>
                                            </div>
                                        </div>
                                        <span class="badge badge-accepted">Approved</span>
                                    </div>
                                    <p class="text-muted small mb-2">Car was okay but could be cleaner. Interior had some stains on the seats.</p>
                                    <div class="d-flex justify-content-between align-items-center">
                                        <small class="text-muted">2024-01-12</small>
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-outline-secondary btn-sm"><i class="fas fa-comment me-1"></i>Reply</button>
                                            <button class="btn btn-outline-danger btn-sm"><i class="fas fa-times-circle me-1"></i>Delete</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-6">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="card-title mb-0">Support Panel</h5>
                                <small class="text-muted">Customer support and messaging</small>
                            </div>
                            <div class="card-body">
                                <div class="border rounded p-3 mb-3 d-flex justify-content-between align-items-center">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="bg-success bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;">
                                            <i class="fas fa-comment text-success"></i>
                                        </div>
                                        <div>
                                            <p class="mb-0 fw-medium">Zalo Support</p>
                                            <small class="text-muted">3 active chats</small>
                                        </div>
                                    </div>
                                    <button class="btn btn-outline-secondary btn-sm">Open</button>
                                </div>
                                <div class="border rounded p-3 mb-3 d-flex justify-content-between align-items-center">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="bg-primary bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;">
                                            <i class="fas fa-users text-primary"></i>
                                        </div>
                                        <div>
                                            <p class="mb-0 fw-medium">Live Chat</p>
                                            <small class="text-muted">1 pending message</small>
                                        </div>
                                    </div>
                                    <button class="btn btn-outline-secondary btn-sm">Open</button>
                                </div>
                                <div class="border rounded p-3 d-flex justify-content-between align-items-center">
                                    <div class="d-flex align-items-center gap-3">
                                        <div class="bg-purple bg-opacity-10 rounded-circle d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;">
                                            <i class="fas fa-cog text-purple"></i>
                                        </div>
                                        <div>
                                            <p class="mb-0 fw-medium">Support Settings</p>
                                            <small class="text-muted">Configure support options</small>
                                        </div>
                                    </div>
                                    <button class="btn btn-outline-secondary btn-sm">Configure</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </div>

    <!-- ===== External JavaScript Libraries ===== -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- ===== Common Excel Handler ===== -->
    <script src="${pageContext.request.contextPath}/scripts/common/excel-handler.js"></script>
    
    <!-- ===== Custom JavaScript ===== -->
    <script src="${pageContext.request.contextPath}/scripts/staff/staff-dashboard.js"></script>
</body>
</html>
