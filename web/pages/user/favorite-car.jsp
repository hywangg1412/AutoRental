<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.util.*, Model.Entity.User.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/pages/authen/SignIn.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Favorite Cars - Auto Rental</title>

        <!-- ===== External CSS Libraries ===== -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap" rel="stylesheet">

        <!-- ===== Include Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/user-nav.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/user/favorite-car.css">

        <!-- ===== Custom Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/open-iconic-bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animate.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owl.carousel.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/owl.theme.default.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/magnific-popup.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/aos.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ionicons.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap-datepicker.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/jquery.timepicker.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/flaticon.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/icomoon.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/user/about.css">
        <style>
        .shadow-car-img {
            box-shadow: 0 4px 16px rgba(0,0,0,0.10), 0 1.5px 4px rgba(0,0,0,0.08);
        }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="/pages/includes/user-nav.jsp" />

        <div class="container">
            <div class="row g-5" style="margin-top: 80px">
                <!-- Sidebar -->
                <div class="col-lg-3 col-md-4">
                    <div class="sidebar">
                        <h2 class="h2 fw-bold mb-3">Hello !</h2>
                        <ul class="sidebar-menu">
                            <li><a href="${pageContext.request.contextPath}/user/profile" class="nav-link text-dark border-top-custom">
                                    <i class="bi bi-person text-dark"></i>
                                    My account
                                </a></li>
                            <li><a href="${pageContext.request.contextPath}/user/favorite-car-page" class="nav-link active text-dark">
                                    <i class="bi bi-heart text-dark"></i>
                                    Favorite cars
                                </a></li>
                            <li><a href="${pageContext.request.contextPath}/user/my-trip" class="nav-link text-dark">
                                    <i class="bi bi-car-front text-dark"></i>
                                    My trips
                                </a></li>
                            <li><a href="${pageContext.request.contextPath}/pages/user/change-password.jsp" class="nav-link text-dark border-top-custom">
                                    <i class="bi bi-lock text-dark"></i>
                                    Change password
                                </a></li>
                            <li><a href="${pageContext.request.contextPath}/pages/user/request-delete.jsp" class="nav-link text-dark border-bottom-custom">
                                    <i class="bi bi-trash text-dark"></i>
                                    Request account deletion
                                </a></li>
                            <li><a href="#" class="nav-link text-danger logoutBtn">
                                    <i class="bi bi-box-arrow-right"></i>
                                    Log out
                                </a></li>
                        </ul>
                    </div>
                </div>
                <!-- Main content -->
                <div class="col-lg-9 col-md-8">
                    <div class="main-content">
                        <div class="container mt-4">
                            <div class="row g-5">
                                <!-- Main Content -->
                                <div class="main-content p-4 mt-1">
                                    <!-- Page Header -->
                                    <div class="mb-4">
                                        <h1 class="h2 fw-semibold mb-0 text-dark">My Favorite Cars</h1>
                                    </div>

                                    <!-- Error Message -->
                                    <c:if test="${not empty errorMessage}">
                                        <div class="alert alert-danger" role="alert">
                                            <i class="bi bi-exclamation-triangle me-2"></i>
                                            ${errorMessage}
                                        </div>
                                    </c:if>

                                    <!-- Car Cards -->
                                    <div class="car-cards">
                                        <c:choose>
                                            <c:when test="${not empty favoriteCars}">
                                                <c:forEach var="car" items="${favoriteCars}">
                                                    <div class="favorite-car-card d-flex align-items-stretch p-4 mb-4 rounded shadow-sm bg-white">
                                                        <div class="car-img-wrapper">
                                                            <img src="${pageContext.request.contextPath}${car.mainImageUrl}" class="car-img" alt="Car image">
                                                        </div>
                                                        <div class="car-card-content flex-grow-1 ps-3 pe-4 d-flex flex-column justify-content-between">
                                                            <!-- Top: Tên xe + trạng thái -->
                                                            <div>
                                                                <div class="d-flex align-items-center mb-2">
                                                                    <div class="car-title-badge d-flex align-items-center">
                                                                        <h5 class="mb-0 fw-bold me-3">${car.carModel}</h5>
                                                                        <span class="badge status-badge ms-0 ${car.statusDisplay == 'Available' ? 'bg-success' : car.statusDisplay == 'Rented' ? 'bg-warning' : 'bg-danger'}">
                                                                            ${car.statusDisplay}
                                                                        </span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                            <!-- Middle: Thông tin -->
                                                            <div class="car-card-middle mb-2 text-muted small fs-7 d-flex align-items-center car-info-inline justify-content-start">
                                                                <span class="me-3"><i class="bi bi-gear me-1"></i>${car.transmissionName}</span>
                                                                <span class="me-3"><i class="bi bi-people me-1"></i>${car.seats} seats</span>
                                                                <span><i class="bi bi-fuel-pump me-1"></i>${car.fuelTypeName}</span>
                                                            </div>
                                                            <!-- Bottom: Giá -->
                                                            <div>
                                                                <span class="price-new fw-bold fs-6 text-success me-3" style="margin-bottom:0;">
                                                                    <fmt:formatNumber value="${car.pricePerDay}" type="number" pattern="#.###" /> VND/day
                                                                </span>
                                                                <span class="price-old text-muted text-decoration-line-through me-2" style="font-size: 1rem;">
                                                                    <!-- Show old price here if available -->
                                                                </span>
                                                            </div>
                                                        </div>
                                                        <div class="d-flex flex-column align-items-end justify-content-start ms-3">
                                                            <form method="post" action="${pageContext.request.contextPath}/user/favorite-car">
                                                                <input type="hidden" name="action" value="remove">
                                                                <input type="hidden" name="carId" value="${car.carId}">
                                                                <input type="hidden" name="source" value="favorite-car" />
                                                                <button type="submit" class="btn-favorite-action btn-unlike">Unlike</button>
                                                            </form>
                                                            <a href="${pageContext.request.contextPath}/pages/car-single?id=${car.carId}" class="btn-favorite-action btn-detail">View details</a>
                                                        </div>
                                                    </div>
                                                </c:forEach>
                                            </c:when>
                                            <c:otherwise>
                                                <div class="text-center py-5">
                                                    <i class="bi bi-heart text-muted" style="font-size: 3rem;"></i>
                                                    <h4 class="text-muted mt-3">No favorite cars yet</h4>
                                                    <p class="text-muted">Start adding cars to your favorites to see them here!</p>
                                                    <a href="${pageContext.request.contextPath}/pages/car" class="btn-browse-cars">
                                                        <i class="bi bi-car-front me-2"></i>Browse Cars
                                                    </a>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <!-- PHÂN TRANG -->
                                    <c:if test="${totalPages > 1}">
                                        <div class="row mt-5">
                                            <div class="col text-center">
                                                <div class="block-27">
                                                    <ul class="pagination justify-content-center">
                                                        <c:if test="${currentPage > 1}">
                                                            <li class="page-item">
                                                                <a class="page-link" href="${pageContext.request.contextPath}/user/favorite-car-page?page=${currentPage - 1}">&laquo;</a>
                                                            </li>
                                                        </c:if>
                                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                                            <c:choose>
                                                                <c:when test="${currentPage eq i}">
                                                                    <li class="page-item active"><span class="page-link">${i}</span></li>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <li class="page-item"><a class="page-link" href="${pageContext.request.contextPath}/user/favorite-car-page?page=${i}">${i}</a></li>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:forEach>
                                                        <c:if test="${currentPage < totalPages}">
                                                            <li class="page-item">
                                                                <a class="page-link" href="${pageContext.request.contextPath}/user/favorite-car-page?page=${currentPage + 1}">&raquo;</a>
                                                            </li>
                                                        </c:if>
                                                    </ul>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <jsp:include page="/pages/includes/footer.jsp" />

        <!-- Bootstrap JS -->
        <div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/></svg></div>

        <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery-migrate-3.0.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.easing.1.3.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.waypoints.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.stellar.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/aos.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.animateNumber.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap-datepicker.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.timepicker.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/scrollax.min.js"></script>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBVWaKrjvy3MaE7SQ74_uJiULgl1JY0H2s&sensor=false"></script>
        <script src="${pageContext.request.contextPath}/assets/js/google-map.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/scripts/user/UserAboutSidebar.js"></script>
        <script src="${pageContext.request.contextPath}/scripts/user/favorite-car.js"></script>
        <jsp:include page="/pages/includes/logout-confirm-modal.jsp" />
    </body>
</html>