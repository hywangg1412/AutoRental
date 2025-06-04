<nav class="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light" id="ftco-navbar">
  <div class="container">
    <a class="navbar-brand" href="index.jsp">Auto<span>Rental</span></a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#ftco-nav" aria-controls="ftco-nav"
      aria-expanded="false" aria-label="Toggle navigation">
      <span class="oi oi-menu"></span> Menu
    </button>

    
    <div class="collapse navbar-collapse" id="ftco-nav">
      <ul class="navbar-nav ml-auto">
        <li class="nav-item"><a href="index.jsp" class="nav-link">Home</a></li>
        <li class="nav-item"><a href="about.jsp" class="nav-link">About</a></li>
        <li class="nav-item"><a href="services.jsp" class="nav-link">Services</a></li>
        <li class="nav-item"><a href="pricing.jsp" class="nav-link">Pricing</a></li>
        <li class="nav-item"><a href="car.jsp" class="nav-link">Cars</a></li>
        <li class="nav-item"><a href="blog.jsp" class="nav-link">Blog</a></li>
        <li class="nav-item"><a href="contact.jsp" class="nav-link">Contact</a></li>
      </ul>
    </div>
    <div class="d-flex align-items-center ms-3">
      <div class="vr mx-8"></div>
      <a href="${pageContext.request.contextPath}/pages/authen/SignIn.jsp" class="btn custom-login-btn px-4 me-0">Login</a>
      <a href="${pageContext.request.contextPath}/pages/authen/SignUp.jsp" class="btn custom-signup-btn px-4 ms-2">Sign Up</a>
    </div>
  </div>
</nav>
<!-- END nav -->