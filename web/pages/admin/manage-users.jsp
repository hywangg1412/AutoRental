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
              <th>First Name</th>
              <th>Last Name</th>
              <th>Email</th>
              <th>Phone</th>
              <th>Gender</th>
              <th>Date of Birth</th>
              <th>Status</th>
              <th>Actions</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="user" items="${users}">
              <tr>
                <td>${user.username}</td>
                <td>${user.firstName}</td>
                <td>${user.lastName}</td>
                <td>${user.email}</td>
                <td>${user.phoneNumber}</td>
                <td>${user.gender}</td>
                <td>${user.userDOB}</td>
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
                    onclick="openEditModal('${user.userId}', '${user.username}', '${user.firstName}', '${user.lastName}', '${user.email}', '${user.phoneNumber}', '${user.gender}', '${user.userDOB}', '${user.status}', '${user.roleId}')"
                  >
                    <i class="fa fa-edit"></i> Edit
                  </button>
                  <form
                    method="post"
                    action="${pageContext.request.contextPath}/admin/user-management"
                    style="display: inline"
                    onsubmit="return confirm('Are you sure you want to delete this user?');"
                  >
                    <input type="hidden" name="action" value="delete" />
                    <input type="hidden" name="userId" value="${user.userId}" />
                    <button type="submit" class="btn btn-danger">
                      <i class="fa fa-trash"></i> Delete
                    </button>
                  </form>
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
          <div class="form-group">
            <label>Họ</label><input type="text" name="firstName" required />
          </div>
          <div class="form-group">
            <label>Tên</label><input type="text" name="lastName" required />
          </div>
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
          <div class="form-group">
            <label>Họ</label
            ><input type="text" name="firstName" id="editFirstName" required />
          </div>
          <div class="form-group">
            <label>Tên</label
            ><input type="text" name="lastName" id="editLastName" required />
          </div>
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
        firstName,
        lastName,
        email,
        phoneNumber,
        gender,
        userDOB,
        status,
        roleId
      ) {
        document.getElementById("editUserId").value = userId;
        document.getElementById("editUsername").value = username;
        document.getElementById("editFirstName").value = firstName;
        document.getElementById("editLastName").value = lastName;
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
        // First Name
        const firstName = form.firstName;
        if (!firstName.value.trim()) showError(firstName, 'First name is required');
        else if (!/^[a-zA-ZÀ-ỹ\s]{1,32}$/.test(firstName.value)) showError(firstName, 'Only letters, max 32 chars');
        // Last Name
        const lastName = form.lastName;
        if (!lastName.value.trim()) showError(lastName, 'Last name is required');
        else if (!/^[a-zA-ZÀ-ỹ\s]{1,32}$/.test(lastName.value)) showError(lastName, 'Only letters, max 32 chars');
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
      // Gắn validate cho form thêm/sửa user
      window.addEventListener('DOMContentLoaded', function() {
        document.querySelectorAll('form[action$="/admin/user-management"]').forEach(form => {
          if (form.querySelector('[name=action][value=add]')) {
            form.onsubmit = function() { return validateUserForm(form); };
          }
          if (form.querySelector('[name=action][value=update]')) {
            form.onsubmit = function() { return validateUserForm(form); };
          }
        });
      });

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
    </script>
  </body>
</html>
