<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Book Multiple Cars - AutoRental</title>
    <link
      rel="stylesheet"
      href="<%= request.getContextPath() %>/styles/booking-form/booking-form-multiple.css"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />
  </head>

  <!-- trang này để điền form book list xe -->

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
          <!-- Left Side - Car List -->
          <div class="cars-list-section">
            <h3>Selected Cars (3)</h3>
            <div class="cars-list-container">
              <!-- Car Item 1 -->
              <div class="car-item">
                <div class="car-header" onclick="toggleCarDetails(1)">
                  <div class="car-basic-info">
                    <img
                      src="/placeholder.svg?height=80&width=120"
                      alt="KIA SEDONA PREMIUM 2017"
                      class="car-thumbnail"
                    />
                    <div class="car-title-price">
                      <h4>KIA SEDONA PREMIUM 2017</h4>
                      <span class="car-price">1,301K/day</span>
                    </div>
                  </div>
                  <button class="btn-toggle" id="toggle-1">
                    <i class="fas fa-chevron-down"></i>
                  </button>
                </div>
                <div class="car-details" id="details-1">
                  <div class="car-gallery">
                    <div class="gallery-main">
                      <img
                        src="/placeholder.svg?height=300&width=400"
                        alt="KIA SEDONA Main"
                        id="main-img-1"
                      />
                      <button
                        class="gallery-nav prev"
                        onclick="previousImage(1)"
                      >
                        <i class="fas fa-chevron-left"></i>
                      </button>
                      <button class="gallery-nav next" onclick="nextImage(1)">
                        <i class="fas fa-chevron-right"></i>
                      </button>
                    </div>
                    <div class="gallery-thumbnails">
                      <img
                        src="/placeholder.svg?height=80&width=120"
                        alt="KIA SEDONA 1"
                        class="thumbnail active"
                        onclick="selectImage(1, 0)"
                      />
                      <img
                        src="/placeholder.svg?height=80&width=120"
                        alt="KIA SEDONA 2"
                        class="thumbnail"
                        onclick="selectImage(1, 1)"
                      />
                      <img
                        src="/placeholder.svg?height=80&width=120"
                        alt="KIA SEDONA 3"
                        class="thumbnail"
                        onclick="selectImage(1, 2)"
                      />
                      <img
                        src="/placeholder.svg?height=80&width=120"
                        alt="KIA SEDONA 4"
                        class="thumbnail"
                        onclick="selectImage(1, 3)"
                      />
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
                  <div class="car-features">
                    <h5>Amenities</h5>
                    <div class="features-grid">
                      <span
                        ><i class="fas fa-snowflake"></i> Air Conditioning</span
                      >
                      <span><i class="fas fa-music"></i> Bluetooth</span>
                      <span><i class="fas fa-video"></i> Dashcam</span>
                      <span><i class="fas fa-usb"></i> USB Charging</span>
                    </div>
                  </div>
                  <div class="car-description">
                    <h5>Description</h5>
                    <p>
                      Spacious and comfortable 7-seater SUV perfect for family
                      trips. Well-maintained with modern amenities and safety
                      features.
                    </p>
                  </div>
                </div>
              </div>

              <!-- Car Item 2 -->
              <div class="car-item">
                <div class="car-header" onclick="toggleCarDetails(2)">
                  <div class="car-basic-info">
                    <img
                      src="/placeholder.svg?height=80&width=120"
                      alt="Toyota Vios 2020"
                      class="car-thumbnail"
                    />
                    <div class="car-title-price">
                      <h4>Toyota Vios 2020</h4>
                      <span class="car-price">1,150K/day</span>
                    </div>
                  </div>
                  <button class="btn-toggle" id="toggle-2">
                    <i class="fas fa-chevron-down"></i>
                  </button>
                </div>
                <div class="car-details" id="details-2">
                  <div class="car-gallery">
                    <div class="gallery-main">
                      <img
                        src="/placeholder.svg?height=300&width=400"
                        alt="Toyota Vios Main"
                        id="main-img-2"
                      />
                      <button
                        class="gallery-nav prev"
                        onclick="previousImage(2)"
                      >
                        <i class="fas fa-chevron-left"></i>
                      </button>
                      <button class="gallery-nav next" onclick="nextImage(2)">
                        <i class="fas fa-chevron-right"></i>
                      </button>
                    </div>
                    <div class="gallery-thumbnails">
                      <img
                        src="/placeholder.svg?height=80&width=120"
                        alt="Toyota Vios 1"
                        class="thumbnail active"
                        onclick="selectImage(2, 0)"
                      />
                      <img
                        src="/placeholder.svg?height=80&width=120"
                        alt="Toyota Vios 2"
                        class="thumbnail"
                        onclick="selectImage(2, 1)"
                      />
                      <img
                        src="/placeholder.svg?height=80&width=120"
                        alt="Toyota Vios 3"
                        class="thumbnail"
                        onclick="selectImage(2, 2)"
                      />
                      <img
                        src="/placeholder.svg?height=80&width=120"
                        alt="Toyota Vios 4"
                        class="thumbnail"
                        onclick="selectImage(2, 3)"
                      />
                    </div>
                  </div>
                  <div class="car-specs">
                    <div class="spec-item">
                      <i class="fas fa-cog"></i>
                      <span>Automatic</span>
                    </div>
                    <div class="spec-item">
                      <i class="fas fa-users"></i>
                      <span>5 seats</span>
                    </div>
                    <div class="spec-item">
                      <i class="fas fa-gas-pump"></i>
                      <span>Gasoline</span>
                    </div>
                    <div class="spec-item">
                      <i class="fas fa-map-marker-alt"></i>
                      <span>Hai Chau District, Da Nang</span>
                    </div>
                  </div>
                  <div class="car-rating">
                    <div class="stars">
                      <i class="fas fa-star"></i>
                      <i class="fas fa-star"></i>
                      <i class="fas fa-star"></i>
                      <i class="fas fa-star"></i>
                      <i class="fas fa-star-half-alt"></i>
                    </div>
                    <span class="rating-text">4.8 (28 trips)</span>
                  </div>
                  <div class="car-features">
                    <h5>Amenities</h5>
                    <div class="features-grid">
                      <span
                        ><i class="fas fa-snowflake"></i> Air Conditioning</span
                      >
                      <span><i class="fas fa-music"></i> Bluetooth</span>
                      <span><i class="fas fa-wifi"></i> WiFi</span>
                      <span><i class="fas fa-usb"></i> USB Charging</span>
                    </div>
                  </div>
                  <div class="car-description">
                    <h5>Description</h5>
                    <p>
                      Reliable and fuel-efficient sedan ideal for city driving
                      and short trips. Modern features with excellent comfort.
                    </p>
                  </div>
                </div>
              </div>

              <!-- Car Item 3 -->
              <div class="car-item">
                <div class="car-header" onclick="toggleCarDetails(3)">
                  <div class="car-basic-info">
                    <img
                      src="/placeholder.svg?height=80&width=120"
                      alt="Honda City 2019"
                      class="car-thumbnail"
                    />
                    <div class="car-title-price">
                      <h4>Honda City 2019</h4>
                      <span class="car-price">950K/day</span>
                    </div>
                  </div>
                  <button class="btn-toggle" id="toggle-3">
                    <i class="fas fa-chevron-down"></i>
                  </button>
                </div>
                <div class="car-details" id="details-3">
                  <div class="car-gallery">
                    <div class="gallery-main">
                      <img
                        src="/placeholder.svg?height=300&width=400"
                        alt="Honda City Main"
                        id="main-img-3"
                      />
                      <button
                        class="gallery-nav prev"
                        onclick="previousImage(3)"
                      >
                        <i class="fas fa-chevron-left"></i>
                      </button>
                      <button class="gallery-nav next" onclick="nextImage(3)">
                        <i class="fas fa-chevron-right"></i>
                      </button>
                    </div>
                    <div class="gallery-thumbnails">
                      <img
                        src="/placeholder.svg?height=80&width=120"
                        alt="Honda City 1"
                        class="thumbnail active"
                        onclick="selectImage(3, 0)"
                      />
                      <img
                        src="/placeholder.svg?height=80&width=120"
                        alt="Honda City 2"
                        class="thumbnail"
                        onclick="selectImage(3, 1)"
                      />
                      <img
                        src="/placeholder.svg?height=80&width=120"
                        alt="Honda City 3"
                        class="thumbnail"
                        onclick="selectImage(3, 2)"
                      />
                      <img
                        src="/placeholder.svg?height=80&width=120"
                        alt="Honda City 4"
                        class="thumbnail"
                        onclick="selectImage(3, 3)"
                      />
                    </div>
                  </div>
                  <div class="car-specs">
                    <div class="spec-item">
                      <i class="fas fa-cog"></i>
                      <span>Manual</span>
                    </div>
                    <div class="spec-item">
                      <i class="fas fa-users"></i>
                      <span>5 seats</span>
                    </div>
                    <div class="spec-item">
                      <i class="fas fa-gas-pump"></i>
                      <span>Gasoline</span>
                    </div>
                    <div class="spec-item">
                      <i class="fas fa-map-marker-alt"></i>
                      <span>Son Tra District, Da Nang</span>
                    </div>
                  </div>
                  <div class="car-rating">
                    <div class="stars">
                      <i class="fas fa-star"></i>
                      <i class="fas fa-star"></i>
                      <i class="fas fa-star"></i>
                      <i class="fas fa-star"></i>
                      <i class="fas fa-star"></i>
                    </div>
                    <span class="rating-text">4.9 (42 trips)</span>
                  </div>
                  <div class="car-features">
                    <h5>Amenities</h5>
                    <div class="features-grid">
                      <span
                        ><i class="fas fa-snowflake"></i> Air Conditioning</span
                      >
                      <span><i class="fas fa-music"></i> Bluetooth</span>
                      <span><i class="fas fa-usb"></i> USB Charging</span>
                    </div>
                  </div>
                  <div class="car-description">
                    <h5>Description</h5>
                    <p>
                      Compact and economical sedan with manual transmission.
                      Perfect for budget-conscious travelers who enjoy driving
                      control.
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Right Side - Booking Form -->
          <div class="booking-form-section">
            <div class="booking-form-container">
              <h3>Multiple Car Booking</h3>
              <form
                id="bookingForm"
                action="booking-form-deposit.jsp"
                method="post"
              >
                <input type="hidden" name="carIds" value="1,2,3" />

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
                    placeholder="Special requests for multiple cars..."
                  ></textarea>
                </div>

                <div class="total-price">
                  <div class="price-breakdown">
                    <div class="price-row">
                      <span>Total Cars:</span>
                      <span id="totalCars">3 cars</span>
                    </div>
                    <div class="price-row">
                      <span>Total Duration:</span>
                      <span id="totalDuration">0 days</span>
                    </div>
                    <div class="price-row">
                      <span>Subtotal:</span>
                      <span id="subtotal">0K</span>
                    </div>
                    <div
                      class="price-row discount"
                      id="discountRow"
                      style="display: none"
                    >
                      <span>Discount:</span>
                      <span id="discountAmount">-0K</span>
                    </div>
                    <div class="price-row deposit">
                      <span>Deposit Required (30%):</span>
                      <span id="depositAmount">0K</span>
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
          <button type="button" class="btn btn-secondary" onclick="goBack()">
            <i class="fas fa-arrow-left"></i>
            Back to Cart
          </button>
          <button type="submit" form="bookingForm" class="btn btn-primary">
            Continue to Deposit
            <i class="fas fa-arrow-right"></i>
          </button>
        </div>
      </div>
    </main>

    <script src="<%= request.getContextPath() %>/scripts/booking-form/booking-form-multiple.js"></script>
  </body>
</html>
