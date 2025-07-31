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
      .btn-danger {
        background: linear-gradient(45deg, #00c896, #00a67e);
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
        background: linear-gradient(45deg, #00a67e, #008b6b);
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
        border-left: 4px solid #00c896;
        padding: 1.5rem;
        margin: 2rem 0;
        text-align: left;
      }
      .next-steps h6 {
        color: #00c896;
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

        <h2 class="cancel-title">Payment Cancelled</h2>

        <p class="cancel-message">
          Your deposit transaction has been cancelled. Your booking is still
          reserved and you can try to pay again at any time.
        </p>

        <div class="payment-info">
          <h5 class="mb-3" style="color: #ffa726">
            <i class="fas fa-info-circle"></i> Payment Details
          </h5>
          <div class="info-row">
            <span>Payment Type:</span>
            <span><strong>Deposit</strong></span>
          </div>
          <div class="info-row">
            <span>Method:</span>
            <span><strong>VNPAY</strong></span>
          </div>
          <div class="info-row">
            <span>Time:</span>
            <span
              ><strong
                ><fmt:formatDate
                  value="${now}"
                  pattern="dd/MM/yyyy HH:mm:ss" /></strong
            ></span>
          </div>
        </div>

        <div class="next-steps">
          <h6><i class="fas fa-lightbulb"></i> Next Steps:</h6>
          <ul>
            <li>Check your booking information in "Manage Bookings"</li>
            <li>Try to pay again if you want to continue your booking</li>
            <li>Contact support if you encounter technical issues</li>
            <li>Book another car if you change your mind</li>
          </ul>
        </div>

        <div class="alert alert-warning mb-4">
          <i class="fas fa-exclamation-triangle"></i>
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
            href="${pageContext.request.contextPath}/pages/index.jsp"
            class="btn-outline-secondary"
          >
            <i class="fas fa-home"></i> Home
          </a>
          <a
            href="${pageContext.request.contextPath}/pages/contact.jsp"
            class="btn btn-danger"
          >
            <i class="fas fa-headset"></i> Support
          </a>
        </div>
      </div>
    </div>

    <script src="${pageContext.request.contextPath}/css/bootstrap/bootstrap.bundle.min.js"></script>
    <script>
      // Auto redirect sau 45 giây
      setTimeout(function () {
        window.location.href =
          "${pageContext.request.contextPath}/user/my-trip";
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
