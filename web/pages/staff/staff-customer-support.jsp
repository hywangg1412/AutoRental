<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AutoRental - Customer Support</title>
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
      href="${pageContext.request.contextPath}/styles/staff/staff-customer-support.css"
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
            <a class="nav-link" href="${pageContext.request.contextPath}/pages/staff/staff-damage-reports.jsp">
              <i class="fas fa-shield-alt"></i> Damage Reports
            </a>
          </li> -->
          <li class="nav-item">
            <a class="nav-link active" href="${pageContext.request.contextPath}/pages/staff/staff-customer-support.jsp">
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
              <h4 class="mb-0 fw-bold">Customer Feedback</h4>
              <small class="text-muted"
                >Manage customer reviews and support requests</small
              >
            </div>

            <!-- Right: Notifications and User -->
            <%@ include file="/pages/includes/staff-header.jsp" %>
          </div>
        </div>
      </header>

      <!-- Customer Support Section -->
      <section id="customer-support" class="section">
        <!-- Customer Ratings Section -->
        <div class="card mb-4">
          <div
            class="card-header d-flex justify-content-between align-items-center"
          >
            <div>
              <h5 class="card-title mb-0">Customer Reviews</h5>
              <small class="text-muted"
                >View and respond to customer feedback</small
              >
            </div>
            <div class="d-flex align-items-center gap-2">
              <div class="input-group" style="width: 300px">
                <span class="input-group-text"
                  ><i class="fas fa-search"></i
                ></span>
                <input
                  type="text"
                  class="form-control form-control-sm"
                  placeholder="Search by customer name or review content..."
                />
              </div>
              <select class="form-select form-select-sm" style="width: auto">
                <option value="all">All Reviews</option>
                <option value="responded">Responded</option>
                <option value="pending">Pending Response</option>
              </select>
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
                    <td class="comment">
                      Great service, clean car, friendly staff.
                    </td>
                    <td>May 30, 2025</td>
                    <td>
                      <span class="status-badge badge-success">Responded</span>
                    </td>
                    <td>
                      <button
                        class="btn btn-primary btn-sm"
                        data-bs-toggle="modal"
                        data-bs-target="#replyModal"
                      >
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
                    <td class="comment">
                      Car was okay but pickup was a bit slow.
                    </td>
                    <td>May 29, 2025</td>
                    <td>
                      <span class="status-badge badge-warning"
                        >Pending Response</span
                      >
                    </td>
                    <td>
                      <button
                        class="btn btn-primary btn-sm"
                        data-bs-toggle="modal"
                        data-bs-target="#replyModal"
                      >
                        <i class="fas fa-reply me-1"></i>Reply
                      </button>
                    </td>
                  </tr>
                  <tr>
                    <td>3</td>
                    <td class="customer-name">Mike Wilson</td>
                    <td class="vehicle-name">Tesla Model 3</td>
                    <td class="rating">
                      <i class="fas fa-star text-warning"></i>
                      <i class="fas fa-star text-warning"></i>
                      <i class="fas fa-star text-warning"></i>
                      <i class="fas fa-star text-warning"></i>
                      <i class="far fa-star text-warning"></i>
                    </td>
                    <td class="comment">
                      Modern car, but need clearer usage instructions.
                    </td>
                    <td>May 28, 2025</td>
                    <td>
                      <span class="status-badge badge-warning"
                        >Pending Response</span
                      >
                    </td>
                    <td>
                      <button
                        class="btn btn-primary btn-sm"
                        data-bs-toggle="modal"
                        data-bs-target="#replyModal"
                      >
                        <i class="fas fa-reply me-1"></i>Reply
                      </button>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- Live Chat Support Section -->
        <div class="card">
          <div class="card-header">
            <h5 class="card-title mb-0">Live Chat Support</h5>
            <small class="text-muted"
              >Direct contact with customers for issue resolution</small
            >
          </div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Customer Name</th>
                    <th>Support Request</th>
                    <th>Date</th>
                    <th>Contact</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>1</td>
                    <td class="customer-name">Alice Brown</td>
                    <td class="support-request">Did not receive contract</td>
                    <td>May 30, 2025</td>
                    <td>
                      <a
                        href="https://zalo.me/0123456789"
                        class="btn btn-success btn-sm"
                        data-bs-toggle="tooltip"
                        data-bs-placement="top"
                        title="Chat with customer on Zalo"
                      >
                        <i class="fas fa-comment-dots me-1"></i>Zalo
                      </a>
                    </td>
                  </tr>
                  <tr>
                    <td>2</td>
                    <td class="customer-name">Bob Green</td>
                    <td class="support-request">
                      Need help changing rental time
                    </td>
                    <td>May 29, 2025</td>
                    <td>
                      <a
                        href="https://zalo.me/0987654321"
                        class="btn btn-success btn-sm"
                        data-bs-toggle="tooltip"
                        data-bs-placement="top"
                        title="Chat with customer on Zalo"
                      >
                        <i class="fas fa-comment-dots me-1"></i>Zalo
                      </a>
                    </td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </section>
    </div>

    <!-- Reply Modal -->
    <div
      class="modal fade"
      id="replyModal"
      tabindex="-1"
      aria-labelledby="replyModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="replyModalLabel">
              <i class="fas fa-reply me-2"></i>Reply to Review
            </h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <!-- Original Comment -->
            <div class="inspection-section">
              <h6 class="section-title">
                <i class="fas fa-comment me-2"></i>Review Information
              </h6>
              <div class="comment-info">
                <p><strong>Customer:</strong> John Smith</p>
                <p><strong>Rented Vehicle:</strong> Toyota Camry 2023</p>
                <p>
                  <strong>Rating:</strong>
                  <i class="fas fa-star text-warning"></i>
                  <i class="fas fa-star text-warning"></i>
                  <i class="fas fa-star text-warning"></i>
                  <i class="fas fa-star text-warning"></i>
                  <i class="fas fa-star text-warning"></i>
                </p>
                <p>
                  <strong>Content:</strong> Great service, clean car, friendly
                  staff.
                </p>
                <p><strong>Date:</strong> May 30, 2025</p>
              </div>
            </div>

            <!-- Reply Form -->
            <div class="inspection-section">
              <h6 class="section-title">
                <i class="fas fa-pen me-2"></i>Reply Content
              </h6>
              <form action="/api/reply-comment" method="post">
                <input type="hidden" name="commentId" value="CMT-001" />
                <textarea
                  class="form-control"
                  name="replyContent"
                  rows="5"
                  placeholder="Enter your reply..."
                  required
                ></textarea>
                <div class="mt-3 text-end">
                  <button type="submit" class="btn btn-primary">
                    <i class="fas fa-paper-plane me-1"></i>Send Reply
                  </button>
                </div>
              </form>
            </div>
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
