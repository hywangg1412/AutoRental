<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!DOCTYPE html>
<html>
    <head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>AutoRental - Staff Dashboard</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/staff/staff-dashboard.css">
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
          <a class="nav-link active" href="${pageContext.request.contextPath}/pages/staff/staff-dashboard.jsp">
            <i class="fas fa-home"></i> Dashboard
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/staff/booking-approval-list">
            <i class="fas fa-calendar"></i> Booking Requests
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/pages/staff/staff-car-condition.jsp">
            <i class="fas fa-car"></i> Car Condition
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/pages/staff/staff-car-availability.jsp">
            <i class="fas fa-clipboard-list"></i> Car Availability
          </a>
        </li>
        <!-- <li class="nav-item">
          <a class="nav-link" href="#">
            <i class="fas fa-shield-alt"></i> Damage Reports
          </a>
        </li> -->
        <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/pages/staff/staff-customer-support.jsp">
            <i class="fas fa-comment"></i> Customer Feedback
          </a>
        </li>
        <!-- <li class="nav-item">
          <a class="nav-link" href="${pageContext.request.contextPath}/pages/staff/staff-profile.jsp">
            <i class="fas fa-users"></i> Profile
          </a>
        </li> -->
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
    <header class="header">
      <div class="d-flex align-items-center gap-2">
        <button class="btn btn-outline-secondary btn-sm d-lg-none" type="button" data-bs-toggle="collapse" data-bs-target="#sidebarMenu">
          <i class="fas fa-bars"></i>
        </button>
        <div>
          <h4 class="mb-0">Staff Dashboard</h4>
          <small class="text-muted">Welcome back! Here's your overview for today.</small>
        </div>
      </div>
      <%@ include file="/pages/includes/staff-header.jsp" %>
    </header>

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
                    <td><span class="badge badge-pending"><i class="fas fa-clock me-1"></i> pending</span></td>
                    <td>$250</td>
                  </tr>
                  <tr>
                    <td>BK002</td>
                    <td>Sarah Johnson</td>
                    <td>Honda Civic</td>
                    <td><span class="badge badge-accepted"><i class="fas fa-check-circle me-1"></i> accepted</span></td>
                    <td>$180</td>
                  </tr>
                  <tr>
                    <td>BK003</td>
                    <td>Mike Wilson</td>
                    <td>BMW X5</td>
                    <td><span class="badge badge-pending"><i class="fas fa-clock me-1"></i> pending</span></td>
                    <td>$450</td>
                  </tr>
                  <tr>
                    <td>BK004</td>
                    <td>Emily Davis</td>
                    <td>Nissan Altima</td>
                    <td><span class="badge badge-accepted"><i class="fas fa-check-circle me-1"></i> accepted</span></td>
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
                    <td><span class="badge badge-available">available</span></td>
                    <td>Downtown</td>
                  </tr>
                  <tr>
                    <td>XYZ-789</td>
                    <td>Honda Civic</td>
                    <td><span class="badge badge-rented">rented</span></td>
                    <td>Airport</td>
                  </tr>
                  <tr>
                    <td>DEF-456</td>
                    <td>BMW X5</td>
                    <td><span class="badge badge-maintenance">maintenance</span></td>
                    <td>Service Center</td>
                  </tr>
                  <tr>
                    <td>GHI-012</td>
                    <td>Nissan Altima</td>
                    <td><span class="badge badge-available">available</span></td>
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

      <div class="row g-4">
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
                  <span class="badge badge-accepted">approved</span>
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
                  <span class="badge badge-pending">pending</span>
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
                  <span class="badge badge-accepted">approved</span>
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
