<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>User Management - AutoRental</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">

  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
  <div class="admin-layout">
      <!-- Sidebar -->
      <div class="sidebar" id="sidebar">
          <div class="sidebar-header">
              <a href="admin-dashboard.jsp" class="sidebar-logo">
                  <svg class="sidebar-logo-icon" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.22.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99zM6.5 16c-.83 0-1.5-.67-1.5-1.5S5.67 13 6.5 13s1.5.67 1.5 1.5S7.33 16 6.5 16zm11 0c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5zM5 11l1.5-4.5h11L19 11H5z"/>
                  </svg>
                  <span class="sidebar-logo-text">AutoRental</span>
              </a>
          </div>

          <nav class="sidebar-nav">
              <a href="admin-dashboard.jsp" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/>
                  </svg>
                  Dashboard
              </a>
              <a href="manage-users.jsp" class="nav-item active">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M16 7c0-2.21-1.79-4-4-4S8 4.79 8 7s1.79 4 4 4 4-1.79 4-4zm-4 6c-2.67 0-8 1.34-8 4v3h16v-3c0-2.66-5.33-4-8-4z"/>
                  </svg>
                  Users
              </a>
              <a href="manage-cars.jsp" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.22.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99z"/>
                  </svg>
                  Cars
              </a>
              <a href="manage-staff.jsp" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                  </svg>
                  Staff
              </a>
              <a href="manage-reports.jsp" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 2 2h12c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/>
                  </svg>
                  Reports
              </a>
              <a href="contract-details.jsp" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 2 2h12c1.1 0 2-.9 2-2V8l-6-6zm2 16H8v-2h8v2zm0-4H8v-2h8v2zm-3-5V3.5L18.5 9H13z"/>
                  </svg>
                  Contract Details
              </a>
              <a href="manage-vouchers.jsp" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M21.41 11.58l-9-9C12.05 2.22 11.55 2 11 2H4c-1.1 0-2 .9-2 2v7c0 .55.22 1.05.59 1.42l9 9c.36.36.86.58 1.41.58.55 0 1.05-.22 1.41-.59l7-7c.37-.36.59-.86.59-1.41 0-.55-.23-1.06-.59-1.42zM5.5 7C4.67 7 4 6.33 4 5.5S4.67 4 5.5 4 7 4.67 7 5.5 6.33 7 5.5 7z"/>
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
                      <path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.59L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/>
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
                              <path d="M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z"/>
                          </svg>
                      </button>
                      <div class="search-box">
                          <svg class="search-icon" fill="currentColor" viewBox="0 0 24 24">
                              <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                          </svg>
                          <input type="text" class="search-input" placeholder="Search...">
                      </div>
                  </div>
                  <div class="header-right">
                      <button class="notification-btn">
                          <svg width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
                              <path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.89 2 2 2zm6-6v-5c0-3.07-1.64-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.63 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z"/>
                          </svg>
                          <span class="notification-badge">3</span>
                      </button>
                      <div class="user-info">
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
                          <h1 class="page-title">User Management</h1>
                          <p class="page-description">Manage customer accounts and permissions</p>
                      </div>
                      <button class="btn btn-primary" onclick="openAddUserModal()">
                          <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                              <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
                          </svg>
                          Add User
                      </button>
                  </div>
              </div>

              <!-- Stats Cards -->
              <div class="stats-grid">
                  <div class="stat-card">
                      <div class="stat-header">
                          <span class="stat-title">Total Users</span>
                      </div>
                      <div class="stat-value">1,245</div>
                      <div class="stat-change positive">+12% from last month</div>
                  </div>
                  <div class="stat-card">
                      <div class="stat-header">
                          <span class="stat-title">Active Users</span>
                      </div>
                      <div class="stat-value">1,089</div>
                      <div class="stat-change positive">Currently active</div>
                  </div>
                  <div class="stat-card">
                      <div class="stat-header">
                          <span class="stat-title">Banned Users</span>
                      </div>
                      <div class="stat-value">12</div>
                      <div class="stat-change">Requires attention</div>
                  </div>
                  <div class="stat-card">
                      <div class="stat-header">
                          <span class="stat-title">New This Month</span>
                      </div>
                      <div class="stat-value">156</div>
                      <div class="stat-change positive">+25% growth</div>
                  </div>
              </div>

              <!-- Filter Bar -->
              <div class="filter-bar">
                  <div class="search-box">
                      <svg class="search-icon" fill="currentColor" viewBox="0 0 24 24">
                          <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                      </svg>
                      <input type="text" class="search-input" placeholder="Search users..." id="searchUsers">
                  </div>
                  <select class="form-select" id="statusFilter">
                      <option value="all">All Status</option>
                      <option value="active">Active</option>
                      <option value="inactive">Inactive</option>
                      <option value="banned">Banned</option>
                  </select>
              </div>

              <!-- Users Table -->
              <div class="card">
                  <div class="card-header">
                      <h2 class="card-title">All Users</h2>
                      <p class="card-description">Manage and monitor user accounts</p>
                  </div>
                  <div class="card-content">
                      <div class="table-container">
                          <table class="data-table" id="usersTable">
                              <thead>
                                  <tr>
                                      <th>User</th>
                                      <th>Contact</th>
                                      <th>Join Date</th>
                                      <th>Bookings</th>
                                      <th>Total Spent</th>
                                      <th>Status</th>
                                      <th>Actions</th>
                                  </tr>
                              </thead>
                              <tbody>
                                  <tr>
                                      <td>
                                          <div>
                                              <div class="font-medium">John Doe</div>
                                              <div class="text-sm text-gray-500">john@example.com</div>
                                          </div>
                                      </td>
                                      <td>
                                          <div>
                                              <div>+1 234 567 8901</div>
                                              <div class="text-xs text-gray-500">123 Main St, City, State</div>
                                          </div>
                                      </td>
                                      <td>Jan 15, 2024</td>
                                      <td class="font-medium">12</td>
                                      <td class="font-medium">$1,245</td>
                                      <td><span class="badge success">Active</span></td>
                                      <td>
                                          <div class="flex items-center gap-4">
                                              <button class="btn-ghost" onclick="viewUser(1)">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
                                                  </svg>
                                              </button>
                                              <button class="btn-ghost" onclick="editUser(1)">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                                                  </svg>
                                              </button>
                                              <button class="btn-ghost" onclick="banUser(1, 'John Doe')">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zM4 12c0-4.42 3.58-8 8-8 1.85 0 3.55.63 4.9 1.69L5.69 16.9C4.63 15.55 4 13.85 4 12zm8 8c-1.85 0-3.55-.63-4.9-1.69L18.31 7.1C19.37 8.45 20 10.15 20 12c0 4.42-3.58 8-8 8z"/>
                                                  </svg>
                                              </button>
                                              <button class="btn-ghost" onclick="deleteUser(1, 'John Doe')">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
                                                  </svg>
                                              </button>
                                          </div>
                                      </td>
                                  </tr>
                                  <tr>
                                      <td>
                                          <div>
                                              <div class="font-medium">Jane Smith</div>
                                              <div class="text-sm text-gray-500">jane@example.com</div>
                                          </div>
                                      </td>
                                      <td>
                                          <div>
                                              <div>+1 234 567 8902</div>
                                              <div class="text-xs text-gray-500">456 Oak Ave, City, State</div>
                                          </div>
                                      </td>
                                      <td>Feb 20, 2024</td>
                                      <td class="font-medium">8</td>
                                      <td class="font-medium">$890</td>
                                      <td><span class="badge success">Active</span></td>
                                      <td>
                                          <div class="flex items-center gap-4">
                                              <button class="btn-ghost" onclick="viewUser(2)">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
                                                  </svg>
                                              </button>
                                              <button class="btn-ghost" onclick="editUser(2)">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                                                  </svg>
                                              </button>
                                              <button class="btn-ghost" onclick="banUser(2, 'Jane Smith')">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zM4 12c0-4.42 3.58-8 8-8 1.85 0 3.55.63 4.9 1.69L5.69 16.9C4.63 15.55 4 13.85 4 12zm8 8c-1.85 0-3.55-.63-4.9-1.69L18.31 7.1C19.37 8.45 20 10.15 20 12c0 4.42-3.58 8-8 8z"/>
                                                  </svg>
                                              </button>
                                              <button class="btn-ghost" onclick="deleteUser(2, 'Jane Smith')">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
                                                  </svg>
                                              </button>
                                          </div>
                                      </td>
                                  </tr>
                                  <tr>
                                      <td>
                                          <div>
                                              <div class="font-medium">Mike Johnson</div>
                                              <div class="text-sm text-gray-500">mike@example.com</div>
                                          </div>
                                      </td>
                                      <td>
                                          <div>
                                              <div>+1 234 567 8903</div>
                                              <div class="text-xs text-gray-500">789 Pine St, City, State</div>
                                          </div>
                                      </td>
                                      <td>Mar 10, 2024</td>
                                      <td class="font-medium">3</td>
                                      <td class="font-medium">$245</td>
                                      <td><span class="badge danger">Banned</span></td>
                                      <td>
                                          <div class="flex items-center gap-4">
                                              <button class="btn-ghost" onclick="viewUser(3)">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
                                                  </svg>
                                              </button>
                                              <button class="btn-ghost" onclick="editUser(3)">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                                                  </svg>
                                              </button>
                                              <button class="btn-ghost" onclick="unbanUser(3, 'Mike Johnson')">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                                                  </svg>
                                              </button>
                                              <button class="btn-ghost" onclick="deleteUser(3, 'Mike Johnson')">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
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

  <!-- Add User Modal -->
  <div id="addUserModal" class="modal-overlay" style="display: none;">
      <div class="modal">
          <div class="modal-header">
              <h3 class="modal-title">Add New User</h3>
              <p class="modal-description">Create a new user account</p>
          </div>
          <div class="modal-content">
              <form id="addUserForm">
                  <div class="form-group">
                      <label class="form-label">Full Name</label>
                      <input type="text" class="form-input" name="fullName" required>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Email</label>
                      <input type="email" class="form-input" name="email" required>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Phone</label>
                      <input type="tel" class="form-input" name="phone" required>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Address</label>
                      <textarea class="form-textarea" name="address" required></textarea>
                  </div>
              </form>
          </div>
          <div class="modal-footer">
              <button class="btn btn-secondary" onclick="closeAddUserModal()">Cancel</button>
              <button class="btn btn-primary" onclick="saveUser()">Add User</button>
          </div>
      </div>
  </div>

  <!-- Ban User Modal -->
  <div id="banUserModal" class="modal-overlay" style="display: none;">
      <div class="modal">
          <div class="modal-header">
              <h3 class="modal-title">Ban User</h3>
              <p class="modal-description">Are you sure you want to ban this user?</p>
          </div>
          <div class="modal-content">
              <div class="form-group">
                  <label class="form-label">Reason for ban</label>
                  <textarea class="form-textarea" id="banReason" placeholder="Enter reason for banning this user..."></textarea>
              </div>
          </div>
          <div class="modal-footer">
              <button class="btn btn-secondary" onclick="closeBanUserModal()">Cancel</button>
              <button class="btn btn-danger" onclick="confirmBanUser()">Ban User</button>
          </div>
      </div>
  </div>

  <script>
      let currentUserId = null;
      let currentUserName = null;

      function toggleSidebar() {
          const sidebar = document.getElementById('sidebar');
          sidebar.classList.toggle('open');
      }

      function logout() {
          if (confirm('Are you sure you want to logout?')) {
              window.location.href = 'login.jsp';
          }
      }

      function openAddUserModal() {
          document.getElementById('addUserModal').style.display = 'flex';
      }

      function closeAddUserModal() {
          document.getElementById('addUserModal').style.display = 'none';
          document.getElementById('addUserForm').reset();
      }

      function saveUser() {
          const form = document.getElementById('addUserForm');
          const formData = new FormData(form);
          
          // Here you would typically send the data to your server
          console.log('Adding user:', Object.fromEntries(formData));
          
          alert('User added successfully!');
          closeAddUserModal();
          // Refresh the table or add the new row dynamically
      }

      function viewUser(userId) {
          // Implement view user functionality
          alert('View user details for ID: ' + userId);
      }

      function editUser(userId) {
          // Implement edit user functionality
          alert('Edit user for ID: ' + userId);
      }

      function banUser(userId, userName) {
          currentUserId = userId;
          currentUserName = userName;
          document.getElementById('banUserModal').style.display = 'flex';
      }

      function unbanUser(userId, userName) {
          if (confirm(`Are you sure you want to unban ${userName}?`)) {
              // Implement unban functionality
              alert(`User ${userName} has been unbanned`);
              // Update the UI
          }
      }

      function closeBanUserModal() {
          document.getElementById('banUserModal').style.display = 'none';
          document.getElementById('banReason').value = '';
          currentUserId = null;
          currentUserName = null;
      }

      function confirmBanUser() {
          const reason = document.getElementById('banReason').value;
          if (!reason.trim()) {
              alert('Please provide a reason for banning this user.');
              return;
          }
          
          // Implement ban functionality
          alert(`User ${currentUserName} has been banned. Reason: ${reason}`);
          closeBanUserModal();
          // Update the UI
      }

      function deleteUser(userId, userName) {
          if (confirm(`Are you sure you want to delete ${userName}? This action cannot be undone.`)) {
              // Implement delete functionality
              alert(`User ${userName} has been deleted`);
              // Remove the row from the table
          }
      }

      // Search functionality
      document.getElementById('searchUsers').addEventListener('input', function(e) {
          const searchTerm = e.target.value.toLowerCase();
          const table = document.getElementById('usersTable');
          const rows = table.getElementsByTagName('tr');
          
          for (let i = 1; i < rows.length; i++) {
              const row = rows[i];
              const text = row.textContent.toLowerCase();
              row.style.display = text.includes(searchTerm) ? '' : 'none';
          }
      });

      // Status filter functionality
      document.getElementById('statusFilter').addEventListener('change', function(e) {
          const filterValue = e.target.value;
          const table = document.getElementById('usersTable');
          const rows = table.getElementsByTagName('tr');
          
          for (let i = 1; i < rows.length; i++) {
              const row = rows[i];
              const statusCell = row.cells[5];
              const statusText = statusCell.textContent.toLowerCase();
              
              if (filterValue === 'all' || statusText.includes(filterValue)) {
                  row.style.display = '';
              } else {
                  row.style.display = 'none';
              }
          }
      });

      // Close modals when clicking outside
      window.addEventListener('click', function(event) {
          const addModal = document.getElementById('addUserModal');
          const banModal = document.getElementById('banUserModal');
          
          if (event.target === addModal) {
              closeAddUserModal();
          }
          if (event.target === banModal) {
              closeBanUserModal();
          }
      });

      // Close sidebar when clicking outside on mobile
      document.addEventListener('click', function(event) {
          const sidebar = document.getElementById('sidebar');
          const isClickInsideSidebar = sidebar.contains(event.target);
          const isToggleButton = event.target.closest('.btn-ghost');
          
          if (!isClickInsideSidebar && !isToggleButton && window.innerWidth <= 1024) {
              sidebar.classList.remove('open');
          }
      });
  </script>
</body>
</html>
