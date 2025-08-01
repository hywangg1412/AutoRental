<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Sign In - Auto Rental</title>

        <!-- ===== Google Fonts ===== -->
        <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;500;600;700&display=swap" rel="stylesheet">

        <!-- ===== External CSS Libraries ===== -->
        <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
        
        <!-- ===== Custom Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/authen/SignIn.css"/>
    </head>

    <body>
        <div class="main-wrapper">
            <div class="logo-autorental">
                <span class="auto">AUTO</span><span class="rental">RENTAL</span>
            </div>
            <div class="login-container">
                <div class="login-box">
                    <h2>Login to your account</h2>
                    <%
                        String errMsg = (String) request.getAttribute("error");
                        String emailFromError = (String) request.getAttribute("email");
                        if (errMsg != null) {
                    %>
                        <div class="social-login-error">
                            <%= errMsg %>
                        </div>
                    <%
                        }
                        String successMsg = (String) request.getAttribute("message");
                        if (successMsg == null) {
                            successMsg = (String) session.getAttribute("message");
                            if (successMsg != null) {
                                session.removeAttribute("message");
                            }
                        }
                        if (successMsg != null) {
                    %>
                        <div class="success-message">
                            <%= successMsg %>
                        </div>
                    <%
                        }
                    %>
                    <form action="${pageContext.request.contextPath}/normalLogin" method="post" class="login-form">
                        <div class="form-group">
                            <label for="email">Email</label>
                            <input type="email" id="email" name="email" required placeholder="Enter your email" 
                                   value="<%= emailFromError != null ? emailFromError : "" %>">
                        </div>
                        <div class="form-group">
                            <div class="form-options">
                                <label for="password" style="margin-bottom:0;">Password</label>
                                <a href="${pageContext.request.contextPath}/pages/authen/RequestPassword.jsp">Forgot ?</a>
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
        <!-- ===== External JS Libraries ===== -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- ===== Custom Scripts ===== -->
        <script src="${pageContext.request.contextPath}/scripts/authen/config.js"></script>
        <script src="${pageContext.request.contextPath}/scripts/authen/SignIn.js"></script>
    </body>
</html>