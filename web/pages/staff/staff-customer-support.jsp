<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
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
    <!-- Notification CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/staff/staff-notification.css">
    <style>
      /* Additional CSS for new features */
      .bulk-reply-section {
        background-color: #f8f9fa;
        border-radius: 10px;
        padding: 20px;
        margin-bottom: 20px;
        border: 1px solid #dee2e6;
      }
      .rating-filter-btn {
        margin-right: 5px;
        margin-bottom: 5px;
      }
      .rating-star {
        color: #ffc107;
      }
      .feedback-checkbox {
        width: 18px;
        height: 18px;
      }
      .responded-feedback {
        background-color: #e8f4f8 !important;
      }
      .dropdown-menu {
        max-height: 300px;
        overflow-y: auto;
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
            <a class="nav-link" href="${pageContext.request.contextPath}/pages/staff/staff-car-condition.jsp">
              <i class="fas fa-car"></i> Car Condition
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="${pageContext.request.contextPath}/pages/staff/staff-car-availability.jsp">
              <i class="fas fa-clipboard-list"></i> Car Availability
            </a>
          </li>
          <li class="nav-item">
            <a class="nav-link active" href="${pageContext.request.contextPath}/staff/feedback-reply">
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
      <!-- Header -->
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
        <!-- Alert Messages -->
        <c:if test="${not empty successMessage}">
          <div class="alert alert-success alert-dismissible fade show" role="alert">
            ${successMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
          </div>
        </c:if>
        <c:if test="${not empty errorMessage}">
          <div class="alert alert-danger alert-dismissible fade show" role="alert">
            ${errorMessage}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
          </div>
        </c:if>
        
        <!-- Bulk Reply Section -->
        <div class="bulk-reply-section mb-4">
          <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="mb-0"><i class="fas fa-reply-all me-2"></i>Bulk Reply</h5>
            <button class="btn btn-sm btn-outline-primary" type="button" data-bs-toggle="collapse" data-bs-target="#bulkReplyCollapse">
              <i class="fas fa-chevron-down"></i>
            </button>
          </div>
          
          <div class="collapse" id="bulkReplyCollapse">
            <form action="${pageContext.request.contextPath}/staff/feedback-reply" method="post">
              <input type="hidden" name="action" value="bulk-reply">
              
              <div class="mb-3">
                <label class="form-label">Reply to all reviews with rating:</label>
                <div class="d-flex flex-wrap">
                  <a href="${pageContext.request.contextPath}/staff/feedback-reply?filter=rating&rating=5" class="btn btn-outline-warning rating-filter-btn">
                    <i class="fas fa-star rating-star"></i><i class="fas fa-star rating-star"></i><i class="fas fa-star rating-star"></i><i class="fas fa-star rating-star"></i><i class="fas fa-star rating-star"></i>
                  </a>
                  <a href="${pageContext.request.contextPath}/staff/feedback-reply?filter=rating&rating=4" class="btn btn-outline-warning rating-filter-btn">
                    <i class="fas fa-star rating-star"></i><i class="fas fa-star rating-star"></i><i class="fas fa-star rating-star"></i><i class="fas fa-star rating-star"></i><i class="far fa-star rating-star"></i>
                  </a>
                  <a href="${pageContext.request.contextPath}/staff/feedback-reply?filter=rating&rating=3" class="btn btn-outline-warning rating-filter-btn">
                    <i class="fas fa-star rating-star"></i><i class="fas fa-star rating-star"></i><i class="fas fa-star rating-star"></i><i class="far fa-star rating-star"></i><i class="far fa-star rating-star"></i>
                  </a>
                  <a href="${pageContext.request.contextPath}/staff/feedback-reply?filter=rating&rating=2" class="btn btn-outline-warning rating-filter-btn">
                    <i class="fas fa-star rating-star"></i><i class="fas fa-star rating-star"></i><i class="far fa-star rating-star"></i><i class="far fa-star rating-star"></i><i class="far fa-star rating-star"></i>
                  </a>
                  <a href="${pageContext.request.contextPath}/staff/feedback-reply?filter=rating&rating=1" class="btn btn-outline-warning rating-filter-btn">
                    <i class="fas fa-star rating-star"></i><i class="far fa-star rating-star"></i><i class="far fa-star rating-star"></i><i class="far fa-star rating-star"></i><i class="far fa-star rating-star"></i>
                  </a>
                </div>
              </div>
              
              <c:if test="${currentRating != null}">
                <div class="mb-3">
                  <label for="bulkReplyContent" class="form-label">Reply to all ${currentRating}-star reviews without replies:</label>
                  <input type="hidden" name="bulkRating" value="${currentRating}">
                  <textarea class="form-control" name="bulkReplyContent" id="bulkReplyContent" rows="3" required placeholder="Enter your reply to all ${currentRating}-star reviews..."></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary">
                  <i class="fas fa-paper-plane me-1"></i>Send Bulk Reply
                </button>
              </c:if>
              
              <c:if test="${currentRating == null}">
                <p class="text-muted">Select a star rating above to reply to all reviews with that rating.</p>
              </c:if>
            </form>
          </div>
        </div>
        
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
                  id="searchInput"
                />
              </div>
              <div class="dropdown">
                <button class="btn btn-outline-secondary btn-sm dropdown-toggle" type="button" id="filterDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                  <c:choose>
                    <c:when test="${currentFilter == 'pending'}">Pending Response</c:when>
                    <c:when test="${currentFilter == 'responded'}">Responded</c:when>
                    <c:when test="${currentFilter == 'rating' && currentRating != null}">${currentRating} Star Reviews</c:when>
                    <c:otherwise>All Reviews</c:otherwise>
                  </c:choose>
                </button>
                <ul class="dropdown-menu" aria-labelledby="filterDropdown">
                  <li><a class="dropdown-item ${currentFilter == 'all' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/feedback-reply?filter=all">All Reviews</a></li>
                  <li><a class="dropdown-item ${currentFilter == 'responded' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/feedback-reply?filter=responded">Responded</a></li>
                  <li><a class="dropdown-item ${currentFilter == 'pending' ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/feedback-reply?filter=pending">Pending Response</a></li>
                  <li><hr class="dropdown-divider"></li>
                  <li><h6 class="dropdown-header">Filter by Rating</h6></li>
                  <li><a class="dropdown-item ${currentFilter == 'rating' && currentRating == 5 ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/feedback-reply?filter=rating&rating=5">5 Star Reviews</a></li>
                  <li><a class="dropdown-item ${currentFilter == 'rating' && currentRating == 4 ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/feedback-reply?filter=rating&rating=4">4 Star Reviews</a></li>
                  <li><a class="dropdown-item ${currentFilter == 'rating' && currentRating == 3 ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/feedback-reply?filter=rating&rating=3">3 Star Reviews</a></li>
                  <li><a class="dropdown-item ${currentFilter == 'rating' && currentRating == 2 ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/feedback-reply?filter=rating&rating=2">2 Star Reviews</a></li>
                  <li><a class="dropdown-item ${currentFilter == 'rating' && currentRating == 1 ? 'active' : ''}" href="${pageContext.request.contextPath}/staff/feedback-reply?filter=rating&rating=1">1 Star Reviews</a></li>
                </ul>
              </div>
              <button class="btn btn-primary btn-sm" id="filterButton">
                <i class="fas fa-filter me-1"></i>Filter
              </button>
            </div>
          </div>
          <div class="card-body">
            <div class="table-responsive">
              <table class="table" id="feedbackTable">
                <thead>
                  <tr>
                    <th>ID</th>
                    <th>Customer Name</th>
                    <th>Rented Vehicle</th>
                    <th>Booking Code</th>
                    <th>Rating</th>
                    <th>Review Content</th>
                    <th>Review Date</th>
                    <th>Response Status</th>
                    <th>Actions</th>
                  </tr>
                </thead>
                <tbody>
                  <c:choose>
                    <c:when test="${not empty pendingFeedback}">
                      <c:forEach var="feedback" items="${pendingFeedback}" varStatus="status">
                        <tr class="${feedback.hasStaffReply() ? 'responded-feedback' : ''}">
                          <td>${status.index + 1}</td>
                          <td class="customer-name">${feedback.username}</td>
                          <td class="vehicle-name">${feedback.carBrand} ${feedback.carModel}</td>
                          <td class="booking-code">${not empty feedback.bookingCode ? feedback.bookingCode : feedback.shortBookingId}</td>
                          <td class="rating">
                            ${feedback.ratingStarsHtml}
                          </td>
                          <td class="comment">
                            ${feedback.content}
                            <c:if test="${feedback.hasStaffReply()}">
<!--                              <div class="staff-reply mt-2 p-2 rounded" style="background-color: #e8f4f8; border-left: 3px solid #0d6efd;">
                                <small>${feedback.staffReply}</small>
                              </div>-->
                            </c:if>
                          </td>
                          <td>${feedback.formattedCreatedDate}</td>
                          <td>
                            <c:choose>
                              <c:when test="${feedback.hasStaffReply()}">
                                <span class="status-badge badge-success">Responded</span>
                              </c:when>
                              <c:otherwise>
                                <span class="status-badge badge-warning">Pending Response</span>
                              </c:otherwise>
                            </c:choose>
                          </td>
                          <td>
                            <c:choose>
                              <c:when test="${feedback.hasStaffReply()}">
                                <button
                                  class="btn btn-info btn-sm"
                                  data-bs-toggle="modal"
                                  data-bs-target="#replyModal"
                                  data-feedback-id="${feedback.feedbackId}"
                                  data-customer-name="${feedback.username}"
                                  data-vehicle="${feedback.carBrand} ${feedback.carModel}"
                                  data-booking-code="${not empty feedback.bookingCode ? feedback.bookingCode : feedback.shortBookingId}"
                                  data-rating="${feedback.rating}"
                                  data-content="${feedback.content}"
                                  data-date="${feedback.formattedCreatedDate}"
                                  data-reply="${feedback.staffReply}"
                                >
                                  <i class="fas fa-edit me-1"></i>View/Edit
                                </button>
                              </c:when>
                              <c:otherwise>
                                <button
                                  class="btn btn-primary btn-sm"
                                  data-bs-toggle="modal"
                                  data-bs-target="#replyModal"
                                  data-feedback-id="${feedback.feedbackId}"
                                  data-customer-name="${feedback.username}"
                                  data-vehicle="${feedback.carBrand} ${feedback.carModel}"
                                  data-booking-code="${not empty feedback.bookingCode ? feedback.bookingCode : feedback.shortBookingId}"
                                  data-rating="${feedback.rating}"
                                  data-content="${feedback.content}"
                                  data-date="${feedback.formattedCreatedDate}"
                                  data-reply="${feedback.staffReply}"
                                >
                                  <i class="fas fa-reply me-1"></i>Reply
                                </button>
                              </c:otherwise>
                            </c:choose>
                          </td>
                        </tr>
                      </c:forEach>
                    </c:when>
                    <c:otherwise>
                      <tr>
                        <td colspan="9" class="text-center">No feedback found</td>
                      </tr>
                    </c:otherwise>
                  </c:choose>
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
                <p><strong>Customer:</strong> <span id="modalCustomerName"></span></p>
                <p><strong>Rented Vehicle:</strong> <span id="modalVehicle"></span></p>
                <p><strong>Booking Code:</strong> <span id="modalBookingCode"></span></p>
                <p>
                  <strong>Rating:</strong>
                  <span id="modalRating"></span>
                </p>
                <p>
                  <strong>Content:</strong> <span id="modalContent"></span>
                </p>
                <p><strong>Date:</strong> <span id="modalDate"></span></p>
              </div>
            </div>

            <!-- Previous Reply (if exists) -->
            <div class="inspection-section" id="previousReplySection" style="display: none;">
              <h6 class="section-title">
                <i class="fas fa-history me-2"></i>Previous Reply
              </h6>
              <div class="previous-reply">
                <p id="previousReplyContent"></p>
              </div>
            </div>

            <!-- Reply Form -->
            <div class="inspection-section">
              <h6 class="section-title">
                <i class="fas fa-pen me-2"></i>Reply Content
              </h6>
              <form action="${pageContext.request.contextPath}/staff/feedback-reply" method="post">
                <input type="hidden" name="feedbackId" id="modalFeedbackId" />
                <textarea
                  class="form-control"
                  name="replyContent"
                  id="replyContent"
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
    
    <!-- Auto-expand bulk reply section if rating is selected -->
    <c:if test="${currentRating != null}">
    <script>
      document.addEventListener('DOMContentLoaded', function() {
        const bulkReplyCollapse = document.getElementById('bulkReplyCollapse');
        if (bulkReplyCollapse) {
          new bootstrap.Collapse(bulkReplyCollapse, {
            toggle: true
          });
        }
      });
    </script>
    </c:if>
    
    <!-- Custom JS for feedback handling -->
    <script>
      document.addEventListener('DOMContentLoaded', function() {
        // Handle reply modal
        const replyModal = document.getElementById('replyModal');
        if (replyModal) {
          replyModal.addEventListener('show.bs.modal', function(event) {
            const button = event.relatedTarget;
            const feedbackId = button.getAttribute('data-feedback-id');
            const customerName = button.getAttribute('data-customer-name');
            const vehicle = button.getAttribute('data-vehicle');
            const bookingCode = button.getAttribute('data-booking-code');
            const rating = button.getAttribute('data-rating');
            const content = button.getAttribute('data-content');
            const date = button.getAttribute('data-date');
            const reply = button.getAttribute('data-reply');
            
            // Set values in modal
            document.getElementById('modalFeedbackId').value = feedbackId;
            document.getElementById('modalCustomerName').textContent = customerName;
            document.getElementById('modalVehicle').textContent = vehicle;
            document.getElementById('modalBookingCode').textContent = bookingCode;
            document.getElementById('modalContent').textContent = content;
            document.getElementById('modalDate').textContent = date;
            
            // Set rating stars
            const modalRating = document.getElementById('modalRating');
            modalRating.innerHTML = '';
            for (let i = 0; i < rating; i++) {
              modalRating.innerHTML += '<i class="fas fa-star text-warning"></i>';
            }
            for (let i = rating; i < 5; i++) {
              modalRating.innerHTML += '<i class="far fa-star text-muted"></i>';
            }
            
            // Handle previous reply if exists
            const previousReplySection = document.getElementById('previousReplySection');
            const previousReplyContent = document.getElementById('previousReplyContent');
            
            if (reply && reply.trim() !== '') {
              previousReplySection.style.display = 'block';
              previousReplyContent.textContent = reply;
              document.getElementById('replyContent').value = reply; // Pre-fill with previous reply
            } else {
              previousReplySection.style.display = 'none';
              previousReplyContent.textContent = '';
              document.getElementById('replyContent').value = ''; // Clear textarea
            }
          });
        }
        
        // Handle search and filter
        const searchInput = document.getElementById('searchInput');
        const filterButton = document.getElementById('filterButton');
        
        filterButton.addEventListener('click', function() {
          const searchTerm = searchInput.value.toLowerCase();
          
          const rows = document.querySelectorAll('#feedbackTable tbody tr');
          
          rows.forEach(row => {
            const customerName = row.querySelector('.customer-name').textContent.toLowerCase();
            const vehicleName = row.querySelector('.vehicle-name').textContent.toLowerCase();
            const comment = row.querySelector('.comment').textContent.toLowerCase();
            
            const matchesSearch = customerName.includes(searchTerm) || 
                              vehicleName.includes(searchTerm) || 
                              comment.includes(searchTerm);
            
            if (matchesSearch) {
              row.style.display = '';
            } else {
              row.style.display = 'none';
            }
          });
        });
      });
</script>
  </body>
</html>
