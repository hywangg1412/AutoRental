<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Car Availability Management - CarRental Pro</title>
        
        <!-- ===== External CSS Libraries ===== -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        
        <!-- ===== Custom Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/staff/car-availability.css">
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
                    <a href="car-availability.jsp" class="nav-item active">
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
            <!-- Header -->
            <div class="content-header">
                <div class="header-left">
                    <h1 class="page-title">Car Availability Management</h1>
                    <p class="page-subtitle">Track and update vehicle availability status</p>
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

            <!-- Filter Section -->
            <div class="filter-section">
                <div class="row g-3">
                    <div class="col-md-3">
                        <select class="form-select">
                            <option>All Status</option>
                            <option>Available</option>
                            <option>Rented</option>
                            <option>Maintenance</option>
                            <option>Coming Soon</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select">
                            <option>All Vehicle Types</option>
                            <option>Sedan</option>
                            <option>SUV</option>
                            <option>Truck</option>
                            <option>Electric</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-search"></i>
                            </span>
                            <input type="text" class="form-control" placeholder="Search by Model, License Plate, or Brand">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <button class="btn btn-primary w-100">
                            <i class="fas fa-filter me-2"></i>Filter
                        </button>
                    </div>
                </div>
            </div>

            <!-- Vehicle Availability Table -->
            <div class="content-section">
                <div class="section-header">
                    <h2 class="section-title">Vehicle List</h2>
                    <p class="section-subtitle">Current status of all vehicles in the system</p>
                </div>

                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Model</th>
                                <th>License Plate</th>
                                <th>Status</th>
                                <th>Current Renter</th>
                                <th>Next Available</th>
                                <th>Late Fee</th>
                                <th>Notes</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td class="vehicle-name">Toyota Camry 2023</td>
                                <td class="license-plate">ABC-123</td>
                                <td>
                                    <span class="status-badge badge-success">Available</span>
                                </td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td class="notes">Vehicle inspected and ready for use</td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#updateModal">
                                        <i class="fas fa-edit me-1"></i>Update
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td class="vehicle-name">Honda Civic 2022</td>
                                <td class="license-plate">XYZ-789</td>
                                <td>
                                    <span class="status-badge badge-warning">Rented</span>
                                </td>
                                <td>John Smith</td>
                                <td>06/03/2025 12:00</td>
                                <td class="late-fee">$5.00</td>
                                <td class="notes">2 hours late for return</td>
                                <td>
                                    <div class="d-flex gap-2">
                                        <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#updateModal">
                                            <i class="fas fa-edit me-1"></i>Update
                                        </button>
                                        <button class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#confirmReturnModal">
                                            <i class="fas fa-check me-1"></i>Confirm Return
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td class="vehicle-name">BMW X5 2021</td>
                                <td class="license-plate">DEF-456</td>
                                <td>
                                    <span class="status-badge badge-danger">Maintenance</span>
                                </td>
                                <td>-</td>
                                <td>2 days remaining</td>
                                <td>-</td>
                                <td class="notes">Tire replacement and engine check</td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#updateModal">
                                        <i class="fas fa-edit me-1"></i>Update
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>4</td>
                                <td class="vehicle-name">Tesla Model 3</td>
                                <td class="license-plate">GHI-012</td>
                                <td>
                                    <span class="status-badge badge-info">Coming Soon</span>
                                </td>
                                <td>-</td>
                                <td>05/31/2025 14:00</td>
                                <td>-</td>
                                <td class="notes">Being cleaned, ready in 2 hours</td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#updateModal">
                                        <i class="fas fa-edit me-1"></i>Update
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>5</td>
                                <td class="vehicle-name">Ford Ranger 2022</td>
                                <td class="license-plate">JKL-345</td>
                                <td>
                                    <span class="status-badge badge-success">Available</span>
                                </td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td class="notes">Newly inspected, full fuel</td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#updateModal">
                                        <i class="fas fa-edit me-1"></i>Update
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Update Status Modal -->
    <div class="modal fade" id="updateModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Update Vehicle Status</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="updateForm">
                        <div class="mb-3">
                            <label class="form-label">Vehicle</label>
                            <input type="text" class="form-control" value="Toyota Camry 2023" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">License Plate</label>
                            <input type="text" class="form-control" value="ABC-123" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Status</label>
                            <select class="form-select" required>
                                <option value="">Select status...</option>
                                <option value="available">Available</option>
                                <option value="rented">Rented</option>
                                <option value="maintenance">Maintenance</option>
                                <option value="coming-soon">Coming Soon</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Notes</label>
                            <textarea class="form-control" rows="3" placeholder="Enter status update notes..."></textarea>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Next Available Date (if applicable)</label>
                            <input type="datetime-local" class="form-control">
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" form="updateForm" class="btn btn-primary">Update Status</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Confirm Return Modal -->
    <div class="modal fade" id="confirmReturnModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Confirm Vehicle Return</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="returnForm">
                        <div class="mb-3">
                            <label class="form-label">Vehicle</label>
                            <input type="text" class="form-control" value="Honda Civic 2022" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">License Plate</label>
                            <input type="text" class="form-control" value="XYZ-789" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Return Date</label>
                            <input type="datetime-local" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Late Fee (if applicable)</label>
                            <input type="number" class="form-control" value="5.00" step="0.01">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Return Notes</label>
                            <textarea class="form-control" rows="3" placeholder="Enter any notes about the return..."></textarea>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" form="returnForm" class="btn btn-success">Confirm Return</button>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== External JavaScript Libraries ===== -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- ===== Custom JavaScript ===== -->
    <script src="${pageContext.request.contextPath}/scripts/staff/car-availability.js"></script>
</body>
</html>