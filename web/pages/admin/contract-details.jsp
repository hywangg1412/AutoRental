<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Contract Details - AutoRental</title>

    <!-- Bootstrap CSS -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />

    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/styles/admin/admin-style.css"
    />

    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap"
      rel="stylesheet"
    />
  </head>
  <body>
    <div class="admin-layout">
      <!-- Sidebar -->
      <div class="sidebar" id="sidebar">
        <div
          class="sidebar-header"
          style="
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            text-align: center;
          "
        >
          <a
            href="${pageContext.request.contextPath}/pages/admin/admin-dashboard.jsp"
            class="sidebar-logo"
            style="
              flex-direction: column;
              align-items: center;
              gap: 0;
              text-decoration: none;
              width: 100%;
            "
          >
            <div
              style="
                display: flex;
                align-items: center;
                gap: 3px;
                justify-content: center;
              "
            >
              <span class="sidebar-logo-brand" style="color: #fff">AUTO</span>
              <span class="sidebar-logo-brand" style="color: #01d28e"
                >RENTAL</span
              >
            </div>
            <small
              style="
                color: #9ca3af;
                font-size: 12px;
                margin-left: 0;
                margin-top: 1px;
              "
              >Admin Dashboard</small
            >
          </a>
        </div>

        <nav class="sidebar-nav">
          <a
            href="${pageContext.request.contextPath}/admin/dashboard"
            class="nav-item"
          >
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"
              />
            </svg>
            Dashboard
          </a>
          <a
            href="${pageContext.request.contextPath}/admin/user-management"
            class="nav-item"
          >
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
          <a
            href="${pageContext.request.contextPath}/admin/manage-staff"
            class="nav-item"
          >
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"
              />
            </svg>
            Staff
          </a>
          <!-- Reports navigation item hidden -->
          <!--
          <a
            href="${pageContext.request.contextPath}/pages/admin/manage-reports.jsp"
            class="nav-item"
          >
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M3 17h3v-7H3v7zm5 0h3v-12H8v12zm5 0h3v-4h-3v4zm5 0h3v-9h-3v9z"
              />
            </svg>
            Reports
          </a>
          -->
          <!-- Contract Details navigation item hidden -->
          <!--
          <a
            href="${pageContext.request.contextPath}/pages/admin/contract-details.jsp"
            class="nav-item active"
          >
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M16.5 3a2.5 2.5 0 0 1 3.54 3.54l-12.5 12.5-4.24 1.06 1.06-4.24L16.5 3zm2.04 2.12a.5.5 0 0 0-.71 0l-1.34 1.34 1.71 1.71 1.34-1.34a.5.5 0 0 0 0-.71l-1-1zm-2.75 2.75L5 16.66V19h2.34l10.79-10.79-1.34-1.34z"
              />
            </svg>
            Contract Details
          </a>
          -->
          <a
            href="${pageContext.request.contextPath}/discount"
            class="nav-item"
          >
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M21.41 11.58l-9-9C12.05 2.22 11.55 2 11 2H4c-1.1 0-2 .9-2 2v7c0 .55.22 1.05.59 1.42l9 9c.36.36.86.58 1.41.58.55 0 1.05-.22 1.41-.59l7-7c.37-.36.59-.86.59-1.41 0-.55-.23-1.06-.59-1.42zM5.5 7C4.67 7 4 6.33 4 5.5S4.67 4 5.5 4 7 4.67 7 5.5 6.33 7 5.5 7z"
              />
            </svg>
            Vouchers
          </a>
        </nav>

        <div class="sidebar-user">
          <a
            class="logout-btn"
            href="${pageContext.request.contextPath}/logout"
          >
            <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.59L17 17l5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"
              />
            </svg>
            Logout
          </a>
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
                  <path
                    d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.89 2 2 2zm6-6v-5c0-3.07-1.64-5.64-4.5-6.32V4c0-.83-.67-1.5-1.5-1.5s-1.5.67-1.5 1.5v.68C7.63 5.36 6 7.92 6 11v5l-2 2v1h16v-1l-2-2z"
                  />
                </svg>
                <span class="notification-badge">3</span>
              </button>
              <div class="user-profile">
                <div class="user-avatar">
                  <img
                    src="${not empty sessionScope.user.avatarUrl ? sessionScope.user.avatarUrl : pageContext.request.contextPath.concat('/assets/images/default-avatar.png')}"
                    alt="User Avatar"
                    width="32"
                    height="32"
                    class="rounded-circle"
                    onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-avatar.png';"
                  />
                </div>
                <div class="user-details">
                  <h4>${sessionScope.user.username}</h4>
                  <p>Administrator</p>
                </div>
              </div>
            </div>
          </div>
        </header>

        <!-- Page Content -->
        <main class="page-content">
          <div class="page-header">
            <h1 class="page-title">Contract Details</h1>
            <p class="page-description">View and manage rental contracts</p>
          </div>

          <!-- Stats Cards -->
          <div class="stats-grid">
            <div class="stat-card">
              <div class="stat-header">
                <span class="stat-title">Active Contracts</span>
              </div>
              <div class="stat-value">156</div>
              <div class="stat-change positive">+8% from last month</div>
            </div>
            <div class="stat-card">
              <div class="stat-header">
                <span class="stat-title">Completed Contracts</span>
              </div>
              <div class="stat-value">1,247</div>
              <div class="stat-change positive">+12% from last month</div>
            </div>
            <div class="stat-card">
              <div class="stat-header">
                <span class="stat-title">Contract Value</span>
              </div>
              <div class="stat-value">$324,500</div>
              <div class="stat-change positive">+15% from last month</div>
            </div>
            <div class="stat-card">
              <div class="stat-header">
                <span class="stat-title">Pending Contracts</span>
              </div>
              <div class="stat-value">23</div>
              <div class="stat-change negative">Requires attention</div>
            </div>
          </div>

          <!-- Filter Bar -->
          <div class="filter-bar">
            <select class="form-select" id="statusFilter">
              <option value="all">All Status</option>
              <option value="active">Active</option>
              <option value="completed">Completed</option>
              <option value="pending">Pending</option>
              <option value="cancelled">Cancelled</option>
            </select>
          </div>

          <!-- Contracts Table -->
          <div class="card">
            <div class="card-header">
              <div class="flex items-center justify-between">
                <div>
                  <h2 class="card-title">All Contracts</h2>
                  <p class="card-description">
                    View and manage rental contracts
                  </p>
                </div>
                <button class="btn btn-primary" onclick="exportContracts()">
                  <svg
                    width="16"
                    height="16"
                    fill="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      d="M14 2H6c-1.1 0-2 .9-2 2v16c0 1.1.89 2 2 2h12c1.11 0 2-.9 2-2V8l-6-6zm4 18H6V4h7v5h5v11z"
                    />
                  </svg>
                  Export
                </button>
              </div>
            </div>
            <div class="card-content">
              <div class="table-container">
                <table class="data-table" id="contractsTable">
                  <thead>
                    <tr>
                      <th>Contract ID</th>
                      <th>Customer</th>
                      <th>Car Details</th>
                      <th>Rental Period</th>
                      <th>Total Amount</th>
                      <th>Status</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td><span class="font-medium">#CT-001</span></td>
                      <td>
                        <div>
                          <div class="font-medium">John Doe</div>
                          <div class="text-sm text-gray-500">
                            john@example.com
                          </div>
                          <div class="text-xs text-gray-500">
                            +1 234 567 8900
                          </div>
                        </div>
                      </td>
                      <td>
                        <div>
                          <div class="font-medium">Toyota Corolla</div>
                          <div class="text-sm text-gray-500">
                            2023 • White • ABC-123
                          </div>
                          <div class="text-xs text-gray-500">Economy Class</div>
                        </div>
                      </td>
                      <td>
                        <div>
                          <div class="font-medium">Dec 20 - Dec 23, 2024</div>
                          <div class="text-sm text-gray-500">3 days</div>
                          <div class="text-xs text-gray-500">
                            Pickup: 10:00 AM
                          </div>
                        </div>
                      </td>
                      <td class="font-medium">$135.00</td>
                      <td><span class="badge success">Active</span></td>
                      <td>
                        <div class="flex items-center gap-4">
                          <button class="btn-ghost" onclick="viewContract(1)">
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"
                              />
                            </svg>
                          </button>
                          <button
                            class="btn-ghost"
                            onclick="downloadContract(1)"
                          >
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"
                              />
                            </svg>
                          </button>
                          <button class="btn-ghost" onclick="editContract(1)">
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"
                              />
                            </svg>
                          </button>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td><span class="font-medium">#CT-002</span></td>
                      <td>
                        <div>
                          <div class="font-medium">Jane Smith</div>
                          <div class="text-sm text-gray-500">
                            jane@example.com
                          </div>
                          <div class="text-xs text-gray-500">
                            +1 234 567 8901
                          </div>
                        </div>
                      </td>
                      <td>
                        <div>
                          <div class="font-medium">Honda Civic</div>
                          <div class="text-sm text-gray-500">
                            2023 • Black • DEF-456
                          </div>
                          <div class="text-xs text-gray-500">Compact Class</div>
                        </div>
                      </td>
                      <td>
                        <div>
                          <div class="font-medium">Dec 18 - Dec 25, 2024</div>
                          <div class="text-sm text-gray-500">7 days</div>
                          <div class="text-xs text-gray-500">
                            Pickup: 2:00 PM
                          </div>
                        </div>
                      </td>
                      <td class="font-medium">$350.00</td>
                      <td><span class="badge warning">Pending</span></td>
                      <td>
                        <div class="flex items-center gap-4">
                          <button class="btn-ghost" onclick="viewContract(2)">
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"
                              />
                            </svg>
                          </button>
                          <button
                            class="btn-ghost"
                            onclick="downloadContract(2)"
                          >
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"
                              />
                            </svg>
                          </button>
                          <button class="btn-ghost" onclick="editContract(2)">
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"
                              />
                            </svg>
                          </button>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td><span class="font-medium">#CT-003</span></td>
                      <td>
                        <div>
                          <div class="font-medium">Mike Johnson</div>
                          <div class="text-sm text-gray-500">
                            mike@example.com
                          </div>
                          <div class="text-xs text-gray-500">
                            +1 234 567 8902
                          </div>
                        </div>
                      </td>
                      <td>
                        <div>
                          <div class="font-medium">BMW X5</div>
                          <div class="text-sm text-gray-500">
                            2024 • Silver • GHI-789
                          </div>
                          <div class="text-xs text-gray-500">SUV Class</div>
                        </div>
                      </td>
                      <td>
                        <div>
                          <div class="font-medium">Dec 15 - Dec 22, 2024</div>
                          <div class="text-sm text-gray-500">7 days</div>
                          <div class="text-xs text-gray-500">
                            Pickup: 9:00 AM
                          </div>
                        </div>
                      </td>
                      <td class="font-medium">$595.00</td>
                      <td><span class="badge info">Completed</span></td>
                      <td>
                        <div class="flex items-center gap-4">
                          <button class="btn-ghost" onclick="viewContract(3)">
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"
                              />
                            </svg>
                          </button>
                          <button
                            class="btn-ghost"
                            onclick="downloadContract(3)"
                          >
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"
                              />
                            </svg>
                          </button>
                          <button class="btn-ghost" onclick="editContract(3)">
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"
                              />
                            </svg>
                          </button>
                        </div>
                      </td>
                    </tr>
                    <tr>
                      <td><span class="font-medium">#CT-004</span></td>
                      <td>
                        <div>
                          <div class="font-medium">Sarah Wilson</div>
                          <div class="text-sm text-gray-500">
                            sarah@example.com
                          </div>
                          <div class="text-xs text-gray-500">
                            +1 234 567 8903
                          </div>
                        </div>
                      </td>
                      <td>
                        <div>
                          <div class="font-medium">Mercedes C-Class</div>
                          <div class="text-sm text-gray-500">
                            2023 • Blue • JKL-012
                          </div>
                          <div class="text-xs text-gray-500">Luxury Class</div>
                        </div>
                      </td>
                      <td>
                        <div>
                          <div class="font-medium">Dec 10 - Dec 15, 2024</div>
                          <div class="text-sm text-gray-500">5 days</div>
                          <div class="text-xs text-gray-500">
                            Pickup: 11:00 AM
                          </div>
                        </div>
                      </td>
                      <td class="font-medium">$475.00</td>
                      <td><span class="badge danger">Cancelled</span></td>
                      <td>
                        <div class="flex items-center gap-4">
                          <button class="btn-ghost" onclick="viewContract(4)">
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"
                              />
                            </svg>
                          </button>
                          <button
                            class="btn-ghost"
                            onclick="downloadContract(4)"
                          >
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"
                              />
                            </svg>
                          </button>
                          <button class="btn-ghost" onclick="editContract(4)">
                            <svg
                              width="16"
                              height="16"
                              fill="currentColor"
                              viewBox="0 0 24 24"
                            >
                              <path
                                d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"
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

    <!-- Contract Details Modal -->
    <div id="contractModal" class="modal-overlay" style="display: none">
      <div class="modal" style="max-width: 800px">
        <div class="modal-header">
          <h3 class="modal-title">Contract Details</h3>
          <p class="modal-description">Complete contract information</p>
        </div>
        <div class="modal-content">
          <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px">
            <!-- Customer Information -->
            <div class="card">
              <div class="card-header">
                <h4 class="card-title">Customer Information</h4>
              </div>
              <div class="card-content">
                <div class="mb-4">
                  <label class="form-label">Full Name</label>
                  <p class="font-medium" id="customerName">John Doe</p>
                </div>
                <div class="mb-4">
                  <label class="form-label">Email</label>
                  <p class="text-sm" id="customerEmail">john@example.com</p>
                </div>
                <div class="mb-4">
                  <label class="form-label">Phone</label>
                  <p class="text-sm" id="customerPhone">+1 234 567 8900</p>
                </div>
                <div class="mb-4">
                  <label class="form-label">License Number</label>
                  <p class="text-sm" id="customerLicense">DL123456789</p>
                </div>
              </div>
            </div>

            <!-- Car Information -->
            <div class="card">
              <div class="card-header">
                <h4 class="card-title">Car Information</h4>
              </div>
              <div class="card-content">
                <div class="mb-4">
                  <label class="form-label">Car Model</label>
                  <p class="font-medium" id="carModel">Toyota Corolla</p>
                </div>
                <div class="mb-4">
                  <label class="form-label">Year & Color</label>
                  <p class="text-sm" id="carDetails">2023 • White</p>
                </div>
                <div class="mb-4">
                  <label class="form-label">License Plate</label>
                  <p class="text-sm" id="carPlate">ABC-123</p>
                </div>
                <div class="mb-4">
                  <label class="form-label">Category</label>
                  <p class="text-sm" id="carCategory">Economy</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Rental Details -->
          <div class="card mt-4">
            <div class="card-header">
              <h4 class="card-title">Rental Details</h4>
            </div>
            <div class="card-content">
              <div
                style="
                  display: grid;
                  grid-template-columns: 1fr 1fr 1fr;
                  gap: 16px;
                "
              >
                <div>
                  <label class="form-label">Pickup Date</label>
                  <p class="font-medium" id="pickupDate">Dec 20, 2024</p>
                  <p class="text-sm" id="pickupTime">10:00 AM</p>
                </div>
                <div>
                  <label class="form-label">Return Date</label>
                  <p class="font-medium" id="returnDate">Dec 23, 2024</p>
                  <p class="text-sm" id="returnTime">10:00 AM</p>
                </div>
                <div>
                  <label class="form-label">Duration</label>
                  <p class="font-medium" id="duration">3 days</p>
                </div>
              </div>
            </div>
          </div>

          <!-- Payment Details -->
          <div class="card mt-4">
            <div class="card-header">
              <h4 class="card-title">Payment Details</h4>
            </div>
            <div class="card-content">
              <div
                style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px"
              >
                <div>
                  <label class="form-label">Daily Rate</label>
                  <p class="font-medium" id="dailyRate">$45.00</p>
                </div>
                <div>
                  <label class="form-label">Total Days</label>
                  <p class="font-medium" id="totalDays">3</p>
                </div>
                <div>
                  <label class="form-label">Subtotal</label>
                  <p class="font-medium" id="subtotal">$135.00</p>
                </div>
                <div>
                  <label class="form-label">Tax (10%)</label>
                  <p class="font-medium" id="tax">$13.50</p>
                </div>
                <div>
                  <label class="form-label">Insurance</label>
                  <p class="font-medium" id="insurance">$15.00</p>
                </div>
                <div>
                  <label class="form-label">Total Amount</label>
                  <p
                    class="font-bold"
                    style="font-size: 18px; color: #2563eb"
                    id="totalAmount"
                  >
                    $163.50
                  </p>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="modal-footer">
          <button class="btn btn-secondary" onclick="closeContractModal()">
            Close
          </button>
          <button class="btn btn-primary" onclick="downloadContract()">
            Download PDF
          </button>
        </div>
      </div>
    </div>

    <script>
      function toggleSidebar() {
        const sidebar = document.getElementById("sidebar");
        sidebar.classList.toggle("open");
      }

      function viewContract(contractId) {
        // Show contract details modal
        document.getElementById("contractModal").style.display = "flex";
      }

      function closeContractModal() {
        document.getElementById("contractModal").style.display = "none";
      }

      function downloadContract(contractId) {
        // Implement download functionality
        alert("Downloading contract PDF...");
      }

      function editContract(contractId) {
        // Implement edit functionality
        alert("Edit contract for ID: " + contractId);
      }

      function exportContracts() {
        // Implement export functionality
        alert("Exporting contracts...");
      }

      // Status filter functionality
      document
        .getElementById("statusFilter")
        .addEventListener("change", function (e) {
          const filterValue = e.target.value;
          const table = document.getElementById("contractsTable");
          const rows = table.getElementsByTagName("tr");

          for (let i = 1; i < rows.length; i++) {
            const row = rows[i];
            const statusCell = row.cells[5];
            const statusText = statusCell.textContent.toLowerCase();

            if (filterValue === "all" || statusText.includes(filterValue)) {
              row.style.display = "";
            } else {
              row.style.display = "none";
            }
          }
        });

      // Close modal when clicking outside
      window.addEventListener("click", function (event) {
        const modal = document.getElementById("contractModal");
        if (event.target === modal) {
          closeContractModal();
        }
      });

      // Close sidebar when clicking outside on mobile
      document.addEventListener("click", function (event) {
        const sidebar = document.getElementById("sidebar");
        const isClickInsideSidebar = sidebar.contains(event.target);
        const isToggleButton = event.target.closest(".btn-ghost");

        if (
          !isClickInsideSidebar &&
          !isToggleButton &&
          window.innerWidth <= 1024
        ) {
          sidebar.classList.remove("open");
        }
      });
    </script>
  </body>
</html>
