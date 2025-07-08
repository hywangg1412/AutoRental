<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
              <div class="dropdown me-2">
                <button class="btn btn-link nav-link p-0 text-dark position-relative" type="button" id="userNotificationDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                  <i class="bi bi-bell" style="font-size: 1.2rem !important; color: white;"></i>
                  <c:if test="${sessionScope.userUnreadCount > 0}">
                    <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger" style="font-size: 0.7rem;">
                      ${sessionScope.userUnreadCount}
                    </span>
                  </c:if>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userNotificationDropdown">
                  <li class="dropdown-header" style="font-weight: bold; font-size: 1.1rem; color: #222;">Notifications</li>
                  <li><hr class="dropdown-divider"></li>
                  <c:choose>
                    <c:when test="${not empty sessionScope.userNotifications}">
                      <c:forEach var="noti" items="${sessionScope.userNotifications}">
                        <li>
                          <a class="dropdown-item notification-item ${noti.read ? 'read' : 'unread'}"
                             href="#"
                             data-notification-id="${noti.notificationId}">
                            <div class="notification-content">
                              <div class="notification-row">
                                <div class="notification-title">
                                  <c:out value="${noti.message}" />
                                </div>
                                <c:if test="${!noti.read}">
                                  <span class="dot-unread"></span>
                                </c:if>
                              </div>
                              <small class="text-muted">${fn:substring(noti.createdDate, 0, 10)}</small>
                            </div>
                          </a>
                        </li>
                      </c:forEach>
                    </c:when>
                    <c:otherwise>
                      <li><span class="dropdown-item text-muted">No new notifications</span></li>
                    </c:otherwise>
                  </c:choose>
                </ul>
              </div>
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
                  <li><a class="dropdown-item" href="${pageContext.request.contextPath}/pages/user/favorite-car.jsp">Favorite Cars</a></li> 
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

<!-- Include user notification JavaScript -->
<script src="${pageContext.request.contextPath}/scripts/common/user-notification.js"></script>

<!-- Debug -->
<!-- UserId: <c:out value="${sessionScope.userId}"/><br>
Notifications: <c:out value="${fn:length(sessionScope.userNotifications)}"/><br>
UnreadCount: <c:out value="${sessionScope.userUnreadCount}"/><br> -->