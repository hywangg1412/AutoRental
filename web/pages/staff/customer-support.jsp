<%-- 
    Document   : customer-support.jsp
    Created on : Jun 1, 2025, 11:01:19 AM
    Author     : ACER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hỗ Trợ & Phản Hồi Khách Hàng - CarRental Pro</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="css/customer-support.css">
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
                    <a href="staff-dashboard.js" class="nav-item">
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
                    <a href="car-availability.jsp" class="nav-item">
                        <i class="fas fa-clipboard-list"></i>
                        <span>Car Availability</span>
                    </a>
                    <a href="#" class="nav-item">
                        <i class="fas fa-shield-alt"></i>
                        <span>Damage Reports</span>
                    </a>
                    <a href="customer-support.jsp" class="nav-item active">
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
                    <h1 class="page-title">Hỗ Trợ & Phản Hồi Khách Hàng</h1>
                    <p class="page-subtitle">Quản lý đánh giá và hỗ trợ khách hàng</p>
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

            <!-- Customer Ratings Section -->
            <div class="content-section">
                <div class="section-header">
                    <h2 class="section-title">Đánh Giá Khách Hàng</h2>
                    <p class="section-subtitle">Xem và phản hồi các đánh giá từ khách hàng</p>
                </div>

                <div class="table-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th>STT</th>
                                <th>Tên Khách Hàng</th>
                                <th>Xe Đã Thuê</th>
                                <th>Số Sao</th>
                                <th>Nội Dung Đánh Giá</th>
                                <th>Ngày Đánh Giá</th>
                                <th>Trạng Thái Phản Hồi</th>
                                <th>Hành Động</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td class="customer-name">Nguyễn Văn An</td>
                                <td class="vehicle-name">Toyota Camry 2023</td>
                                <td class="rating">
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                </td>
                                <td class="comment">Dịch vụ tốt, xe sạch sẽ, nhân viên thân thiện.</td>
                                <td>30/05/2025</td>
                                <td>
                                    <span class="status-badge badge-success">Đã Phản Hồi</span>
                                </td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#replyModal">
                                        <i class="fas fa-reply me-1"></i>Phản Hồi
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>2</td>
                                <td class="customer-name">Trần Thị Bích</td>
                                <td class="vehicle-name">Honda Civic 2022</td>
                                <td class="rating">
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="far fa-star text-warning"></i>
                                    <i class="far fa-star text-warning"></i>
                                </td>
                                <td class="comment">Xe ổn nhưng giao xe hơi chậm.</td>
                                <td>29/05/2025</td>
                                <td>
                                    <span class="status-badge badge-warning">Chưa Phản Hồi</span>
                                </td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#replyModal">
                                        <i class="fas fa-reply me-1"></i>Phản Hồi
                                    </button>
                                </td>
                            </tr>
                            <tr>
                                <td>3</td>
                                <td class="customer-name">Lê Văn Cường</td>
                                <td class="vehicle-name">Tesla Model 3</td>
                                <td class="rating">
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="fas fa-star text-warning"></i>
                                    <i class="far fa-star text-warning"></i>
                                </td>
                                <td class="comment">Xe hiện đại, nhưng cần hướng dẫn sử dụng rõ hơn.</td>
                                <td>28/05/2025</td>
                                <td>
                                    <span class="status-badge badge-warning">Chưa Phản Hồi</span>
                                </td>
                                <td>
                                    <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#replyModal">
                                        <i class="fas fa-reply me-1"></i>Phản Hồi
                                    </button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Zalo Support Section -->
            <div class="content-section">
                <div class="section-header">
                    <h2 class="section-title">Hỗ Trợ Khách Hàng Qua Zalo</h2>
                    <p class="section-subtitle">Liên hệ trực tiếp với khách hàng để giải quyết yêu cầu</p>
                </div>

                <div class="card">
                    <div class="card-body">
                        <table class="table">
                            <thead>
                                <tr>
                                    <th>STT</th>
                                    <th>Tên Khách</th>
                                    <th>Yêu Cầu Hỗ Trợ</th>
                                    <th>Ngày</th>
                                    <th>Liên Hệ</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>1</td>
                                    <td class="customer-name">Trần Văn A</td>
                                    <td class="support-request">Không nhận được hợp đồng</td>
                                    <td>30/05/2025</td>
                                    <td>
                                        <a href="https://zalo.me/0123456789" class="btn btn-success btn-sm" data-bs-toggle="tooltip" data-bs-placement="top" title="Trò chuyện với khách hàng trên Zalo">
                                            <i class="fas fa-comment-dots me-1"></i>Zalo
                                        </a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td class="customer-name">Phạm Thị B</td>
                                    <td class="support-request">Cần hỗ trợ thay đổi thời gian thuê</td>
                                    <td>29/05/2025</td>
                                    <td>
                                        <a href="https://zalo.me/0987654321" class="btn btn-success btn-sm" data-bs-toggle="tooltip" data-bs-placement="top" title="Trò chuyện với khách hàng trên Zalo">
                                            <i class="fas fa-comment-dots me-1"></i>Zalo
                                        </a>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Reply Modal -->
    <div class="modal fade" id="replyModal" tabindex="-1" aria-labelledby="replyModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="replyModalLabel">
                        <i class="fas fa-reply me-2"></i>Phản Hồi Đánh Giá
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Original Comment -->
                    <div class="inspection-section">
                        <h6 class="section-title">
                            <i class="fas fa-comment me-2"></i>Thông Tin Đánh Giá
                        </h6>
                        <div class="comment-info">
                            <p><strong>Khách Hàng:</strong> Nguyễn Văn An</p>
                            <p><strong>Xe Thuê:</strong> Toyota Camry 2023</p>
                            <p><strong>Điểm Đánh Giá:</strong> 
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                                <i class="fas fa-star text-warning"></i>
                            </p>
                            <p><strong>Nội Dung:</strong> Dịch vụ tốt, xe sạch sẽ, nhân viên thân thiện.</p>
                            <p><strong>Ngày:</strong> 30/05/2025</p>
                        </div>
                    </div>

                    <!-- Reply Form -->
                    <div class="inspection-section">
                        <h6 class="section-title">
                            <i class="fas fa-pen me-2"></i>Nội Dung Phản Hồi
                        </h6>
                        <form action="/api/reply-comment" method="post">
                            <input type="hidden" name="commentId" value="CMT-001">
                            <textarea class="form-control" name="replyContent" rows="5" placeholder="Nhập nội dung phản hồi..." required></textarea>
                            <div class="mt-3 text-end">
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-paper-plane me-1"></i>Gửi Phản Hồi
                                </button>
                            </div>
                        </form>
                    </div>
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