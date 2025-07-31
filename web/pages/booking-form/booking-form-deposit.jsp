<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Car Rental Deposit - AutoRental</title>
        <link
            rel="stylesheet"
            href="<%= request.getContextPath()%>/styles/booking-form/booking-form-deposit.css"
            />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />
  </head>
  <body>
        <input type="hidden" id="bookingIdHidden" name="bookingIdHidden" value="${depositPageData.bookingId}" />
        <input type="hidden" id="subtotalHidden" name="subtotalHidden" value="${depositPageData.subtotal * 1000}" />
        
        <!-- Debug script to check bookingId value -->
        <script>
            console.log("=== DEBUG BOOKING ID ===");
            console.log("DepositPageData bookingId:", "${depositPageData.bookingId}");
            console.log("DepositPageData bookingId toString:", "${depositPageData.bookingId.toString()}");
            const hiddenInput = document.getElementById("bookingIdHidden");
            if (hiddenInput) {
                console.log("Hidden input value:", hiddenInput.value);
                console.log("Hidden input value length:", hiddenInput.value.length);
            } else {
                console.log("ERROR: Hidden input not found!");
            }
        </script>
        
    <!-- Header -->
        <jsp:include page="/pages/booking-form/booking-form-header.jsp" />




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
          <!-- Cost Details Section -->
          <div class="cost-details-section">
            <div class="cost-container">
              <h3><i class="fas fa-calculator"></i> Cost Breakdown</h3>

              <!-- Booking Information -->
              <div class="booking-info">
                <h4><i class="fas fa-car"></i> Booking Information</h4>
                <div class="info-grid">
                  <div class="info-item">
                    <span class="label">Vehicle:</span>
                                        <span class="value">
                                            ${depositPageData.carBrand} ${depositPageData.carModel} - ${depositPageData.licensePlate}
                                        </span>
                  </div>
                  <div class="info-item">
                    <span class="label">Duration:</span>
                                        <span class="value">
                                            ${depositPageData.formattedPickupDateTime} - ${depositPageData.formattedReturnDateTime}
                                        </span>
                  </div>
                  <div class="info-item">
                                        <span class="label">Rental ${depositPageData.formattedRentalType}:</span>
                                        <span class="value">${depositPageData.formattedDuration}</span>
                  </div>
                  <div class="info-item">
                    <span class="label">Customer:</span>
                                        <span class="value">${depositPageData.customerName}</span>
                  </div>
                </div>
              </div>

              <!-- Price Breakdown -->
              <div class="price-breakdown">
                <h4><i class="fas fa-money-bill-wave"></i> Detailed Pricing</h4>
                <div class="price-list">
                                    <!-- Car Rental base price (giá thuê xe cơ bản, đã tính đúng từ booking.totalAmount) -->
                  <div class="price-item">
                                        <span>Car Rental (${depositPageData.formattedDuration})</span>
                                        <span class="amount"><c:out value="${depositPageData.formattedBaseRentalPrice}" /></span>
                  </div>

                  <div class="insurance-section">
                    <div class="section-title">
                      <i class="fas fa-shield-alt"></i>
                      <span>Automatic Insurance</span>
                    </div>
                    <!-- 
                    Hiển thị danh sách bảo hiểm lấy từ booking
                    Dữ liệu bảo hiểm được tái sử dụng từ booking thay vì tính toán lại
                    depositPageData.insuranceDetails chứa danh sách bảo hiểm đã được lọc từ bảng BookingInsurance
                    -->
                                        <c:forEach var="ins" items="${depositPageData.insuranceDetails}">
                    <div class="price-item sub-item">
                                                <span>• <c:out value="${ins.insuranceName}" /></span>
                                                <span class="amount"><c:out value="${ins.formattedPremiumAmount}" /></span>
                    </div>
                                        </c:forEach>
                                        <c:if test="${empty depositPageData.insuranceDetails}">
                    <div class="price-item sub-item">
                                                <span>• No insurance selected</span>
                                                <span class="amount">0VND</span>
                    </div>
                                        </c:if>
                  </div>

                  <div class="subtotal-line">
                    <div class="price-item">
                      <span><strong>Subtotal</strong></span>
                                            <span class="amount"><strong><c:out value="${depositPageData.formattedSubtotal}" /></strong></span>
                    </div>
                  </div>

                  <!-- Voucher Discount Row -->
                  <div
                    class="price-item discount-row"
                    id="discountRow"
                    <c:choose>
                      <c:when test="${depositPageData.discountAmount > 0}">style="display: flex;"</c:when>
                      <c:otherwise>style="display: none;"</c:otherwise>
                    </c:choose>>
                    <span><i class="fas fa-ticket-alt"></i> Voucher Discount</span>
                    <span class="amount discount" id="discountAmount">-<c:out value="${depositPageData.formattedDiscountAmount}" /></span>
                  </div>
                  
                  <!-- Voucher Info Row (shows voucher details) -->
                  <c:if test="${depositPageData.appliedDiscount != null}">
                    <div class="price-item voucher-info-row" id="voucherInfoRow">
                      <span><i class="fas fa-info-circle"></i> Applied: <c:out value="${depositPageData.appliedDiscount.voucherCode}" /> - <c:out value="${depositPageData.appliedDiscount.name}" /></span>
                      <span class="amount info">Applied</span>
                    </div>
                  </c:if>

                  <div class="price-item">
                    <span>VAT Tax (10%)</span>
                                        <span class="amount" id="vatAmount"><c:out value="${depositPageData.formattedVatAmount}" /></span>
                  </div>

                  <div class="total-line">
                    <div class="price-item total">
                      <span><strong>TOTAL AMOUNT</strong></span>
                                            <span class="amount total-amount" id="finalTotal"><strong><c:out value="${depositPageData.formattedTotalAmount}" /></strong></span>
                    </div>
                  </div>

                  <div class="deposit-line">
                    <div class="price-item deposit">
                                            <span><strong>Deposit Required (Fixed)</strong></span>
                                            <span class="amount deposit-amount" id="finalDeposit"><strong><c:out value="${depositPageData.formattedDepositAmount}" /></strong></span>
                    </div>
                  </div>
                </div>
              </div>

              <!-- Insurance Benefits -->
              <div class="insurance-benefits">
                <h4><i class="fas fa-shield-check"></i> Insurance Coverage</h4>
                <div class="benefits-list">
                  <div class="benefit-item">
                    <i class="fas fa-check-circle"></i>
                    <span
                      >Civil Liability: Up to 150 million VND per person</span
                    >
                  </div>
                  <div class="benefit-item">
                    <i class="fas fa-check-circle"></i>
                    <span>Vehicle Damage: Up to 500 million VND coverage</span>
                  </div>
                  <div class="benefit-item">
                    <i class="fas fa-check-circle"></i>
                    <span
                      >Personal Accident: Up to 200 million VND per person</span
                    >
                  </div>
                </div>
              </div>

              <!-- Potential Additional Fees -->
              <div class="potential-fees">
                <h4>
                  <i class="fas fa-exclamation-triangle"></i> Potential
                  Additional Fees
                </h4>
                <div class="fees-list">
                  <div class="fee-item">
                    <i class="fas fa-clock"></i>
                    <span>Late Return: 50,000VND/hour</span>
                  </div>
                  <div class="fee-item">
                    <i class="fas fa-soap"></i>
                    <span>Excessive Cleaning: 200,000VND</span>
                  </div>
                  <div class="fee-item">
                    <i class="fas fa-gas-pump"></i>
                    <span>Fuel Shortage: Fuel price + 20,000VND</span>
                  </div>
                  <div class="fee-item">
                    <i class="fas fa-tools"></i>
                    <span>Minor Damage: 100,000VND - 500,000VND</span>
                  </div>
                  <div class="fee-item">
                    <i class="fas fa-exclamation-circle"></i>
                    <span
                      >Traffic Violations: As per authority + 100,000VND</span
                    >
                  </div>
                  <div class="fee-item">
                    <i class="fas fa-tachometer-alt"></i>
                    <span>Excess Mileage: 5,000VND/km</span>
                  </div>
                </div>
                <div class="fees-note">
                  <i class="fas fa-info-circle"></i>
                  <span
                    >These fees only apply when corresponding violations
                    occur</span
                  >
                </div>
              </div>
            </div>

            <!-- Terms Agreement Section -->
            <div class="agreement-section">
              <div class="checkbox-container">
                <input type="checkbox" id="agreeTerms" />
                <span class="checkmark"></span>
                <label for="agreeTerms">
                  I agree to the
                  <a href="#" onclick="showTermsModal()" class="terms-link"
                    >AutoRental Terms & Conditions</a
                  >
                  and commit to payment within the specified timeframe
                </label>
              </div>
            </div>
          </div>

          <!-- Payment Section -->
          <div class="payment-section">
            <div class="payment-container">
              <h3><i class="fas fa-credit-card"></i> Deposit Payment</h3>

              <!-- Voucher Section -->
              <div class="voucher-section">
                <div class="voucher-header">
                  <i class="fas fa-ticket-alt"></i>
                  <span>Voucher</span>
                </div>
                <div class="voucher-input">
                  <input
                    type="text"
                    id="voucherCode"
                    placeholder="Enter voucher code"
                    maxlength="20"
                  />
                  <button class="btn-apply-voucher" onclick="applyVoucher()">
                    Apply
                  </button>
                </div>
                <button class="btn-select-voucher" onclick="showVoucherModal()">
                  <i class="fas fa-tags"></i>
                  Select Available Voucher
                </button>
                
                <!-- Applied Voucher Info -->
                <c:if test="${depositPageData.appliedDiscount != null}">
                  <div class="applied-voucher-info" id="appliedVoucherInfo">
                    <div class="applied-voucher-header">
                      <i class="fas fa-check-circle"></i>
                      <span>Applied Voucher</span>
                    </div>
                    <div class="applied-voucher-details">
                      <div class="voucher-code-applied">
                        <strong>${depositPageData.appliedDiscount.voucherCode}</strong>
                      </div>
                      <div class="voucher-name-applied">
                        ${depositPageData.appliedDiscount.name}
                      </div>
                      <div class="voucher-description-applied">
                        ${depositPageData.appliedDiscount.description}
                      </div>
                    </div>
                  </div>
                </c:if>
              </div>

                            <!-- Order Summary động, format giống hardcode -->
              <div class="booking-summary">
                <h4>Order Summary</h4>
                <div class="summary-item">
                                    <span>${depositPageData.carBrand} ${depositPageData.carModel} (${depositPageData.formattedDuration})</span>
                                    <span class="total-amount" id="summaryTotal">
                                        <c:out value="${depositPageData.formattedBaseRentalPrice}" />
                                    </span>
                </div>
                                <c:if test="${depositPageData.discountAmount > 0}">
                                    <div class="summary-item discount" id="summaryDiscountRow">
                                        <span><i class="fas fa-ticket-alt"></i> Voucher Discount</span>
                                        <span class="discount-amount" id="summaryDiscount">
                                            -<c:out value="${depositPageData.formattedDiscountAmount}" />
                                        </span>
                                    </div>
                                </c:if>
                                <div class="summary-item">
                                    <span>Total Amount</span>
                                    <span>
                                        <c:out value="${depositPageData.formattedTotalAmount}" />
                                    </span>
                </div>
                <div class="summary-item deposit">
                  <span>Deposit Required</span>
                                    <span class="deposit-amount" id="summaryDeposit">
                                        <c:out value="${depositPageData.formattedDepositAmount}" />
                                    </span>
                </div>
              </div>

              <!-- Payment Methods -->
              <div class="payment-methods">
                <h4>Payment Methods</h4>
                <div class="payment-method active" data-method="bank">
                  <i class="fas fa-university"></i>
                  <span>Bank Transfer</span>
                  <i class="fas fa-check-circle"></i>
                </div>
                <div class="payment-method" data-method="momo">
                  <i class="fas fa-mobile-alt"></i>
                  <span>MoMo Wallet</span>
                  <i class="fas fa-check-circle"></i>
                </div>
              </div>

              <!-- QR Code Section -->
              <div
                id="qrCodeSection"
                class="payment-details"
                style="display: none"
              >
                <div class="qr-section">
                  <div class="qr-code">
                    <img
                      id="qrCodeImage"
                      src="https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=Banking_Transfer_319070VND"
                      alt="QR Code"
                    />
                  </div>
                  <p class="qr-instruction">Scan QR code to make payment</p>
                </div>

                <!-- Bank Transfer Info -->
                <div id="bankPayment" class="bank-info">
                  <div class="info-item">
                    <label>Bank:</label>
                    <span
                      class="copyable"
                      onclick="copyToClipboard('Vietcombank')"
                    >
                      Vietcombank <i class="fas fa-copy"></i>
                    </span>
                  </div>
                  <div class="info-item">
                    <label>Account Number:</label>
                    <span
                      class="copyable"
                      onclick="copyToClipboard('1234567890')"
                    >
                      1234567890 <i class="fas fa-copy"></i>
                    </span>
                  </div>
                  <div class="info-item">
                    <label>Account Holder:</label>
                    <span
                      class="copyable"
                      onclick="copyToClipboard('AUTORENTAL COMPANY LIMITED')"
                    >
                      AUTORENTAL COMPANY LIMITED <i class="fas fa-copy"></i>
                    </span>
                  </div>
                  <div class="info-item">
                    <label>Amount:</label>
                    <span
                      class="copyable"
                      id="bankAmount"
                      onclick="copyToClipboard('319070')"
                    >
                      319,070VND <i class="fas fa-copy"></i>
                    </span>
                  </div>
                  <div class="info-item">
                    <label>Transfer Note:</label>
                    <span
                      class="copyable"
                      onclick="copyToClipboard('DEPOSIT CAR BK240628001')"
                    >
                      DEPOSIT CAR BK240628001 <i class="fas fa-copy"></i>
                    </span>
                  </div>
                </div>

                <!-- Payment Status -->
                <div class="payment-status">
                  <div class="status-indicator">
                    <i class="fas fa-clock"></i>
                    <span>Waiting for payment</span>
                  </div>
                  <p class="status-text">
                    Please complete payment within the specified time
                  </p>
                  <div class="countdown" id="countdown">15:00</div>
                </div>
              </div>

              <!-- Action Buttons -->
              <div class="action-buttons">
                <button
                  type="button"
                  class="btn btn-secondary"
                  onclick="goBack()"
                >
                  <i class="fas fa-arrow-left"></i>
                  Back
                </button>
                <button
                  id="depositBtn"
                  class="btn btn-primary"
                                    onclick="generateDepositQRMain()"
                  disabled
                >
                  <i class="fas fa-lock"></i>
                  Deposit
                </button>


              </div>
            </div>
          </div>
        </div>
      </div>
    </main>

    <!-- Voucher Modal -->
    <div id="voucherModal" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <h3>Available Vouchers</h3>
          <button class="btn-close" onclick="closeVoucherModal()">
            &times;
          </button>
        </div>
        <div class="modal-body">
          <div class="voucher-item" onclick="selectVoucher('SAVE10', 10)">
            <div class="voucher-info">
              <div class="voucher-code">SAVE10</div>
              <div class="voucher-desc">Save 10% on orders over 2,000K</div>
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
              <div class="voucher-desc">
                20% off weekend bookings (min 1,000K)
              </div>
            </div>
            <div class="voucher-discount">-20%</div>
          </div>

          <div class="voucher-item" onclick="selectVoucher('STUDENT15', 15)">
            <div class="voucher-info">
              <div class="voucher-code">STUDENT15</div>
              <div class="voucher-desc">15% student discount</div>
            </div>
            <div class="voucher-discount">-15%</div>
          </div>
        </div>
      </div>
    </div>

    <!-- Terms Modal với điều khoản đầy đủ -->
    <div id="termsModal" class="modal">
      <div class="modal-content">
        <div class="modal-header">
          <h3>AutoRental Terms & Conditions</h3>
          <span class="close" onclick="closeTermsModal()">&times;</span>
        </div>
        <div class="modal-body">
          <div class="terms-full-content">
            <h4>1. About AutoRental Company</h4>
                        <p><strong>AutoRental Company Limited</strong> - Business License No. 0123456789</p>
            <p>Address: 123 ABC Street, District 1, Ho Chi Minh City</p>
            <p>Phone: (028) 1234 5678 | Email: info@autorental.vn</p>
            <p>Website: www.autorental.vn</p>
                        <p>The company is committed to operating in accordance with Vietnamese laws regarding car rental services.</p>

            <h4>2. Comprehensive Insurance Policy Explanation</h4>
            <div class="insurance-details">
                            <h5>2.1 Mandatory Insurance (Automatically Included in All Rentals)</h5>

              <div class="insurance-item">
                                <strong>Civil Liability Insurance (TNDS) - Required by Vietnamese Law:</strong>
                <ul>
                                    <li><strong>What it covers:</strong> Damages and injuries to third parties (other people, vehicles, or property) caused by accidents where you are at fault</li>
                                    <li><strong>Coverage amount:</strong> Up to 150 million VND per person for bodily injury, 100 million VND per incident for property damage</li>
                                    <li><strong>Cost calculation:</strong> 
                    <ul>
                                            <li>Vehicles under 6 seats: 437,000 VND/year = 1,197 VND/day</li>
                                            <li>Vehicles 6-11 seats: 794,000 VND/year = 2,175 VND/day</li>
                                            <li>Vehicles 12+ seats: 1,270,000 VND/year = 3,479 VND/day</li>
                    </ul>
                  </li>
                                    <li><strong>What it does NOT cover:</strong> Damage to the rental vehicle itself, injuries to the driver or passengers of the rental vehicle</li>
                                    <li><strong>Important note:</strong> This insurance is mandatory by Vietnamese Traffic Law and cannot be waived</li>
                </ul>
              </div>

              <div class="insurance-item">
                                <strong>Vehicle Material Insurance - Protects the Rental Car:</strong>
                <ul>
                                    <li><strong>What it covers:</strong> Physical damage to the rental vehicle from collision, theft, fire, vandalism, or natural disasters</li>
                                    <li><strong>Coverage amount:</strong> Up to 500 million VND per incident</li>
                                    <li><strong>Cost calculation:</strong> 1.5% of vehicle value per year (approximately 61,644 VND for 3-day rental of a mid-range vehicle)</li>
                                    <li><strong>Deductible:</strong> Customer pays first 2 million VND of any claim, insurance covers the rest</li>
                                    <li><strong>What it does NOT cover:</strong> 
                    <ul>
                      <li>Tire damage from normal wear or road hazards</li>
                      <li>Windshield chips or cracks under 15cm</li>
                                            <li>Interior damage from misuse (smoking, food spills, etc.)</li>
                                            <li>Damage from driving under influence or reckless driving</li>
                    </ul>
                  </li>
                </ul>
              </div>

              <div class="insurance-item">
                                <strong>Personal Accident Insurance - Protects People in the Vehicle:</strong>
                <ul>
                                    <li><strong>What it covers:</strong> Medical expenses, disability compensation, and death benefits for driver and all passengers</li>
                                    <li><strong>Coverage amount:</strong> Up to 200 million VND per person</li>
                                    <li><strong>Cost:</strong> 200,000 VND/year = 548 VND/day per vehicle (covers all occupants)</li>
                                    <li><strong>Benefits include:</strong>
                    <ul>
                      <li>Emergency medical treatment costs</li>
                      <li>Hospital expenses up to coverage limit</li>
                      <li>Disability compensation based on severity</li>
                      <li>Death benefits for beneficiaries</li>
                      <li>24/7 emergency assistance hotline</li>
                    </ul>
                  </li>
                                    <li><strong>What it does NOT cover:</strong> Pre-existing medical conditions, injuries from illegal activities, self-inflicted injuries</li>
                </ul>
              </div>

              <h5>2.2 How Insurance Claims Work</h5>
              <ul>
                                <li><strong>Immediate notification:</strong> Contact AutoRental within 24 hours of any incident at (028) 1234 5678</li>
                                <li><strong>Police report required for:</strong> Any accident involving injury, damage over 5 million VND, or theft</li>
                                <li><strong>Documentation needed:</strong> Photos of damage, police report (if applicable), driver's license, rental agreement</li>
                                <li><strong>Assessment timeline:</strong> Insurance company will assess damage within 3-5 business days</li>
                                <li><strong>Payment process:</strong> Customer pays deductible first, insurance covers remaining approved amount</li>
                                <li><strong>Claim processing:</strong> 15-30 days after complete documentation is submitted</li>
              </ul>

              <h5>2.3 Insurance Exclusions (What is NOT Covered)</h5>
              <ul>
                                <li><strong>Driver-related exclusions:</strong>
                  <ul>
                                        <li>Driving under influence of alcohol (over 0.05% BAC) or drugs</li>
                                        <li>Driving without valid license or with expired license</li>
                    <li>Allowing unlicensed person to drive</li>
                    <li>Racing, competitive driving, or stunt driving</li>
                  </ul>
                </li>
                                <li><strong>Usage-related exclusions:</strong>
                  <ul>
                                        <li>Using vehicle for illegal purposes (drug transport, etc.)</li>
                                        <li>Commercial use (taxi, delivery) without proper permits</li>
                    <li>Subletting vehicle to third parties</li>
                    <li>Off-road driving in non-designated areas</li>
                  </ul>
                </li>
                                <li><strong>Circumstantial exclusions:</strong>
                  <ul>
                                        <li>War, terrorism, civil unrest, or government confiscation</li>
                                        <li>Natural disasters beyond normal coverage (earthquake, tsunami)</li>
                    <li>Intentional damage or negligence</li>
                    <li>Mechanical breakdown due to normal wear and tear</li>
                  </ul>
                </li>
              </ul>

              <h5>2.4 Customer Responsibilities for Insurance Validity</h5>
              <ul>
                                <li><strong>Valid documentation:</strong> Must have valid driver's license (B1 grade or higher) for vehicle category</li>
                                <li><strong>Age requirements:</strong> Minimum 21 years old with at least 2 years driving experience</li>
                                <li><strong>Vehicle condition:</strong> Report any pre-existing damage during pickup inspection</li>
                                <li><strong>Immediate reporting:</strong> Contact AutoRental immediately after any incident, no matter how minor</li>
                                <li><strong>Cooperation:</strong> Provide truthful information and cooperate with insurance investigation</li>
                                <li><strong>Vehicle security:</strong> Lock vehicle when unattended, don't leave valuables visible</li>
              </ul>
            </div>

            <h4>3. Deposit Terms and Conditions</h4>
                        <div>
                            <c:out value="${depositPageData.termsFullContent}" escapeXml="false" />
                        </div>

            <h4>4. Payment Terms and Procedures</h4>
            <ul>
                            <li><strong>Deposit payment:</strong> Must be completed within 15 minutes of agreement</li>
                            <li><strong>Full contract payment:</strong> Within 6 hours after contract signing</li>
                            <li><strong>Late payment consequences:</strong> Automatic contract cancellation, deposit forfeiture</li>
                            <li><strong>No interest charged:</strong> On deposit amount during rental period</li>
                            <li><strong>VAT inclusion:</strong> All payments include 10% VAT as per Vietnamese tax law</li>
                            <li><strong>Refund processing:</strong> 3-5 business days for deposit refunds after vehicle return</li>
            </ul>

            <h4>5. Vehicle Usage Terms and Restrictions</h4>
            <ul>
                            <li><strong>Fuel policy:</strong> Vehicle delivered with full tank, must be returned with same level</li>
                            <li><strong>Mileage limits:</strong> 200km per day included, excess charged at 5,000 VND/km</li>
                            <li><strong>Operating hours:</strong> Pickup/return between 6:00 AM - 10:00 PM daily</li>
                            <li><strong>After-hours service:</strong> Available with 100,000 VND additional fee</li>
                            <li><strong>Passenger limits:</strong> Maximum passengers as per vehicle specification</li>
                            <li><strong>Smoking policy:</strong> Strictly prohibited (300,000 VND cleaning fee)</li>
                            <li><strong>Pet policy:</strong> Allowed with prior approval and additional cleaning deposit</li>
            </ul>

            <h4>6. Additional Fees Schedule</h4>
            <ul>
                            <li><strong>Late return:</strong> 50,000 VND per hour after 1-hour grace period</li>
                            <li><strong>Excessive cleaning:</strong> 200,000 VND for heavily soiled vehicle</li>
                            <li><strong>Odor removal:</strong> 300,000 VND for smoke or strong odors</li>
                            <li><strong>Fuel shortage:</strong> Actual fuel price + 20,000 VND handling fee</li>
                            <li><strong>Minor damage:</strong> 100,000 - 500,000 VND (scratches, small dents)</li>
                            <li><strong>Major damage:</strong> According to actual repair assessment</li>
                            <li><strong>Traffic violations:</strong> Full fine amount + 100,000 VND processing fee</li>
              <li><strong>Lost keys:</strong> 500,000 VND replacement cost</li>
                            <li><strong>Towing service:</strong> Actual cost + 200,000 VND service fee</li>
                            <li><strong>Administrative fees:</strong> 50,000 VND for document processing</li>
            </ul>

            <h4>7. Customer Rights and Responsibilities</h4>
            <p><strong>Customer Rights:</strong></p>
            <ul>
              <li>Receive vehicle in clean, safe, and roadworthy condition</li>
              <li>24/7 roadside assistance during rental period</li>
              <li>Clear explanation of all charges and fees</li>
              <li>Fair treatment in case of disputes</li>
              <li>Privacy protection of personal information</li>
            </ul>

            <p><strong>Customer Responsibilities:</strong></p>
            <ul>
              <li>Provide accurate and truthful information</li>
                            <li>Have full civil legal capacity according to Vietnamese law</li>
              <li>Maintain valid driver's license throughout rental period</li>
              <li>Report accidents or damage immediately</li>
              <li>Return vehicle on time and in original condition</li>
              <li>Pay all applicable fees and charges promptly</li>
              <li>Comply with all traffic laws and regulations</li>
            </ul>

            <h4>8. Emergency Procedures and Contact Information</h4>
            <ul>
                            <li><strong>Traffic accident:</strong> Call 113 (Police), then AutoRental: (028) 1234 5678</li>
                            <li><strong>Vehicle breakdown:</strong> AutoRental 24/7 hotline: (028) 1234 5678</li>
                            <li><strong>Medical emergency:</strong> Call 115 (Ambulance), then notify AutoRental</li>
                            <li><strong>Vehicle theft:</strong> Report to police immediately, then AutoRental within 2 hours</li>
                            <li><strong>Fire emergency:</strong> Call 114 (Fire Department)</li>
                            <li><strong>Customer service:</strong> Available 24/7 for non-emergency assistance</li>
            </ul>

            <h4>9. Legal Commitments and Dispute Resolution</h4>
            <p><strong>AutoRental Company commits to:</strong></p>
            <ul>
              <li>Operating according to valid Vietnamese business license</li>
                            <li>Maintaining comprehensive insurance coverage for all vehicles</li>
              <li>Providing 24/7 roadside assistance and customer support</li>
                            <li>Protecting customer information per Vietnamese Cybersecurity Law</li>
              <li>Resolving disputes fairly according to Vietnamese law</li>
              <li>Maintaining vehicles to safety and quality standards</li>
            </ul>

            <p><strong>Dispute Resolution Process:</strong></p>
            <ul>
                            <li>Step 1: Direct negotiation between customer and AutoRental</li>
                            <li>Step 2: Mediation through Ho Chi Minh City Consumer Protection Agency</li>
                            <li>Step 3: Arbitration or court proceedings under Vietnamese law</li>
              <li>Governing law: Socialist Republic of Vietnam</li>
              <li>Jurisdiction: Courts of Ho Chi Minh City</li>
            </ul>

            <h4>10. Terms Effectiveness and Modifications</h4>
            <p><strong>These terms become effective when:</strong></p>
            <ul>
              <li>Customer checks "I agree to terms and conditions"</li>
              <li>Deposit payment is completed successfully</li>
                            <li>Agreement is stored in system with timestamp and IP address</li>
              <li>Digital signature is applied to the rental contract</li>
            </ul>

            <p><strong>Modifications and Updates:</strong></p>
            <ul>
                            <li>AutoRental reserves right to update terms with 30 days notice</li>
              <li>Customers will be notified of changes via email</li>
                            <li>Continued use of service constitutes acceptance of updated terms</li>
              <li>Major changes require explicit customer consent</li>
            </ul>

                        <p><strong>Legal Note:</strong> Agreement to these terms has legal value equivalent to physical signature according to Vietnamese Electronic Transaction Law 2023. This contract is governed by Vietnamese law and any disputes will be resolved in Vietnamese courts.</p>
          </div>
        </div>
      </div>
    </div>

    <script>
      // Voucher functionality
      let appliedVoucher = null;
      // Khai báo originalSubtotal với giá trị mặc định
      let originalSubtotal = 0;
      
      // Đảm bảo DOM đã sẵn sàng trước khi lấy giá trị
      document.addEventListener("DOMContentLoaded", function() {
        // Lấy giá trị subtotal từ hidden input
        originalSubtotal = parseFloat(document.getElementById("subtotalHidden").value || 0);
        console.log("Loaded subtotal from backend:", originalSubtotal);
        
        // Kiểm tra xem có voucher đã được áp dụng chưa
        checkAppliedVoucher();
      });
      
      function checkAppliedVoucher() {
        // Kiểm tra xem có discount amount > 0 không (có voucher đã áp dụng)
        const discountRow = document.getElementById("discountRow");
        const discountAmount = document.getElementById("discountAmount");
        
        if (discountRow && discountRow.style.display !== "none" && discountAmount) {
          // Có voucher đã áp dụng
          const voucherCode = "${depositPageData.appliedDiscount.voucherCode}";
          const voucherName = "${depositPageData.appliedDiscount.name}";
          
          if (voucherCode && voucherCode.trim() !== "") {
            appliedVoucher = {
              code: voucherCode,
              name: voucherName
            };
            
            // Cập nhật UI để hiển thị voucher đã áp dụng
            const voucherInput = document.getElementById("voucherCode");
            const applyBtn = document.querySelector('.btn-apply-voucher');
            
            voucherInput.value = voucherCode;
            voucherInput.disabled = true;
            applyBtn.textContent = 'Remove';
            applyBtn.onclick = removeVoucher;
            
            console.log("Voucher already applied:", voucherCode);
          }
        }
      }

      function applyVoucher() {
        const voucherCode = document.getElementById("voucherCode").value.trim();
        const bookingId = document.getElementById("bookingIdHidden").value;
        
        if (!voucherCode) {
          showToast("Vui lòng nhập mã voucher", "error");
          return;
        }
        
        if (!bookingId || bookingId === "TEMP_BOOKING_ID" || bookingId.trim() === "") {
          showToast("Không tìm thấy bookingId. Vui lòng tải lại trang.", "error");
          return;
        }

        // Show loading state
        const applyBtn = document.querySelector('.btn-apply-voucher');
        const originalText = applyBtn.textContent;
        applyBtn.textContent = 'Applying...';
        applyBtn.disabled = true;

        // Send AJAX request to backend
        fetch('<%=request.getContextPath()%>/customer/deposit', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: new URLSearchParams({
            'action': 'applyVoucher',
            'bookingId': bookingId,
            'voucherCode': voucherCode
          })
        })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            // Update UI with new pricing data
            updatePriceWithBackendData(data);
            showToast(data.message || "Voucher applied successfully!", "success");
            
            // Store applied voucher info
            appliedVoucher = {
              code: data.discountCode,
              name: data.discountName
            };
            
            // Update voucher input to show applied voucher
            document.getElementById("voucherCode").value = data.discountCode;
            document.getElementById("voucherCode").disabled = true;
            
            // Change apply button to remove button
            applyBtn.textContent = 'Remove';
            applyBtn.onclick = removeVoucher;
            
          } else {
            showToast(data.message || "Failed to apply voucher", "error");
          }
        })
        .catch(error => {
          console.error('Error applying voucher:', error);
          showToast("Có lỗi xảy ra khi áp dụng voucher", "error");
        })
        .finally(() => {
          // Reset button state if not successful
          if (!appliedVoucher) {
            applyBtn.textContent = originalText;
            applyBtn.disabled = false;
          }
        });
      }

      function removeVoucher() {
        const bookingId = document.getElementById("bookingIdHidden").value;
        
        // Send request to remove voucher (you may need to implement this endpoint)
        fetch('<%=request.getContextPath()%>/customer/deposit', {
          method: 'POST',
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: new URLSearchParams({
            'action': 'removeVoucher',
            'bookingId': bookingId
          })
        })
        .then(response => response.json())
        .then(data => {
          if (data.success) {
            // Reset UI to original state
            resetVoucherUI();
            updatePriceWithBackendData(data);
            showToast("Voucher removed successfully!", "success");
          } else {
            showToast(data.message || "Failed to remove voucher", "error");
          }
        })
        .catch(error => {
          console.error('Error removing voucher:', error);
          showToast("Có lỗi xảy ra khi xóa voucher", "error");
        });
      }

      function resetVoucherUI() {
        appliedVoucher = null;
        const voucherInput = document.getElementById("voucherCode");
        const applyBtn = document.querySelector('.btn-apply-voucher');
        
        voucherInput.value = '';
        voucherInput.disabled = false;
        applyBtn.textContent = 'Apply';
        applyBtn.onclick = applyVoucher;
        applyBtn.disabled = false;
        
        // Hide applied voucher info
        const appliedVoucherInfo = document.getElementById("appliedVoucherInfo");
        if (appliedVoucherInfo) {
          appliedVoucherInfo.remove();
        }
        
        // Hide voucher info row
        const voucherInfoRow = document.getElementById("voucherInfoRow");
        if (voucherInfoRow) {
          voucherInfoRow.remove();
        }
      }

      function updatePriceWithBackendData(data) {
        // Update price breakdown with backend data
        const discountAmount = data.discountAmount || 0;
        
        // Update voucher discount row
        const discountRow = document.getElementById("discountRow");
        const discountAmountElement = document.getElementById("discountAmount");
        
        if (discountAmount > 0) {
          discountRow.style.display = "flex";
          discountAmountElement.textContent = `-${discountAmount.toLocaleString()}VND`;
          console.log("Voucher discount applied: -" + discountAmount.toLocaleString() + "VND");
        } else {
          discountRow.style.display = "none";
          discountAmountElement.textContent = "-0VND";
          console.log("No voucher discount");
        }

        // Update all price elements with backend data
        document.getElementById("vatAmount").textContent = `${data.vatAmount.toLocaleString()}VND`;
        document.getElementById("finalTotal").innerHTML = `<strong>${data.totalAmount.toLocaleString()}VND</strong>`;
        document.getElementById("finalDeposit").innerHTML = `<strong>${data.depositAmount.toLocaleString()}VND</strong>`;

        // Update order summary
        document.getElementById("summaryTotal").textContent = `${data.baseAmount.toLocaleString()}VND`;
        
        if (discountAmount > 0) {
          document.getElementById("summaryDiscountRow").style.display = "flex";
          document.getElementById("summaryDiscount").textContent = `-${discountAmount.toLocaleString()}VND`;
          console.log("Voucher discount in summary: -" + discountAmount.toLocaleString() + "VND");
        } else {
          document.getElementById("summaryDiscountRow").style.display = "none";
          console.log("No voucher discount in summary");
        }
        
        document.getElementById("summaryDeposit").textContent = `${data.depositAmount.toLocaleString()}VND`;

        // Update payment amounts
        document.getElementById("bankAmount").innerHTML = `${data.depositAmount.toLocaleString()}VND <i class="fas fa-copy"></i>`;
        
        // Update applied voucher info display
        updateAppliedVoucherDisplay(data.discountCode, data.discountName);
        
        // Update voucher info row in detailed pricing
        updateVoucherInfoRow(data.discountCode, data.discountName);
      }
      
      function updateAppliedVoucherDisplay(discountCode, discountName) {
        const appliedVoucherInfo = document.getElementById("appliedVoucherInfo");
        
        if (discountCode && discountCode.trim() !== "") {
          // Show applied voucher info
          if (!appliedVoucherInfo) {
            // Create applied voucher info element if it doesn't exist
            const voucherSection = document.querySelector('.voucher-section');
            const newAppliedVoucherInfo = document.createElement('div');
            newAppliedVoucherInfo.className = 'applied-voucher-info';
            newAppliedVoucherInfo.id = 'appliedVoucherInfo';
            newAppliedVoucherInfo.innerHTML = `
              <div class="applied-voucher-header">
                <i class="fas fa-check-circle"></i>
                <span>Applied Voucher</span>
              </div>
              <div class="applied-voucher-details">
                <div class="voucher-code-applied">
                  <strong>${discountCode}</strong>
                </div>
                <div class="voucher-name-applied">
                  ${discountName || ''}
                </div>
              </div>
            `;
            voucherSection.appendChild(newAppliedVoucherInfo);
          } else {
            // Update existing applied voucher info
            const voucherCodeElement = appliedVoucherInfo.querySelector('.voucher-code-applied strong');
            const voucherNameElement = appliedVoucherInfo.querySelector('.voucher-name-applied');
            
            if (voucherCodeElement) voucherCodeElement.textContent = discountCode;
            if (voucherNameElement) voucherNameElement.textContent = discountName || '';
          }
        } else {
          // Hide applied voucher info if no voucher
          if (appliedVoucherInfo) {
            appliedVoucherInfo.remove();
          }
        }
      }
      
      function updateVoucherInfoRow(discountCode, discountName) {
        const voucherInfoRow = document.getElementById("voucherInfoRow");
        
        if (discountCode && discountCode.trim() !== "") {
          // Show voucher info row
          if (!voucherInfoRow) {
            // Create voucher info row if it doesn't exist
            const discountRow = document.getElementById("discountRow");
            const newVoucherInfoRow = document.createElement('div');
            newVoucherInfoRow.className = 'price-item voucher-info-row';
            newVoucherInfoRow.id = 'voucherInfoRow';
            newVoucherInfoRow.innerHTML = `
              <span><i class="fas fa-info-circle"></i> Applied: ${discountCode} - ${discountName || ''}</span>
              <span class="amount info">Applied</span>
            `;
            discountRow.parentNode.insertBefore(newVoucherInfoRow, discountRow.nextSibling);
          } else {
            // Update existing voucher info row
            const voucherInfoSpan = voucherInfoRow.querySelector('span:first-child');
            if (voucherInfoSpan) {
              voucherInfoSpan.innerHTML = `<i class="fas fa-info-circle"></i> Applied: ${discountCode} - ${discountName || ''}`;
            }
          }
        } else {
          // Hide voucher info row if no voucher
          if (voucherInfoRow) {
            voucherInfoRow.remove();
          }
        }
      }

      // Legacy function for backward compatibility (if needed)
      function updatePriceWithVoucher() {
        // This function is now replaced by updatePriceWithBackendData
        // Keeping for any legacy references
        console.log("updatePriceWithVoucher called - use updatePriceWithBackendData instead");
      }

      function showVoucherModal() {
        document.getElementById("voucherModal").classList.add("show");
      }

      function closeVoucherModal() {
        document.getElementById("voucherModal").classList.remove("show");
      }

      function selectVoucher(code, value) {
        document.getElementById("voucherCode").value = code;
        closeVoucherModal();
        applyVoucher();
      }

      function showTermsModal() {
        document.getElementById("termsModal").classList.add("show");
      }

      function closeTermsModal() {
        document.getElementById("termsModal").classList.remove("show");
      }

      // Checkbox functionality
      document.addEventListener("DOMContentLoaded", () => {
        const agreeTermsCheckbox = document.getElementById("agreeTerms");
        const depositBtn = document.getElementById("depositBtn");

        agreeTermsCheckbox.addEventListener("change", function () {
          if (this.checked) {
            // Chỉ bật nút Deposit, KHÔNG hiện QR ngay lập tức
            depositBtn.disabled = false;
            depositBtn.innerHTML = '<i class="fas fa-credit-card"></i> Deposit';
          } else {
            // Ẩn QR section nếu có và disable nút
            const qrSection = document.getElementById("qrCodeSection");
            qrSection.style.display = "none";
            depositBtn.disabled = true;
            depositBtn.innerHTML = '<i class="fas fa-lock"></i> Deposit';
          }
        });
      });

      function showToast(message, type = "info") {
        const toast = document.createElement("div");
        toast.className = `toast toast-${type}`;
        toast.textContent = message;

        const styles = {
          position: "fixed",
          top: "20px",
          right: "20px",
          padding: "1rem 1.5rem",
          borderRadius: "6px",
          color: "white",
          fontWeight: "500",
          zIndex: "1001",
          animation: "slideIn 0.3s ease",
        };

        const colors = {
          success: "#10b981",
          error: "#ef4444",
          info: "#3b82f6",
        };

        Object.assign(toast.style, styles);
        toast.style.background = colors[type] || colors.info;

        document.body.appendChild(toast);

        setTimeout(() => {
          toast.style.animation = "slideOut 0.3s ease";
          setTimeout(() => {
            document.body.removeChild(toast);
          }, 300);
        }, 3000);
      }

      function copyToClipboard(text) {
        navigator.clipboard.writeText(text).then(() => {
          showToast("Copied: " + text, "success");
        });
      }

      function goBack() {
        window.history.back();
      }

            // Hàm tạo thanh toán PayOS (đơn giản như mẫu)
            async function generateDepositQRMain() {
                console.log("=== generateDepositQRMain called ===");
                
                // Lấy bookingId từ input hidden
                const bookingIdInput = document.getElementById("bookingIdHidden");
                const bookingId = bookingIdInput ? bookingIdInput.value : null;
                
                console.log("BookingId:", bookingId);
                
                if (!bookingId || bookingId === "TEMP_BOOKING_ID" || bookingId.trim() === "") {
                    showToast("Không tìm thấy bookingId. Vui lòng tải lại trang hoặc liên hệ hỗ trợ.", "error");
                    return;
                }

                try {
                    showToast("Đang tạo mã thanh toán...", "info");

                    // Tạo form để POST đến PaymentServlet (giống mẫu PayOS)
                    const form = document.createElement('form');
                    form.method = 'POST';
                    form.action = '<%=request.getContextPath()%>/api/payment/create?bookingId=' + encodeURIComponent(bookingId) + '&fixedDeposit=true';
                    
                    document.body.appendChild(form);
                    console.log("Submitting form to:", form.action);
                    form.submit();

                } catch (error) {
                    console.error("Error in generateDepositQRMain:", error);
                    showToast("Có lỗi xảy ra khi tạo mã thanh toán. Vui lòng thử lại!", "error");
                }
            }

      // Hàm đếm ngược thời gian thanh toán
      function startPaymentCountdown() {
        let timeLeft = 15 * 60; // 15 phút = 900 giây
        const countdownElement = document.getElementById("countdown");

        const timer = setInterval(() => {
          const minutes = Math.floor(timeLeft / 60);
          const seconds = timeLeft % 60;
          countdownElement.textContent = `${minutes
            .toString()
            .padStart(2, "0")}:${seconds.toString().padStart(2, "0")}`;

          if (timeLeft <= 0) {
            clearInterval(timer);
            countdownElement.textContent = "Time expired";
            showToast(
              "Payment time expired. Please generate new QR code.",
              "error"
            );

            // Reset về trạng thái ban đầu
            const qrSection = document.getElementById("qrCodeSection");
            qrSection.style.display = "none";
            const depositBtn = document.getElementById("depositBtn");
            depositBtn.disabled = false;
            depositBtn.innerHTML = '<i class="fas fa-credit-card"></i> Deposit';
          }

          timeLeft--;
        }, 1000);
      }

      // Close modals when clicking outside
      window.onclick = function (event) {
        const voucherModal = document.getElementById("voucherModal");
        const termsModal = document.getElementById("termsModal");

        if (event.target == voucherModal) {
          closeVoucherModal();
        }
        if (event.target == termsModal) {
          closeTermsModal();
        }
      };
    </script>
  </body>
</html>
