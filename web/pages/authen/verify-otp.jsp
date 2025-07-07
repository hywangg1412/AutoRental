<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Verify OTP - AutoRental</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap"
        rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Montserrat:600,700&display=swap" rel="stylesheet">
    <!-- Bootstrap & Icon Fonts -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom Styles (nav, verify-otp) -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/authen/verify-otp.css">
</head>
<body>
    <div class="main-content">
        <div class="verify-container">
            <div class="verify-title">Check your email</div>
            <div class="verify-desc">
                We sent a verification code to <b>${sessionScope.email != null ? sessionScope.email : "your email"}</b>.<br>
                Enter the 6 digit code from the email below.
            </div>
            <form action="${pageContext.request.contextPath}/verify-otp" method="post" autocomplete="off" id="otpForm">
                <div class="otp-input-group">
                    <input type="text" maxlength="1" class="otp-input" name="otp1" required>
                    <input type="text" maxlength="1" class="otp-input" name="otp2" required>
                    <input type="text" maxlength="1" class="otp-input" name="otp3" required>
                    <input type="text" maxlength="1" class="otp-input" name="otp4" required>
                    <input type="text" maxlength="1" class="otp-input" name="otp5" required>
                    <input type="text" maxlength="1" class="otp-input" name="otp6" required>
                </div>
                <input type="hidden" name="otp" id="otpFull">
                <c:if test="${not empty error}">
                    <div class="error-message">${error}</div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="success-message">${success}</div>
                </c:if>
                <button type="submit" class="btn btn-verify">Verify Code</button>
            </form>
            <div class="text-center mt-2" style="color:#888;">
                Haven't got the email yet?
                <a href="${pageContext.request.contextPath}/resend-otp" class="resend-link">Resend email</a>
            </div>
        </div>
    </div>
    <!-- Bootstrap Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Custom Script -->
    <script src="${pageContext.request.contextPath}/scripts/authen/verify-otp.js"></script>
</body>

</html>