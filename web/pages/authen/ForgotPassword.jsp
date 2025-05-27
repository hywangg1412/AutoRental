<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Forgot Password</title>
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="../../css/Authen/css/ForgotPassword.css">
</head>
<body>
    <div class="forgot-container">
        <div class="forgot-box">
            <div class="forgot-title">Forgot Password</div>
            <div class="forgot-desc">Please enter your password to reset the password</div>
            <form class="forgot-form" action="" method="post">
                <div class="form-group">
                    <label for="email">Your Email</label>
                    <input type="email" id="email" name="email" required placeholder="example@gmail.com">
                </div>
                <button class="forgot-btn" type="submit">Reset Password</button>
            </form>
            <div class="login-row">
                Already Have An Account ? <a href="SignIn.jsp">Log In</a>
            </div>
        </div>
    </div>
</body>
</html>
