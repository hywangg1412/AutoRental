<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
    prefix="c" uri="jakarta.tags.core" %> <%@ page import="Model.DTO.CarDetailDTO"
                                               %> <%@ page import="Model.Entity.User.User" %> 
    <%@ page
    import="Model.Entity.User.DriverLicense" %> <%@ page import="Model.DTO.BookingInfoDTO" %> <% User user = (User)
    session.getAttribute("user"); if (user == null) {
    response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
    return; } CarDetailDTO car = (CarDetailDTO) request.getAttribute("car"); Boolean
    hasDriverLicense = (Boolean) request.getAttribute("hasDriverLicense");
    DriverLicense driverLicense = (DriverLicense)
    request.getAttribute("driverLicense"); 
    BookingInfoDTO bookingInfo = (BookingInfoDTO) request.getAttribute("bookingInfo");
        %>

        <!DOCTYPE html>
        <html lang="vi">
            <head>
                <meta charset="UTF-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1.0" />
                <title>Book Car - AutoRental</title>
                <link
                    rel="stylesheet"
                    href="<%= request.getContextPath()%>/styles/booking-form/booking-form-details.css"
                    />
                <link
                    rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
                    />

                <!-- Flatpickr CSS -->
                <link
                    rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css"
                    />

                <style>
                    /* Enhanced Alert Styles */
                    .alert {
                        position: relative;
                        border-radius: 6px;
                        margin-bottom: 15px;
                        animation: fadeIn 0.3s ease-out;
                        box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
                    }

                    .alert i {
                        margin-right: 8px;
                        font-size: 16px;
                    }

                    .alert-danger {
                        background-color: #fff5f5;
                        border-left: 4px solid #f56565;
                        color: #c53030;
                    }

                    .alert-warning {
                        background-color: #fffbeb;
                        border-left: 4px solid #f59e0b;
                        color: #b45309;
                    }

                    .alert-info {
                        background-color: #ebf8ff;
                        border-left: 4px solid #4299e1;
                        color: #2b6cb0;
                    }

                    .alert-success {
                        background-color: #f0fff4;
                        border-left: 4px solid #48bb78;
                        color: #2f855a;
                    }

                    /* Fixed Alert */
                    .fixed-alert {
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                        padding: 10px 15px;
                        margin-bottom: 15px;
                        border-radius: 6px;
                        background-color: #ebf8ff;
                        border-left: 4px solid #4299e1;
                        color: #2b6cb0;
                        animation: slideDown 0.3s ease-out;
                    }

                    .fixed-alert.alert-danger {
                        background-color: #fff5f5;
                        border-left: 4px solid #f56565;
                        color: #c53030;
                    }

                    .fixed-alert.alert-warning {
                        background-color: #fffbeb;
                        border-left: 4px solid #f59e0b;
                        color: #b45309;
                    }

                    .fixed-alert.alert-success {
                        background-color: #f0fff4;
                        border-left: 4px solid #48bb78;
                        color: #2f855a;
                    }

                    .alert-content {
                        display: flex;
                        align-items: center;
                    }

                    .alert-content i {
                        margin-right: 10px;
                        font-size: 18px;
                    }

                    .close-alert {
                        background: none;
                        border: none;
                        cursor: pointer;
                        color: inherit;
                        opacity: 0.7;
                    }

                    .close-alert:hover {
                        opacity: 1;
                    }

                    /* Input Warnings */
                    .time-warning,
                    .rental-warning {
                        margin-top: 5px;
                    }

                    .text-warning {
                        color: #b45309;
                        font-weight: 500;
                        display: flex;
                        align-items: center;
                    }

                    .text-warning i {
                        margin-right: 5px;
                        color: #f59e0b;
                    }

                    @keyframes fadeIn {
                        from {
                            opacity: 0;
                            transform: translateY(-10px);
                        }
                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    @keyframes slideDown {
                        from {
                            opacity: 0;
                            transform: translateY(-20px);
                        }
                        to {
                            opacity: 1;
                            transform: translateY(0);
                        }
                    }

                    /* Highlight invalid inputs */
                    input:invalid,
                    select:invalid {
                        border-color: #f56565 !important;
                        background-color: #fff5f5 !important;
                    }

                    /* Make flatpickr more visible */
                    .flatpickr-calendar {
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.15) !important;
                    }

                    /* Insurance Info Styles */
                    .insurance-info {
                        margin-top: 20px;
                        padding: 15px;
                        border: 1px solid #e2e8f0;
                        border-radius: 8px;
                        background-color: #f8fafc;
                    }

                    .insurance-info h5 {
                        margin-top: 0;
                        margin-bottom: 15px;
                        font-size: 16px;
                        color: #2d3748;
                    }

                    .insurance-list {
                        display: flex;
                        flex-direction: column;
                        gap: 12px;
                    }

                    .insurance-item {
                        padding: 10px;
                        border-radius: 6px;
                        background-color: white;
                        box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
                        border-left: 3px solid #4299e1;
                    }

                    .insurance-name {
                        display: flex;
                        align-items: center;
                        font-weight: 500;
                        margin-bottom: 5px;
                    }

                    .insurance-name i {
                        color: #4299e1;
                        margin-right: 8px;
                    }

                    .insurance-description {
                        color: #718096;
                        font-size: 13px;
                    }

                    .insurance-note {
                        margin-top: 5px;
                        padding-top: 5px;
                        border-top: 1px dashed #e2e8f0;
                    }

                    .insurance-note small {
                        font-size: 12px;
                    }

                    .insurance-explanation {
                        padding: 8px;
                        border-radius: 4px;
                        background-color: #f0f4f8;
                        border-left: 3px solid #cbd5e0;
                    }

                    .mt-2 {
                        margin-top: 10px;
                    }

                    .text-info {
                        color: #4299e1;
                    }

                    .text-muted {
                        color: #718096;
                    }
                </style>
            </head>
            <body>
                <!-- Header -->
                <jsp:include page="/pages/booking-form/booking-form-header.jsp" />

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
                                        <img
                                            src="<%= request.getContextPath() + car.getImageUrls().get(0)%>"
                                            alt="Car Main Image"
                                            id="mainCarImage"
                                            style="width: 100%; height: auto; object-fit: cover"
                                            />
                                    </div>
                                </div>

                                <div class="car-details">
                                    <div class="car-header">
                                        <h2 class="car-title">
                                            <%= car.getCarModel()%> <%= car.getYearManufactured()%>
                                        </h2>
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
                                            <span class="price-value"><%= String.format("%,.0f", car.getPricePerHour().doubleValue() * 1000) %> VND/hour</span>
                                        </div>
                                        <div class="price-item">
                                            <span class="price-label">Daily rate:</span>
                                            <span class="price-value"><%= String.format("%,.0f", car.getPricePerDay().doubleValue() * 1000) %> VND/day</span>
                                        </div>
                                        <div class="price-item">
                                            <span class="price-label">Monthly rate:</span>
                                            <span class="price-value"><%= String.format("%,.0f", car.getPricePerMonth().doubleValue() * 1000) %> VND/month</span>
                                        </div>
                                    </div>

                                    <div class="car-description">
                                        <h3>Car Description</h3>
                                        <p><%= car.getDescription()%></p>
                                    </div>

                                    <!-- Insurance Options -->
                                    <div class="insurance-section">
                                        <h3>Insurance Options</h3>

                                        <!-- Basic Insurance -->
                                        <div class="insurance-card basic-insurance">
                                            <div class="insurance-header">
                                                <div class="insurance-icon">
                                                    <i class="fas fa-shield-alt"></i>
                                                </div>
                                                <div class="insurance-info">
                                                    <h4>Car Rental Insurance</h4>
                                                    <p class="insurance-description">
                                                        Comprehensive coverage included. Customers are
                                                        compensated up to 2,000,000 VND in case of accidents
                                                        with third parties.
                                                    </p>
                                                </div>
                                            </div>
                                            <div class="insurance-actions">
                                                <span class="insurance-price">Included</span>
                                                <button
                                                    type="button"
                                                    class="btn-view-more"
                                                    onclick="showInsuranceDetails('basic')"
                                                    >
                                                    View Details <i class="fas fa-chevron-right"></i>
                                                </button>
                                            </div>
                                        </div>

                                        <!-- Additional Insurance -->
                                        <div class="insurance-card additional-insurance">
                                            <div class="insurance-header">
                                                <div class="insurance-icon additional">
                                                    <i class="fas fa-user-shield"></i>
                                                </div>
                                                <div class="insurance-info">
                                                    <h4>
                                                        Additional Personal Insurance
                                                        <span class="new-badge">New</span>
                                                    </h4>
                                                    <p class="insurance-description">
                                                        Enhanced protection for accidents. Covers medical
                                                        expenses and personal injury up to 300,000,000 VND per
                                                        person.
                                                    </p>
                                                </div>
                                            </div>
                                            <div class="insurance-actions">
                                                <span class="insurance-price">
                                                    <c:choose>
                                                        <c:when test="${not empty bookingInfo.additionalInsuranceFee}">
                                                            +${bookingInfo.formattedAdditionalInsuranceFeeWithoutConversion}/day
                                                        </c:when>
                                                        <c:otherwise>
                                                            +30,000 VND/day
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                                <button
                                                    type="button"
                                                    class="btn-view-more"
                                                    onclick="showInsuranceDetails('additional')"
                                                    >
                                                    View Details <i class="fas fa-chevron-right"></i>
                                                </button>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Included Services -->
                                    <div class="included-services">
                                        <h3>Included Services</h3>
                                        <div class="services-grid">
                                            <div class="service-item">
                                                <i class="fas fa-tint"></i>
                                                <span>2 Bottles of Water</span>
                                            </div>
                                            <div class="service-item">
                                                <i class="fas fa-cookie-bite"></i>
                                                <span>3 Snack Packs</span>
                                            </div>
                                            <div class="service-item">
                                                <i class="fas fa-tissue"></i>
                                                <span>Tissue Box</span>
                                            </div>
                                            <div class="service-item">
                                                <i class="fas fa-spray-can"></i>
                                                <span>Air Freshener</span>
                                            </div>
                                            <div class="service-item">
                                                <i class="fas fa-mobile-alt"></i>
                                                <span>Phone Charger</span>
                                            </div>
                                            <div class="service-item">
                                                <i class="fas fa-first-aid"></i>
                                                <span>First Aid Kit</span>
                                            </div>
                                        </div>
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

                                <div class="alert alert-info" style="margin-top: 1rem">
                                    <i class="fas fa-info-circle"></i>
                                    <span>
                                        <strong>Operating Hours:</strong> Car rental service is
                                        available from 7:00 AM to 10:00 PM daily.
                                        <br />
                                        <strong>Time Selection:</strong> Please select times in
                                        30-minute intervals (e.g., 7:00, 7:30, 8:00, etc.)
                                    </span>
                                </div>
                            </div>

                            <!-- Right Side - Booking Form -->
                            <div class="booking-form-section">
                                <div class="booking-form-container">
                                    <h3>Car Booking Information</h3>

                                    <!-- Driver License Status Alert -->
                                    <% if (hasDriverLicense != null && hasDriverLicense) { %>
                                    <div class="alert alert-success mb-3">
                                        <i class="fas fa-check-circle"></i>
                                        <strong>Driver License Verified!</strong> Your license
                                        information is already on file.
                                    </div>
                                    <% } else { %>
                                    <div class="alert alert-info mb-3">
                                        <i class="fas fa-info-circle"></i>
                                        <strong>Driver License Required:</strong> Please provide your
                                        driver license information below.
                                    </div>
                                    <% } %>

                                    <form
                                        id="bookingForm"
                                        action="${pageContext.request.contextPath}/booking/create"
                                        method="post"
                                        enctype="multipart/form-data"
                                        >
                                        <input
                                            type="hidden"
                                            name="carId"
                                            value="<%= car.getCarId()%>"
                                            />
                                        <input
                                            type="hidden"
                                            name="hasDriverLicense"
                                            value="<%= hasDriverLicense%>"
                                            />
                                        <input
                                            type="hidden"
                                            id="carHourlyPrice"
                                            value="<%= car.getPricePerHour() %>"
                                            />
                                        <input
                                            type="hidden"
                                            id="carDailyPrice"
                                            value="<%= car.getPricePerDay() %>"
                                            />
                                        <input
                                            type="hidden"
                                            id="carMonthlyPrice"
                                            value="<%= car.getPricePerMonth() %>"
                                            />

                                        <!-- Customer Information Section -->
                                        <div class="form-section">
                                            <h4 class="section-title">Customer Information</h4>

                                            <div class="form-group">
                                                <label for="customerName">Account Name</label>
                                                <input type="text" id="customerName" name="customerName"
                                                       value="<%= user != null ? user.getUsername() : ""%>"
                                                       readonly>
                                            </div>

                                            <div class="form-group">
                                                <label for="customerEmail">Email</label>
                                                <input type="email" id="customerEmail" name="customerEmail"
                                                       value="<%= user != null ? user.getEmail() : ""%>" required>
                                                <small>You can use another email if you want.</small>
                                            </div>

                                            <div class="form-group">
                                                <label for="customerPhone">Phone Number</label>
                                                <input type="tel" id="customerPhone" name="customerPhone"
                                                       value="<%= user.getPhoneNumber() != null ?
                    user.getPhoneNumber() : ""%>" required>
                                            </div>
                                        </div>

                                        <!-- Rental Information Section -->
                                        <div class="form-section">
                                            <h4 class="section-title">
                                                Rental Information
                                                <div class="tooltip-container">
                                                    <i class="fas fa-info-circle rental-info-tooltip"></i>
                                                    <div class="tooltip-content">
                                                        <h4>Rental Fee Calculation Rules:</h4>
                                                        <ul>
                                                            <li><strong>Hourly:</strong> Less than 24 hours = hourly rate</li>
                                                            <li><strong>Daily:</strong> 24 hours or more = daily rate</li>
                                                            <li><strong>Daily:</strong> Partial days (e.g., 3 days 5 hours) = converted to decimal days</li>
                                                            <li><strong>Monthly:</strong> Less than 30 days = daily rate, 30 days or more = monthly rate</li>
                                                        </ul>

                                                        <h4>Recommendations:</h4>
                                                        <ul>
                                                            <li><strong>For short trips (4-9 hours):</strong> Choose hourly rental</li>
                                                            <li><strong>For day trips (10-24 hours):</strong> Choose daily rental</li>
                                                            <li><strong>For extended stays (3+ days):</strong> Choose daily rental</li>
                                                            <li><strong>For long-term (30+ days):</strong> Choose monthly rental</li>
                                                        </ul>
                                                    </div>
                                            </h4>

                                            <div class="form-group">
                                                <label for="rentalType">Rental Type</label>
                                                <select id="rentalType" name="rentalType" required>
                                                    <option value="">-- Select Type --</option>
                                                    <option value="hourly">Hourly</option>
                                                    <option value="daily">Daily</option>
                                                    <option value="monthly">Monthly</option>
                                                </select>
                                                <div class="rental-warning">
                                                    <small
                                                        class="text-warning hourly-warning"
                                                        style="display: none"
                                                        >
                                                        <i class="fas fa-exclamation-circle"></i> Hourly rentals
                                                        require a minimum of 4 hours
                                                    </small>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label for="startDate">Start Date & Time</label>
                                                <input
                                                    type="text"
                                                    id="startDate"
                                                    name="startDate"
                                                    required
                                                    placeholder="Chọn ngày và giờ bắt đầu"
                                                    />
                                                <small class="time-note"
                                                       >Available: 7:00 AM - 10:00 PM (30-min intervals)</small
                                                >
                                                <div class="time-warning">
                                                    <small
                                                        class="text-warning start-time-warning"
                                                        style="display: none"
                                                        >
                                                        <i class="fas fa-exclamation-circle"></i>
                                                        <span id="startTimeWarningText"></span>
                                                    </small>
                                                </div>
                                            </div>

                                            <div class="form-group">
                                                <label for="endDate">End Date & Time</label>
                                                <input
                                                    type="text"
                                                    id="endDate"
                                                    name="endDate"
                                                    required
                                                    placeholder="Chọn ngày và giờ kết thúc"
                                                    />
                                                <small class="time-note"
                                                       >Available: 7:00 AM - 10:00 PM (30-min intervals)</small
                                                >
                                                <div class="time-warning">
                                                    <small
                                                        class="text-warning end-time-warning"
                                                        style="display: none"
                                                        >
                                                        <i class="fas fa-exclamation-circle"></i>
                                                        <span id="endTimeWarningText"></span>
                                                    </small>
                                                </div>
                                            </div>

                                            <!-- Additional Insurance Checkbox -->
                                            <div class="form-group">
                                                <div class="checkbox-group">
                                                    <input
                                                        type="checkbox"
                                                        id="additionalInsurance"
                                                        name="additionalInsurance"
                                                        value="true"
                                                        />
                                                    <label for="additionalInsurance" class="checkbox-label">
                                                        <span class="checkbox-text"
                                                              >Add Personal Insurance Protection</span
                                                        >
                                                        <span class="checkbox-price">
                                                            <!-- Lấy giá bảo hiểm tai nạn từ bookingInfo -->
                                                            <c:choose>
                                                                <c:when test="${not empty bookingInfo.additionalInsuranceFee}">
                                                                    +${bookingInfo.formattedAdditionalInsuranceFeeWithoutConversion}/day
                                                                </c:when>
                                                                <c:otherwise>
                                                                    +30,000 VND/day
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </label>
                                                </div>
                                                <small
                                                    >Optional coverage for enhanced personal protection</small
                                                >
                                            </div>

                                            <!-- Hiển thị thông tin bảo hiểm từ database -->
                                            <!--                  <div class="form-group insurance-info">
                                                                <h5>Available Insurance Options:</h5>
                                                                <div class="insurance-list">
                                            <c:forEach var="insurance" items="${bookingInfo.insuranceDetails}">
                                              <div class="insurance-item">
                                                <div class="insurance-name">
                                                  <i class="fas fa-shield-alt"></i>
                                                  <span>${insurance.insuranceName}</span>
                                                </div>
                                                <div class="insurance-description">
                                                  <small>${insurance.description}</small>
                                                </div>
                                              </div>
                                            </c:forEach>
                                            <c:if test="${empty bookingInfo.insuranceDetails}">
                                              <div class="insurance-item">
                                                <div class="insurance-name">
                                                  <i class="fas fa-exclamation-circle"></i>
                                                  <span>No insurance information available</span>
                                                </div>
                                              </div>
                                            </c:if>
                                          </div>
                                        </div>-->

                                            <!-- Driver License Section - Conditional Display -->
                                            <% if (hasDriverLicense == null || !hasDriverLicense) { %>
                                            <div class="form-section" id="driverLicenseSection">
                                                <h4 class="section-title">Driver License Information</h4>

                                                <div class="form-group">
                                                    <label for="licenseNumber">Driver License Number</label>
                                                    <input
                                                        type="text"
                                                        id="licenseNumber"
                                                        name="licenseNumber"
                                                        pattern="[0-9]{12}"
                                                        maxlength="12"
                                                        required
                                                        />
                                                    <small>Enter exactly 12 digits</small>
                                                </div>

                                                <div class="form-group">
                                                    <label for="licenseFullName">Full Name on License</label>
                                                    <input
                                                        type="text"
                                                        id="licenseFullName"
                                                        name="licenseFullName"
                                                        required
                                                        />
                                                </div>

                                                <div class="form-group">
                                                    <label for="licenseDob">Date of Birth</label>
                                                    <input
                                                        type="date"
                                                        id="licenseDob"
                                                        name="licenseDob"
                                                        required
                                                        />
                                                </div>

                                                <div class="form-group">
                                                    <label for="licenseImage">Driver License Image</label>
                                                    <div class="license-upload-container">
                                                        <div
                                                            class="license-upload-area"
                                                            onclick="document.getElementById('licenseImageInput').click()"
                                                            >
                                                            <div class="upload-content">
                                                                <i class="fas fa-cloud-upload-alt"></i>
                                                                <p>Click to upload driver license image</p>
                                                                <small>JPG, PNG, PDF (Max 5MB)</small>
                                                            </div>
                                                        </div>
                                                        <input
                                                            type="file"
                                                            id="licenseImageInput"
                                                            name="licenseImage"
                                                            accept="image/*,.pdf"
                                                            style="display: none"
                                                            required
                                                            />
                                                        <div
                                                            id="licenseImagePreview"
                                                            class="license-image-preview"
                                                            style="display: none"
                                                            >
                                                            <img
                                                                id="previewImg"
                                                                src="/placeholder.svg"
                                                                alt="License Preview"
                                                                />
                                                            <button
                                                                type="button"
                                                                class="remove-image"
                                                                onclick="removeLicenseImage()"
                                                                >
                                                                <i class="fas fa-times"></i>
                                                            </button>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <% } else { %>
                                            <!-- Display existing license info -->
                                            <div class="form-section">
                                                <h4 class="section-title">Driver License Information</h4>
                                                <div class="existing-license-info">
                                                    <div class="license-card">
                                                        <div class="license-header">
                                                            <i class="fas fa-id-card"></i>
                                                            <span>Verified License</span>
                                                        </div>
                                                        <div class="license-details">
                                                            <p>
                                                                <strong>License Number:</strong> <%=
                          driverLicense.getLicenseNumber()%>
                                                            </p>
                                                            <p>
                                                                <strong>Full Name:</strong> <%=
                          driverLicense.getFullName()%>
                                                            </p>
                                                            <p>
                                                                <strong>Date of Birth:</strong> <%=
                          driverLicense.getDob()%>
                                                            </p>
                                                        </div>
                                                        <div class="license-image-display">
                                                            <img
                                                                src="<%= driverLicense.getLicenseImage()%>"
                                                                alt="Driver License"
                                                                class="license-thumbnail"
                                                                />
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <% } %>

                                            <!-- Price Calculation -->
                                            <div class="total-price">
                                                <!-- Thông báo cố định -->
                                                <div
                                                    id="fixedAlert"
                                                    class="fixed-alert"
                                                    style="display: none"
                                                    >
                                                    <div class="alert-content">
                                                        <i class="fas fa-exclamation-circle"></i>
                                                        <span id="fixedAlertText"></span>
                                                    </div>
                                                    <button
                                                        type="button"
                                                        onclick="closeFixedAlert()"
                                                        class="close-alert"
                                                        >
                                                        <i class="fas fa-times"></i>
                                                    </button>
                                                </div>

                                                <div class="price-breakdown">
                                                    <div class="price-row">
                                                        <span>Base Rental Fee:</span>
                                                        <span id="baseRentalFee">0 VND</span>
                                                    </div>
                                                    <div class="price-row">
                                                        <span>Rental Duration:</span>
                                                        <span id="totalDuration">0</span>
                                                    </div>
                                                    <div class="price-row">
                                                        <span>Unit Price:</span>
                                                        <span id="unitPrice">0 VND</span>
                                                    </div>

                                                    <!-- Insurance Section Header -->
                                                    <div class="price-row insurance-header-row">
                                                        <span><strong>Insurance:</strong></span>
                                                        <span></span>
                                                    </div>

                                                    <!-- Basic Insurance (Always visible) -->
                                                    <div class="price-row insurance-item">
                                                        <span>&nbsp;&nbsp;• Basic Insurance:</span>
                                                        <span id="basicInsuranceFee">0 VND</span>
                                                    </div>

                                                    <!-- Additional Insurance (Hidden by default) -->
                                                    <div
                                                        class="price-row insurance-item"
                                                        id="additionalInsuranceRow"
                                                        style="display: none"
                                                        >
                                                        <span>&nbsp;&nbsp;• Personal Insurance:</span>
                                                        <span id="additionalInsuranceFee">0 VND</span>
                                                    </div>

                                                    <div class="price-row total">
                                                        <span>Total Amount:</span>
                                                        <span id="totalPrice">0 VND</span>
                                                    </div>
                                                </div>
                                                <input
                                                    type="hidden"
                                                    name="totalAmount"
                                                    id="hiddenTotalAmount"
                                                    value="0"
                                                    />
                                                <input
                                                    type="hidden"
                                                    name="rentalType"
                                                    id="hiddenRentalType"
                                                    value=""
                                                    />
                                                <!-- Thêm hidden inputs để lưu phí bảo hiểm từ server -->
                                                <input type="hidden" id="basicInsuranceFeeHidden" value="${bookingInfo.basicInsuranceFee}" />
                                                <input type="hidden" id="additionalInsuranceFeeHidden" value="${bookingInfo.additionalInsuranceFee}" />
                                                <input type="hidden" id="carSeatsHidden" value="<%= car.getSeats() %>" />
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
                            <button type="submit" form="bookingForm" class="btn btn-primary">
                                Request Booking Approval
                                <i class="fas fa-paper-plane"></i>
                            </button>
                        </div>
                    </div>
                </main>

                <!-- Insurance Details Modal -->
                <div id="insuranceModal" class="modal" style="display: none">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h3 id="modalTitle">Insurance Details</h3>
                            <span class="close" onclick="closeInsuranceModal()">&times;</span>
                        </div>
                        <div class="modal-body" id="modalBody">
                            <!-- Content will be populated by JavaScript -->
                        </div>
                        <div class="modal-footer">
                            <button
                                type="button"
                                class="btn btn-secondary"
                                onclick="closeInsuranceModal()"
                                >
                                Close
                            </button>
                        </div>
                    </div>
                </div>

                <div
                    id="carPriceData"
                    data-hourly="<%= car.getPricePerHour()%>"
                    data-daily="<%= car.getPricePerDay()%>"
                    data-monthly="<%= car.getPricePerMonth()%>"
                    ></div>

                <script src="<%= request.getContextPath()%>/scripts/booking-form/booking-form-detail.js"></script>
                <!-- Flatpickr JS -->
                <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

                <script>
                                    // Hiển thị thông báo cố định
                                    function showFixedAlert(message, type, autoHide = false) {
                                        const alertElement = document.getElementById("fixedAlert");
                                        const textElement = document.getElementById("fixedAlertText");

                                        if (alertElement && textElement) {
                                            textElement.textContent = message;

                                            // Thiết lập màu sắc dựa trên loại thông báo
                                            alertElement.className = "fixed-alert";
                                            if (type === "error") {
                                                alertElement.classList.add("alert-danger");
                                            } else if (type === "warning") {
                                                alertElement.classList.add("alert-warning");
                                            } else if (type === "success") {
                                                alertElement.classList.add("alert-success");
                                            } else {
                                                alertElement.classList.add("alert-info");
                                            }

                                            alertElement.style.display = "flex";

                                            // Chỉ tự động ẩn nếu được chỉ định
                                            if (autoHide) {
                                                setTimeout(() => {
                                                    closeFixedAlert();
                                                }, 15000); // Kéo dài thời gian hiển thị lên 15 giây
                                            }
                                    }
                                    }

                                    // Đóng thông báo cố định
                                    function closeFixedAlert() {
                                        const alertElement = document.getElementById("fixedAlert");
                                        if (alertElement) {
                                            alertElement.style.display = "none";
                                        }
                                    }

                                    // Hiển thị thông báo dưới trường nhập liệu
                                    function showInputWarning(inputId, message) {
                                        const warningElement = document.querySelector(`.${inputId}-warning`);
                                        const textElement = document.querySelector(`#${inputId}WarningText`);

                                        if (warningElement && textElement) {
                                            textElement.textContent = message;
                                            warningElement.style.display = "block";
                                        }
                                    }

                                    // Ẩn thông báo dưới trường nhập liệu
                                    function hideInputWarning(inputId) {
                                        const warningElement = document.querySelector(`.${inputId}-warning`);
                                        if (warningElement) {
                                            warningElement.style.display = "none";
                                        }
                                    }

                                    // Hiển thị thông báo về quy tắc thuê theo giờ khi chọn loại thuê
                                    document
                                            .getElementById("rentalType")
                                            ?.addEventListener("change", function () {
                                                const hourlyWarning = document.querySelector(".hourly-warning");
                                                if (this.value === "hourly") {
                                                    hourlyWarning.style.display = "block";
                                                    showFixedAlert(
                                                            "Hourly rentals require a minimum of 4 hours. Please select an end time at least 4 hours after the start time.",
                                                            "info",
                                                            false
                                                            );
                                                } else {
                                                    hourlyWarning.style.display = "none";
                                                }
                                            });

                                    // Hiển thị thông báo khi focus vào end date
                                    document
                                            .getElementById("endDate")
                                            ?.addEventListener("focus", function () {
                                                const startDate = document.getElementById("startDate")?.value;
                                                if (startDate) {
                                                    const rentalType = document.getElementById("rentalType")?.value;
                                                    if (rentalType === "hourly") {
                                                        showInputWarning(
                                                                "end-time",
                                                                "Please select at least 4 hours after start time"
                                                                );
                                                        showFixedAlert(
                                                                "Hourly rentals require a minimum of 4 hours",
                                                                "info",
                                                                false
                                                                );
                                                    }
                                                } else {
                                                    showInputWarning("end-time", "Please select start date first");
                                                }
                                            });

                                    // Hiển thị thông báo khi trang được tải
                                    document.addEventListener("DOMContentLoaded", function () {
                                        // Hiển thị thông báo chung về quy tắc thuê xe
                                        setTimeout(() => {
                                            showFixedAlert(
                                                    "Welcome! Please note: Hourly rentals require minimum 4 hours, and our service is available from 7:00 AM to 10:00 PM.",
                                                    "info",
                                                    true
                                                    );
                                        }, 1000);

                                        // Thêm thông báo cho start date
                                        document
                                                .getElementById("startDate")
                                                ?.addEventListener("focus", function () {
                                                    showInputWarning("start-time", "Select between 7:00 AM - 10:00 PM");
                                                });

                                        // Thêm sự kiện blur cho các trường nhập liệu
                                        document
                                                .getElementById("startDate")
                                                ?.addEventListener("blur", function () {
                                                    setTimeout(() => hideInputWarning("start-time"), 200);
                                                });

                                        document
                                                .getElementById("endDate")
                                                ?.addEventListener("blur", function () {
                                                    setTimeout(() => hideInputWarning("end-time"), 200);
                                                });
                                    });
                </script>
            </body>
        </html>
