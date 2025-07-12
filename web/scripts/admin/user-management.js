// Global variables
let currentUserId = null;
let currentUserName = null;

// Sidebar toggle
function toggleSidebar() {
    const sidebar = document.getElementById('sidebar');
    sidebar.classList.toggle('collapsed');
}

// Modal functions
function openAddUserModal() {
    document.getElementById('addUserModal').style.display = 'flex';
}

function closeAddUserModal() {
    document.getElementById('addUserModal').style.display = 'none';
    document.getElementById('addUserForm').reset();
}

function openBanUserModal(userId, userName) {
    currentUserId = userId;
    currentUserName = userName;
    document.getElementById('banUserModal').style.display = 'flex';
}

function closeBanUserModal() {
    document.getElementById('banUserModal').style.display = 'none';
    document.getElementById('banReason').value = '';
    currentUserId = null;
    currentUserName = null;
}

function openAccountDetailModal() {
    document.getElementById('accountDetailModal').style.display = 'flex';
}

function closeAccountDetailModal() {
    document.getElementById('accountDetailModal').style.display = 'none';
}

// User action functions
function viewUser(userId) {
    // Fetch user details from server
    fetch(`${window.location.origin}${window.location.pathname}?action=view&userId=${userId}`)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                populateUserDetailModal(data.user);
                openAccountDetailModal();
            } else {
                alert('Error loading user details: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error loading user details');
        });
}

function populateUserDetailModal(user) {
    // Populate modal with user data
    document.getElementById('detailFullName').textContent = user.fullName || 'N/A';
    document.getElementById('detailEmail').textContent = user.email || 'N/A';
    document.getElementById('detailPhone').textContent = user.phoneNumber || 'N/A';
    document.getElementById('detailUsername').textContent = user.username || 'N/A';
    document.getElementById('detailGender').textContent = user.gender || 'N/A';
    document.getElementById('detailDob').textContent = user.dateOfBirth ? user.dateOfBirth.substring(0, 10) : 'N/A';
    document.getElementById('detailAddress').textContent = user.address || 'N/A';
    document.getElementById('detailJoinDate').textContent = user.createdDate ? user.createdDate.substring(0, 10) : 'N/A';
    document.getElementById('detailRole').textContent = user.role || 'N/A';
    document.getElementById('detailStatus').textContent = user.status || 'N/A';
    document.getElementById('detailBookingCount').textContent = user.bookingCount || '0';
    document.getElementById('detailTotalSpent').textContent = formatCurrency(user.totalSpent || 0);
    
    // Set join year
    if (user.createdDate) {
        const joinYear = user.createdDate.substring(0, 4);
        document.getElementById('detailJoinYear').textContent = `Tham gia từ năm ${joinYear}`;
    }
    
    // Set avatar if available
    if (user.avatar) {
        document.getElementById('detailAvatar').src = user.avatar;
        document.getElementById('detailAvatar').style.display = 'block';
        document.getElementById('avatarFallback').style.display = 'none';
    } else {
        document.getElementById('detailAvatar').style.display = 'none';
        document.getElementById('avatarFallback').style.display = 'flex';
    }
}

function editUser(userId) {
    // Redirect to edit user page or open edit modal
    window.location.href = `${window.location.origin}${window.location.pathname}?action=edit&userId=${userId}`;
}

function banUser(userId, userName) {
    openBanUserModal(userId, userName);
}

function unbanUser(userId, userName) {
    if (confirm(`Are you sure you want to unban ${userName}?`)) {
        fetch(`${window.location.origin}${window.location.pathname}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `action=unban&userId=${userId}`
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('User unbanned successfully');
                location.reload();
            } else {
                alert('Error unbanning user: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error unbanning user');
        });
    }
}

function confirmBanUser() {
    const reason = document.getElementById('banReason').value.trim();
    if (!reason) {
        alert('Please enter a reason for banning this user');
        return;
    }
    
    fetch(`${window.location.origin}${window.location.pathname}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: `action=ban&userId=${currentUserId}&reason=${encodeURIComponent(reason)}`
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('User banned successfully');
            closeBanUserModal();
            location.reload();
        } else {
            alert('Error banning user: ' + data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Error banning user');
    });
}

function deleteUser(userId, userName) {
    if (confirm(`Are you sure you want to delete ${userName}? This action cannot be undone.`)) {
        fetch(`${window.location.origin}${window.location.pathname}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: `action=delete&userId=${userId}`
        })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('User deleted successfully');
                location.reload();
            } else {
                alert('Error deleting user: ' + data.message);
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Error deleting user');
        });
    }
}

function saveUser() {
    const form = document.getElementById('addUserForm');
    const formData = new FormData(form);
    
    fetch(`${window.location.origin}${window.location.pathname}`, {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        if (data.success) {
            alert('User added successfully');
            closeAddUserModal();
            location.reload();
        } else {
            alert('Error adding user: ' + data.message);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert('Error adding user');
    });
}

// Filter and search functions
function filterUsers() {
    const searchTerm = document.getElementById('searchUsers').value.toLowerCase();
    const roleFilter = document.getElementById('roleFilter').value;
    const statusFilter = document.getElementById('statusFilter').value;
    
    const table = document.getElementById('usersTable');
    const rows = table.getElementsByTagName('tbody')[0].getElementsByTagName('tr');
    
    for (let row of rows) {
        const name = row.cells[0].textContent.toLowerCase();
        const email = row.cells[0].getElementsByClassName('text-sm')[0].textContent.toLowerCase();
        const role = row.cells[3].textContent.trim();
        const status = row.cells[6].textContent.trim();
        
        const matchesSearch = name.includes(searchTerm) || email.includes(searchTerm);
        const matchesRole = roleFilter === 'all' || role === roleFilter;
        const matchesStatus = statusFilter === 'all' || status === statusFilter;
        
        row.style.display = matchesSearch && matchesRole && matchesStatus ? '' : 'none';
    }
}

// Utility functions
function formatCurrency(amount) {
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'
    }).format(amount);
}

// Event listeners
document.addEventListener('DOMContentLoaded', function() {
    // Search and filter event listeners
    document.getElementById('searchUsers').addEventListener('input', filterUsers);
    document.getElementById('roleFilter').addEventListener('change', filterUsers);
    document.getElementById('statusFilter').addEventListener('change', filterUsers);
    
    // Close modals when clicking outside
    window.addEventListener('click', function(event) {
        const modals = document.querySelectorAll('.modal-overlay');
        modals.forEach(modal => {
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        });
    });
    
    // Close modals with Escape key
    document.addEventListener('keydown', function(event) {
        if (event.key === 'Escape') {
            const modals = document.querySelectorAll('.modal-overlay');
            modals.forEach(modal => {
                if (modal.style.display === 'flex') {
                    modal.style.display = 'none';
                }
            });
        }
    });
});

// Export functions for global access
window.toggleSidebar = toggleSidebar;
window.openAddUserModal = openAddUserModal;
window.closeAddUserModal = closeAddUserModal;
window.viewUser = viewUser;
window.editUser = editUser;
window.banUser = banUser;
window.unbanUser = unbanUser;
window.deleteUser = deleteUser;
window.saveUser = saveUser;
window.confirmBanUser = confirmBanUser;
window.closeBanUserModal = closeBanUserModal;
window.openAccountDetailModal = openAccountDetailModal;
window.closeAccountDetailModal = closeAccountDetailModal;
