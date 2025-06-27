<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Carbook - Choose Your Car</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <!-- ===== External CSS Libraries ===== -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap" rel="stylesheet">

        <!-- ===== Page Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/car.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/car/car.css">

        <!-- ===== Custom Styles (Theme/Plugins) ===== -->
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

        <!-- ===== NavBar Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/nav.css">

        <!-- Thêm vào phần <head> -->
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/nouislider@15.7.1/dist/nouislider.min.css">
        <script src="https://cdn.jsdelivr.net/npm/nouislider@15.7.1/dist/nouislider.min.js"></script>
    </head>
    <body>
        <jsp:include page="includes/car-nav.jsp"/>

        <section class="ftco-section bg-light">
            <div class="container" style="max-width: 1140px; margin-top: 50px;">
                <div class="mb-4">
                    <div class="filter-bar">
                        <form method="get" action="car" id="filterBarForm">
                            <div class="filter-group mb-3">
                                <!-- Brand -->
                                <div class="dropdown">
                                    <button type="button" class="filter-btn" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="bi bi-globe"></i> Brand
                                    </button>
                                    <ul class="dropdown-menu">
                                        <c:forEach var="brand" items="${brandList}">
                                            <li>
                                                <label class="dropdown-item">
                                                    <input type="checkbox" name="brandId" value="${brand.brandId}" <c:if test="${paramValues.brandId != null && fn:contains(paramValues.brandId, brand.brandId)}">checked</c:if>>
                                                    ${brand.brandName}
                                                </label>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                                <!-- Type -->
                                <div class="dropdown">
                                    <button type="button" class="filter-btn" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="bi bi-car-front"></i> Type
                                    </button>
                                    <ul class="dropdown-menu">
                                        <c:forEach var="cat" items="${categoryList}">
                                            <li>
                                                <label class="dropdown-item">
                                                    <input type="checkbox" name="categoryId" value="${cat.categoryId}" <c:if test="${paramValues.categoryId != null && fn:contains(paramValues.categoryId, cat.categoryId)}">checked</c:if>>
                                                    ${cat.categoryName}
                                                </label>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                                <!-- Transmission -->
                                <div class="dropdown">
                                    <button type="button" class="filter-btn" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="bi bi-gear"></i> Transmission
                                    </button>
                                    <ul class="dropdown-menu">
                                        <c:forEach var="trans" items="${transmissionTypeList}">
                                            <li>
                                                <label class="dropdown-item">
                                                    <input type="checkbox" name="transmissionTypeId" value="${trans.transmissionTypeId}" <c:if test="${paramValues.transmissionTypeId != null && fn:contains(paramValues.transmissionTypeId, trans.transmissionTypeId)}">checked</c:if>>
                                                    ${trans.transmissionName}
                                                </label>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                                <!-- Fuel -->
                                <div class="dropdown">
                                    <button type="button" class="filter-btn" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="bi bi-fuel-pump"></i> Fuel
                                    </button>
                                    <ul class="dropdown-menu">
                                        <c:forEach var="fuel" items="${fuelTypeList}">
                                            <li>
                                                <label class="dropdown-item">
                                                    <input type="checkbox" name="fuelTypeId" value="${fuel.fuelTypeId}" <c:if test="${paramValues.fuelTypeId != null && fn:contains(paramValues.fuelTypeId, fuel.fuelTypeId)}">checked</c:if>>
                                                    ${fuel.fuelName}
                                                </label>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                                <!-- Status -->
                                <div class="dropdown">
                                    <button type="button" class="filter-btn" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="bi bi-info-circle"></i> Status
                                    </button>
                                    <ul class="dropdown-menu">
                                        <c:forEach var="status" items="${statusList}">
                                            <li>
                                                <label class="dropdown-item">
                                                    <input type="checkbox" name="status" value="${status.value}" <c:if test="${paramValues.status != null && fn:contains(paramValues.status, status.value)}">checked</c:if>>
                                                    ${status.display}
                                                </label>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                                <!-- Feature -->
                                <div class="dropdown">
                                    <button type="button" class="filter-btn" data-bs-toggle="dropdown" aria-expanded="false">
                                        <i class="bi bi-stars"></i> Feature
                                    </button>
                                    <ul class="dropdown-menu">
                                        <c:forEach var="feature" items="${featureList}">
                                            <li>
                                                <label class="dropdown-item">
                                                    <input type="checkbox" name="featureId" value="${feature.featureId}" <c:if test="${paramValues.featureId != null && fn:contains(paramValues.featureId, feature.featureId)}">checked</c:if>>
                                                    ${feature.featureName}
                                                </label>
                                            </li>
                                        </c:forEach>
                                    </ul>
                                </div>
                                <!-- Advanced Filter -->
                                <button type="button" class="filter-btn-adv" data-bs-toggle="modal" data-bs-target="#advancedFilterModal">
                                    <i class="bi bi-sliders"></i> <b>Advanced Filter</b>
                                </button>
                            </div>
                            <div class="filter-search-row">
                                <!-- Reset button riêng biệt -->
                                <button class="reset-filter-btn" type="button" id="resetFilterBtn" title="Reset filters">
                                    <i class="bi bi-arrow-clockwise"></i>
                                </button>
                                
                                <!-- Search input group -->
                                <div class="search-input-group">
                                    <input type="text" name="keyword" class="form-control" placeholder="Search car, brand..." value="${param.keyword}">
                                    <button class="btn-search" type="submit" title="Search">
                                        <i class="bi bi-search"></i>
                                    </button>
                                </div>
                                
                                <!-- Sort select -->
                                <select name="sort" id="sortSelect" class="sort-select" onchange="this.form.submit()">
                                    <option value="" ${empty param.sort ? 'selected' : ''}>Default</option>
                                    <option value="priceAsc" ${param.sort == 'priceAsc' ? 'selected' : ''}>Price ↑</option>
                                    <option value="priceDesc" ${param.sort == 'priceDesc' ? 'selected' : ''}>Price ↓</option>
                                    <option value="nameAsc" ${param.sort == 'nameAsc' ? 'selected' : ''}>A-Z</option>
                                    <option value="nameDesc" ${param.sort == 'nameDesc' ? 'selected' : ''}>Z-A</option>
                                    <option value="yearDesc" ${param.sort == 'yearDesc' ? 'selected' : ''}>Year ↓</option>
                                    <option value="yearAsc" ${param.sort == 'yearAsc' ? 'selected' : ''}>Year ↑</option>
                                </select>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- MODAL BỘ LỌC NÂNG CAO (khoảng giá, năm sản xuất) -->
                <div class="modal fade" id="advancedFilterModal" tabindex="-1" aria-labelledby="advancedFilterModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <form method="get" action="car">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="advancedFilterModalLabel">Advanced Filter</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Price range (VND/hour)</label>
                                            <div class="d-flex align-items-center gap-2">
                                                <input type="number" class="form-control" name="minPrice" placeholder="From" value="${param.minPrice != null ? param.minPrice : ''}">
                                                <span>-</span>
                                                <input type="number" class="form-control" name="maxPrice" placeholder="To" value="${param.maxPrice != null ? param.maxPrice : ''}">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Manufacture year</label>
                                            <div class="d-flex align-items-center gap-2">
                                                <input type="number" class="form-control" name="minYear" placeholder="From" value="${param.minYear != null ? param.minYear : ''}">
                                                <span>-</span>
                                                <input type="number" class="form-control" name="maxYear" placeholder="To" value="${param.maxYear != null ? param.maxYear : ''}">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-success w-100">Apply filter</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Danh sách xe -->
                <div>
                    <div>
                        <div class="row g-4">
                            <c:forEach var="car" items="${carList}">
                                <div class="col-lg-4 col-md-6 col-12 d-flex">
                                    <div class="car-wrap rounded ftco-animate h-100 w-100">
                                        <div class="img rounded d-flex align-items-end"
                                             style="background-image: url('${pageContext.request.contextPath}${car.mainImageUrl}'); position: relative; height: 220px; background-size: cover; background-position: center;">
                                            <button class="favorite-btn" type="button" title="Yêu thích" style="position: absolute; top: 15px; right: 15px; background: rgba(255,255,255,0.9); border: none; border-radius: 50%; width: 40px; height: 40px; display: flex; align-items: center; justify-content: center;">
                                                <i class="bi bi-heart"></i>
                                            </button>
                                        </div>
                                        <div class="text p-3">
                                            <div class="car-title-row d-flex align-items-center justify-content-between mb-2">
                                                <h2 class="mb-0 flex-grow-1" style="font-size: 1.1rem; font-weight: 600;">
                                                    <a href="${pageContext.request.contextPath}/pages/car-single?id=${car.carId}" class="text-decoration-none text-dark">${car.carModel}</a>
                                                </h2>
                                                <span class="car-status-inline ${car.statusCssClass} badge ms-2">${car.statusDisplay}</span>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-center mb-3">
                                                <span class="cat text-muted small">${car.brandName}</span>
                                                <p class="price mb-0 fw-bold text-primary">
                                                    <fmt:formatNumber value="${car.pricePerHour * 1000}" type="number" pattern="#,###" />
                                                    <span class="small">&nbsp;VND/h</span>
                                                </p>
                                            </div>
                                            <div class="d-grid gap-2">
                                                <div class="row g-1">
                                                    <div class="col-12">
                                                        <a href="${pageContext.request.contextPath}/booking/form/details?id=${car.carId}" class="btn btn-primary btn-sm w-100">Book now</a>
                                                    </div>
                                                </div>
                                                <div class="row g-1">
                                                    <div class="col-6">
                                                        <a href="${pageContext.request.contextPath}/pages/car-single?id=${car.carId}" class="btn btn-outline-secondary btn-sm w-100">Details</a>
                                                    </div>
                                                    <div class="col-6">
                                                        <a href="${pageContext.request.contextPath}/pages/add-to-cart?id=${car.carId}" class="btn btn-outline-primary btn-sm w-100">Add Cart</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty carList}">
                                <div class="col-12 text-center">
                                    <div class="alert alert-info">
                                        <i class="bi bi-info-circle me-2"></i>
                                        No cars found matching your search criteria!
                                    </div>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Phân trang -->
                    <div class="row mt-5">
                        <div class="col text-center">
                            <div class="block-27">
                                <ul class="pagination justify-content-center">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage - 1}&keyword=${param.keyword}<c:forEach var='brand' items='${paramValues.brandId}'>&brandId=${brand}</c:forEach><c:forEach var='fuel' items='${paramValues.fuelTypeId}'>&fuelTypeId=${fuel}</c:forEach><c:forEach var='cat' items='${paramValues.categoryId}'>&categoryId=${cat}</c:forEach><c:forEach var='st' items='${paramValues.status}'>&status=${st}</c:forEach><c:forEach var='feature' items='${paramValues.featureId}'>&featureId=${feature}</c:forEach><c:if test='${not empty param.sort}'>&sort=${param.sort}</c:if>">&laquo;</a>
                                        </li>
                                    </c:if>
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <c:choose>
                                            <c:when test="${currentPage eq i}">
                                                <li class="page-item active"><span class="page-link">${i}</span></li>
                                            </c:when>
                                            <c:otherwise>
                                                <li class="page-item"><a class="page-link" href="?page=${i}&keyword=${param.keyword}<c:forEach var='brand' items='${paramValues.brandId}'>&brandId=${brand}</c:forEach><c:forEach var='fuel' items='${paramValues.fuelTypeId}'>&fuelTypeId=${fuel}</c:forEach><c:forEach var='cat' items='${paramValues.categoryId}'>&categoryId=${cat}</c:forEach><c:forEach var='st' items='${paramValues.status}'>&status=${st}</c:forEach><c:forEach var='feature' items='${paramValues.featureId}'>&featureId=${feature}</c:forEach><c:if test='${not empty param.sort}'>&sort=${param.sort}</c:if>">${i}</a></li>
                                            </c:otherwise>
                                        </c:choose>
                                    </c:forEach>
                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="?page=${currentPage + 1}&keyword=${param.keyword}<c:forEach var='brand' items='${paramValues.brandId}'>&brandId=${brand}</c:forEach><c:forEach var='fuel' items='${paramValues.fuelTypeId}'>&fuelTypeId=${fuel}</c:forEach><c:forEach var='cat' items='${paramValues.categoryId}'>&categoryId=${cat}</c:forEach><c:forEach var='st' items='${paramValues.status}'>&status=${st}</c:forEach><c:forEach var='feature' items='${paramValues.featureId}'>&featureId=${feature}</c:forEach><c:if test='${not empty param.sort}'>&sort=${param.sort}</c:if>">&raquo;</a>
                                        </li>
                                    </c:if>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <jsp:include page="includes/footer.jsp" />

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
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/car.js"></script>
        <!-- Toast notification -->
        <div id="favorite-toast"></div>
        <script>
            document.getElementById('resetFilterBtn').onclick = function() {
                window.location.href = 'car';
            };
        </script>
    </body>
</html>