<%-- Document : car-condition.jsp Created on : Jun 1, 2025, 11:00:54 AM Author :
ACER --%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AutoRental - Car Condition</title>
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
      href="${pageContext.request.contextPath}/styles/staff/staff-car-condition.css"
    />
    <!-- Notification CSS -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/styles/staff/staff-notification.css"
    />
  </head>
  <body>
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
            <a class="nav-link active" href="${pageContext.request.contextPath}/pages/staff/staff-car-condition.jsp">
              <i class="fas fa-car"></i> Car Condition
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/pages/staff/staff-car-availability.jsp">
              <i class="fas fa-clipboard-list"></i> Car Availability
            </a>
          </li>
          <!-- <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/pages/staff/staff-damage-reports.jsp">
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
              <h4 class="mb-0 fw-bold">Car Condition Report</h4>
              <small class="text-muted"
                >Inspect and report vehicle condition after customer
                returns</small
              >
            </div>

            <!-- Right: Notifications and User -->
            <%@ include file="/pages/includes/staff-header.jsp" %>
          </div>
        </div>
      </header>

      <!-- Car Condition Section -->
      <section id="car-condition" class="section">
        <!-- Recently Completed Inspections -->
        <div class="card mb-4">
          <div
            class="card-header d-flex justify-content-between align-items-center"
          >
            <div>
              <h5 class="card-title mb-0">Recent Inspections</h5>
              <small class="text-muted"
                >Last 5 completed vehicle inspections</small
              >
            </div>
            <div class="d-flex align-items-center gap-2">
              <select class="form-select form-select-sm" style="width: auto">
                <option value="all">All Status</option>
                <option value="pending">Pending Inspection</option>
                <option value="completed">Completed</option>
                <option value="issues">Issues Found</option>
              </select>
              <div class="input-group" style="width: 300px">
                <span class="input-group-text"
                  ><i class="fas fa-search"></i
                ></span>
                <input
                  type="text"
                  class="form-control form-control-sm"
                  placeholder="Search by rental ID, vehicle, or license plate..."
                />
              </div>
              <button class="btn btn-primary btn-sm">
                <i class="fas fa-filter me-1"></i>Filter Results
              </button>
            </div>
          </div>
          <div class="card-body">
            <div class="table-responsive">
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
                    <td class="inspection-date">Nov 15, 2025</td>
                    <td>
                      <span class="condition-badge normal">Normal</span>
                    </td>
                    <td class="inspector-name">John Staff</td>
                    <td class="inspection-notes">
                      Vehicle returned in excellent condition
                    </td>
                    <td>
                      <button
                        class="btn btn-outline-secondary btn-sm action-btn"
                      >
                        <i class="fas fa-eye"></i>
                        View
                      </button>
                    </td>
                  </tr>
                  <tr>
                    <td class="rental-id">RNT-0994</td>
                    <td class="vehicle-name">Hyundai Sonata</td>
                    <td class="license-plate">PQR-901</td>
                    <td class="inspection-date">Nov 15, 2025</td>
                    <td>
                      <span class="condition-badge needs-cleaning"
                        >Needs Cleaning</span
                      >
                    </td>
                    <td class="inspector-name">John Staff</td>
                    <td class="inspection-notes">
                      Interior needs cleaning, food stains on seats
                    </td>
                    <td>
                      <button
                        class="btn btn-outline-secondary btn-sm action-btn"
                      >
                        <i class="fas fa-eye"></i>
                        View
                      </button>
                    </td>
                  </tr>
                  <tr>
                    <td class="rental-id">RNT-0993</td>
                    <td class="vehicle-name">Chevrolet Malibu</td>
                    <td class="license-plate">STU-234</td>
                    <td class="inspection-date">Nov 14, 2025</td>
                    <td>
                      <span class="condition-badge minor-scratches"
                        >Minor Scratches</span
                      >
                    </td>
                    <td class="inspector-name">Sarah Admin</td>
                    <td class="inspection-notes">
                      Small scratch on rear bumper, otherwise good
                    </td>
                    <td>
                      <button
                        class="btn btn-outline-secondary btn-sm action-btn"
                      >
                        <i class="fas fa-eye"></i>
                        View
                      </button>
                    </td>
                  </tr>
                  <tr>
                    <td class="rental-id">RNT-0992</td>
                    <td class="vehicle-name">Kia Sportage</td>
                    <td class="license-plate">VWX-567</td>
                    <td class="inspection-date">Nov 14, 2025</td>
                    <td>
                      <span class="condition-badge normal">Normal</span>
                    </td>
                    <td class="inspector-name">Sarah Admin</td>
                    <td class="inspection-notes">No issues found</td>
                    <td>
                      <button
                        class="btn btn-outline-secondary btn-sm action-btn"
                      >
                        <i class="fas fa-eye"></i>
                        View
                      </button>
                    </td>
                  </tr>
                  <tr>
                    <td class="rental-id">RNT-0991</td>
                    <td class="vehicle-name">Mazda CX-5</td>
                    <td class="license-plate">YZA-890</td>
                    <td class="inspection-date">Nov 13, 2025</td>
                    <td>
                      <span class="condition-badge major-damage"
                        >Major Damage</span
                      >
                    </td>
                    <td class="inspector-name">Mike Inspector</td>
                    <td class="inspection-notes">
                      Large dent on driver side door, requires repair
                    </td>
                    <td>
                      <button
                        class="btn btn-outline-secondary btn-sm action-btn"
                      >
                        <i class="fas fa-eye"></i>
                        View
                      </button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- Pending Inspections Section -->
        <div class="card">
          <div
            class="card-header d-flex justify-content-between align-items-center"
          >
            <div>
              <h5 class="card-title mb-0">Pending Inspections</h5>
              <small class="text-muted"
                >Vehicles awaiting inspection after return</small
              >
            </div>
            <div class="d-flex align-items-center gap-2">
              <select class="form-select form-select-sm" style="width: auto">
                <option value="all">All Status</option>
                <option value="pending">Pending Inspection</option>
                <option value="completed">Completed</option>
                <option value="issues">Issues Found</option>
              </select>
              <div class="input-group" style="width: 300px">
                <span class="input-group-text"
                  ><i class="fas fa-search"></i
                ></span>
                <input
                  type="text"
                  class="form-control form-control-sm"
                  placeholder="Search by rental ID, customer, or vehicle..."
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
                    <th>Rental ID</th>
                    <th>Vehicle</th>
                    <th>Customer</th>
                    <th>Return Date</th>
                    <th>Previous Condition</th>
                    <th>Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td class="rental-id">RNT-1001</td>
                    <td class="vehicle-name">Toyota Camry 2023</td>
                    <td class="customer-name">John Smith</td>
                    <td class="return-date">Nov 20, 2025</td>
                    <td>
                      <span class="condition-badge normal">Good</span>
                    </td>
                    <td>
                      <span class="status-badge pending"
                        >Pending Inspection</span
                      >
                    </td>
                    <td>
                      <button
                        class="btn btn-primary btn-sm"
                        data-bs-toggle="modal"
                        data-bs-target="#inspectionModal"
                      >
                        <i class="fas fa-search me-1"></i>Inspect Vehicle
                      </button>
                    </td>
                  </tr>
                  <tr>
                    <td class="rental-id">RNT-1002</td>
                    <td class="vehicle-name">Honda Civic 2022</td>
                    <td class="customer-name">Sarah Johnson</td>
                    <td class="return-date">Nov 19, 2025</td>
                    <td>
                      <span class="condition-badge needs-cleaning">Normal</span>
                    </td>
                    <td>
                      <span class="status-badge pending"
                        >Pending Inspection</span
                      >
                    </td>
                    <td>
                      <button
                        class="btn btn-primary btn-sm"
                        data-bs-toggle="modal"
                        data-bs-target="#inspectionModal"
                      >
                        <i class="fas fa-search me-1"></i>Inspect Vehicle
                      </button>
                    </td>
                  </tr>
                  <tr>
                    <td class="rental-id">RNT-1003</td>
                    <td class="vehicle-name">BMW X5 2021</td>
                    <td class="customer-name">Mike Wilson</td>
                    <td class="return-date">Nov 18, 2025</td>
                    <td>
                      <span class="condition-badge normal">Good</span>
                    </td>
                    <td>
                      <span class="status-badge pending"
                        >Pending Inspection</span
                      >
                    </td>
                    <td>
                      <button
                        class="btn btn-primary btn-sm"
                        data-bs-toggle="modal"
                        data-bs-target="#inspectionModal"
                      >
                        <i class="fas fa-search me-1"></i>Inspect Vehicle
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

    <!-- Inspection Modal -->
    <div
      class="modal fade"
      id="inspectionModal"
      tabindex="-1"
      aria-labelledby="inspectionModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-xl">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="inspectionModalLabel">
              <i class="fas fa-clipboard-check me-2"></i>
              Vehicle Inspection Form
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
                  <label>Rental ID:</label>
                  <span>RNT-1001</span>
                </div>
                <div class="info-item">
                  <label>Vehicle:</label>
                  <span>Toyota Camry 2023</span>
                </div>
                <div class="info-item">
                  <label>License Plate:</label>
                  <span>ABC-123</span>
                </div>
                <div class="info-item">
                  <label>Customer:</label>
                  <span>John Smith</span>
                </div>
                <div class="info-item">
                  <label>Return Date:</label>
                  <span>Nov 20, 2025</span>
                </div>
                <div class="info-item">
                  <label>Mileage:</label>
                  <span>15,240 km</span>
                </div>
              </div>
            </div>

            <!-- Overall Condition -->
            <div class="inspection-section">
              <h6 class="section-title">
                <i class="fas fa-clipboard-list me-2"></i>Overall Condition
              </h6>
              <div class="row">
                <div class="col-md-6">
                  <label class="form-label">General Condition *</label>
                  <select class="form-select" required>
                    <option value="">Select condition</option>
                    <option value="clean">Clean</option>
                    <option value="dirty">Dirty</option>
                    <option value="smelly">Odor present</option>
                    <option value="minor-scratch">Minor scratches</option>
                    <option value="dent">Dents</option>
                    <option value="fuel-shortage">Low fuel</option>
                    <option value="broken-light">Broken lights</option>
                  </select>
                </div>
                <div class="col-md-6">
                  <label class="form-label">Fuel Level</label>
                  <select class="form-select">
                    <option value="">Select fuel level</option>
                    <option value="full">Full</option>
                    <option value="3/4">3/4</option>
                    <option value="1/2">1/2</option>
                    <option value="1/4">1/4</option>
                    <option value="empty">Empty</option>
                  </select>
                </div>
              </div>
            </div>

            <!-- Interior Condition -->
            <div class="inspection-section">
              <h6 class="section-title">
                <i class="fas fa-couch me-2"></i>Interior Condition
              </h6>
              <div class="checkbox-grid">
                <div class="form-check">
                  <input
                    class="form-check-input"
                    type="checkbox"
                    id="torn-seat"
                  />
                  <label class="form-check-label" for="torn-seat"
                    >Torn seats</label
                  >
                </div>
                <div class="form-check">
                  <input class="form-check-input" type="checkbox" id="dusty" />
                  <label class="form-check-label" for="dusty"
                    >Dusty/dirty</label
                  >
                </div>
                <div class="form-check">
                  <input
                    class="form-check-input"
                    type="checkbox"
                    id="missing-accessories"
                  />
                  <label class="form-check-label" for="missing-accessories"
                    >Missing accessories</label
                  >
                </div>
                <div class="form-check">
                  <input
                    class="form-check-input"
                    type="checkbox"
                    id="cracked-mirror"
                  />
                  <label class="form-check-label" for="cracked-mirror"
                    >Cracked mirror</label
                  >
                </div>
                <div class="form-check">
                  <input
                    class="form-check-input"
                    type="checkbox"
                    id="broken-ac"
                  />
                  <label class="form-check-label" for="broken-ac"
                    >Broken A/C</label
                  >
                </div>
                <div class="form-check">
                  <input
                    class="form-check-input"
                    type="checkbox"
                    id="cigarette-smell"
                  />
                  <label class="form-check-label" for="cigarette-smell"
                    >Cigarette smell</label
                  >
                </div>
              </div>
            </div>

            <!-- Photo Upload -->
            <div class="inspection-section">
              <h6 class="section-title">
                <i class="fas fa-camera me-2"></i>Evidence Photos
              </h6>
              <div class="upload-area">
                <input
                  type="file"
                  class="form-control"
                  accept=".jpg,.jpeg,.png"
                  multiple
                />
                <div class="upload-placeholder">
                  <i class="fas fa-cloud-upload-alt"></i>
                  <p>Upload damage photos (JPG, PNG)</p>
                  <small>Maximum 10 files, 5MB each</small>
                </div>
              </div>
            </div>

            <!-- Additional Notes -->
            <div class="inspection-section">
              <h6 class="section-title">
                <i class="fas fa-sticky-note me-2"></i>Additional Notes
              </h6>
              <textarea
                class="form-control"
                rows="4"
                placeholder="Enter additional notes or observations..."
              ></textarea>
            </div>

            <!-- Issue Classification -->
            <div class="inspection-section">
              <h6 class="section-title">
                <i class="fas fa-exclamation-triangle me-2"></i>Issue
                Classification
              </h6>
              <div class="classification-options">
                <div class="form-check">
                  <input
                    class="form-check-input"
                    type="radio"
                    name="issueLevel"
                    id="minor"
                    value="minor"
                  />
                  <label
                    class="form-check-label classification-minor"
                    for="minor"
                  >
                    <i class="fas fa-info-circle"></i>
                    <span>Minor</span>
                  </label>
                </div>
                <div class="form-check">
                  <input
                    class="form-check-input"
                    type="radio"
                    name="issueLevel"
                    id="serious"
                    value="serious"
                  />
                  <label
                    class="form-check-label classification-serious"
                    for="serious"
                  >
                    <i class="fas fa-exclamation-triangle"></i>
                    <span>Serious</span>
                  </label>
                </div>
                <div class="form-check">
                  <input
                    class="form-check-input"
                    type="radio"
                    name="issueLevel"
                    id="urgent"
                    value="urgent"
                  />
                  <label
                    class="form-check-label classification-urgent"
                    for="urgent"
                  >
                    <i class="fas fa-tools"></i>
                    <span>Urgent maintenance required</span>
                  </label>
                </div>
              </div>
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
            <button type="button" class="btn btn-success">
              <i class="fas fa-paper-plane me-1"></i>Submit Report
            </button>
            <button type="button" class="btn btn-primary">
              <i class="fas fa-sync me-1"></i>Update Status
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
