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
        background: linear-gradient(135deg, #00c896 0%, #00a67e 100%);
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
        background: linear-gradient(45deg, #00c896, #00a67e);
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
        background: linear-gradient(45deg, #00c896, #00a67e);
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
        background: linear-gradient(45deg, #00a67e, #008b6b);
      }
      .btn-outline-secondary {
        border: 2px solid #00c896;
        color: #00c896;
        padding: 10px 25px;
        border-radius: 25px;
        font-weight: 600;
        text-decoration: none;
        display: inline-block;
        margin: 0 10px;
        transition: all 0.3s ease;
      }
      .btn-outline-secondary:hover {
        background: #00c896;
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
        border-top: 2px solid #00c896;
        padding-top: 0.75rem;
        font-weight: 600;
      }
      .text-success {
        color: #00c896 !important;
      }
      .alert-info {
        background-color: #e6f7ff;
        border-color: #00c896;
        color: #0c5460;
      }
      .alert-info .fas {
        color: #00c896;
      }
    </style>
  </head>
  <body>
    <div class="success-container">
      <div class="success-card">
        <div class="success-icon">
          <i class="fas fa-check"></i>
        </div>

        <h2 class="success-title">Payment Successful!</h2>

        <p class="success-message">
          Thank you for your deposit. Your transaction has been processed
          successfully. Please wait for staff notification to complete the
          contract signing procedure.
        </p>

        <div class="payment-details">
          <h5 class="mb-3" style="color: #00c896">
            <i class="fas fa-receipt"></i> Payment Details
          </h5>
          <div class="detail-row">
            <span>Payment Type:</span>
            <span><strong>Deposit</strong></span>
          </div>
          <div class="detail-row">
            <span>Method:</span>
            <span><strong>VNPAY</strong></span>
          </div>
          <div class="detail-row">
            <span>Time:</span>
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
          <strong>Important Note:</strong> Please sign the contract to complete
          your booking procedure. After using the service, please pay the
          remaining amount and any violation fees if applicable.
        </div>

        <div class="action-buttons">
          <a
            href="${pageContext.request.contextPath}/user/my-trip"
            class="btn btn-primary"
          >
            <i class="fas fa-car"></i> Manage Bookings
          </a>
          <a
            href="${pageContext.request.contextPath}/pages/home"
            class="btn-outline-secondary"
          >
            <i class="fas fa-home"></i> Home
          </a>
        </div>
      </div>
    </div>

    <script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap.bundle.min.js"></script>
    <script>
      // Auto redirect sau 30 giây
      setTimeout(function () {
        window.location.href =
          "${pageContext.request.contextPath}/user/my-trip";
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
