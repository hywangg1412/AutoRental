<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Booking Successful</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/styles/success.css">
</head>
<body>
    <div class="success-message">
        <h1>🎉 Booking Successful!</h1>
        <p>Thank you for your booking. Our staff will contact you soon for confirmation.</p>
        <a href="<%= request.getContextPath() %>/index.jsp" class="btn btn-primary">Back to Home</a>
    </div>
</body>
</html>
