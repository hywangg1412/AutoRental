<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Long-term Car Rental Orders - Auto Rental</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
        <!-- Custom CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/user/longterm-booking.css">
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center py-3">
                    <div class="logo">
                        <span class="text-dark">AUTO</span><span class="text-success">RENTAL</span>
                    </div>
                    <div class="d-flex align-items-center gap-4">
                        <nav class="nav-links d-flex gap-4">
                            <a href="#" class="fw-medium">About</a>
                            <a href="#" class="fw-medium">My trips</a>
                        </nav>
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-bell"></i>
                            <i class="bi bi-chat-dots"></i>
                            <div class="dropdown">
                                <button class="btn btn-link text-decoration-none text-dark dropdown-toggle d-flex align-items-center gap-2" 
                                        type="button" data-bs-toggle="dropdown">
                                    <div class="user-avatar rounded-circle"></div>
                                    <span>hywang1412</span>
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#">Profile</a></li>
                                    <li><a class="dropdown-item" href="#">Settings</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="#">Logout</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <div class="container-fluid mt-4">
            <div class="row g-4">
                <!-- Sidebar -->
                <div class="col-lg-3">
                    <div class="sidebar p-4">
                        <h2 class="h4 fw-bold mb-4">Hello !</h2>
                        <ul class="sidebar-menu">
                            <li><a href="my-account.jsp" class="nav-link">
                                    <i class="bi bi-person"></i>
                                    My account
                                </a></li>
                            <li><a href="favorite-car.jsp" class="nav-link">
                                    <i class="bi bi-heart"></i>
                                    Favorite cars
                                </a></li>
                            <li><a href="my-trip.jsp" class="nav-link">
                                    <i class="bi bi-car-front"></i>
                                    My trips
                                </a></li>
                            <li><a href="longterm-booking.jsp" class="nav-link active">
                                    <i class="bi bi-clipboard-check"></i>
                                    Long-term car rental orders
                                </a></li>
                            <li><a href="my-address.jsp" class="nav-link">
                                    <i class="bi bi-geo-alt"></i>
                                    My address
                                </a></li>
                            <li><a href="change-password.jsp" class="nav-link">
                                    <i class="bi bi-lock"></i>
                                    Change password
                                </a></li>
                            <li><a href="request-delete.jsp" class="nav-link">
                                    <i class="bi bi-trash"></i>
                                    Request account deletion
                                </a></li>
                            <li class="mt-3"><a href="#" class="nav-link text-danger">
                                    <i class="bi bi-box-arrow-right"></i>
                                    Log out
                                </a></li>
                        </ul>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="col-lg-9">
                    <div class="main-content">
                        <!-- Page Header -->
                        <div class="p-4 border-bottom">
                            <h1 class="h4 fw-semibold mb-0">Long-term Car Rental Orders</h1>
                            <p class="text-muted mt-1">Manage your extended car rental agreements</p>
                        </div>

                        <!-- Custom Tabs -->
                        <ul class="nav custom-tabs px-4" id="orderTabs" role="tablist">
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
                        <div class="tab-content p-4" id="orderTabContent">
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

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Filter functionality
            document.querySelectorAll('.filter-btn').forEach(btn => {
                btn.addEventListener('click', function () {
                    // Remove active class from all buttons
                    document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
                    // Add active class to clicked button
                    this.classList.add('active');

                    const filter = this.getAttribute('data-filter');
                    filterOrders(filter);
                });
            });

            function filterOrders(filter) {
                const orders = document.querySelectorAll('.order-card');

                orders.forEach(order => {
                    const durationText = order.querySelector('.duration-highlight').textContent;
                    let show = true;

                    if (filter !== 'all') {
                        if (filter === '1-3months') {
                            show = durationText.includes('1 Month') || durationText.includes('2 Month') || durationText.includes('3 Month');
                        } else if (filter === '3-6months') {
                            show = durationText.includes('3 Month') || durationText.includes('4 Month') ||
                                    durationText.includes('5 Month') || durationText.includes('6 Month');
                        } else if (filter === '6months+') {
                            show = durationText.includes('6 Month') || durationText.includes('7 Month') ||
                                    durationText.includes('8 Month') || durationText.includes('9 Month') ||
                                    durationText.includes('10 Month') || durationText.includes('11 Month') ||
                                    durationText.includes('12 Month') || durationText.includes('Year');
                        }
                    }

                    order.style.display = show ? 'block' : 'none';
                });
            }

            // Add smooth transition effect for tab switching
            document.querySelectorAll('[data-bs-toggle="tab"]').forEach(tab => {
                tab.addEventListener('shown.bs.tab', function (e) {
                    const targetPane = document.querySelector(e.target.getAttribute('data-bs-target'));
                    targetPane.style.animation = 'none';
                    targetPane.offsetHeight; // Trigger reflow
                    targetPane.style.animation = 'fadeIn 0.3s ease-in-out';
                });
            });

            // Order action handlers
            document.addEventListener('click', function (e) {
                if (e.target.textContent === 'View Details') {
                    alert('Opening order details...');
                } else if (e.target.textContent === 'Extend Rental') {
                    alert('Opening rental extension form...');
                } else if (e.target.textContent === 'End Early') {
                    if (confirm('Are you sure you want to end this rental early?')) {
                        alert('Processing early termination...');
                    }
                } else if (e.target.textContent === 'Cancel Request') {
                    if (confirm('Are you sure you want to cancel this request?')) {
                        e.target.closest('.order-card').remove();
                    }
                }
            });

            // Update progress bars animation
            document.addEventListener('DOMContentLoaded', function () {
                const progressBars = document.querySelectorAll('.progress-fill');
                progressBars.forEach(bar => {
                    const width = bar.style.width;
                    bar.style.width = '0%';
                    setTimeout(() => {
                        bar.style.width = width;
                    }, 500);
                });
            });
        </script>
    </body>
</html>