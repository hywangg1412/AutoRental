<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
    <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
      <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

        <!DOCTYPE html>
        <html lang="en">

        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Staff Management - AutoRental</title>
          
          <!-- Bootstrap CSS -->
          <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
          
          <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/admin/admin-style.css">
          <!-- <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/nav.css"> -->
          <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
            rel="stylesheet">
          <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">
        </head>

        <body>
          <div class="admin-layout">
            <!-- Sidebar -->
            <div class="sidebar" id="sidebar">
              <div class="sidebar-header"
                style="display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center;">
                <a href="${pageContext.request.contextPath}/pages/admin/admin-dashboard.jsp" class="sidebar-logo"
                  style="flex-direction: column; align-items: center; gap: 0; text-decoration: none; width: 100%;">
                  <div style="display: flex; align-items: center; gap: 3px; justify-content: center;">
                    <span class="sidebar-logo-brand" style="color: #fff;">AUTO</span>
                    <span class="sidebar-logo-brand" style="color: #01D28E;">RENTAL</span>
                  </div>
                  <small style="color: #9ca3af; font-size: 12px; margin-left: 0; margin-top: 1px;">Admin
                    Dashboard</small>
                </a>
              </div>

              <nav class="sidebar-nav">
                <a href="${pageContext.request.contextPath}/pages/admin/admin-dashboard.jsp" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z" />
                  </svg>
                  Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/admin/user-management" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                    <path
                      d="M16 7c0-2.21-1.79-4-4-4S8 4.79 8 7s1.79 4 4 4 4-1.79 4-4zm-4 6c-2.67 0-8 1.34-8 4v3h16v-3c0-2.66-5.33-4-8-4z" />
                  </svg>
                  Users
                </a>
                <a href="${pageContext.request.contextPath}/pages/admin/manage-cars.jsp" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                    <path
                      d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.22.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99z" />
                  </svg>
                  Cars
                </a>
                <a href="${pageContext.request.contextPath}/admin/staff-management" class="nav-item active">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                    <path
                      d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" />
                  </svg>
                  Staff
                </a>
                <a href="${pageContext.request.contextPath}/pages/admin/manage-reports.jsp" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M3 17h3v-7H3v7zm5 0h3v-12H8v12zm5 0h3v-4h-3v4zm5 0h3v-9h-3v9z" />
                  </svg>
                  Reports
                </a>
                <a href="${pageContext.request.contextPath}/pages/admin/contract-details.jsp" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                    <path
                      d="M16.5 3a2.5 2.5 0 0 1 3.54 3.54l-12.5 12.5-4.24 1.06 1.06-4.24L16.5 3zm2.04 2.12a.5.5 0 0 0-.71 0l-1.34 1.34 1.71 1.71 1.34-1.34a.5.5 0 0 0 0-.71l-1-1zm-2.75 2.75L5 16.66V19h2.34l10.79-10.79-1.34-1.34z" />
                  </svg>
                  Contract Details
                </a>
                <a href="${pageContext.request.contextPath}/pages/admin/manage-vouchers.jsp" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                    <path
                      d="M21.41 11.58l-9-9C12.05 2.22 11.55 2 11 2H4c-1.1 0-2 .9-2 2v7c0 .55.22 1.05.59 1.42l9 9c.36.36.86.58 1.41.58z" />
                  </svg>
                  Vouchers
                </a>
              </nav>

              <div class="sidebar-user">
                <button class="logout-btn" onclick="logout()">
                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                    <path
                      d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.59L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z" />
                  </svg>
                  Logout
                </button>
              </div>
            </div>

            <!-- Main Content -->
            <div class="main-content">
              <!-- Top Header -->
              <header class="top-header">
                <div class="header-content">
                  <div class="header-left">
                    <button class="btn-ghost" onclick="toggleSidebar()">
                      <svg width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z" />
                      </svg>
                    </button>
                    <div class="search-box">
                      <svg class="search-icon" fill="currentColor" viewBox="0 0 24 24">
                        <path
                          d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z" />
                      </svg>
                      <input type="text" class="search-input" placeholder="Search staff..." id="searchStaff">
                    </div>
                  </div>
                  <div class="header-right">
                    <button class="notification-btn">
                      <svg width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
                        <path
                          d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.89 2 2 2zm6-6v-5c0-3.07-1.64-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.63 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z" />
                      </svg>
                      <span class="notification-badge">3</span>
                    </button>
                    <div class="user-profile">
                      <div class="user-avatar">QH</div>
                      <div class="user-details">
                        <h4>Quang Huy</h4>
                        <p>Administrator</p>
                      </div>
                    </div>
                  </div>
                </div>
              </header>

              <!-- Page Content -->
              <main class="page-content">

                <div class="page-header">
                  <div class="flex items-center justify-between">
                    <div>
                      <h1 class="page-title">Staff Management</h1>
                      <p class="page-description">Manage staff accounts and permissions</p>
                    </div>
                    <button class="btn btn-primary" onclick="openAddStaffModal()">
                      <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z" />
                      </svg>
                      Add Staff
                    </button>
                  </div>
                </div>


                <!-- Messages -->
                <c:if test="${not empty success}">
                  <div class="alert alert-success">${success}</div>
                </c:if>
                <c:if test="${not empty error}">
                  <div class="alert alert-danger">${error}</div>
                </c:if>

                <!-- Stats Cards -->
                <div class="stats-grid">
                  <div class="stat-card">
                    <div class="stat-header">
                      <span class="stat-title">Total Staff</span>
                      <svg class="stat-icon blue" fill="currentColor" viewBox="0 0 24 24">
                        <path
                          d="M16 7c0-2.21-1.79-4-4-4S8 4.79 8 7s1.79 4 4 4 4-1.79 4-4zm-4 6c-2.67 0-8 1.34-8 4v3h16v-3c0-2.66-5.33-4-8-4z" />
                      </svg>
                    </div>
                    <div class="stat-value">${totalStaff != null ? totalStaff : 0}</div>
                    <div class="stat-change">Across all departments</div>
                  </div>
                  <div class="stat-card">
                    <div class="stat-header">
                      <span class="stat-title">Active Staff</span>
                      <svg class="stat-icon green" fill="currentColor" viewBox="0 0 24 24">
                        <path
                          d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" />
                      </svg>
                    </div>
                    <div class="stat-value">${activeStaff != null ? activeStaff : 0}</div>
                    <div class="stat-change positive">Currently working</div>
                  </div>
                  <div class="stat-card">
                    <div class="stat-header">
                      <span class="stat-title">Disabled</span>
                      <svg class="stat-icon red" fill="currentColor" viewBox="0 0 24 24">
                        <path
                          d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" />
                      </svg>
                    </div>
                    <div class="stat-value">${disabledStaff != null ? disabledStaff : 0}</div>
                    <div class="stat-change">Inactive accounts</div>
                  </div>
                  <div class="stat-card">
                    <div class="stat-header">
                      <span class="stat-title">Departments</span>
                      <svg class="stat-icon purple" fill="currentColor" viewBox="0 0 24 24">
                        <path
                          d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" />
                      </svg>
                    </div>
                    <div class="stat-value">4</div>
                    <div class="stat-change">Active departments</div>
                  </div>
                </div>
                <!-- Filter Bar -->
                <div class="filter-bar">
                  <div class="search-box">
                    <svg class="search-icon" fill="currentColor" viewBox="0 0 24 24">
                      <path
                        d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z" />
                    </svg>
                    <input type="text" class="search-input" placeholder="Search staff..." id="searchStaff">
                  </div>
                  <select class="form-select" id="statusFilter">
                    <option value="all">All Status</option>
                    <c:forEach var="status" items="${statusList}">
                      <option value="${fn:toLowerCase(status)}">${status}</option>
                    </c:forEach>
                  </select>
                </div>
                <!-- Staff Table -->
                <div class="card">
                  <div class="card-header">
                    <h2 class="card-title">All Staff Members</h2>
                    <p class="card-description">Manage staff accounts and access permissions</p>
                  </div>
                  <div class="card-content">
                    <div class="table-container">
                      <table class="data-table" id="staffTable">
                        <thead>
                          <tr>
                            <th>Staff Name</th>
                            <th>Username</th>
                            <th>Email</th>
                            <th>Phone</th>
                            <th>Join Date</th>
                            <th>Status</th>
                            <th>Actions</th>
                          </tr>
                        </thead>
                        <tbody>
                          <%-- Include fragment để render các dòng staff --%>
                            <jsp:include page="staff-table-rows.jsp" />
                        </tbody>
                      </table>
                    </div>
                  </div>
                </div>
              </main>
            </div>
          </div>

          <!-- Add Staff Modal -->
          <div id="addStaffModal" class="modal-overlay" style="display: none">
            <div class="modal">
              <button type="button" class="modal-close" onclick="closeAddStaffModal()">×</button>
              <div class="modal-header">
                <h3 class="modal-title">Add New Staff Member</h3>
              </div>
              <div class="modal-content">
                <form id="addStaffForm" method="post"
                  action="${pageContext.request.contextPath}/admin/staff-management">
                  <input type="hidden" name="action" value="add" />
                  <div class="form-group">
                    <label class="form-label">First Name *</label>
                    <input type="text" class="form-input" name="firstName" required />
                  </div>
                  <div class="form-group">
                    <label class="form-label">Last Name *</label>
                    <input type="text" class="form-input" name="lastName" required />
                  </div>
                  <div class="form-group">
                    <label class="form-label">Email *</label>
                    <input type="email" class="form-input" name="email" required />
                  </div>
                  <div class="form-group">
                    <label class="form-label">Username *</label>
                    <input type="text" class="form-input" name="username" required />
                  </div>
                  <div class="form-group">
                    <label class="form-label">Password *</label>
                    <input type="password" class="form-input" name="password" required />
                  </div>
                  <div class="form-group">
                    <label class="form-label">Phone</label>
                    <input type="tel" class="form-input" name="phoneNumber" />
                  </div>
                  <div class="form-group">
                    <label class="form-label">Gender</label>
                    <select class="form-select" name="gender">
                      <option value="">Select Gender</option>
                      <option value="Male">Male</option>
                      <option value="Female">Female</option>
                      <option value="Other">Other</option>
                    </select>
                  </div>
                  <div class="form-group">
                    <label class="form-label">Date of Birth</label>
                    <input type="date" class="form-input" name="userDOB" />
                  </div>
                  <div class="modal-footer">
                    <button class="btn btn-success" type="submit" style="width:100%; font-size:1.15rem;">Add Staff
                      Member</button>
                  </div>
                </form>
              </div>
            </div>
          </div>

          <!-- Edit Staff Modal -->
          <div id="editStaffModal" class="modal-overlay" style="display: none">
            <div class="modal">
              <button type="button" class="modal-close" onclick="closeEditStaffModal()">×</button>
              <div class="modal-header">
                <h3 class="modal-title">Update Staff Information</h3>
              </div>
              <div class="modal-content">
                <form id="editStaffForm" method="post"
                  action="${pageContext.request.contextPath}/admin/staff-management">
                  <input type="hidden" name="action" value="update" />
                  <input type="hidden" name="userId" id="editUserId" />
                  <div class="form-group">
                    <label class="form-label">First Name *</label>
                    <input type="text" class="form-input" name="firstName" id="editFirstName" required />
                  </div>
                  <div class="form-group">
                    <label class="form-label">Last Name *</label>
                    <input type="text" class="form-input" name="lastName" id="editLastName" required />
                  </div>
                  <div class="form-group">
                    <label class="form-label">Email *</label>
                    <input type="email" class="form-input" name="email" id="editEmail" required />
                  </div>
                  <div class="form-group">
                    <label class="form-label">Username *</label>
                    <input type="text" class="form-input" name="username" id="editUsername" required />
                  </div>
                  <div class="form-group">
                    <label class="form-label">Phone</label>
                    <input type="tel" class="form-input" name="phoneNumber" id="editPhoneNumber" />
                  </div>
                  <div class="form-group">
                    <label class="form-label">Gender</label>
                    <select class="form-select" name="gender" id="editGender">
                      <option value="">Select Gender</option>
                      <option value="Male">Male</option>
                      <option value="Female">Female</option>
                      <option value="Other">Other</option>
                    </select>
                  </div>
                  <div class="form-group">
                    <label class="form-label">Date of Birth</label>
                    <input type="date" class="form-input" name="userDOB" id="editUserDOB" />
                  </div>
                  <div class="modal-footer">
                    <button class="btn btn-success" id="updateStaffBtn" type="submit">
                      Update
                      <span class="spinner" id="updateSpinner" style="display:none"></span>
                    </button>
                  </div>
                </form>
              </div>
            </div>
          </div>

          <!-- Include Logout Modal -->
          <jsp:include page="../includes/logout-confirm-modal.jsp" />

          <!-- Bootstrap JS -->
          <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

          <script>
            const contextPath = '${pageContext.request.contextPath}';
          </script>
          <script>
            // Sidebar toggle
            function toggleSidebar() {
              document.getElementById("sidebar").classList.toggle("open");
            }

            // Logout confirm
            function logout() {
              // Show logout modal
              const logoutModal = document.getElementById('logoutConfirmModal');
              if (logoutModal) {
                  const modal = new bootstrap.Modal(logoutModal);
                  modal.show();
              } else {
                  // Fallback to confirm if modal not available
                  if (confirm("Are you sure you want to logout?")) {
                      window.location.href = "${pageContext.request.contextPath}/logout";
                  }
              }
            }

            // Modal helpers
            function openModal(modalId) {
              document.getElementById(modalId).style.display = "flex";
            }
            function closeModal(modalId, formId) {
              document.getElementById(modalId).style.display = "none";
              if (formId) document.getElementById(formId).reset();
            }

            // Add Staff Modal
            function openAddStaffModal() {
              openModal("addStaffModal");
            }
            function closeAddStaffModal() {
              closeModal("addStaffModal", "addStaffForm");
            }

            // Edit Staff Modal
            function openEditStaffModalFromRow(userId, firstName, lastName, username, email, phoneNumber, gender, userDOB) {
              document.getElementById("editUserId").value = userId || "";
              document.getElementById("editFirstName").value = firstName || "";
              document.getElementById("editLastName").value = lastName || "";
              document.getElementById("editUsername").value = username || "";
              document.getElementById("editEmail").value = email || "";
              document.getElementById("editPhoneNumber").value = phoneNumber || "";
              document.getElementById("editGender").value = gender || "";
              document.getElementById("editUserDOB").value = userDOB ? userDOB.substring(0, 10) : "";
              openModal("editStaffModal");
              // Lưu giá trị gốc vào data-original
              const form = document.getElementById("editStaffForm");
              for (let input of form.querySelectorAll("input, select")) {
                input.setAttribute("data-original", input.value);
              }
            }
            function closeEditStaffModal() {
              closeModal("editStaffModal", "editStaffForm");
            }

            // Đóng modal khi click outside, có xác nhận nếu form bị thay đổi
            window.addEventListener("click", function (event) {
              const editModal = document.getElementById("editStaffModal");
              if (event.target === editModal) {
                const form = document.getElementById("editStaffForm");
                let isDirty = false;
                for (let input of form.querySelectorAll("input, select")) {
                  if (input.value !== input.getAttribute("data-original")) {
                    isDirty = true;
                    break;
                  }
                }
                if (isDirty) {
                  if (confirm("You have unsaved changes. Do you want to save before closing?")) {
                    form.submit();
                    editModal.style.display = "none";
                  } else {
                    editModal.style.display = "none";
                  }
                } else {
                  editModal.style.display = "none";
                }
              }
              const addModal = document.getElementById("addStaffModal");
              if (event.target === addModal) {
                closeAddStaffModal();
              }
            });

            // Set editingStaffId and submit form
            document.getElementById('statusFilter').addEventListener('change', function () {
              const selectedStatus = this.value;
              console.log('Selected status:', selectedStatus);

              // Gửi trực tiếp giá trị từ option (lowercase)
              const statusParam = selectedStatus;
              console.log('Status parameter sent:', statusParam);

              // Sử dụng contextPath đã được define
              fetch(`${contextPath}/admin/staff-list-fragment?status=${statusParam}`)
                .then(response => {
                  console.log('Response status:', response.status);
                  if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                  }
                  return response.text();
                })
                .then(html => {
                  console.log('HTML received:', html.length > 0 ? 'Success' : 'Empty response');
                  document.querySelector('#staffTable tbody').innerHTML = html;
                  console.log('Table updated successfully');
                })
                .catch(error => {
                  console.error('Error fetching filtered staff:', error);
                  alert('Error filtering staff. Please try again.');
                });
            });
          </script>
        </body>

        </html>