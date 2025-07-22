/**
 * Script xử lý thông báo chung cho cả user và staff
 */
document.addEventListener('DOMContentLoaded', function() {
    // Debug: Log kiểm tra
    console.log("Notification script loaded");
    
    // Lấy contextPath
    const contextPath = window.location.pathname.split('/').slice(0, 2).join('/');
    console.log("ContextPath:", contextPath);
    
    // Đảm bảo CSS của nút thông báo được áp dụng đúng
    const notificationBtn = document.querySelector('.notification-btn');
    if (notificationBtn) {
        // Đảm bảo các lớp CSS được áp dụng
        notificationBtn.classList.add('d-flex', 'align-items-center', 'position-relative');
    }
    
    // Xử lý đặc biệt cho thông báo người dùng
    document.querySelectorAll('.notification-item.user-notification').forEach(function(item) {
        item.addEventListener('click', function(e) {
            e.preventDefault(); // Ngăn chặn hành vi mặc định của thẻ a
            const notificationId = this.getAttribute('data-notification-id');
            console.log("User notification clicked:", notificationId);
            
            // Đánh dấu đã đọc
            markAsRead(notificationId);
            
            // Chuyển hướng đến trang my-trip
            console.log("Redirecting to my-trip page");
            setTimeout(function() {
                window.location.href = contextPath + '/user/my-trip';
            }, 200);
        });
    });
    
    // Đánh dấu một thông báo đã đọc khi click vào
    document.querySelectorAll('.notification-item.unread:not(.user-notification)').forEach(function(item) {
        item.addEventListener('click', function(e) {
            const notificationId = this.getAttribute('data-notification-id');
            console.log("Marking notification as read:", notificationId);
            markAsRead(notificationId);
        });
    });
    
    // Đánh dấu tất cả thông báo đã đọc
    const markAllBtn = document.querySelector('.mark-all-read-btn') || document.getElementById('markAllAsRead');
    if (markAllBtn) {
        markAllBtn.addEventListener('click', function(e) {
            e.preventDefault();
            e.stopPropagation();
            console.log("Marking all notifications as read");
            markAllAsRead();
        });
    }
    // Thêm nút xóa thông báo
    addDeleteButtonsToNotifications();
    
    // Hàm đánh dấu một thông báo đã đọc
    function markAsRead(notificationId) {
        console.log("Calling API to mark as read:", notificationId);
        fetch(contextPath + '/notifications/mark-read', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'notificationId=' + notificationId
        })
        .then(response => {
            console.log("API response status:", response.status);
            return response.json();
        })
        .then(data => {
            console.log("API response data:", data);
            if (data.success) {
                updateNotificationCount();
                
                // Cập nhật UI cho thông báo đã đọc
                const notificationItem = document.querySelector(`.notification-item[data-notification-id="${notificationId}"]`);
                if (notificationItem) {
                    notificationItem.classList.remove('unread');
                    notificationItem.classList.add('read');
                    
                    // Xử lý dot-unread (user) hoặc notification-dot (staff)
                    const dotUnread = notificationItem.querySelector('.dot-unread');
                    const notificationDot = notificationItem.querySelector('.notification-dot');
                    
                    if (dotUnread) dotUnread.remove();
                    if (notificationDot) notificationDot.remove();
                }
            }
        })
        .catch(error => {
            console.error("Error marking notification as read:", error);
        });
    }
    
    // Hàm đánh dấu tất cả thông báo đã đọc
    function markAllAsRead() {
        console.log("Calling API to mark all as read");
        fetch(contextPath + '/notifications/mark-read', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'all=true'
        })
        .then(response => {
            console.log("API response status:", response.status);
            return response.json();
        })
        .then(data => {
            console.log("API response data:", data);
            if (data.success) {
                updateNotificationCount();
                
                // Cập nhật UI cho tất cả thông báo
                document.querySelectorAll('.notification-item.unread').forEach(function(item) {
                    item.classList.remove('unread');
                    item.classList.add('read');
                    
                    // Xử lý dot-unread (user) hoặc notification-dot (staff)
                    const dotUnread = item.querySelector('.dot-unread');
                    const notificationDot = item.querySelector('.notification-dot');
                    
                    if (dotUnread) dotUnread.remove();
                    if (notificationDot) notificationDot.remove();
                });
                
                // Ẩn nút "Đánh dấu tất cả đã đọc"
                if (markAllBtn) markAllBtn.style.display = 'none';
                
                // Xóa badge thông báo
                document.querySelector('.notification-badge')?.remove();
            }
        })
        .catch(error => {
            console.error("Error marking all notifications as read:", error);
        });
    }
    
    // Hàm cập nhật số lượng thông báo chưa đọc
    function updateNotificationCount() {
        console.log("Calling API to update notification count");
        fetch(contextPath + '/notifications/count')
            .then(response => {
                console.log("API response status:", response.status);
                return response.json();
            })
            .then(data => {
                console.log("API response data:", data);
                
                // Xử lý badge thông báo cho user và staff
                const badge = document.querySelector('.notification-count') || document.querySelector('.notification-badge');
                const notificationBtn = document.querySelector('.notification-btn') || document.getElementById('userNotificationDropdown') || document.getElementById('notificationDropdown');
                
                if (data.count > 0) {
                    if (badge) {
                        badge.textContent = data.count;
                        badge.style.display = '';
                    } else if (notificationBtn) {
                        // Tạo badge mới nếu không tồn tại
                        const newBadge = document.createElement('span');
                        if (notificationBtn.id === 'userNotificationDropdown') {
                            // User badge
                            newBadge.className = 'notification-count';
                        } else {
                            // Staff badge
                            newBadge.className = 'position-absolute notification-badge';
                        }
                        newBadge.textContent = data.count;
                        notificationBtn.appendChild(newBadge);
                    }
                } else if (badge) {
                    badge.style.display = 'none';
                }
            })
            .catch(error => {
                console.error("Error updating notification count:", error);
            });
    }
    
    // Thêm sự kiện click cho biểu tượng thông báo để cập nhật số lượng
    const notificationDropdown = document.getElementById('userNotificationDropdown') || document.getElementById('notificationDropdown');
    if (notificationDropdown) {
        notificationDropdown.addEventListener('click', function() {
            updateNotificationCount();
        });
    }
    
    // Hàm thêm nút xóa vào các thông báo
    function addDeleteButtonsToNotifications() {
        document.querySelectorAll('.notification-item').forEach(function(item) {
            // Kiểm tra xem đã có nút xóa chưa
            const existingDeleteBtn = item.querySelector('.notification-actions');
            if (existingDeleteBtn) {
                return; // Nếu đã có nút xóa thì bỏ qua
            }
            
            // Tạo container cho nút xóa
            const deleteContainer = document.createElement('div');
            deleteContainer.className = 'notification-actions';
            
            // Tạo nút xóa
            const deleteBtn = document.createElement('button');
            deleteBtn.className = 'btn-delete-notification';
            deleteBtn.innerHTML = '<i class="fas fa-trash-alt"></i>';
            deleteBtn.title = 'Xóa thông báo';
            
            // Thêm sự kiện click cho nút xóa
            deleteBtn.addEventListener('click', function(e) {
                e.preventDefault();
                e.stopPropagation();
                const notificationId = item.getAttribute('data-notification-id');
                if (confirm('Bạn có chắc chắn muốn xóa thông báo này?')) {
                    deleteNotification(notificationId, item);
                }
            });
            
            // Thêm nút xóa vào container
            deleteContainer.appendChild(deleteBtn);
            
            // Thêm container vào thông báo
            const notificationContent = item.querySelector('.notification-content');
            if (notificationContent) {
                const notificationRow = notificationContent.querySelector('.notification-row');
                if (notificationRow) {
                    notificationRow.appendChild(deleteContainer);
                }
            }
        });
    }
    
    // Hàm xóa thông báo
    function deleteNotification(notificationId, notificationElement) {
        console.log("Deleting notification:", notificationId);
        fetch(contextPath + '/notifications/delete', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'notificationId=' + notificationId
        })
        .then(response => {
            console.log("API response status:", response.status);
            return response.json();
        })
        .then(data => {
            console.log("API response data:", data);
            if (data.success) {
                // Xóa thông báo khỏi DOM
                if (notificationElement) {
                    notificationElement.remove();
                }
                
                // Cập nhật số lượng thông báo nếu thông báo chưa đọc
                if (notificationElement.classList.contains('unread')) {
                    updateNotificationCount();
                }
                
                // Kiểm tra nếu không còn thông báo nào
                const remainingNotifications = document.querySelectorAll('.notification-item');
                if (remainingNotifications.length === 0) {
                    const dropdownMenu = document.getElementById('notificationDropdownMenu');
                    if (dropdownMenu) {
                        // Thêm thông báo "Không có thông báo mới"
                        const noNotificationsLi = document.createElement('li');
                        noNotificationsLi.innerHTML = '<span class="dropdown-item text-muted">Không có thông báo mới</span>';
                        
                        // Xóa tất cả các mục thông báo cũ
                        const items = dropdownMenu.querySelectorAll('li:not(.dropdown-header):not(.dropdown-divider)');
                        items.forEach(item => item.remove());
                        
                        // Thêm thông báo mới
                        dropdownMenu.appendChild(noNotificationsLi);
                    }
                }
            }
        })
        .catch(error => {
            console.error("Error deleting notification:", error);
            alert("Có lỗi xảy ra khi xóa thông báo. Vui lòng thử lại sau.");
        });
    }
    
    // Gọi API lấy số lượng notification khi trang load
    updateNotificationCount();
}); 