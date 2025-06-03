<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Password</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Authen/css/ResetPassword.css">
        <link href="https://fonts.googleapis.com/css?family=Montserrat:400,500,600,700&display=swap" rel="stylesheet">
    </head>
    <body>
        <div class="reset-container">
            <div class="reset-box">
                <h2 class="reset-title">Change password</h2>
                <div class="reset-desc">Create a new password. Ensure it differs from previous ones for security</div>
                <form class="reset-form" method="post">
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
    </body>
    <script src="${pageContext.request.contextPath}/Authen/js/ResetPassword.js"></script>
</html>
