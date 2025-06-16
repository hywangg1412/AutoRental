<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="Model.DTO.CarDetailDTO" %>
<%@ page import="Model.Entity.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
        return;
    }

    CarDetailDTO car = (CarDetailDTO) request.getAttribute("car");
%>

<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Book Car - AutoRental</title>
        <!-- Sau -->
        <link rel="stylesheet" href="<%= request.getContextPath()%>/styles/booking-form/booking-form-details.css">

        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="/pages/booking-form/booking-form-header.jsp"/>
        <!-- Progress Steps -->
        <div class="progress-container">
            <div class="container">
                <div class="progress-steps">
                    <div class="step active">
                        <div class="step-number">1</div>
                        <span>Fill Form</span>
                    </div>
                    <div class="step">
                        <div class="step-number">2</div>
                        <span>Deposit</span>
                    </div>
                    <div class="step">
                        <div class="step-number">3</div>
                        <span>Sign Contract</span>
                    </div>
                    <div class="step">
                        <div class="step-number">4</div>
                        <span>Complete</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Main Content -->
        <main class="main-content">
            <div class="container">
                <div class="booking-container">
                    <!-- Left Side - Car Information -->
                    <div class="car-info-section">
                        <div class="car-gallery">
                            <div class="main-image">
                                <img src="<%= request.getContextPath() + car.getImageUrls().get(0)%>"
                                     alt="Car Main Image"
                                     id="mainCarImage"
                                     style="width: 100%; height: auto; object-fit: cover;">
                            </div>
                        </div>



                        <div class="car-details">
                            <div class="car-header">
                                <h2 class="car-title"><%= car.getCarModel()%> <%= car.getYearManufactured()%></h2>
                            </div>

                            <div class="car-specs">
                                <div class="spec-item">
                                    <i class="fas fa-cog"></i>
                                    <span><%= car.getTransmissionName()%></span>
                                </div>
                                <div class="spec-item">
                                    <i class="fas fa-users"></i>
                                    <span><%= car.getSeats()%> seats</span>
                                </div>
                                <div class="spec-item">
                                    <i class="fas fa-gas-pump"></i>
                                    <span><%= car.getFuelName()%></span>
                                </div>
                                <div class="spec-item">
                                    <i class="fas fa-map-marker-alt"></i>
                                    <span>Thanh Khe District, Da Nang</span>
                                </div>
                            </div>

                            <div class="pricing">
                                <div class="price-item">
                                    <span class="price-label">Hourly rate:</span>
                                    <span class="price-value"><%= car.getPricePerHour()%>K/hour</span>
                                </div>
                                <div class="price-item">
                                    <span class="price-label">Daily rate:</span>
                                    <span class="price-value"><%= car.getPricePerDay()%>K/day</span>
                                </div>
                                <div class="price-item">
                                    <span class="price-label">Monthly rate:</span>
                                    <span class="price-value"><%= car.getPricePerMonth()%>K/month</span>
                                </div>
                            </div>


                            <div class="car-description">
                                <h3>Car Description</h3>
                                <p><%= car.getDescription()%></p>
                            </div>

                            <div class="car-features">
                                <h3>Amenities</h3>
                                <div class="features-grid">
                                    <div class="feature-item">
                                        <i class="fas fa-snowflake"></i>
                                        <span>Air Conditioning</span>
                                    </div>
                                    <div class="feature-item">
                                        <i class="fas fa-music"></i>
                                        <span>Bluetooth</span>
                                    </div>
                                    <div class="feature-item">
                                        <i class="fas fa-video"></i>
                                        <span>Dashcam</span>
                                    </div>
                                    <div class="feature-item">
                                        <i class="fas fa-map"></i>
                                        <span>GPS</span>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- Right Side - Booking Form -->
                    <div class="booking-form-section">
                        <div class="booking-form-container">
                            <h3>Car Booking Information</h3>
                            <form id="bookingForm" action="${pageContext.request.contextPath}/booking/create" method="post">
                                <input type="hidden" name="carId" value="<%= car.getCarId()%>">

                                <div class="form-group">
                                    <label for="customerName">Account Name</label>
                                    <input type="text" id="customerName" name="customerName"
                                           value="<%= user != null ? user.getUsername() : ""%>" readonly>
                                </div>

                                <div class="form-group">
                                    <label for="customerEmail">Email</label>
                                    <input type="email" id="customerEmail" name="customerEmail"
                                           value="<%= user != null ? user.getEmail() : ""%>" required>
                                    <small>You can use another email if you want.</small>
                                </div>
                                <div class="form-group">
                                    <label for="rentalType">Rental Type</label>
                                    <select id="rentalType" name="rentalType" required>
                                        <option value="">-- Select Type --</option>
                                        <option value="hourly">Hourly</option>
                                        <option value="daily">Daily</option>
                                        <option value="monthly">Monthly</option>
                                    </select>
                                </div>

                                <div class="form-group">
                                    <label for="customerPhone">Phone Number</label>
                                    <input type="tel" id="customerPhone" name="customerPhone"
                                           value="<%= user.getPhoneNumber() != null ? user.getPhoneNumber() : ""%>" required>
                                </div>

                                <div class="form-group">
                                    <label for="customerAddress">Address</label>
                                    <input type="text" id="customerAddress" name="customerAddress"
                                           value="<%= user.getUserAddress() != null ? user.getUserAddress() : ""%>" required>
                                </div>

                                <div class="form-group">
                                    <label for="startDate">Start Date</label>
                                    <input type="datetime-local" id="startDate" name="startDate" required>
                                </div>

                                <div class="form-group">
                                    <label for="endDate">End Date</label>
                                    <input type="datetime-local" id="endDate" name="endDate" required>
                                </div>
                                <div class="form-group">
                                    <label for="licenseNumber">Driver License Number</label>
                                    <input type="text" id="licenseNumber" name="licenseNumber" required>
                                </div>
                                <div class="total-price">
                                    <div class="price-breakdown">
                                        <div class="price-row">
                                            <span>Total Duration:</span>
                                            <span id="totalDuration">0 days</span>
                                        </div>
                                        <div class="price-row">
                                            <span>Unit Price:</span>
                                            <span id="unitPrice">0K</span>
                                        </div>
                                        <div class="price-row total">
                                            <span>Total Amount:</span>
                                            <span id="totalPrice">0K</span>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <button type="button" class="btn btn-secondary" onclick="goHome()">
                        <i class="fas fa-home"></i>
                        Back to Home
                    </button>

                    <!-- Nút gửi booking để duyệt -->
                    <button type="submit" form="bookingForm" class="btn btn-warning">
                        Request Booking Approval
                        <i class="fas fa-paper-plane"></i>
                    </button>

                    <!-- Nút tiếp tục đặt cọc -->
                    <button type="button" class="btn btn-primary" onclick="goToDeposit()">
                        Continue to Deposit
                        <i class="fas fa-arrow-right"></i>
                    </button>
                </div>


            </div>
        </main>
        
        <div id="carPriceData"
             data-hourly="<%= car.getPricePerHour()%>"
             data-daily="<%= car.getPricePerDay()%>"
             data-monthly="<%= car.getPricePerMonth()%>">
        </div>

      <script src="<%= request.getContextPath()%>/scripts/booking-form/booking-form-detail.js"></script>
    </body>
</html>
