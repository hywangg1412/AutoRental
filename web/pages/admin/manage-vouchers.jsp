<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Manage Vouchers - AutoRental</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/admin-style.css"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
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
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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
            href="${pageContext.request.contextPath}/pages/admin/admin-dashboard.jsp"
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
            href="${pageContext.request.contextPath}/pages/admin/manage-cars.jsp"
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
            class="nav-item"
          >
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M16.5 3a2.5 2.5 0 0 1 3.54 3.54l-12.5 12.5-4.24 1.06 1.06-4.24L16.5 3zm2.04 2.12a.5.5 0 0 0-.71 0l-1.34 1.34 1.71 1.71 1.34-1.34a.5.5 0 0 0 0-.71l-1-1zm-2.75 2.75L5 16.66V19h2.34l10.79-10.79-1.34-1.34z"
              />
            </svg>
            Contract Details
          </a>
          <a
            href="${pageContext.request.contextPath}/pages/admin/manage-vouchers.jsp"
            class="nav-item active"
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
            <div class="flex items-center justify-between">
              <div>
                <h1 class="page-title">Manage Vouchers</h1>
                <p class="page-description">
                  Create and manage discount codes and promotional vouchers
                </p>
              </div>
              <button
                class="btn btn-primary"
                onclick="openCreateVoucherModal()"
              >
                <svg
                  width="16"
                  height="16"
                  fill="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"></path>
                </svg>
                Add Voucher
              </button>
            </div>
          </div>

          <!-- Notifications -->
          <c:if test="${not empty message}">
            <div style="color: green; font-weight: bold; margin: 16px 0">
              <c:out value="${message}" />
            </div>
          </c:if>
          <c:if test="${not empty error}">
            <div style="color: red; font-weight: bold; margin: 16px 0">
              Error: <c:out value="${error}" />
            </div>
          </c:if>

          <!-- Stats Cards -->
          <div class="stats-grid">
            <div class="stat-card">
              <div class="stat-header">
                <span class="stat-title">Total Vouchers</span>
              </div>
              <div class="stat-value">${discounts.size()}</div>
              <div class="stat-change">All time created</div>
            </div>
            <div class="stat-card">
              <div class="stat-header">
                <span class="stat-title">Active Vouchers</span>
              </div>
              <div class="stat-value">
                ${discounts.stream().filter(d -> d.isActive).count()}
              </div>
              <div class="stat-change positive">Currently available</div>
            </div>
            <div class="stat-card">
              <div class="stat-header">
                <span class="stat-title">Total Usage</span>
              </div>
              <div class="stat-value">
                ${discounts.stream().map(d -> d.usedCount).sum()}
              </div>
              <div class="stat-change">Times redeemed</div>
            </div>
          </div>

          <!-- Voucher List Table -->
          <div class="card">
            <div class="card-header">
              <h2 class="card-title">All Vouchers</h2>
              <p class="card-description">Manage discount codes and offers</p>
            </div>
            <div class="card-content">
              <c:if test="${empty discounts}">
                <div
                  style="
                    color: #888;
                    font-size: 18px;
                    margin: 32px 0;
                    text-align: center;
                  "
                >
                  No vouchers/discounts found in the system!
                </div>
              </c:if>
              <c:if test="${not empty discounts}">
                <div class="table-container">
                  <table class="data-table" id="vouchersTable">
                    <thead>
                      <tr>
                        <th>Discount ID</th>
                        <th>Voucher Name</th>
                        <th>Description</th>
                        <th>Type</th>
                        <th>Value</th>
                        <th>Voucher Code</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Active</th>
                        <th>Created Date</th>
                        <th>Số user đã dùng</th>
                        <th>Actions</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="discount" items="${discounts}">
                        <c:if test="${discount.isActive}">
                          <tr>
                            <td><c:out value="${discount.discountId}" /></td>
                            <td><c:out value="${discount.discountName}" /></td>
                            <td><c:out value="${discount.description}" /></td>
                            <td><c:out value="${discount.discountType}" /></td>
                            <td><c:out value="${discount.discountValue}" /></td>
                            <td><c:out value="${discount.voucherCode}" /></td>
                            <td>
                              <fmt:formatDate
                                value="${discount.startDate}"
                                pattern="yyyy-MM-dd"
                              />
                            </td>
                            <td>
                              <fmt:formatDate
                                value="${discount.endDate}"
                                pattern="yyyy-MM-dd"
                              />
                            </td>
                            <td>
                              <label class="switch">
                                <input type="checkbox" ${discount.isActive ?
                                'checked' : ''} disabled>
                                <span class="slider"></span>
                              </label>
                            </td>
                            <td>
                              <fmt:formatDate
                                value="${discount.createdDate}"
                                pattern="yyyy-MM-dd"
                              />
                            </td>
                            <td>
                              <c:out
                                value="${userUsedCountMap[discount.discountId]}"
                              />
                            </td>
                            <td>
                              <button
                                class="btn-ghost"
                                data-discount-id="${discount.discountId}"
                                data-discount-name="${discount.discountName}"
                                data-description="${discount.description}"
                                data-discount-type="${discount.discountType}"
                                data-discount-value="${discount.discountValue}"
                                data-start-date="${discount.startDate}"
                                data-end-date="${discount.endDate}"
                                data-is-active="${discount.isActive}"
                                data-voucher-code="${discount.voucherCode}"
                                data-min-order-amount="${discount.minOrderAmount}"
                                data-max-discount-amount="${discount.maxDiscountAmount}"
                                data-usage-limit="${discount.usageLimit}"
                                data-discount-category="${discount.discountCategory}"
                                data-used-count="${discount.usedCount}"
                                onclick="editVoucherFromButton(this)"
                              >
                                <svg
                                  width="16"
                                  height="16"
                                  fill="currentColor"
                                  viewBox="0 0 24 24"
                                >
                                  <path
                                    d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"
                                  ></path>
                                </svg>
                              </button>
                            </td>
                          </tr>
                        </c:if>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:if>
            </div>
          </div>
        </main>
      </div>

      <!-- Add Voucher Modal -->
      <div id="createVoucherModal" class="modal-overlay" style="display: none">
        <div class="modal" style="max-width: 600px">
          <div class="modal-header">
            <h3 class="modal-title">Add New Voucher</h3>
          </div>
          <div class="modal-content">
            <form
              id="createVoucherForm"
              method="post"
              action="${pageContext.request.contextPath}/discount"
            >
              <input type="hidden" name="action" value="add" />
              <div class="form-group">
                <label>Voucher Name</label>
                <input
                  type="text"
                  name="discountName"
                  class="form-input"
                  required
                />
              </div>
              <div class="form-group">
                <label>Description</label>
                <textarea name="description" class="form-textarea"></textarea>
              </div>
              <div class="form-group">
                <label>Discount Type</label>
                <select name="discountType" class="form-select" required>
                  <option value="Percent">Percentage</option>
                  <option value="Fixed">Fixed Amount</option>
                </select>
              </div>
              <div class="form-group">
                <label>Discount Value</label>
                <input
                  type="number"
                  name="discountValue"
                  class="form-input"
                  required
                  step="0.01"
                  min="0"
                />
              </div>
              <div class="form-group">
                <label>Voucher Code</label>
                <input type="text" name="voucherCode" class="form-input" />
              </div>
              <div class="form-group">
                <label>Start Date</label>
                <input
                  type="date"
                  name="startDate"
                  class="form-input"
                  required
                />
              </div>
              <div class="form-group">
                <label>End Date</label>
                <input type="date" name="endDate" class="form-input" required />
              </div>
              <div class="form-group">
                <label>Minimum Order Amount</label>
                <input
                  type="number"
                  name="minOrderAmount"
                  class="form-input"
                  required
                  step="0.01"
                  min="0"
                  value="0"
                />
              </div>
              <div class="form-group">
                <label>Maximum Discount Amount</label>
                <input
                  type="number"
                  name="maxDiscountAmount"
                  class="form-input"
                  step="0.01"
                  min="0"
                />
              </div>
              <div class="form-group">
                <label>Usage Limit</label>
                <input
                  type="number"
                  name="usageLimit"
                  class="form-input"
                  min="0"
                />
              </div>
              <div class="form-group">
                <label>Voucher Category</label>
                <select name="discountCategory" class="form-select" required>
                  <option value="General">General</option>
                  <option value="Voucher">Voucher</option>
                </select>
              </div>
              <div class="form-group">
                <label>Active</label>
                <input type="checkbox" name="isActive" checked />
              </div>
              <button type="submit" class="btn btn-primary">Add Voucher</button>
            </form>
          </div>
          <div class="modal-footer">
            <button
              class="btn btn-secondary"
              onclick="closeCreateVoucherModal()"
            >
              Cancel
            </button>
          </div>
        </div>
      </div>

      <!-- Edit Voucher Modal -->
      <div id="editVoucherModal" class="modal-overlay" style="display: none">
        <div class="modal" style="max-width: 600px">
          <div class="modal-header">
            <h3 class="modal-title">Edit Voucher</h3>
          </div>
          <div class="modal-content">
            <form
              id="editVoucherForm"
              method="post"
              action="${pageContext.request.contextPath}/discount"
            >
              <input type="hidden" name="action" value="edit" />
              <input type="hidden" name="discountId" id="edit-discountId" />
              <input type="hidden" name="usedCount" id="edit-usedCount" />
              <div class="form-group">
                <label>Voucher Name</label>
                <input
                  type="text"
                  name="discountName"
                  id="edit-discountName"
                  class="form-input"
                  required
                />
              </div>
              <div class="form-group">
                <label>Description</label>
                <textarea
                  name="description"
                  id="edit-description"
                  class="form-textarea"
                ></textarea>
              </div>
              <div class="form-group">
                <label>Discount Type</label>
                <select
                  name="discountType"
                  id="edit-discountType"
                  class="form-select"
                  required
                >
                  <option value="Percent">Percentage</option>
                  <option value="Fixed">Fixed Amount</option>
                </select>
              </div>
              <div class="form-group">
                <label>Discount Value</label>
                <input
                  type="number"
                  name="discountValue"
                  id="edit-discountValue"
                  class="form-input"
                  required
                  step="0.01"
                  min="0"
                />
              </div>
              <div class="form-group">
                <label>Voucher Code</label>
                <input
                  type="text"
                  name="voucherCode"
                  id="edit-voucherCode"
                  class="form-input"
                />
              </div>
              <div class="form-group">
                <label>Start Date</label>
                <input
                  type="date"
                  name="startDate"
                  id="edit-startDate"
                  class="form-input"
                  required
                />
              </div>
              <div class="form-group">
                <label>End Date</label>
                <input
                  type="date"
                  name="endDate"
                  id="edit-endDate"
                  class="form-input"
                  required
                />
              </div>
              <div class="form-group">
                <label>Minimum Order Amount</label>
                <input
                  type="number"
                  name="minOrderAmount"
                  id="edit-minOrderAmount"
                  class="form-input"
                  required
                  step="0.01"
                  min="0"
                />
              </div>
              <div class="form-group">
                <label>Maximum Discount Amount</label>
                <input
                  type="number"
                  name="maxDiscountAmount"
                  id="edit-maxDiscountAmount"
                  class="form-input"
                  step="0.01"
                  min="0"
                />
              </div>
              <div class="form-group">
                <label>Usage Limit</label>
                <input
                  type="number"
                  name="usageLimit"
                  id="edit-usageLimit"
                  class="form-input"
                  min="0"
                />
              </div>
              <div class="form-group">
                <label>Voucher Category</label>
                <select
                  name="discountCategory"
                  id="edit-discountCategory"
                  class="form-select"
                  required
                >
                  <option value="General">General</option>
                  <option value="Voucher">Voucher</option>
                </select>
              </div>
              <div class="form-group">
                <label>Active</label>
                <input type="checkbox" name="isActive" id="edit-isActive" />
              </div>
              <button type="submit" class="btn btn-primary">
                Update Voucher
              </button>
            </form>
          </div>
          <div class="modal-footer">
            <button class="btn btn-secondary" onclick="closeEditVoucherModal()">
              Cancel
            </button>
          </div>
        </div>
      </div>

      <style>
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
          transition: 0.4s;
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
          transition: 0.4s;
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
          const sidebar = document.getElementById("sidebar");
          sidebar.classList.toggle("open");
        }

        function logout() {
          Swal.fire({
            title: "Are you sure you want to log out?",
            icon: "warning",
            showCancelButton: true,
            confirmButtonText: "Log Out",
            cancelButtonText: "Cancel",
          }).then((result) => {
            if (result.isConfirmed) {
              window.location.href = "login.jsp";
            }
          });
        }

        function openCreateVoucherModal() {
          document.getElementById("createVoucherModal").style.display = "flex";
          document.getElementById("createVoucherForm").reset();
        }

        function closeCreateVoucherModal() {
          document.getElementById("createVoucherModal").style.display = "none";
          document.getElementById("createVoucherForm").reset();
        }

        function openEditVoucherModal(
          id,
          name,
          description,
          type,
          value,
          startDate,
          endDate,
          isActive,
          voucherCode,
          minOrderAmount,
          maxDiscountAmount,
          usageLimit,
          discountCategory,
          usedCount
        ) {
          console.log("Opening edit modal with id:", id);
          try {
            if (!id || id.trim() === "") {
              throw new Error("Invalid or empty voucher ID");
            }
            document.getElementById("edit-discountId").value = id || "";
            document.getElementById("edit-discountName").value = name || "";
            document.getElementById("edit-description").value =
              description || "";
            document.getElementById("edit-discountType").value =
              type || "Percent";
            document.getElementById("edit-discountValue").value = value || "";
            document.getElementById("edit-startDate").value = startDate || "";
            document.getElementById("edit-endDate").value = endDate || "";
            document.getElementById("edit-isActive").checked =
              isActive === true || isActive === "true";
            document.getElementById("edit-voucherCode").value =
              voucherCode || "";
            document.getElementById("edit-minOrderAmount").value =
              minOrderAmount || "0";
            document.getElementById("edit-maxDiscountAmount").value =
              maxDiscountAmount || "";
            document.getElementById("edit-usageLimit").value = usageLimit || "";
            document.getElementById("edit-discountCategory").value =
              discountCategory || "General";
            document.getElementById("edit-usedCount").value = usedCount || "0";
            document.getElementById("editVoucherModal").style.display = "flex";
          } catch (e) {
            console.error("Error opening edit modal:", e);
            Swal.fire({
              icon: "error",
              title: "Error",
              text: "Failed to open edit modal: " + e.message,
            });
          }
        }

        function closeEditVoucherModal() {
          document.getElementById("editVoucherModal").style.display = "none";
          document.getElementById("editVoucherForm").reset();
        }

        function deleteVoucher(voucherId, voucherCode) {
          if (
            !voucherId ||
            typeof voucherId !== "string" ||
            voucherId.trim() === ""
          ) {
            Swal.fire({
              icon: "error",
              title: "Error",
              text: "Voucher ID is empty or invalid!",
            });
            return;
          }
          console.log(
            "deleteVoucher called with voucherId:",
            voucherId,
            "and voucherCode:",
            voucherCode
          );
          try {
            fetch(
              "${pageContext.request.contextPath}/discount?action=check&id=" +
                encodeURIComponent(voucherId),
              {
                method: "GET",
                headers: {
                  Accept: "application/json",
                },
                signal: AbortSignal.timeout(5000), // Timeout after 5 seconds
              }
            )
              .then((response) => {
                console.log("Response status:", response.status);
                if (!response.ok) {
                  return response.text().then((text) => {
                    throw new Error(
                      `HTTP error! Status: ${response.status}, Response: ${text}`
                    );
                  });
                }
                return response.json();
              })
              .then((data) => {
                console.log("Check response:", data);
                if (data.exists) {
                  currentVoucherId = voucherId;
                  currentVoucherCode = voucherCode || "Unknown";
                  console.log(
                    "Assigned currentVoucherId:",
                    currentVoucherId,
                    "and currentVoucherCode:",
                    currentVoucherCode
                  );
                  Swal.fire({
                    title:
                      "Are you sure you want to delete voucher " +
                      (currentVoucherCode || "this") +
                      "?",
                    icon: "warning",
                    showCancelButton: true,
                    confirmButtonText: "Delete",
                    cancelButtonText: "Cancel",
                  }).then((result) => {
                    if (result.isConfirmed) {
                      confirmDeleteVoucher();
                    }
                  });
                } else {
                  Swal.fire({
                    icon: "error",
                    title: "Error",
                    text: data.error || "Voucher does not exist in the system!",
                  });
                }
              })
              .catch((error) => {
                console.error("Error checking voucher:", error);
                Swal.fire({
                  icon: "error",
                  title: "Error",
                  text: "Failed to check voucher: " + error.message,
                });
              });
          } catch (e) {
            console.error("Error processing voucherId:", e);
            Swal.fire({
              icon: "error",
              title: "Error",
              text: "Failed to process voucher ID: " + e.message,
            });
          }
        }

        function confirmDeleteVoucher() {
          console.log(
            "confirmDeleteVoucher called with currentVoucherId:",
            currentVoucherId
          );
          try {
            if (!currentVoucherId || currentVoucherId.trim() === "") {
              throw new Error("Invalid or empty voucher ID");
            }
            const form = document.createElement("form");
            form.method = "post";
            form.action = "${pageContext.request.contextPath}/discount";
            form.innerHTML = `
                        <input type="hidden" name="action" value="delete"/>
                        <input type="hidden" name="id" value="${currentVoucherId}"/>
                    `;
            console.log(
              "Form created with action:",
              form.action,
              "and id:",
              currentVoucherId
            );
            document.body.appendChild(form);
            form.submit();
          } catch (e) {
            console.error("Error submitting delete form:", e);
            Swal.fire({
              icon: "error",
              title: "Error",
              text: "Failed to delete voucher: " + e.message,
            });
          }
        }

        function deleteVoucherFromButton(btn) {
          const voucherId = btn.getAttribute("data-discount-id");
          const voucherCode = btn.getAttribute("data-voucher-code");
          if (!voucherId || voucherId.trim() === "") {
            Swal.fire({
              icon: "error",
              title: "Error",
              text: "Voucher ID is empty or invalid!",
            });
            return;
          }
          deleteVoucher(voucherId, voucherCode);
        }

        function editVoucherFromButton(btn) {
          openEditVoucherModal(
            btn.getAttribute("data-discount-id"),
            btn.getAttribute("data-discount-name"),
            btn.getAttribute("data-description"),
            btn.getAttribute("data-discount-type"),
            btn.getAttribute("data-discount-value"),
            btn.getAttribute("data-start-date"),
            btn.getAttribute("data-end-date"),
            btn.getAttribute("data-is-active") === "true" ||
              btn.getAttribute("data-is-active") === "1",
            btn.getAttribute("data-voucher-code"),
            btn.getAttribute("data-min-order-amount"),
            btn.getAttribute("data-max-discount-amount"),
            btn.getAttribute("data-usage-limit"),
            btn.getAttribute("data-discount-category"),
            btn.getAttribute("data-used-count")
          );
        }

        function validateVoucherForm(form) {
          let valid = true;
          let firstError = null;
          form.querySelectorAll(".input-error").forEach((e) => e.remove());
          function showError(input, msg) {
            const err = document.createElement("div");
            err.className = "input-error";
            err.style.color = "#e74c3c";
            err.style.fontSize = "13px";
            err.style.marginTop = "2px";
            err.textContent = msg;
            input.parentNode.appendChild(err);
            if (!firstError) firstError = input;
            valid = false;
          }
          // Voucher Name
          const name = form.discountName;
          if (!name.value.trim()) showError(name, "Voucher name is required");
          // Discount Type
          const type = form.discountType;
          if (!type.value) showError(type, "Discount type is required");
          // Discount Value
          const value = form.discountValue;
          if (!value.value || value.value < 0)
            showError(value, "Discount value must be >= 0");
          // Start/End Date
          const start = form.startDate;
          const end = form.endDate;
          if (!start.value) showError(start, "Start date is required");
          if (!end.value) showError(end, "End date is required");
          if (
            start.value &&
            end.value &&
            new Date(end.value) < new Date(start.value)
          )
            showError(end, "End date must be after start date");
          // Min Order Amount
          const minOrder = form.minOrderAmount;
          if (!minOrder.value || minOrder.value < 0)
            showError(minOrder, "Min order amount must be >= 0");
          // Max Discount Amount
          const maxDiscount = form.maxDiscountAmount;
          if (maxDiscount.value && maxDiscount.value < 0)
            showError(maxDiscount, "Max discount must be >= 0");
          // Usage Limit
          const usage = form.usageLimit;
          if (usage.value && usage.value < 0)
            showError(usage, "Usage limit must be >= 0");
          // Description
          const desc = form.description;
          if (desc && desc.value.length > 500)
            showError(desc, "Description max 500 chars");
          if (!valid && firstError) firstError.focus();
          return valid;
        }

        window.addEventListener("click", function (event) {
          const createModal = document.getElementById("createVoucherModal");
          const editModal = document.getElementById("editVoucherModal");

          if (event.target === createModal) {
            closeCreateVoucherModal();
          }
          if (event.target === editModal) {
            closeEditVoucherModal();
          }
        });

        window.addEventListener("DOMContentLoaded", function () {
          document.querySelectorAll("form").forEach((form) => {
            if (
              form.id === "createVoucherForm" ||
              form.id === "editVoucherForm"
            ) {
              form.onsubmit = function () {
                return validateVoucherForm(form);
              };
            }
          });
        });
      </script>
    </div>
  </body>
</html>
