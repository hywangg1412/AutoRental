<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Book Car - AutoRental</title>
    <!-- Sau -->
    <link
      rel="stylesheet"
      href="<%= request.getContextPath() %>/styles/booking-form/booking-form-details.css"
    />

    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />
  </head>

  <!-- details này là trang dùng cho book 1 xe -->

  <body>
    <!-- Header -->
    <header class="header">
      <div class="container">
        <div class="header-content">
          <div class="logo">
            <h1>AUTO<span>RENTAL</span></h1>
          </div>
          <nav class="nav">
            <a href="#" class="nav-link">Home</a>
            <a href="#" class="nav-link">My Booking</a>
            <div class="user-menu">
              <i class="fas fa-bell"></i>
              <i class="fas fa-comment"></i>
              <div class="user-avatar">
                <span>hywang1412</span>
                <i class="fas fa-chevron-down"></i>
              </div>
            </div>
          </nav>
        </div>
      </div>
    </header>

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
                  src="/placeholder.svg?height=400&width=600"
                  alt="Car Main Image"
                  id="mainCarImage"
                />
              </div>
              <div class="thumbnail-gallery">
                <img
                  src="/placeholder.svg?height=100&width=150"
                  alt="Car Image 1"
                  class="thumbnail active"
                  onclick="changeMainImage(this)"
                />
                <img
                  src="/placeholder.svg?height=100&width=150"
                  alt="Car Image 2"
                  class="thumbnail"
                  onclick="changeMainImage(this)"
                />
                <img
                  src="/placeholder.svg?height=100&width=150"
                  alt="Car Image 3"
                  class="thumbnail"
                  onclick="changeMainImage(this)"
                />
                <img
                  src="/placeholder.svg?height=100&width=150"
                  alt="Car Image 4"
                  class="thumbnail"
                  onclick="changeMainImage(this)"
                />
              </div>
            </div>

            <div class="car-details">
              <div class="car-header">
                <h2 class="car-title">KIA SEDONA PREMIUM 2017</h2>
                <div class="car-rating">
                  <div class="stars">
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                    <i class="fas fa-star"></i>
                  </div>
                  <span class="rating-text">5.0 (35 trips)</span>
                </div>
              </div>

              <div class="car-specs">
                <div class="spec-item">
                  <i class="fas fa-cog"></i>
                  <span>Automatic</span>
                </div>
                <div class="spec-item">
                  <i class="fas fa-users"></i>
                  <span>7 seats</span>
                </div>
                <div class="spec-item">
                  <i class="fas fa-gas-pump"></i>
                  <span>Gasoline</span>
                </div>
                <div class="spec-item">
                  <i class="fas fa-map-marker-alt"></i>
                  <span>Thanh Khe District, Da Nang</span>
                </div>
              </div>

              <div class="pricing">
                <div class="price-item">
                  <span class="price-label">Hourly rate:</span>
                  <span class="price-value">150K/hour</span>
                </div>
                <div class="price-item">
                  <span class="price-label">Daily rate:</span>
                  <span class="price-value">1,301K/day</span>
                </div>
                <div class="price-item">
                  <span class="price-label">Monthly rate:</span>
                  <span class="price-value">25,000K/month</span>
                </div>
              </div>

              <div class="car-description">
                <h3>Car Description</h3>
                <p>${car.description}</p>
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

              <div class="reviews-section">
                <h3>Customer Reviews</h3>
                <div class="review-item">
                  <div class="review-header">
                    <div class="reviewer-info">
                      <img
                        src="/placeholder.svg?height=40&width=40"
                        alt="Reviewer"
                        class="reviewer-avatar"
                      />
                      <div>
                        <span class="reviewer-name">Nguyễn Văn A</span>
                        <div class="review-stars">
                          <i class="fas fa-star"></i>
                          <i class="fas fa-star"></i>
                          <i class="fas fa-star"></i>
                          <i class="fas fa-star"></i>
                          <i class="fas fa-star"></i>
                        </div>
                      </div>
                    </div>
                    <span class="review-date">2 days ago</span>
                  </div>
                  <p class="review-text">
                    Very clean car, enthusiastic owner. Will rent again next
                    time!
                  </p>
                </div>
              </div>
            </div>
          </div>

          <!-- Right Side - Booking Form -->
          <div class="booking-form-section">
            <div class="booking-form-container">
              <h3>Car Booking Information</h3>
              <form
                id="bookingForm"
                action="booking-form-deposit.jsp"
                method="post"
              >
                <input type="hidden" name="carId" value="${car.carId}" />

                <div class="form-group">
                  <label for="rentalType">Rental Type</label>
                  <select id="rentalType" name="rentalType" required>
                    <option value="">Select rental type</option>
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
                    required
                  />
                </div>

                <div class="form-group">
                  <label for="endDate">End Date</label>
                  <input
                    type="datetime-local"
                    id="endDate"
                    name="endDate"
                    required
                  />
                </div>

                <div class="form-group">
                  <label for="pickupLocation">Pickup Location</label>
                  <select id="pickupLocation" name="pickupLocation" required>
                    <option value="">Select location</option>
                    <option value="office">At office</option>
                    <option value="delivery">Home delivery</option>
                  </select>
                </div>

                <div class="form-group">
                  <label for="customerName">Full Name</label>
                  <input
                    type="text"
                    id="customerName"
                    name="customerName"
                    required
                  />
                </div>

                <div class="form-group">
                  <label for="customerPhone">Phone Number</label>
                  <input
                    type="tel"
                    id="customerPhone"
                    name="customerPhone"
                    required
                  />
                </div>

                <div class="form-group">
                  <label for="customerEmail">Email</label>
                  <input
                    type="email"
                    id="customerEmail"
                    name="customerEmail"
                    required
                  />
                </div>

                <div class="form-group">
                  <label for="customerAddress">Address</label>
                  <textarea
                    id="customerAddress"
                    name="customerAddress"
                    rows="3"
                    required
                  ></textarea>
                </div>

                <div class="form-group">
                  <label for="licenseNumber">Driver License Number</label>
                  <input
                    type="text"
                    id="licenseNumber"
                    name="licenseNumber"
                    required
                  />
                </div>

                <div class="form-group">
                  <label for="notes">Notes (optional)</label>
                  <textarea
                    id="notes"
                    name="notes"
                    rows="3"
                    placeholder="Special requests..."
                  ></textarea>
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
          <button type="submit" form="bookingForm" class="btn btn-primary">
            Continue to Deposit
            <i class="fas fa-arrow-right"></i>
          </button>
        </div>
      </div>
    </main>

    <script src="<%= request.getContextPath() %>/scripts/booking-form/booking-form-details.js"></script>
  </body>
</html>
