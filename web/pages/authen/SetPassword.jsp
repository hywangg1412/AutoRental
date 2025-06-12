<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Set Password - Auto Rental</title>

        <!-- ===== Google Fonts ===== -->
        <link href="https://fonts.googleapis.com/css?family=Montserrat:400,500,600,700&display=swap" rel="stylesheet">

        <!-- ===== External CSS Libraries ===== -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
        
        <!-- ===== Custom Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/authen/ResetPassword.css">
    </head>
    <body>
        <div class="reset-container">
            <div class="reset-box">
                <h2 class="reset-title">Set Your Password</h2>
                <div class="reset-desc">Please set a password for your new account. Make sure it is strong and secure.</div>
                <%
                    String errMsg = (String) request.getAttribute("error");
                    if (errMsg == null) {
                        errMsg = (String) session.getAttribute("error");
                        if (errMsg != null) session.removeAttribute("error");
                    }
                    if (errMsg == null) {
                        errMsg = request.getParameter("error");
                    }
                    if (errMsg != null && !errMsg.isEmpty()) {
                %>
                    <div class="alert alert-danger" style="color: red; margin-bottom: 10px;"><%= errMsg %></div>
                <%
                    }
                    String successMsg = (String) request.getAttribute("message");
                    if (successMsg == null) {
                        successMsg = (String) session.getAttribute("message");
                        if (successMsg != null) session.removeAttribute("message");
                    }
                    if (successMsg == null) {
                        successMsg = request.getParameter("message");
                    }
                    if (successMsg != null) {
                %>
                    <div class="alert alert-success" style="color: green; margin-bottom: 10px;">
                        <%= successMsg %>
                    </div>
                <%
                    }
                %>
                <form class="reset-form" method="post" action="${pageContext.request.contextPath}/setPassword" onsubmit="console.log('Form submitted to:', this.action); return true;">
                    <input type="hidden" name="userId" value="<%= session.getAttribute("userId") %>">
                    <div class="form-group">
                        <label>New Password</label>
                        <div class="input-row">
                            <input type="password" name="newPassword" placeholder="New Password" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Confirm New Password</label>
                        <div class="input-row">
                            <input type="password" name="confirmPassword" placeholder="Confirm New Password" required>
                        </div>
                    </div>
                    <button type="submit" class="reset-btn">Set Password</button>
                </form>
            </div>
        </div>
        <!-- ===== External JS Libraries ===== -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- ===== Custom Scripts ===== -->
        <script src="${pageContext.request.contextPath}/scripts/authen/config.js"></script>
        <script src="${pageContext.request.contextPath}/scripts/authen/ResetPassword.js"></script>
    </body>
</html>
