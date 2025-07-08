document.addEventListener('DOMContentLoaded', function() {
    // Đánh dấu một thông báo đã đọc khi click vào
    document.querySelectorAll('.notification-item.unread').forEach(function(item) {
        item.addEventListener('click', function(e) {
            e.preventDefault();
            const notificationId = this.getAttribute('data-notification-id');
            if (notificationId) {
                markAsRead(notificationId, this);
            }
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
    function markAsRead(notificationId, element) {
        fetch(window.location.origin + '/user/notifications/mark-read', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=markAsRead&notificationId=' + notificationId
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Cập nhật UI: ẩn chấm xanh, đổi class
                element.classList.remove('unread');
                element.classList.add('read');
                const dot = element.querySelector('.dot-unread');
                if (dot) dot.style.display = 'none';
                updateNotificationCount();
            }
        })
        .catch(error => console.error('Error:', error));
    }
    
    // Hàm đánh dấu tất cả thông báo đã đọc
    function markAllAsRead() {
        fetch(window.location.origin + '/user/notifications/mark-read', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'action=markAllAsRead'
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Cập nhật UI
                document.querySelectorAll('.notification-item.unread').forEach(function(item) {
                    item.classList.remove('unread');
                    item.classList.add('read');
                    const dot = item.querySelector('.dot-unread');
                    if (dot) dot.style.display = 'none';
                });
                
                // Ẩn badge số lượng
                const countBadge = document.querySelector('.badge.rounded-pill.bg-danger');
                if (countBadge) countBadge.remove();
                
                // Ẩn button "Mark all as read"
                if (markAllBtn) markAllBtn.style.display = 'none';
                
                updateNotificationCount();
            }
        })
        .catch(error => console.error('Error:', error));
    }
    
    // Hàm cập nhật số lượng thông báo chưa đọc
    function updateNotificationCount() {
        fetch(window.location.origin + '/user/notifications/count')
            .then(response => response.json())
            .then(data => {
                const badge = document.querySelector('.badge.rounded-pill.bg-danger');
                if (data.count > 0) {
                    if (badge) {
                        badge.textContent = data.count;
                    } else {
                        const newBadge = document.createElement('span');
                        newBadge.className = 'position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger';
                        newBadge.style.fontSize = '0.7rem';
                        newBadge.textContent = data.count;
                        const dropdownButton = document.getElementById('userNotificationDropdown');
                        if (dropdownButton) {
                            dropdownButton.appendChild(newBadge);
                        }
                    }
                } else if (badge) {
                    badge.remove();
                }
            })
            .catch(error => console.error('Error:', error));
    }
    
    // Hàm refresh notifications
    function refreshNotifications() {
        fetch(window.location.origin + '/user/notifications/refresh', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            }
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                console.log('Notifications refreshed: ' + data.total + ' total, ' + data.count + ' unread');
                // Reload page để cập nhật UI
                window.location.reload();
            }
        })
        .catch(error => console.error('Error:', error));
    }
    
    // Auto refresh notifications mỗi 30 giây
    setInterval(refreshNotifications, 30000);
}); 