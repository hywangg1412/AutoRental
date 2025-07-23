<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AutoRental - Car Availability</title>
    <!-- Bootstrap 5 CSS -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <!-- Font Awesome -->
    <link
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
      rel="stylesheet"
    />
    <!-- Custom CSS -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/styles/staff/staff-car-availability.css"
    />
    <!-- Notification CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/staff/staff-notification.css">
  </head>
  <body>
    <div class="dashboard-container">
      <!-- Sidebar -->
      <div class="sidebar">
        <div class="p-4 border-bottom">
          <div class="d-flex align-items-center gap-2">
            <div
              class="bg-primary text-white rounded d-flex align-items-center justify-content-center"
              style="width: 32px; height: 32px"
            >
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
              <a class="nav-link" href="${pageContext.request.contextPath}/staff/dashboard">
                <i class="fas fa-home"></i> Dashboard
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/staff/booking-approval-list">
                <i class="fas fa-calendar"></i> Booking Requests
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/staff/car-condition">
                <i class="fas fa-car"></i> Car Condition
              </a>
            </li>
            <li class="nav-item">
              <a class="nav-link active" href="${pageContext.request.contextPath}/pages/staff/staff-car-availability.jsp">
                <i class="fas fa-clipboard-list"></i> Car Availability
              </a>
            </li>
            <!-- <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/pages/staff/staff-damage-reports.jsp">
                <i class="fas fa-shield-alt"></i> Damage Reports
              </a>
            </li> -->
            <li class="nav-item">
                        <a class="nav-link" href="${pageContext.request.contextPath}/staff/feedback-reply">
                <i class="fas fa-comment"></i> Customer Feedback
              </a>
            </li>
            <!-- <li class="nav-item">
              <a class="nav-link" href="${pageContext.request.contextPath}/pages/staff/staff-profile.jsp">
                <i class="fas fa-users"></i> Profile
              </a>
            </li> -->
          </ul>
          <hr />
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
        <!-- New Header Design -->
        <header class="header bg-white border-bottom shadow-sm">
          <div class="container-fluid px-4 py-3">
            <div class="row align-items-center">
              <!-- Left: Page Title -->
              <div class="col text-start">
                <h4 class="mb-0 fw-bold">Car Availability</h4>
                <small class="text-muted"
                  >Monitor and update vehicle availability status</small
                >
              </div>

              <!-- Right: Notifications and User -->
              <%@ include file="/pages/includes/staff-header.jsp" %>
            </div>
          </div>
        </header>

        <!-- Car Availability Section -->
        <section id="car-availability" class="section">
          <!-- Vehicle Availability Table -->
          <div class="card">
            <div
              class="card-header d-flex justify-content-between align-items-center"
            >
              <div>
                <h5 class="card-title mb-0">Vehicle List</h5>
                <small class="text-muted"
                  >Current status of all vehicles in the system</small
                >
              </div>
              <div class="d-flex align-items-center gap-2">
                <select class="form-select form-select-sm" style="width: auto">
                  <option value="all">All Status</option>
                  <option value="available">Available</option>
                  <option value="rented">Rented</option>
                  <option value="maintenance">Maintenance</option>
                </select>
                <select class="form-select form-select-sm" style="width: auto">
                  <option value="all">All Vehicle Types</option>
                  <option value="sedan">Sedan</option>
                  <option value="suv">SUV</option>
                  <option value="truck">Truck</option>
                </select>
                <div class="input-group" style="width: 300px">
                  <span class="input-group-text"
                    ><i class="fas fa-search"></i
                  ></span>
                  <input
                    type="text"
                    class="form-control form-control-sm"
                    placeholder="Search by Model, License Plate, or Brand..."
                  />
                </div>
                <button class="btn btn-primary btn-sm">
                  <i class="fas fa-filter me-1"></i>Filter
                </button>
              </div>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table">
                  <thead>
                    <tr>
                      <th>ID</th>
                      <th>Model</th>
                      <th>License Plate</th>
                      <th>Status</th>
                      <th>Current Renter</th>
                      <th>Available Again</th>
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
                        <span class="status-badge badge-success"
                          >Available</span
                        >
                      </td>
                      <td>-</td>
                      <td>-</td>
                      <td>-</td>
                      <td class="notes">Vehicle inspected and ready for use</td>
                      <td>
                        <button
                          class="btn btn-primary btn-sm"
                          data-bs-toggle="modal"
                          data-bs-target="#updateModal"
                        >
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
                      <td>12:00 Jun 3, 2025</td>
                      <td class="late-fee">$50.00</td>
                      <td class="notes">2 hours late for return</td>
                      <td>
                        <div class="d-flex gap-2">
                          <button
                            class="btn btn-primary btn-sm"
                            data-bs-toggle="modal"
                            data-bs-target="#updateModal"
                          >
                            <i class="fas fa-edit me-1"></i>Update
                          </button>
                          <button
                            class="btn btn-success btn-sm"
                            data-bs-toggle="modal"
                            data-bs-target="#confirmReturnModal"
                          >
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
                        <span class="status-badge badge-danger"
                          >Maintenance</span
                        >
                      </td>
                      <td>-</td>
                      <td>2 days remaining</td>
                      <td>-</td>
                      <td class="notes">Tire replacement and engine check</td>
                      <td>
                        <button
                          class="btn btn-primary btn-sm"
                          data-bs-toggle="modal"
                          data-bs-target="#updateModal"
                        >
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
                      <td>2:00 PM May 31, 2025</td>
                      <td>-</td>
                      <td class="notes">Being cleaned, ready in 2 hours</td>
                      <td>
                        <button
                          class="btn btn-primary btn-sm"
                          data-bs-toggle="modal"
                          data-bs-target="#updateModal"
                        >
                          <i class="fas fa-edit me-1"></i>Update
                        </button>
                      </td>
                    </tr>
                    <tr>
                      <td>5</td>
                      <td class="vehicle-name">Ford Ranger 2022</td>
                      <td class="license-plate">JKL-345</td>
                      <td>
                        <span class="status-badge badge-success"
                          >Available</span
                        >
                      </td>
                      <td>-</td>
                      <td>-</td>
                      <td>-</td>
                      <td class="notes">Recently inspected, full fuel tank</td>
                      <td>
                        <button
                          class="btn btn-primary btn-sm"
                          data-bs-toggle="modal"
                          data-bs-target="#updateModal"
                        >
                          <i class="fas fa-edit me-1"></i>Update
                        </button>
                      </td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>

    <!-- Update Status Modal -->
    <div
      class="modal fade"
      id="updateModal"
      tabindex="-1"
      aria-labelledby="updateModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="updateModalLabel">
              <i class="fas fa-clipboard-check me-2"></i>
              Update Vehicle Status
            </h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <!-- Vehicle Information -->
            <div class="inspection-section">
              <h6 class="section-title">
                <i class="fas fa-info-circle me-2"></i>Vehicle Information
              </h6>
              <div class="vehicle-info-grid">
                <div class="info-item">
                  <label>Model:</label>
                  <span>Toyota Camry 2023</span>
                </div>
                <div class="info-item">
                  <label>License Plate:</label>
                  <span>ABC-123</span>
                </div>
                <div class="info-item">
                  <label>Vehicle Type:</label>
                  <span>Sedan</span>
                </div>
              </div>
            </div>

            <!-- Update Status -->
            <div class="inspection-section">
              <h6 class="section-title">
                <i class="fas fa-cog me-2"></i>Update Status
              </h6>
              <div class="row">
                <div class="col-md-6">
                  <label class="form-label">Status *</label>
                  <select class="form-select" required>
                    <option value="">Select status</option>
                    <option value="ready">Available</option>
                    <option value="rented">Rented</option>
                    <option value="maintenance">Maintenance</option>
                    <option value="soon">Coming Soon</option>
                  </select>
                </div>
                <div class="col-md-6">
                  <label class="form-label">Available Again</label>
                  <input type="datetime-local" class="form-control" />
                </div>
              </div>
            </div>

            <!-- Notes -->
            <div class="inspection-section">
              <h6 class="section-title">
                <i class="fas fa-sticky-note me-2"></i>Notes
              </h6>
              <textarea
                class="form-control"
                rows="4"
                placeholder="Enter notes about vehicle status..."
              ></textarea>
            </div>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Cancel
            </button>
            <button type="button" class="btn btn-primary">
              <i class="fas fa-save me-1"></i>Save Changes
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Confirm Return Modal -->
    <div
      class="modal fade"
      id="confirmReturnModal"
      tabindex="-1"
      aria-labelledby="confirmReturnModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="confirmReturnModalLabel">
              <i class="fas fa-check-circle me-2"></i>Confirm Vehicle Return
            </h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <form action="/api/confirm-return" method="post">
              <input type="hidden" name="bookingId" value="RNT-1002" />
              <p>
                Confirm that <strong>Honda Civic 2022 (XYZ-789)</strong> has
                been returned by <strong>John Smith</strong>.
              </p>
              <p><strong>Late Fee:</strong> $50.00 (2 hours late)</p>
              <div class="mb-3">
                <label for="confirm-notes" class="form-label"
                  >Notes (Optional)</label
                >
                <textarea
                  class="form-control"
                  id="confirm-notes"
                  name="notes"
                  rows="3"
                  placeholder="Enter notes if any..."
                ></textarea>
              </div>
              <div class="modal-footer">
                <button
                  type="button"
                  class="btn btn-secondary"
                  data-bs-dismiss="modal"
                >
                  Cancel
                </button>
                <button type="submit" class="btn btn-success">
                  <i class="fas fa-check me-1"></i>Confirm
                </button>
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>

<script type="text/javascript">
  var gk_isXlsx = false;
  var gk_xlsxFileLookup = {};
  var gk_fileData = {};
  function filledCell(cell) {
    return cell !== "" && cell != null;
  }
  function loadFileData(filename) {
    if (gk_isXlsx && gk_xlsxFileLookup[filename]) {
      try {
        var workbook = XLSX.read(gk_fileData[filename], { type: "base64" });
        var firstSheetName = workbook.SheetNames[0];
        var worksheet = workbook.Sheets[firstSheetName];

        // Convert sheet to JSON to filter blank rows
        var jsonData = XLSX.utils.sheet_to_json(worksheet, {
          header: 1,
          blankrows: false,
          defval: "",
        });
        // Filter out blank rows (rows where all cells are empty, null, or undefined)
        var filteredData = jsonData.filter((row) => row.some(filledCell));
        // Heuristic to find the header row by ignoring rows with fewer filled cells than the next row
        var headerRowIndex = filteredData.findIndex(
          (row, index) =>
            row.filter(filledCell).length >=
            filteredData[index + 1]?.filter(filledCell).length
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
