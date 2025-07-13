<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isErrorPage="true" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Error - AutoRental</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .error-container {
            max-width: 600px;
            text-align: center;
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        .error-icon {
            font-size: 4rem;
            color: #dc3545;
            margin-bottom: 20px;
        }
        .error-title {
            font-size: 2rem;
            color: #333;
            margin-bottom: 10px;
        }
        .error-message {
            color: #666;
            margin-bottom: 30px;
            font-size: 1.1rem;
        }
        .error-details {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-family: monospace;
            font-size: 0.9rem;
            color: #666;
            text-align: left;
        }
        .btn {
            display: inline-block;
            padding: 12px 24px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            transition: background-color 0.3s;
            margin: 0 10px;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .btn-secondary {
            background-color: #6c757d;
        }
        .btn-secondary:hover {
            background-color: #545b62;
        }
    </style>
</head>
<body>
    <div class="error-container">
        <div class="error-icon">⚠️</div>
        <h1 class="error-title">An error has occurred!</h1>
        
        <p class="error-message">
            <c:choose>
                <c:when test="${not empty errorMessage}">
                    ${errorMessage}
                </c:when>
                <c:when test="${not empty requestScope.errorMessage}">
                    ${requestScope.errorMessage}
                </c:when>
                <c:when test="${not empty param.message}">
                    ${param.message}
                </c:when>
                <c:otherwise>
                    Sorry, an unexpected error has occurred. Please try again later.
                </c:otherwise>
            </c:choose>
        </p>
        
        <%-- Hiển thị chi tiết lỗi nếu có exception --%>
        <c:if test="${not empty exception}">
            <div class="error-details">
                <strong>Error Details:</strong><br/>
                <c:out value="${exception.message}" default="No detailed error message available"/>
            </div>
        </c:if>
        
        <%-- Hiển thị thông tin request nếu cần debug --%>
        <c:if test="${param.debug eq 'true'}">
            <div class="error-details">
                <strong>Debug Info:</strong><br/>
                Request URI: ${pageContext.request.requestURI}<br/>
                Context Path: ${pageContext.request.contextPath}<br/>
                Servlet Path: ${pageContext.request.servletPath}<br/>
                Session ID: ${pageContext.session.id}
            </div>
        </c:if>
        
        <div style="margin-top: 30px;">
            <a href="${pageContext.request.contextPath}/pages/authen/SignIn.jsp" class="btn">
                <i class="fas fa-sign-in-alt"></i> Back to Login
            </a>
            <a href="${pageContext.request.contextPath}/pages/home.jsp" class="btn btn-secondary">
                <i class="fas fa-home"></i> Home Page
            </a>
        </div>
    </div>
</body>
</html>