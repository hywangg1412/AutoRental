<%-- 
    Document   : staff-booking.jsp
    Created on : Jun 1, 2025, 11:00:04 AM
    Author     : ACER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>CarRental Pro - Booking Requests</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
  <link rel="stylesheet" href="css/styles.css">
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
          <h5 class="mb-0">AutoRental</h5>
          <small class="text-muted">Staff Dashboard</small>
        </div>
      </div>
    </div>
    <div class="p-3">
      <h6 class="px-3 mb-2 text-muted">Navigation</h6>
      <ul class="nav flex-column">
        <li class="nav-item">
          <a class="nav-link" href="staff-dashboard.jsp">
            <i class="fas fa-home"></i> Dashboard
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link active" href="staff-booking.jsp">
            <i class="fas fa-calendar"></i> Booking Requests
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="car-condition.jsp">
            <i class="fas fa-car"></i> Car Condition
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="car-availability.jsp">
            <i class="fas fa-clipboard-list"></i> Car Availability
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#">
            <i class="fas fa-shield-alt"></i> Damage Reports
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="customer-support.jsp">
            <i class="fas fa-comment"></i> Customer Feedback
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="#">
            <i class="fas fa-users"></i> Support Users
          </a>
        </li>
      </ul>
      <hr>
      <ul class="nav flex-column">
        <li class="nav-item">
          <a class="nav-link text-danger" href="#">
            <i class="fas fa-sign-out-alt"></i> Logout
          </a>
        </li>
      </ul>
    </div>
  </div>

  <!-- Main Content -->
  <div class="main-content">
    <header class="header">
      <div class="d-flex align-items-center gap-2">
        <button class="btn btn-outline-secondary btn-sm d-lg-none" type="button" data-bs-toggle="collapse" data-bs-target="#sidebarMenu">
          <i class="fas fa-bars"></i>
        </button>
        <div>
          <h4 class="mb-0">Booking Requests</h4>
          <small class="text-muted">Manage incoming rental requests and bookings</small>
        </div>
      </div>
      <div class="d-flex align-items-center gap-3">
        <button class="btn btn-outline-secondary btn-sm">
          <i class="fas fa-bell me-2"></i> Notifications
        </button>
        <div class="d-flex align-items-center gap-2">
          <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center" style="width: 32px; height: 32px;">
            JS
          </div>
          <span>John Staff</span>
        </div>
      </div>
    </header>

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
                <tr>
                  <td>BK001</td>
                  <td>
                    <div>John Smith</div>
                    <small class="text-muted">john.smith@email.com</small>
                  </td>
                  <td>
                    <div>Toyota Camry</div>
                    <small class="text-muted">ABC-123</small>
                  </td>
                  <td>Nov 20, 2025</td>
                  <td>Nov 25, 2025</td>
                  <td><span class="badge badge-pending"><i class="fas fa-clock me-1"></i>pending</span></td>
                  <td>$250</td>
                  <td>
                    <div class="d-flex gap-2">
                      <button class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#bookingModal"><i class="fas fa-eye"></i> View</button>
                      <button class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#acceptModal"><i class="fas fa-check"></i> Accept</button>
                      <button class="btn btn-outline-danger btn-sm" data-bs-toggle="modal" data-bs-target="#declineModal"><i class="fas fa-times"></i> Decline</button>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td>BK002</td>
                  <td>
                    <div>Sarah Johnson</div>
                    <small class="text-muted">sarah.johnson@email.com</small>
                  </td>
                  <td>
                    <div>Honda Civic</div>
                    <small class="text-muted">XYZ-789</small>
                  </td>
                  <td>Nov 21, 2025</td>
                  <td>Nov 24, 2025</td>
                  <td><span class="badge badge-accepted"><i class="fas fa-check-circle me-1"></i>accepted</span></td>
                  <td>$180</td>
                  <td>
                    <div class="d-flex gap-2">
                      <button class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#bookingModal"><i class="fas fa-eye"></i> View</button>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td>BK003</td>
                  <td>
                    <div>Mike Wilson</div>
                    <small class="text-muted">mike.wilson@email.com</small>
                  </td>
                  <td>
                    <div>BMW X5</div>
                    <small class="text-muted">DEF-456</small>
                  </td>
                  <td>Nov 22, 2025</td>
                  <td>Nov 26, 2025</td>
                  <td><span class="badge badge-pending"><i class="fas fa-clock me-1"></i>pending</span></td>
                  <td>$450</td>
                  <td>
                    <div class="d-flex gap-2">
                      <button class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#bookingModal"><i class="fas fa-eye"></i> View</button>
                      <button class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#acceptModal"><i class="fas fa-check"></i> Accept</button>
                      <button class="btn btn-outline-danger btn-sm" data-bs-toggle="modal" data-bs-target="#declineModal"><i class="fas fa-times"></i> Decline</button>
                    </div>
                  </td>
                </tr>
                <tr>
                  <td>BK004</td>
                  <td>
                    <div>Emily Davis</div>
                    <small class="text-muted">emily.davis@email.com</small>
                  </td>
                  <td>
                    <div>Nissan Altima</div>
                    <small class="text-muted">GHI-012</small>
                  </td>
                  <td>Nov 23, 2025</td>
                  <td>Nov 27, 2025</td>
                  <td><span class="badge badge-rejected"><i class="fas fa-times-circle me-1"></i>rejected</span></td>
                  <td>$200</td>
                  <td>
                    <div class="d-flex gap-2">
                      <button class="btn btn-outline-secondary btn-sm" data-bs-toggle="modal" data-bs-target="#bookingModal"><i class="fas fa-eye"></i> View</button>
                    </div>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </section>

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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<script type="text/javascript">
        var gk_isXlsx = false;
        var gk_xlsxFileLookup = {};
        var gk_fileData = {};
        function filledCell(cell) {
          return cell !== '' && cell != null;
        }
        function loadFileData(filename) {
        if (gk_isXlsx && gk_xlsxFileLookup[filename]) {
            try {
                var workbook = XLSX.read(gk_fileData[filename], { type: 'base64' });
                var firstSheetName = workbook.SheetNames[0];
                var worksheet = workbook.Sheets[firstSheetName];
                // Convert sheet to JSON to filter blank rows
                var jsonData = XLSX.utils.sheet_to_json(worksheet, { header: 1, blankrows: false, defval: '' });
                // Filter out blank rows (rows where all cells are empty, null, or undefined)
                var filteredData = jsonData.filter(row => row.some(filledCell));
                // Heuristic to find the header row by ignoring rows with fewer filled cells than the next row
                var headerRowIndex = filteredData.findIndex((row, index) =>
                  row.filter(filledCell).length >= filteredData[index + 1]?.filter(filledCell).length
                );
                // Fallback
                if (headerRowIndex === -1 || headerRowIndex > 25) {
                  headerRowIndex = 0;
                }
                // Convert filtered JSON back to CSV
                var csv = XLSX.utils.aoa_to_sheet(filteredData.slice(headerRowIndex)); // Create a new sheet from filtered array of arrays
                csv = XLSX.utils.sheet_to_csv(csv, { header: 1 });
                return csv;
            } catch (e) {
                console.error(e);
                return "";
            }
        }
        return gk_fileData[filename] || "";
        }
        </script>