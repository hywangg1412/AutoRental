<!-- Right: Notifications and User -->
<div class="col-auto">
    <div class="d-flex align-items-center gap-3">
        <div class="dropdown">
            <button class="btn btn-outline-secondary btn-sm d-flex align-items-center gap-2 position-relative" data-bs-toggle="dropdown" aria-expanded="false" id="notificationDropdown">
                <i class="fas fa-bell"></i>
                <span>Notifications</span>
                <c:if test="${unreadCount > 0}">
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                        ${unreadCount}
                    </span>
                </c:if>
            </button>
            <ul class="dropdown-menu dropdown-menu-end">
                <li class="dropdown-header d-flex justify-content-between align-items-center">
                    <span>Notifications</span>
                    <c:if test="${unreadCount > 0}">
                        <button class="btn btn-sm btn-link text-decoration-none p-0" id="markAllAsRead">Mark all as read</button>
                    </c:if>
                </li>
                <li><hr class="dropdown-divider"></li>
                <c:choose>
                    <c:when test="${not empty notifications}">
                        <c:forEach var="noti" items="${notifications}">
                            <li>
                                <a class="dropdown-item notification-item ${noti.read ? 'read' : 'unread'}" 
                                   href="${pageContext.request.contextPath}/staff/booking-approval-list"
                                   data-notification-id="${noti.notificationId}">
                                    <div class="d-flex align-items-center">
                                        <div class="flex-grow-1">
                                            ${noti.message}
                                            <br>
                                            <small class="text-muted">${noti.createdDate}</small>
                                        </div>
                                        <c:if test="${!noti.read}">
                                            <span class="badge bg-primary ms-2">New</span>
                                        </c:if>
                                    </div>
                                </a>
                            </li>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <li><span class="dropdown-item text-muted">No new notifications</span></li>
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

<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Đánh dấu một thông báo đã đọc khi click vào
        document.querySelectorAll('.notification-item.unread').forEach(function(item) {
            item.addEventListener('click', function(e) {
                const notificationId = this.getAttribute('data-notification-id');
                markAsRead(notificationId);
            });
        });
        
        // Đánh dấu tất cả thông báo đã đọc
        const markAllBtn = document.getElementById('markAllAsRead');
        if (markAllBtn) {
            markAllBtn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                markAllAsRead();
            });
        }
        
        // Hàm đánh dấu một thông báo đã đọc
        function markAsRead(notificationId) {
            fetch('${pageContext.request.contextPath}/staff/notifications/mark-read', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=markAsRead&notificationId=' + notificationId
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    updateNotificationCount();
                }
            })
            .catch(error => console.error('Error:', error));
        }
        
        // Hàm đánh dấu tất cả thông báo đã đọc
        function markAllAsRead() {
            fetch('${pageContext.request.contextPath}/staff/notifications/mark-read', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: 'action=markAllAsRead'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    updateNotificationCount();
                    document.querySelectorAll('.notification-item.unread').forEach(function(item) {
                        item.classList.remove('unread');
                        item.classList.add('read');
                        item.querySelector('.badge')?.remove();
                    });
                    document.querySelector('.badge.rounded-pill.bg-danger')?.remove();
                    markAllBtn.style.display = 'none';
                }
            })
            .catch(error => console.error('Error:', error));
        }
        
        // Hàm cập nhật số lượng thông báo chưa đọc
        function updateNotificationCount() {
            fetch('${pageContext.request.contextPath}/staff/notifications/count')
                .then(response => response.json())
                .then(data => {
                    const badge = document.querySelector('.badge.rounded-pill.bg-danger');
                    if (data.count > 0) {
                        if (badge) {
                            badge.textContent = data.count;
                        } else {
                            const newBadge = document.createElement('span');
                            newBadge.className = 'position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger';
                            newBadge.textContent = data.count;
                            document.getElementById('notificationDropdown').appendChild(newBadge);
                        }
                    } else if (badge) {
                        badge.remove();
                    }
                })
                .catch(error => console.error('Error:', error));
        }
    });
</script>

<style>
    .notification-item.unread {
        background-color: rgba(13, 110, 253, 0.05);
        font-weight: 500;
    }
    .notification-item.read {
        background-color: transparent;
        font-weight: normal;
    }
</style>