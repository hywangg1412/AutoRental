<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!-- Link CSS file cho thông báo -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/styles/staff/staff-notification.css">
<!-- Right: Notifications and User -->
<div class="col-auto">
    <div class="d-flex align-items-center gap-3">
        <div class="dropdown notification-wrapper">
            <button class="btn btn-outline-secondary btn-sm notification-btn" data-bs-toggle="dropdown" aria-expanded="false" id="notificationDropdown">
                <i class="fas fa-bell"></i>
                <c:if test="${unreadCount > 0}">
                    <span class="position-absolute notification-badge">
                        ${unreadCount}
                    </span>
                </c:if>
            </button>
            <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="notificationDropdown" id="notificationDropdownMenu">
                <li class="dropdown-header d-flex justify-content-between align-items-center">
                    <span>Thông báo</span>
                    <c:if test="${unreadCount > 0}">
                        <button class="btn btn-sm btn-link text-decoration-none p-0 mark-all-read-btn" id="markAllAsRead">Đánh dấu tất cả đã đọc</button>
                    </c:if>
                </li>
                <li><hr class="dropdown-divider"></li>
                <c:choose>
                    <c:when test="${not empty notifications}">
                        <c:forEach var="noti" items="${notifications}">
                            <li>
                                <a class="dropdown-item notification-item ${noti.isRead() ? 'read' : 'unread'}" 
                                   href="${pageContext.request.contextPath}/staff/booking-approval-list"
                                   data-notification-id="${noti.notificationId}"
                                   data-notification-message="${noti.message}">
                                    <div class="notification-content">
                                        <div class="notification-row">
                                            <span class="notification-title">${noti.message}</span>
                                            <c:if test="${!noti.isRead()}">
                                                <span class="dot-unread"></span>
                                            </c:if>
                                        </div>
                                        <small class="notification-time">
                                            <fmt:parseDate value="${noti.createdDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" />
                                            <fmt:formatDate value="${parsedDate}" pattern="dd-MM-yyyy HH:mm" />
                                        </small>
                                    </div>
                                </a>
                            </li>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <li><span class="dropdown-item text-muted">Không có thông báo mới</span></li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
        <div class="d-flex align-items-center gap-2">
            <a href="${pageContext.request.contextPath}/staff/profile" class="user-avatar">
                <img src="${not empty sessionScope.user.avatarUrl ? sessionScope.user.avatarUrl : pageContext.request.contextPath.concat('/assets/images/default-avatar.png')}"
                     alt="User Avatar"
                     width="32"
                     height="32"
                     class="rounded-circle"
                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-avatar.png';">
            </a>
            <a href="${pageContext.request.contextPath}/staff/profile" class="nav-link username-link text-dark d-flex align-items-center" style="padding: 0 !important;">
                <span class="fw-medium">${sessionScope.user.username}</span>
            </a>
            <div class="dropdown">
                <button class="btn btn-link nav-link p-0 text-dark dropdown-toggle" type="button" id="userDropdown" aria-expanded="false">
                  <i class="bi bi-three-dots-vertical" style="font-size: 1.2rem !important;"></i>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                  <li><a class="dropdown-item" href="${pageContext.request.contextPath}/staff/profile">Profile</a></li>
                  <li><hr class="dropdown-divider"></li>
                  <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                </ul>
            </div>
        </div>
    </div>
</div>

<!-- Include chung notification JavaScript -->
<script src="${pageContext.request.contextPath}/scripts/common/notification.js"></script>