<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Deposit - AutoRental</title>
        <link rel="stylesheet" href="styles/booking-form/booking-form-deposit.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="/pages/booking-form/booking-form-header.jsp"/>
        
        
        <!-- Progress Steps -->
        <div class="progress-container">
            <div class="container">
                <div class="progress-steps">
                    <div class="step completed">
                        <div class="step-number">1</div>
                        <span>Fill Form</span>
                    </div>
                    <div class="step active">
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
                <div class="deposit-container">
                    <!-- Left Side - Terms and Conditions -->
                    <div class="terms-section">
                        <div class="terms-container">
                            <h3>Deposit Terms &amp; Conditions</h3>
                            <div class="terms-content">
                                <div class="term-item">
                                    <h4><i class="fas fa-money-bill-wave"></i> Deposit Amount</h4>
                                    <p>Customer needs to deposit 30% of the total rental contract value to reserve. The deposit will be deducted from the final payment.</p>
                                </div>

                                <div class="term-item">
                                    <h4><i class="fas fa-calendar-times"></i> Cancellation Policy</h4>
                                    <p><strong>Cancel before 24h:</strong> 100% deposit refund</p>
                                    <p><strong>Cancel within 24h:</strong> 50% deposit refund</p>
                                    <p><strong>Cancel within 2h:</strong> No deposit refund</p>
                                </div>

                                <div class="term-item">
                                    <h4><i class="fas fa-id-card"></i> Necessary Documents</h4>
                                    <p>When picking up the car, customers need to bring:</p>
                                    <ul>
                                        <li>Original ID card/Citizen ID</li>
                                        <li>Driving license of B1 grade or higher</li>
                                        <li>Household registration book or temporary residence (if renting long-term)</li>
                                    </ul>
                                </div>

                                <div class="term-item">
                                    <h4><i class="fas fa-shield-alt"></i> Insurance and Responsibility</h4>
                                    <p>The car is fully insured according to regulations. Customers are responsible for traffic violations and damages due to misuse.</p>
                                </div>

                                <div class="term-item">
                                    <h4><i class="fas fa-gas-pump"></i> Fuel</h4>
                                    <p>The car is delivered with a full tank of gas. Customers need to return the car with the same fuel level or pay the fuel fee.</p>
                                </div>

                                <div class="term-item">
                                    <h4><i class="fas fa-clock"></i> Car Pick-up and Return Time</h4>
                                    <p>Flexible car pick-up and return time from 6:00 - 22:00 daily. Surcharge of 100K for pick-up/return outside of hours.</p>
                                </div>

                                <div class="term-item">
                                    <h4><i class="fas fa-tools"></i> Maintenance and Repair</h4>
                                    <p>For any technical problems during use, please contact the hotline for support. Do not repair without permission.</p>
                                </div>

                                <div class="term-item">
                                    <h4><i class="fas fa-ban"></i> Prohibited Acts</h4>
                                    <ul>
                                        <li>Using the car for illegal purposes</li>
                                        <li>Subleasing the car</li>
                                        <li>Using the car after drinking alcohol</li>
                                        <li>Carrying more than the prescribed number of people</li>
                                        <li>Smoking in the car</li>
                                    </ul>
                                </div>

                                <div class="term-item">
                                    <h4><i class="fas fa-exclamation-triangle"></i> Violation Handling</h4>
                                    <p>Customers who violate the terms will be charged a penalty according to regulations and may be refused service in the future.</p>
                                </div>
                            </div>

                            <div class="agreement-section">
                                <label class="checkbox-container">
                                    <input type="checkbox" id="agreeTerms" required>
                                    <span class="checkmark"></span>
                                    I have read and agree to all the deposit terms and conditions above
                                </label>
                            </div>
                        </div>
                    </div>

                    <!-- Right Side - Payment Information -->
                    <div class="payment-section">
                        <div class="payment-container">
                            <h3>Payment Information</h3>

                            <div class="booking-summary">
                                <h4>Order Summary</h4>
                                <div class="summary-item">
                                    <span>Car:</span>
                                    <span>KIA SEDONA PREMIUM 2017</span>
                                </div>
                                <div class="summary-item">
                                    <span>Duration:</span>
                                    <span>3 days</span>
                                </div>
                                <div class="summary-item">
                                    <span>Total Amount:</span>
                                    <span class="total-amount">3,903,000 VNĐ</span>
                                </div>
                                <div class="summary-item deposit">
                                    <span>Deposit (30%):</span>
                                    <span class="deposit-amount">1,170,900 VNĐ</span>
                                </div>
                            </div>

                            <div class="payment-methods">
                                <h4>Payment Methods</h4>
                                <div class="payment-method active" data-method="bank">
                                    <i class="fas fa-university"></i>
                                    <span>Bank Transfer</span>
                                    <i class="fas fa-check"></i>
                                </div>
                                <div class="payment-method" data-method="momo">
                                    <i class="fas fa-mobile-alt"></i>
                                    <span>MoMo Wallet</span>
                                    <i class="fas fa-check"></i>
                                </div>
                            </div>

                            <div class="payment-details" id="bankPayment">
                                <div class="qr-section">
                                    <div class="qr-code">
                                        <img src="/placeholder.svg?height=200&width=200" alt="QR Code" id="qrCode">
                                    </div>
                                    <p class="qr-instruction">Scan QR code to transfer</p>
                                </div>

                                <div class="bank-info">
                                    <div class="info-item">
                                        <label>Bank:</label>
                                        <span>Vietcombank</span>
                                    </div>
                                    <div class="info-item">
                                        <label>Account Number:</label>
                                        <span class="copyable" onclick="copyToClipboard('1234567890')">
                                            1234567890
                                            <i class="fas fa-copy"></i>
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <label>Account Holder:</label>
                                        <span>CONG TY AUTORENTAL</span>
                                    </div>
                                    <div class="info-item">
                                        <label>Amount:</label>
                                        <span class="copyable" onclick="copyToClipboard('1170900')">
                                            1,170,900 VNĐ
                                            <i class="fas fa-copy"></i>
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <label>Description:</label>
                                        <span class="copyable" onclick="copyToClipboard('AUTORENTAL DATCOC 12345')">
                                            AUTORENTAL DATCOC 12345
                                            <i class="fas fa-copy"></i>
                                        </span>
                                    </div>
                                </div>
                            </div>

                            <div class="payment-details" id="momoPayment" style="display: none;">
                                <div class="qr-section">
                                    <div class="qr-code">
                                        <img src="/placeholder.svg?height=200&width=200" alt="MoMo QR Code">
                                    </div>
                                    <p class="qr-instruction">Scan QR code using MoMo app</p>
                                </div>

                                <div class="momo-info">
                                    <div class="info-item">
                                        <label>Phone Number:</label>
                                        <span class="copyable" onclick="copyToClipboard('0123456789')">
                                            0123 456 789
                                            <i class="fas fa-copy"></i>
                                        </span>
                                    </div>
                                    <div class="info-item">
                                        <label>Name:</label>
                                        <span>AUTORENTAL COMPANY</span>
                                    </div>
                                </div>
                            </div>

                            <div class="payment-status">
                                <div class="status-indicator">
                                    <i class="fas fa-clock"></i>
                                    <span>Waiting for Payment</span>
                                </div>
                                <p class="status-text">Please complete payment within 15 minutes</p>
                                <div class="countdown" id="countdown">14:59</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="action-buttons">
                    <button type="button" class="btn btn-secondary" onclick="goBack()">
                        <i class="fas fa-arrow-left"></i>
                        Go Back
                    </button>
                    <button type="button" class="btn btn-primary" onclick="confirmPayment()" id="confirmBtn" disabled>
                        <i class="fas fa-check"></i>
                        Confirm Payment
                    </button>
                </div>
            </div>
        </main>

        <script src="scripts/booking-form/booking-form-deposit.js"></script>
    </body>
</html>
