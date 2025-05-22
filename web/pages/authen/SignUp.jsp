<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Sign Up</title>
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700&display=swap" rel="stylesheet">
    <style>
        body {
            margin: 0;
            padding: 0;
            min-height: 100vh;
            font-family: 'Montserrat', sans-serif;
            background: #f6f7fb;
        }
        .main-container {
            display: flex;
            min-height: 100vh;
            align-items: center;
            justify-content: center;
        }
        .left-bg {
            flex: 1;
            background: linear-gradient(135deg, #f8fafc 0%, #e0e7ff 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .right-form {
            flex: 1;
            background: #fff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            padding: 0 32px;
            min-width: 420px;
            max-width: 700px;
            min-height: 100vh;
            box-shadow: 0 0 32px 0 rgba(31, 38, 135, 0.08);
        }
        .form-wrapper {
            width: 100%;
            max-width: 420px;
            margin: 0 auto;
        }
        .signup-title {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 8px;
            color: #222;
        }
        .signup-subtitle {
            color: #444;
            font-size: 1.05rem;
            margin-bottom: 24px;
        }
        .signup-form label {
            font-size: 1rem;
            color: #444;
            margin-bottom: 6px;
            display: block;
        }
        .signup-form input[type="text"],
        .signup-form input[type="email"],
        .signup-form input[type="password"] {
            width: 100%;
            padding: 13px 16px;
            margin-bottom: 16px;
            border: 1px solid #e0e0e0;
            border-radius: 10px;
            font-size: 1rem;
            background: #fafbfc;
            transition: border 0.2s;
        }
        .signup-form input:focus {
            border: 1.5px solid #2d5eff;
            outline: none;
            background: #fff;
        }
        .password-conditions {
            font-size: 0.95rem;
            color: #bdbdbd;
            margin-top: -10px;
            margin-bottom: 18px;
            display: flex;
            flex-wrap: wrap;
            gap: 12px 18px;
        }
        .password-conditions span {
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .checkbox-row {
            display: flex;
            align-items: flex-start;
            margin-bottom: 18px;
        }
        .checkbox-row input[type="checkbox"] {
            margin-right: 10px;
            margin-top: 2px;
        }
        .checkbox-row label {
            font-size: 1rem;
            color: #222;
            font-weight: 400;
            margin: 0;
        }
        .signup-btn {
            width: 100%;
            padding: 14px 0;
            background: #bdbdbd;
            color: #fff;
            font-size: 1.1rem;
            font-weight: 700;
            border: none;
            border-radius: 24px;
            cursor: pointer;
            margin-top: 8px;
            margin-bottom: 18px;
            transition: background 0.2s;
        }
        .signup-btn:hover {
            background: #2d5eff;
        }
        .signup-link {
            display: block;
            text-align: left;
            margin-top: 18px;
            color: #222;
            text-decoration: underline;
            font-size: 1rem;
        }
        .terms {
            margin: 18px 0 0 0;
            font-size: 0.98rem;
            color: #444;
        }
        .terms a {
            color: #2d5eff;
            text-decoration: underline;
        }
        .login-link {
            color: #222;
            text-decoration: underline;
            font-size: 1rem;
        }
        .login-row {
            margin-top: 8px;
            font-size: 0.98rem;
            color: #444;
        }
        @media (max-width: 900px) {
            .main-container { flex-direction: column; }
            .left-bg, .right-form { min-width: 100vw; border-radius: 0; }
            .right-form { padding: 32px 0 0 0; align-items: center; min-height: auto; }
        }
    </style>
</head>
<body>
<div class="main-container">
    <div class="left-bg"></div>
    <div class="right-form">
        <div class="form-wrapper">
            <div class="signup-title">Welcome to Auto Rental</div>
            <div class="signup-subtitle">
                Already have an account? <a class="login-link" href="SignIn.jsp">Log in</a>
            </div>
            <form class="signup-form" action="" method="post">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required>
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required oninput="validatePassword()">
                <div class="password-conditions" id="password-conditions">
                    <span id="cond-length">• Use 8 or more characters</span>
                    <span id="cond-upper">• One Uppercase character</span>
                    <span id="cond-lower">• One lowercase character</span>
                    <span id="cond-special">• One special character</span>
                    <span id="cond-number">• One number</span>
                </div>
                <div class="checkbox-row">
                    <input type="checkbox" id="receive-emails" name="receive-emails" checked>
                    <label for="receive-emails">I want to receive emails about the product, feature updates, events, and marketing promotions.</label>
                </div>
                <button class="signup-btn" id="signup-btn" type="submit" disabled>Create an account</button>
            </form>
            <div class="terms">
                By creating an account, you agree to the <a href="#">Terms of use</a> and <a href="#">Privacy Policy</a>.
            </div>
            <div class="login-row">
                Already have an account? <a class="login-link" href="SignIn.jsp">Log in</a>
            </div>
        </div>
    </div>
</div>
<script>
    function validatePassword() {
        const password = document.getElementById('password').value;
        const condLength = document.getElementById('cond-length');
        const condUpper = document.getElementById('cond-upper');
        const condLower = document.getElementById('cond-lower');
        const condSpecial = document.getElementById('cond-special');
        const condNumber = document.getElementById('cond-number');
        const btn = document.getElementById('signup-btn');

        const isLength = password.length >= 8;
        const isUpper = /[A-Z]/.test(password);
        const isLower = /[a-z]/.test(password);
        const isSpecial = /[^A-Za-z0-9]/.test(password);
        const isNumber = /[0-9]/.test(password);

        condLength.style.color = isLength ? '#000000' : '#bdbdbd';
        condUpper.style.color = isUpper ? '#000000' : '#bdbdbd';
        condLower.style.color = isLower ? '#000000' : '#bdbdbd';
        condSpecial.style.color = isSpecial ? '#000000' : '#bdbdbd';
        condNumber.style.color = isNumber ? '#000000' : '#bdbdbd';

        if (isLength && isUpper && isLower && isSpecial && isNumber) {
            btn.disabled = false;
            btn.style.background = '#2d5eff';
            btn.style.cursor = 'pointer';
        } else {
            btn.disabled = true;
            btn.style.background = '#bdbdbd';
            btn.style.cursor = 'not-allowed';
        }
    }
    window.onload = function() { validatePassword(); };
</script>
</body>
</html>