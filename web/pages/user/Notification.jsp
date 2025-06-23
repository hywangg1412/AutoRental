<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications - Auto Rental</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        :root {
            --primary-green: #10b981;
            --light-green: #f0fdf4;
            --warning-orange: #f59e0b;
            --danger-red: #dc2626;
            --light-gray: #f8f9fa;
            --border-gray: #e5e7eb;
            --text-gray: #6b7280;
            --blue: #3b82f6;
            --light-blue: #eff6ff;
        }

        body {
            background-color: var(--light-gray);
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }

        .header {
            background: white;
            border-bottom: 1px solid var(--border-gray);
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .logo {
            font-weight: bold;
            font-size: 1.25rem;
        }

        .logo .text-dark {
            color: #333 !important;
        }

        .logo .text-success {
            color: var(--primary-green) !important;
        }

        .nav-links a {
            color: var(--text-gray);
            text-decoration: none;
            transition: color 0.2s;
        }

        .nav-links a:hover {
            color: var(--primary-green);
        }

        .user-avatar {
            width: 32px;
            height: 32px;
            background-color: #d1d5db;
        }

        .notification-bell {
            position: relative;
            color: var(--primary-green);
        }

        .notification-badge {
            position: absolute;
            top: -5px;
            right: -5px;
            background-color: var(--danger-red);
            color: white;
            border-radius: 50%;
            width: 18px;
            height: 18px;
            font-size: 0.7rem;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .sidebar {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            height: fit-content;
        }

        .sidebar-menu {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar-menu .nav-link {
            color: var(--text-gray);
            border-radius: 0;
            padding: 0.75rem 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
            transition: all 0.2s;
            border: none;
        }

        .sidebar-menu .nav-link:hover {
            background-color: #f3f4f6;
            color: var(--primary-green);
        }

        .sidebar-menu .nav-link.active {
            background-color: var(--light-green);
            color: var(--primary-green);
            border-right: 3px solid var(--primary-green);
        }

        .sidebar-menu .nav-link.text-danger:hover {
            background-color: #fee2e2;
            color: var(--danger-red);
        }

        .main-content {
            background: white;
            border-radius: 12px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .notification-header {
            border-bottom: 1px solid var(--border-gray);
            padding: 1.5rem;
        }

        .notification-filters {
            display: flex;
            gap: 1rem;
            margin-top: 1rem;
        }

        .filter-btn {
            background: transparent;
            border: 1px solid var(--border-gray);
            color: var(--text-gray);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-size: 0.875rem;
            transition: all 0.2s;
        }

        .filter-btn:hover,
        .filter-btn.active {
            background-color: var(--primary-green);
            border-color: var(--primary-green);
            color: white;
        }

        .notification-list {
            max-height: 600px;
            overflow-y: auto;
        }

        .notification-item {
            padding: 1.5rem;
            border-bottom: 1px solid #f3f4f6;
            transition: all 0.2s;
            cursor: pointer;
        }

        .notification-item:hover {
            background-color: #f9fafb;
        }

        .notification-item.unread {
            background-color: var(--light-blue);
            border-left: 4px solid var(--blue);
        }

        .notification-item.unread:hover {
            background-color: #dbeafe;
        }

        .notification-icon {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            flex-shrink: 0;
        }

        .notification-icon.success {
            background-color: var(--light-green);
            color: var(--primary-green);
        }

        .notification-icon.warning {
            background-color: #fef3c7;
            color: var(--warning-orange);
        }

        .notification-icon.info {
            background-color: var(--light-blue);
            color: var(--blue);
        }

        .notification-icon.danger {
            background-color: #fee2e2;
            color: var(--danger-red);
        }

        .notification-content {
            flex: 1;
        }

        .notification-title {
            font-weight: 600;
            color: #333;
            margin-bottom: 0.25rem;
        }

        .notification-message {
            color: var(--text-gray);
            font-size: 0.875rem;
            line-height: 1.4;
            margin-bottom: 0.5rem;
        }

        .notification-time {
            font-size: 0.75rem;
            color: var(--text-gray);
        }

        .notification-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: 0.75rem;
        }

        .btn-sm-custom {
            padding: 0.25rem 0.75rem;
            font-size: 0.75rem;
            border-radius: 4px;
        }

        .mark-read-btn {
            position: absolute;
            top: 1rem;
            right: 1rem;
            background: transparent;
            border: none;
            color: var(--text-gray);
            font-size: 0.875rem;
            opacity: 0;
            transition: opacity 0.2s;
        }

        .notification-item:hover .mark-read-btn {
            opacity: 1;
        }

        .mark-read-btn:hover {
            color: var(--primary-green);
        }

        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--text-gray);
        }

        .dropdown-toggle::after {
            margin-left: 0.5rem;
        }
    </style>
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
                        <div class="notification-bell">
                            <i class="bi bi-bell-fill"></i>
                            <span class="notification-badge">3</span>
                        </div>
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
                        <li><a href="profile.jsp" class="nav-link">
                            <i class="bi bi-person"></i>
                            My account
                        </a></li>
                        <li><a href="FavoriteCar.jsp" class="nav-link">
                            <i class="bi bi-heart"></i>
                            Favorite cars
                        </a></li>
                        <li><a href="MyTrip.jsp" class="nav-link">
                            <i class="bi bi-car-front"></i>
                            My trips
                        </a></li>
                        <li><a href="longtermrender.jsp" class="nav-link">
                            <i class="bi bi-clipboard-check"></i>
                            Long-term car rental orders
                        </a></li>
                        <li><a href="myaddress.jsp" class="nav-link">
                            <i class="bi bi-geo-alt"></i>
                            My address
                        </a></li>
                        <li><a href="Notification.jsp" class="nav-link active">
                            <i class="bi bi-bell"></i>
                            Notifications
                        </a></li>
                        <li><a href="changepassword.jsp" class="nav-link">
                            <i class="bi bi-lock"></i>
                            Change password
                        </a></li>
                        <li><a href="changepassword.jsp" class="nav-link">
                            <i class="bi bi-trash"></i>
                            Request account deletion
                        </a></li>
                        <li class="mt-3"><a href="${pageContext.request.contextPath}/logout" class="nav-link text-danger">
                            <i class="bi bi-box-arrow-right"></i>
                            Log out
                        </a></li>
                    </ul>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-lg-9">
                <div class="main-content">
                    <!-- Notification Header -->
                    <div class="notification-header">
                        <div class="d-flex justify-content-between align-items-center">
                            <h1 class="h4 fw-semibold mb-0">Notifications</h1>
                            <button class="btn btn-outline-secondary btn-sm" onclick="markAllAsRead()">
                                <i class="bi bi-check2-all me-1"></i>Mark all as read
                            </button>
                        </div>
                        <div class="notification-filters">
                            <button class="filter-btn active" data-filter="all">All</button>
                            <button class="filter-btn" data-filter="unread">Unread</button>
                            <button class="filter-btn" data-filter="trips">Trips</button>
                            <button class="filter-btn" data-filter="system">System</button>
                            <button class="filter-btn" data-filter="promotions">Promotions</button>
                        </div>
                    </div>

                    <!-- Notification List -->
                    <div class="notification-list">
                        <!-- Unread Notification 1 -->
                        <div class="notification-item unread position-relative" data-type="trips">
                            <button class="mark-read-btn" onclick="markAsRead(this)">
                                <i class="bi bi-check"></i>
                            </button>
                            <div class="d-flex gap-3">
                                <div class="notification-icon success">
                                    <i class="bi bi-car-front"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-title">Trip Completed Successfully</div>
                                    <div class="notification-message">
                                        Your trip with KIA SEDONA PREMIUM 2017 has been completed. Thank you for choosing Auto Rental!
                                    </div>
                                    <div class="notification-time">2 hours ago</div>
                                    <div class="notification-actions">
                                        <button class="btn btn-outline-primary btn-sm-custom">Rate Trip</button>
                                        <button class="btn btn-outline-secondary btn-sm-custom">View Details</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Unread Notification 2 -->
                        <div class="notification-item unread position-relative" data-type="system">
                            <button class="mark-read-btn" onclick="markAsRead(this)">
                                <i class="bi bi-check"></i>
                            </button>
                            <div class="d-flex gap-3">
                                <div class="notification-icon warning">
                                    <i class="bi bi-exclamation-triangle"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-title">Driver's License Verification Failed</div>
                                    <div class="notification-message">
                                        Your driver's license verification was unsuccessful. Please upload a clear photo of your license.
                                    </div>
                                    <div class="notification-time">5 hours ago</div>
                                    <div class="notification-actions">
                                        <button class="btn btn-primary btn-sm-custom">Upload License</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Unread Notification 3 -->
                        <div class="notification-item unread position-relative" data-type="promotions">
                            <button class="mark-read-btn" onclick="markAsRead(this)">
                                <i class="bi bi-check"></i>
                            </button>
                            <div class="d-flex gap-3">
                                <div class="notification-icon info">
                                    <i class="bi bi-gift"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-title">Special Offer: 20% Off Your Next Trip</div>
                                    <div class="notification-message">
                                        Limited time offer! Get 20% discount on your next car rental. Use code SAVE20 at checkout.
                                    </div>
                                    <div class="notification-time">1 day ago</div>
                                    <div class="notification-actions">
                                        <button class="btn btn-success btn-sm-custom">Book Now</button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Read Notification 1 -->
                        <div class="notification-item position-relative" data-type="trips">
                            <div class="d-flex gap-3">
                                <div class="notification-icon success">
                                    <i class="bi bi-check-circle"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-title">Booking Confirmed</div>
                                    <div class="notification-message">
                                        Your booking for Toyota Camry 2020 has been confirmed. Pickup time: Tomorrow 9:00 AM.
                                    </div>
                                    <div class="notification-time">2 days ago</div>
                                </div>
                            </div>
                        </div>

                        <!-- Read Notification 2 -->
                        <div class="notification-item position-relative" data-type="system">
                            <div class="d-flex gap-3">
                                <div class="notification-icon info">
                                    <i class="bi bi-info-circle"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-title">Account Verification Complete</div>
                                    <div class="notification-message">
                                        Your account has been successfully verified. You can now book premium vehicles.
                                    </div>
                                    <div class="notification-time">3 days ago</div>
                                </div>
                            </div>
                        </div>

                        <!-- Read Notification 3 -->
                        <div class="notification-item position-relative" data-type="trips">
                            <div class="d-flex gap-3">
                                <div class="notification-icon danger">
                                    <i class="bi bi-x-circle"></i>
                                </div>
                                <div class="notification-content">
                                    <div class="notification-title">Booking Cancelled</div>
                                    <div class="notification-message">
                                        Your booking for Honda Civic 2019 has been cancelled due to vehicle unavailability. Refund processed.
                                    </div>
                                    <div class="notification-time">1 week ago</div>
                                </div>
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
            btn.addEventListener('click', function() {
                // Remove active class from all buttons
                document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
                // Add active class to clicked button
                this.classList.add('active');
                
                const filter = this.getAttribute('data-filter');
                const notifications = document.querySelectorAll('.notification-item');
                
                notifications.forEach(notification => {
                    if (filter === 'all') {
                        notification.style.display = 'block';
                    } else if (filter === 'unread') {
                        notification.style.display = notification.classList.contains('unread') ? 'block' : 'none';
                    } else {
                        const type = notification.getAttribute('data-type');
                        notification.style.display = type === filter ? 'block' : 'none';
                    }
                });
            });
        });

        // Mark single notification as read
        function markAsRead(button) {
            const notification = button.closest('.notification-item');
            notification.classList.remove('unread');
            button.style.display = 'none';
            updateNotificationCount();
        }

        // Mark all notifications as read
        function markAllAsRead() {
            document.querySelectorAll('.notification-item.unread').forEach(notification => {
                notification.classList.remove('unread');
                const markBtn = notification.querySelector('.mark-read-btn');
                if (markBtn) markBtn.style.display = 'none';
            });
            updateNotificationCount();
        }

        // Update notification count in header
        function updateNotificationCount() {
            const unreadCount = document.querySelectorAll('.notification-item.unread').length;
            const badge = document.querySelector('.notification-badge');
            if (unreadCount > 0) {
                badge.textContent = unreadCount;
                badge.style.display = 'flex';
            } else {
                badge.style.display = 'none';
            }
        }

        // Click notification to mark as read
        document.querySelectorAll('.notification-item').forEach(item => {
            item.addEventListener('click', function(e) {
                if (!e.target.closest('.mark-read-btn') && !e.target.closest('.notification-actions')) {
                    if (this.classList.contains('unread')) {
                        this.classList.remove('unread');
                        const markBtn = this.querySelector('.mark-read-btn');
                        if (markBtn) markBtn.style.display = 'none';
                        updateNotificationCount();
                    }
                }
            });
        });
    </script>
</body>
</html>