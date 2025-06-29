<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
              rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
              rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css"
              rel="stylesheet">
        <link
            href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap"
            rel="stylesheet">

        <!-- ===== Page Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">

                        <!-- <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/car/car.css"> -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/car.css">

        <!-- ===== Custom Styles (Theme/Plugins) ===== -->
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/open-iconic-bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/animate.css">
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/owl.carousel.min.css">
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/owl.theme.default.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/magnific-popup.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/aos.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/ionicons.min.css">
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/bootstrap-datepicker.css">
        <link rel="stylesheet"
              href="${pageContext.request.contextPath}/assets/css/jquery.timepicker.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/flaticon.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/icomoon.css">

        <!-- ===== NavBar Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/nav.css">

        <!-- Thêm vào phần <head> -->
        <link rel="stylesheet"
              href="https://cdn.jsdelivr.net/npm/nouislider@15.7.1/dist/nouislider.min.css">
        <script src="https://cdn.jsdelivr.net/npm/nouislider@15.7.1/dist/nouislider.min.js"></script>
    </head>

    <body class="car-page">
        <div class="container" ;">
            <jsp:include page="../includes/car-nav.jsp" />
        </div>
        <section class="ftco-section bg-light">
            <div class="container" style="max-width: 1140px; margin-top: 80px;">
                <div class="mb-4">
                    <div class="filter-bar d-flex justify-content-between align-items-center mb-3"
                         style="padding: 0 0;">
                        <div class="filter-group-left d-flex align-items-center gap-2">
                            <!-- Brand, Type, Transmission, Fuel, Status, Feature -->
                            <button class="reset-filter-btn" type="button" id="resetFilterBtn" title="Reset filters">
                                <i class="bi bi-arrow-clockwise"></i>
                            </button>
                            <div class="dropdown">
                                <button type="button" class="filter-btn" data-bs-toggle="dropdown"
                                        aria-expanded="false">
                                    <i class="bi bi-globe"></i> Brand
                                </button>
                                <ul class="dropdown-menu">
                                    <c:forEach var="brand" items="${brandList}">
                                        <li>
                                            <label class="dropdown-item">
                                                <input type="checkbox" name="brandId"
                                                       value="${brand.brandId}" <c:if
                                                           test="${paramValues.brandId != null && fn:contains(paramValues.brandId, brand.brandId)}">checked
                                                       </c:if>>
                                                ${brand.brandName}
                                            </label>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                            <div class="dropdown">
                                <button type="button" class="filter-btn" data-bs-toggle="dropdown"
                                        aria-expanded="false">
                                    <i class="bi bi-car-front"></i> Type
                                </button>
                                <ul class="dropdown-menu">
                                    <c:forEach var="cat" items="${categoryList}">
                                        <li>
                                            <label class="dropdown-item">
                                                <input type="checkbox" name="categoryId"
                                                       value="${cat.categoryId}" <c:if
                                                           test="${paramValues.categoryId != null && fn:contains(paramValues.categoryId, cat.categoryId)}">checked
                                                       </c:if>>
                                                ${cat.categoryName}
                                            </label>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                            <div class="dropdown">
                                <button type="button" class="filter-btn" data-bs-toggle="dropdown"
                                        aria-expanded="false">
                                    <i class="bi bi-gear"></i> Transmission
                                </button>
                                <ul class="dropdown-menu">
                                    <c:forEach var="trans" items="${transmissionTypeList}">
                                        <li>
                                            <label class="dropdown-item">
                                                <input type="checkbox" name="transmissionTypeId"
                                                       value="${trans.transmissionTypeId}" <c:if
                                                           test="${paramValues.transmissionTypeId != null && fn:contains(paramValues.transmissionTypeId, trans.transmissionTypeId)}">checked
                                                       </c:if>>
                                                ${trans.transmissionName}
                                            </label>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                            <div class="dropdown">
                                <button type="button" class="filter-btn" data-bs-toggle="dropdown"
                                        aria-expanded="false">
                                    <i class="bi bi-fuel-pump"></i> Fuel
                                </button>
                                <ul class="dropdown-menu">
                                    <c:forEach var="fuel" items="${fuelTypeList}">
                                        <li>
                                            <label class="dropdown-item">
                                                <input type="checkbox" name="fuelTypeId"
                                                       value="${fuel.fuelTypeId}" <c:if
                                                           test="${paramValues.fuelTypeId != null && fn:contains(paramValues.fuelTypeId, fuel.fuelTypeId)}">checked
                                                       </c:if>>
                                                ${fuel.fuelName}
                                            </label>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                            <div class="dropdown">
                                <button type="button" class="filter-btn" data-bs-toggle="dropdown"
                                        aria-expanded="false">
                                    <i class="bi bi-info-circle"></i> Status
                                </button>
                                <ul class="dropdown-menu">
                                    <c:forEach var="status" items="${statusList}">
                                        <li>
                                            <label class="dropdown-item">
                                                <input type="checkbox" name="status"
                                                       value="${status.value}" <c:if
                                                           test="${paramValues.status != null && fn:contains(paramValues.status, status.value)}">checked
                                                       </c:if>>
                                                ${status.display}
                                            </label>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>
                            <div class="dropdown">
                                <button type="button" class="filter-btn" data-bs-toggle="dropdown"
                                        aria-expanded="false">
                                    <i class="bi bi-stars"></i> Feature
                                </button>
                                <ul class="dropdown-menu">
                                    <c:forEach var="feature" items="${featureList}">
                                        <li>
                                            <label class="dropdown-item">
                                                <input type="checkbox" name="featureId"
                                                       value="${feature.featureId}" <c:if
                                                           test="${paramValues.featureId != null && fn:contains(paramValues.featureId, feature.featureId)}">checked
                                                       </c:if>>
                                                ${feature.featureName}
                                            </label>
                                        </li>
                                    </c:forEach>
                                </ul>
                            </div>

                        </div>
                        <div class="filter-group-right">
                            <button type="button" class="filter-btn-adv" data-bs-toggle="modal"
                                    data-bs-target="#advancedFilterModal">
                                <i class="bi bi-sliders"></i> <b>Advanced Filter</b>
                            </button>
                        </div>
                    </div>
                </div>

                <form method="get" action="${pageContext.request.contextPath}/pages/car-list-fragment" style="width:100%;">
                    <div class="search-sort-bar d-flex align-items-center" style="max-width: 520px; margin: 0 auto 24px auto;">
                        <input type="text" name="keyword" class="search-input flex-grow-1" placeholder="Search car, brand..." value="${param.keyword}" style="border:none; outline:none; background:transparent; font-size:1rem; height:44px; padding-left:18px; border-radius:24px 0 0 24px;">
                        <button class="search-btn" type="submit" title="Search" style="border-radius:0; border-left:1.5px solid #e0e7ef; min-width:44px; height:44px;">
                            <i class="bi bi-search"></i>
                        </button>
                        <select name="sort" id="sortSelect" class="sort-select" style="border:none; border-left:1.5px solid #e0e7ef; border-radius:0 24px 24px 0; min-width:110px; height:44px; font-size:1rem; background:#fff; color:#222;">
                            <option value="" ${empty param.sort ? 'selected' : '' }>Default</option>
                            <option value="priceAsc" ${param.sort=='priceAsc' ? 'selected' : '' }>Price ↑</option>
                            <option value="priceDesc" ${param.sort=='priceDesc' ? 'selected' : '' }>Price ↓</option>
                            <option value="nameAsc" ${param.sort=='nameAsc' ? 'selected' : '' }>A-Z</option>
                            <option value="nameDesc" ${param.sort=='nameDesc' ? 'selected' : '' }>Z-A</option>
                            <option value="yearDesc" ${param.sort=='yearDesc' ? 'selected' : '' }>Year ↓</option>
                            <option value="yearAsc" ${param.sort=='yearAsc' ? 'selected' : '' }>Year ↑</option>
                        </select>
                    </div>
                </form>

                <!-- MODAL BỘ LỌC NÂNG CAO (khoảng giá, năm sản xuất) -->
                <div class="modal fade" id="advancedFilterModal" tabindex="-1"
                     aria-labelledby="advancedFilterModalLabel" aria-hidden="true">
                    <div class="modal-dialog modal-lg">
                        <div class="modal-content">
                            <form method="get" action="${pageContext.request.contextPath}/pages/car-list-fragment">
                                <div class="modal-header">
                                    <h5 class="modal-title" id="advancedFilterModalLabel">Advanced
                                        Filter</h5>
                                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                </div>
                                <div class="modal-body">
                                    <div class="row g-3">
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Price range
                                                (VND/hour)</label>
                                            <div class="d-flex align-items-center gap-2">
                                                <input type="number" class="form-control"
                                                       name="minPrice" placeholder="From"
                                                       value="${param.minPrice != null ? param.minPrice : ''}">
                                                <span>-</span>
                                                <input type="number" class="form-control"
                                                       name="maxPrice" placeholder="To"
                                                       value="${param.maxPrice != null ? param.maxPrice : ''}">
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <label class="form-label fw-bold">Manufacture year</label>
                                            <div class="d-flex align-items-center gap-2">
                                                <input type="number" class="form-control" name="minYear"
                                                       placeholder="From"
                                                       value="${param.minYear != null ? param.minYear : ''}">
                                                <span>-</span>
                                                <input type="number" class="form-control" name="maxYear"
                                                       placeholder="To"
                                                       value="${param.maxYear != null ? param.maxYear : ''}">
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-success w-100">Apply
                                        filter</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Danh sách xe -->
                <div id="car-list-container">
                    <jsp:include page="car-list-fragment.jsp" />
                </div>
            </div>
        </section>

        <jsp:include page="../includes/footer.jsp" />

        <div id="ftco-loader" class="show fullscreen" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(255,255,255,0.9); display: none; justify-content: center; align-items: center; z-index: 9999;">
            <svg class="circular" width="48px" height="48px">
            <circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4"
                    stroke="#eeeeee" />
            <circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4"
                    stroke-miterlimit="10" stroke="#F96D00" />
            </svg>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery-migrate-3.0.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.easing.1.3.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.waypoints.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.stellar.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/owl.carousel.min.js"></script>
        <script
        src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/aos.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.animateNumber.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/bootstrap-datepicker.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/jquery.timepicker.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/scrollax.min.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
        <script src="${pageContext.request.contextPath}/scripts/car/car.js"></script>
        <!-- Toast notification -->
        <div id="favorite-toast"></div>
        <script>
          var contextPath = '${pageContext.request.contextPath}';
        </script>
    </body>

</html>