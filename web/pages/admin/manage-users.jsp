<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>User Management</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/styles/admin/user-management.css"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Montserrat:wght@900&display=swap"
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
    <style>
      .modal-overlay {
        display: none;
        position: fixed;
        z-index: 1000;
        left: 0; top: 0; width: 100vw; height: 100vh;
        background: rgba(0,0,0,0.4);
        justify-content: center;
        align-items: center;
      }
      
      /* Phone number validation styles */
      input[name="phoneNumber"].is-valid {
        border-color: #28a745 !important;
        box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25) !important;
      }
      
      input[name="phoneNumber"].is-invalid {
        border-color: #dc3545 !important;
        box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25) !important;
      }
      
      input[name="phoneNumber"].validating {
        border-color: #ffc107 !important;
        box-shadow: 0 0 0 0.2rem rgba(255, 193, 7, 0.25) !important;
      }
      
      .input-success {
        color: #28a745;
        font-size: 13px;
        margin-top: 2px;
      }
      
      .input-error {
        color: #e74c3c;
        font-size: 13px;
        margin-top: 2px;
      }
      
      /* Loading indicator for phone validation */
      input[name="phoneNumber"].validating::after {
        content: "Đang kiểm tra...";
        position: absolute;
        right: 10px;
        top: 50%;
        transform: translateY(-50%);
        font-size: 12px;
        color: #ffc107;
      }
    </style>
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
            class="nav-item active"
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
            class="nav-item "
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
            class="nav-item"
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

    <div class="manage-user-full">
      <div class="top-bar">
        <h1>User Management</h1>
        <div style="display: flex; gap: 12px; align-items: center;">
          <div class="search-box">
            <input type="text" id="searchUsername" placeholder="Tìm kiếm theo username..." />
            <button class="btn btn-search" id="searchButton">
              <i class="fa fa-search"></i>
            </button>
          </div>
          <button class="btn" onclick="openAddModal()">
            <i class="fa fa-plus"></i> Add User
          </button>
          <select id="userStatusFilter" style="margin-left: 16px; padding: 8px 12px; border-radius: 6px; border: 1px solid #ccc;">
            <option value="all">All</option>
            <option value="Active" ${param.status == 'Active' ? 'selected' : ''}>Active</option>
            <option value="Banned" ${param.status == 'Banned' ? 'selected' : ''}>Banned</option>
          </select>
        </div>
      </div>
      <c:if test="${not empty error}"><div class="error">${error}</div></c:if>
      <c:if test="${not empty success}"
        ><div class="success">${success}</div></c:if
      >
      <div class="table-wrap">
        <table>
          <thead>
            <tr>
              <th>Username</th>
              <!-- Xóa cột First Name và Last Name -->
              <th>Email</th>
              <th>Phone</th>
              <th>Gender</th>
              <th>Date of Birth</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody id="userTableBody">
            <c:forEach var="user" items="${users}">
              <tr class="user-row">
                <td>${user.username}</td>
                <!-- Xóa cột First Name và Last Name -->
                <td>${user.email}</td>
                <td>${user.phoneNumber}</td>
                <td>${user.gender}</td>
                <td>
                  <c:if test="${not empty user.userDOB}">
                    <fmt:parseDate value="${user.userDOB}" pattern="yyyy-MM-dd" var="parsedDate" type="date" />
                    <fmt:formatDate value="${parsedDate}" pattern="dd-MM-yyyy" />
                  </c:if>
                </td>
                <td>
                  <c:choose>
                    <c:when test="${user.status eq 'Active'}">
                      <span class="status-badge status-active">Active</span>
                    </c:when>
                    <c:when test="${user.status eq 'Banned'}">
                      <span class="status-badge status-banned">Banned</span>
                    </c:when>
                    <c:when test="${user.status eq 'Disabled'}">
                      <span class="status-badge status-disabled">Disabled</span>
                    </c:when>
                    <c:otherwise>
                      <span class="status-badge status-disabled">${user.status}</span>
                    </c:otherwise>
                  </c:choose>
                </td>
                <td class="actions">
                  <button
                    class="btn btn-secondary"
                    onclick="openEditModal('${user.userId}', '${user.username}', '${user.email}', '${user.phoneNumber}', '${user.gender}', '${user.userDOB}', '${user.status}', '${user.roleId}')"
                  >
                    <i class="fa fa-edit"></i> Edit
                  </button>
                  <!-- Xóa nút Delete -->
                  <c:if test="${user.status ne 'Banned'}">
                    <form
                      method="post"
                      action="${pageContext.request.contextPath}/admin/user-management"
                      style="display: inline"
                      onsubmit="return confirm('Are you sure you want to ban this user?');"
                    >
                      <input type="hidden" name="action" value="ban" />
                      <input type="hidden" name="userId" value="${user.userId}" />
                      <button type="submit" class="btn btn-danger" style="background: #fdeaea; color: #e74c3c; border: 1px solid #f5c6cb;">
                        <i class="fa fa-ban"></i> Ban
                      </button>
                    </form>
                  </c:if>
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
        
        <!-- Pagination -->
        <div class="pagination-container">
          <div class="pagination-info">
            Hiển thị <span id="startIndex">0</span> - <span id="endIndex">0</span> trên tổng số <span id="totalItems">0</span>
          </div>
          <div class="pagination">
            <button id="prevPage" class="pagination-btn">
              <i class="fa fa-chevron-left"></i>
            </button>
            <div id="pageNumbers" class="page-numbers"></div>
            <button id="nextPage" class="pagination-btn">
              <i class="fa fa-chevron-right"></i>
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal Thêm User -->
    <div class="modal-overlay" id="addModal">
      <div class="modal">
        <span class="close" onclick="closeAddModal()">&times;</span>
        <h2>Thêm User mới</h2>
        <form
          method="post"
          action="${pageContext.request.contextPath}/admin/user-management"
        >
          <input type="hidden" name="action" value="add" />
          <div class="form-group">
            <label>Username</label
            ><input type="text" name="username" required />
          </div>
          <!-- Xóa trường First Name và Last Name -->
          <div class="form-group">
            <label>Email</label><input type="email" name="email" required />
          </div>
          <div class="form-group">
            <label>Số điện thoại</label><input type="text" name="phoneNumber" />
          </div>
          <div class="form-group">
            <label>Giới tính</label>
            <select name="gender">
              <option value="Nam">Nam</option>
              <option value="Nữ">Nữ</option>
              <option value="Khác">Khác</option>
            </select>
          </div>
          <div class="form-group">
            <label>Ngày sinh</label><input type="date" name="userDOB" />
          </div>
          <div class="form-group">
            <label>Trạng thái</label>
            <select name="status">
              <option value="Active">Active</option>
              <option value="Inactive">Inactive</option>
              <option value="Banned">Banned</option>
              <option value="Deleted">Deleted</option>
            </select>
          </div>
          <div class="form-group">
            <label>Role</label>
            <select name="roleId">
              <option value="6BA7B810-9DAD-11D1-80B4-00C04FD430C8">User</option>
            </select>
          </div>
          <div class="form-group">
            <label>Password</label
            ><input type="password" name="passwordHash" required />
          </div>
          <button type="submit" class="btn">Thêm User</button>
        </form>
      </div>
    </div>

    <!-- Modal Sửa User -->
    <div class="modal-overlay" id="editModal">
      <div class="modal">
        <span class="close" onclick="closeEditModal()">&times;</span>
        <h2>Sửa User</h2>
        <form
          method="post"
          action="${pageContext.request.contextPath}/admin/user-management"
        >
          <input type="hidden" name="action" value="update" />
          <input type="hidden" name="userId" id="editUserId" />
          <div class="form-group">
            <label>Username</label
            ><input type="text" name="username" id="editUsername" required />
          </div>
          <!-- Xóa trường First Name và Last Name -->
          <div class="form-group">
            <label>Email</label
            ><input type="email" name="email" id="editEmail" required />
          </div>
          <div class="form-group">
            <label>Số điện thoại</label
            ><input type="text" name="phoneNumber" id="editPhoneNumber" />
          </div>
          <div class="form-group">
            <label>Giới tính</label>
            <select name="gender" id="editGender">
              <option value="Nam">Nam</option>
              <option value="Nữ">Nữ</option>
              <option value="Khác">Khác</option>
            </select>
          </div>
          <div class="form-group">
            <label>Ngày sinh</label
            ><input type="date" name="userDOB" id="editUserDOB" />
          </div>
          <div class="form-group">
            <label>Trạng thái</label>
            <select name="status" id="editStatus">
              <option value="Active">Active</option>
              <option value="Inactive">Inactive</option>
              <option value="Banned">Banned</option>
              <option value="Deleted">Deleted</option>
            </select>
          </div>
          <div class="form-group">
            <label>Role</label>
            <select name="roleId" id="editRoleId">
              <option value="6BA7B810-9DAD-11D1-80B4-00C04FD430C8">User</option>
            </select>
          </div>
          <button type="submit" class="btn">Cập nhật User</button>
        </form>
      </div>
    </div>

    <script>
      function openAddModal() {
        document.getElementById("addModal").style.display = "flex";
      }
      function closeAddModal() {
        document.getElementById("addModal").style.display = "none";
      }
      function openEditModal(
        userId,
        username,
        email,
        phoneNumber,
        gender,
        userDOB,
        status,
        roleId
      ) {
        document.getElementById("editUserId").value = userId;
        document.getElementById("editUsername").value = username;
        document.getElementById("editEmail").value = email;
        document.getElementById("editPhoneNumber").value = phoneNumber;
        document.getElementById("editGender").value = gender;
        document.getElementById("editUserDOB").value = userDOB;
        document.getElementById("editStatus").value = status;
        document.getElementById("editRoleId").value = roleId;
        document.getElementById("editModal").style.display = "flex";
      }
      function closeEditModal() {
        document.getElementById("editModal").style.display = "none";
      }
      // Đóng modal khi bấm nền tối
      window.onclick = function (event) {
        if (event.target === document.getElementById("addModal"))
          closeAddModal();
        if (event.target === document.getElementById("editModal"))
          closeEditModal();
      };

      function validateUserForm(form) {
        let valid = true;
        let firstError = null;
        // Xóa lỗi cũ
        form.querySelectorAll('.input-error').forEach(e => e.remove());
        // Helper
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
        // Username
        const username = form.username;
        if (!username.value.trim()) showError(username, 'Username is required');
        else if (!/^[a-zA-Z0-9_]{4,32}$/.test(username.value)) showError(username, '4-32 chars, no special chars');
        // Email
        const email = form.email;
        if (!email.value.trim()) showError(email, 'Email is required');
        else if (!/^\S+@\S+\.\S+$/.test(email.value)) showError(email, 'Invalid email');
        // Phone
        const phone = form.phoneNumber;
        if (phone.value && !/^0\d{9,10}$/.test(phone.value)) showError(phone, 'Phone must be 10-11 digits, start with 0');
        // Gender
        const gender = form.gender;
        if (!gender.value) showError(gender, 'Gender is required');
        // Date of Birth
        const dob = form.userDOB;
        if (dob.value) {
          const d = new Date(dob.value);
          const now = new Date();
          if (d > now) showError(dob, 'Date of birth cannot be in the future');
          else {
            const age = now.getFullYear() - d.getFullYear();
            if (age < 18) showError(dob, 'User must be at least 18 years old');
          }
        }
        // Status
        const status = form.status;
        if (!['Active','Inactive','Banned','Deleted'].includes(status.value)) showError(status, 'Invalid status');
        // Password (chỉ bắt buộc khi thêm mới)
        const password = form.passwordHash;
        if (password && password.required) {
          if (!password.value) showError(password, 'Password is required');
          else if (password.value.length < 6) showError(password, 'Min 6 chars');
          else if (!/[A-Za-z]/.test(password.value) || !/\d/.test(password.value)) showError(password, 'Must have letter & number');
        }
        if (!valid && firstError) firstError.focus();
        return valid;
      }

      // Function to check phone number uniqueness via AJAX
      function checkPhoneNumberUniqueness(phoneNumber, userId = null) {
        return new Promise((resolve, reject) => {
          const xhr = new XMLHttpRequest();
          xhr.open('POST', '${pageContext.request.contextPath}/admin/check-phone-unique', true);
          xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
          
          let data = 'phoneNumber=' + encodeURIComponent(phoneNumber);
          if (userId) {
            data += '&userId=' + encodeURIComponent(userId);
          }
          
          xhr.onreadystatechange = function() {
            if (xhr.readyState === 4) {
              if (xhr.status === 200) {
                try {
                  const response = JSON.parse(xhr.responseText);
                  resolve(response.isUnique);
                } catch (e) {
                  reject('Invalid response format');
                }
              } else {
                reject('Request failed');
              }
            }
          };
          
          xhr.send(data);
        });
      }

      // Add real-time phone number validation
      function addPhoneNumberValidation() {
        const phoneInputs = document.querySelectorAll('input[name="phoneNumber"]');
        phoneInputs.forEach(input => {
          let timeoutId;
          
          input.addEventListener('input', function() {
            clearTimeout(timeoutId);
            const phoneNumber = this.value.trim();
            
            // Remove existing error messages
            const existingError = this.parentNode.querySelector('.input-error');
            if (existingError) {
              existingError.remove();
            }
            
            // Clear existing validation classes
            this.classList.remove('is-valid', 'is-invalid');
            
            if (phoneNumber && /^0\d{9,10}$/.test(phoneNumber)) {
              // Add loading state
              this.classList.add('validating');
              
              timeoutId = setTimeout(() => {
                const userId = this.closest('form').querySelector('input[name="userId"]')?.value;
                
                checkPhoneNumberUniqueness(phoneNumber, userId)
                  .then(isUnique => {
                    this.classList.remove('validating');
                    if (isUnique) {
                      this.classList.add('is-valid');
                      showSuccess(this, 'Số điện thoại có thể sử dụng');
                    } else {
                      this.classList.add('is-invalid');
                      showError(this, 'Số điện thoại đã tồn tại trong hệ thống');
                    }
                  })
                  .catch(error => {
                    this.classList.remove('validating');
                    console.error('Phone validation error:', error);
                  });
              }, 500); // Delay to avoid too many requests
            }
          });
        });
      }

      function showSuccess(input, msg) {
        const existingMsg = input.parentNode.querySelector('.input-success');
        if (existingMsg) existingMsg.remove();
        
        const success = document.createElement('div');
        success.className = 'input-success';
        success.style.color = '#28a745';
        success.style.fontSize = '13px';
        success.style.marginTop = '2px';
        success.textContent = msg;
        input.parentNode.appendChild(success);
      }

      function showError(input, msg) {
        const existingMsg = input.parentNode.querySelector('.input-error');
        if (existingMsg) existingMsg.remove();
        
        const err = document.createElement('div');
        err.className = 'input-error';
        err.style.color = '#e74c3c';
        err.style.fontSize = '13px';
        err.style.marginTop = '2px';
        err.textContent = msg;
        input.parentNode.appendChild(err);
      }
      // Gắn validate cho form thêm/sửa user
      window.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('form[action$="/admin/user-management"]').forEach(form => {
          if (form.querySelector('[name=action][value=add]')) {
            form.onsubmit = function(e) { 
              e.preventDefault();
              return validateUserFormWithPhoneCheck(form, 'add'); 
            };
          }
          if (form.querySelector('[name=action][value=update]')) {
            form.onsubmit = function(e) { 
              e.preventDefault();
              return validateUserFormWithPhoneCheck(form, 'update'); 
            };
          }
        });
        
        // Initialize phone number validation
        addPhoneNumberValidation();
      });

      // Enhanced form validation with phone number uniqueness check
      async function validateUserFormWithPhoneCheck(form, action) {
        // First do basic validation
        if (!validateUserForm(form)) {
          return false;
        }
        
        // Check phone number uniqueness
        const phoneInput = form.querySelector('input[name="phoneNumber"]');
        const phoneNumber = phoneInput.value.trim();
        const userId = form.querySelector('input[name="userId"]')?.value;
        
        if (phoneNumber && /^0\d{9,10}$/.test(phoneNumber)) {
          try {
            const isUnique = await checkPhoneNumberUniqueness(phoneNumber, userId);
            if (!isUnique) {
              showError(phoneInput, 'Số điện thoại đã tồn tại trong hệ thống');
              phoneInput.focus();
              return false;
            }
          } catch (error) {
            console.error('Phone validation error:', error);
            showError(phoneInput, 'Lỗi kiểm tra số điện thoại');
            return false;
          }
        }
        
        // If all validations pass, submit the form
        form.submit();
        return true;
      }

      document.getElementById('userStatusFilter').addEventListener('change', function() {
        var status = this.value;
        var url = new URL(window.location.href);
        if (status === 'all') {
          url.searchParams.delete('status');
        } else {
          url.searchParams.set('status', status);
        }
        window.location.href = url.toString();
      });
      
      // Chức năng tìm kiếm theo username
      function searchUsers() {
        const searchTerm = document.getElementById('searchUsername').value.toLowerCase().trim();
        const rows = document.querySelectorAll('.user-row');
        let visibleRows = 0;
        
        rows.forEach(row => {
          const username = row.querySelector('td:first-child').textContent.toLowerCase();
          
          if (username.includes(searchTerm)) {
            row.classList.remove('filtered-out');
            visibleRows++;
          } else {
            row.classList.add('filtered-out');
          }
        });
        
        // Cập nhật phân trang sau khi lọc
        initPagination();
        
        // Hiển thị thông báo nếu không có kết quả
        const noResultsMessage = document.getElementById('noResultsMessage');
        if (visibleRows === 0 && searchTerm !== '') {
          if (!noResultsMessage) {
            const message = document.createElement('div');
            message.id = 'noResultsMessage';
            message.className = 'no-results-message';
            message.textContent = 'Không tìm thấy người dùng nào phù hợp';
            document.querySelector('.table-wrap').appendChild(message);
          }
        } else if (noResultsMessage) {
          noResultsMessage.remove();
        }
      }
      
      // Xử lý sự kiện tìm kiếm
      document.getElementById('searchButton').addEventListener('click', searchUsers);
      document.getElementById('searchUsername').addEventListener('keyup', function(event) {
        if (event.key === 'Enter') {
          searchUsers();
        }
      });
      
      // Phân trang
      function initPagination() {
        const rowsPerPage = 10;
        const rows = document.querySelectorAll('.user-row:not(.filtered-out)');
        const totalRows = rows.length;
        const totalPages = Math.ceil(totalRows / rowsPerPage);
        let currentPage = 1;
        
        // Cập nhật thông tin hiển thị
        function updatePaginationInfo() {
          document.getElementById('totalItems').textContent = totalRows;
          const startIndex = totalRows > 0 ? (currentPage - 1) * rowsPerPage + 1 : 0;
          const endIndex = Math.min(currentPage * rowsPerPage, totalRows);
          document.getElementById('startIndex').textContent = startIndex;
          document.getElementById('endIndex').textContent = endIndex;
        }
        
        // Tạo các nút số trang
        function createPageNumbers() {
          const pageNumbers = document.getElementById('pageNumbers');
          pageNumbers.innerHTML = '';
          
          // Hiển thị tối đa 5 nút số trang
          const maxPageButtons = 5;
          let startPage = Math.max(1, currentPage - Math.floor(maxPageButtons / 2));
          let endPage = Math.min(totalPages, startPage + maxPageButtons - 1);
          
          if (endPage - startPage + 1 < maxPageButtons) {
            startPage = Math.max(1, endPage - maxPageButtons + 1);
          }
          
          for (let i = startPage; i <= endPage; i++) {
            const pageNumber = document.createElement('div');
            pageNumber.className = 'page-number' + (i === currentPage ? ' active' : '');
            pageNumber.textContent = i;
            pageNumber.addEventListener('click', function() {
              goToPage(i);
            });
            pageNumbers.appendChild(pageNumber);
          }
        }
        
        // Hiển thị các hàng cho trang hiện tại
        function displayRows() {
          const allRows = document.querySelectorAll('.user-row');
          const visibleRows = document.querySelectorAll('.user-row:not(.filtered-out)');
          
          const start = (currentPage - 1) * rowsPerPage;
          const end = start + rowsPerPage;
          
          allRows.forEach(row => row.classList.add('hidden'));
          
          Array.from(visibleRows).forEach((row, index) => {
            if (index >= start && index < end) {
              row.classList.remove('hidden');
            }
          });
        }
        
        // Cập nhật trạng thái các nút điều hướng
        function updateNavigationButtons() {
          const prevButton = document.getElementById('prevPage');
          const nextButton = document.getElementById('nextPage');
          
          prevButton.disabled = currentPage === 1;
          nextButton.disabled = currentPage === totalPages || totalPages === 0;
        }
        
        // Chuyển đến trang cụ thể
        function goToPage(page) {
          currentPage = page;
          displayRows();
          updatePaginationInfo();
          createPageNumbers();
          updateNavigationButtons();
        }
        
        // Thiết lập sự kiện cho các nút điều hướng
        document.getElementById('prevPage').addEventListener('click', function() {
          if (currentPage > 1) {
            goToPage(currentPage - 1);
          }
        });
        
        document.getElementById('nextPage').addEventListener('click', function() {
          if (currentPage < totalPages) {
            goToPage(currentPage + 1);
          }
        });
        
        // Khởi tạo phân trang
        createPageNumbers();
        displayRows();
        updatePaginationInfo();
        updateNavigationButtons();
      }
      
      document.addEventListener('DOMContentLoaded', function() {
        initPagination();
      });
    </script>
  </body>
</html>
