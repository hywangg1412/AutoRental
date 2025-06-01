<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Login to your account</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Authen/css/SignIn.css"/>
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css"/>
    </head>

    <body>
        <div class="main-wrapper">
            <div class="logo-autorental">
                <span class="auto">AUTO</span><span class="rental">RENTAL</span>
            </div>
            <div class="login-container">
                <div class="login-box">
                    <h2>Login to your account</h2>
                    <% if (request.getAttribute("error") != null) {%>
                    <p class="error-message"><%= request.getAttribute("error")%></p>
                    <% }%>
                    <form action="normalLogin" method="post" class="login-form">
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" required placeholder="Enter your email" >
                        </div>
                        <div class="form-group">
                            <div class="form-options">
                                <label for="password" style="margin-bottom:0;">Password</label>
                                <a href="ForgotPassword.jsp">Forgot ?</a>
                            </div>
                            <div style="position: relative;">
                                <input type="password" id="password" name="password" required placeholder="Enter your password">
                            </div>
                        </div>
                        <button class="submit-btn" type="submit" id="loginBtn">
                            <span id="loginBtnText">Login now</span>
                        </button>

                        <div class="or-divider">
                            <span>or</span>
                        </div>

                        <div class="social-login-row">
                            <button type="button" class="social-btn google" onclick="loginWithGoogle()">
                                <i class="fab fa-google"></i> Login with Google
                            </button>
                            <button type="button" class="social-btn facebook" onclick="loginWithFacebook()">
                                <i class="fab fa-facebook-f"></i> Login with Facebook
                            </button>
                        </div>
                        <p class="register-link">Don't Have An Account ? <a href="${pageContext.request.contextPath}/pages/authen/SignUp.jsp">Sign Up</a></p>
                    </form>
                </div>
            </div>
        </div>
    </body>
    <script src="${pageContext.request.contextPath}/Authen/js/config.js"></script>
    <script src="${pageContext.request.contextPath}/Authen/js/SignIn.js"></script>
</html>
