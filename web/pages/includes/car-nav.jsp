<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Font Awesome -->
<link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
<!-- jQuery -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<nav class="navbar navbar-expand-lg navbar-dark ftco_navbar bg-dark ftco-navbar-light" id="ftco-navbar">
  <div class="container">
    <a class="navbar-brand" href="${pageContext.request.contextPath}/pages/home">Auto<span>Rental</span></a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#ftco-nav" aria-controls="ftco-nav"
      aria-expanded="false" aria-label="Toggle navigation">
      <span class="oi oi-menu"></span> Menu
    </button>

    <div class="collapse navbar-collapse" id="ftco-nav">
      <ul class="navbar-nav ml-auto">
        <li class="nav-item"><a href="${pageContext.request.contextPath}/pages/home" class="nav-link">Home</a></li>
        <!-- <li class="nav-item"><a href="${pageContext.request.contextPath}/pages/about.jsp" class="nav-link">About</a></li> -->
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
              <div class="dropdown me-2 notification-wrapper">
                <button class="btn btn-link nav-link p-0 text-dark position-relative notification-btn" type="button" id="userNotificationDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                  <i class="fas fa-bell" style="font-size: 1.2rem !important; color: #222 !important;"></i>
                  <span class="notification-count" style="display: ${sessionScope.userUnreadCount > 0 ? 'flex' : 'none'};">
                    ${sessionScope.userUnreadCount}
                  </span>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userNotificationDropdown" id="notificationDropdownMenu">
                  <li class="dropdown-header">Notifications</li>
                  <li><hr class="dropdown-divider"></li>
                  
                  <c:choose>
                    <c:when test="${not empty sessionScope.userNotifications}">
                      <c:forEach var="notification" items="${sessionScope.userNotifications}">
                        <li>
                          <a class="dropdown-item notification-item ${notification.isRead() ? 'read' : 'unread'} user-notification"
                             href="#"
                             data-notification-id="${notification.notificationId}">
                            <div class="notification-content">
                              <div class="notification-row">
                                <c:set var="iconClass" value="info-circle" />
                                <c:set var="iconColor" value="#17a2b8" />
                                
                                <c:if test="${fn:contains(fn:toLowerCase(notification.message), 'đã được duyệt')}">
                                  <c:set var="iconClass" value="check-circle" />
                                  <c:set var="iconColor" value="#28a745" />
                                </c:if>
                                <c:if test="${fn:contains(fn:toLowerCase(notification.message), 'từ chối')}">
                                  <c:set var="iconClass" value="times-circle" />
                                  <c:set var="iconColor" value="#dc3545" />
                                </c:if>
                                
                                <i class="fas fa-${iconClass}" style="color: ${iconColor}; margin-right: 8px;"></i>
                                <div class="notification-title">
                                  ${notification.message}
                                </div>
                                <c:if test="${!notification.isRead()}">
                                  <span class="dot-unread"></span>
                                </c:if>
                              </div>
                              <span class="notification-time">
                                <fmt:parseDate value="${notification.createdDate}" pattern="yyyy-MM-dd'T'HH:mm:ss" var="parsedDate" />
                                <fmt:formatDate value="${parsedDate}" pattern="dd-MM-yyyy HH:mm" />
                              </span>
                            </div>
                          </a>
                        </li>
                      </c:forEach>
                      
                      <c:if test="${sessionScope.userUnreadCount > 0}">
                        <li><hr class="dropdown-divider"></li>
                        <li>
                          <a class="dropdown-item text-center mark-all-read-btn" href="#">
                            <i class="fas fa-check-double"></i> Mark all as read
                          </a>
                        </li>
                      </c:if>
                    </c:when>
                    <c:otherwise>
                      <li><span class="dropdown-item text-muted">No new notifications</span></li>
                    </c:otherwise>
                  </c:choose>
                </ul>
              </div>
              <a href="https://www.facebook.com/share/16hwvT4v4y/" class="nav-link p-0 text-dark"><i class="fas fa-comment-dots" style="font-size: 1.2rem !important; color: #222;"></i></a>
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
                  <i class="fas fa-ellipsis-v" style="font-size: 1.2rem !important; color: #222;"></i>
                </button>
                <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
                  <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/profile">Profile</a></li>
                  <li><a class="dropdown-item" href="${pageContext.request.contextPath}/user/my-trip">My Trips</a></li>
                  <li><a class="dropdown-item" href="${pageContext.request.contextPath}/pages/user/favorite-car.jsp">Favorite Cars</a></li> 
                  <li><hr class="dropdown-divider"></li>
                  <li><a class="dropdown-item text-danger logoutBtn" href="#" style="cursor: pointer;">Logout</a></li>
                </ul>
              </div>
            </div>
          </div>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/pages/authen/SignUp.jsp" class="btn custom-signup-btn px-4 ms-2">Sign Up</a>
          <a href="${pageContext.request.contextPath}/pages/authen/SignIn.jsp" class="btn custom-login-btn px-4 me-0">Login</a>
        </c:otherwise>
      </c:choose>
    </div>
  </div>
</nav>
<!-- END nav -->

<!-- Thêm CSS cho thông báo -->
<!-- Đã xóa style nội tuyến, dùng file nav.css -->

<!-- Include dropdown JavaScript -->
<script src="${pageContext.request.contextPath}/scripts/common/nav-dropdown.js"></script>

<!-- Include notification JavaScript -->
<script src="${pageContext.request.contextPath}/scripts/common/notification.js"></script>

<!-- Include logout confirmation modal -->
<jsp:include page="logout-confirm-modal.jsp" />

<!-- Debug -->
<%-- 
UserId: <c:out value="${sessionScope.userId}"/>
Notifications: <c:out value="${fn:length(sessionScope.userNotifications)}"/>
UnreadCount: <c:out value="${sessionScope.userUnreadCount}"/>
--%>