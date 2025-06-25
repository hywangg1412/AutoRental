<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Email Verification - AutoRental</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Poppins:400,600&display=swap" rel="stylesheet">
    <style>
        body {
            background: #f8f9fa;
            font-family: 'Poppins', Arial, sans-serif;
        }
        .verify-section {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .verify-card {
            background: #fff;
            border-radius: 10px;
            box-shadow: 0 2px 12px rgba(0,0,0,0.06);
            padding: 2rem 1.5rem;
            max-width: 350px;
            width: 100%;
            text-align: center;
        }
        .verify-card .logo {
            font-size: 1.7rem;
            font-weight: 600;
            color: #222;
            letter-spacing: 1px;
        }
        .verify-card .logo span {
            color: #01d28e;
        }
        .verify-card .icon-success {
            color: #01d28e;
            font-size: 2.2rem;
            margin-bottom: 0.7rem;
        }
        .verify-card .icon-error {
            color: #dc3545;
            font-size: 2.2rem;
            margin-bottom: 0.7rem;
        }
        .verify-card .title {
            color: #222;
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
        }
        .verify-card .message {
            color: #555;
            font-size: 0.98rem;
            margin-bottom: 1.2rem;
        }
        .verify-card .btn-primary {
            background: #01d28e;
            border: none;
            border-radius: 20px;
            font-weight: 600;
            padding: 0.5rem 1.5rem;
            font-size: 1rem;
            transition: all 0.18s cubic-bezier(.4,2,.6,1);
        }
        .verify-card .btn-primary.register-again {
            transition: all 0.18s cubic-bezier(.4,2,.6,1);
        }
        .verify-card .btn-primary.register-again:hover {
            background: #01d28e;
            filter: brightness(1.08);
            transform: scale(1.07);
        }
        .verify-card .btn-secondary {
            background: #6c757d;
            border: none;
            border-radius: 20px;
            font-weight: 600;
            padding: 0.5rem 1.5rem;
            font-size: 1rem;
            margin-left: 0.3rem;
            transition: all 0.18s cubic-bezier(.4,2,.6,1);
        }
        .verify-card .btn-secondary:hover {
            background: #6c757d;
            filter: brightness(1.15);
            transform: scale(1.07);
        }
        .verify-card .help {
            margin-top: 1.2rem;
            font-size: 0.93rem;
        }
        .verify-card .help a {
            color: #1089ff;
        }
    </style>
</head>
<body>
    <div class="verify-section">
        <div class="verify-card">
            <div class="logo" style="font-size: 1.7rem; font-weight: 800; color: #222; letter-spacing: 1px;">
                Auto<span style="color: #01d28e;">Rental</span>
            </div>
            <c:choose>
                <c:when test="${not empty success}">
                    <div class="icon-success">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <div class="title">Email Verified Successfully!</div>
                    <div class="message">${message}</div>
                    <a href="SignIn.jsp" class="btn btn-primary">
                        Sign In Now
                    </a>
                </c:when>
                <c:when test="${not empty error}">
                    <div class="icon-error">
                        <i class="fas fa-exclamation-triangle"></i>
                    </div>
                    <div class="title">Verification Failed</div>
                    <div class="message">${message}</div>
                    <a href="SignUp.jsp" class="btn btn-primary register-again">
                        Register Again
                    </a>
                    <a href="SignIn.jsp" class="btn btn-secondary">
                        Sign In
                    </a>
                </c:when>
                <c:otherwise>
                    <div class="icon-error">
                        <i class="fas fa-question-circle"></i>
                    </div>
                    <div class="title">Invalid Request</div>
                    <div class="message">The verification link is invalid or has expired.</div>
                    <a href="SignUp.jsp" class="btn btn-primary register-again">
                        Register Again
                    </a>
                    <a href="SignIn.jsp" class="btn btn-secondary">
                        Sign In
                    </a>
                </c:otherwise>
            </c:choose>
            <div class="help">
                Need help? <a href="mailto:support@autorental.com">Contact support</a>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/js/all.min.js"></script>
</body>
</html> 