<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard - AutoRental</title>

    <!-- Bootstrap CSS -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/admin-style.css"
    />

    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap"
      rel="stylesheet"
    />
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
     <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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
    <style>
      .stats-table th,
      .stats-table td {
        text-align: center;
        vertical-align: middle;
      }
      .chart-container {
        display: flex;
        flex-wrap: wrap;
        gap: 32px;
        justify-content: center;
        margin-top: 32px;
      }
      .chart-box {
        background: #fff;
        border-radius: 16px;
        box-shadow: 0 2px 8px #0001;
        padding: 24px;
        min-width: 340px;
      }
    </style>
  </head>
  <body style="background: #f4f6fa">
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
            class="nav-item active"
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
          <a
            href="${pageContext.request.contextPath}/pages/admin/contract-details.jsp"
            class="nav-item "
          >
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M16.5 3a2.5 2.5 0 0 1 3.54 3.54l-12.5 12.5-4.24 1.06 1.06-4.24L16.5 3zm2.04 2.12a.5.5 0 0 0-.71 0l-1.34 1.34 1.71 1.71 1.34-1.34a.5.5 0 0 0 0-.71l-1-1zm-2.75 2.75L5 16.66V19h2.34l10.79-10.79-1.34-1.34z"
              />
            </svg>
            Contract Details
          </a>
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
    <div class="container py-4">
      <h1 class="mb-4">AutoRental System Overview</h1>
      <table class="table table-bordered stats-table">
        <thead class="table-dark">
          <tr>
            <th></th>
            <th>Total</th>
            <th>Active</th>
            <th>Banned</th>
            <th>Disabled/Inactive</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <th>User</th>
            <td>${userCount}</td>
            <td>${userActive}</td>
            <td>${userBanned}</td>
            <td>${userDisabled}</td>
          </tr>
          <tr>
            <th>Staff</th>
            <td>${staffCount}</td>
            <td>${staffActive}</td>
            <td>${staffBanned}</td>
            <td>${staffDisabled}</td>
          </tr>
          <tr>
            <th>Voucher</th>
            <td>${voucherCount}</td>
            <td>${voucherActive}</td>
            <td colspan="2">${voucherInactive}</td>
          </tr>
          <tr>
            <th>Car</th>
            <td colspan="4">${carCount}</td>
          </tr>
        </tbody>
      </table>

      <div class="chart-container">
        <div class="chart-box">
          <h5>Total Comparison</h5>
          <canvas id="barChart" width="350" height="300"></canvas>
        </div>
        <div class="chart-box">
          <h5>User Status Ratio</h5>
          <canvas id="userPie" width="300" height="300"></canvas>
        </div>
        <div class="chart-box">
          <h5>Staff Status Ratio</h5>
          <canvas id="staffPie" width="300" height="300"></canvas>
        </div>
        <div class="chart-box">
          <h5>Voucher Status Ratio</h5>
          <canvas id="voucherPie" width="300" height="300"></canvas>
        </div>
      </div>

      <h2 class="mt-5 mb-3">Monthly Statistics (Last 12 Months)</h2>
      <div class="chart-container">
        <div class="chart-box" style="flex: 2; min-width: 600px">
          <h5>Monthly Comparison Chart: User, Car, Voucher</h5>
          <canvas id="monthBarChart" width="600" height="350"></canvas>
        </div>
      </div>

      <div class="chart-container">
        <div class="chart-box" style="flex: 2; min-width: 600px">
          <h5>Monthly Revenue Chart</h5>
          <canvas id="revenueLineChart" width="600" height="350"></canvas>
        </div>
      </div>
    </div>
    <script type="application/json" id="monthLabelsJson">
      ${monthLabelsJson}
    </script>
    <script type="application/json" id="userByMonthJson">
      ${userByMonthJson}
    </script>
    <script type="application/json" id="carByMonthJson">
      ${carByMonthJson}
    </script>
    <script type="application/json" id="voucherByMonthJson">
      ${voucherByMonthJson}
    </script>
    <script type="application/json" id="revenueByMonthJson">
      ${revenueByMonthJson}
    </script>
    <script>
      // Bar chart: Tổng số User, Staff, Car, Voucher
      new Chart(document.getElementById('barChart'), {
        type: 'bar',
        data: {
          labels: ['User', 'Staff', 'Car', 'Voucher'],
          datasets: [{
            label: 'Quantity',
            data: [${userCount}, ${staffCount}, ${carCount}, ${voucherCount}],
            backgroundColor: [
              'rgba(54, 162, 235, 0.8)',
              'rgba(255, 99, 132, 0.8)',
              'rgba(75, 192, 192, 0.8)',
              'rgba(255, 206, 86, 0.8)'
            ],
            borderRadius: 8
          }]
        },
        options: {
          responsive: true,
          plugins: {
            legend: { display: false },
            tooltip: { enabled: true }
          },
          scales: {
            y: { beginAtZero: true }
          }
        }
      });
      // Pie chart: User
      new Chart(document.getElementById('userPie'), {
        type: 'doughnut',
        data: {
          labels: ['Active', 'Banned', 'Disabled'],
          datasets: [{
            data: [${userActive}, ${userBanned}, ${userDisabled}],
            backgroundColor: [
              'rgba(54, 162, 235, 0.8)',
              'rgba(255, 99, 132, 0.8)',
              'rgba(201, 203, 207, 0.8)'
            ],
            borderWidth: 1
          }]
        },
        options: {
          plugins: {
            legend: { position: 'bottom' },
            tooltip: { enabled: true }
          }
        }
      });
      // Pie chart: Staff
      new Chart(document.getElementById('staffPie'), {
        type: 'doughnut',
        data: {
          labels: ['Active', 'Banned', 'Disabled'],
          datasets: [{
            data: [${staffActive}, ${staffBanned}, ${staffDisabled}],
            backgroundColor: [
              'rgba(255, 99, 132, 0.8)',
              'rgba(54, 162, 235, 0.8)',
              'rgba(201, 203, 207, 0.8)'
            ],
            borderWidth: 1
          }]
        },
        options: {
          plugins: {
            legend: { position: 'bottom' },
            tooltip: { enabled: true }
          }
        }
      });
      // Pie chart: Voucher
      new Chart(document.getElementById('voucherPie'), {
        type: 'doughnut',
        data: {
          labels: ['Active', 'Inactive'],
          datasets: [{
            data: [${voucherActive}, ${voucherInactive}],
            backgroundColor: [
              'rgba(255, 206, 86, 0.8)',
              'rgba(201, 203, 207, 0.8)'
            ],
            borderWidth: 1
          }]
        },
        options: {
          plugins: {
            legend: { position: 'bottom' },
            tooltip: { enabled: true }
          }
        }
      });
      // Biểu đồ so sánh theo tháng
      const monthLabels = JSON.parse(document.getElementById('monthLabelsJson').innerHTML.trim());
      const userByMonth = JSON.parse(document.getElementById('userByMonthJson').innerHTML.trim());
      const carByMonth = JSON.parse(document.getElementById('carByMonthJson').innerHTML.trim());
      const voucherByMonth = JSON.parse(document.getElementById('voucherByMonthJson').innerHTML.trim());
      new Chart(document.getElementById('monthBarChart'), {
        type: 'bar',
        data: {
          labels: monthLabels,
          datasets: [
            {
              label: 'User',
              data: userByMonth,
              backgroundColor: 'rgba(54, 162, 235, 0.8)'
            },
            {
              label: 'Car',
              data: carByMonth,
              backgroundColor: 'rgba(75, 192, 192, 0.8)'
            },
            {
              label: 'Voucher',
              data: voucherByMonth,
              backgroundColor: 'rgba(255, 206, 86, 0.8)'
            }
          ]
        },
        options: {
          responsive: true,
          plugins: {
            legend: { position: 'top' },
            tooltip: { enabled: true }
          },
          scales: {
            y: { beginAtZero: true }
          }
        }
      });
      const revenueByMonth = JSON.parse(document.getElementById('revenueByMonthJson').innerHTML.trim());
      // Vẽ biểu đồ doanh thu các tháng
      new Chart(document.getElementById('revenueLineChart'), {
        type: 'line',
        data: {
          labels: monthLabels,
          datasets: [{
            label: 'Revenue (VND)',
            data: revenueByMonth,
            borderColor: 'rgba(255, 99, 132, 1)',
            backgroundColor: 'rgba(255, 99, 132, 0.2)',
            tension: 0.3,
            fill: true,
            pointRadius: 4,
            pointBackgroundColor: 'rgba(255, 99, 132, 1)'
          }]
        },
        options: {
          responsive: true,
          plugins: {
            legend: { position: 'top' },
            tooltip: { enabled: true }
          },
          scales: {
            y: {
              beginAtZero: true,
              ticks: {
                callback: function(value) {
                  return value.toLocaleString('en-US') + ' VND';
                }
              }
            }
          }
        }
      });
    </script>
  </body>
</html>
