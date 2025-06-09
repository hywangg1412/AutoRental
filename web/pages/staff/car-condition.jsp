<%-- 
    Document   : car-condition.jsp
    Created on : Jun 1, 2025, 11:00:54 AM
    Author     : ACER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Car Condition Report - CarRental Pro</title>
        
        <!-- ===== External CSS Libraries ===== -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        
        <!-- ===== Custom Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/staff/car-condition.css">
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
                    <a href="car-condition.jsp" class="nav-item active">
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
            <!-- Header -->
            <div class="content-header">
                <div class="header-left">
                    <h1 class="page-title">Car Condition Report</h1>
                    <p class="page-subtitle">Inspect and report vehicle conditions after customer returns</p>
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
                            <option>Pending Inspection</option>
                            <option>Completed</option>
                            <option>Issues Found</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-search"></i>
                            </span>
                            <input type="text" class="form-control" placeholder="Search by rental ID, vehicle or license plate">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <button class="btn btn-primary w-100">
                            <i class="fas fa-filter me-2"></i>Filter Results
                        </button>
                    </div>
                </div>
            </div>

            <!-- Recently Completed Inspections -->
            <div class="content-section">
                <div class="section-header">
                    <h2 class="section-title">Recent Inspections</h2>
                    <p class="section-subtitle">5 most recent completed vehicle inspections</p>
                </div>

                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Rental ID</th>
                                <th>Vehicle</th>
                                <th>License Plate</th>
                                <th>Inspection Date</th>
                                <th>Condition</th>
                                <th>Inspector</th>
                                <th>Notes</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="rental-id">RNT-0995</td>
                                <td class="vehicle-name">Toyota Corolla</td>
                                <td class="license-plate">MNO-678</td>
                                <td class="inspection-date">11/15/2025</td>
                                <td>
                                    <span class="condition-badge normal">Normal</span>
                                </td>
                                <td class="inspector-name">John Staff</td>
                                <td class="inspection-notes">Vehicle returned in excellent condition</td>
                                <td>
                                    <button class="btn btn-outline-secondary btn-sm action-btn">
                                        <i class="fas fa-eye"></i>
                                        View
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td class="rental-id">RNT-0994</td>
                                <td class="vehicle-name">Hyundai Sonata</td>
                                <td class="license-plate">PQR-901</td>
                                <td class="inspection-date">11/15/2025</td>
                                <td>
                                    <span class="condition-badge needs-cleaning">Needs Cleaning</span>
                                </td>
                                <td class="inspector-name">John Staff</td>
                                <td class="inspection-notes">Interior needs cleaning, food stains on seats</td>
                                <td>
                                    <button class="btn btn-outline-secondary btn-sm action-btn">
                                        <i class="fas fa-eye"></i>
                                        View
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td class="rental-id">RNT-0993</td>
                                <td class="vehicle-name">Chevrolet Malibu</td>
                                <td class="license-plate">STU-234</td>
                                <td class="inspection-date">11/14/2025</td>
                                <td>
                                    <span class="condition-badge minor-scratches">Minor Scratches</span>
                                </td>
                                <td class="inspector-name">Sarah Admin</td>
                                <td class="inspection-notes">Small scratch on rear bumper, otherwise good</td>
                                <td>
                                    <button class="btn btn-outline-secondary btn-sm action-btn">
                                        <i class="fas fa-eye"></i>
                                        View
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td class="rental-id">RNT-0992</td>
                                <td class="vehicle-name">Kia Sportage</td>
                                <td class="license-plate">VWX-567</td>
                                <td class="inspection-date">11/14/2025</td>
                                <td>
                                    <span class="condition-badge normal">Normal</span>
                                </td>
                                <td class="inspector-name">Sarah Admin</td>
                                <td class="inspection-notes">No issues found</td>
                                <td>
                                    <button class="btn btn-outline-secondary btn-sm action-btn">
                                        <i class="fas fa-eye"></i>
                                        View
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td class="rental-id">RNT-0991</td>
                                <td class="vehicle-name">Mazda CX-5</td>
                                <td class="license-plate">YZA-890</td>
                                <td class="inspection-date">11/13/2025</td>
                                <td>
                                    <span class="condition-badge major-damage">Major Damage</span>
                                </td>
                                <td class="inspector-name">Mike Inspector</td>
                                <td class="inspection-notes">Large dent on driver's door, needs repair</td>
                                <td>
                                    <button class="btn btn-outline-secondary btn-sm action-btn">
                                        <i class="fas fa-eye"></i>
                                        View
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Pending Inspections Section -->
            <div class="content-section">
                <div class="section-header">
                    <h2 class="section-title">Pending Inspections</h2>
                    <p class="section-subtitle">Vehicles awaiting inspection after return</p>
                </div>

                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>Rental ID</th>
                                <th>Vehicle</th>
                                <th>License Plate</th>
                                <th>Return Date</th>
                                <th>Customer</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="rental-id">RNT-0996</td>
                                <td class="vehicle-name">Ford Focus</td>
                                <td class="license-plate">BCD-123</td>
                                <td class="return-date">11/16/2025</td>
                                <td class="customer-name">Robert Johnson</td>
                                <td>
                                    <span class="status-badge pending">Pending</span>
                                </td>
                                <td>
                                    <button class="btn btn-primary btn-sm action-btn">
                                        <i class="fas fa-clipboard-check"></i>
                                        Inspect
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td class="rental-id">RNT-0997</td>
                                <td class="vehicle-name">Honda Civic</td>
                                <td class="license-plate">EFG-456</td>
                                <td class="return-date">11/16/2025</td>
                                <td class="customer-name">Emily Davis</td>
                                <td>
                                    <span class="status-badge pending">Pending</span>
                                </td>
                                <td>
                                    <button class="btn btn-primary btn-sm action-btn">
                                        <i class="fas fa-clipboard-check"></i>
                                        Inspect
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Inspection Modal -->
    <div class="modal fade" id="inspectionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Vehicle Inspection</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="inspectionForm">
                        <div class="row g-4">
                            <div class="col-md-6">
                                <h6 class="mb-3">Vehicle Information</h6>
                                <div class="mb-3">
                                    <label class="form-label">Vehicle</label>
                                    <input type="text" class="form-control" value="Ford Focus" readonly>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">License Plate</label>
                                    <input type="text" class="form-control" value="BCD-123" readonly>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Rental ID</label>
                                    <input type="text" class="form-control" value="RNT-0996" readonly>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <h6 class="mb-3">Inspection Details</h6>
                                <div class="mb-3">
                                    <label class="form-label">Overall Condition</label>
                                    <select class="form-select" required>
                                        <option value="">Select condition...</option>
                                        <option value="normal">Normal</option>
                                        <option value="needs-cleaning">Needs Cleaning</option>
                                        <option value="minor-scratches">Minor Scratches</option>
                                        <option value="major-damage">Major Damage</option>
                                    </select>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Inspection Notes</label>
                                    <textarea class="form-control" rows="3" placeholder="Enter detailed inspection notes..." required></textarea>
                                </div>
                            </div>
                            <div class="col-12">
                                <h6 class="mb-3">Damage Assessment</h6>
                                <div class="row g-3">
                                    <div class="col-md-6">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="exteriorDamage">
                                            <label class="form-check-label" for="exteriorDamage">Exterior Damage</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="interiorDamage">
                                            <label class="form-check-label" for="interiorDamage">Interior Damage</label>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="mechanicalIssues">
                                            <label class="form-check-label" for="mechanicalIssues">Mechanical Issues</label>
                                        </div>
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" id="needsCleaning">
                                            <label class="form-check-label" for="needsCleaning">Needs Cleaning</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-12">
                                <h6 class="mb-3">Upload Photos</h6>
                                <div class="mb-3">
                                    <input type="file" class="form-control" multiple accept="image/*">
                                    <small class="text-muted">Upload photos of any damage or issues found</small>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" form="inspectionForm" class="btn btn-primary">Submit Inspection</button>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== External JavaScript Libraries ===== -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- ===== Custom JavaScript ===== -->
    <script src="${pageContext.request.contextPath}/scripts/staff/car-condition.js"></script>
</body>
</html>