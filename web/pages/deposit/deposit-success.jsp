<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Thanh Toán Thành Công - AutoRental</title>
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
      .success-container {
        min-height: 80vh;
        display: flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, #00C896 0%, #00A67E 100%);
      }
      .success-card {
        background: white;
        border-radius: 20px;
        box-shadow: 0 15px 35px rgba(0, 200, 150, 0.2);
        padding: 3rem;
        text-align: center;
        max-width: 500px;
        width: 90%;
      }
      .success-icon {
        width: 80px;
        height: 80px;
        background: linear-gradient(45deg, #00C896, #00A67E);
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 2rem;
        animation: pulse 2s infinite;
      }
      .success-icon i {
        font-size: 2.5rem;
        color: white;
      }
      @keyframes pulse {
        0% {
          transform: scale(1);
        }
        50% {
          transform: scale(1.05);
        }
        100% {
          transform: scale(1);
        }
      }
      .success-title {
        color: #2c3e50;
        font-weight: 700;
        margin-bottom: 1rem;
      }
      .success-message {
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
      .payment-details {
        background: #f0fdf9;
        border: 1px solid #d1fae5;
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
      }
      .detail-row:last-child {
        margin-bottom: 0;
        border-top: 2px solid #00C896;
        padding-top: 0.75rem;
        font-weight: 600;
      }
      .text-success {
        color: #00C896 !important;
      }
      .alert-info {
        background-color: #e6f7ff;
        border-color: #00C896;
        color: #0c5460;
      }
      .alert-info .fas {
        color: #00C896;
      }
    </style>
  </head>
  <body>
    <div class="success-container">
      <div class="success-card">
        <div class="success-icon">
          <i class="fas fa-check"></i>
        </div>

        <h2 class="success-title">Thanh Toán Thành Công!</h2>

        <p class="success-message">
          Cảm ơn bạn đã đặt cọc cho xe thuê. Giao dịch của bạn đã được xử lý
          thành công. Vui lòng chờ thông báo từ nhân viên để hoàn tất thủ tục ký
          hợp đồng.
        </p>

        <div class="payment-details">
          <h5 class="mb-3" style="color: #00C896;">
            <i class="fas fa-receipt"></i> Chi Tiết Thanh Toán
          </h5>
          <div class="detail-row">
            <span>Loại thanh toán:</span>
            <span><strong>Đặt cọc (30%)</strong></span>
          </div>
          <div class="detail-row">
            <span>Phương thức:</span>
            <span><strong>PayOS</strong></span>
          </div>
          <div class="detail-row">
            <span>Trạng thái:</span>
            <span class="text-success"><strong>Thành công</strong></span>
          </div>
          <div class="detail-row">
            <span>Thời gian:</span>
            <span
              ><strong
                ><fmt:formatDate
                  value="${now}"
                  pattern="dd/MM/yyyy HH:mm:ss" /></strong
            ></span>
          </div>
        </div>

        <div class="alert alert-info mb-4">
          <i class="fas fa-info-circle"></i>
          <strong>Lưu ý quan trọng:</strong> Bạn cần ký hợp đồng trong vòng 6
          giờ để hoàn tất đặt xe. Sau đó thanh toán 70% còn lại khi nhận xe.
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
        </div>
      </div>
    </div>

    <script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap.bundle.min.js"></script>
    <script>
      // Auto redirect sau 30 giây
      setTimeout(function () {
        window.location.href =
          "${pageContext.request.contextPath}/customer/mytrip";
      }, 30000);

      // Hiển thị thời gian hiện tại
      document.addEventListener("DOMContentLoaded", function () {
        const now = new Date();
        const timeElement = document.querySelector(
          ".detail-row:nth-child(4) span:last-child strong"
        );
        if (timeElement) {
          timeElement.textContent = now.toLocaleString("vi-VN");
        }
      });
    </script>
  </body>
</html>
