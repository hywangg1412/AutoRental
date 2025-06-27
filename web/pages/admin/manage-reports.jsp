<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports & Analytics - AutoRental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
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
                <a href="manage-reports.jsp" class="nav-item active">
                    <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
                        <path d="M14 2H6c-1.1 0-1.99.9-1.99 2L4 20c0 1.1.89 2 2 2h12c1.1 0 2-.9 2-2V8l-6-6z"/>
                    </svg>
                    Reports
                </a>
                <a href="manage-vouchers.jsp" class="nav-item">
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
                        <select class="form-select" id="dateRange">
                            <option value="7days">Last 7 days</option>
                            <option value="30days" selected>Last 30 days</option>
                            <option value="90days">Last 90 days</option>
                            <option value="1year">Last year</option>
                        </select>
                        <button class="btn btn-primary">
                            <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/>
                            </svg>
                            Export Report
                        </button>
                    </div>
                </div>
            </header>

            <!-- Page Content -->
            <main class="page-content">
                <div class="page-header">
                    <h1 class="page-title">Reports & Analytics</h1>
                    <p class="page-description">View comprehensive business insights and statistics</p>
                </div>

                <!-- Key Metrics -->
                <div class="stats-grid">
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Total Revenue</span>
                            <svg class="stat-icon green" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2z"/>
                            </svg>
                        </div>
                        <div class="stat-value">$324,500</div>
                        <div class="stat-change positive">
                            <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M7 14l5-5 5 5z"/>
                            </svg>
                            +12.5% from last month
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Total Users</span>
                            <svg class="stat-icon blue" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M16 7c0-2.21-1.79-4-4-4S8 4.79 8 7s1.79 4 4 4 4-1.79 4-4z"/>
                            </svg>
                        </div>
                        <div class="stat-value">1,245</div>
                        <div class="stat-change positive">
                            <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M7 14l5-5 5 5z"/>
                            </svg>
                            +8.2% from last month
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Total Bookings</span>
                            <svg class="stat-icon purple" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M19 3h-1V1h-2v2H8V1H6v2H5c-1.11 0-1.99.9-1.99 2L3 19c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2z"/>
                            </svg>
                        </div>
                        <div class="stat-value">892</div>
                        <div class="stat-change positive">
                            <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M7 14l5-5 5 5z"/>
                            </svg>
                            +15.3% from last month
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-header">
                            <span class="stat-title">Fleet Utilization</span>
                            <svg class="stat-icon orange" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.22.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99z"/>
                            </svg>
                        </div>
                        <div class="stat-value">78.5%</div>
                        <div class="stat-change negative">
                            <svg width="12" height="12" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M7 10l5 5 5-5z"/>
                            </svg>
                            -2.1% from last month
                        </div>
                    </div>
                </div>

                <!-- Charts Section -->
                <div class="grid" style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; margin-bottom: 24px;">
                    <div class="card">
                        <div class="card-header">
                            <h2 class="card-title">Monthly Revenue Trend</h2>
                            <p class="card-description">Revenue performance over the last 12 months</p>
                        </div>
                        <div class="card-content">
                            <canvas id="revenueChart" width="400" height="200"></canvas>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">
                            <h2 class="card-title">User Growth</h2>
                            <p class="card-description">New user registrations over time</p>
                        </div>
                        <div class="card-content">
                            <canvas id="userGrowthChart" width="400" height="200"></canvas>
                        </div>
                    </div>
                </div>

                <!-- Revenue Breakdown -->
                <div class="card mb-6">
                    <div class="card-header">
                        <h2 class="card-title">Revenue Breakdown</h2>
                        <p class="card-description">Detailed revenue analysis by category</p>
                    </div>
                    <div class="card-content">
                        <div class="grid" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px;">
                            <div class="text-center">
                                <div class="stat-value" style="color: #10b981;">$245,000</div>
                                <div class="text-sm text-gray-600">Car Rentals</div>
                                <div class="text-xs" style="color: #10b981;">+18.2%</div>
                            </div>
                            <div class="text-center">
                                <div class="stat-value" style="color: #3b82f6;">$52,000</div>
                                <div class="text-sm text-gray-600">Insurance</div>
                                <div class="text-xs" style="color: #3b82f6;">+12.5%</div>
                            </div>
                            <div class="text-center">
                                <div class="stat-value" style="color: #8b5cf6;">$27,500</div>
                                <div class="text-sm text-gray-600">Additional Services</div>
                                <div class="text-xs" style="color: #8b5cf6;">+8.9%</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Top Performing Cars -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">Top Performing Cars</h2>
                        <p class="card-description">Most popular vehicles by bookings</p>
                    </div>
                    <div class="card-content">
                        <div class="table-container">
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Car Model</th>
                                        <th>Bookings</th>
                                        <th>Revenue</th>
                                        <th>Utilization</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="font-medium">Toyota Corolla</td>
                                        <td>156</td>
                                        <td class="font-medium">$15,600</td>
                                        <td>
                                            <div class="flex items-center gap-8">
                                                <span>85%</span>
                                                <div class="progress-bar" style="width: 64px;">
                                                    <div class="progress-fill" style="width: 85%;"></div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="font-medium">Honda Civic</td>
                                        <td>142</td>
                                        <td class="font-medium">$14,200</td>
                                        <td>
                                            <div class="flex items-center gap-8">
                                                <span>82%</span>
                                                <div class="progress-bar" style="width: 64px;">
                                                    <div class="progress-fill" style="width: 82%;"></div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="font-medium">BMW 3 Series</td>
                                        <td>98</td>
                                        <td class="font-medium">$19,600</td>
                                        <td>
                                            <div class="flex items-center gap-8">
                                                <span>78%</span>
                                                <div class="progress-bar" style="width: 64px;">
                                                    <div class="progress-fill" style="width: 78%;"></div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="font-medium">Chevrolet Malibu</td>
                                        <td>89</td>
                                        <td class="font-medium">$8,900</td>
                                        <td>
                                            <div class="flex items-center gap-8">
                                                <span>75%</span>
                                                <div class="progress-bar" style="width: 64px;">
                                                    <div class="progress-fill" style="width: 75%;"></div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="font-medium">Tesla Model 3</td>
                                        <td>76</td>
                                        <td class="font-medium">$11,400</td>
                                        <td>
                                            <div class="flex items-center gap-8">
                                                <span>72%</span>
                                                <div class="progress-bar" style="width: 64px;">
                                                    <div class="progress-fill" style="width: 72%;"></div>
                                                </div>
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

        // Initialize Charts
        document.addEventListener('DOMContentLoaded', function() {
            // Revenue Chart
            const revenueCtx = document.getElementById('revenueChart').getContext('2d');
            new Chart(revenueCtx, {
                type: 'bar',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                    datasets: [{
                        label: 'Revenue ($)',
                        data: [12000, 15000, 18000, 22000, 25000, 28000, 32000, 35000, 30000, 28000, 26000, 24000],
                        backgroundColor: '#3b82f6',
                        borderRadius: 4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function(value) {
                                    return '$' + value.toLocaleString();
                                }
                            }
                        }
                    }
                }
            });

            // User Growth Chart
            const userCtx = document.getElementById('userGrowthChart').getContext('2d');
            new Chart(userCtx, {
                type: 'line',
                data: {
                    labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
                    datasets: [{
                        label: 'New Users',
                        data: [120, 145, 168, 192, 218, 245, 272, 298, 325, 352, 378, 405],
                        borderColor: '#8b5cf6',
                        backgroundColor: 'rgba(139, 92, 246, 0.1)',
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        });

        // Date range change handler
        document.getElementById('dateRange').addEventListener('change', function(e) {
            console.log('Date range changed to:', e.target.value);
            // Here you would typically reload the data based on the selected date range
        });
    </script>
</body>
</html>
