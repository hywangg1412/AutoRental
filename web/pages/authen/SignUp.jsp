<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign Up - Auto Rental</title>

    <!-- ===== Google Fonts ===== -->
    <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700&display=swap" rel="stylesheet">

    <!-- ===== External CSS Libraries ===== -->
    <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
    
    <!-- ===== Custom Styles ===== -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/authen/SignUp.css">
</head>

<body>
    <div class="logo-autorental">
        <span class="auto">Auto</span><span class="rental">Rental</span>
    </div>
    <div class="container">
        <div class="signup-box">
            <div class="signup-title">Create an account</div>
            <% String errMsg=(String) request.getAttribute("error"); %>
                <% if (errMsg !=null) {%>
                    <div class="social-login-error">
                        <%= errMsg%>
                    </div>
                    <% }%>
                        <form action="${pageContext.request.contextPath}/normalRegister" method="post"
                            class="signup-form">
                            <div class="form-group">
                                <label for="username">Username</label>
                                <input type="text" id="username" name="username" required>
                            </div>
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" id="email" name="email" required>
                            </div>
                            <div class="form-group">
                                <label for="password">Password</label>
                                <div class="input-row">
                                    <input type="password" id="password" name="password" tabindex="-1" required>
                                    <button type="button" class="toggle-password"
                                        onclick="togglePassword('password', this)" aria-label="Show/Hide Password">
                                    </button>
                                </div>
                            </div>
                            <div class="form-group">
                                <label for="repassword">Re-Enter Password</label>
                                <div class="input-row">
                                    <input type="password" id="repassword" name="repassword" tabindex="-1" required>
                                    <button type="button" class="toggle-password"
                                        onclick="togglePassword('repassword', this)" aria-label="Show/Hide Password">
                                    </button>
                                </div>
                            </div>
                            <button class="signup-btn" type="submit">Create account</button>
                        </form>
                        <div class="or-divider">
                            <span>or</span>
                        </div>

                        <div class="social-login-col">
                            <button type="button" class="social-btn google" onclick="continueWithGoogle()">
                                <i class="fab fa-google"></i> Continue with Google
                            </button>
                            <button type="button" class="social-btn facebook" onclick="continueWithFacebook()">
                                <i class="fab fa-facebook-f"></i> Continue with Facebook
                            </button>
                        </div>
                        <div class="login-row">
                            Already Have An Account?
                            <a href="${pageContext.request.contextPath}/pages/authen/SignIn.jsp">Log In</a>
                        </div>
        </div>
    </div>
    <!-- ===== External JS Libraries ===== -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- ===== Custom Scripts ===== -->
    <script src="${pageContext.request.contextPath}/scripts/authen/config.js"></script>
    <script src="${pageContext.request.contextPath}/scripts/authen/SignUp.js"></script>
</body>

</html>