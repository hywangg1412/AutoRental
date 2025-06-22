<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Long-term Car Rental Orders - Auto Rental</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css">
        <link href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap" rel="stylesheet">
        <!-- ===== Include Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/userNav.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/nav.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/user/longterm-booking.css">
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
        <jsp:include page="/pages/includes/userNav.jsp" />
        <div class="container">
            <div class="row g-5 mt-4">
                <!-- Sidebar -->
                <div class="col-lg-3 col-md-4">
                    <div class="sidebar">
                        <h2 class="h2 fw-bold mb-3">Hello !</h2>
                        <ul class="sidebar-menu">
                            <li><a href="${pageContext.request.contextPath}/pages/user/user-profile.jsp" class="nav-link text-dark border-top-custom">
                                    <i class="bi bi-person text-dark"></i>
                                    My account
                                </a></li>
                            <li><a href="${pageContext.request.contextPath}/pages/user/favorite-car.jsp" class="nav-link text-dark">
                                    <i class="bi bi-heart text-dark"></i>
                                    Favorite cars
                                </a></li>
                            <li><a href="${pageContext.request.contextPath}/pages/user/my-trip.jsp" class="nav-link text-dark">
                                    <i class="bi bi-car-front text-dark"></i>
                                    My trips
                                </a></li>
                            <li><a href="${pageContext.request.contextPath}/pages/user/longterm-booking.jsp" class="nav-link active text-dark">
                                    <i class="bi bi-clipboard-check text-dark"></i>
                                    Long-term car rental orders
                                </a></li>
                            <li><a href="${pageContext.request.contextPath}/pages/user/my-address.jsp" class="nav-link text-dark">
                                    <i class="bi bi-geo-alt text-dark"></i>
                                    My address
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
                                <div class="main-content p-4 mt-1">
                                    <div class="account-info-block mb-4 p-4 bg-white rounded shadow-sm w-100" style="max-width:900px;margin-left:auto;margin-right:auto;">
                                        <!-- Page Header -->
                                        <div class="p-0 border-bottom mb-4">
                                            <h1 class="h5 fw-semibold mb-0 text-dark">Long-term Car Rental Orders</h1>
                                            <p class="text-muted mt-1">Manage your extended car rental agreements</p>
                                        </div>
                                        <!-- Custom Tabs -->
                                        <ul class="nav custom-tabs" id="orderTabs" role="tablist">
                                            <li class="nav-item" role="presentation">
                                                <button class="nav-link active" id="active-orders-tab" data-bs-toggle="tab" 
                                                        data-bs-target="#active-orders" type="button" role="tab">
                                                    Active Orders <span class="badge bg-success ms-1">2</span>
                                                </button>
                                            </li>
                                            <li class="nav-item" role="presentation">
                                                <button class="nav-link" id="pending-orders-tab" data-bs-toggle="tab" 
                                                        data-bs-target="#pending-orders" type="button" role="tab">
                                                    Pending <span class="badge bg-warning ms-1">1</span>
                                                </button>
                                            </li>
                                            <li class="nav-item" role="presentation">
                                                <button class="nav-link" id="completed-orders-tab" data-bs-toggle="tab" 
                                                        data-bs-target="#completed-orders" type="button" role="tab">
                                                    Completed <span class="badge bg-primary ms-1">3</span>
                                                </button>
                                            </li>
                                            <li class="nav-item" role="presentation">
                                                <button class="nav-link" id="cancelled-orders-tab" data-bs-toggle="tab" 
                                                        data-bs-target="#cancelled-orders" type="button" role="tab">
                                                    Cancelled <span class="badge bg-danger ms-1">1</span>
                                                </button>
                                            </li>
                                        </ul>
                                        <!-- Filter Section -->
                                        <div class="filter-section">
                                            <div class="filter-group">
                                                <span class="fw-medium me-3">Filter by Duration:</span>
                                                <button class="filter-btn active" data-filter="all">All</button>
                                                <button class="filter-btn" data-filter="1-3months">1-3 Months</button>
                                                <button class="filter-btn" data-filter="3-6months">3-6 Months</button>
                                                <button class="filter-btn" data-filter="6months+">6+ Months</button>
                                            </div>
                                        </div>
                                        <!-- Tab Content -->
                                        <div class="tab-content pt-4" id="orderTabContent">
                                            <!-- Active Orders Tab -->
                                            <div class="tab-pane fade show active" id="active-orders" role="tabpanel">
                                                <!-- Active Order 1 -->
                                                <div class="order-card">
                                                    <div class="order-header">
                                                        <div>
                                                            <div class="order-id">Order #LT-2024-001</div>
                                                            <div class="order-date">Started: January 15, 2024</div>
                                                        </div>
                                                        <span class="status-badge status-active">Active</span>
                                                    </div>

                                                    <div class="car-info">
                                                        <div class="car-image"></div>
                                                        <div class="car-details flex-grow-1">
                                                            <h4>KIA SEDONA PREMIUM 2017</h4>
                                                            <div class="car-specs">
                                                                <span class="car-spec">
                                                                    <i class="bi bi-gear"></i>
                                                                    Automatic
                                                                </span>
                                                                <span class="car-spec">
                                                                    <i class="bi bi-people"></i>
                                                                    7 seats
                                                                </span>
                                                                <span class="car-spec">
                                                                    <i class="bi bi-fuel-pump"></i>
                                                                    Gas
                                                                </span>
                                                            </div>
                                                            <div class="car-spec">
                                                                <i class="bi bi-geo-alt"></i>
                                                                Quận Thanh Khê, Đà Nẵng
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="rental-period">
                                                        <div class="period-row">
                                                            <span class="period-label">Start Date:</span>
                                                            <span class="period-value">January 15, 2024</span>
                                                        </div>
                                                        <div class="period-row">
                                                            <span class="period-label">End Date:</span>
                                                            <span class="period-value">July 15, 2024</span>
                                                        </div>
                                                        <div class="period-row">
                                                            <span class="period-label">Duration:</span>
                                                            <span class="duration-highlight">6 Months</span>
                                                        </div>
                                                        <div class="period-row">
                                                            <span class="period-label">Progress:</span>
                                                            <span class="period-value">45 days remaining</span>
                                                        </div>
                                                        <div class="progress-bar-custom">
                                                            <div class="progress-fill" style="width: 75%"></div>
                                                        </div>
                                                    </div>

                                                    <div class="price-section">
                                                        <div class="price-info">
                                                            <div class="price-breakdown">Monthly Rate: 25,000K × 6 months</div>
                                                            <div class="total-price">150,000K Total</div>
                                                        </div>
                                                        <div class="order-actions">
                                                            <button class="btn btn-outline-custom btn-action">View Details</button>
                                                            <button class="btn btn-primary-custom btn-action">Extend Rental</button>
                                                            <button class="btn btn-danger-custom btn-action">End Early</button>
                                                        </div>
                                                    </div>
                                                </div>

                                                <!-- Active Order 2 -->
                                                <div class="order-card">
                                                    <div class="order-header">
                                                        <div>
                                                            <div class="order-id">Order #LT-2024-003</div>
                                                            <div class="order-date">Started: February 1, 2024</div>
                                                        </div>
                                                        <span class="status-badge status-active">Active</span>
                                                    </div>

                                                    <div class="car-info">
                                                        <div class="car-image"></div>
                                                        <div class="car-details flex-grow-1">
                                                            <h4>TOYOTA FORTUNER 2020</h4>
                                                            <div class="car-specs">
                                                                <span class="car-spec">
                                                                    <i class="bi bi-gear"></i>
                                                                    Automatic
                                                                </span>
                                                                <span class="car-spec">
                                                                    <i class="bi bi-people"></i>
                                                                    7 seats
                                                                </span>
                                                                <span class="car-spec">
                                                                    <i class="bi bi-fuel-pump"></i>
                                                                    Diesel
                                                                </span>
                                                            </div>
                                                            <div class="car-spec">
                                                                <i class="bi bi-geo-alt"></i>
                                                                Quận Hải Châu, Đà Nẵng
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="rental-period">
                                                        <div class="period-row">
                                                            <span class="period-label">Start Date:</span>
                                                            <span class="period-value">February 1, 2024</span>
                                                        </div>
                                                        <div class="period-row">
                                                            <span class="period-label">End Date:</span>
                                                            <span class="period-value">May 1, 2024</span>
                                                        </div>
                                                        <div class="period-row">
                                                            <span class="period-label">Duration:</span>
                                                            <span class="duration-highlight">3 Months</span>
                                                        </div>
                                                        <div class="period-row">
                                                            <span class="period-label">Progress:</span>
                                                            <span class="period-value">28 days remaining</span>
                                                        </div>
                                                        <div class="progress-bar-custom">
                                                            <div class="progress-fill" style="width: 85%"></div>
                                                        </div>
                                                    </div>

                                                    <div class="price-section">
                                                        <div class="price-info">
                                                            <div class="price-breakdown">Monthly Rate: 35,000K × 3 months</div>
                                                            <div class="total-price">105,000K Total</div>
                                                        </div>
                                                        <div class="order-actions">
                                                            <button class="btn btn-outline-custom btn-action">View Details</button>
                                                            <button class="btn btn-primary-custom btn-action">Extend Rental</button>
                                                            <button class="btn btn-danger-custom btn-action">End Early</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- Pending Orders Tab -->
                                            <div class="tab-pane fade" id="pending-orders" role="tabpanel">
                                                <div class="order-card">
                                                    <div class="order-header">
                                                        <div>
                                                            <div class="order-id">Order #LT-2024-004</div>
                                                            <div class="order-date">Requested: March 10, 2024</div>
                                                        </div>
                                                        <span class="status-badge status-pending">Pending Approval</span>
                                                    </div>

                                                    <div class="car-info">
                                                        <div class="car-image"></div>
                                                        <div class="car-details flex-grow-1">
                                                            <h4>MERCEDES C-CLASS 2023</h4>
                                                            <div class="car-specs">
                                                                <span class="car-spec">
                                                                    <i class="bi bi-gear"></i>
                                                                    Automatic
                                                                </span>
                                                                <span class="car-spec">
                                                                    <i class="bi bi-people"></i>
                                                                    5 seats
                                                                </span>
                                                                <span class="car-spec">
                                                                    <i class="bi bi-fuel-pump"></i>
                                                                    Gas
                                                                </span>
                                                            </div>
                                                            <div class="car-spec">
                                                                <i class="bi bi-geo-alt"></i>
                                                                Quận Sơn Trà, Đà Nẵng
                                                            </div>
                                                        </div>
                                                    </div>

                                                    <div class="rental-period">
                                                        <div class="period-row">
                                                            <span class="period-label">Requested Start:</span>
                                                            <span class="period-value">March 20, 2024</span>
                                                        </div>
                                                        <div class="period-row">
                                                            <span class="period-label">Requested End:</span>
                                                            <span class="period-value">September 20, 2024</span>
                                                        </div>
                                                        <div class="period-row">
                                                            <span class="period-label">Duration:</span>
                                                            <span class="duration-highlight">6 Months</span>
                                                        </div>
                                                    </div>

                                                    <div class="price-section">
                                                        <div class="price-info">
                                                            <div class="price-breakdown">Monthly Rate: 60,000K × 6 months</div>
                                                            <div class="total-price">360,000K Total</div>
                                                        </div>
                                                        <div class="order-actions">
                                                            <button class="btn btn-outline-custom btn-action">View Details</button>
                                                            <button class="btn btn-danger-custom btn-action">Cancel Request</button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- Completed Orders Tab -->
                                            <div class="tab-pane fade" id="completed-orders" role="tabpanel">
                                                <div class="empty-state">
                                                    <i class="bi bi-check-circle" style="font-size: 3rem; color: var(--primary-green); margin-bottom: 1rem;"></i>
                                                    <h5 class="mb-3">No completed long-term orders yet</h5>
                                                    <p class="text-muted">Your completed long-term rentals will appear here.</p>
                                                </div>
                                            </div>
                                            <!-- Cancelled Orders Tab -->
                                            <div class="tab-pane fade" id="cancelled-orders" role="tabpanel">
                                                <div class="empty-state">
                                                    <i class="bi bi-x-circle" style="font-size: 3rem; color: var(--danger-red); margin-bottom: 1rem;"></i>
                                                    <h5 class="mb-3">No cancelled orders</h5>
                                                    <p class="text-muted">Cancelled long-term rental orders will appear here.</p>
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
    </body>
</html>