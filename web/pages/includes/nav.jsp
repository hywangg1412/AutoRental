<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light" id="ftco-navbar">
  <div class="container">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/pages/home">Auto<span>Rental</span></a>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#ftco-nav" aria-controls="ftco-nav"
      aria-expanded="false" aria-label="Toggle navigation">
      <span class="oi oi-menu"></span> Menu
    </button>

    <div class="collapse navbar-collapse" id="ftco-nav">
      <ul class="navbar-nav ml-auto">
        <li class="nav-item"><a href="${pageContext.request.contextPath}/pages/home" class="nav-link">Home</a></li>
        <li class="nav-item"><a href="${pageContext.request.contextPath}/pages/about.jsp" class="nav-link">About</a></li>
        <!-- <li class="nav-item"><a href="services.jsp" class="nav-link">Services</a></li> -->
        <!-- <li class="nav-item"><a href="pricing.jsp" class="nav-link">Pricing</a></li> -->
        <li class="nav-item"><a href="${pageContext.request.contextPath}/pages/car" class="nav-link">Cars</a></li>
        <!-- <li class="nav-item"><a href="blog.jsp" class="nav-link">Blog</a></li> -->
        <li class="nav-item"><a href="${pageContext.request.contextPath}/pages/contact.jsp" class="nav-link">Contact</a></li>
      </ul>
    </div>
    
    <div class="d-flex align-items-center ms-3">
      <div class="vr mx-8"></div>
      <c:choose>
        <c:when test="${sessionScope.isLoggedIn}">
          <div class="d-flex align-items-center justify-content-between w-100">
            <div class="d-flex align-items-center gap-3">
              <a href="#" class="nav-link p-0 text-dark"><i class="bi bi-bell" style="font-size: 1.2rem !important; color: white;"></i></a>
              <a href="#" class="nav-link p-0 text-dark"><i class="bi bi-chat-dots" style="font-size: 1.2rem !important; color: white;"></i></a>
              <a href="${pageContext.request.contextPath}/user/profile" class="user-avatar">
                <img src="${not empty sessionScope.user.avatarUrl ? sessionScope.user.avatarUrl : pageContext.request.contextPath.concat('/assets/images/default-avatar.png')}" 
                     alt="User Avatar" 
                     width="32" 
                     height="32" 
                     class="rounded-circle"
                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-avatar.png';">
              </a>
              <a href="${pageContext.request.contextPath}/user/profile" class="nav-link username-link text-dark d-flex align-items-center" style="padding: 0 !important;" >
                <span class="d-none d-md-inline">${sessionScope.user.username}</span>
              </a>
              <div class="dropdown">
                <button class="btn btn-link nav-link p-0 text-dark dropdown-toggle" type="button" id="userDropdown" aria-expanded="false">
                  <i class="bi bi-three-dots-vertical" style="font-size: 1.2rem !important; color: white;"></i>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                  <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile">Profile</a></li>
                  <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/my-trip">My Trips</a></li>
                  <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/favorite-car">Favorite Cars</a></li>
                  <li><hr class="dropdown-divider"></li>
                  <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">Logout</a></li>
                </ul>
              </div>
            </div>
          </div>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/pages/authen/SignIn.jsp" class="btn custom-login-btn px-4 me-0">Login</a>
          <a href="${pageContext.request.contextPath}/pages/authen/SignUp.jsp" class="btn custom-signup-btn px-4 ms-2">Sign Up</a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</nav>
<!-- END nav -->

<!-- Include dropdown JavaScript -->
<script src="${pageContext.request.contextPath}/scripts/common/nav-dropdown.js"></script>