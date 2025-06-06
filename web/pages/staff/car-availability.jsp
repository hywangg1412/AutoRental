<%-- 
    Document   : car-availability
    Created on : Jun 1, 2025, 11:00:33 AM
    Author     : ACER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Tình Trạng Xe - CarRental Pro</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/car-availability.css">
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="sidebar-header">
                <div class="brand-logo">
                    <i class="fas fa-car"></i>
                </div>
                <div class="brand-info">
                    <h5 class="brand-title">AutoRental</h5>
                    <small class="brand-subtitle">Staff Dashboard</small>
                </div>
            </div>
            
            <div class="sidebar-content">
                <h6 class="nav-heading">Navigation</h6>
                <nav class="sidebar-nav">
                    <a href="staff-dashboard.jsp" class="nav-item">
                        <i class="fas fa-home"></i>
                        <span>Dashboard</span>
                    </a>
                    <a href="staff-booking.jsp" class="nav-item">
                        <i class="fas fa-calendar-alt"></i>
                        <span>Booking Requests</span>
                    </a>
                    <a href="car-condition.jsp" class="nav-item">
                        <i class="fas fa-car"></i>
                        <span>Car Condition</span>
                    </a>
                    <a href="car-availability.jsp" class="nav-item active">
                        <i class="fas fa-clipboard-list"></i>
                        <span>Car Availability</span>
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-shield-alt"></i>
                        <span>Damage Reports</span>
                    </a>
                    <a href="customer-support.jsp" class="nav-item">
                        <i class="fas fa-comment"></i>
                        <span>Customer Feedback</span>
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-users"></i>
                        <span>Support Users</span>
                    </a>
                </nav>
                
                <div class="sidebar-footer">
                    <a href="#" class="nav-item logout">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>Logout</span>
                    </a>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Header -->
            <div class="content-header">
                <div class="header-left">
                    <h1 class="page-title">Quản Lý Tình Trạng Xe</h1>
                    <p class="page-subtitle">Theo dõi và cập nhật tình trạng sẵn sàng của xe</p>
                </div>
                <div class="header-right">
                    <button class="btn btn-outline-secondary btn-sm me-2">
                        <i class="fas fa-bell"></i>
                        Thông Báo
                    </button>
                    <div class="user-profile">
                        <div class="user-avatar">JS</div>
                        <span class="user-name">John Staff</span>
                    </div>
                </div>
            </div>

            <!-- Progress Bar -->
            <div class="progress-container">
                <div class="progress">
                    <div class="progress-bar" style="width: 75%"></div>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <div class="row g-3">
                    <div class="col-md-3">
                        <select class="form-select">
                            <option>Tất Cả Trạng Thái</option>
                            <option>Sẵn Sàng</option>
                            <option>Đang Cho Thuê</option>
                            <option>Đang Bảo Trì</option>
                            <option>Sắp Có Sẵn</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <select class="form-select">
                            <option>Tất Cả Loại Xe</option>
                            <option>Sedan</option>
                            <option>SUV</option>
                            <option>Truck</option>
                            <option>Electric</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-search"></i>
                            </span>
                            <input type="text" class="form-control" placeholder="Tìm kiếm theo Model, Biển số, hoặc Brand">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <button class="btn btn-primary w-100">
                            <i class="fas fa-filter me-2"></i>Lọc
                        </button>
                    </div>
                </div>
            </div>

            <!-- Vehicle Availability Table -->
            <div class="content-section">
                <div class="section-header">
                    <h2 class="section-title">Danh Sách Xe</h2>
                    <p class="section-subtitle">Tình trạng hiện tại của tất cả xe trong hệ thống</p>
                </div>

                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Model</th>
                                <th>Biển Số</th>
                                <th>Trạng Thái</th>
                                <th>Đang Cho Ai Thuê</th>
                                <th>Thời Gian Có Sẵn Lại</th>
                                <th>Phí Trễ</th>
                                <th>Ghi Chú</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td class="vehicle-name">Toyota Camry 2023</td>
                                <td class="license-plate">ABC-123</td>
                                <td>
                                    <span class="status-badge badge-success">Sẵn Sàng</span>
                                </td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td class="notes">Xe đã được kiểm tra và sẵn sàng sử dụng</td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#updateModal">
                                        <i class="fas fa-edit me-1"></i>Cập Nhật
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td class="vehicle-name">Honda Civic 2022</td>
                                <td class="license-plate">XYZ-789</td>
                                <td>
                                    <span class="status-badge badge-warning">Đang Cho Thuê</span>
                                </td>
                                <td>Nguyễn Văn An</td>
                                <td>12:00 03/06/2025</td>
                                <td class="late-fee">100,000 VND</td>
                                <td class="notes">Muộn 2 tiếng so với lịch trả xe</td>
                                <td>
                                    <div class="d-flex gap-2">
                                        <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#updateModal">
                                            <i class="fas fa-edit me-1"></i>Cập Nhật
                                        </button>
                                        <button class="btn btn-success btn-sm" data-bs-toggle="modal" data-bs-target="#confirmReturnModal">
                                            <i class="fas fa-check me-1"></i>Xác Nhận Trả Xe
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td class="vehicle-name">BMW X5 2021</td>
                                <td class="license-plate">DEF-456</td>
                                <td>
                                    <span class="status-badge badge-danger">Đang Bảo Trì</span>
                                </td>
                                <td>-</td>
                                <td>Còn 2 ngày</td>
                                <td>-</td>
                                <td class="notes">Thay lốp và kiểm tra động cơ</td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#updateModal">
                                        <i class="fas fa-edit me-1"></i>Cập Nhật
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>4</td>
                                <td class="vehicle-name">Tesla Model 3</td>
                                <td class="license-plate">GHI-012</td>
                                <td>
                                    <span class="status-badge badge-info">Sắp Có Sẵn</span>
                                </td>
                                <td>-</td>
                                <td>14:00 31/05/2025</td>
                                <td>-</td>
                                <td class="notes">Đang vệ sinh, sẵn sàng trong 2 giờ</td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#updateModal">
                                        <i class="fas fa-edit me-1"></i>Cập Nhật
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>5</td>
                                <td class="vehicle-name">Ford Ranger 2022</td>
                                <td class="license-plate">JKL-345</td>
                                <td>
                                    <span class="status-badge badge-success">Sẵn Sàng</span>
                                </td>
                                <td>-</td>
                                <td>-</td>
                                <td>-</td>
                                <td class="notes">Xe mới kiểm tra, đầy đủ nhiên liệu</td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#updateModal">
                                        <i class="fas fa-edit me-1"></i>Cập Nhật
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Update Status Modal -->
    <div class="modal fade" id="updateModal" tabindex="-1" aria-labelledby="updateModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="updateModalLabel">
                        <i class="fas fa-clipboard-check me-2"></i>
                        Cập Nhật Tình Trạng Xe
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Vehicle Information -->
                    <div class="inspection-section">
                        <h6 class="section-title">
                            <i class="fas fa-info-circle me-2"></i>Thông Tin Xe
                        </h6>
                        <div class="vehicle-info-grid">
                            <div class="info-item">
                                <label>Model:</label>
                                <span>Toyota Camry 2023</span>
                            </div>
                            <div class="info-item">
                                <label>Biển Số:</label>
                                <span>ABC-123</span>
                            </div>
                            <div class="info-item">
                                <label>Loại Xe:</label>
                                <span>Sedan</span>
                            </div>
                        </div>
                    </div>

                    <!-- Update Status -->
                    <div class="inspection-section">
                        <h6 class="section-title">
                            <i class="fas fa-cog me-2"></i>Cập Nhật Trạng Thái
                        </h6>
                        <div class="row">
                            <div class="col-md-6">
                                <label class="form-label">Trạng Thái *</label>
                                <select class="form-select" required>
                                    <option value="">Chọn trạng thái</option>
                                    <option value="ready">Sẵn Sàng</option>
                                    <option value="rented">Đang Cho Thuê</option>
                                    <option value="maintenance">Đang Bảo Trì</option>
                                    <option value="soon">Sắp Có Sẵn</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Thời Gian Sẵn Sàng Lại</label>
                                <input type="datetime-local" class="form-control">
                            </div>
                        </div>
                    </div>

                    <!-- Notes -->
                    <div class="inspection-section">
                        <h6 class="section-title">
                            <i class="fas fa-sticky-note me-2"></i>Ghi Chú
                        </h6>
                        <textarea class="form-control" rows="4" placeholder="Nhập ghi chú về tình trạng xe..."></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-primary">
                        <i class="fas fa-save me-1"></i>Lưu Thay Đổi
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Confirm Return Modal -->
    <div class="modal fade" id="confirmReturnModal" tabindex="-1" aria-labelledby="confirmReturnModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="confirmReturnModalLabel">
                        <i class="fas fa-check-circle me-2"></i>Xác Nhận Trả Xe
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="/api/confirm-return" method="post">
                        <input type="hidden" name="bookingId" value="RNT-1002">
                        <p>Xác nhận xe <strong>Honda Civic 2022 (XYZ-789)</strong> đã được trả bởi <strong>Nguyễn Văn An</strong>.</p>
                        <p><strong>Phí Trễ:</strong> 100,000 VND (muộn 2 tiếng)</p>
                        <div class="mb-3">
                            <label for="confirm-notes" class="form-label">Ghi Chú (Tùy chọn)</label>
                            <textarea class="form-control" id="confirm-notes" name="notes" rows="3" placeholder="Nhập ghi chú nếu có..."></textarea>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-check me-1"></i>Xác Nhận
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
<script type="text/javascript">
        var gk_isXlsx = false;
        var gk_xlsxFileLookup = {};
        var gk_fileData = {};
        function filledCell(cell) {
          return cell !== '' && cell != null;
        }
        function loadFileData(filename) {
        if (gk_isXlsx && gk_xlsxFileLookup[filename]) {
            try {
                var workbook = XLSX.read(gk_fileData[filename], { type: 'base64' });
                var firstSheetName = workbook.SheetNames[0];
                var worksheet = workbook.Sheets[firstSheetName];

                // Convert sheet to JSON to filter blank rows
                var jsonData = XLSX.utils.sheet_to_json(worksheet, { header: 1, blankrows: false, defval: '' });
                // Filter out blank rows (rows where all cells are empty, null, or undefined)
                var filteredData = jsonData.filter(row => row.some(filledCell));
                // Heuristic to find the header row by ignoring rows with fewer filled cells than the next row
                var headerRowIndex = filteredData.findIndex((row, index) =>
                  row.filter(filledCell).length >= filteredData[index + 1]?.filter(filledCell).length
                );
                // Fallback
                if (headerRowIndex === -1 || headerRowIndex > 25) {
                  headerRowIndex = 0;
                }
                // Convert filtered JSON back to CSV
                var csv = XLSX.utils.aoa_to_sheet(filteredData.slice(headerRowIndex)); // Create a new sheet from filtered array of arrays
                csv = XLSX.utils.sheet_to_csv(csv, { header: 1 });
                return csv;
            } catch (e) {
                console.error(e);
                return "";
            }
        }
        return gk_fileData[filename] || "";
        }
        </script>