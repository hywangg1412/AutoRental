<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="UTF-8">
        <title>Forgot Password</title>
        <link href="https://fonts.googleapis.com/css?family=Montserrat:400,700&display=swap" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/authen/RequestPassword.css">
    </head>

    <body>

        <div class="forgot-container">
            <div class="forgot-box">
                <div class="forgot-title">Forgot Password</div>
                <%
                    String errMsg = (String) request.getAttribute("error");
                    if (errMsg == null) {
                        errMsg = (String) session.getAttribute("error");
                        if (errMsg != null) session.removeAttribute("error");
                    }
                    if (errMsg == null) {
                        errMsg = request.getParameter("error");
                    }
                    if (errMsg != null) {
                %>
                    <div class="error-message">
                        <%= errMsg %>
                    </div>
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
                    <div class="success-message">
                        <%= successMsg %>
                    </div>
                <%
                    }
                %>
                <div class="forgot-desc">Please enter your password to reset the password</div>
                <form class="forgot-form" action="${pageContext.request.contextPath}/requestPassword"
                      method="post">
                    <div class="form-group">
                        <label for="email">Your Email</label>
                        <input type="email" id="email" name="email" required
                               placeholder="example@gmail.com">
                    </div>
                    <button class="forgot-btn" type="submit">Reset Password</button>
                </form>
                <div class="login-row">
                    Already Have An Account ? <a href="SignIn.jsp">Log In</a>
                </div>
            </div>
        </div>
        <!-- ===== External JavaScript Libraries ===== -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- ===== Authentication Scripts ===== -->
        <script src="${pageContext.request.contextPath}/scripts/authen/RequestPassword.js"></script>
    </body>

</html>