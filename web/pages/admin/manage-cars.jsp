<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Car Management - AutoRental</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/admin/admin-style.css">

  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap" rel="stylesheet">

</head>
<body>
  <div class="admin-layout">
      <!-- Sidebar -->
      <div class="sidebar" id="sidebar">
        <div class="sidebar-header" style="display: flex; flex-direction: column; align-items: center; justify-content: center; text-align: center;">
            <a href="${pageContext.request.contextPath}/pages/admin/admin-dashboard.jsp" class="sidebar-logo" style="flex-direction: column; align-items: center; gap: 0; text-decoration: none; width: 100%;">
                <div style="display: flex; align-items: center; gap: 3px; justify-content: center;">
                    <span class="sidebar-logo-brand" style="color: #fff;">AUTO</span>
                    <span class="sidebar-logo-brand" style="color: #01D28E;">RENTAL</span>
                </div>
                <small style="color: #9ca3af; font-size: 12px; margin-left: 0; margin-top: 1px;">Admin Dashboard</small>
            </a>
          </div>

          <nav class="sidebar-nav">
              <a href="${pageContext.request.contextPath}/pages/admin/admin-dashboard.jsp" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/>
                  </svg>
                  Dashboard
              </a>
              <a href="${pageContext.request.contextPath}/pages/admin/manage-users.jsp" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M16 7c0-2.21-1.79-4-4-4S8 4.79 8 7s1.79 4 4 4 4-1.79 4-4zm-4 6c-2.67 0-8 1.34-8 4v3h16v-3c0-2.66-5.33-4-8-4z"/>
                  </svg>
                  Users
              </a>
              <a href="${pageContext.request.contextPath}/pages/admin/manage-cars.jsp" class="nav-item active">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.22.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99z"/>
                  </svg>
                  Cars
              </a>
              <a href="${pageContext.request.contextPath}/admin/staff-management" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                  </svg>
                  Staff
              </a>
              <a href="${pageContext.request.contextPath}/pages/admin/manage-reports.jsp" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M3 17h3v-7H3v7zm5 0h3v-12H8v12zm5 0h3v-4h-3v4zm5 0h3v-9h-3v9z"/>
                  </svg>
                  Reports
              </a>
              <a href="${pageContext.request.contextPath}/pages/admin/contract-details.jsp" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M16.5 3a2.5 2.5 0 0 1 3.54 3.54l-12.5 12.5-4.24 1.06 1.06-4.24L16.5 3zm2.04 2.12a.5.5 0 0 0-.71 0l-1.34 1.34 1.71 1.71 1.34-1.34a.5.5 0 0 0 0-.71l-1-1zm-2.75 2.75L5 16.66V19h2.34l10.79-10.79-1.34-1.34z"/>
                  </svg>
                  Contract Details
              </a>
              <a href="${pageContext.request.contextPath}/pages/admin/manage-vouchers.jsp" class="nav-item">
                  <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                      <path d="M21.41 11.58l-9-9C12.05 2.22 11.55 2 11 2H4c-1.1 0-2 .9-2 2v7c0 .55.22 1.05.59 1.42l9 9c.36.36.86.58 1.41.58.55 0 1.05-.22 1.41-.59l7-7c.37-.36.59-.86.59-1.41 0-.55-.23-1.06-.59-1.42zM5.5 7C4.67 7 4 6.33 4 5.5S4.67 4 5.5 4 7 4.67 7 5.5 6.33 7 5.5 7z"/>
                  </svg>
                  Vouchers
              </a>
          </nav>

          <div class="sidebar-user">
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
                          <h1 class="page-title">Car Management</h1>
                          <p class="page-description">Manage your car fleet and inventory</p>
                      </div>
                      <button class="btn btn-primary" onclick="openAddCarModal()">
                          <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                              <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
                          </svg>
                          Add Car
                      </button>
                  </div>
              </div>

              <!-- Stats Cards -->
              <div class="stats-grid">
                  <div class="stat-card">
                      <div class="stat-header">
                          <span class="stat-title">Total Cars</span>
                      </div>
                      <div class="stat-value">243</div>
                      <div class="stat-change positive">+5 new cars this month</div>
                  </div>
                  <div class="stat-card">
                      <div class="stat-header">
                          <span class="stat-title">Available Cars</span>
                      </div>
                      <div class="stat-value">89</div>
                      <div class="stat-change positive">Ready for rental</div>
                  </div>
                  <div class="stat-card">
                      <div class="stat-header">
                          <span class="stat-title">Rented Cars</span>
                      </div>
                      <div class="stat-value">142</div>
                      <div class="stat-change positive">Currently on rent</div>
                  </div>
                  <div class="stat-card">
                      <div class="stat-header">
                          <span class="stat-title">Maintenance</span>
                      </div>
                      <div class="stat-value">12</div>
                      <div class="stat-change negative">Under maintenance</div>
                  </div>
              </div>

              <!-- Filter Bar -->
              <div class="filter-bar">
                  <div class="search-box">
                      <svg class="search-icon" fill="currentColor" viewBox="0 0 24 24">
                          <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                      </svg>
                      <input type="text" class="search-input" placeholder="Search cars..." id="searchCars">
                  </div>
                  <select class="form-select" id="statusFilter">
                      <option value="all">All Status</option>
                      <option value="available">Available</option>
                      <option value="rented">Rented</option>
                      <option value="maintenance">Maintenance</option>
                  </select>
                  <select class="form-select" id="categoryFilter">
                      <option value="all">All Categories</option>
                      <option value="economy">Economy</option>
                      <option value="compact">Compact</option>
                      <option value="suv">SUV</option>
                      <option value="luxury">Luxury</option>
                  </select>
              </div>

              <!-- Cars Table -->
              <div class="card">
                  <div class="card-header">
                      <h2 class="card-title">All Cars</h2>
                      <p class="card-description">Manage and monitor your car fleet</p>
                  </div>
                  <div class="card-content">
                      <div class="table-container">
                          <table class="data-table" id="carsTable">
                              <thead>
                                  <tr>
                                      <th>Car</th>
                                      <th>Details</th>
                                      <th>Category</th>
                                      <th>Price/Day</th>
                                      <th>Status</th>
                                      <th>Last Service</th>
                                      <th>Actions</th>
                                  </tr>
                              </thead>
                              <tbody>
                                  <tr>
                                      <td>
                                          <div>
                                              <div class="font-medium">Toyota Corolla</div>
                                              <div class="text-sm text-gray-500">2023 Model</div>
                                          </div>
                                      </td>
                                      <td>
                                          <div>
                                              <div>License: ABC-123</div>
                                              <div class="text-xs text-gray-500">White • Automatic</div>
                                          </div>
                                      </td>
                                      <td><span class="badge info">Economy</span></td>
                                      <td class="font-medium">$45</td>
                                      <td><span class="badge success">Available</span></td>
                                      <td>Dec 15, 2024</td>
                                      <td>
                                          <div class="flex items-center gap-4">
                                              <button class="btn-ghost" onclick="viewCar(1)">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
                                                  </svg>
                                              </button>
                                              <button class="btn-ghost" onclick="editCar(1)">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                                                  </svg>
                                              </button>
                                              <button class="btn-ghost" onclick="deleteCar(1, 'Toyota Corolla')">
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
                                              <div class="font-medium">Honda Civic</div>
                                              <div class="text-sm text-gray-500">2023 Model</div>
                                          </div>
                                      </td>
                                      <td>
                                          <div>
                                              <div>License: DEF-456</div>
                                              <div class="text-xs text-gray-500">Black • Manual</div>
                                          </div>
                                      </td>
                                      <td><span class="badge info">Compact</span></td>
                                      <td class="font-medium">$50</td>
                                      <td><span class="badge warning">Rented</span></td>
                                      <td>Nov 28, 2024</td>
                                      <td>
                                          <div class="flex items-center gap-4">
                                              <button class="btn-ghost" onclick="viewCar(2)">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
                                                  </svg>
                                              </button>
                                              <button class="btn-ghost" onclick="editCar(2)">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                                                  </svg>
                                              </button>
                                              <button class="btn-ghost" onclick="deleteCar(2, 'Honda Civic')">
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
                                              <div class="font-medium">BMW X5</div>
                                              <div class="text-sm text-gray-500">2024 Model</div>
                                          </div>
                                      </td>
                                      <td>
                                          <div>
                                              <div>License: GHI-789</div>
                                              <div class="text-xs text-gray-500">Silver • Automatic</div>
                                          </div>
                                      </td>
                                      <td><span class="badge secondary">SUV</span></td>
                                      <td class="font-medium">$85</td>
                                      <td><span class="badge success">Available</span></td>
                                      <td>Dec 10, 2024</td>
                                      <td>
                                          <div class="flex items-center gap-4">
                                              <button class="btn-ghost" onclick="viewCar(3)">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
                                                  </svg>
                                              </button>
                                              <button class="btn-ghost" onclick="editCar(3)">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                                                  </svg>
                                              </button>
                                              <button class="btn-ghost" onclick="deleteCar(3, 'BMW X5')">
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
                                              <div class="font-medium">Mercedes C-Class</div>
                                              <div class="text-sm text-gray-500">2023 Model</div>
                                          </div>
                                      </td>
                                      <td>
                                          <div>
                                              <div>License: JKL-012</div>
                                              <div class="text-xs text-gray-500">Blue • Automatic</div>
                                          </div>
                                      </td>
                                      <td><span class="badge warning">Luxury</span></td>
                                      <td class="font-medium">$95</td>
                                      <td><span class="badge danger">Maintenance</span></td>
                                      <td>Dec 5, 2024</td>
                                      <td>
                                          <div class="flex items-center gap-4">
                                              <button class="btn-ghost" onclick="viewCar(4)">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z"/>
                                                  </svg>
                                              </button>
                                              <button class="btn-ghost" onclick="editCar(4)">
                                                  <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                      <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                                                  </svg>
                                              </button>
                                              <button class="btn-ghost" onclick="deleteCar(4, 'Mercedes C-Class')">
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

  <!-- Add Car Modal -->
  <div id="addCarModal" class="modal-overlay" style="display: none;">
      <div class="modal">
          <div class="modal-header">
              <h3 class="modal-title">Add New Car</h3>
              <p class="modal-description">Add a new car to your fleet</p>
          </div>
          <div class="modal-content">
              <form id="addCarForm">
                  <div class="form-group">
                      <label class="form-label">Car Make</label>
                      <input type="text" class="form-input" name="carMake" placeholder="e.g., Toyota" required>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Car Model</label>
                      <input type="text" class="form-input" name="carModel" placeholder="e.g., Corolla" required>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Year</label>
                      <input type="number" class="form-input" name="year" placeholder="2024" min="2000" max="2025" required>
                  </div>
                  <div class="form-group">
                      <label class="form-label">License Plate</label>
                      <input type="text" class="form-input" name="licensePlate" placeholder="ABC-123" required>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Color</label>
                      <input type="text" class="form-input" name="color" placeholder="White" required>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Transmission</label>
                      <select class="form-select" name="transmission" required>
                          <option value="">Select Transmission</option>
                          <option value="automatic">Automatic</option>
                          <option value="manual">Manual</option>
                      </select>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Category</label>
                      <select class="form-select" name="category" required>
                          <option value="">Select Category</option>
                          <option value="economy">Economy</option>
                          <option value="compact">Compact</option>
                          <option value="suv">SUV</option>
                          <option value="luxury">Luxury</option>
                      </select>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Price per Day ($)</label>
                      <input type="number" class="form-input" name="pricePerDay" placeholder="45" min="1" required>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Description</label>
                      <textarea class="form-textarea" name="description" placeholder="Car description and features..."></textarea>
                  </div>
              </form>
          </div>
          <div class="modal-footer">
              <button class="btn btn-secondary" onclick="closeAddCarModal()">Cancel</button>
              <button class="btn btn-primary" onclick="saveCar()">Add Car</button>
          </div>
      </div>
  </div>

  <!-- Edit Car Modal -->
  <div id="editCarModal" class="modal-overlay" style="display: none;">
      <div class="modal">
          <div class="modal-header">
              <h3 class="modal-title">Edit Car</h3>
              <p class="modal-description">Update car information</p>
          </div>
          <div class="modal-content">
              <form id="editCarForm">
                  <div class="form-group">
                      <label class="form-label">Car Make</label>
                      <input type="text" class="form-input" id="editCarMake" required>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Car Model</label>
                      <input type="text" class="form-input" id="editCarModel" required>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Year</label>
                      <input type="number" class="form-input" id="editYear" min="2000" max="2025" required>
                  </div>
                  <div class="form-group">
                      <label class="form-label">License Plate</label>
                      <input type="text" class="form-input" id="editLicensePlate" required>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Color</label>
                      <input type="text" class="form-input" id="editColor" required>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Transmission</label>
                      <select class="form-select" id="editTransmission" required>
                          <option value="">Select Transmission</option>
                          <option value="automatic">Automatic</option>
                          <option value="manual">Manual</option>
                      </select>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Category</label>
                      <select class="form-select" id="editCategory" required>
                          <option value="">Select Category</option>
                          <option value="economy">Economy</option>
                          <option value="compact">Compact</option>
                          <option value="suv">SUV</option>
                          <option value="luxury">Luxury</option>
                      </select>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Price per Day ($)</label>
                      <input type="number" class="form-input" id="editPricePerDay" min="1" required>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Status</label>
                      <select class="form-select" id="editStatus" required>
                          <option value="available">Available</option>
                          <option value="rented">Rented</option>
                          <option value="maintenance">Maintenance</option>
                      </select>
                  </div>
                  <div class="form-group">
                      <label class="form-label">Description</label>
                      <textarea class="form-textarea" id="editDescription"></textarea>
                  </div>
              </form>
          </div>
          <div class="modal-footer">
              <button class="btn btn-secondary" onclick="closeEditCarModal()">Cancel</button>
              <button class="btn btn-primary" onclick="updateCar()">Update Car</button>
          </div>
      </div>
  </div>

  <script>
      let currentCarId = null;

      function toggleSidebar() {
          const sidebar = document.getElementById('sidebar');
          sidebar.classList.toggle('open');
      }

      function logout() {
          if (confirm('Are you sure you want to logout?')) {
              window.location.href = 'login.jsp';
          }
      }

      function openAddCarModal() {
          document.getElementById('addCarModal').style.display = 'flex';
      }

      function closeAddCarModal() {
          document.getElementById('addCarModal').style.display = 'none';
          document.getElementById('addCarForm').reset();
      }

      function openEditCarModal() {
          document.getElementById('editCarModal').style.display = 'flex';
      }

      function closeEditCarModal() {
          document.getElementById('editCarModal').style.display = 'none';
          document.getElementById('editCarForm').reset();
          currentCarId = null;
      }

      function saveCar() {
          const form = document.getElementById('addCarForm');
          const formData = new FormData(form);
          
          // Here you would typically send the data to your server
          console.log('Adding car:', Object.fromEntries(formData));
          
          alert('Car added successfully!');
          closeAddCarModal();
          // Refresh the table or add the new row dynamically
      }

      function viewCar(carId) {
          // Implement view car functionality
          alert('View car details for ID: ' + carId);
      }

      function editCar(carId) {
          currentCarId = carId;
          // Here you would typically fetch car data from server
          // For demo, we'll populate with sample data
          document.getElementById('editCarMake').value = 'Toyota';
          document.getElementById('editCarModel').value = 'Corolla';
          document.getElementById('editYear').value = '2023';
          document.getElementById('editLicensePlate').value = 'ABC-123';
          document.getElementById('editColor').value = 'White';
          document.getElementById('editTransmission').value = 'automatic';
          document.getElementById('editCategory').value = 'economy';
          document.getElementById('editPricePerDay').value = '45';
          document.getElementById('editStatus').value = 'available';
          document.getElementById('editDescription').value = 'Reliable economy car';
          
          openEditCarModal();
      }

      function updateCar() {
          if (!currentCarId) return;
          
          const form = document.getElementById('editCarForm');
          const formData = new FormData(form);
          
          // Here you would typically send the data to your server
          console.log('Updating car ID:', currentCarId, Object.fromEntries(formData));
          
          alert('Car updated successfully!');
          closeEditCarModal();
          // Refresh the table or update the row dynamically
      }

      function deleteCar(carId, carName) {
          if (confirm(`Are you sure you want to delete ${carName}? This action cannot be undone.`)) {
              // Implement delete functionality
              alert(`Car ${carName} has been deleted`);
              // Remove the row from the table
          }
      }

      // Search functionality
      document.getElementById('searchCars').addEventListener('input', function(e) {
          const searchTerm = e.target.value.toLowerCase();
          const table = document.getElementById('carsTable');
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
          const table = document.getElementById('carsTable');
          const rows = table.getElementsByTagName('tr');
          
          for (let i = 1; i < rows.length; i++) {
              const row = rows[i];
              const statusCell = row.cells[4];
              const statusText = statusCell.textContent.toLowerCase();
              
              if (filterValue === 'all' || statusText.includes(filterValue)) {
                  row.style.display = '';
              } else {
                  row.style.display = 'none';
              }
          }
      });

      // Category filter functionality
      document.getElementById('categoryFilter').addEventListener('change', function(e) {
          const filterValue = e.target.value;
          const table = document.getElementById('carsTable');
          const rows = table.getElementsByTagName('tr');
          
          for (let i = 1; i < rows.length; i++) {
              const row = rows[i];
              const categoryCell = row.cells[2];
              const categoryText = categoryCell.textContent.toLowerCase();
              
              if (filterValue === 'all' || categoryText.includes(filterValue)) {
                  row.style.display = '';
              } else {
                  row.style.display = 'none';
              }
          }
      });

      // Close modals when clicking outside
      window.addEventListener('click', function(event) {
          const addModal = document.getElementById('addCarModal');
          const editModal = document.getElementById('editCarModal');
          
          if (event.target === addModal) {
              closeAddCarModal();
          }
          if (event.target === editModal) {
              closeEditCarModal();
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
