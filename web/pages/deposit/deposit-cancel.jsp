<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Thanh Toán Bị Hủy - AutoRental</title>
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
      .cancel-container {
        min-height: 80vh;
        display: flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #ffa726 0%, #ff9800 100%);
      }
      .cancel-card {
        background: white;
        border-radius: 20px;
        box-shadow: 0 15px 35px rgba(255, 152, 0, 0.2);
        padding: 3rem;
        text-align: center;
        max-width: 500px;
        width: 90%;
      }
      .cancel-icon {
        width: 80px;
        height: 80px;
        background: linear-gradient(45deg, #ffa726, #ff9800);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 2rem;
        animation: shake 1s ease-in-out;
      }
      .cancel-icon i {
        font-size: 2.5rem;
        color: white;
      }
      @keyframes shake {
        0%,
        100% {
          transform: translateX(0);
        }
        25% {
          transform: translateX(-5px);
        }
        75% {
          transform: translateX(5px);
        }
      }
      .cancel-title {
        color: #2c3e50;
        font-weight: 700;
        margin-bottom: 1rem;
      }
      .cancel-message {
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
      .btn-danger {
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
      .btn-danger:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 15px rgba(0, 200, 150, 0.3);
        background: linear-gradient(45deg, #00A67E, #008B6B);
      }
      .payment-info {
        background: #fff8e1;
        border: 1px solid #ffecb3;
        border-radius: 10px;
        padding: 1.5rem;
        margin: 2rem 0;
        text-align: left;
      }
      .info-row {
        display: flex;
        justify-content: space-between;
        margin-bottom: 0.5rem;
        padding: 0.25rem 0;
      }
      .info-row:last-child {
        margin-bottom: 0;
      }
      .status-badge {
        background: #ffa726;
        color: white;
        padding: 4px 12px;
        border-radius: 15px;
        font-size: 0.85rem;
        font-weight: 600;
      }
      .next-steps {
        background: #f0fdf9;
        border-left: 4px solid #00C896;
        padding: 1.5rem;
        margin: 2rem 0;
        text-align: left;
      }
      .next-steps h6 {
        color: #00C896;
        margin-bottom: 1rem;
      }
      .next-steps ul {
        margin-bottom: 0;
        padding-left: 1.5rem;
      }
      .next-steps li {
        margin-bottom: 0.5rem;
        color: #495057;
      }
      .alert-warning {
        background-color: #fff8e1;
        border-color: #ffa726;
        color: #e65100;
      }
      .alert-warning .fas {
        color: #ffa726;
      }
    </style>
  </head>
  <body>
    <div class="cancel-container">
      <div class="cancel-card">
        <div class="cancel-icon">
          <i class="fas fa-times"></i>
        </div>

        <h2 class="cancel-title">Thanh Toán Bị Hủy</h2>

        <p class="cancel-message">
          Giao dịch thanh toán đặt cọc xe thuê của bạn đã bị hủy bỏ. Đơn đặt xe
          của bạn vẫn được giữ và bạn có thể thử thanh toán lại bất cứ lúc nào.
        </p>

        <div class="payment-info">
          <h5 class="mb-3" style="color: #ffa726;">
            <i class="fas fa-info-circle"></i> Thông Tin Giao Dịch
          </h5>
          <div class="info-row">
            <span>Loại thanh toán:</span>
            <span><strong>Đặt cọc (30%)</strong></span>
          </div>
          <div class="info-row">
            <span>Phương thức:</span>
            <span><strong>PayOS</strong></span>
          </div>
          <div class="info-row">
            <span>Trạng thái:</span>
            <span class="status-badge">Đã hủy</span>
          </div>
          <div class="info-row">
            <span>Thời gian hủy:</span>
            <span
              ><strong
                ><fmt:formatDate
                  value="${now}"
                  pattern="dd/MM/yyyy HH:mm:ss" /></strong
            ></span>
          </div>
        </div>

        <div class="next-steps">
          <h6><i class="fas fa-lightbulb"></i> Bước tiếp theo:</h6>
          <ul>
            <li>Kiểm tra lại thông tin đặt xe trong "Quản Lý Đặt Xe"</li>
            <li>Thử thanh toán lại nếu muốn tiếp tục đặt cọc</li>
            <li>Liên hệ hỗ trợ nếu gặp vấn đề kỹ thuật</li>
            <li>Đặt xe khác nếu thay đổi ý định</li>
          </ul>
        </div>

        <div class="alert alert-warning mb-4">
          <i class="fas fa-exclamation-triangle"></i>
          <strong>Lưu ý:</strong> Đơn đặt xe của bạn sẽ được giữ trong 24 giờ.
          Sau thời gian này, xe có thể được đặt bởi khách hàng khác.
        </div>

        <div class="action-buttons">
          <a
            href="${pageContext.request.contextPath}/customer/mytrip"
            class="btn btn-primary"
          >
            <i class="fas fa-car"></i> Quản Lý Đặt Xe
          </a>
          <a
            href="${pageContext.request.contextPath}/pages/index.jsp"
            class="btn-outline-secondary"
          >
            <i class="fas fa-home"></i> Về Trang Chủ
          </a>
          <a
            href="${pageContext.request.contextPath}/pages/contact.jsp"
            class="btn btn-danger"
          >
            <i class="fas fa-headset"></i> Hỗ Trợ
          </a>
        </div>
      </div>
    </div>

    <script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap.bundle.min.js"></script>
    <script>
      // Auto redirect sau 45 giây
      setTimeout(function () {
        window.location.href =
          "${pageContext.request.contextPath}/customer/mytrip";
      }, 45000);

      // Hiển thị thời gian hiện tại
      document.addEventListener("DOMContentLoaded", function () {
        const now = new Date();
        const timeElement = document.querySelector(
          ".info-row:nth-child(4) span:last-child strong"
        );
        if (timeElement) {
          timeElement.textContent = now.toLocaleString("vi-VN");
        }
      });

      // Hiệu ứng countdown
      let countdown = 45;
      const countdownInterval = setInterval(function () {
        countdown--;
        if (countdown <= 0) {
          clearInterval(countdownInterval);
        }
      }, 1000);
    </script>
  </body>
</html>
