<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <title>Create an account</title>
        <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700&display=swap" rel="stylesheet">
        <link rel="stylesheet" href="../../Authen/css/SignUp.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" />

    </head>

    <body>
        <div class="logo-autorental">
            <span class="auto">Auto</span><span class="rental">Rental</span>
        </div>
        <div class="container">
            <div class="signup-box">
                <div class="signup-title">Create an account</div>
                <% String errMsg = (String) request.getAttribute("errMsg"); %>
                <% if (errMsg != null) { %>
                    <div class="social-login-error"><%= errMsg %></div>
                <% } %>
                <form class="signup-form" action="" method="post">
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
                            <input type="password" id="password" name="password" required>
                            <button type="button" class="toggle-password" onclick="togglePassword('password', this)"
                                    aria-label="Show/Hide Password">
                            </button>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="repassword">Re-Enter Password</label>
                        <div class="input-row">
                            <input type="password" id="repassword" name="repassword" required>
                            <button type="button" class="toggle-password" onclick="togglePassword('repassword', this)"
                                    aria-label="Show/Hide Password">
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
                    <a href="SignIn.jsp">Log In</a>
                </div>
            </div>
        </div>
        <script src="../../Authen/js/config.js"></script>
        <script src="../../Authen/js/SignUp.js"></script>
    </body>

</html>