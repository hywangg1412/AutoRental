<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - CarBook</title>
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="../css/login.css">
    <link href="https://fonts.googleapis.com/css2?family=Montserrat:wght@400;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" integrity="sha512-Fo3rlrZj/k7ujTnHg4CGR2D7kSs0v4LLanw2qksYuRlEzO+tcaEPQogQ0KaoGN26/zrn20ImR1DfuLWnOo7aBA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body>
<img src="../images/anh-o-to-27.jpg" alt="Background" class="background-image">
<div class="login-container">
    <div class="login-box">
        <h2>Đăng nhập</h2>
        <% if (request.getAttribute("error") != null) { %>
        <p style="color: red; text-align: center;"><%= request.getAttribute("error") %></p>
        <% } %>
        <form action="../login" method="post" class="login-form">
            <div class="form-group">
                <label for="email">Email:</label>
                <input type="email" id="email" name="email" required placeholder="Nhập email của bạn">
                <i class="fas fa-envelope"></i>
            </div>
            <div class="form-group">
                <label for="password">Mật Khẩu:</label>
                <input type="password" id="password" name="password" required placeholder="Nhập mật khẩu">
                <i class="fas fa-lock"></i>
            </div>
            <div class="form-options">
                <label>
                    <input type="checkbox" name="remember-me"> Remember me
                </label>
                <a href="../forgotPassword.jsp" class="forgot-password">Forgot password?</a>
            </div>
            <button type="submit" class="submit-btn">Đăng nhập</button>
            <p class="register-link">Don't have an account? <a href="../register.jsp">Register</a></p>
        </form>
    </div>
</div>
</body>
</html>