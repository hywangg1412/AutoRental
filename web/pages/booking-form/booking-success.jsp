<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="jakarta.tags.core" %> <%@ taglib prefix="fmt"
uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Booking Successful</title>
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"
    />
    <style>
      body {
        font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f8f9fa;
        margin: 0;
        padding: 0;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        color: #333;
      }

      .success-container {
        background-color: white;
        border-radius: 12px;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
        width: 90%;
        max-width: 600px;
        padding: 40px;
        text-align: center;
        animation: fadeIn 0.8s ease-in-out;
      }

      @keyframes fadeIn {
        from {
          opacity: 0;
          transform: translateY(-20px);
        }
        to {
          opacity: 1;
          transform: translateY(0);
        }
      }

      .success-icon {
        font-size: 64px;
        color: #28a745;
        margin-bottom: 20px;
      }

      h1 {
        color: #28a745;
        margin-bottom: 20px;
        font-weight: 600;
      }

      .booking-info {
        background-color: #f8f9fa;
        border-radius: 8px;
        padding: 20px;
        margin: 20px 0;
        text-align: left;
      }

      .booking-info p {
        margin: 10px 0;
        display: flex;
        justify-content: space-between;
      }

      .booking-info .label {
        font-weight: 600;
        color: #495057;
      }

      .booking-info .value {
        font-weight: 500;
      }

      .total-amount {
        font-size: 1.2em;
        font-weight: 700;
        color: #dc3545;
        margin: 15px 0;
      }

      .notice {
        background-color: #fff3cd;
        border-left: 4px solid #ffc107;
        padding: 15px;
        margin: 20px 0;
        text-align: left;
        border-radius: 4px;
      }

      .notice i {
        color: #ffc107;
        margin-right: 10px;
      }

      .btn {
        display: inline-block;
        font-weight: 500;
        text-align: center;
        white-space: nowrap;
        vertical-align: middle;
        user-select: none;
        border: 1px solid transparent;
        padding: 0.5rem 1rem;
        font-size: 1rem;
        line-height: 1.5;
        border-radius: 0.25rem;
        transition: all 0.15s ease-in-out;
        text-decoration: none;
        margin: 10px 5px;
        cursor: pointer;
      }

      .btn-primary {
        color: #fff;
        background-color: #007bff;
        border-color: #007bff;
      }

      .btn-primary:hover {
        background-color: #0069d9;
        border-color: #0062cc;
      }

      .btn-success {
        color: #fff;
        background-color: #28a745;
        border-color: #28a745;
      }

      .btn-success:hover {
        background-color: #218838;
        border-color: #1e7e34;
      }

      .footer-links {
        margin-top: 30px;
      }
    </style>
  </head>
  <body>
    <div class="success-container">
      <i class="fas fa-check-circle success-icon"></i>
      <h1>Booking Successful!</h1>
      <p>
        Thank you for your booking. Your request has been submitted
        successfully.
      </p>

      <div class="notice">
        <i class="fas fa-info-circle"></i>
        <strong>Please note:</strong> Our staff will review your booking request
        within 5-15 minutes. You will receive a notification once it's approved.
      </div>

      <c:if test="${not empty booking}">
        <div class="booking-info">
          <p>
            <span class="label">Booking Code:</span>
            <span class="value">${booking.bookingCode}</span>
          </p>
          <p>
            <span class="label">Status:</span>
            <span class="value">Pending Approval</span>
          </p>
          <p>
            <span class="label">Created Date:</span>
            <span class="value">
              <fmt:formatDate
                value="${booking.createdDate}"
                pattern="dd/MM/yyyy HH:mm"
              />
            </span>
          </p>
          <p class="total-amount">
            <span class="label">Total Amount:</span>
            <span class="value">
              <fmt:formatNumber
                value="${booking.totalAmount * 1000}"
                pattern="#,##0"
              />
              VND
            </span>
          </p>
        </div>
      </c:if>

      <div class="footer-links">
        <a
          href="<%= request.getContextPath() %>/user/my-trip"
          class="btn btn-success"
        >
          <i class="fas fa-car"></i> View My Trips
        </a>
<!--        <a href="<%= request.getContextPath() %>/" class="btn btn-primary">
          <i class="fas fa-home"></i> Back to Home
        </a>-->
      </div>
    </div>
  </body>
</html>
