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
    </head>
    <body>
        <jsp:include page="includes/nav.jsp"/>

        <section class="hero-wrap hero-wrap-2 js-fullheight" style="background-image: url('images/bg_3.jpg');" data-stellar-background-ratio="0.5">
            <div class="overlay"></div>
            <div class="container">
                <div class="row no-gutters slider-text js-fullheight align-items-end justify-content-start">
                    <div class="col-md-9 ftco-animate pb-5">
                        <p class="breadcrumbs"><span class="mr-2"><a href="index.jsp">Home <i class="ion-ios-arrow-forward"></i></a></span> <span>Cars <i class="ion-ios-arrow-forward"></i></span></p>
                        <h1 class="mb-3 bread">Choose Your Car</h1>
                    </div>
                </div>
            </div>
        </section>

        <section class="ftco-section bg-light">
            <div class="container">
                <div class="row">
                    <!-- Sidebar bộ lọc -->
                    <div class="col-md-3">
                        <form method="get" action="car" id="filterForm" class="bg-white p-3 rounded shadow-sm mb-4">
                            <h5 class="mb-3 font-weight-bold">Filter</h5>
                            <!-- Hãng xe -->
                            <div class="mb-3">
                                <h6>Car Brand</h6>
                                <c:forEach var="brand" items="${brandList}">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="brandId" value="${brand.brandId}"
                                            <c:if test="${paramValues.brandId != null && fn:contains(paramValues.brandId, brand.brandId)}">checked</c:if>
                                            id="brand${brand.brandId}">
                                        <label class="form-check-label" for="brand${brand.brandId}">${brand.brandName}</label>
                                    </div>
                                </c:forEach>
                            </div>
                            <!-- Hộp số -->
                            <div class="mb-3">
                                <h6>Transmission Type</h6>
                                <c:forEach var="trans" items="${transmissionTypeList}">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="transmissionTypeId" value="${trans.transmissionTypeId}"
                                            <c:if test="${paramValues.transmissionTypeId != null && fn:contains(paramValues.transmissionTypeId, trans.transmissionTypeId)}">checked</c:if>
                                            id="trans${trans.transmissionTypeId}">
                                        <label class="form-check-label" for="trans${trans.transmissionTypeId}">${trans.transmissionName}</label>
                                    </div>
                                </c:forEach>
                            </div>
                            <!-- Nhiên liệu -->
                            <div class="mb-3">
                                <h6>Fuel Type</h6>
                                <c:forEach var="fuel" items="${fuelTypeList}">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="fuelTypeId" value="${fuel.fuelTypeId}"
                                            <c:if test="${paramValues.fuelTypeId != null && fn:contains(paramValues.fuelTypeId, fuel.fuelTypeId)}">checked</c:if>
                                            id="fuel${fuel.fuelTypeId}">
                                        <label class="form-check-label" for="fuel${fuel.fuelTypeId}">${fuel.fuelName}</label>
                                    </div>
                                </c:forEach>
                            </div>
                            <!-- Số ghế -->
                            <div class="mb-3">
                                <h6>Seats</h6>
                                <c:forEach var="seat" items="${seatList}">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="seat" value="${seat}"
                                            <c:if test="${paramValues.seat != null && fn:contains(paramValues.seat, seat)}">checked</c:if>
                                            id="seat${seat}">
                                        <label class="form-check-label" for="seat${seat}">${seat}</label>
                                    </div>
                                </c:forEach>
                            </div>
                            <!-- Loại xe -->
                            <div class="mb-3">
                                <h6>Car Categories</h6>
                                <c:forEach var="cat" items="${categoryList}">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="categoryId" value="${cat.categoryId}"
                                            <c:if test="${paramValues.categoryId != null && fn:contains(paramValues.categoryId, cat.categoryId)}">checked</c:if>
                                            id="cat${cat.categoryId}">
                                        <label class="form-check-label" for="cat${cat.categoryId}">${cat.categoryName}</label>
                                    </div>
                                </c:forEach>
                            </div>
                            <!-- Trạng thái -->
                            <div class="mb-3">
                                <h6>Status</h6>
                                <c:forEach var="status" items="${statusList}">
                                    <div class="form-check">
                                        <input class="form-check-input" type="checkbox" name="status" value="${status.value}"
                                            <c:if test="${paramValues.status != null && fn:contains(paramValues.status, status.value)}">checked</c:if>
                                            id="status${status.value}">
                                        <label class="form-check-label" for="status${status.value}">${status.display}</label>
                                    </div>
                                </c:forEach>
                            </div>
                            <!-- Tính năng (Feature) - collapsible -->
                            <div class="mb-3">
                                <h6 style="cursor:pointer;" onclick="toggleFeatureFilter()">
                                    Features
                                    <span id="feature-toggle-icon" style="font-size:1rem;">&#9660;</span>
                                </h6>
                                <div id="feature-filter-content">
                                    <c:forEach var="feature" items="${featureList}">
                                        <div class="form-check">
                                            <input class="form-check-input" type="checkbox" name="featureId" value="${feature.featureId}"
                                                <c:if test="${paramValues.featureId != null && fn:contains(paramValues.featureId, feature.featureId)}">checked</c:if>
                                                id="feature${feature.featureId}">
                                            <label class="form-check-label" for="feature${feature.featureId}">${feature.featureName}</label>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                            <!-- Khoảng giá -->
                            <div class="mb-3">
                                <h6>Price Range (VND/hour)</h6>
                                <div class="d-flex">
                                    <input type="number" class="form-control form-control-sm mr-2" name="minPrice" placeholder="From" value="${param.minPrice}">
                                    <input type="number" class="form-control form-control-sm" name="maxPrice" placeholder="To" value="${param.maxPrice}">
                                </div>
                            </div>
                            <!-- Năm sản xuất -->
                            <div class="mb-3">
                                <h6>Year Manufactured</h6>
                                <div class="d-flex">
                                    <input type="number" class="form-control form-control-sm mr-2" name="minYear" placeholder="From" value="${param.minYear}">
                                    <input type="number" class="form-control form-control-sm" name="maxYear" placeholder="To" value="${param.maxYear}">
                                </div>
                            </div>
                            <!-- Giữ lại keyword và sort khi lọc -->
                            <c:if test="${not empty param.keyword}"><input type="hidden" name="keyword" value="${param.keyword}"/></c:if>
                            <c:if test="${not empty param.sort}"><input type="hidden" name="sort" value="${param.sort}"/></c:if>
                            <button type="submit" class="btn btn-success w-100 mt-2">Filter Car</button>
                        </form>
                    </div>
                    <!-- Danh sách xe + sort + search -->
                    <div class="col-md-9">
                        <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap">
                            <!-- Search bar -->
                            <form class="form-inline mb-2" method="get" action="car" style="flex:1; min-width:250px;">
                                <input type="text" name="keyword" class="form-control mr-2 w-75" placeholder="Search by car name, car brand" value="${param.keyword}">
                                <!-- giữ lại filter/sort -->
                                <c:forEach var="brand" items="${paramValues.brandId}"><input type="hidden" name="brandId" value="${brand}"/></c:forEach>
                                <c:forEach var="fuel" items="${paramValues.fuelTypeId}"><input type="hidden" name="fuelTypeId" value="${fuel}"/></c:forEach>
                                <c:forEach var="seat" items="${paramValues.seat}"><input type="hidden" name="seat" value="${seat}"/></c:forEach>
                                <c:forEach var="cat" items="${paramValues.categoryId}"><input type="hidden" name="categoryId" value="${cat}"/></c:forEach>
                                <c:forEach var="st" items="${paramValues.status}"><input type="hidden" name="status" value="${st}"/></c:forEach>
                                <c:forEach var="feature" items="${paramValues.featureId}"><input type="hidden" name="featureId" value="${feature}"/></c:forEach>
                                <c:if test="${not empty param.sort}"><input type="hidden" name="sort" value="${param.sort}"/></c:if>
                                <button type="submit" class="btn btn-primary">Search</button>
                            </form>
                            <!-- Sort -->
                            <form method="get" action="car" class="mb-2 ml-3" id="sortForm">
                                <!-- giữ lại filter/search -->
                                <c:forEach var="brand" items="${paramValues.brandId}"><input type="hidden" name="brandId" value="${brand}"/></c:forEach>
                                <c:forEach var="fuel" items="${paramValues.fuelTypeId}"><input type="hidden" name="fuelTypeId" value="${fuel}"/></c:forEach>
                                <c:forEach var="seat" items="${paramValues.seat}"><input type="hidden" name="seat" value="${seat}"/></c:forEach>
                                <c:forEach var="cat" items="${paramValues.categoryId}"><input type="hidden" name="categoryId" value="${cat}"/></c:forEach>
                                <c:forEach var="st" items="${paramValues.status}"><input type="hidden" name="status" value="${st}"/></c:forEach>
                                <c:forEach var="feature" items="${paramValues.featureId}"><input type="hidden" name="featureId" value="${feature}"/></c:forEach>
                                <c:if test="${not empty param.keyword}"><input type="hidden" name="keyword" value="${param.keyword}"/></c:if>
                                <select name="sort" class="form-control" onchange="document.getElementById('sortForm').submit()">
                                    <option value="">Sort</option>
                                    <option value="priceAsc" ${param.sort == 'priceAsc' ? 'selected' : ''}>Price Ascending</option>
                                    <option value="priceDesc" ${param.sort == 'priceDesc' ? 'selected' : ''}>Price Descending</option>
                                    <option value="nameAsc" ${param.sort == 'nameAsc' ? 'selected' : ''}>Car Name A-Z</option>
                                    <option value="nameDesc" ${param.sort == 'nameDesc' ? 'selected' : ''}>Car Name Z-A</option>
                                    <option value="yearDesc" ${param.sort == 'yearDesc' ? 'selected' : ''}>Lastest Year Manufactured</option>
                                    <option value="yearAsc" ${param.sort == 'yearAsc' ? 'selected' : ''}>Oldest Year Manufactured</option>
                                </select>
                            </form>
                        </div>
                        <!-- Danh sách xe -->
                        <div class="row">
                            <c:forEach var="car" items="${carList}">
                                <div class="col-md-4">
                                    <div class="car-wrap rounded ftco-animate">
                                        <div class="img rounded d-flex align-items-end"
                                             style="background-image: url('${pageContext.request.contextPath}${car.mainImageUrl}');">
                                        </div>
                                        <div class="text">
                                            <div class="d-flex align-items-center mb-2">
                                                <h2 class="mb-0" style="font-size: 1.25rem;">
                                                    <a href="car-single.jsp?id=${car.carId}">${car.carModel}</a>
                                                </h2>
                                                <span class="car-status-inline ${car.statusCssClass}" style="margin-left:10px;">${car.statusDisplay}</span>
                                            </div>
                                            <div class="d-flex mb-3">
                                                <span class="cat">${car.brandName}</span>
                                                <p class="price ml-auto">
                                                    <fmt:formatNumber value="${car.pricePerHour * 1000}" type="number" pattern="#,###" />
                                                    <span>&nbsp;VND/hour</span>
                                                </p>
                                            </div>
                                            <p class="d-flex mb-0 d-block">
                                                <a href="${pageContext.request.contextPath}/booking/form/details?id=${car.carId}" class="btn btn-book-now py-2 mr-1">Book now</a>
                                                <a href="${pageContext.request.contextPath}/pages/car-single?id=${car.carId}" class="btn btn-details py-2 mr-1">Details</a>
                                                <a href="${pageContext.request.contextPath}/pages/add-to-cart?id=${car.carId}" class="btn btn-add-to-cart py-2 ml-1">Add to Cart</a>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty carList}">
                                <div class="col-12 text-center text-danger mb-4">Không tìm thấy xe phù hợp!</div>
                            </c:if>
                        </div>
                        <!-- Phân trang -->
                        <div class="row mt-5">
                            <div class="col text-center">
                                <div class="block-27">
                                    <ul>
                                        <c:if test="${currentPage > 1}">
                                            <li>
                                                <a href="?page=${currentPage - 1}
                                                    <c:forEach var='brand' items='${paramValues.brandId}'> &brandId=${brand}</c:forEach>
                                                    <c:forEach var='fuel' items='${paramValues.fuelTypeId}'> &fuelTypeId=${fuel}</c:forEach>
                                                    <c:forEach var='seat' items='${paramValues.seat}'> &seat=${seat}</c:forEach>
                                                    <c:forEach var='cat' items='${paramValues.categoryId}'> &categoryId=${cat}</c:forEach>
                                                    <c:forEach var='st' items='${paramValues.status}'> &status=${st}</c:forEach>
                                                    <c:forEach var='feature' items='${paramValues.featureId}'> &featureId=${feature}</c:forEach>
                                                    <c:if test='${not empty param.sort}'> &sort=${param.sort}</c:if>
                                                    <c:if test='${not empty param.keyword}'> &keyword=${param.keyword}</c:if>
                                                ">&lt;</a>
                                            </li>
                                        </c:if>
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="${i == currentPage ? 'active' : ''}">
                                                <a href="?page=${i}
                                                    <c:forEach var='brand' items='${paramValues.brandId}'> &brandId=${brand}</c:forEach>
                                                    <c:forEach var='fuel' items='${paramValues.fuelTypeId}'> &fuelTypeId=${fuel}</c:forEach>
                                                    <c:forEach var='seat' items='${paramValues.seat}'> &seat=${seat}</c:forEach>
                                                    <c:forEach var='cat' items='${paramValues.categoryId}'> &categoryId=${cat}</c:forEach>
                                                    <c:forEach var='st' items='${paramValues.status}'> &status=${st}</c:forEach>
                                                    <c:forEach var='feature' items='${paramValues.featureId}'> &featureId=${feature}</c:forEach>
                                                    <c:if test='${not empty param.sort}'> &sort=${param.sort}</c:if>
                                                    <c:if test='${not empty param.keyword}'> &keyword=${param.keyword}</c:if>
                                                ">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <c:if test="${currentPage < totalPages}">
                                            <li>
                                                <a href="?page=${currentPage + 1}
                                                    <c:forEach var='brand' items='${paramValues.brandId}'> &brandId=${brand}</c:forEach>
                                                    <c:forEach var='fuel' items='${paramValues.fuelTypeId}'> &fuelTypeId=${fuel}</c:forEach>
                                                    <c:forEach var='seat' items='${paramValues.seat}'> &seat=${seat}</c:forEach>
                                                    <c:forEach var='cat' items='${paramValues.categoryId}'> &categoryId=${cat}</c:forEach>
                                                    <c:forEach var='st' items='${paramValues.status}'> &status=${st}</c:forEach>
                                                    <c:forEach var='feature' items='${paramValues.featureId}'> &featureId=${feature}</c:forEach>
                                                    <c:if test='${not empty param.sort}'> &sort=${param.sort}</c:if>
                                                    <c:if test='${not empty param.keyword}'> &keyword=${param.keyword}</c:if>
                                                ">&gt;</a>
                                            </li>
                                        </c:if>
                                    </ul>
                                </div>
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
    </body>
</html>