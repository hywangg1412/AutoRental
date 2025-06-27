<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voucher Management - AutoRental</title>
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
                        <path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.22.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99z"/>
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
                <a href="manage-users.jsp" class="nav-item">
                    <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M16 7c0-2.21-1.79-4-4-4S8 4.79 8 7s1.79 4 4 4 4-1.79 4-4zm-4 6c-2.67 0-8 1.34-8 4v3h16v-3c0-2.66-5.33-4-8-4z"/>
                    </svg>
                    Users
                </a>
                <a href="manage-staff.jsp" class="nav-item">
                    <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z"/>
                    </svg>
                    Staff
                </a>
                <a href="manage-reports.jsp" class="nav-item">
                    <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 2 2h12c1.1 0 2-.9 2-2V8l-6-6z"/>
                    </svg>
                    Reports
                </a>
                <a href="manage-vouchers.jsp" class="nav-item active">
                    <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M21.41 11.58l-9-9C12.05 2.22 11.55 2 11 2H4c-1.1 0-2 .9-2 2v7c0 .55.22 1.05.59 1.42l9 9c.36.36.86.58 1.41.58z"/>
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
                        <path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.59L17 17l5-5z"/>
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
                    </div>
                    <div class="header-right">
                        <button class="notification-btn">
                            <svg width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.89 2 2 2z"/>
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
                            <h1 class="page-title">Voucher Management</h1>
                            <p class="page-description">Create and manage discount vouchers and promotional codes</p>
                        </div>
                        <button class="btn btn-primary" onclick="openCreateVoucherModal()">
                            <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
                            </svg>
                            Create Voucher
                        </button>
                    </div>
                </div>

                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Total Vouchers</span>
                        </div>
                        <div class="stat-value">24</div>
                        <div class="stat-change">All time created</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Active Vouchers</span>
                        </div>
                        <div class="stat-value">18</div>
                        <div class="stat-change positive">Currently available</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Total Usage</span>
                        </div>
                        <div class="stat-value">1,245</div>
                        <div class="stat-change">Times redeemed</div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Savings Given</span>
                        </div>
                        <div class="stat-value">$12,450</div>
                        <div class="stat-change">Total discounts</div>
                    </div>
                </div>

                <!-- Filter Bar -->
                <div class="filter-bar">
                    <div class="search-box">
                        <svg class="search-icon" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5z"/>
                        </svg>
                        <input type="text" class="search-input" placeholder="Search vouchers..." id="searchVouchers">
                    </div>
                    <select class="form-select" id="typeFilter">
                        <option value="all">All Types</option>
                        <option value="percentage">Percentage</option>
                        <option value="fixed">Fixed Amount</option>
                    </select>
                    <select class="form-select" id="statusFilter">
                        <option value="all">All Status</option>
                        <option value="active">Active</option>
                        <option value="inactive">Inactive</option>
                        <option value="expired">Expired</option>
                    </select>
                </div>

                <!-- Vouchers Table -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">All Vouchers</h2>
                        <p class="card-description">Manage discount codes and promotional offers</p>
                    </div>
                    <div class="card-content">
                        <div class="table-container">
                            <table class="data-table" id="vouchersTable">
                                <thead>
                                    <tr>
                                        <th>Voucher Code</th>
                                        <th>Name & Description</th>
                                        <th>Discount</th>
                                        <th>Usage</th>
                                        <th>Valid Period</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td>
                                            <div class="flex items-center gap-8">
                                                <code style="background: #f3f4f6; padding: 4px 8px; border-radius: 4px; font-family: monospace; font-size: 12px;">SUMMER2024</code>
                                                <button class="btn-ghost" onclick="copyVoucherCode('SUMMER2024')">
                                                    <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24">
                                                        <path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/>
                                                    </svg>
                                                </button>
                                            </div>
                                        </td>
                                        <td>
                                            <div>
                                                <div class="font-medium">Summer Special</div>
                                                <div class="text-sm text-gray-500">20% off all car rentals during summer</div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="flex items-center gap-4">
                                                <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                    <path d="M7.5 11H2V9h5.5l-.75-1.5h2.5L11 10l-1.75 2.5h-2.5L7.5 11zm4.5 0h5.5l-.75 1.5h2.5L21 10l-1.75-2.5h-2.5L17.5 9H12v2z"/>
                                                </svg>
                                                <span class="font-medium">20%</span>
                                            </div>
                                            <div class="text-xs text-gray-500">Min: $100 • Max: $50</div>
                                        </td>
                                        <td>
                                            <div class="text-sm">
                                                <div class="font-medium">45 / 100</div>
                                                <div class="progress-bar mt-4">
                                                    <div class="progress-fill" style="width: 45%;"></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-sm">
                                            <div>
                                                <div class="flex items-center text-xs text-gray-500">
                                                    <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24" style="margin-right: 4px;">
                                                        <path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"/>
                                                    </svg>
                                                    From
                                                </div>
                                                <div>2024-06-01</div>
                                                <div class="flex items-center text-xs text-gray-500 mt-4">
                                                    <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24" style="margin-right: 4px;">
                                                        <path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"/>
                                                    </svg>
                                                    To
                                                </div>
                                                <div>2024-08-31</div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="flex items-center gap-8">
                                                <span class="badge success">Active</span>
                                                <label class="switch">
                                                    <input type="checkbox" checked onchange="toggleVoucherStatus(1)">
                                                    <span class="slider"></span>
                                                </label>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="flex items-center gap-4">
                                                <button class="btn-ghost" onclick="viewVoucher(1)">
                                                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                        <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5z"/>
                                                    </svg>
                                                </button>
                                                <button class="btn-ghost" onclick="editVoucher(1)">
                                                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                        <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25z"/>
                                                    </svg>
                                                </button>
                                                <button class="btn-ghost" onclick="deleteVoucher(1, 'SUMMER2024')">
                                                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                        <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12z"/>
                                                    </svg>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="flex items-center gap-8">
                                                <code style="background: #f3f4f6; padding: 4px 8px; border-radius: 4px; font-family: monospace; font-size: 12px;">NEWUSER50</code>
                                                <button class="btn-ghost" onclick="copyVoucherCode('NEWUSER50')">
                                                    <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24">
                                                        <path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/>
                                                    </svg>
                                                </button>
                                            </div>
                                        </td>
                                        <td>
                                            <div>
                                                <div class="font-medium">New User Discount</div>
                                                <div class="text-sm text-gray-500">Fixed $50 discount for first-time users</div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="flex items-center gap-4">
                                                <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z"/>
                                                </svg>
                                                <span class="font-medium">$50</span>
                                            </div>
                                            <div class="text-xs text-gray-500">Min: $200</div>
                                        </td>
                                        <td>
                                            <div class="text-sm">
                                                <div class="font-medium">234 / 500</div>
                                                <div class="progress-bar mt-4">
                                                    <div class="progress-fill" style="width: 47%;"></div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="text-sm">
                                            <div>
                                                <div class="flex items-center text-xs text-gray-500">
                                                    <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24" style="margin-right: 4px;">
                                                        <path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"/>
                                                    </svg>
                                                    From
                                                </div>
                                                <div>2024-01-01</div>
                                                <div class="flex items-center text-xs text-gray-500 mt-4">
                                                    <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24" style="margin-right: 4px;">
                                                        <path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"/>
                                                    </svg>
                                                    To
                                                </div>
                                                <div>2024-12-31</div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="flex items-center gap-8">
                                                <span class="badge success">Active</span>
                                                <label class="switch">
                                                    <input type="checkbox" checked onchange="toggleVoucherStatus(2)">
                                                    <span class="slider"></span>
                                                </label>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="flex items-center gap-4">
                                                <button class="btn-ghost" onclick="viewVoucher(2)">
                                                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                        <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5z"/>
                                                    </svg>
                                                </button>
                                                <button class="btn-ghost" onclick="editVoucher(2)">
                                                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                        <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25z"/>
                                                    </svg>
                                                </button>
                                                <button class="btn-ghost" onclick="deleteVoucher(2, 'NEWUSER50')">
                                                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                        <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12z"/>
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

    <!-- Create Voucher Modal -->
    <div id="createVoucherModal" class="modal-overlay" style="display: none;">
        <div class="modal" style="max-width: 600px;">
            <div class="modal-header">
                <h3 class="modal-title">Create New Voucher</h3>
                <p class="modal-description">Set up a new discount voucher with specific terms and conditions</p>
            </div>
            <div class="modal-content">
                <form id="createVoucherForm">
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label class="form-label">Voucher Code</label>
                            <input type="text" class="form-input" name="code" placeholder="e.g., SUMMER2024" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Voucher Name</label>
                            <input type="text" class="form-input" name="name" placeholder="e.g., Summer Special" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Description</label>
                        <textarea class="form-textarea" name="description" placeholder="Brief description of the voucher" required></textarea>
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label class="form-label">Discount Type</label>
                            <select class="form-select" name="type" onchange="updateDiscountLabel()" required>
                                <option value="percentage">Percentage</option>
                                <option value="fixed">Fixed Amount</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label class="form-label" id="discountLabel">Percentage (%)</label>
                            <input type="number" class="form-input" name="value" placeholder="20" required>
                        </div>
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label class="form-label">Minimum Order Amount ($)</label>
                            <input type="number" class="form-input" name="minAmount" placeholder="100" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Usage Limit</label>
                            <input type="number" class="form-input" name="usageLimit" placeholder="100" required>
                        </div>
                    </div>
                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                        <div class="form-group">
                            <label class="form-label">Start Date</label>
                            <input type="date" class="form-input" name="startDate" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">End Date</label>
                            <input type="date" class="form-input" name="endDate" required>
                        </div>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeCreateVoucherModal()">Cancel</button>
                <button class="btn btn-primary" onclick="saveVoucher()">Create Voucher</button>
            </div>
        </div>
    </div>

    <!-- Delete Voucher Modal -->
    <div id="deleteVoucherModal" class="modal-overlay" style="display: none;">
        <div class="modal">
            <div class="modal-header">
                <h3 class="modal-title">Delete Voucher</h3>
                <p class="modal-description">Are you sure you want to delete this voucher? This action cannot be undone.</p>
            </div>
            <div class="modal-footer">
                <button class="btn btn-secondary" onclick="closeDeleteVoucherModal()">Cancel</button>
                <button class="btn btn-danger" onclick="confirmDeleteVoucher()">Delete Voucher</button>
            </div>
        </div>
    </div>

    <style>
        /* Switch Toggle Styles */
        .switch {
            position: relative;
            display: inline-block;
            width: 44px;
            height: 24px;
        }

        .switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 24px;
        }

        .slider:before {
            position: absolute;
            content: "";
            height: 18px;
            width: 18px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }

        input:checked + .slider {
            background-color: #2563eb;
        }

        input:checked + .slider:before {
            transform: translateX(20px);
        }
    </style>

    <script>
        let currentVoucherId = null;
        let currentVoucherCode = null;

        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            sidebar.classList.toggle('open');
        }

        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = 'login.jsp';
            }
        }

        function openCreateVoucherModal() {
            document.getElementById('createVoucherModal').style.display = 'flex';
        }

        function closeCreateVoucherModal() {
            document.getElementById('createVoucherModal').style.display = 'none';
            document.getElementById('createVoucherForm').reset();
        }

        function updateDiscountLabel() {
            const typeSelect = document.querySelector('select[name="type"]');
            const label = document.getElementById('discountLabel');
            label.textContent = typeSelect.value === 'percentage' ? 'Percentage (%)' : 'Amount ($)';
        }

        function saveVoucher() {
            const form = document.getElementById('createVoucherForm');
            const formData = new FormData(form);
            
            console.log('Creating voucher:', Object.fromEntries(formData));
            alert('Voucher created successfully!');
            closeCreateVoucherModal();
        }

        function copyVoucherCode(code) {
            navigator.clipboard.writeText(code).then(function() {
                alert('Voucher code copied to clipboard!');
            });
        }

        function toggleVoucherStatus(voucherId) {
            console.log('Toggle voucher status for ID:', voucherId);
            // Implement toggle functionality
        }

        function viewVoucher(voucherId) {
            alert('View voucher details for ID: ' + voucherId);
        }

        function editVoucher(voucherId) {
            alert('Edit voucher for ID: ' + voucherId);
        }

        function deleteVoucher(voucherId, voucherCode) {
            currentVoucherId = voucherId;
            currentVoucherCode = voucherCode;
            document.getElementById('deleteVoucherModal').style.display = 'flex';
        }

        function closeDeleteVoucherModal() {
            document.getElementById('deleteVoucherModal').style.display = 'none';
            currentVoucherId = null;
            currentVoucherCode = null;
        }

        function confirmDeleteVoucher() {
            alert(`Voucher ${currentVoucherCode} has been deleted`);
            closeDeleteVoucherModal();
        }

        // Search functionality
        document.getElementById('searchVouchers').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const table = document.getElementById('vouchersTable');
            const rows = table.getElementsByTagName('tr');
            
            for (let i = 1; i < rows.length; i++) {
                const row = rows[i];
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(searchTerm) ? '' : 'none';
            }
        });

        // Filter functionality
        document.getElementById('typeFilter').addEventListener('change', filterTable);
        document.getElementById('statusFilter').addEventListener('change', filterTable);

        function filterTable() {
            const typeFilter = document.getElementById('typeFilter').value;
            const statusFilter = document.getElementById('statusFilter').value;
            const table = document.getElementById('vouchersTable');
            const rows = table.getElementsByTagName('tr');
            
            for (let i = 1; i < rows.length; i++) {
                const row = rows[i];
                const discountCell = row.cells[2];
                const statusCell = row.cells[5];
                
                const discountText = discountCell.textContent.toLowerCase();
                const statusText = statusCell.textContent.toLowerCase();
                
                const typeMatch = typeFilter === 'all' || 
                    (typeFilter === 'percentage' && discountText.includes('%')) ||
                    (typeFilter === 'fixed' && discountText.includes('$'));
                const statusMatch = statusFilter === 'all' || statusText.includes(statusFilter);
                
                row.style.display = (typeMatch && statusMatch) ? '' : 'none';
            }
        }

        // Close modals when clicking outside
        window.addEventListener('click', function(event) {
            const createModal = document.getElementById('createVoucherModal');
            const deleteModal = document.getElementById('deleteVoucherModal');
            
            if (event.target === createModal) {
                closeCreateVoucherModal();
            }
            if (event.target === deleteModal) {
                closeDeleteVoucherModal();
            }
        });
    </script>
</body>
</html>
