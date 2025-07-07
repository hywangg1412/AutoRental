<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sign Contract - AutoRental</title>
    <link
      rel="stylesheet"
      href="styles/booking-form/booking-form-contract.css"
    />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />
  </head>
  <body>
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
          <div class="step completed">
            <div class="step-number">2</div>
            <span>Deposit</span>
          </div>
          <div class="step active">
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
        <div class="contract-container">
          <!-- Left Side - Contract Terms -->
          <div class="contract-section">
            <div class="contract-header">
              <h3><i class="fas fa-file-contract"></i> Car Rental Agreement</h3>
              <div class="contract-info">
                <span>Contract No: AR-2024-001234</span>
                <span>Date: ${currentDate}</span>
              </div>
            </div>

            <div class="contract-content">
              <div class="contract-parties">
                <h4>PARTIES TO THE AGREEMENT</h4>
                <div class="party-info">
                  <div class="party">
                    <strong>LESSOR (AutoRental Company):</strong>
                    <p>
                      AutoRental Joint Stock Company<br />
                      Address: 123 Nguyen Van Linh, Da Nang City<br />
                      Tax Code: 0123456789<br />
                      Phone: +84 236 123 4567
                    </p>
                  </div>
                  <div class="party">
                    <strong>LESSEE (Customer):</strong>
                    <p>
                      Name: <span class="customer-name">John Doe</span><br />
                      ID Number: <span class="customer-id">123456789</span
                      ><br />
                      Phone: <span class="customer-phone">+84831837721</span
                      ><br />
                      Address:
                      <span class="customer-address">456 Le Duan, Da Nang</span>
                    </p>
                  </div>
                </div>
              </div>

              <div class="rental-details">
                <h4>RENTAL DETAILS</h4>
                <div class="rental-info">
                  <div class="info-row">
                    <span>Vehicle(s):</span>
                    <span
                      >KIA SEDONA PREMIUM 2017, Toyota Vios 2020, Honda City
                      2019</span
                    >
                  </div>
                  <div class="info-row">
                    <span>Rental Period:</span>
                    <span>3 days (Dec 15, 2024 - Dec 18, 2024)</span>
                  </div>
                  <div class="info-row">
                    <span>Pickup Location:</span>
                    <span>AutoRental Office - 123 Nguyen Van Linh</span>
                  </div>
                  <div class="info-row">
                    <span>Total Amount:</span>
                    <span class="amount">3,401,000 VND</span>
                  </div>
                  <div class="info-row">
                    <span>Deposit Paid:</span>
                    <span class="amount">1,020,300 VND</span>
                  </div>
                  <div class="info-row">
                    <span>Remaining Balance:</span>
                    <span class="amount highlight">2,380,700 VND</span>
                  </div>
                </div>
              </div>

              <div class="contract-terms">
                <h4>TERMS AND CONDITIONS</h4>
                <div class="terms-list">
                  <div class="term-item">
                    <h5>
                      <i class="fas fa-shield-alt"></i> Vehicle Condition &
                      Responsibility
                    </h5>
                    <p>
                      The LESSEE acknowledges receiving the vehicle(s) in good
                      condition and agrees to return them in the same condition,
                      normal wear excepted. Any damage will be charged to the
                      LESSEE.
                    </p>
                  </div>

                  <div class="term-item">
                    <h5><i class="fas fa-id-card"></i> Driver Requirements</h5>
                    <p>
                      The LESSEE must possess a valid driver's license (Class B1
                      or higher) and be at least 21 years old. Only authorized
                      drivers listed in this agreement may operate the
                      vehicle(s).
                    </p>
                  </div>

                  <div class="term-item">
                    <h5><i class="fas fa-gas-pump"></i> Fuel Policy</h5>
                    <p>
                      Vehicle(s) will be delivered with a full tank of fuel.
                      LESSEE must return vehicle(s) with the same fuel level or
                      pay refueling charges at market rate plus 20% service fee.
                    </p>
                  </div>

                  <div class="term-item">
                    <h5><i class="fas fa-ban"></i> Prohibited Uses</h5>
                    <p>
                      Vehicle(s) may not be used for: illegal activities,
                      racing, towing, subleasing, or carrying hazardous
                      materials. Smoking is strictly prohibited in all vehicles.
                    </p>
                  </div>

                  <div class="term-item">
                    <h5>
                      <i class="fas fa-exclamation-triangle"></i> Accidents &
                      Insurance
                    </h5>
                    <p>
                      In case of accident, LESSEE must immediately notify
                      AutoRental and local authorities. Vehicle(s) are covered
                      by mandatory insurance. LESSEE is responsible for
                      deductibles and damages not covered by insurance.
                    </p>
                  </div>

                  <div class="term-item">
                    <h5><i class="fas fa-calendar-times"></i> Late Return</h5>
                    <p>
                      Late return will incur additional charges: 50,000 VND per
                      hour for the first 3 hours, then full daily rate for each
                      additional day or part thereof.
                    </p>
                  </div>

                  <div class="term-item">
                    <h5><i class="fas fa-gavel"></i> Termination</h5>
                    <p>
                      AutoRental reserves the right to terminate this agreement
                      and repossess the vehicle(s) if LESSEE violates any terms.
                      No refund will be provided for early termination due to
                      LESSEE's breach.
                    </p>
                  </div>
                </div>
              </div>

              <div class="signature-section">
                <h4>DIGITAL SIGNATURE</h4>
                <p>
                  By checking the agreement box below, you acknowledge that you
                  have read, understood, and agree to be bound by all terms and
                  conditions of this rental agreement. Your digital signature
                  has the same legal effect as a handwritten signature.
                </p>

                <div class="agreement-checkbox">
                  <label class="checkbox-container">
                    <input type="checkbox" id="agreeContract" required />
                    <span class="checkmark"></span>
                    <span class="agreement-text">
                      I have read and understood all terms and conditions of
                      this rental agreement. I agree to be legally bound by this
                      contract and confirm my digital signature.
                    </span>
                  </label>
                </div>
              </div>
            </div>
          </div>

          <!-- Right Side - Payment Options -->
          <div class="payment-section">
            <div class="payment-container">
              <h3><i class="fas fa-credit-card"></i> Payment Options</h3>

              <div class="payment-summary">
                <h4>Payment Summary</h4>
                <div class="summary-item">
                  <span>Total Rental Amount:</span>
                  <span>3,401,000 VND</span>
                </div>
                <div class="summary-item">
                  <span>Deposit Paid:</span>
                  <span class="paid">-1,020,300 VND</span>
                </div>
                <div class="summary-item total">
                  <span>Remaining Balance:</span>
                  <span>2,380,700 VND</span>
                </div>
              </div>

              <div class="payment-options">
                <h4>Choose Payment Method</h4>

                <div class="payment-option" data-option="full">
                  <div class="option-header">
                    <input
                      type="radio"
                      name="paymentOption"
                      id="payFull"
                      value="full"
                    />
                    <label for="payFull">
                      <div class="option-info">
                        <h5>
                          <i class="fas fa-money-bill-wave"></i> Pay Full Amount
                          Now
                        </h5>
                        <p>
                          Pay the remaining balance immediately and complete
                          your booking
                        </p>
                      </div>
                      <div class="option-amount">
                        <span class="amount">2,380,700 VND</span>
                        <span class="badge recommended">Recommended</span>
                      </div>
                    </label>
                  </div>
                  <div class="option-benefits">
                    <div class="benefit">
                      <i class="fas fa-check"></i> Immediate booking
                      confirmation
                    </div>
                    <div class="benefit">
                      <i class="fas fa-check"></i> No additional payment
                      required
                    </div>
                    <div class="benefit">
                      <i class="fas fa-check"></i> 5% discount applied
                    </div>
                  </div>
                </div>

                <div class="payment-option" data-option="advance">
                  <div class="option-header">
                    <input
                      type="radio"
                      name="paymentOption"
                      id="payAdvance"
                      value="advance"
                    />
                    <label for="payAdvance">
                      <div class="option-info">
                        <h5>
                          <i class="fas fa-calendar-check"></i> Pay 1 Day Before
                          Pickup
                        </h5>
                        <p>
                          Complete payment 24 hours before your rental start
                          date
                        </p>
                      </div>
                      <div class="option-amount">
                        <span class="amount">2,380,700 VND</span>
                        <span class="due-date">Due: Dec 14, 2024</span>
                      </div>
                    </label>
                  </div>
                  <div class="option-benefits">
                    <div class="benefit">
                      <i class="fas fa-check"></i> Flexible payment timing
                    </div>
                    <div class="benefit">
                      <i class="fas fa-check"></i> SMS/Email payment reminder
                    </div>
                    <div class="benefit">
                      <i class="fas fa-exclamation-triangle"></i> Booking may be
                      cancelled if not paid on time
                    </div>
                  </div>
                </div>
              </div>

              <div
                class="payment-methods"
                id="paymentMethods"
                style="display: none"
              >
                <h4>Payment Method</h4>
                <div class="method-options">
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

                <div class="qr-payment" id="qrPayment">
                  <div class="qr-code">
                    <img
                      src="/placeholder.svg?height=200&width=200"
                      alt="QR Code"
                      id="paymentQR"
                    />
                  </div>
                  <p class="qr-instruction">Scan QR code to complete payment</p>
                  <div class="payment-amount">
                    <span id="paymentAmount">2,380,700 VND</span>
                  </div>
                </div>
              </div>

              <div class="contract-actions">
                <button
                  type="button"
                  class="btn btn-secondary"
                  onclick="goBack()"
                >
                  <i class="fas fa-arrow-left"></i>
                  Back to Deposit
                </button>
                <button
                  type="button"
                  class="btn btn-primary"
                  id="signContractBtn"
                  disabled
                  onclick="signContract()"
                >
                  <i class="fas fa-signature"></i>
                  Sign Contract
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </main>

    <script src="scripts/booking-form/booking-form-contract.js"></script>
  </body>
</html>
