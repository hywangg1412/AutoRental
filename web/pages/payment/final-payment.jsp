<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Remaining Payment - AutoRental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.7.2/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/style.css" rel="stylesheet">
    <style>
        .payment-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .payment-header {
            text-align: center;
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #f8f9fa;
        }
        
        .payment-header h2 {
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }
        
        .payment-header p {
            color: #6c757d;
            margin: 0;
        }
        
        .booking-info {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 8px;
            margin-bottom: 2rem;
        }
        
        .booking-info h5 {
            color: #2c3e50;
            margin-bottom: 1rem;
        }
        
        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.5rem;
            padding: 0.5rem 0;
            border-bottom: 1px solid #e9ecef;
        }
        
        .info-row:last-child {
            border-bottom: none;
        }
        
        .info-label {
            font-weight: 600;
            color: #495057;
        }
        
        .info-value {
            color: #6c757d;
        }
        
        .payment-breakdown {
            background: #fff;
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .payment-breakdown h5 {
            color: #2c3e50;
            margin-bottom: 1rem;
        }
        
        .amount-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 0.75rem;
            padding: 0.5rem 0;
        }
        
        .amount-row.total {
            border-top: 2px solid #dee2e6;
            padding-top: 1rem;
            margin-top: 1rem;
            font-weight: 700;
            font-size: 1.1rem;
            color: #2c3e50;
        }
        
        .surcharges-section {
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #dee2e6;
        }
        
        .surcharge-item {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 6px;
            padding: 0.75rem;
            margin-bottom: 0.5rem;
        }
        
        .surcharge-item .surcharge-amount {
            font-weight: 600;
            color: #856404;
        }
        
        .payment-button {
            width: 100%;
            padding: 1rem;
            font-size: 1.1rem;
            font-weight: 600;
            border: none;
            border-radius: 8px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .payment-button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.4);
        }
        
        .payment-button:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
        }
        
        .warning-box {
            background: #fff3cd;
            border: 1px solid #ffeaa7;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 1.5rem;
        }
        
        .warning-box h6 {
            color: #856404;
            margin-bottom: 0.5rem;
        }
        
        .warning-box p {
            color: #856404;
            margin: 0;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="payment-container">
            <div class="payment-header">
                <h2><i class="bi bi-credit-card me-2"></i>Remaining Payment</h2>
                <p>Complete payment for your trip</p>
            </div>
            
            <c:if test="${not empty paymentData}">
                <!-- Booking Information -->
                <div class="booking-info">
                    <h5><i class="bi bi-info-circle me-2"></i>Booking Information</h5>
                    <div class="info-row">
                        <span class="info-label">Booking Code:</span>
                        <span class="info-value">${paymentData.bookingCode}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Car:</span>
                        <span class="info-value">${paymentData.fullCarName}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Rental Period:</span>
                        <span class="info-value">${paymentData.formattedPickupDateTime} - ${paymentData.formattedReturnDateTime}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Actual Return Time:</span>
                        <span class="info-value">${paymentData.formattedActualReturnDateTime}</span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Inspection Time:</span>
                        <span class="info-value">${paymentData.formattedInspectionDate}</span>
                    </div>
                </div>
                
                <!-- Payment Breakdown -->
                <div class="payment-breakdown">
                    <h5><i class="bi bi-calculator me-2"></i>Payment Details</h5>
                    
                    <div class="amount-row">
                        <span>Original Total Amount:</span>
                        <span>${paymentData.formattedTotalAmount}</span>
                    </div>
                    
                    <div class="amount-row">
                        <span>Deposit Already Paid:</span>
                        <span>-${paymentData.formattedDepositAmount}</span>
                    </div>
                    
                    <div class="amount-row">
                        <span>Remaining Amount:</span>
                        <span>${paymentData.formattedRemainingAmount}</span>
                    </div>
                    
                    <c:if test="${paymentData.hasSurcharges()}">
                        <div class="surcharges-section">
                            <h6><i class="bi bi-exclamation-triangle me-2"></i>Surcharges</h6>
                            <c:forEach items="${paymentData.surcharges}" var="surcharge">
                                <div class="surcharge-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <strong>${surcharge.description}</strong>
                                            <br>
                                            <small class="text-muted">${surcharge.surchargeType}</small>
                                        </div>
                                        <span class="surcharge-amount">
                                            <fmt:formatNumber value="${surcharge.amount * 1000}" type="number" groupingUsed="true" pattern="#,##0" /> VND
                                        </span>
                                    </div>
                                </div>
                            </c:forEach>
                            
                            <div class="amount-row">
                                <span>Total Surcharges:</span>
                                <span>${paymentData.formattedTotalSurcharges}</span>
                            </div>
                        </div>
                    </c:if>
                    
                    <div class="amount-row total">
                        <span>Total Amount to Pay:</span>
                        <span>${paymentData.formattedFinalAmount}</span>
                    </div>
                </div>
                
                <!-- Warning Box -->
                <div class="warning-box">
                    <h6><i class="bi bi-info-circle me-2"></i>Important Notes</h6>
                    <p>• This amount includes the remaining amount after deducting the deposit and any surcharges (if applicable)</p>
                    <p>• Surcharges are calculated based on the car inspection results by staff</p>
                    <p>• Payment will be processed through VNPay - a secure payment gateway</p>
                </div>
                
                <!-- Payment Button -->
                <button id="paymentBtn" class="payment-button" onclick="processPayment()">
                    <i class="bi bi-credit-card me-2"></i>
                    Pay ${paymentData.formattedFinalAmount}
                </button>
                
                <!-- Hidden form for payment -->
                <form id="paymentForm" method="post" action="${pageContext.request.contextPath}/payment/final-payment" style="display: none;">
                    <input type="hidden" name="bookingId" value="${paymentData.bookingId}">
                </form>
                
            </c:if>
            
            <c:if test="${empty paymentData}">
                <div class="text-center">
                    <i class="bi bi-exclamation-triangle" style="font-size: 3rem; color: #dc3545; margin-bottom: 1rem;"></i>
                    <h5 class="text-danger">Cannot load payment information</h5>
                    <p class="text-muted">Please try again or contact support</p>
                    <a href="${pageContext.request.contextPath}/user/my-trip" class="btn btn-primary">
                        <i class="bi bi-arrow-left me-2"></i>Go Back
                    </a>
                </div>
            </c:if>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function processPayment() {
            const paymentBtn = document.getElementById('paymentBtn');
            const bookingId = '${paymentData.bookingId}';
            
            // Validate bookingId
            if (!bookingId) {
                alert('Error: Missing booking information');
                return;
            }
            
            // Disable button to prevent double click
            paymentBtn.disabled = true;
            paymentBtn.innerHTML = '<i class="bi bi-hourglass-split me-2"></i>Processing...';
            
            // Create form data
            const formData = new FormData();
            formData.append('bookingId', bookingId);
            
            // Submit form via AJAX
            fetch('${pageContext.request.contextPath}/payment/final-payment', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Redirect to VNPay
                    window.location.href = data.paymentUrl;
                } else {
                    alert('Error: ' + data.message);
                    // Re-enable button
                    paymentBtn.disabled = false;
                    paymentBtn.innerHTML = '<i class="bi bi-credit-card me-2"></i>Pay ${paymentData.formattedFinalAmount}';
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred. Please try again.');
                // Re-enable button
                paymentBtn.disabled = false;
                paymentBtn.innerHTML = '<i class="bi bi-credit-card me-2"></i>Pay ${paymentData.formattedFinalAmount}';
            });
        }
    </script>
</body>
</html> 