<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Car Management - AutoRental</title>
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
          <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-item">
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/>
            </svg>
            Dashboard
          </a>
          <a href="${pageContext.request.contextPath}/admin/user-management" class="nav-item">
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path d="M16 7c0-2.21-1.79-4-4-4S8 4.79 8 7s1.79 4 4 4 4-1.79 4-4zm-4 6c-2.67 0-8 1.34-8 4v3h16v-3c0-2.66-5.33-4-8-4z"/>
            </svg>
            Users
          </a>
          <a href="${pageContext.request.contextPath}/manageCarsServlet" class="nav-item active">
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.22.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99z"/>
            </svg>
            Cars
          </a>
          <a href="${pageContext.request.contextPath}/admin/manage-staff" class="nav-item">
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
          <a href="${pageContext.request.contextPath}/discount" class="nav-item">
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path d="M21.41 11.58l-9-9C12.05 2.22 11.55 2 11 2H4c-1.1 0-2 .9-2 2v7c0 .55.22 1.05.59 1.42l9 9c.36.36.86.58 1.41.58.55 0 1.05-.22 1.41-.59l7-7c.37-.36.59-.86.59-1.41 0-.55-.23-1.06-.59-1.42zM5.5 7C4.67 7 4 6.33 4 5.5S4.67 4 5.5 4 7 4.67 7 5.5 6.33 7 5.5 7z"/>
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
                  <img src="${not empty sessionScope.user.avatarUrl ? sessionScope.user.avatarUrl : pageContext.request.contextPath.concat('/assets/images/default-avatar.png')}"
                       alt="User Avatar" width="32" height="32" class="rounded-circle"
                       onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-avatar.png';">
                </div>
                <div class="user-details">
                  <h4>${sessionScope.user.username}</h4>
                  <p>Administrator</p>
                </div>
              </div>
            </div>
          </div>
        </header>

            <main class="page-content">
                <div class="page-header">
                    <div class="flex items-center justify-between">
                        <div>
                            <h1 class="page-title">Car Management</h1>
                            <p class="page-description">Manage your car fleet and inventory</p>
                        </div>
                        <div style="display: flex; gap: 10px;">
                        <button class="btn btn-primary" onclick="openModal('add')">
                            <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/>
                            </svg>
                            Add Car
                        </button>
                        </div>
                    </div>
                    <div style="display: flex; gap: 12px; align-items: center; margin-top: 18px; flex-wrap: wrap;">
                        <select id="carBrandFilter" style="padding: 8px 12px; border-radius: 6px; border: 1px solid #ccc;">
                            <option value="all">All Brands</option>
                            <c:forEach var="brand" items="${brandList}">
                                <option value="${brand.brandId}" ${param.brandId == brand.brandId ? 'selected' : ''}>${brand.brandName}</option>
                            </c:forEach>
                        </select>
                        <select id="carStatusFilter" style="padding: 8px 12px; border-radius: 6px; border: 1px solid #ccc;">
                            <option value="all">All Status</option>
                            <option value="Available" ${param.status == 'Available' ? 'selected' : ''}>Available</option>
                            <option value="Rented" ${param.status == 'Rented' ? 'selected' : ''}>Rented</option>
                            <option value="Unavailable" ${param.status == 'Unavailable' ? 'selected' : ''}>Unavailable</option>
                        </select>
                        <select id="carFuelFilter" style="padding: 8px 12px; border-radius: 6px; border: 1px solid #ccc;">
                            <option value="all">All Fuel</option>
                            <option value="Xăng" ${param.fuel == 'Xăng' ? 'selected' : ''}>Petrol (Xăng)</option>
                            <option value="Dầu" ${param.fuel == 'Dầu' ? 'selected' : ''}>Diesel (Dầu)</option>
                            <option value="Điện" ${param.fuel == 'Điện' ? 'selected' : ''}>Electric (Điện)</option>
                        </select>
                        <select id="carTransmissionFilter" style="padding: 8px 12px; border-radius: 6px; border: 1px solid #ccc;">
                            <option value="all">All Transmission</option>
                            <option value="Số tự động" ${param.transmission == 'Số tự động' ? 'selected' : ''}>Automatic (Số tự động)</option>
                            <option value="Số sàn" ${param.transmission == 'Số sàn' ? 'selected' : ''}>Manual (Số sàn)</option>
                        </select>
                        <input type="number" id="carPriceMin" placeholder="Min Price/Day" value="${param.priceMin != null ? param.priceMin : ''}" style="width: 120px; padding: 8px 12px; border-radius: 6px; border: 1px solid #ccc;" />
                        <input type="number" id="carPriceMax" placeholder="Max Price/Day" value="${param.priceMax != null ? param.priceMax : ''}" style="width: 120px; padding: 8px 12px; border-radius: 6px; border: 1px solid #ccc;" />
                        <button class="btn btn-secondary" onclick="applyCarFilters()" type="button">Filter</button>
                    </div>
                </div>

                <!-- Alerts -->
                <c:if test="${not empty param.error || not empty param.success}">
                    <div class="alert ${not empty param.error ? 'alert-error' : 'alert-success'}" id="alertBox">
                        <svg width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
                            <path ${not empty param.error ? 'd="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"' : 'd="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"'}/>
                        </svg>
                        <span>${param.error != null ? param.error : param.success}</span>
                        <button class="alert-close" onclick="this.parentElement.style.display='none'">×</button>
                    </div>
                </c:if>

                <!-- Cars Table -->
                <div class="card">
                    <div class="card-header">
                        <h2 class="card-title">All Cars</h2>
                        <p class="card-description">Manage and monitor your car fleet</p>
                        
                    </div>
                    <div class="card-content">
                        <c:choose>
                            <c:when test="${not empty carList}">
                                <table class="data-table" id="carsTable">
                                    <thead>
                                        <tr>
                                            <th>Image</th>
                                            <th>Car</th>
                                            <th>Brand</th>
                                            <th>Transmission</th>
                                            <th>Fuel</th>
                                            <th>Year</th>
                                            <th>Seats</th>
                                            <th>Price/Day</th>
                                            <th>Price/Hour</th>
                                            <th>Price/Month</th>
                                            <th>Status</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="car" items="${carList}">
                                            <tr>
                                                <td>
                                                    <img src="${pageContext.request.contextPath}/${car.mainImageUrl != null ? car.mainImageUrl : 'images/car-default.jpg'}" 
                                                         alt="Car Image" class="car-image" loading="lazy" 
                                                         onerror="this.src='${pageContext.request.contextPath}/images/car-default.jpg'">
                                                </td>
                                                <td>
                                                    <div>
                                                        <div class="font-medium">${car.carModel != null ? car.carModel : 'N/A'}</div>
                                                        <div class="text-sm text-gray-500">${car.carId}</div>
                                                    </div>
                                                </td>
                                                <td>${car.brandName != null ? car.brandName : 'N/A'}</td>
                                                <td><span class="badge info">${car.transmissionTypeName != null ? car.transmissionTypeName : 'N/A'}</span></td>
                                                <td><span class="badge info">${car.fuelName != null ? car.fuelName : 'N/A'}</span></td>
                                                <td>${car.yearManufactured != null ? car.yearManufactured : 'N/A'}</td>
                                                <td>${car.seats > 0 ? car.seats : 'N/A'}</td>
                                                <td class="font-medium price-column">$${car.pricePerDay != null ? car.pricePerDay.intValue() : 0}000</td>
                                                <td class="font-medium price-column">$${car.pricePerHour != null ? car.pricePerHour.intValue() : 0}000</td>
                                                <td class="font-medium price-column">$${car.pricePerMonth != null && car.pricePerMonth > 0 ? car.pricePerMonth.intValue() : 0}000</td>
                                                <td><span class="badge ${car.statusCssClass != null ? car.statusCssClass : 'unknown'}">${car.statusDisplay != null ? car.statusDisplay : 'N/A'}</span></td>
                                                <td>
                                                    <div class="flex items-center gap-4">
                                                        <button class="btn-ghost" onclick="openModal('edit', '${car.carId}')">
                                                            <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                                <path d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"/>
                                                            </svg>
                                                        </button>
                                                        <a href="${pageContext.request.contextPath}/pages/admin/upload-images.jsp?carId=${car.carId}" class="btn-ghost" title="Upload Images">
                                                            <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                                <path d="M21 19V5c0-1.1-.9-2-2-2H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2zM8.5 13.5l2.5 3.01L14.5 12l4.5 6H5l3.5-4.5z"/>
                                                            </svg>
                                                        </a>
                                                        <button class="btn-ghost" onclick="deleteCar('${car.carId}', '${car.carModel}')">
                                                            <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                                <path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/>
                                                            </svg>
                                                        </button>
                                                        <a class="btn-ghost" title="Tính năng xe" href="${pageContext.request.contextPath}/FeatureCarServlet?carId=${car.carId}&carModel=${car.carModel}">
                                                            <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
                                                                <circle cx="12" cy="12" r="10" stroke="currentColor" stroke-width="2" fill="none"/>
                                                                <path d="M8 12l2 2 4-4" stroke="currentColor" stroke-width="2" fill="none"/>
                                                            </svg>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:when>
                            <c:otherwise>
                                <div class="empty-state">
                                    <p>No cars available. Please add a new car.</p>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <!-- Pagination -->
                        <div class="pagination-wrapper" style="display:flex;justify-content:center;margin-top:32px;">
                          <c:if test="${totalPages > 1}">
                            <ul class="pagination">
                              <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                  <a href="${pageContext.request.contextPath}/manageCarsServlet?page=${currentPage - 1}" class="page-link" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                  </a>
                                </li>
                              </c:if>
                              <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${i == currentPage ? 'active' : ''}">
                                  <a href="${pageContext.request.contextPath}/manageCarsServlet?page=${i}" class="page-link">${i}</a>
                                </li>
                              </c:forEach>
                              <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                  <a href="${pageContext.request.contextPath}/manageCarsServlet?page=${currentPage + 1}" class="page-link" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                  </a>
                                </li>
                              </c:if>
                            </ul>
                          </c:if>
                        </div>
                    </div>
                </div>
            </main>
        </div>

        <!-- Modal for Add/Update Car -->
        <div class="modal" id="carModal">
            <div class="modal-content">
                <div class="modal-header">
                    <h2 id="carModalTitle">Thêm Xe Mới</h2>
                    <button class="modal-close" onclick="closeModal()">×</button>
                </div>
                <form id="carForm" action="${pageContext.request.contextPath}/manageCarsServlet" method="post" autocomplete="off">
                    <input type="hidden" name="action" id="carFormAction" value="add">
                    <input type="hidden" name="carId" id="carId">

                    <div class="form-group">
                        <label for="carModel">Car Model *</label>
                        <input type="text" id="carModel" name="carModel" required maxlength="100" placeholder="Enter car model">
                    </div>

                    <div class="form-group">
                        <label for="brandId">Brand *</label>
                        <select id="brandId" name="brandId" required onchange="toggleBrandOther()">
                            <c:forEach var="brand" items="${brandList}">
                                <option value="${brand.brandId}">${brand.brandName}</option>
                            </c:forEach>
                            <option value="other">Other</option>
                        </select>
                        <input type="text" id="brandOtherInput" name="brandOtherName" placeholder="Enter new brand" style="display:none; margin-top:6px;" />
                        <small style="color: #666;">Chọn thương hiệu xe hoặc chọn Other để nhập mới</small>
                    </div>

                    <div class="form-group">
                        <label for="fuelTypeId">Fuel Type *</label>
                        <select id="fuelTypeId" name="fuelTypeId" required>
                            <option value="Xăng" selected>Petrol (Xăng)</option>
                            <option value="Dầu">Diesel (Dầu)</option>
                            <option value="Điện">Electric (Điện)</option>
                        </select>
                        <small style="color: #666;">Chọn loại nhiên liệu xe sử dụng</small>
                    </div>

                    <div class="form-group">
                        <label for="transmissionTypeId">Transmission Type *</label>
                        <select id="transmissionTypeId" name="transmissionTypeId" required>
                            <option value="Số tự động" selected>Automatic (Số tự động)</option>
                            <option value="Số sàn">Manual (Số sàn)</option>
                        </select>
                        <small style="color: #666;">Chọn loại hộp số xe</small>
                    </div>

                    <div class="form-group">
                        <label for="categoryId">Category</label>
                        <input type="text" id="categoryId" name="categoryId" placeholder="Điền phân loại xe (tùy chọn, ví dụ: Xe 4 chỗ, Xe 7 chỗ)">
                        <small style="color: #666;">Nhập phân loại xe (không bắt buộc, sẽ sử dụng Xe 4 chỗ mặc định nếu có)</small>
                    </div>

                    <div class="form-group">
                        <label for="seats">Seats *</label>
                        <input type="number" id="seats" name="seats" min="1" max="50" required placeholder="Điền số ghế (1-50)">
                    </div>

                    <div class="form-group">
                        <label for="yearManufactured">Year Manufactured *</label>
                        <input type="number" id="yearManufactured" name="yearManufactured" min="1900" max="${maxYear}" required placeholder="Điền năm sản xuất, ví dụ: 2023">
                    </div>

                    <div class="form-group">
                        <label for="licensePlate">License Plate *</label>
                        <input type="text" id="licensePlate" name="licensePlate" required maxlength="20" placeholder="Điền biển số xe, ví dụ: 30A-12345">
                    </div>

                    <div class="form-group">
                        <label for="odometer">Odometer (km) *</label>
                        <input type="number" id="odometer" name="odometer" min="0" required placeholder="Điền số km đã chạy, ví dụ: 50000">
                    </div>

                    <div class="form-group">
                        <label for="pricePerDay">Price Per Day ($) *</label>
                        <input type="number" id="pricePerDay" name="pricePerDay" step="0.01" min="0" required placeholder="Điền giá theo ngày, ví dụ: 50.00">
                    </div>

                    <div class="form-group">
                        <label for="pricePerHour">Price Per Hour ($) *</label>
                        <input type="number" id="pricePerHour" name="pricePerHour" step="0.01" min="0" required placeholder="Điền giá theo giờ, ví dụ: 5.00">
                    </div>

                    <div class="form-group">
                        <label for="pricePerMonth">Price Per Month ($)</label>
                        <input type="number" id="pricePerMonth" name="pricePerMonth" step="0.01" min="0" placeholder="Điền giá theo tháng, ví dụ: 1000.00 (tùy chọn)">
                        <small style="color: #666;">Để trống nếu không áp dụng</small>
                    </div>

                    <div class="form-group">
                        <label for="status">Status *</label>
                        <input type="text" id="status" name="status" required placeholder="Điền trạng thái (ví dụ: Available, Rented, Unavailable)">
                        <small style="color: #666;">Nhập trạng thái xe (Available, Rented, Unavailable)</small>
                    </div>

                    <div class="form-group">
                        <label for="description">Description</label>
                        <textarea id="description" name="description" rows="3" maxlength="500" placeholder="Điền mô tả xe (tùy chọn)"></textarea>
                    </div>

                    <div class="form-group">
                        <label>Car Images</label>
                        <div style="background: #f8f9fa; padding: 15px; border-radius: 4px; border: 1px solid #dee2e6;">
                            <p style="margin: 0; color: #6c757d; font-size: 14px;">
                                <strong>Lưu ý:</strong> Ảnh có thể được upload riêng biệt sau khi thêm xe.<br>
                                Sử dụng nút "Upload Images" trong danh sách xe để thêm ảnh.
                            </p>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary" id="carFormSubmit">Thêm Xe</button>
                </form>
            </div>
        </div>
    </div>

    <script>
        const maxYear = parseInt('${maxYear}') || new Date().getFullYear() + 1;

        function toggleSidebar() {
            document.getElementById('sidebar').classList.toggle('collapsed');
            document.querySelector('.main-content').classList.toggle('expanded');
        }

        function openModal(action, carId = '') {
            resetForm();
            const modal = document.getElementById('carModal');
            const title = document.getElementById('carModalTitle');
            const submitBtn = document.getElementById('carFormSubmit');
            const formAction = document.getElementById('carFormAction');

            if (action === 'add') {
                title.textContent = 'Thêm Xe Mới';
                submitBtn.textContent = 'Thêm Xe';
                formAction.value = 'add';
            } else if (action === 'edit' && carId) {
                title.textContent = 'Cập Nhật Xe';
                submitBtn.textContent = 'Cập Nhật Xe';
                formAction.value = 'update';
                fetchCarData(carId);
            }
            modal.style.display = 'block';
        }

        function closeModal() {
            document.getElementById('carModal').style.display = 'none';
        }

        function fetchCarData(carId) {
            console.log('Fetching car data for ID:', carId);
            fetch('${pageContext.request.contextPath}/manageCarsServlet?carId=' + carId)
                .then(res => {
                    if (!res.ok) throw new Error('Failed to fetch car data');
                    return res.json();
                })
                .then(car => {
                    console.log('Received car data:', car);
                    document.getElementById('carId').value = car.carId || '';
                    document.getElementById('carModel').value = car.carModel || '';
                    // Set brand
                    var brandSelect = document.getElementById('brandId');
                    var found = false;
                    for (var i = 0; i < brandSelect.options.length; i++) {
                        if (brandSelect.options[i].value === car.brandId) {
                            brandSelect.value = car.brandId;
                            found = true;
                            break;
                        }
                    }
                    var otherInput = document.getElementById('brandOtherInput');
                    if (!found && car.brandName) {
                        brandSelect.value = 'other';
                        otherInput.style.display = '';
                        otherInput.value = car.brandName;
                        otherInput.required = true;
                    } else {
                        otherInput.style.display = 'none';
                        otherInput.value = '';
                        otherInput.required = false;
                    }
                    // Set fuel type
                    if (car.fuelName) {
                        document.getElementById('fuelTypeId').value = car.fuelName;
                    } else {
                        document.getElementById('fuelTypeId').value = 'Xăng';
                    }
                    // Set transmission
                    if (car.transmissionTypeName) {
                        document.getElementById('transmissionTypeId').value = car.transmissionTypeName;
                    } else {
                        document.getElementById('transmissionTypeId').value = 'Số tự động';
                    }
                    document.getElementById('categoryId').value = car.categoryName || '';
                    document.getElementById('seats').value = car.seats || '';
                    document.getElementById('yearManufactured').value = car.yearManufactured || '';
                    document.getElementById('licensePlate').value = car.licensePlate || '';
                    document.getElementById('odometer').value = car.odometer || '';
                    document.getElementById('pricePerDay').value = car.pricePerDay || '';
                    document.getElementById('pricePerHour').value = car.pricePerHour || '';
                    if (car.pricePerMonth && car.pricePerMonth !== 'null' && car.pricePerMonth !== '0') {
                        document.getElementById('pricePerMonth').value = car.pricePerMonth;
                    } else {
                        document.getElementById('pricePerMonth').value = '';
                    }
                    document.getElementById('status').value = car.status || '';
                    document.getElementById('description').value = car.description || '';
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Không thể tải thông tin xe!');
                });
        }

        function deleteCar(carId, carModel) {
            if (confirm(`Bạn có chắc chắn muốn xóa xe ${carModel}?`)) {
                const form = document.createElement('form');
                form.method = 'post';
                form.action = '${pageContext.request.contextPath}/manageCarsServlet';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'delete';
                form.appendChild(actionInput);
                
                const carIdInput = document.createElement('input');
                carIdInput.type = 'hidden';
                carIdInput.name = 'carId';
                carIdInput.value = carId;
                form.appendChild(carIdInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }

        function resetForm() {
            const form = document.getElementById('carForm');
            form.reset();
            document.getElementById('carId').value = '';
            // Clear text input fields
            document.getElementById('brandId').value = '';
            document.getElementById('fuelTypeId').value = '';
            document.getElementById('transmissionTypeId').value = '';
            document.getElementById('categoryId').value = '';
            document.getElementById('status').value = '';
            // Clear pricePerMonth if it's 0 or null
            const pricePerMonth = document.getElementById('pricePerMonth');
            if (pricePerMonth.value === '0' || pricePerMonth.value === 'null') {
                pricePerMonth.value = '';
            }
        }

        function validateCarForm(form) {
            let valid = true;
            let firstError = null;
            form.querySelectorAll('.input-error').forEach(e => e.remove());
            function showError(input, msg) {
                const err = document.createElement('div');
                err.className = 'input-error';
                err.style.color = '#e74c3c';
                err.style.fontSize = '13px';
                err.style.marginTop = '2px';
                err.textContent = msg;
                input.parentNode.appendChild(err);
                if (!firstError) firstError = input;
                valid = false;
            }
            // Car Model
            const carModel = form.carModel;
            if (!carModel.value.trim()) showError(carModel, 'Car model is required');
            // Brand
            const brand = form.brandId;
            if (!brand.value.trim()) showError(brand, 'Brand is required');
            // Fuel Type
            const fuel = form.fuelTypeId;
            if (!fuel.value.trim()) showError(fuel, 'Fuel type is required');
            // Transmission
            const trans = form.transmissionTypeId;
            if (!trans.value.trim()) showError(trans, 'Transmission type is required');
            // Seats
            const seats = form.seats;
            if (!seats.value || seats.value < 1 || seats.value > 50) showError(seats, 'Seats must be 1-50');
            // Year
            const year = form.yearManufactured;
            if (!year.value || year.value < 1900 || year.value > maxYear) showError(year, 'Year must be 1900-' + maxYear);
            // License Plate
            const license = form.licensePlate;
            if (!license.value.trim()) showError(license, 'License plate is required');
            // Odometer
            const odo = form.odometer;
            if (!odo.value || odo.value < 0) showError(odo, 'Odometer must be >= 0');
            // Price Per Day
            const priceDay = form.pricePerDay;
            if (!priceDay.value || priceDay.value < 0) showError(priceDay, 'Price per day must be >= 0');
            // Price Per Hour
            const priceHour = form.pricePerHour;
            if (!priceHour.value || priceHour.value < 0) showError(priceHour, 'Price per hour must be >= 0');
            // Price Per Month
            const priceMonth = form.pricePerMonth;
            if (priceMonth.value && priceMonth.value < 0) showError(priceMonth, 'Price per month must be >= 0');
            // Status
            const status = form.status;
            if (!status.value.trim()) showError(status, 'Status is required');
            // Description
            const desc = form.description;
            if (desc.value && desc.value.length > 500) showError(desc, 'Description max 500 chars');
            if (!valid && firstError) firstError.focus();
            return valid;
        }

        window.addEventListener('DOMContentLoaded', function() {
            const carForm = document.getElementById('carForm');
            if (carForm) carForm.onsubmit = function() { return validateCarForm(carForm); };
        });

        document.querySelectorAll('.alert').forEach(alert => {
            setTimeout(() => alert.style.display = 'none', 5000);
        });

        window.onclick = (event) => {
            if (event.target === document.getElementById('carModal')) closeModal();
        };

        function toggleBrandOther() {
            var select = document.getElementById('brandId');
            var otherInput = document.getElementById('brandOtherInput');
            if (select.value === 'other') {
                otherInput.style.display = '';
                otherInput.required = true;
            } else {
                otherInput.style.display = 'none';
                otherInput.required = false;
                otherInput.value = '';
            }
        }

        function applyCarFilters() {
            var url = new URL(window.location.href);
            var brand = document.getElementById('carBrandFilter').value;
            var status = document.getElementById('carStatusFilter').value;
            var fuel = document.getElementById('carFuelFilter').value;
            var transmission = document.getElementById('carTransmissionFilter').value;
            var priceMin = document.getElementById('carPriceMin').value;
            var priceMax = document.getElementById('carPriceMax').value;
            if (brand === 'all') url.searchParams.delete('brandId'); else url.searchParams.set('brandId', brand);
            if (status === 'all') url.searchParams.delete('status'); else url.searchParams.set('status', status);
            if (fuel === 'all') url.searchParams.delete('fuel'); else url.searchParams.set('fuel', fuel);
            if (transmission === 'all') url.searchParams.delete('transmission'); else url.searchParams.set('transmission', transmission);
            if (priceMin) url.searchParams.set('priceMin', priceMin); else url.searchParams.delete('priceMin');
            if (priceMax) url.searchParams.set('priceMax', priceMax); else url.searchParams.delete('priceMax');
            window.location.href = url.toString();
        }
    </script>

    <style>
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.5); z-index: 1000; justify-content: center; align-items: center; }
        .modal-content { background: white; padding: 20px; border-radius: 8px; width: 90%; max-width: 450px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1); animation: fadeIn 0.3s ease-in-out; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(-20px); } to { opacity: 1; transform: translateY(0); } }
        .modal-close { float: right; font-size: 24px; cursor: pointer; color: #666; border: none; background: none; }
        .modal-close:hover { color: #000; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 500; font-size: 14px; color: #333; }
        .form-group input, .form-group select, .form-group textarea { width: 100%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; font-size: 14px; box-sizing: border-box; }
        .form-group textarea { resize: vertical; min-height: 80px; }
        .btn { padding: 8px 16px; border: none; border-radius: 4px; cursor: pointer; font-size: 14px; font-weight: 500; transition: background-color 0.2s; }
        .btn-primary { background-color: #007bff; color: white; }
        .btn-primary:hover { background-color: #0056b3; }
        .modal-header h2 { font-size: 20px; margin: 0 0 15px; text-align: center; font-weight: 600; color: #333; }
        .alert { padding: 10px; margin-bottom: 15px; border-radius: 4px; display: flex; align-items: center; gap: 10px; animation: slideIn 0.3s ease-out; }
        @keyframes slideIn { from { transform: translateX(-100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
        .alert-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        .alert-close { margin-left: auto; cursor: pointer; font-size: 18px; border: none; background: none; }
        @media (max-width: 480px) {
            .modal-content { width: 95%; padding: 15px; }
            .form-group input, .form-group select { font-size: 13px; padding: 6px; }
            .modal-header h2 { font-size: 18px; }
            .btn { padding: 6px 12px; font-size: 13px; }
        }
        .car-image { max-width: 80px; max-height: 50px; border-radius: 4px; object-fit: cover; }
        .badge { display: inline-block; padding: 4px 8px; border-radius: 12px; font-size: 12px; font-weight: 500; }
        .badge.success { background-color: #d4edda; color: #155724; }
        .badge.warning { background-color: #fff3cd; color: #856404; }
        .badge.error { background-color: #f8d7da; color: #721c24; }
        .badge.info { background-color: #cce5ff; color: #004085; }
        .badge.unknown { background-color: #e9ecef; color: #383d41; }
        .badge.status-available { background-color: #d4edda; color: #155724; }
        .badge.status-rented { background-color: #fff3cd; color: #856404; }
        .badge.status-unavailable { background-color: #f8d7da; color: #721c24; }
        
        /* Style cho cột giá */
        .price-column {
            font-weight: 600;
            color: #28a745;
            text-align: right;
        }
        
        /* Responsive cho bảng */
        @media (max-width: 1200px) {
            .data-table th:nth-child(4),
            .data-table td:nth-child(4),
            .data-table th:nth-child(5),
            .data-table td:nth-child(5) {
                display: none;
            }
        }
        
        @media (max-width: 768px) {
            .data-table th:nth-child(6),
            .data-table td:nth-child(6),
            .data-table th:nth-child(7),
            .data-table td:nth-child(7) {
                display: none;
            }
        }
    </style>
</body>
</html>