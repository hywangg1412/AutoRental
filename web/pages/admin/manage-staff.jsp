<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %> <%@ taglib prefix="fn"
uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Staff Management - AutoRental</title>

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
              <path
                d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"
              />
            </svg>
            Dashboard
          </a>
          <a href="${pageContext.request.contextPath}/admin/user-management" class="nav-item">
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M16 7c0-2.21-1.79-4-4-4S8 4.79 8 7s1.79 4 4 4 4-1.79 4-4zm-4 6c-2.67 0-8 1.34-8 4v3h16v-3c0-2.66-5.33-4-8-4z"
              />
            </svg>
            Users
          </a>
          <a href="${pageContext.request.contextPath}/manageCarsServlet" class="nav-item ">
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M18.92 6.01C18.72 5.42 18.16 5 17.5 5h-11c-.66 0-1.22.42-1.42 1.01L3 12v8c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-1h12v1c0 .55.45 1 1 1h1c.55 0 1-.45 1-1v-8l-2.08-5.99z"
              />
            </svg>
            Cars
          </a>
          <a href="${pageContext.request.contextPath}/admin/manage-staff" class="nav-item active">
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"
              />
            </svg>
            Staff
          </a>
          <!-- Reports navigation item hidden -->
          <!--
          <a href="${pageContext.request.contextPath}/pages/admin/manage-reports.jsp" class="nav-item">
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
          <a href="${pageContext.request.contextPath}/pages/admin/contract-details.jsp" class="nav-item">
            <svg class="nav-item-icon" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M16.5 3a2.5 2.5 0 0 1 3.54 3.54l-12.5 12.5-4.24 1.06 1.06-4.24L16.5 3zm2.04 2.12a.5.5 0 0 0-.71 0l-1.34 1.34 1.71 1.71 1.34-1.34a.5.5 0 0 0 0-.71l-1-1zm-2.75 2.75L5 16.66V19h2.34l10.79-10.79-1.34-1.34z"
              />
            </svg>
            Contract Details
          </a>
          -->
          <a href="${pageContext.request.contextPath}/discount" class="nav-item">
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
            </div>
          </div>

          <!-- Messages -->
          <c:if test="${not empty success}">
            <div class="alert alert-success">${success}</div>
          </c:if>
          <c:if test="${not empty error}">
            <div class="alert alert-danger">${error}</div>
          </c:if>

          <!-- Filter Bar -->
          <div class="filter-bar">
            <div class="search-box">
              <svg class="search-icon" fill="currentColor" viewBox="0 0 24 24">
                <path
                  d="M15.5 14h-.79l-.28-.27C15.41 12.59 16 11.11 16 9.5 16 5.91 13.09 3 9.5 3S3 5.91 3 9.5 5.91 16 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z"
                />
              </svg>
              <input
                type="text"
                class="search-input"
                placeholder="Search staff..."
                id="searchStaff"
              />
            </div>
            <select
              class="form-select"
              id="statusFilter"
              onchange="filterStaff()"
            >
              <option value="all">All Status</option>
              <option value="active">Active</option>
              <option value="inactive">Inactive</option>
              <option value="banned">Banned</option>
              <option value="deleted">Deleted</option>
            </select>
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
              <div class="d-flex justify-content-end mb-3">
                <button class="btn btn-primary" onclick="forceOpenAddModal()">
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
                  <tbody id="staffTableBody">
                    <c:forEach var="staff" items="${staffList}">
                      <tr>
                        <form
                          method="post"
                          action="${pageContext.request.contextPath}/admin/manage-staff"
                        >
                          <input
                            type="hidden"
                            name="userId"
                            value="${staff.userId}"
                          />
                          <td>
                            <span>${staff.firstName}</span>
                            <span>${staff.lastName}</span>
                          </td>
                          <td>
                            <span>${staff.username}</span>
                          </td>
                          <td>
                            <span>${staff.email}</span>
                          </td>
                          <td>
                            <span>${staff.phoneNumber}</span>
                          </td>
                          <td>
                            <c:choose>
                              <c:when test="${not empty staff.createdDate}">
                                <span
                                  >${fn:substringBefore(staff.createdDate,
                                  'T')}</span
                                >
                              </c:when>
                              <c:otherwise>N/A</c:otherwise>
                            </c:choose>
                          </td>
                          <td>
                            <c:choose>
                              <c:when test="${staff.status eq 'Active'}">
                                <span class="badge success">Active</span>
                              </c:when>
                              <c:when test="${staff.status eq 'Banned'}">
                                <span class="badge danger">Banned</span>
                              </c:when>
                              <c:when test="${staff.status eq 'Inactive'}">
                                <span class="badge warning">Inactive</span>
                              </c:when>
                              <c:when test="${staff.status eq 'Deleted'}">
                                <span class="badge secondary">Deleted</span>
                              </c:when>
                              <c:otherwise>
                                <span class="badge secondary">
                                  <c:out
                                    value="${staff.status}"
                                    default="Unknown"
                                  />
                                </span>
                              </c:otherwise>
                            </c:choose>
                          </td>
                          <td>
                            <button
                              type="button"
                              class="btn btn-outline-edit"
                              onclick="openEditStaffModalFromRow('${staff.userId}', '${staff.firstName}', '${staff.lastName}', '${staff.username}', '${staff.email}', '${staff.phoneNumber}', '${staff.gender}', '${staff.userDOB}')"
                            >
                              Edit
                            </button>
                            <button
                              name="action"
                              value="delete"
                              type="submit"
                              class="btn btn-outline-delete"
                              onclick="return confirm('Delete this staff member?')"
                            >
                              Delete
                            </button>
                          </td>
                        </form>
                      </tr>
                    </c:forEach>
                    <c:if test="${empty staffList}">
                      <tr>
                        <td colspan="7" style="text-align: center; color: #888">
                          No staff members found
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

    <script>
      const contextPath = "${pageContext.request.contextPath}";
    </script>
    <script>
      // Sidebar toggle
      function toggleSidebar() {
        document.getElementById("sidebar").classList.toggle("open");
      }

      function logout() {
        if (confirm("Are you sure you want to logout?")) {
          window.location.href = "login.jsp";
        }
      }

      function filterStaff() {
        const statusFilter = document.getElementById("statusFilter").value;
        const url = new URL(window.location);

        if (statusFilter === "all") {
          url.searchParams.delete("status");
        } else {
          url.searchParams.set("status", statusFilter);
        }

        window.location.href = url.toString();
      }

      // Show success/error messages
      const urlParams = new URLSearchParams(window.location.search);
      const success = urlParams.get("success");
      const error = urlParams.get("error");

      if (success) {
        let message = "";
        switch (success) {
          case "add":
            message = "Staff member added successfully!";
            break;
          case "edit":
            message = "Staff member updated successfully!";
            break;
          case "delete":
            message = "Staff member deleted successfully!";
            break;
        }
        if (message) {
          alert(message);
        }
      }

      if (error) {
        alert("Error: " + error);
      }

      // Add event listener for status filter
      document
        .getElementById("statusFilter")
        .addEventListener("change", filterStaff);

      // Create dynamic edit modal
      function createDynamicEditModal(
        userId,
        firstName,
        lastName,
        username,
        email,
        phoneNumber,
        gender,
        userDOB
      ) {
        // Remove existing dynamic modal if any
        const existingModal = document.getElementById("dynamicEditModal");
        if (existingModal) {
          existingModal.remove();
        }
        // Tạo gender options đúng cách
        const genderOptions =
          '<option value="Male"' +
          (gender === "Male" ? " selected" : "") +
          ">Male</option>" +
          '<option value="Female"' +
          (gender === "Female" ? " selected" : "") +
          ">Female</option>" +
          '<option value="Other"' +
          (gender === "Other" ? " selected" : "") +
          ">Other</option>";
        const modalHTML =
          '<div id="dynamicEditModal" style="position: fixed; top: 0; left: 0; right: 0; bottom: 0; background-color: rgba(0, 0, 0, 0.5); z-index: 1000; display: flex; align-items: center; justify-content: center;">' +
          '<div style="background: white; border-radius: 8px; max-width: 500px; width: 90%; max-height: 90vh; overflow-y: auto; position: relative;">' +
          '<button onclick="closeDynamicEditModal()" style="position: absolute; top: 16px; right: 16px; background: none; border: none; font-size: 24px; cursor: pointer; color: #6b7280;">×</button>' +
          '<div style="padding: 20px 24px; border-bottom: 1px solid #e5e7eb;">' +
          '<h3 style="font-size: 18px; font-weight: 600; color: #111827; margin: 0;">Update Staff Information</h3>' +
          "</div>" +
          '<div style="padding: 24px;">' +
          '<form method="post" action="' +
          contextPath +
          '/admin/manage-staff">' +
          '<input type="hidden" name="action" value="edit" />' +
          '<input type="hidden" name="userId" value="' +
          (userId || "") +
          '" />' +
          '<div style="margin-bottom: 16px;">' +
          '<label style="display: block; margin-bottom: 4px; font-size: 14px; font-weight: 500; color: #374151;">First Name *</label>' +
          '<input type="text" name="firstName" value="' +
          (firstName || "") +
          '" required style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px;" />' +
          "</div>" +
          '<div style="margin-bottom: 16px;">' +
          '<label style="display: block; margin-bottom: 4px; font-size: 14px; font-weight: 500; color: #374151;">Last Name *</label>' +
          '<input type="text" name="lastName" value="' +
          (lastName || "") +
          '" required style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px;" />' +
          "</div>" +
          '<div style="margin-bottom: 16px;">' +
          '<label style="display: block; margin-bottom: 4px; font-size: 14px; font-weight: 500; color: #374151;">Email *</label>' +
          '<input type="email" name="email" value="' +
          (email || "") +
          '" required style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px;" />' +
          "</div>" +
          '<div style="margin-bottom: 16px;">' +
          '<label style="display: block; margin-bottom: 4px; font-size: 14px; font-weight: 500; color: #374151;">Username *</label>' +
          '<input type="text" name="username" value="' +
          (username || "") +
          '" required style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px;" />' +
          "</div>" +
          '<div style="margin-bottom: 16px;">' +
          '<label style="display: block; margin-bottom: 4px; font-size: 14px; font-weight: 500; color: #374151;">Phone</label>' +
          '<input type="tel" name="phoneNumber" value="' +
          (phoneNumber || "") +
          '" style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px;" />' +
          "</div>" +
          '<div style="margin-bottom: 16px;">' +
          '<label style="display: block; margin-bottom: 4px; font-size: 14px; font-weight: 500; color: #374151;">Gender</label>' +
          '<select name="gender" style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px; background-color: white;">' +
          '<option value="">Select Gender</option>' +
          genderOptions +
          "</select>" +
          "</div>" +
          '<div style="margin-bottom: 16px;">' +
          '<label style="display: block; margin-bottom: 4px; font-size: 14px; font-weight: 500; color: #374151;">Date of Birth</label>' +
          '<input type="date" name="userDOB" value="' +
          (userDOB || "") +
          '" style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px;" />' +
          "</div>" +
          '<div style="padding: 20px 24px; border-top: 1px solid #e5e7eb; text-align: center;">' +
          '<button type="submit" style="background-color: #10b981; color: white; border: none; padding: 8px 16px; border-radius: 6px; font-size: 14px; cursor: pointer; width: 100%;">Update Staff Member</button>' +
          "</div>" +
          "</form>" +
          "</div>" +
          "</div>" +
          "</div>";
        document.body.insertAdjacentHTML("beforeend", modalHTML);
      }
      function closeDynamicEditModal() {
        const modal = document.getElementById("dynamicEditModal");
        if (modal) {
          modal.remove();
        }
      }
      // Force open edit modal function
      function openEditStaffModalFromRow(
        userId,
        firstName,
        lastName,
        username,
        email,
        phoneNumber,
        gender,
        userDOB
      ) {
        createDynamicEditModal(
          userId,
          firstName,
          lastName,
          username,
          email,
          phoneNumber,
          gender,
          userDOB
        );
      }
      // Đóng modal khi click ngoài vùng modal
      window.addEventListener("click", function (event) {
        const addModal = document.getElementById("dynamicAddModal");
        const editModal = document.getElementById("dynamicEditModal");
        if (event.target === addModal) {
          closeDynamicAddModal();
        }
        if (event.target === editModal) {
          closeDynamicEditModal();
        }
      });

      // Force open add modal function
      function forceOpenAddModal() {
        createDynamicAddModal();
      }
      // Create dynamic add modal
      function createDynamicAddModal() {
        // Remove existing dynamic modal if any
        const existingModal = document.getElementById("dynamicAddModal");
        if (existingModal) {
          existingModal.remove();
        }
        const modalHTML =
          '<div id="dynamicAddModal" style="position: fixed; top: 0; left: 0; right: 0; bottom: 0; background-color: rgba(0, 0, 0, 0.5); z-index: 1000; display: flex; align-items: center; justify-content: center;">' +
          '<div style="background: white; border-radius: 8px; max-width: 500px; width: 90%; max-height: 90vh; overflow-y: auto; position: relative;">' +
          '<button onclick="closeDynamicAddModal()" style="position: absolute; top: 16px; right: 16px; background: none; border: none; font-size: 24px; cursor: pointer; color: #6b7280;">×</button>' +
          '<div style="padding: 20px 24px; border-bottom: 1px solid #e5e7eb;">' +
          '<h3 style="font-size: 18px; font-weight: 600; color: #111827; margin: 0;">Add New Staff Member</h3>' +
          "</div>" +
          '<div style="padding: 24px;">' +
          '<form method="post" action="' +
          contextPath +
          '/admin/manage-staff">' +
          '<input type="hidden" name="action" value="add" />' +
          '<div style="margin-bottom: 16px;">' +
          '<label style="display: block; margin-bottom: 4px; font-size: 14px; font-weight: 500; color: #374151;">First Name *</label>' +
          '<input type="text" name="firstName" required style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px;" />' +
          "</div>" +
          '<div style="margin-bottom: 16px;">' +
          '<label style="display: block; margin-bottom: 4px; font-size: 14px; font-weight: 500; color: #374151;">Last Name *</label>' +
          '<input type="text" name="lastName" required style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px;" />' +
          "</div>" +
          '<div style="margin-bottom: 16px;">' +
          '<label style="display: block; margin-bottom: 4px; font-size: 14px; font-weight: 500; color: #374151;">Email *</label>' +
          '<input type="email" name="email" required style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px;" />' +
          "</div>" +
          '<div style="margin-bottom: 16px;">' +
          '<label style="display: block; margin-bottom: 4px; font-size: 14px; font-weight: 500; color: #374151;">Username *</label>' +
          '<input type="text" name="username" required style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px;" />' +
          "</div>" +
          '<div style="margin-bottom: 16px;">' +
          '<label style="display: block; margin-bottom: 4px; font-size: 14px; font-weight: 500; color: #374151;">Password *</label>' +
          '<input type="password" name="password" required style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px;" />' +
          "</div>" +
          '<div style="margin-bottom: 16px;">' +
          '<label style="display: block; margin-bottom: 4px; font-size: 14px; font-weight: 500; color: #374151;">Phone</label>' +
          '<input type="tel" name="phoneNumber" style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px;" />' +
          "</div>" +
          '<div style="margin-bottom: 16px;">' +
          '<label style="display: block; margin-bottom: 4px; font-size: 14px; font-weight: 500; color: #374151;">Gender</label>' +
          '<select name="gender" style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px; background-color: white;">' +
          '<option value="">Select Gender</option>' +
          '<option value="Male">Male</option>' +
          '<option value="Female">Female</option>' +
          '<option value="Other">Other</option>' +
          "</select>" +
          "</div>" +
          '<div style="margin-bottom: 16px;">' +
          '<label style="display: block; margin-bottom: 4px; font-size: 14px; font-weight: 500; color: #374151;">Date of Birth</label>' +
          '<input type="date" name="userDOB" style="width: 100%; padding: 8px 12px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px;" />' +
          "</div>" +
          '<div style="padding: 20px 24px; border-top: 1px solid #e5e7eb; text-align: center;">' +
          '<button type="submit" style="background-color: #10b981; color: white; border: none; padding: 8px 16px; border-radius: 6px; font-size: 14px; cursor: pointer; width: 100%; font-size: 1.15rem;">Add Staff Member</button>' +
          "</div>" +
          "</form>" +
          "</div>" +
          "</div>" +
          "</div>";
        document.body.insertAdjacentHTML("beforeend", modalHTML);
      }
      function closeDynamicAddModal() {
        const modal = document.getElementById("dynamicAddModal");
        if (modal) {
          modal.remove();
        }
      }
    </script>
  </body>
</html>
