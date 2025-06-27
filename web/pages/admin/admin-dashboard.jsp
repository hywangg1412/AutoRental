<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - AutoRental</title>
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
                <a href="admin-dashboard.jsp" class="nav-item active">
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
                    <h1 class="page-title">Dashboard</h1>
                    <p class="page-description">Welcome back, Quang Huy</p>
                </div>

                <!-- Stats Cards -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Total Revenue</span>
                            <svg class="stat-icon green" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M7 14l5-5 5 5z"/>
                            </svg>
                        </div>
                        <div class="stat-value">$8,450</div>
                        <div class="stat-change positive">
                            <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M7 14l5-5 5 5z"/>
                            </svg>
                            +12.5% from last month
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Active Bookings</span>
                            <svg class="stat-icon blue" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 3c1.66 0 3 1.34 3 3s-1.34 3-3 3-3-1.34-3-3 1.34-3 3-3zm6 12H4v-1c0-2 4-3.1 6-3.1s6 1.1 6 3.1v1z"/>
                            </svg>
                        </div>
                        <div class="stat-value">150</div>
                        <div class="stat-change positive">
                            <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M7 14l5-5 5 5z"/>
                            </svg>
                            +8.2% from last week
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Total Cars</span>
                            <svg class="stat-icon purple" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.22.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99z"/>
                            </svg>
                        </div>
                        <div class="stat-value">243</div>
                        <div class="stat-change negative">
                            <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M7 10l5 5 5-5z"/>
                            </svg>
                            -2.1% from last month
                        </div>
                    </div>

                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Available Cars</span>
                            <svg class="stat-icon orange" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                            </svg>
                        </div>
                        <div class="stat-value">89</div>
                        <div class="stat-change positive">
                            <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M7 14l5-5 5 5z"/>
                            </svg>
                            +15.3% from last week
                        </div>
                    </div>
                </div>

                <!-- Car Bookings Table -->
                <div class="card">
                    <div class="card-header">
                        <div class="flex items-center justify-between">
                            <div>
                                <h2 class="card-title">Car Bookings</h2>
                                <p class="card-description">Recent booking activities</p>
                            </div>
                            <div class="flex items-center gap-4">
                                <div class="search-box">
                                    <svg class="search-icon" fill="currentColor" viewBox="0 0 24 24">
                                        <path d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"/>
                                    </svg>
                                    <input type="text" class="search-input" placeholder="Search client name, car, etc...">
                                </div>
                                <button class="btn btn-secondary">
                                    <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                        <path d="M10 18h4v-2h-4v2zM3 6v2h18V6H3zm3 7h12v-2H6v2z"/>
                                    </svg>
                                    Filter
                                </button>
                            </div>
                        </div>
                    </div>
                    <div class="card-content">
                        <div class="table-container">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Booking ID</th>
                                        <th>Booking Date</th>
                                        <th>Client Name</th>
                                        <th>Car Model</th>
                                        <th>Plan</th>
                                        <th>Date</th>
                                        <th>Payment</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td><span class="text-blue-600 font-medium">BK-WX1001</span></td>
                                        <td>Aug 1, 2025</td>
                                        <td class="font-medium">Quang Huy</td>
                                        <td>
                                            <div>
                                                <div class="font-medium">Toyota Corolla</div>
                                                <div class="text-xs text-gray-500">TX2024</div>
                                            </div>
                                        </td>
                                        <td>2 Days</td>
                                        <td>
                                            <div>
                                                <div class="text-xs text-gray-500">Start</div>
                                                <div>Aug 1, 2025</div>
                                                <div class="text-xs text-gray-500">End</div>
                                                <div>Aug 3, 2025</div>
                                            </div>
                                        </td>
                                        <td class="font-medium">$90</td>
                                        <td><span class="badge info">Confirmed</span></td>
                                    </tr>
                                    <tr>
                                        <td><span class="text-blue-600 font-medium">BK-WX1002</span></td>
                                        <td>Aug 1, 2025</td>
                                        <td class="font-medium">Quang Huy</td>
                                        <td>
                                            <div>
                                                <div class="font-medium">Toyota Corolla</div>
                                                <div class="text-xs text-gray-500">TX2024</div>
                                            </div>
                                        </td>
                                        <td>7 Days</td>
                                        <td>
                                            <div>
                                                <div class="text-xs text-gray-500">Start</div>
                                                <div>Aug 1, 2025</div>
                                                <div class="text-xs text-gray-500">End</div>
                                                <div>Aug 8, 2025</div>
                                            </div>
                                        </td>
                                        <td class="font-medium">$350</td>
                                        <td><span class="badge success">Ongoing</span></td>
                                    </tr>
                                    <tr>
                                        <td><span class="text-blue-600 font-medium">BK-WX1003</span></td>
                                        <td>Aug 1, 2025</td>
                                        <td class="font-medium">Quang Huy</td>
                                        <td>
                                            <div>
                                                <div class="font-medium">Chevrolet Malibu</div>
                                                <div class="text-xs text-gray-500">CX2024</div>
                                            </div>
                                        </td>
                                        <td>3 Days</td>
                                        <td>
                                            <div>
                                                <div class="text-xs text-gray-500">Start</div>
                                                <div>Aug 2, 2025</div>
                                                <div class="text-xs text-gray-500">End</div>
                                                <div>Aug 5, 2025</div>
                                            </div>
                                        </td>
                                        <td class="font-medium">$180</td>
                                        <td><span class="badge success">Ongoing</span></td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script>
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            sidebar.classList.toggle('open');
        }

        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = 'login.jsp';
            }
        }

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
