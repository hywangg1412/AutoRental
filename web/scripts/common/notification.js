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
    
    // Xử lý đặc biệt cho tất cả thông báo người dùng (bao gồm cả booking và trả xe)
    document.querySelectorAll('.notification-item').forEach(function(item) {
        item.addEventListener('click', function(e) {
            e.preventDefault(); // Ngăn chặn hành vi mặc định của thẻ a
            const notificationId = this.getAttribute('data-notification-id');
            console.log("Notification clicked:", notificationId);
            
            // Đánh dấu đã đọc
            markAsRead(notificationId);
            
            // Kiểm tra nội dung thông báo
            const messageText = this.querySelector('.notification-title')?.textContent?.trim().toLowerCase() || '';
            
            // Xử lý chuyển hướng dựa vào nội dung thông báo
            if (messageText.includes('booking') || 
                messageText.includes('approved') || 
                messageText.includes('rejected') || 
                messageText.includes('return') || 
                messageText.includes('confirmed')) {
                
                // Chuyển hướng đến trang my-trip
                console.log("Redirecting to my-trip page based on notification content");
                setTimeout(function() {
                    window.location.href = contextPath + '/user/my-trip';
                }, 200);
            }
        });
    });
    
    // Xử lý click cho staff notification
    document.querySelectorAll('.notification-item:not(.user-notification)').forEach(function(item) {
        // Đảm bảo không ghi đè sự kiện đã thêm ở trên
        if (!item.classList.contains('notification-handled')) {
            item.addEventListener('click', function(e) {
                e.preventDefault();
                const notificationId = this.getAttribute('data-notification-id');
                const message = this.getAttribute('data-notification-message') || '';
                console.log("Staff notification clicked:", notificationId, message);
                
                // Đánh dấu đã đọc
                markAsRead(notificationId);
                
                // Xử lý chuyển hướng dựa vào nội dung thông báo
                const messageText = message.toLowerCase();
                let redirectUrl = contextPath + '/staff/booking-approval-list'; // default
                
                if (messageText.includes('car return') || messageText.includes('return')) {
                    redirectUrl = contextPath + '/staff/car-condition';
                    console.log("Redirecting to car-condition page for return car notification");
                } else if (messageText.includes('booking request') || messageText.includes('new booking')) {
                    redirectUrl = contextPath + '/staff/booking-approval-list';
                    console.log("Redirecting to booking-approval-list page for booking request notification");
                }
                
                // Chuyển hướng sau khi đánh dấu đã đọc
                setTimeout(function() {
                    window.location.href = redirectUrl;
                }, 200);
            });
            item.classList.add('notification-handled');
        }
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
                showDeleteConfirmationModal(notificationId, item);
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
    
    // Hàm hiển thị modal xác nhận xóa
    function showDeleteConfirmationModal(notificationId, notificationElement) {
        // Tạo modal HTML
        const modalHTML = `
            <div class="modal fade" id="deleteNotificationModal" tabindex="-1" aria-labelledby="deleteNotificationModalLabel" aria-hidden="true">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title" id="deleteNotificationModalLabel">
                                <i class="fas fa-trash-alt text-danger me-2"></i>
                                Xóa thông báo
                            </h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <p class="mb-0">
                                <i class="fas fa-exclamation-triangle text-warning me-2"></i>
                                Bạn có chắc chắn muốn xóa thông báo này?
                            </p>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                                <i class="fas fa-times me-1"></i>
                                Hủy
                            </button>
                            <button type="button" class="btn btn-danger" id="confirmDeleteBtn">
                                <i class="fas fa-trash-alt me-1"></i>
                                Xóa
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        `;
        
        // Thêm modal vào body nếu chưa có
        if (!document.getElementById('deleteNotificationModal')) {
            document.body.insertAdjacentHTML('beforeend', modalHTML);
        }
        
        // Hiển thị modal
        const modal = new bootstrap.Modal(document.getElementById('deleteNotificationModal'));
        modal.show();
        
        // Xử lý sự kiện xác nhận xóa
        document.getElementById('confirmDeleteBtn').onclick = function() {
            modal.hide();
            deleteNotification(notificationId, notificationElement);
        };
    }
    
    // Gọi API lấy số lượng notification khi trang load
    updateNotificationCount();
}); 