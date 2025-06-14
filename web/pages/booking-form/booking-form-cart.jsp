<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Car Cart - AutoRental</title>
    <link rel="stylesheet" href="styles/booking-form/booking-form-cart.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
</head>
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

    <!-- Main Content -->
    <main class="main-content">
        <div class="container">
            <div class="cart-header">
                <h2>Car Rental Cart</h2>
                <span class="cart-count">4 cars in cart</span>
            </div>

            <div class="cart-container">
                <!-- Left Side - Car List -->
                <div class="cart-items-section">
                    <div class="cart-header-controls">
                        <label class="checkbox-container">
                            <input type="checkbox" id="selectAll">
                            <span class="checkmark"></span>
                            Select All (4)
                        </label>
                        <button class="btn-remove-selected" id="removeSelected" disabled>
                            <i class="fas fa-trash"></i>
                            Remove Selected
                        </button>
                    </div>

                    <div class="cart-items-list">
                        <!-- Car Item 1 -->
                        <div class="cart-item" data-car-id="1" data-price="1301">
                            <div class="cart-item-header">
                                <label class="checkbox-container">
                                    <input type="checkbox" class="car-checkbox" data-car-id="1">
                                    <span class="checkmark"></span>
                                </label>
                                <div class="car-image">
                                    <img src="/placeholder.svg?height=120&width=180" alt="KIA SEDONA PREMIUM 2017">
                                </div>
                                <div class="car-info">
                                    <h4 class="car-title">KIA SEDONA PREMIUM 2017</h4>
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
                                    <div class="car-specs-mini">
                                        <span><i class="fas fa-users"></i> 7 seats</span>
                                        <span><i class="fas fa-cog"></i> Automatic</span>
                                        <span><i class="fas fa-gas-pump"></i> Gasoline</span>
                                    </div>
                                    <div class="car-location">
                                        <i class="fas fa-map-marker-alt"></i>
                                        Thanh Khe District, Da Nang
                                    </div>
                                </div>
                                <div class="car-price">
                                    <span class="price-value">1,301K/day</span>
                                    <span class="price-label">Daily rate</span>
                                </div>
                                <div class="car-actions">
                                    <button class="btn-expand" onclick="toggleCarDetails(1)" id="expand-1">
                                        <i class="fas fa-chevron-down"></i>
                                    </button>
                                    <button class="btn-remove" onclick="removeCarFromCart(1)">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <!-- Expandable Details -->
                            <div class="car-details" id="details-1">
                                <div class="car-gallery">
                                    <div class="gallery-main">
                                        <img src="/placeholder.svg?height=300&width=400" alt="KIA SEDONA Main" id="main-img-1">
                                        <button class="gallery-nav prev" onclick="previousImage(1)">
                                            <i class="fas fa-chevron-left"></i>
                                        </button>
                                        <button class="gallery-nav next" onclick="nextImage(1)">
                                            <i class="fas fa-chevron-right"></i>
                                        </button>
                                    </div>
                                    <div class="gallery-thumbnails">
                                        <img src="/placeholder.svg?height=80&width=120" alt="KIA SEDONA 1" class="thumbnail active" onclick="selectImage(1, 0)">
                                        <img src="/placeholder.svg?height=80&width=120" alt="KIA SEDONA 2" class="thumbnail" onclick="selectImage(1, 1)">
                                        <img src="/placeholder.svg?height=80&width=120" alt="KIA SEDONA 3" class="thumbnail" onclick="selectImage(1, 2)">
                                        <img src="/placeholder.svg?height=80&width=120" alt="KIA SEDONA 4" class="thumbnail" onclick="selectImage(1, 3)">
                                    </div>
                                </div>
                                <div class="car-full-specs">
                                    <div class="specs-grid">
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
                                            <i class="fas fa-calendar"></i>
                                            <span>2017</span>
                                        </div>
                                    </div>
                                    <div class="car-amenities">
                                        <h5>Amenities</h5>
                                        <div class="amenities-grid">
                                            <span><i class="fas fa-snowflake"></i> Air Conditioning</span>
                                            <span><i class="fas fa-music"></i> Bluetooth</span>
                                            <span><i class="fas fa-video"></i> Dashcam</span>
                                            <span><i class="fas fa-wifi"></i> WiFi</span>
                                        </div>
                                    </div>
                                    <div class="car-description">
                                        <h5>Description</h5>
                                        <p>Spacious and comfortable 7-seater SUV perfect for family trips. Well-maintained with modern amenities and safety features.</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Car Item 2 -->
                        <div class="cart-item" data-car-id="2" data-price="1150">
                            <div class="cart-item-header">
                                <label class="checkbox-container">
                                    <input type="checkbox" class="car-checkbox" data-car-id="2">
                                    <span class="checkmark"></span>
                                </label>
                                <div class="car-image">
                                    <img src="/placeholder.svg?height=120&width=180" alt="Toyota Vios 2020">
                                </div>
                                <div class="car-info">
                                    <h4 class="car-title">Toyota Vios 2020</h4>
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
                                    <div class="car-specs-mini">
                                        <span><i class="fas fa-users"></i> 5 seats</span>
                                        <span><i class="fas fa-cog"></i> Automatic</span>
                                        <span><i class="fas fa-gas-pump"></i> Gasoline</span>
                                    </div>
                                    <div class="car-location">
                                        <i class="fas fa-map-marker-alt"></i>
                                        Hai Chau District, Da Nang
                                    </div>
                                </div>
                                <div class="car-price">
                                    <span class="price-value">1,150K/day</span>
                                    <span class="price-label">Daily rate</span>
                                </div>
                                <div class="car-actions">
                                    <button class="btn-expand" onclick="toggleCarDetails(2)" id="expand-2">
                                        <i class="fas fa-chevron-down"></i>
                                    </button>
                                    <button class="btn-remove" onclick="removeCarFromCart(2)">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <!-- Expandable Details -->
                            <div class="car-details" id="details-2">
                                <div class="car-gallery">
                                    <div class="gallery-main">
                                        <img src="/placeholder.svg?height=300&width=400" alt="Toyota Vios Main" id="main-img-2">
                                        <button class="gallery-nav prev" onclick="previousImage(2)">
                                            <i class="fas fa-chevron-left"></i>
                                        </button>
                                        <button class="gallery-nav next" onclick="nextImage(2)">
                                            <i class="fas fa-chevron-right"></i>
                                        </button>
                                    </div>
                                    <div class="gallery-thumbnails">
                                        <img src="/placeholder.svg?height=80&width=120" alt="Toyota Vios 1" class="thumbnail active" onclick="selectImage(2, 0)">
                                        <img src="/placeholder.svg?height=80&width=120" alt="Toyota Vios 2" class="thumbnail" onclick="selectImage(2, 1)">
                                        <img src="/placeholder.svg?height=80&width=120" alt="Toyota Vios 3" class="thumbnail" onclick="selectImage(2, 2)">
                                        <img src="/placeholder.svg?height=80&width=120" alt="Toyota Vios 4" class="thumbnail" onclick="selectImage(2, 3)">
                                    </div>
                                </div>
                                <div class="car-full-specs">
                                    <div class="specs-grid">
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
                                            <i class="fas fa-calendar"></i>
                                            <span>2020</span>
                                        </div>
                                    </div>
                                    <div class="car-amenities">
                                        <h5>Amenities</h5>
                                        <div class="amenities-grid">
                                            <span><i class="fas fa-snowflake"></i> Air Conditioning</span>
                                            <span><i class="fas fa-music"></i> Bluetooth</span>
                                            <span><i class="fas fa-wifi"></i> WiFi</span>
                                            <span><i class="fas fa-usb"></i> USB Charging</span>
                                        </div>
                                    </div>
                                    <div class="car-description">
                                        <h5>Description</h5>
                                        <p>Reliable and fuel-efficient sedan ideal for city driving and short trips. Modern features with excellent comfort.</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Car Item 3 -->
                        <div class="cart-item" data-car-id="3" data-price="950">
                            <div class="cart-item-header">
                                <label class="checkbox-container">
                                    <input type="checkbox" class="car-checkbox" data-car-id="3">
                                    <span class="checkmark"></span>
                                </label>
                                <div class="car-image">
                                    <img src="/placeholder.svg?height=120&width=180" alt="Honda City 2019">
                                </div>
                                <div class="car-info">
                                    <h4 class="car-title">Honda City 2019</h4>
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
                                    <div class="car-specs-mini">
                                        <span><i class="fas fa-users"></i> 5 seats</span>
                                        <span><i class="fas fa-cog"></i> Manual</span>
                                        <span><i class="fas fa-gas-pump"></i> Gasoline</span>
                                    </div>
                                    <div class="car-location">
                                        <i class="fas fa-map-marker-alt"></i>
                                        Son Tra District, Da Nang
                                    </div>
                                </div>
                                <div class="car-price">
                                    <span class="price-value">950K/day</span>
                                    <span class="price-label">Daily rate</span>
                                </div>
                                <div class="car-actions">
                                    <button class="btn-expand" onclick="toggleCarDetails(3)" id="expand-3">
                                        <i class="fas fa-chevron-down"></i>
                                    </button>
                                    <button class="btn-remove" onclick="removeCarFromCart(3)">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <!-- Expandable Details -->
                            <div class="car-details" id="details-3">
                                <div class="car-gallery">
                                    <div class="gallery-main">
                                        <img src="/placeholder.svg?height=300&width=400" alt="Honda City Main" id="main-img-3">
                                        <button class="gallery-nav prev" onclick="previousImage(3)">
                                            <i class="fas fa-chevron-left"></i>
                                        </button>
                                        <button class="gallery-nav next" onclick="nextImage(3)">
                                            <i class="fas fa-chevron-right"></i>
                                        </button>
                                    </div>
                                    <div class="gallery-thumbnails">
                                        <img src="/placeholder.svg?height=80&width=120" alt="Honda City 1" class="thumbnail active" onclick="selectImage(3, 0)">
                                        <img src="/placeholder.svg?height=80&width=120" alt="Honda City 2" class="thumbnail" onclick="selectImage(3, 1)">
                                        <img src="/placeholder.svg?height=80&width=120" alt="Honda City 3" class="thumbnail" onclick="selectImage(3, 2)">
                                        <img src="/placeholder.svg?height=80&width=120" alt="Honda City 4" class="thumbnail" onclick="selectImage(3, 3)">
                                    </div>
                                </div>
                                <div class="car-full-specs">
                                    <div class="specs-grid">
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
                                            <i class="fas fa-calendar"></i>
                                            <span>2019</span>
                                        </div>
                                    </div>
                                    <div class="car-amenities">
                                        <h5>Amenities</h5>
                                        <div class="amenities-grid">
                                            <span><i class="fas fa-snowflake"></i> Air Conditioning</span>
                                            <span><i class="fas fa-music"></i> Bluetooth</span>
                                            <span><i class="fas fa-usb"></i> USB Charging</span>
                                        </div>
                                    </div>
                                    <div class="car-description">
                                        <h5>Description</h5>
                                        <p>Compact and economical sedan with manual transmission. Perfect for budget-conscious travelers who enjoy driving control.</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Car Item 4 -->
                        <div class="cart-item" data-car-id="4" data-price="1200">
                            <div class="cart-item-header">
                                <label class="checkbox-container">
                                    <input type="checkbox" class="car-checkbox" data-car-id="4">
                                    <span class="checkmark"></span>
                                </label>
                                <div class="car-image">
                                    <img src="/placeholder.svg?height=120&width=180" alt="Mazda CX-5 2021">
                                </div>
                                <div class="car-info">
                                    <h4 class="car-title">Mazda CX-5 2021</h4>
                                    <div class="car-rating">
                                        <div class="stars">
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                        </div>
                                        <span class="rating-text">5.0 (15 trips)</span>
                                    </div>
                                    <div class="car-specs-mini">
                                        <span><i class="fas fa-users"></i> 7 seats</span>
                                        <span><i class="fas fa-cog"></i> Automatic</span>
                                        <span><i class="fas fa-gas-pump"></i> Gasoline</span>
                                    </div>
                                    <div class="car-location">
                                        <i class="fas fa-map-marker-alt"></i>
                                        Cam Le District, Da Nang
                                    </div>
                                </div>
                                <div class="car-price">
                                    <span class="price-value">1,200K/day</span>
                                    <span class="price-label">Daily rate</span>
                                </div>
                                <div class="car-actions">
                                    <button class="btn-expand" onclick="toggleCarDetails(4)" id="expand-4">
                                        <i class="fas fa-chevron-down"></i>
                                    </button>
                                    <button class="btn-remove" onclick="removeCarFromCart(4)">
                                        <i class="fas fa-trash"></i>
                                    </button>
                                </div>
                            </div>
                            
                            <!-- Expandable Details -->
                            <div class="car-details" id="details-4">
                                <div class="car-gallery">
                                    <div class="gallery-main">
                                        <img src="/placeholder.svg?height=300&width=400" alt="Mazda CX-5 Main" id="main-img-4">
                                        <button class="gallery-nav prev" onclick="previousImage(4)">
                                            <i class="fas fa-chevron-left"></i>
                                        </button>
                                        <button class="gallery-nav next" onclick="nextImage(4)">
                                            <i class="fas fa-chevron-right"></i>
                                        </button>
                                    </div>
                                    <div class="gallery-thumbnails">
                                        <img src="/placeholder.svg?height=80&width=120" alt="Mazda CX-5 1" class="thumbnail active" onclick="selectImage(4, 0)">
                                        <img src="/placeholder.svg?height=80&width=120" alt="Mazda CX-5 2" class="thumbnail" onclick="selectImage(4, 1)">
                                        <img src="/placeholder.svg?height=80&width=120" alt="Mazda CX-5 3" class="thumbnail" onclick="selectImage(4, 2)">
                                        <img src="/placeholder.svg?height=80&width=120" alt="Mazda CX-5 4" class="thumbnail" onclick="selectImage(4, 3)">
                                    </div>
                                </div>
                                <div class="car-full-specs">
                                    <div class="specs-grid">
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
                                            <i class="fas fa-calendar"></i>
                                            <span>2021</span>
                                        </div>
                                    </div>
                                    <div class="car-amenities">
                                        <h5>Amenities</h5>
                                        <div class="amenities-grid">
                                            <span><i class="fas fa-snowflake"></i> Air Conditioning</span>
                                            <span><i class="fas fa-music"></i> Bluetooth</span>
                                            <span><i class="fas fa-video"></i> Dashcam</span>
                                            <span><i class="fas fa-wifi"></i> WiFi</span>
                                        </div>
                                    </div>
                                    <div class="car-description">
                                        <h5>Description</h5>
                                        <p>Premium SUV with advanced safety features and luxurious interior. Ideal for long trips and special occasions.</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Side - Order Summary -->
                <div class="order-summary-section">
                    <div class="order-summary-container">
                        <h3>Order Summary</h3>
                        
                        <!-- Voucher Section -->
                        <div class="voucher-section">
                            <div class="voucher-header">
                                <i class="fas fa-ticket-alt"></i>
                                <span>Voucher</span>
                            </div>
                            <div class="voucher-input">
                                <input type="text" placeholder="Enter voucher code" id="voucherCode">
                                <button class="btn-apply-voucher" onclick="applyVoucher()">Apply</button>
                            </div>
                            <div class="available-vouchers">
                                <button class="btn-select-voucher" onclick="showVoucherModal()">
                                    <i class="fas fa-tags"></i>
                                    Select Available Voucher
                                </button>
                            </div>
                        </div>

                        <!-- Price Breakdown -->
                        <div class="price-breakdown">
                            <div class="price-row">
                                <span>Selected Cars:</span>
                                <span id="selectedCount">0 cars</span>
                            </div>
                            <div class="price-row">
                                <span>Subtotal:</span>
                                <span id="subtotal">0K</span>
                            </div>
                            <div class="price-row discount" id="discountRow" style="display: none;">
                                <span>Discount:</span>
                                <span id="discountAmount">-0K</span>
                            </div>
                            <div class="price-row deposit">
                                <span>Deposit Required (30%):</span>
                                <span id="depositAmount">0K</span>
                            </div>
                            <div class="price-row total">
                                <span>Total Amount:</span>
                                <span id="totalAmount">0K</span>
                            </div>
                        </div>

                        <!-- Booking Button -->
                        <button class="btn-book-cars" id="bookCarsBtn" disabled onclick="proceedToBooking()">
                            <i class="fas fa-calendar-check"></i>
                            Book Selected Cars
                        </button>

                        <!-- Continue Shopping -->
                        <button class="btn-continue-shopping" onclick="continueShopping()">
                            <i class="fas fa-arrow-left"></i>
                            Continue Shopping
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <!-- Voucher Modal -->
    <div class="modal" id="voucherModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Available Vouchers</h3>
                <button class="btn-close" onclick="closeVoucherModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="voucher-item" onclick="selectVoucher('SAVE10', 10)">
                    <div class="voucher-info">
                        <div class="voucher-code">SAVE10</div>
                        <div class="voucher-desc">10% off for orders above 2,000K</div>
                    </div>
                    <div class="voucher-discount">-10%</div>
                </div>
                <div class="voucher-item" onclick="selectVoucher('FIRST50', 50)">
                    <div class="voucher-info">
                        <div class="voucher-code">FIRST50</div>
                        <div class="voucher-desc">50K off for first-time customers</div>
                    </div>
                    <div class="voucher-discount">-50K</div>
                </div>
                <div class="voucher-item" onclick="selectVoucher('WEEKEND20', 20)">
                    <div class="voucher-info">
                        <div class="voucher-code">WEEKEND20</div>
                        <div class="voucher-desc">20% off for weekend bookings</div>
                    </div>
                    <div class="voucher-discount">-20%</div>
                </div>
            </div>
        </div>
    </div>

    <script src="scripts/booking-form/booking-form-cart.js"></script>
</body>
</html>
