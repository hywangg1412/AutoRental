<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Customer Support & Feedback - CarRental Pro</title>
        
        <!-- ===== External CSS Libraries ===== -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        
        <!-- ===== Custom Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/staff/customer-support.css">
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
                    <a href="customer-support.jsp" class="nav-item active">
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
            <!-- Header -->
            <div class="content-header">
                <div class="header-left">
                    <h1 class="page-title">Customer Support & Feedback</h1>
                    <p class="page-subtitle">Manage customer reviews and support requests</p>
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

            <!-- Progress Bar -->
            <div class="progress-container">
                <div class="progress">
                    <div class="progress-bar" style="width: 75%"></div>
                </div>
            </div>

            <!-- Customer Ratings Section -->
            <div class="content-section">
                <div class="section-header">
                    <h2 class="section-title">Customer Reviews</h2>
                    <p class="section-subtitle">View and respond to customer feedback</p>
                </div>

                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Customer Name</th>
                                <th>Rented Vehicle</th>
                                <th>Rating</th>
                                <th>Review Content</th>
                                <th>Review Date</th>
                                <th>Response Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td class="customer-name">John Smith</td>
                                <td class="vehicle-name">Toyota Camry 2023</td>
                                <td class="rating">
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                </td>
                                <td class="comment">Great service, clean car, friendly staff.</td>
                                <td>05/30/2025</td>
                                <td>
                                    <span class="status-badge badge-success">Responded</span>
                                </td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#replyModal">
                                        <i class="fas fa-reply me-1"></i>Reply
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td class="customer-name">Sarah Johnson</td>
                                <td class="vehicle-name">Honda Civic 2022</td>
                                <td class="rating">
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="far fa-star text-warning"></i>
                                    <i class="far fa-star text-warning"></i>
                                </td>
                                <td class="comment">Car was good but delivery was a bit late.</td>
                                <td>05/29/2025</td>
                                <td>
                                    <span class="status-badge badge-warning">Pending</span>
                                </td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#replyModal">
                                        <i class="fas fa-reply me-1"></i>Reply
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td class="customer-name">Michael Brown</td>
                                <td class="vehicle-name">Tesla Model 3</td>
                                <td class="rating">
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="far fa-star text-warning"></i>
                                </td>
                                <td class="comment">Modern car, but needs better usage instructions.</td>
                                <td>05/28/2025</td>
                                <td>
                                    <span class="status-badge badge-warning">Pending</span>
                                </td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#replyModal">
                                        <i class="fas fa-reply me-1"></i>Reply
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Support Requests Section -->
            <div class="content-section">
                <div class="section-header">
                    <h2 class="section-title">Customer Support Requests</h2>
                    <p class="section-subtitle">Handle direct customer support inquiries</p>
                </div>

                <div class="card">
                    <div class="card-body">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Customer Name</th>
                                    <th>Support Request</th>
                                    <th>Date</th>
                                    <th>Contact</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>1</td>
                                    <td class="customer-name">Robert Wilson</td>
                                    <td class="support-request">Contract not received</td>
                                    <td>05/30/2025</td>
                                    <td>
                                        <a href="https://zalo.me/0123456789" class="btn btn-success btn-sm" data-bs-toggle="tooltip" data-bs-placement="top" title="Chat with customer on Zalo">
                                            <i class="fas fa-comment-dots me-1"></i>Zalo
                                        </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td class="customer-name">Emily Davis</td>
                                    <td class="support-request">Need help changing rental time</td>
                                    <td>05/29/2025</td>
                                    <td>
                                        <a href="https://zalo.me/0987654321" class="btn btn-success btn-sm" data-bs-toggle="tooltip" data-bs-placement="top" title="Chat with customer on Zalo">
                                            <i class="fas fa-comment-dots me-1"></i>Zalo
                                        </a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Reply Modal -->
    <div class="modal fade" id="replyModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Reply to Customer Review</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="replyForm">
                        <div class="mb-3">
                            <label class="form-label">Customer Name</label>
                            <input type="text" class="form-control" value="John Smith" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Vehicle</label>
                            <input type="text" class="form-control" value="Toyota Camry 2023" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Original Review</label>
                            <div class="p-3 bg-light rounded">
                                <div class="rating mb-2">
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                </div>
                                <p class="mb-0">Great service, clean car, friendly staff.</p>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Your Response</label>
                            <textarea class="form-control" rows="4" placeholder="Enter your response to the customer..." required></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" form="replyForm" class="btn btn-primary">Send Response</button>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== External JavaScript Libraries ===== -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- ===== Custom JavaScript ===== -->
    <script src="${pageContext.request.contextPath}/scripts/staff/customer-support.js"></script>
</body>
</html>