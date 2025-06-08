<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>My Trips - Auto Rental</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
        <!-- Bootstrap Icons -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

        <style>
            :root {
                --primary-green: #10b981;
                --light-green: #f0fdf4;
                --warning-orange: #f59e0b;
                --danger-red: #dc2626;
                --light-gray: #f8f9fa;
                --border-gray: #e5e7eb;
                --text-gray: #6b7280;
            }

            body {
                background-color: var(--light-gray);
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            }

            .header {
                background: white;
                border-bottom: 1px solid var(--border-gray);
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            }

            .logo {
                font-weight: bold;
                font-size: 1.25rem;
            }

            .logo .text-dark {
                color: #333 !important;
            }

            .logo .text-success {
                color: var(--primary-green) !important;
            }

            .nav-links a {
                color: var(--text-gray);
                text-decoration: none;
                transition: color 0.2s;
            }

            .nav-links a:hover {
                color: var(--primary-green);
            }

            .user-avatar {
                width: 32px;
                height: 32px;
                background-color: #d1d5db;
            }

            .sidebar {
                background: white;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
                height: fit-content;
            }

            .sidebar-menu {
                list-style: none;
                padding: 0;
                margin: 0;
            }

            .sidebar-menu .nav-link {
                color: var(--text-gray);
                border-radius: 0;
                padding: 0.75rem 1.5rem;
                display: flex;
                align-items: center;
                gap: 0.75rem;
                transition: all 0.2s;
                border: none;
            }

            .sidebar-menu .nav-link:hover {
                background-color: #f3f4f6;
                color: var(--primary-green);
            }

            .sidebar-menu .nav-link.active {
                background-color: var(--light-green);
                color: var(--primary-green);
                border-right: 3px solid var(--primary-green);
            }

            .sidebar-menu .nav-link.text-danger:hover {
                background-color: #fee2e2;
                color: var(--danger-red);
            }

            .main-content {
                background: white;
                border-radius: 12px;
                box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            }

            .custom-tabs {
                border-bottom: 1px solid var(--border-gray);
                margin-bottom: 2rem;
            }

            .custom-tabs .nav-link {
                border: none;
                color: var(--text-gray);
                font-weight: 500;
                padding: 1rem 0;
                margin-right: 2rem;
                background: transparent;
                border-bottom: 2px solid transparent;
                transition: all 0.3s ease;
            }

            .custom-tabs .nav-link:hover {
                color: var(--primary-green);
                border-bottom-color: var(--primary-green);
            }

            .custom-tabs .nav-link.active {
                color: var(--primary-green);
                border-bottom-color: var(--primary-green);
            }

            .empty-state {
                text-align: center;
                padding: 4rem 2rem;
                color: var(--text-gray);
            }

            .filter-btn {
                border: 1px solid var(--border-gray);
                background: white;
                color: var(--text-gray);
                padding: 0.5rem 1rem;
                border-radius: 6px;
                font-size: 0.875rem;
                transition: all 0.2s;
            }

            .filter-btn:hover {
                border-color: var(--primary-green);
                color: var(--primary-green);
            }

            .dropdown-toggle::after {
                margin-left: 0.5rem;
            }

            /* Filter Modal Styles */
            .filter-modal .modal-header {
                border-bottom: 1px solid var(--border-gray);
                padding: 1.5rem;
            }

            .filter-modal .modal-body {
                padding: 1.5rem;
            }

            .filter-modal .modal-footer {
                border-top: 1px solid var(--border-gray);
                padding: 1.5rem;
            }

            .filter-section {
                margin-bottom: 1.5rem;
            }

            .filter-label {
                font-weight: 500;
                color: #333;
                margin-bottom: 0.75rem;
                display: block;
            }

            .filter-options {
                display: flex;
                gap: 1rem;
                margin-bottom: 1rem;
            }

            .filter-radio {
                display: flex;
                align-items: center;
                gap: 0.5rem;
            }

            .filter-radio input[type="radio"] {
                accent-color: var(--primary-green);
            }

            .filter-radio label {
                font-size: 0.875rem;
                color: var(--text-gray);
                margin: 0;
            }

            .filter-radio input[type="radio"]:checked + label {
                color: var(--primary-green);
                font-weight: 500;
            }

            .btn-clear-filter {
                background: transparent;
                border: 1px solid var(--border-gray);
                color: var(--text-gray);
                padding: 0.75rem 1.5rem;
                border-radius: 6px;
                transition: all 0.2s;
            }

            .btn-clear-filter:hover {
                background-color: #f3f4f6;
                border-color: var(--text-gray);
                color: var(--text-gray);
            }

            .btn-apply-filter {
                background-color: var(--primary-green);
                border-color: var(--primary-green);
                color: white;
                padding: 0.75rem 1.5rem;
                border-radius: 6px;
                transition: all 0.2s;
            }

            .btn-apply-filter:hover {
                background-color: #059669;
                border-color: #059669;
                color: white;
            }

            .tab-content {
                animation: fadeIn 0.3s ease-in-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <header class="header">
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center py-3">
                    <div class="logo">
                        <span class="text-dark">AUTO</span><span class="text-success">RENTAL</span>
                    </div>
                    <div class="d-flex align-items-center gap-4">
                        <nav class="nav-links d-flex gap-4">
                            <a href="#" class="fw-medium">About</a>
                            <a href="#" class="fw-medium">My trips</a>
                        </nav>
                        <div class="d-flex align-items-center gap-2">
                            <i class="bi bi-bell"></i>
                            <i class="bi bi-chat-dots"></i>
                            <div class="dropdown">
                                <button class="btn btn-link text-decoration-none text-dark dropdown-toggle d-flex align-items-center gap-2" 
                                        type="button" data-bs-toggle="dropdown">
                                    <div class="user-avatar rounded-circle"></div>
                                    <span>hywang1412</span>
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item" href="#">Profile</a></li>
                                    <li><a class="dropdown-item" href="#">Settings</a></li>
                                    <li><hr class="dropdown-divider"></li>
                                    <li><a class="dropdown-item" href="#">Logout</a></li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <div class="container-fluid mt-4">
            <div class="row g-4">
                <!-- Sidebar -->
                <div class="col-lg-3">
                    <div class="sidebar p-4">
                        <h2 class="h4 fw-bold mb-4">Hello !</h2>
                        <ul class="sidebar-menu">
                            <li><a href="#" class="nav-link">
                                    <i class="bi bi-person"></i>
                                    My account
                                </a></li>
                            <li><a href="#" class="nav-link">
                                    <i class="bi bi-heart"></i>
                                    Favorite cars
                                </a></li>
                            <li><a href="#" class="nav-link active">
                                    <i class="bi bi-car-front"></i>
                                    My trips
                                </a></li>
                            <li><a href="#" class="nav-link">
                                    <i class="bi bi-clipboard-check"></i>
                                    Long-term car rental orders
                                </a></li>
                            <li><a href="#" class="nav-link">
                                    <i class="bi bi-geo-alt"></i>
                                    My address
                                </a></li>
                            <li><a href="#" class="nav-link">
                                    <i class="bi bi-lock"></i>
                                    Change password
                                </a></li>
                            <li><a href="#" class="nav-link">
                                    <i class="bi bi-trash"></i>
                                    Request account deletion
                                </a></li>
                            <li class="mt-3"><a href="#" class="nav-link text-danger">
                                    <i class="bi bi-box-arrow-right"></i>
                                    Log out
                                </a></li>
                        </ul>
                    </div>
                </div>

                <!-- Main Content -->
                <div class="col-lg-9">
                    <div class="main-content p-4">
                        <!-- Page Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <h1 class="h4 fw-semibold mb-0">My trips</h1>
                            <button class="filter-btn d-none" id="filterBtn" data-bs-toggle="modal" data-bs-target="#filterModal">
                                <i class="bi bi-funnel me-2"></i>Filter
                            </button>
                        </div>

                        <!-- Custom Tabs -->
                        <ul class="nav custom-tabs" id="tripTabs" role="tablist">
                            <li class="nav-item" role="presentation">
                                <button class="nav-link active" id="current-trip-tab" data-bs-toggle="tab" 
                                        data-bs-target="#current-trip" type="button" role="tab">
                                    Current trip
                                </button>
                            </li>
                            <li class="nav-item" role="presentation">
                                <button class="nav-link" id="trip-history-tab" data-bs-toggle="tab" 
                                        data-bs-target="#trip-history" type="button" role="tab">
                                    Trip history
                                </button>
                            </li>
                        </ul>

                        <!-- Tab Content -->
                        <div class="tab-content" id="tripTabContent">
                            <!-- Current Trip Tab -->
                            <div class="tab-pane fade show active" id="current-trip" role="tabpanel">
                                <div class="empty-state">
                                    <i class="bi bi-car-front" style="font-size: 3rem; color: var(--text-gray); margin-bottom: 1rem;"></i>
                                    <h5 class="mb-3">You have no trip yet</h5>
                                    <p class="text-muted">Start your first trip by booking a car!</p>
                                </div>
                            </div>

                            <!-- Trip History Tab -->
                            <div class="tab-pane fade" id="trip-history" role="tabpanel">
                                <div class="empty-state">
                                    <i class="bi bi-clock-history" style="font-size: 3rem; color: var(--text-gray); margin-bottom: 1rem;"></i>
                                    <h5 class="mb-3">You have no trip yet</h5>
                                    <p class="text-muted">Your completed trips will appear here.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filter Modal -->
        <div class="modal fade filter-modal" id="filterModal" tabindex="-1" aria-labelledby="filterModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title fw-semibold" id="filterModalLabel">Bộ lọc</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <!-- Chỉ dẫn -->
                        <div class="filter-section">
                            <label class="filter-label">Chỉ dẫn</label>
                            <div class="filter-options">
                                <div class="filter-radio">
                                    <input type="radio" id="all-guide" name="guide" value="all" checked>
                                    <label for="all-guide">Tất cả</label>
                                </div>
                                <div class="filter-radio">
                                    <input type="radio" id="self-drive" name="guide" value="self">
                                    <label for="self-drive">Tự lái</label>
                                </div>
                                <div class="filter-radio">
                                    <input type="radio" id="with-driver" name="guide" value="driver">
                                    <label for="with-driver">Có tài</label>
                                </div>
                            </div>
                        </div>

                        <!-- Tình trạng xe -->
                        <div class="filter-section">
                            <label class="filter-label">Tình trạng xe</label>
                            <input type="text" class="form-control" placeholder="Nhập thông tin tìm kiếm">
                        </div>

                        <!-- Hiệp định đối tác -->
                        <div class="filter-section">
                            <label class="filter-label">Hiệp định đối tác</label>
                            <input type="text" class="form-control" placeholder="Nhập thông tin đối tác">
                        </div>

                        <!-- Sắp xếp -->
                        <div class="filter-section">
                            <label class="filter-label">Sắp xếp</label>
                            <select class="form-select">
                                <option selected>Ưu tiên thời gian thay đổi</option>
                                <option value="1">Giá tăng dần</option>
                                <option value="2">Giá giảm dần</option>
                                <option value="3">Đánh giá cao nhất</option>
                            </select>
                        </div>

                        <!-- Loại chuyến -->
                        <div class="filter-section">
                            <label class="filter-label">Loại chuyến</label>
                            <select class="form-select">
                                <option selected>Tất cả</option>
                                <option value="1">Chuyến ngắn</option>
                                <option value="2">Chuyến dài</option>
                                <option value="3">Chuyến theo giờ</option>
                            </select>
                        </div>

                        <!-- Trạng thái -->
                        <div class="filter-section">
                            <label class="filter-label">Trạng thái</label>
                            <select class="form-select">
                                <option selected>Tất cả</option>
                                <option value="1">Đang diễn ra</option>
                                <option value="2">Hoàn thành</option>
                                <option value="3">Đã hủy</option>
                                <option value="4">Chờ xác nhận</option>
                            </select>
                        </div>

                        <!-- Thời gian kết thúc (first) -->
                        <div class="filter-section">
                            <label class="filter-label">Thời gian kết thúc</label>
                            <input type="text" class="form-control" placeholder="Bắt đầu" readonly>
                        </div>

                        <!-- Thời gian kết thúc (second) -->
                        <div class="filter-section">
                            <label class="filter-label">Thời gian kết thúc</label>
                            <input type="text" class="form-control" placeholder="Bắt đầu" readonly>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-clear-filter">Xóa bộ lọc</button>
                        <button type="button" class="btn btn-apply-filter" data-bs-dismiss="modal">Áp dụng</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Show/hide filter button based on active tab
            document.addEventListener('DOMContentLoaded', function () {
                const filterBtn = document.getElementById('filterBtn');
                const tripHistoryTab = document.getElementById('trip-history-tab');
                const currentTripTab = document.getElementById('current-trip-tab');

                // Show filter button when Trip history tab is active
                tripHistoryTab.addEventListener('shown.bs.tab', function () {
                    filterBtn.classList.remove('d-none');
                });

                // Hide filter button when Current trip tab is active
                currentTripTab.addEventListener('shown.bs.tab', function () {
                    filterBtn.classList.add('d-none');
                });
            });

            // Clear filter functionality
            document.querySelector('.btn-clear-filter').addEventListener('click', function () {
                // Reset all form elements
                document.querySelectorAll('#filterModal input[type="radio"]').forEach(radio => {
                    if (radio.value === 'all')
                        radio.checked = true;
                    else
                        radio.checked = false;
                });

                document.querySelectorAll('#filterModal input[type="text"]').forEach(input => {
                    input.value = '';
                });

                document.querySelectorAll('#filterModal select').forEach(select => {
                    select.selectedIndex = 0;
                });
            });

            // Add smooth transition effect for tab switching
            document.querySelectorAll('[data-bs-toggle="tab"]').forEach(tab => {
                tab.addEventListener('shown.bs.tab', function (e) {
                    const targetPane = document.querySelector(e.target.getAttribute('data-bs-target'));
                    targetPane.style.animation = 'none';
                    targetPane.offsetHeight; // Trigger reflow
                    targetPane.style.animation = 'fadeIn 0.3s ease-in-out';
                });
            });
        </script>
    </body>
</html>