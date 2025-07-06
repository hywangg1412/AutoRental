<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Staff Management - AutoRental</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/admin-style.css"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
      rel="stylesheet"
    />
  </head>
  <body>
    <div class="admin-layout">
      <!-- Sidebar -->
      <div class="sidebar" id="sidebar">
        <div class="sidebar-header">
          <a href="admin-dashboard.jsp" class="sidebar-logo">
            <svg
              class="sidebar-logo-icon"
              fill="currentColor"
              viewBox="0 0 24 24"
            >
              <path
                d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.22.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99z"
              />
            </svg>
            <span class="sidebar-logo-text">AutoRental</span>
          </a>
        </div>

        <nav class="sidebar-nav">
          <a href="admin-dashboard.jsp" class="nav-item">
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"
              />
            </svg>
            Dashboard
          </a>
          <a href="manage-users.jsp" class="nav-item">
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M16 7c0-2.21-1.79-4-4-4S8 4.79 8 7s1.79 4 4 4 4-1.79 4-4zm-4 6c-2.67 0-8 1.34-8 4v3h16v-3c0-2.66-5.33-4-8-4z"
              />
            </svg>
            Users
          </a>
          <a
            href="${pageContext.request.contextPath}/manageCarsServlet"
            class="nav-item"
          >
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.22.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99z"
              />
            </svg>
            Cars
          </a>
          <a href="manage-staff.jsp" class="nav-item active">
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"
              />
            </svg>
            Staff
          </a>
          <a href="manage-reports.jsp" class="nav-item">
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 2 2h12c1.1 0 2-.9 2-2V8l-6-6z"
              />
            </svg>
            Reports
          </a>
          <a href="contract-details.jsp" class="nav-item">
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 2 2h12c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"
              />
            </svg>
            Contract Details
          </a>
          <a href="manage-vouchers.jsp" class="nav-item">
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M21.41 11.58l-9-9C12.05 2.22 11.55 2 11 2H4c-1.1 0-2 .9-2 2v7c0 .55.22 1.05.59 1.42l9 9c.36.36.86.58 1.41.58z"
              />
            </svg>
            Vouchers
          </a>
        </nav>

        <div class="sidebar-user">
          <div class="user-info">
            <div class="user-avatar">QH</div>
            <div class="user-details">
              <h4>Quang Huy</h4>
              <p>Administrator</p>
            </div>
          </div>
          <button class="logout-btn" onclick="logout()">
            <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.59L17 17l5-5z"
              />
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
                <svg
                  width="20"
                  height="20"
                  fill="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path d="M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z" />
                </svg>
              </button>
            </div>
            <div class="header-right">
              <button class="notification-btn">
                <svg
                  width="20"
                  height="20"
                  fill="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.89 2 2 2z" />
                </svg>
                <span class="notification-badge">3</span>
              </button>
            </div>
          </div>
        </header>

        <!-- Page Content -->
        <main class="page-content">
          <div class="page-header">
            <div class="flex items-center justify-between">
              <div>
                <h1 class="page-title">Staff Management</h1>
                <p class="page-description">
                  Manage staff accounts and permissions
                </p>
              </div>
              <button class="btn btn-primary" onclick="openAddStaffModal()">
                <svg
                  width="16"
                  height="16"
                  fill="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z" />
                </svg>
                Add Staff
              </button>
            </div>
          </div>

          <!-- Stats Cards -->
          <div class="stats-grid">
            <div class="stat-card">
              <div class="stat-header">
                <span class="stat-title">Total Staff</span>
              </div>
              <div class="stat-value">24</div>
              <div class="stat-change">Across all departments</div>
            </div>
            <div class="stat-card">
              <div class="stat-header">
                <span class="stat-title">Active Staff</span>
              </div>
              <div class="stat-value">22</div>
              <div class="stat-change positive">Currently working</div>
            </div>
            <div class="stat-card">
              <div class="stat-header">
                <span class="stat-title">Disabled</span>
              </div>
              <div class="stat-value">2</div>
              <div class="stat-change">Inactive accounts</div>
            </div>
            <div class="stat-card">
              <div class="stat-header">
                <span class="stat-title">Departments</span>
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
                  d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5z"
                />
              </svg>
              <input
                type="text"
                class="search-input"
                placeholder="Search staff..."
                id="searchStaff"
              />
            </div>
            <select class="form-select" id="departmentFilter">
              <option value="all">All Departments</option>
              <option value="support">Support</option>
              <option value="operations">Operations</option>
              <option value="sales">Sales</option>
              <option value="finance">Finance</option>
            </select>
            <select class="form-select" id="statusFilter">
              <option value="all">All Status</option>
              <option value="active">Active</option>
              <option value="disabled">Disabled</option>
            </select>
          </div>

          <!-- Staff Table -->
          <div class="card">
            <div class="card-header">
              <h2 class="card-title">All Staff Members</h2>
              <p class="card-description">
                Manage staff accounts and access permissions
              </p>
            </div>
            <div class="card-content">
              <div class="table-container">
                <table class="data-table" id="staffTable">
                  <thead>
                    <tr>
                      <th>Staff Member</th>
                      <th>Position</th>
                      <th>Department</th>
                      <th>Join Date</th>
                      <th>Last Login</th>
                      <th>Status</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>
                        <div>
                          <div class="font-medium">Alice Johnson</div>
                          <div class="text-sm text-gray-500">
                            alice@autorental.com
                          </div>
                          <div class="text-sm text-gray-500">
                            +1 234 567 8901
                          </div>
                        </div>
                      </td>
                      <td class="font-medium">Customer Service</td>
                      <td><span class="badge secondary">Support</span></td>
                      <td>Jan 15, 2024</td>
                      <td>2 hours ago</td>
                      <td><span class="badge success">Active</span></td>
                      <td>
                        <div class="flex items-center gap-4">
                          <button class="btn-ghost" onclick="viewStaff(1)">
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5z"
                              />
                            </svg>
                          </button>
                          <button class="btn-ghost" onclick="editStaff(1)">
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25z"
                              />
                            </svg>
                          </button>
                          <button
                            class="btn-ghost"
                            onclick="disableStaff(1, 'Alice Johnson')"
                          >
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z"
                              />
                            </svg>
                          </button>
                          <button
                            class="btn-ghost"
                            onclick="deleteStaff(1, 'Alice Johnson')"
                          >
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12z"
                              />
                            </svg>
                          </button>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td>
                        <div>
                          <div class="font-medium">Bob Smith</div>
                          <div class="text-sm text-gray-500">
                            bob@autorental.com
                          </div>
                          <div class="text-sm text-gray-500">
                            +1 234 567 8902
                          </div>
                        </div>
                      </td>
                      <td class="font-medium">Fleet Manager</td>
                      <td><span class="badge secondary">Operations</span></td>
                      <td>Feb 20, 2024</td>
                      <td>1 day ago</td>
                      <td><span class="badge success">Active</span></td>
                      <td>
                        <div class="flex items-center gap-4">
                          <button class="btn-ghost" onclick="viewStaff(2)">
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5z"
                              />
                            </svg>
                          </button>
                          <button class="btn-ghost" onclick="editStaff(2)">
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25z"
                              />
                            </svg>
                          </button>
                          <button
                            class="btn-ghost"
                            onclick="disableStaff(2, 'Bob Smith')"
                          >
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z"
                              />
                            </svg>
                          </button>
                          <button
                            class="btn-ghost"
                            onclick="deleteStaff(2, 'Bob Smith')"
                          >
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12z"
                              />
                            </svg>
                          </button>
                        </div>
                      </td>
                    </tr>
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
        <div class="modal-header">
          <h3 class="modal-title">Add New Staff Member</h3>
          <p class="modal-description">
            Create a new staff account with appropriate permissions
          </p>
        </div>
        <div class="modal-content">
          <form id="addStaffForm">
            <div class="form-group">
              <label class="form-label">Full Name</label>
              <input type="text" class="form-input" name="fullName" required />
            </div>
            <div class="form-group">
              <label class="form-label">Email</label>
              <input type="email" class="form-input" name="email" required />
            </div>
            <div class="form-group">
              <label class="form-label">Phone</label>
              <input type="tel" class="form-input" name="phone" required />
            </div>
            <div class="form-group">
              <label class="form-label">Position</label>
              <input type="text" class="form-input" name="position" required />
            </div>
            <div class="form-group">
              <label class="form-label">Department</label>
              <select class="form-select" name="department" required>
                <option value="">Select Department</option>
                <option value="Support">Support</option>
                <option value="Operations">Operations</option>
                <option value="Sales">Sales</option>
                <option value="Finance">Finance</option>
              </select>
            </div>
          </form>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" onclick="closeAddStaffModal()">
            Cancel
          </button>
          <button class="btn btn-primary" onclick="saveStaff()">
            Add Staff Member
          </button>
        </div>
      </div>
    </div>

    <!-- Disable Staff Modal -->
    <div id="disableStaffModal" class="modal-overlay" style="display: none">
      <div class="modal">
        <div class="modal-header">
          <h3 class="modal-title">Disable Staff Account</h3>
          <p class="modal-description">
            Are you sure you want to disable this staff account?
          </p>
        </div>
        <div class="modal-content">
          <div class="form-group">
            <label class="form-label">Reason for disabling</label>
            <textarea
              class="form-textarea"
              id="disableReason"
              placeholder="Enter reason for disabling this account..."
            ></textarea>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" onclick="closeDisableStaffModal()">
            Cancel
          </button>
          <button class="btn btn-danger" onclick="confirmDisableStaff()">
            Disable Account
          </button>
        </div>
      </div>
    </div>

    <script>
      let currentStaffId = null;
      let currentStaffName = null;

      function toggleSidebar() {
        const sidebar = document.getElementById("sidebar");
        sidebar.classList.toggle("open");
      }

      function logout() {
        if (confirm("Are you sure you want to logout?")) {
          window.location.href = "login.jsp";
        }
      }

      function openAddStaffModal() {
        document.getElementById("addStaffModal").style.display = "flex";
      }

      function closeAddStaffModal() {
        document.getElementById("addStaffModal").style.display = "none";
        document.getElementById("addStaffForm").reset();
      }

      function saveStaff() {
        const form = document.getElementById("addStaffForm");
        const formData = new FormData(form);

        console.log("Adding staff:", Object.fromEntries(formData));
        alert("Staff member added successfully!");
        closeAddStaffModal();
      }

      function viewStaff(staffId) {
        alert("View staff details for ID: " + staffId);
      }

      function editStaff(staffId) {
        alert("Edit staff for ID: " + staffId);
      }

      function disableStaff(staffId, staffName) {
        currentStaffId = staffId;
        currentStaffName = staffName;
        document.getElementById("disableStaffModal").style.display = "flex";
      }

      function closeDisableStaffModal() {
        document.getElementById("disableStaffModal").style.display = "none";
        document.getElementById("disableReason").value = "";
        currentStaffId = null;
        currentStaffName = null;
      }

      function confirmDisableStaff() {
        const reason = document.getElementById("disableReason").value;
        if (!reason.trim()) {
          alert("Please provide a reason for disabling this account.");
          return;
        }

        alert(
          `Staff account for ${currentStaffName} has been disabled. Reason: ${reason}`
        );
        closeDisableStaffModal();
      }

      function deleteStaff(staffId, staffName) {
        if (
          confirm(
            `Are you sure you want to delete ${staffName}? This action cannot be undone.`
          )
        ) {
          alert(`Staff member ${staffName} has been deleted`);
        }
      }

      // Search functionality
      document
        .getElementById("searchStaff")
        .addEventListener("input", function (e) {
          const searchTerm = e.target.value.toLowerCase();
          const table = document.getElementById("staffTable");
          const rows = table.getElementsByTagName("tr");

          for (let i = 1; i < rows.length; i++) {
            const row = rows[i];
            const text = row.textContent.toLowerCase();
            row.style.display = text.includes(searchTerm) ? "" : "none";
          }
        });

      // Filter functionality
      document
        .getElementById("departmentFilter")
        .addEventListener("change", filterTable);
      document
        .getElementById("statusFilter")
        .addEventListener("change", filterTable);

      function filterTable() {
        const departmentFilter =
          document.getElementById("departmentFilter").value;
        const statusFilter = document.getElementById("statusFilter").value;
        const table = document.getElementById("staffTable");
        const rows = table.getElementsByTagName("tr");

        for (let i = 1; i < rows.length; i++) {
          const row = rows[i];
          const departmentCell = row.cells[2];
          const statusCell = row.cells[5];

          const departmentText = departmentCell.textContent.toLowerCase();
          const statusText = statusCell.textContent.toLowerCase();

          const departmentMatch =
            departmentFilter === "all" ||
            departmentText.includes(departmentFilter);
          const statusMatch =
            statusFilter === "all" || statusText.includes(statusFilter);

          row.style.display = departmentMatch && statusMatch ? "" : "none";
        }
      }

      // Close modals when clicking outside
      window.addEventListener("click", function (event) {
        const addModal = document.getElementById("addStaffModal");
        const disableModal = document.getElementById("disableStaffModal");

        if (event.target === addModal) {
          closeAddStaffModal();
        }
        if (event.target === disableModal) {
          closeDisableStaffModal();
        }
      });
    </script>
  </body>
</html>
