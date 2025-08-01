<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/styles/staff/staff-notification.css"
    />
    <style>
      .image-preview-container {
        display: flex;
        flex-wrap: wrap;
        gap: 10px;
        margin-top: 10px;
      }
      .image-preview {
        width: 100px;
        height: 100px;
        object-fit: cover;
        border-radius: 5px;
      }
      .image-preview-item {
        position: relative;
      }
      .remove-image {
        position: absolute;
        top: -5px;
        right: -5px;
        background-color: red;
        color: white;
        border-radius: 50%;
        width: 20px;
        height: 20px;
        text-align: center;
        line-height: 20px;
        cursor: pointer;
      }
    </style>
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
            <a class="nav-link active" href="${pageContext.request.contextPath}/staff/car-condition">
              <i class="fas fa-car"></i> Car Condition
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/pages/staff/staff-car-availability.jsp">
              <i class="fas fa-clipboard-list"></i> Car Availability
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/staff/feedback-reply">
              <i class="fas fa-comment"></i> Customer Feedback
            </a>
          </li>
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
      <!-- Updated Header Design -->
      <header class="header bg-white border-bottom shadow-sm">
        <div class="container-fluid px-4 py-3">
          <div class="row align-items-center">
            <!-- Left: Page Title -->
            <div class="col text-start">
              <h4 class="mb-0 fw-bold">Car Condition Report</h4>
              <small class="text-muted">Inspect and report vehicle condition after customer returns</small>
            </div>
            <!-- Right: Notifications and User -->
            <%@ include file="/pages/includes/staff-header.jsp" %>
          </div>
        </div>
      </header>

      <div class="container-fluid p-4">
        <div class="row mb-4">
          <div class="col-md-6">
            <!-- Pending Inspections Card -->
            <div class="card" style="border-top: 6px solid #10b981;">
              <div class="card-header" style="background-color: #10b981; color: #fff;">
                <h5 class="card-title mb-0">Pending Inspections</h5>
              </div>
              <div class="card-body">
                <div class="table-responsive">
                  <table class="table table-striped table-hover">
                    <thead>
                      <tr>
                        <th>Booking Code</th>
                        <th>Car</th>
                        <th>Customer</th>
                        <th>Return Date</th>
                        <th>Actions</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach items="${pendingInspections}" var="inspection">
                        <tr>
                          <td>${inspection.bookingCode}</td>
                          <td>${inspection.carModel} (${inspection.licensePlate})</td>
                          <td>${inspection.customerName}</td>
                          <td>
                            <fmt:parseDate value="${inspection.returnDateTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                          </td>
                          <td>
                            <button
                              class="btn btn-success btn-sm inspect-btn"
                              data-bs-toggle="modal"
                              data-bs-target="#inspectionModal"
                              data-booking-id="${inspection.bookingId}"
                              data-car-id="${inspection.carId}"
                            >
                              Inspect Vehicle
                            </button>
                          </td>
                        </tr>
                      </c:forEach>
                      <c:if test="${empty pendingInspections}">
                        <tr>
                          <td colspan="5" class="text-center">No pending inspections</td>
                        </tr>
                      </c:if>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>

          <div class="col-md-6">
            <!-- Recent Inspections Card -->
            <div class="card" style="border-top: 6px solid #10b981;">
              <div class="card-header" style="background-color: #10b981; color: #fff;">
                <h5 class="card-title mb-0">Recent Inspections</h5>
              </div>
              <div class="card-body">
                <div class="table-responsive">
                  <table class="table table-striped table-hover">
                    <thead>
                      <tr>
                        <th>Date</th>
                        <th>Type</th>
                        <th>Status</th>
                        <th>Actions</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach items="${recentInspections}" var="log">
                        <tr>
                          <td>
                            <fmt:parseDate value="${log.checkTime}" pattern="yyyy-MM-dd'T'HH:mm" var="parsedDate" type="both" />
                            <fmt:formatDate value="${parsedDate}" pattern="dd/MM/yyyy HH:mm" />
                          </td>
                          <td>${log.checkType}</td>
                          <td>
                            <span class="badge status-badge status-recent" style="background-color: #e5e7eb; color: #6b7280;">
                              ${log.conditionStatus}
                            </span>
                          </td>
                          <td>
                            <button
                              class="btn btn-success btn-sm view-details-btn"
                              data-bs-toggle="modal"
                              data-bs-target="#viewDetailsModal"
                              data-log-id="${log.logId}"
                              data-booking-id="${log.bookingId}"
                              data-check-type="${log.checkType}"
                              data-condition-status="${log.conditionStatus}"
                              data-condition-description="${log.conditionDescription}"
                              data-damage-images="${log.damageImages}"
                              data-note="${log.note}"
                              data-odometer="${log.odometer}"
                              data-fuel-level="${log.fuelLevel}"
                              data-car-model="${log.carModel}"
                              data-license-plate="${log.licensePlate}"
                              data-customer-name="${log.customerName}"
                              data-return-date="${log.returnDateTime}"
                            >
                              View Details
                            </button>
                          </td>
                        </tr>
                      </c:forEach>
                      <c:if test="${empty recentInspections}">
                        <tr>
                          <td colspan="4" class="text-center">No recent inspections</td>
                        </tr>
                      </c:if>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Inspection Modal -->
    <div
      class="modal fade"
      id="inspectionModal"
      tabindex="-1"
      aria-labelledby="inspectionModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="inspectionModalLabel">
              Vehicle Inspection
            </h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <form id="inspectionForm" enctype="multipart/form-data">
              <input type="hidden" id="bookingId" name="bookingId" />
              <input type="hidden" id="carId" name="carId" />
              <input type="hidden" name="action" value="submitInspection" />
              <input type="hidden" name="checkType" value="Return" />

              <div class="row mb-3">
                <div class="col-md-6">
                  <label for="carModel" class="form-label">Car Model</label>
                  <input
                    type="text"
                    class="form-control"
                    id="carModel"
                    readonly
                  />
                </div>
                <div class="col-md-6">
                  <label for="licensePlate" class="form-label">License Plate</label>
                  <input
                    type="text"
                    class="form-control"
                    id="licensePlate"
                    readonly
                  />
                </div>
              </div>

              <div class="row mb-3">
                <div class="col-md-6">
                  <label for="customerName" class="form-label">Customer Name</label>
                  <input
                    type="text"
                    class="form-control"
                    id="customerName"
                    readonly
                  />
                </div>
                <div class="col-md-6">
                  <label for="returnDate" class="form-label">Return Date</label>
                  <input
                    type="text"
                    class="form-control"
                    id="returnDate"
                    readonly
                  />
                </div>
              </div>

              <div class="row mb-3">
                <div class="col-md-6">
                  <label for="fuelLevel" class="form-label">Fuel Level</label>
                  <select class="form-select" id="fuelLevel" name="fuelLevel" required>
                    <option value="">Select fuel level</option>
                    <option value="Empty">Empty</option>
                    <option value="1/4">1/4</option>
                    <option value="Half">Half</option>
                    <option value="3/4">3/4</option>
                    <option value="Full">Full</option>
                  </select>
                </div>
                <div class="col-md-6">
                  <label for="conditionStatus" class="form-label">Condition Status</label>
                  <select
                    class="form-select"
                    id="conditionStatus"
                    name="conditionStatus"
                    required
                  >
                    <option value="">Select condition status</option>
                    <option value="Good">Good</option>
                    <option value="Need Maintenance">Need Maintenance</option>
                    <option value="Damaged">Damaged</option>
                    <option value="Dirty">Dirty</option>
                    <option value="Other">Other</option>
                    <option value="Flat Tire">Flat Tire</option>
                    <option value="Broken Light">Broken Light</option>
                    <option value="Engine Issue">Engine Issue</option>
                    <option value="Scratch">Scratch</option>
                    <option value="Dented">Dented</option>
                  </select>
                </div>
              </div>

              <div class="mb-3">
                <label for="conditionDescription" class="form-label">
                  Condition Description
                </label>
                <textarea
                  class="form-control"
                  id="conditionDescription"
                  name="conditionDescription"
                  rows="3"
                ></textarea>
              </div>

              <div class="mb-3">
                <label for="damageImages" class="form-label">
                  Damage Images (if any)
                </label>
                <input
                  type="file"
                  class="form-control"
                  id="damageImages"
                  name="damageImages"
                  multiple
                  accept="image/*"
                />
                <div id="imagePreviewContainer" class="image-preview-container mt-2"></div>
              </div>

              <div class="mb-3">
                <label for="note" class="form-label">Note</label>
                <textarea
                  class="form-control"
                  id="note"
                  name="note"
                  rows="2"
                ></textarea>
              </div>
              
              <!-- Surcharges Section -->
              <div class="card mt-4">
                <div class="card-header">
                  <h6 class="mb-0"><i class="bi bi-exclamation-triangle me-2"></i>Surcharges (if applicable)</h6>
                </div>
                <div class="card-body">
                  <!-- Late Return -->
                  <div class="row mb-3">
                    <div class="col-md-6">
                      <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="lateReturn" name="lateReturn" value="true">
                        <label class="form-check-label" for="lateReturn">
                          Late return
                        </label>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <label for="lateReturnHours" class="form-label">Hours late</label>
                      <input type="number" class="form-control" id="lateReturnHours" name="lateReturnHours" min="0" step="0.5" disabled>
                    </div>
                  </div>
                  
                  <!-- Fuel Shortage -->
                  <div class="row mb-3">
                    <div class="col-md-6">
                      <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="fuelShortage" name="fuelShortage" value="true">
                        <label class="form-check-label" for="fuelShortage">
                          Fuel shortage
                        </label>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <label for="fuelPrice" class="form-label">Fuel price (VND)</label>
                      <input type="number" class="form-control" id="fuelPrice" name="fuelPrice" min="0" disabled>
                    </div>
                  </div>
                  
                  <!-- Traffic Violations -->
                  <div class="row mb-3">
                    <div class="col-md-6">
                      <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="trafficViolations" name="trafficViolations" value="true">
                        <label class="form-check-label" for="trafficViolations">
                          Traffic violations
                        </label>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <label for="violationFine" class="form-label">Fine amount (VND)</label>
                      <input type="number" class="form-control" id="violationFine" name="violationFine" min="0" disabled>
                    </div>
                  </div>
                  
                  <!-- Excessive Cleaning -->
                  <div class="row mb-3">
                    <div class="col-md-12">
                      <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="excessiveCleaning" name="excessiveCleaning" value="true">
                        <label class="form-check-label" for="excessiveCleaning">
                          Car cleaning (200,000 VND)
                        </label>
                      </div>
                    </div>
                  </div>
                  
                  <!-- Minor Damage -->
                  <div class="row mb-3">
                    <div class="col-md-6">
                      <div class="form-check">
                        <input class="form-check-input" type="checkbox" id="minorDamage" name="minorDamage" value="true">
                        <label class="form-check-label" for="minorDamage">
                          Minor damage
                        </label>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <label for="damageAmount" class="form-label">Repair cost (VND)</label>
                      <input type="number" class="form-control" id="damageAmount" name="damageAmount" min="100000" max="500000" disabled>
                    </div>
                  </div>
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Close
            </button>
            <button type="button" class="btn btn-success" id="acceptReturnBtn">
              Accept Return Car
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- View Details Modal -->
    <div
      class="modal fade"
      id="viewDetailsModal"
      tabindex="-1"
      aria-labelledby="viewDetailsModalLabel"
      aria-hidden="true"
    >
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="viewDetailsModalLabel">
              Inspection Details
            </h5>
            <button
              type="button"
              class="btn-close"
              data-bs-dismiss="modal"
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <div class="row mb-3">
              <div class="col-md-6">
                <label class="form-label">Car Model</label>
                <p id="viewCarModel" class="form-control-static"></p>
              </div>
              <div class="col-md-6">
                <label class="form-label">License Plate</label>
                <p id="viewLicensePlate" class="form-control-static"></p>
              </div>
            </div>
            <div class="row mb-3">
              <div class="col-md-6">
                <label class="form-label">Customer Name</label>
                <p id="viewCustomerName" class="form-control-static"></p>
              </div>
              <div class="col-md-6">
                <label class="form-label">Return Date</label>
                <p id="viewReturnDate" class="form-control-static"></p>
              </div>
            </div>
            <div class="row mb-3">
              <div class="col-md-6">
                <label class="form-label">Check Type</label>
                <p id="viewCheckType" class="form-control-static"></p>
              </div>
              <div class="col-md-6">
                <label class="form-label">Condition Status</label>
                <p id="viewConditionStatus" class="form-control-static"></p>
              </div>
            </div>
            <div class="row mb-3">
              <div class="col-md-6">
                <label class="form-label">Fuel Level</label>
                <p id="viewFuelLevel" class="form-control-static"></p>
              </div>
            </div>
            <div class="mb-3">
              <label class="form-label">Condition Description</label>
              <p id="viewConditionDescription" class="form-control-static"></p>
            </div>
            <div class="mb-3">
              <label class="form-label">Note</label>
              <p id="viewNote" class="form-control-static"></p>
            </div>
          </div>
          <div class="modal-footer">
            <button
              type="button"
              class="btn btn-secondary"
              data-bs-dismiss="modal"
            >
              Close
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Success Modal -->
    <div class="modal fade" id="successModal" tabindex="-1" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title">Success</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <p id="successMessage">Operation completed successfully.</p>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-primary" data-bs-dismiss="modal" id="successModalCloseBtn">OK</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap 5 JS Bundle with Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/dayjs@1/dayjs.min.js"></script>
    
    <script>
      $(document).ready(function () {
        // Handle event when clicking "Inspect Vehicle" button
        $(".inspect-btn").click(function () {
          const bookingId = $(this).data("booking-id");
          const carId = $(this).data("car-id");
          
          // Set booking ID and car ID into form
          $("#bookingId").val(bookingId);
          $("#carId").val(carId);
          
          // Get detailed booking information
          $.ajax({
            url: "${pageContext.request.contextPath}/staff/car-condition",
            type: "GET",
            data: {
              ajax: "true",
              type: "getBookingDetails",
              bookingId: bookingId
            },
            success: function (response) {
              if (response.success) {
                const data = response.data;
                $("#carModel").val(data.carModel);
                $("#licensePlate").val(data.licensePlate);
                $("#customerName").val(data.customerName);
                $("#returnDate").val(formatDateTime(data.returnDateTime));
              } else {
                alert("Error: " + response.message);
              }
            },
            error: function (xhr, status, error) {
              alert("Error: " + error);
            }
          });
        });
        
        // Handle event when clicking "Accept Return Car" button
        $("#acceptReturnBtn").click(function () {
          const form = $("#inspectionForm")[0];
          const formData = new FormData(form);
          
          // Check required fields
          if (!validateForm()) {
            return;
          }
          
          // Submit form
          $.ajax({
            url: "${pageContext.request.contextPath}/staff/car-condition",
            type: "POST",
            data: formData,
            processData: false,
            contentType: false,
            success: function (response) {
              if (response.success) {
                // Show success message
                $("#successMessage").text("Accept Car Return Successfully");
                $("#successModal").modal("show");
                
                // Close modal and refresh page when clicking OK
                $("#successModalCloseBtn").click(function() {
                  $("#inspectionModal").modal("hide");
                  location.reload();
                });
              } else {
                alert("Error: " + response.message);
              }
            },
            error: function (xhr, status, error) {
              alert("Error: " + error);
            }
          });
        });
        
        // Handle event when clicking "View Details" button
        $(".view-details-btn").click(function () {
          const logId = $(this).data("log-id");
          const bookingId = $(this).data("booking-id");
          const checkType = $(this).data("check-type");
          const conditionStatus = $(this).data("condition-status");
          const conditionDescription = $(this).data("condition-description");
          const note = $(this).data("note");
          const odometer = $(this).data("odometer");
          const fuelLevel = $(this).data("fuel-level");
          
          // Hiển thị thông tin trong modal
          $("#viewCheckType").text(checkType);
          $("#viewConditionStatus").text(conditionStatus);
          $("#viewConditionDescription").text(conditionDescription || "N/A");
          $("#viewNote").text(note || "N/A");
          $("#viewFuelLevel").text(fuelLevel || "N/A");

          // Hiển thị thêm các trường mới
          $("#viewCarModel").text($(this).data("car-model") || "N/A");
          $("#viewLicensePlate").text($(this).data("license-plate") || "N/A");
          $("#viewCustomerName").text($(this).data("customer-name") || "N/A");
          $("#viewReturnDate").text($(this).data("return-date") ? formatDateTime($(this).data("return-date")) : "N/A");
        });
        
        // Handle events for surcharge checkboxes
        $("#lateReturn").change(function() {
          $("#lateReturnHours").prop("disabled", !this.checked);
          if (!this.checked) {
            $("#lateReturnHours").val("");
          }
        });
        
        $("#fuelShortage").change(function() {
          $("#fuelPrice").prop("disabled", !this.checked);
          if (!this.checked) {
            $("#fuelPrice").val("");
          }
        });
        
        $("#trafficViolations").change(function() {
          $("#violationFine").prop("disabled", !this.checked);
          if (!this.checked) {
            $("#violationFine").val("");
          }
        });
        
        $("#minorDamage").change(function() {
          $("#damageAmount").prop("disabled", !this.checked);
          if (!this.checked) {
            $("#damageAmount").val("");
          }
        });
        
        // Handle event when selecting image files
        $("#damageImages").change(function () {
          const files = this.files;
          const previewContainer = $("#imagePreviewContainer");
          previewContainer.empty();
          
          if (files.length > 0) {
            for (let i = 0; i < files.length; i++) {
              const file = files[i];
              if (file.type.startsWith("image/")) {
                const reader = new FileReader();
                reader.onload = function (e) {
                  const previewItem = $("<div>").addClass("image-preview-item");
                  const img = $("<img>")
                    .addClass("image-preview")
                    .attr("src", e.target.result);
                  const removeBtn = $("<span>")
                    .addClass("remove-image")
                    .html("&times;")
                    .click(function() {
                      $(this).parent().remove();
                      // Cannot directly delete file from input file, so we need to create a new FileList
                      // However, FileList is read-only, so we need to handle when submitting form
                    });
                  
                  previewItem.append(img).append(removeBtn);
                  previewContainer.append(previewItem);
                };
                reader.readAsDataURL(file);
              }
            }
          }
        });
        
        // Form validation function
        function validateForm() {
          const fuelLevel = $("#fuelLevel").val();
          const conditionStatus = $("#conditionStatus").val();
          
          if (!fuelLevel) {
            alert("Please select fuel level");
            return false;
          }
          
          if (!conditionStatus) {
            alert("Please select condition status");
            return false;
          }
          
          return true;
        }
        
        // Date time formatting function
        function formatDateTime(dateTimeStr) {
          if (!dateTimeStr) return "";
          // Use dayjs to parse and format
          var d = dayjs(dateTimeStr);
          if (!d.isValid()) return dateTimeStr;
          return d.format("DD/MM/YYYY HH:mm");
        }
      });
    </script>
  </body>
</html>