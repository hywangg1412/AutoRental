<%-- 
    Document   : car-condition.jsp
    Created on : Jun 1, 2025, 11:00:54 AM
    Author     : ACER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Car Condition Report - CarRental Pro</title>
        
        <!-- ===== External CSS Libraries ===== -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        
        <!-- ===== Custom Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/staff/car-condition.css">
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
                    <a href="car-condition.jsp" class="nav-item active">
                        <i class="fas fa-car"></i>
                        <span>Car Condition</span>
                    </a>
                    <a href="car-availability.jsp" class="nav-item">
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
                    <h1 class="page-title">Báo Cáo Tình Trạng Xe</h1>
                    <p class="page-subtitle">Kiểm tra và báo cáo tình trạng xe sau khi khách hàng trả xe</p>
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
                            <option>Chờ Kiểm Tra</option>
                            <option>Hoàn Thành</option>
                            <option>Có Vấn Đề</option>
                        </select>
                    </div>
                    <div class="col-md-6">
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-search"></i>
                            </span>
                            <input type="text" class="form-control" placeholder="Tìm kiếm theo ID thuê, xe hoặc biển số">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <button class="btn btn-primary w-100">
                            <i class="fas fa-filter me-2"></i>Lọc Kết Quả
                        </button>
                    </div>
                </div>
            </div>

            <!-- Recently Completed Inspections -->
            <div class="content-section">
                <div class="section-header">
                    <h2 class="section-title">Các Kiểm Tra Gần Đây</h2>
                    <p class="section-subtitle">5 kiểm tra xe gần nhất đã hoàn thành</p>
                </div>

                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID Thuê</th>
                                <th>Xe</th>
                                <th>Biển Số</th>
                                <th>Ngày Kiểm Tra</th>
                                <th>Tình Trạng</th>
                                <th>Nhân Viên</th>
                                <th>Ghi Chú</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="rental-id">RNT-0995</td>
                                <td class="vehicle-name">Toyota Corolla</td>
                                <td class="license-plate">MNO-678</td>
                                <td class="inspection-date">15/11/2025</td>
                                <td>
                                    <span class="condition-badge normal">Bình Thường</span>
                                </td>
                                <td class="inspector-name">John Staff</td>
                                <td class="inspection-notes">Xe được trả trong tình trạng tuyệt vời</td>
                                <td>
                                    <button class="btn btn-outline-secondary btn-sm action-btn">
                                        <i class="fas fa-eye"></i>
                                        Xem
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td class="rental-id">RNT-0994</td>
                                <td class="vehicle-name">Hyundai Sonata</td>
                                <td class="license-plate">PQR-901</td>
                                <td class="inspection-date">15/11/2025</td>
                                <td>
                                    <span class="condition-badge needs-cleaning">Cần Vệ Sinh</span>
                                </td>
                                <td class="inspector-name">John Staff</td>
                                <td class="inspection-notes">Nội thất cần vệ sinh, có vết bẩn thức ăn trên ghế</td>
                                <td>
                                    <button class="btn btn-outline-secondary btn-sm action-btn">
                                        <i class="fas fa-eye"></i>
                                        Xem
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td class="rental-id">RNT-0993</td>
                                <td class="vehicle-name">Chevrolet Malibu</td>
                                <td class="license-plate">STU-234</td>
                                <td class="inspection-date">14/11/2025</td>
                                <td>
                                    <span class="condition-badge minor-scratches">Trầy Xước Nhẹ</span>
                                </td>
                                <td class="inspector-name">Sarah Admin</td>
                                <td class="inspection-notes">Vết trầy nhỏ ở cản sau, còn lại tốt</td>
                                <td>
                                    <button class="btn btn-outline-secondary btn-sm action-btn">
                                        <i class="fas fa-eye"></i>
                                        Xem
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td class="rental-id">RNT-0992</td>
                                <td class="vehicle-name">Kia Sportage</td>
                                <td class="license-plate">VWX-567</td>
                                <td class="inspection-date">14/11/2025</td>
                                <td>
                                    <span class="condition-badge normal">Bình Thường</span>
                                </td>
                                <td class="inspector-name">Sarah Admin</td>
                                <td class="inspection-notes">Không có vấn đề gì</td>
                                <td>
                                    <button class="btn btn-outline-secondary btn-sm action-btn">
                                        <i class="fas fa-eye"></i>
                                        Xem
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td class="rental-id">RNT-0991</td>
                                <td class="vehicle-name">Mazda CX-5</td>
                                <td class="license-plate">YZA-890</td>
                                <td class="inspection-date">13/11/2025</td>
                                <td>
                                    <span class="condition-badge major-damage">Hư Hỏng Nặng</span>
                                </td>
                                <td class="inspector-name">Mike Inspector</td>
                                <td class="inspection-notes">Vết lõm lớn ở cửa bên tài xế, cần sửa chữa</td>
                                <td>
                                    <button class="btn btn-outline-secondary btn-sm action-btn">
                                        <i class="fas fa-eye"></i>
                                        Xem
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Pending Inspections Section -->
            <div class="content-section">
                <div class="section-header">
                    <h2 class="section-title">Xe Chờ Kiểm Tra</h2>
                    <p class="section-subtitle">Các xe đang chờ kiểm tra sau khi trả</p>
                </div>

                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>ID Thuê</th>
                                <th>Xe</th>
                                <th>Khách Hàng</th>
                                <th>Ngày Trả</th>
                                <th>Tình Trạng Trước</th>
                                <th>Trạng Thái</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td class="rental-id">RNT-1001</td>
                                <td class="vehicle-name">Toyota Camry 2023</td>
                                <td class="customer-name">Nguyễn Văn An</td>
                                <td class="return-date">20/11/2025</td>
                                <td>
                                    <span class="condition-badge normal">Tốt</span>
                                </td>
                                <td>
                                    <span class="status-badge pending">Chờ Kiểm Tra</span>
                                </td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#inspectionModal">
                                        <i class="fas fa-search me-1"></i>Kiểm Tra Xe
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td class="rental-id">RNT-1002</td>
                                <td class="vehicle-name">Honda Civic 2022</td>
                                <td class="customer-name">Trần Thị Bình</td>
                                <td class="return-date">19/11/2025</td>
                                <td>
                                    <span class="condition-badge needs-cleaning">Bình Thường</span>
                                </td>
                                <td>
                                    <span class="status-badge pending">Chờ Kiểm Tra</span>
                                </td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#inspectionModal">
                                        <i class="fas fa-search me-1"></i>Kiểm Tra Xe
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td class="rental-id">RNT-1003</td>
                                <td class="vehicle-name">BMW X5 2021</td>
                                <td class="customer-name">Lê Minh Cường</td>
                                <td class="return-date">18/11/2025</td>
                                <td>
                                    <span class="condition-badge normal">Tốt</span>
                                </td>
                                <td>
                                    <span class="status-badge pending">Chờ Kiểm Tra</span>
                                </td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#inspectionModal">
                                        <i class="fas fa-search me-1"></i>Kiểm Tra Xe
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Inspection Modal -->
    <div class="modal fade" id="inspectionModal" tabindex="-1" aria-labelledby="inspectionModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-xl">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="inspectionModalLabel">
                        <i class="fas fa-clipboard-check me-2"></i>
                        Biểu Mẫu Kiểm Tra Xe
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
                                <label>ID Thuê:</label>
                                <span>RNT-1001</span>
                            </div>
                            <div class="info-item">
                                <label>Xe:</label>
                                <span>Toyota Camry 2023</span>
                            </div>
                            <div class="info-item">
                                <label>Biển Số:</label>
                                <span>ABC-123</span>
                            </div>
                            <div class="info-item">
                                <label>Khách Hàng:</label>
                                <span>Nguyễn Văn An</span>
                            </div>
                            <div class="info-item">
                                <label>Ngày Trả:</label>
                                <span>20/11/2025</span>
                            </div>
                            <div class="info-item">
                                <label>Quãng Đường:</label>
                                <span>15,240 km</span>
                            </div>
                        </div>
                    </div>

                    <!-- Overall Condition -->
                    <div class="inspection-section">
                        <h6 class="section-title">
                            <i class="fas fa-clipboard-list me-2"></i>Tình Trạng Chung
                        </h6>
                        <div class="row">
                            <div class="col-md-6">
                                <label class="form-label">Tình Trạng Tổng Quát *</label>
                                <select class="form-select" required>
                                    <option value="">Chọn tình trạng</option>
                                    <option value="clean">Sạch</option>
                                    <option value="dirty">Bẩn</option>
                                    <option value="smelly">Có mùi</option>
                                    <option value="minor-scratch">Trầy xước nhẹ</option>
                                    <option value="dent">Vết lõm</option>
                                    <option value="fuel-shortage">Thiếu xăng</option>
                                    <option value="broken-light">Hư đèn</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label">Mức Nhiên Liệu</label>
                                <select class="form-select">
                                    <option value="">Chọn mức nhiên liệu</option>
                                    <option value="full">Đầy</option>
                                    <option value="3/4">3/4</option>
                                    <option value="1/2">1/2</option>
                                    <option value="1/4">1/4</option>
                                    <option value="empty">Trống</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Interior Condition -->
                    <div class="inspection-section">
                        <h6 class="section-title">
                            <i class="fas fa-couch me-2"></i>Tình Trạng Nội Thất
                        </h6>
                        <div class="checkbox-grid">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="torn-seat">
                                <label class="form-check-label" for="torn-seat">Ghế rách</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="dusty">
                                <label class="form-check-label" for="dusty">Bụi bẩn</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="missing-accessories">
                                <label class="form-check-label" for="missing-accessories">Thiếu phụ kiện</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="cracked-mirror">
                                <label class="form-check-label" for="cracked-mirror">Nứt gương</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="broken-ac">
                                <label class="form-check-label" for="broken-ac">Hỏng điều hòa</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="cigarette-smell">
                                <label class="form-check-label" for="cigarette-smell">Mùi thuốc lá</label>
                            </div>
                        </div>
                    </div>

                    <!-- Photo Upload -->
                    <div class="inspection-section">
                        <h6 class="section-title">
                            <i class="fas fa-camera me-2"></i>Hình Ảnh Chứng Minh
                        </h6>
                        <div class="upload-area">
                            <input type="file" class="form-control" accept=".jpg,.jpeg,.png" multiple>
                            <div class="upload-placeholder">
                                <i class="fas fa-cloud-upload-alt"></i>
                                <p>Tải lên ảnh hư hỏng (JPG, PNG)</p>
                                <small>Tối đa 10 tệp, mỗi tệp 5MB</small>
                            </div>
                        </div>
                    </div>

                    <!-- Additional Notes -->
                    <div class="inspection-section">
                        <h6 class="section-title">
                            <i class="fas fa-sticky-note me-2"></i>Ghi Chú Thêm
                        </h6>
                        <textarea class="form-control" rows="4" placeholder="Nhập ghi chú hoặc quan sát thêm..."></textarea>
                    </div>

                    <!-- Issue Classification -->
                    <div class="inspection-section">
                        <h6 class="section-title">
                            <i class="fas fa-exclamation-triangle me-2"></i>Phân Loại Vấn Đề
                        </h6>
                        <div class="classification-options">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="issueLevel" id="minor" value="minor">
                                <label class="form-check-label classification-minor" for="minor">
                                    <i class="fas fa-info-circle"></i>
                                    <span>Nhẹ</span>
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="issueLevel" id="serious" value="serious">
                                <label class="form-check-label classification-serious" for="serious">
                                    <i class="fas fa-exclamation-triangle"></i>
                                    <span>Nghiêm trọng</span>
                                </label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="issueLevel" id="urgent" value="urgent">
                                <label class="form-check-label classification-urgent" for="urgent">
                                    <i class="fas fa-tools"></i>
                                    <span>Cần bảo trì gấp</span>
                                </label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="button" class="btn btn-success">
                        <i class="fas fa-paper-plane me-1"></i>Gửi Báo Cáo
                    </button>
                    <button type="button" class="btn btn-primary">
                        <i class="fas fa-sync me-1"></i>Cập Nhật Trạng Thái
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- ===== External JavaScript Libraries ===== -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- ===== Common Excel Handler ===== -->
    <script src="${pageContext.request.contextPath}/scripts/common/excel-handler.js"></script>
    
    <!-- ===== Custom JavaScript ===== -->
    <script src="${pageContext.request.contextPath}/scripts/staff/car-condition.js"></script>
</body>
</html>