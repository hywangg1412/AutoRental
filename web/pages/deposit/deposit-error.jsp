<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Lỗi Thanh Toán - AutoRental</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/bootstrap/bootstrap.min.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/style.css"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />
    <style>
      .error-container {
        min-height: 80vh;
        display: flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #ff6b6b 0%, #ee5a52 100%);
      }
      .error-card {
        background: white;
        border-radius: 20px;
        box-shadow: 0 15px 35px rgba(238, 90, 82, 0.2);
        padding: 3rem;
        text-align: center;
        max-width: 600px;
        width: 90%;
      }
      .error-icon {
        width: 80px;
        height: 80px;
        background: linear-gradient(45deg, #ff6b6b, #ee5a52);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 2rem;
        animation: bounce 2s infinite;
      }
      .error-icon i {
        font-size: 2.5rem;
        color: white;
      }
      @keyframes bounce {
        0%,
        20%,
        60%,
        100% {
          transform: translateY(0);
        }
        40% {
          transform: translateY(-10px);
        }
        80% {
          transform: translateY(-5px);
        }
      }
      .error-title {
        color: #2c3e50;
        font-weight: 700;
        margin-bottom: 1rem;
      }
      .error-message {
        color: #6c757d;
        margin-bottom: 2rem;
        line-height: 1.6;
      }
      .btn-primary {
        background: linear-gradient(45deg, #00C896, #00A67E);
        border: none;
        padding: 12px 30px;
        border-radius: 25px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 1px;
        transition: all 0.3s ease;
      }
      .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 15px rgba(0, 200, 150, 0.3);
        background: linear-gradient(45deg, #00A67E, #008B6B);
      }
      .btn-outline-secondary {
        border: 2px solid #00C896;
        color: #00C896;
        padding: 10px 25px;
        border-radius: 25px;
        font-weight: 600;
        text-decoration: none;
        display: inline-block;
        margin: 0 10px;
        transition: all 0.3s ease;
      }
      .btn-outline-secondary:hover {
        background: #00C896;
        color: white;
        text-decoration: none;
      }
      .btn-warning {
        background: linear-gradient(45deg, #00C896, #00A67E);
        border: none;
        padding: 12px 30px;
        border-radius: 25px;
        font-weight: 600;
        text-transform: uppercase;
        letter-spacing: 1px;
        transition: all 0.3s ease;
        margin: 0 10px;
      }
      .btn-warning:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 15px rgba(0, 200, 150, 0.3);
        background: linear-gradient(45deg, #00A67E, #008B6B);
      }
      .error-details {
        background: #fef2f2;
        border: 1px solid #fecaca;
        border-radius: 10px;
        padding: 1.5rem;
        margin: 2rem 0;
        text-align: left;
      }
      .detail-row {
        display: flex;
        justify-content: space-between;
        margin-bottom: 0.5rem;
        padding: 0.25rem 0;
        border-bottom: 1px solid #fecaca;
      }
      .detail-row:last-child {
        margin-bottom: 0;
        border-bottom: none;
      }
      .status-badge {
        background: #dc3545;
        color: white;
        padding: 4px 12px;
        border-radius: 15px;
        font-size: 0.85rem;
        font-weight: 600;
      }
      .troubleshooting {
        background: #f0fdf9;
        border-left: 4px solid #00C896;
        padding: 1.5rem;
        margin: 2rem 0;
        text-align: left;
      }
      .troubleshooting h6 {
        color: #00C896;
        margin-bottom: 1rem;
      }
      .troubleshooting ul {
        margin-bottom: 0;
        padding-left: 1.5rem;
      }
      .troubleshooting li {
        margin-bottom: 0.5rem;
        color: #495057;
      }
      .contact-support {
        background: #f0fdf9;
        border: 1px solid #d1fae5;
        border-radius: 10px;
        padding: 1rem;
        margin: 1.5rem 0;
        font-size: 0.9rem;
      }
      .error-message-detail {
        background: #f0fdf9;
        border: 1px solid #d1fae5;
        border-radius: 8px;
        padding: 1rem;
        margin: 1rem 0;
        color: #065f46;
        font-weight: 500;
      }
      .debug-info {
        background: #f8f9fa;
        border: 1px solid #dee2e6;
        border-radius: 8px;
        padding: 1rem;
        margin: 1rem 0;
        font-size: 0.9rem;
        text-align: left;
      }
      .debug-info h6 {
        color: #495057;
        margin-bottom: 0.5rem;
      }
      .debug-info code {
        background: #e9ecef;
        padding: 2px 4px;
        border-radius: 3px;
        font-size: 0.85rem;
      }
      .alert-info {
        background-color: #f0fdf9;
        border-color: #00C896;
        color: #065f46;
      }
      .alert-info .fas {
        color: #00C896;
      }
    </style>
  </head>
  <body>
    <div class="error-container">
      <div class="error-card">
        <div class="error-icon">
          <i class="fas fa-exclamation-triangle"></i>
        </div>

        <h2 class="error-title">Lỗi Thanh Toán</h2>

        <p class="error-message">
          Đã xảy ra lỗi trong quá trình xử lý thanh toán đặt cọc của bạn. Vui
          lòng thử lại hoặc liên hệ bộ phận hỗ trợ để được giúp đỡ.
        </p>

        <!-- Hiển thị thông báo lỗi chi tiết từ server -->
        <c:if test="${not empty param.errorMessage}">
          <div class="error-message-detail">
            <i class="fas fa-exclamation-circle"></i>
            <strong>Chi tiết lỗi:</strong> ${param.errorMessage}
          </div>
        </c:if>

        <div class="error-details">
          <h5 class="mb-3" style="color: #ff6b6b;"><i class="fas fa-bug"></i> Thông Tin Giao Dịch</h5>
          <div class="detail-row">
            <span>Loại giao dịch:</span>
            <span><strong>Đặt cọc (30%)</strong></span>
          </div>
          <div class="detail-row">
            <span>Phương thức:</span>
            <span><strong>VNPay</strong></span>
          </div>
          <div class="detail-row">
            <span>Trạng thái:</span>
            <span class="status-badge">Lỗi</span>
          </div>
          <div class="detail-row">
            <span>Thời gian:</span>
            <span><strong id="current-time"></strong></span>
          </div>
          <div class="detail-row">
            <span>Mã lỗi:</span>
            <span
              ><strong>
                <c:choose>
                  <c:when test="${not empty param.errorCode}">
                    ${param.errorCode}
                  </c:when>
                  <c:otherwise> UNKNOWN_ERROR </c:otherwise>
                </c:choose>
              </strong></span
            >
          </div>
          <c:if test="${not empty param.txnRef}">
            <div class="detail-row">
              <span>Mã giao dịch:</span>
              <span><strong>${param.txnRef}</strong></span>
            </div>
          </c:if>
          <c:if test="${not empty param.responseCode}">
            <div class="detail-row">
              <span>Mã phản hồi VNPay:</span>
              <span><strong>${param.responseCode}</strong></span>
            </div>
          </c:if>
        </div>

        <!-- Debug information (chỉ hiển thị khi có lỗi) -->
        <c:if test="${not empty param.errorCode}">
          <div class="debug-info">
            <h6><i class="fas fa-code"></i> Thông Tin Debug</h6>
            <p>
              <strong>URL hiện tại:</strong>
              <code
                >${pageContext.request.requestURL}?${pageContext.request.queryString}</code
              >
            </p>
            <p><strong>Tham số nhận được:</strong></p>
            <ul>
              <c:forEach var="param" items="${paramValues}">
                <li><code>${param.key}</code>: ${param.value[0]}</li>
              </c:forEach>
            </ul>
          </div>
        </c:if>

        <div class="troubleshooting">
          <h6><i class="fas fa-tools"></i> Hướng dẫn khắc phục:</h6>
          <ul>
            <c:choose>
              <c:when test="${param.responseCode == '51'}">
                <li>
                  <strong>Tài khoản không đủ số dư:</strong> Vui lòng kiểm tra
                  số dư tài khoản
                </li>
                <li>Liên hệ ngân hàng để xác nhận trạng thái tài khoản</li>
              </c:when>
              <c:when test="${param.responseCode == '12'}">
                <li>
                  <strong>Thẻ/Tài khoản bị khóa:</strong> Liên hệ ngân hàng để
                  mở khóa
                </li>
                <li>Sử dụng phương thức thanh toán khác</li>
              </c:when>
              <c:when test="${param.responseCode == '24'}">
                <li><strong>Giao dịch bị hủy:</strong> Bạn đã hủy giao dịch</li>
                <li>Thử lại nếu muốn tiếp tục thanh toán</li>
              </c:when>
              <c:otherwise>
                <li>Kiểm tra kết nối internet của bạn</li>
                <li>Đảm bảo thông tin thẻ thanh toán chính xác</li>
                <li>
                  Thử sử dụng trình duyệt khác hoặc tắt trình chặn quảng cáo
                </li>
                <li>Kiểm tra số dư tài khoản ngân hàng</li>
                <li>Thử lại sau 5-10 phút</li>
              </c:otherwise>
            </c:choose>
          </ul>
        </div>

        <div class="contact-support">
          <i class="fas fa-headset" style="color: #00C896;"></i>
          <strong>Cần hỗ trợ?</strong> Liên hệ hotline:
          <strong>1900-xxxx</strong> hoặc email:
          <strong>support@autorental.com</strong>
        </div>

        <div class="alert alert-info mb-4">
          <i class="fas fa-info-circle"></i>
          <strong>Đừng lo lắng!</strong> Đơn đặt xe của bạn vẫn được bảo lưu.
          Bạn có thể thử thanh toán lại hoặc chọn phương thức thanh toán khác.
        </div>

        <div class="action-buttons">
          <a href="javascript:history.back()" class="btn btn-warning">
            <i class="fas fa-redo"></i> Thử Lại
          </a>
          <a
            href="${pageContext.request.contextPath}/customer/mytrip"
            class="btn btn-primary"
          >
            <i class="fas fa-car"></i> Quản Lý Đặt Xe
          </a>
          <a
            href="${pageContext.request.contextPath}/pages/contact.jsp"
            class="btn-outline-secondary"
          >
            <i class="fas fa-phone"></i> Liên Hệ Hỗ Trợ
          </a>
        </div>
      </div>
    </div>

    <script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap.bundle.min.js"></script>
    <script>
      // Hiển thị thời gian hiện tại
      document.addEventListener("DOMContentLoaded", function () {
        const now = new Date();
        const timeElement = document.getElementById("current-time");
        if (timeElement) {
          timeElement.textContent = now.toLocaleString("vi-VN");
        }

        // Log thông tin debug ra console
        console.log("=== ERROR PAGE DEBUG INFO ===");
        console.log("Error Code:", "${param.errorCode}");
        console.log("Error Message:", "${param.errorMessage}");
        console.log("Transaction Ref:", "${param.txnRef}");
        console.log("Response Code:", "${param.responseCode}");
        console.log("Full URL:", window.location.href);

        // Thêm thông tin debug vào localStorage để có thể truy cập sau
        const debugInfo = {
          errorCode: "${param.errorCode}",
          errorMessage: "${param.errorMessage}",
          txnRef: "${param.txnRef}",
          responseCode: "${param.responseCode}",
          timestamp: now.toISOString(),
          url: window.location.href,
        };
        localStorage.setItem("lastPaymentError", JSON.stringify(debugInfo));
        console.log("Debug info saved to localStorage");
      });

      // Auto refresh error info every 30 seconds
      setInterval(function () {
        const timeElement = document.getElementById("current-time");
        if (timeElement) {
          const now = new Date();
          timeElement.textContent = now.toLocaleString("vi-VN");
        }
      }, 30000);
    </script>
  </body>
</html>
