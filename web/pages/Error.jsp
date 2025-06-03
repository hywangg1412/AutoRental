<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>System Error</title>
    </head>
    <body>
        <h1>An error has occurred!</h1>
        <%
            String errorMsg = (String) request.getAttribute("errorMsg");
            if (errorMsg != null) {
        %>
            <div style="color: red; font-weight: bold;">
                <%= errorMsg %>
            </div>
        <%
            } else {
        %>
            <div style="color: orange;">
                No detailed error message available.
            </div>
        <%
            }
        %>
        <a href="${pageContext.request.contextPath}/pages/authen/SignUp.jsp">Back to Sign Up</a>
    </body>
</html>