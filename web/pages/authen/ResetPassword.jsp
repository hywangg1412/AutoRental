<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Reset Password - Auto Rental</title>

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
                <h2 class="reset-title">Change password</h2>
                <div class="reset-desc">Create a new password. Ensure it differs from previous ones for security</div>
                <form class="reset-form" method="post">
                    <% if (request.getAttribute("error") != null) { %>
                        <div class="alert alert-danger" style="color: red; margin-bottom: 10px;">
                            <%= request.getAttribute("error") %>
                        </div>
                    <% } %>
                    <% if (request.getAttribute("message") != null) { %>
                        <div class="alert alert-success" style="color: green; margin-bottom: 10px;">
                            <%= request.getAttribute("message") %>
                        </div>
                    <% } %>
                    <div class="form-error" style="color: red; margin-bottom: 10px;"></div>
                    <div class="form-group">
                        <input type="password" name="newPassword" placeholder="New Password" required>
                    </div>
                    <div class="form-group">
                        <input type="password" name="confirmPassword" placeholder="Confirm New Password" required>
                    </div>
                    <button type="submit" class="reset-btn">Change Password</button>
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
