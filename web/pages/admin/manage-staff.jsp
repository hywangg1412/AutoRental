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
    <style>
      * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
      }

      body {
        font-family: "Inter", -apple-system, BlinkMacSystemFont, "Segoe UI",
          Roboto, sans-serif;
        background-color: #f9fafb;
        color: #111827;
        line-height: 1.6;
      }

      .admin-layout {
        display: flex;
        min-height: 100vh;
      }

      .sidebar {
        width: 256px;
        background-color: #111827;
        color: white;
        position: fixed;
        height: 100vh;
        overflow-y: auto;
        z-index: 50;
      }

      .sidebar-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        height: 64px;
        padding: 0 24px;
        border-bottom: 1px solid #374151;
      }

      .sidebar-logo {
        display: flex;
        align-items: center;
        gap: 8px;
        text-decoration: none;
        color: white;
      }

      .sidebar-logo-icon {
        width: 32px;
        height: 32px;
        color: #60a5fa;
      }

      .sidebar-logo-text {
        font-size: 20px;
        font-weight: bold;
      }

      .sidebar-nav {
        margin-top: 24px;
        padding: 0 12px;
      }

      .nav-item {
        display: flex;
        align-items: center;
        padding: 8px 12px;
        margin-bottom: 4px;
        border-radius: 8px;
        text-decoration: none;
        color: #d1d5db;
        font-size: 14px;
        font-weight: 500;
        transition: all 0.2s;
      }

      .nav-item:hover {
        background-color: #374151;
        color: white;
      }

      .nav-item.active {
        background-color: #2563eb;
        color: white;
      }

      .nav-item-icon {
        width: 20px;
        height: 20px;
        margin-right: 12px;
      }

      .sidebar-user {
        position: absolute;
        bottom: 0;
        left: 0;
        right: 0;
        padding: 16px;
        border-top: 1px solid #374151;
      }

      .user-info {
        display: flex;
        align-items: center;
        gap: 12px;
        margin-bottom: 12px;
      }

      .user-avatar {
        width: 32px;
        height: 32px;
        background-color: #2563eb;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-size: 14px;
        font-weight: 600;
      }

      .user-details h4 {
        font-size: 14px;
        font-weight: 500;
        color: white;
      }

      .user-details p {
        font-size: 12px;
        color: #9ca3af;
      }

      .logout-btn {
        width: 100%;
        padding: 8px 12px;
        background: transparent;
        border: none;
        color: #d1d5db;
        font-size: 14px;
        border-radius: 6px;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 8px;
        transition: all 0.2s;
      }

      .logout-btn:hover {
        background-color: #374151;
        color: white;
      }

      .main-content {
        flex: 1;
        margin-left: 256px;
        display: flex;
        flex-direction: column;
      }

      .top-header {
        background: white;
        border-bottom: 1px solid #e5e7eb;
        padding: 16px 24px;
      }

      .header-content {
        display: flex;
        align-items: center;
        justify-content: space-between;
      }

      .header-left {
        display: flex;
        align-items: center;
        gap: 16px;
      }

      .btn-ghost {
        padding: 8px;
        background: transparent;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        color: #6b7280;
        transition: all 0.2s;
      }

      .btn-ghost:hover {
        background-color: #f3f4f6;
        color: #374151;
      }

      .header-right {
        display: flex;
        align-items: center;
        gap: 16px;
      }

      .notification-btn {
        position: relative;
        padding: 8px;
        background: transparent;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        color: #6b7280;
      }

      .notification-btn:hover {
        background-color: #f3f4f6;
        color: #374151;
      }

      .notification-badge {
        position: absolute;
        top: 4px;
        right: 4px;
        background-color: #ef4444;
        color: white;
        font-size: 10px;
        padding: 2px 6px;
        border-radius: 10px;
        min-width: 16px;
        text-align: center;
      }

      .page-content {
        flex: 1;
        padding: 24px;
      }

      .page-header {
        margin-bottom: 24px;
      }

      .page-title {
        font-size: 30px;
        font-weight: 700;
        color: #111827;
        margin-bottom: 8px;
      }

      .page-description {
        color: #6b7280;
        font-size: 16px;
      }

      .flex {
        display: flex;
      }

      .items-center {
        align-items: center;
      }

      .justify-between {
        justify-content: space-between;
      }

      .btn {
        padding: 10px 16px;
        border: none;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        transition: all 0.2s;
        display: inline-flex;
        align-items: center;
        gap: 8px;
      }

      .btn-primary {
        background-color: #2563eb;
        color: white;
      }

      .btn-primary:hover {
        background-color: #1d4ed8;
      }

      .btn-secondary {
        background-color: #6b7280;
        color: white;
      }

      .btn-secondary:hover {
        background-color: #4b5563;
      }

      .alert {
        padding: 12px 16px;
        border-radius: 8px;
        margin-bottom: 16px;
        font-size: 14px;
      }

      .alert-success {
        background-color: #d1fae5;
        color: #065f46;
        border: 1px solid #a7f3d0;
      }

      .alert-danger {
        background-color: #fee2e2;
        color: #991b1b;
        border: 1px solid #fecaca;
      }

      .stats-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
        gap: 24px;
        margin-bottom: 24px;
      }

      .stat-card {
        background: white;
        padding: 24px;
        border-radius: 12px;
        border: 1px solid #e5e7eb;
      }

      .stat-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 12px;
      }

      .stat-title {
        font-size: 14px;
        font-weight: 500;
        color: #6b7280;
      }

      .stat-value {
        font-size: 32px;
        font-weight: 700;
        color: #111827;
        margin-bottom: 8px;
      }

      .stat-change {
        font-size: 14px;
        color: #6b7280;
      }

      .stat-change.positive {
        color: #059669;
      }

      .card {
        background: white;
        border-radius: 12px;
        border: 1px solid #e5e7eb;
        overflow: hidden;
      }

      .card-header {
        padding: 24px;
        border-bottom: 1px solid #e5e7eb;
      }

      .card-title {
        font-size: 20px;
        font-weight: 600;
        color: #111827;
        margin-bottom: 4px;
      }

      .card-description {
        color: #6b7280;
        font-size: 14px;
      }

      .card-content {
        padding: 24px;
      }

      .table-container {
        overflow-x: auto;
      }

      .data-table {
        width: 100%;
        border-collapse: collapse;
      }

      .data-table th {
        background-color: #f9fafb;
        padding: 12px 16px;
        text-align: left;
        font-size: 14px;
        font-weight: 500;
        color: #374151;
        border-bottom: 1px solid #e5e7eb;
      }

      .data-table td {
        padding: 12px 16px;
        border-bottom: 1px solid #e5e7eb;
        font-size: 14px;
      }

      .data-table tbody tr:hover {
        background-color: #f9fafb;
      }

      .font-medium {
        font-weight: 500;
      }

      .badge {
        padding: 4px 8px;
        border-radius: 6px;
        font-size: 12px;
        font-weight: 500;
      }

      .badge.success {
        background-color: #d1fae5;
        color: #065f46;
      }

      .badge.danger {
        background-color: #fee2e2;
        color: #991b1b;
      }

      .modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background-color: rgba(0, 0, 0, 0.5);
        display: flex;
        align-items: center;
        justify-content: center;
        z-index: 1000;
      }

      .modal {
        background: white;
        border-radius: 12px;
        width: 90%;
        max-width: 500px;
        max-height: 90vh;
        overflow-y: auto;
      }

      .modal-header {
        padding: 24px 24px 0 24px;
      }

      .modal-title {
        font-size: 20px;
        font-weight: 600;
        color: #111827;
        margin-bottom: 8px;
      }

      .modal-description {
        color: #6b7280;
        font-size: 14px;
      }

      .modal-content {
        padding: 24px;
      }

      .modal-footer {
        padding: 0 24px 24px 24px;
        display: flex;
        gap: 12px;
        justify-content: flex-end;
      }

      .form-group {
        margin-bottom: 20px;
      }

      .form-label {
        display: block;
        font-size: 14px;
        font-weight: 500;
        color: #374151;
        margin-bottom: 6px;
      }

      .form-input,
      .form-select {
        width: 100%;
        padding: 10px 12px;
        border: 1px solid #d1d5db;
        border-radius: 8px;
        font-size: 14px;
        transition: border-color 0.2s;
      }

      .form-input:focus,
      .form-select:focus {
        outline: none;
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
      }

      @media (max-width: 768px) {
        .sidebar {
          transform: translateX(-100%);
          transition: transform 0.3s ease;
        }

        .sidebar.open {
          transform: translateX(0);
        }

        .main-content {
          margin-left: 0;
        }

        .stats-grid {
          grid-template-columns: 1fr;
        }

        .modal {
          width: 95%;
          margin: 20px;
        }
      }
    </style>
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
              </div>
              <div class="stat-value">
                ${totalStaff != null ? totalStaff : 0}
              </div>
              <div class="stat-change">Across all departments</div>
            </div>
            <div class="stat-card">
              <div class="stat-header">
                <span class="stat-title">Active Staff</span>
              </div>
              <div class="stat-value">
                ${activeStaff != null ? activeStaff : 0}
              </div>
              <div class="stat-change positive">Currently working</div>
            </div>
            <div class="stat-card">
              <div class="stat-header">
                <span class="stat-title">Disabled</span>
              </div>
              <div class="stat-value">
                ${disabledStaff != null ? disabledStaff : 0}
              </div>
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
                    <c:forEach var="staff" items="${staffList}">
                      <tr>
                        <form method="post" action="StaffServlet">
                          <input
                            type="hidden"
                            name="userId"
                            value="${staff.userId}"
                          />
                          <td>
                            <input
                              name="firstName"
                              value="${staff.firstName}"
                              size="8"
                              required
                              style="width: 80px"
                            />
                            <input
                              name="lastName"
                              value="${staff.lastName}"
                              size="8"
                              required
                              style="width: 80px"
                            />
                          </td>
                          <td>
                            <input
                              name="username"
                              value="${staff.username}"
                              size="8"
                              required
                              readonly
                              style="width: 80px"
                            />
                          </td>
                          <td>
                            <input
                              name="email"
                              value="${staff.email}"
                              size="16"
                              required
                              readonly
                              style="width: 140px"
                            />
                          </td>
                          <td>
                            <input
                              name="phoneNumber"
                              value="${staff.phoneNumber}"
                              size="10"
                              style="width: 100px"
                            />
                          </td>
                          <td>
                            <c:choose>
                              <c:when test="${not empty staff.createdDate}">
                                ${staff.createdDate}
                              </c:when>
                              <c:otherwise>N/A</c:otherwise>
                            </c:choose>
                          </td>
                          <td>
                            <span
                              class="badge ${staff.status eq 'Active' ? 'success' : 'danger'}"
                            >
                              <c:out
                                value="${staff.status}"
                                default="Unknown"
                              />
                            </span>
                          </td>
                          <td>
                            <button
                              name="action"
                              value="update"
                              type="submit"
                              class="btn btn-primary"
                            >
                              Lưu
                            </button>
                            <button
                              name="action"
                              value="delete"
                              type="submit"
                              class="btn btn-danger"
                              onclick="return confirm('Xóa nhân viên này?')"
                            >
                              Xóa
                            </button>
                          </td>
                        </form>
                      </tr>
                    </c:forEach>
                    <c:if test="${empty staffList}">
                      <tr>
                        <td colspan="7" style="text-align: center; color: #888">
                          Không có nhân viên nào
                        </td>
                      </tr>
                    </c:if>
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
          <form
            id="addStaffForm"
            method="post"
            action="${pageContext.request.contextPath}/StaffServlet"
          >
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
              <input
                type="password"
                class="form-input"
                name="password"
                required
              />
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
              <button
                class="btn btn-secondary"
                type="button"
                onclick="closeAddStaffModal()"
              >
                Cancel
              </button>
              <button class="btn btn-primary" type="submit">
                Add Staff Member
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Edit Staff Modal -->
    <div id="editStaffModal" class="modal-overlay" style="display: none">
      <div class="modal">
        <div class="modal-header">
          <h3 class="modal-title">Edit Staff Member</h3>
          <p class="modal-description">Update staff account information</p>
        </div>
        <div class="modal-content">
          <form
            id="editStaffForm"
            method="post"
            action="${pageContext.request.contextPath}/StaffServlet"
          >
            <input type="hidden" name="action" value="edit" />
            <input type="hidden" name="userId" id="editUserId" />
            <div class="form-group">
              <label class="form-label">First Name *</label>
              <input
                type="text"
                class="form-input"
                name="firstName"
                id="editFirstName"
                required
              />
            </div>
            <div class="form-group">
              <label class="form-label">Last Name *</label>
              <input
                type="text"
                class="form-input"
                name="lastName"
                id="editLastName"
                required
              />
            </div>
            <div class="form-group">
              <label class="form-label">Email *</label>
              <input
                type="email"
                class="form-input"
                name="email"
                id="editEmail"
                required
              />
            </div>
            <div class="form-group">
              <label class="form-label">Username *</label>
              <input
                type="text"
                class="form-input"
                name="username"
                id="editUsername"
                required
              />
            </div>
            <div class="form-group">
              <label class="form-label">Phone</label>
              <input
                type="tel"
                class="form-input"
                name="phoneNumber"
                id="editPhoneNumber"
              />
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
              <input
                type="date"
                class="form-input"
                name="userDOB"
                id="editUserDOB"
              />
            </div>
            <div class="modal-footer">
              <button
                class="btn btn-secondary"
                type="button"
                onclick="closeEditStaffModal()"
              >
                Cancel
              </button>
              <button class="btn btn-primary" type="submit">
                Save Changes
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <script>
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

      function viewStaff(userId) {
        if (!userId || userId === "null" || userId === "") {
          alert("Invalid staff ID");
          return;
        }
        alert("View staff with ID: " + userId);
      }

      function openEditStaffModal(btn) {
        document.getElementById("editUserId").value =
          btn.getAttribute("data-userid") || "";
        document.getElementById("editFirstName").value =
          btn.getAttribute("data-firstname") || "";
        document.getElementById("editLastName").value =
          btn.getAttribute("data-lastname") || "";
        document.getElementById("editUsername").value =
          btn.getAttribute("data-username") || "";
        document.getElementById("editEmail").value =
          btn.getAttribute("data-email") || "";
        document.getElementById("editPhoneNumber").value =
          btn.getAttribute("data-phonenumber") || "";
        document.getElementById("editGender").value =
          btn.getAttribute("data-gender") || "";
        document.getElementById("editUserDOB").value =
          btn.getAttribute("data-userdob") || "";
        document.getElementById("editStaffModal").style.display = "flex";
      }

      function closeEditStaffModal() {
        document.getElementById("editStaffModal").style.display = "none";
        document.getElementById("editStaffForm").reset();
      }

      function disableStaff(userId) {
        if (!userId || userId === "null" || userId === "") {
          alert("Invalid staff ID");
          return;
        }
        if (confirm("Are you sure you want to disable this staff member?")) {
          window.location.href =
            "${pageContext.request.contextPath}/StaffServlet?action=disable&userId=" +
            userId;
        }
      }

      function enableStaff(userId) {
        if (!userId || userId === "null" || userId === "") {
          alert("Invalid staff ID");
          return;
        }
        if (confirm("Are you sure you want to enable this staff member?")) {
          window.location.href =
            "${pageContext.request.contextPath}/StaffServlet?action=enable&userId=" +
            userId;
        }
      }

      function deleteStaff(userId) {
        if (!userId || userId === "null" || userId === "") {
          alert("Invalid staff ID");
          return;
        }
        if (
          confirm(
            "Are you sure you want to delete this staff member? This action cannot be undone."
          )
        ) {
          window.location.href =
            "${pageContext.request.contextPath}/StaffServlet?action=delete&userId=" +
            userId;
        }
      }

      // Close modals when clicking outside
      window.addEventListener("click", function (event) {
        const addModal = document.getElementById("addStaffModal");
        if (event.target === addModal) {
          closeAddStaffModal();
        }
        const editModal = document.getElementById("editStaffModal");
        if (event.target === editModal) {
          closeEditStaffModal();
        }
      });
    </script>
  </body>
</html>
