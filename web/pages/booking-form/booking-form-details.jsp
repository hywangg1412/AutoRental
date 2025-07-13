<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
    prefix="c" uri="jakarta.tags.core" %> <%@ page import="Model.DTO.CarDetailDTO"
                                               %> <%@ page import="Model.Entity.User.User" %> <%@ page
    import="Model.Entity.User.DriverLicense" %> <% User user = (User)
    session.getAttribute("user"); if (user == null) {
    response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
    return; } CarDetailDTO car = (CarDetailDTO) request.getAttribute("car"); Boolean
    hasDriverLicense = (Boolean) request.getAttribute("hasDriverLicense");
    DriverLicense driverLicense = (DriverLicense)
    request.getAttribute("driverLicense"); %>

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
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
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
                                            <span class="price-value"
                                                  ><%= car.getPricePerHour()%>K/hour</span
                                            >
                                        </div>
                                        <div class="price-item">
                                            <span class="price-label">Daily rate:</span>
                                            <span class="price-value"
                                                  ><%= car.getPricePerDay()%>K/day</span
                                            >
                                        </div>
                                        <div class="price-item">
                                            <span class="price-label">Monthly rate:</span>
                                            <span class="price-value"
                                                  ><%= car.getPricePerMonth()%>K/month</span
                                            >
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


                                <div class="alert alert-info" style="margin-top: 1rem;">
                                    <i class="fas fa-info-circle"></i>
                                    <span>
                                        For <strong>daily</strong> and <strong>monthly</strong> rentals, we recommend booking full day/month blocks.
                                        <br>
                                        Note: If you exceed the block slightly (e.g., 1 day 5 hours or 1 month 7 days), AutoRental will round up the duration
                                        based on system logic.
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
                                            <h4 class="section-title">Rental Information</h4>

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
                                                <label for="startDate">Start Date</label>
                                                <input
                                                    type="datetime-local"
                                                    id="startDate"
                                                    name="startDate"
<!--                                                    value="${pickupDefault}"-->
<!--                                                    required
                                                    />-->
                                            </div>

                                            <div class="form-group">
                                                <label for="endDate">End Date</label>
                                                <input
                                                    type="datetime-local"
                                                    id="endDate"
                                                    name="endDate"
<!--                                                    value="${returnDefault}"-->
<!--                                                    required
                                                    />-->
                                            </div>
                                        </div>

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
                                                        <img id="previewImg" src="" alt="License Preview" />
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

                <div
                    id="carPriceData"
                    data-hourly="<%= car.getPricePerHour()%>"
                    data-daily="<%= car.getPricePerDay()%>"
                    data-monthly="<%= car.getPricePerMonth()%>"
                    ></div>

                <script src="<%= request.getContextPath()%>/scripts/booking-form/booking-form-detail.js"></script>
                <!-- Flatpickr JS -->
                <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>

            </body>
        </html>
