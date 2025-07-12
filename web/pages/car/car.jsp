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
                        <!-- ===== NavBar Styles ===== -->
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/nav.css">
                        <!-- ===== Page Styles ===== -->
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/car/car.css">
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
                                            <button class="reset-filter-btn" type="button" id="resetFilterBtn"
                                                title="Reset filters">
                                                <i class="bi bi-arrow-clockwise"></i>
                                            </button>
                                            <div class="dropdown">
                                                <button type="button" class="filter-btn" data-bs-toggle="modal"
                                                    data-bs-target="#brandFilterModal">
                                                    <i class="bi bi-globe"></i> Brand
                                                </button>
                                            </div>
                                            <div class="dropdown">
                                                <button type="button" class="filter-btn" data-bs-toggle="modal"
                                                    data-bs-target="#categoryFilterModal">
                                                    <i class="bi bi-car-front"></i> Type
                                                </button>
                                            </div>
                                            <div class="dropdown">
                                                <button type="button" class="filter-btn" data-bs-toggle="modal"
                                                    data-bs-target="#transmissionFilterModal">
                                                    <i class="bi bi-gear"></i> Transmission
                                                </button>
                                            </div>
                                            <div class="dropdown">
                                                <button type="button" class="filter-btn" data-bs-toggle="modal"
                                                    data-bs-target="#fuelFilterModal">
                                                    <i class="bi bi-fuel-pump"></i> Fuel
                                                </button>
                                            </div>
                                            <div class="dropdown">
                                                <button type="button" class="filter-btn" data-bs-toggle="modal"
                                                    data-bs-target="#statusFilterModal">
                                                    <i class="bi bi-info-circle"></i> Status
                                                </button>
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

                                <form method="get" action="${pageContext.request.contextPath}/pages/car"
                                    style="width:100%;">
                                    <div class="search-sort-bar d-flex align-items-center"
                                        style="max-width: 520px; margin: 0 auto 24px auto;">
                                        <input type="text" name="keyword" class="search-input flex-grow-1"
                                            placeholder="Search car, brand..." value="${param.keyword}"
                                            style="border:none; outline:none; background:transparent; font-size:1rem; height:44px; padding-left:18px; border-radius:24px 0 0 24px;">
                                        <button class="search-btn" type="submit" title="Search"
                                            style="border-radius:0; border-left:1.5px solid #e0e7ef; min-width:44px; height:44px;">
                                            <i class="bi bi-search"></i>
                                        </button>
                                        <select name="sort" id="sortSelect" class="sort-select"
                                            style="border:none; border-left:1.5px solid #e0e7ef; border-radius:0 24px 24px 0; min-width:110px; height:44px; font-size:1rem; background:#fff; color:#222;">
                                            <option value="" ${empty param.sort ? 'selected' : '' }>Default</option>
                                            <option value="priceAsc" ${param.sort=='priceAsc' ? 'selected' : '' }>Price
                                                ↑</option>
                                            <option value="priceDesc" ${param.sort=='priceDesc' ? 'selected' : '' }>
                                                Price ↓</option>
                                            <option value="nameAsc" ${param.sort=='nameAsc' ? 'selected' : '' }>A-Z
                                            </option>
                                            <option value="nameDesc" ${param.sort=='nameDesc' ? 'selected' : '' }>Z-A
                                            </option>
                                            <option value="yearDesc" ${param.sort=='yearDesc' ? 'selected' : '' }>Year ↓
                                            </option>
                                            <option value="yearAsc" ${param.sort=='yearAsc' ? 'selected' : '' }>Year ↑
                                            </option>
                                        </select>
                                    </div>
                                </form>

                                <!-- MODAL BỘ LỌC NÂNG CAO (khoảng giá, năm sản xuất) -->
                                <div id="advancedFilterModal" class="modal fade" tabindex="-1">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h2>Advanced Filter</h2>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                                    aria-label="Close"></button>
                                            </div>
                                            <div class="modal-body">
                                                <form method="get"
                                                    action="${pageContext.request.contextPath}/pages/car">
                                                    <div class="modal-body pt-2 pb-0">
                                                        <!-- Sort -->
                                                        <div class="mb-4">
                                                            <label class="fw-bold mb-2 d-block">Sort</label>
                                                            <select class="form-select w-100" name="sort">
                                                                <option value="">Optimal</option>
                                                                <option value="priceAsc" ${param.sort=='priceAsc'
                                                                    ? 'selected' : '' }>Price ↑</option>
                                                                <option value="priceDesc" ${param.sort=='priceDesc'
                                                                    ? 'selected' : '' }>Price ↓</option>
                                                                <option value="nameAsc" ${param.sort=='nameAsc'
                                                                    ? 'selected' : '' }>A-Z</option>
                                                                <option value="nameDesc" ${param.sort=='nameDesc'
                                                                    ? 'selected' : '' }>Z-A</option>
                                                                <option value="yearDesc" ${param.sort=='yearDesc'
                                                                    ? 'selected' : '' }>Year ↓</option>
                                                                <option value="yearAsc" ${param.sort=='yearAsc'
                                                                    ? 'selected' : '' }>Year ↑</option>
                                                            </select>
                                                        </div>
                                                        <!-- Price (VND/hour) -->
                                                        <div class="mb-4">
                                                            <label class="fw-bold mb-2 d-block">Price (VND/hour)</label>
                                                            <div class="dual-range-container">
                                                                <div class="range-background"></div>
                                                                <div class="range-track" id="priceTrack"></div>
                                                                <input type="range" class="dual-range-slider" min="0"
                                                                    max="500" step="10" id="priceHourMinSlider"
                                                                    value="${param.minPricePerHour != null ? param.minPricePerHour : 0}">
                                                                <input type="range" class="dual-range-slider" min="0"
                                                                    max="500" step="10" id="priceHourMaxSlider"
                                                                    value="${param.maxPricePerHour != null ? param.maxPricePerHour : 500}">
                                                            </div>
                                                            <!-- <div class="d-flex justify-content-between mt-2">
                                                <span id="priceHourMinValue">0K</span>
                                                <span id="priceHourMaxValue">500K</span>
                                            </div> -->
                                                            <div class="d-flex justify-content-start mt-2">
                                                                <div id="priceHourRangeDisplay"
                                                                    style="border:1px solid #e0e0e0; border-radius:8px; padding:4px 16px; background:#fff; font-weight:500; min-width:120px; text-align:center; box-shadow:0 2px 8px rgba(0,0,0,0.03);">
                                                                    0K - 500K
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="minPricePerHour"
                                                                id="minPricePerHourInput"
                                                                value="${param.minPricePerHour}">
                                                            <input type="hidden" name="maxPricePerHour"
                                                                id="maxPricePerHourInput"
                                                                value="${param.maxPricePerHour}">
                                                        </div>
                                                        <!-- Transmission -->
                                                        <div class="mb-4">
                                                            <label class="fw-medium mb-2 d-block">Transmission</label>
                                                            <div class="row">
                                                                <div class="col-12 col-md-6 mb-2">
                                                                    <label
                                                                        class="form-check-label d-flex align-items-center p-3 border rounded w-100 transmission-hover"
                                                                        style="cursor: pointer; transition: all 0.2s;">
                                                                        <input type="radio"
                                                                            class="form-check-input me-3"
                                                                            name="transmissionTypeId" value="" <c:if
                                                                            test="${empty paramValues.transmissionTypeId || (paramValues.transmissionTypeId.length == 1 && paramValues.transmissionTypeId[0] == '')}">checked
                                                                        </c:if>>
                                                                        <span class="fw-medium flex-grow-1">All</span>
                                                                    </label>
                                                                </div>
                                                                <c:forEach var="trans" items="${transmissionTypeList}">
                                                                    <div class="col-12 col-md-6 mb-2">
                                                                        <label
                                                                            class="form-check-label d-flex align-items-center p-3 border rounded w-100 transmission-hover"
                                                                            style="cursor: pointer; transition: all 0.2s;">
                                                                            <input type="radio"
                                                                                class="form-check-input me-3"
                                                                                name="transmissionTypeId"
                                                                                value="${trans.transmissionTypeId}"
                                                                                <c:if
                                                                                test="${paramValues.transmissionTypeId != null && fn:indexOf(paramValues.transmissionTypeId, trans.transmissionTypeId) != -1 && !(paramValues.transmissionTypeId.length == 1 && paramValues.transmissionTypeId[0] == '')}">checked
                                                                            </c:if>>
                                                                            <span
                                                                                class="fw-medium flex-grow-1">${trans.transmissionName}</span>
                                                                        </label>
                                                                    </div>
                                                                </c:forEach>
                                                            </div>
                                                        </div>
                                                        <!-- Mileage -->
                                                        <div class="mb-4">
                                                            <label class="fw-bold mb-2 d-block">Mileage (km)</label>
                                                            <div class="dual-range-container">
                                                                <div class="range-background"></div>
                                                                <div class="range-track" id="mileageTrack"></div>
                                                                <input type="range" class="dual-range-slider" min="0"
                                                                    max="100000" step="1000" id="mileageMinSlider"
                                                                    value="${param.minOdometer != null ? param.minOdometer : 0}">
                                                                <input type="range" class="dual-range-slider" min="0"
                                                                    max="100000" step="1000" id="mileageMaxSlider"
                                                                    value="${param.maxOdometer != null ? param.maxOdometer : 100000}">
                                                            </div>
                                                            <div class="d-flex justify-content-start mt-2">
                                                                <div id="mileageRangeDisplay"
                                                                    style="border:1px solid #e0e0e0; border-radius:8px; padding:4px 16px; background:#fff; font-weight:500; min-width:140px; text-align:center; box-shadow:0 2px 8px rgba(0,0,0,0.03);">
                                                                    0 - 100,000 km
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="minOdometer"
                                                                id="minOdometerInput" value="${param.minOdometer}">
                                                            <input type="hidden" name="maxOdometer"
                                                                id="maxOdometerInput" value="${param.maxOdometer}">
                                                        </div>
                                                        <!-- Distance -->
                                                        <div class="mb-4">
                                                            <label class="fw-bold mb-2 d-block">Distance (km)</label>
                                                            <div class="dual-range-container">
                                                                <div class="range-background"></div>
                                                                <div class="range-track" id="distanceTrack"></div>
                                                                <input type="range" class="dual-range-slider" min="0"
                                                                    max="100" step="1" id="distanceMinSlider"
                                                                    value="${param.minDistance != null ? param.minDistance : 0}">
                                                                <input type="range" class="dual-range-slider" min="0"
                                                                    max="100" step="1" id="distanceMaxSlider"
                                                                    value="${param.maxDistance != null ? param.maxDistance : 100}">
                                                            </div>
                                                            <div class="d-flex justify-content-start mt-2">
                                                                <div id="distanceRangeDisplay"
                                                                    style="border:1px solid #e0e0e0; border-radius:8px; padding:4px 16px; background:#fff; font-weight:500; min-width:100px; text-align:center; box-shadow:0 2px 8px rgba(0,0,0,0.03);">
                                                                    0 - 100 km
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="minDistance"
                                                                id="minDistanceInput" value="${param.minDistance}">
                                                            <input type="hidden" name="maxDistance"
                                                                id="maxDistanceInput" value="${param.maxDistance}">
                                                        </div>
                                                        <!-- Seats -->
                                                        <div class="mb-4">
                                                            <label class="fw-bold mb-2 d-block">Seats</label>
                                                            <div class="dual-range-container">
                                                                <div class="range-background"></div>
                                                                <div class="range-track" id="seatsTrack"></div>
                                                                <input type="range" class="dual-range-slider" min="2"
                                                                    max="16" step="1" id="seatsMinSlider"
                                                                    value="${param.minSeats != null ? param.minSeats : 2}">
                                                                <input type="range" class="dual-range-slider" min="2"
                                                                    max="16" step="1" id="seatsMaxSlider"
                                                                    value="${param.maxSeats != null ? param.maxSeats : 16}">
                                                            </div>
                                                            <div class="d-flex justify-content-start mt-2">
                                                                <div id="seatsRangeDisplay"
                                                                    style="border:1px solid #e0e0e0; border-radius:8px; padding:4px 16px; background:#fff; font-weight:500; min-width:80px; text-align:center; box-shadow:0 2px 8px rgba(0,0,0,0.03);">
                                                                    2 - 16 seats
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="minSeats" id="minSeatsInput"
                                                                value="${param.minSeats}">
                                                            <input type="hidden" name="maxSeats" id="maxSeatsInput"
                                                                value="${param.maxSeats}">
                                                        </div>
                                                        <!-- Year -->
                                                        <div class="mb-4">
                                                            <label class="fw-bold mb-2 d-block">Year</label>
                                                            <div class="dual-range-container">
                                                                <div class="range-background"></div>
                                                                <div class="range-track" id="yearTrack"></div>
                                                                <input type="range" class="dual-range-slider" min="2000"
                                                                    max="2024" step="1" id="yearMinSlider"
                                                                    value="${param.minYear != null ? param.minYear : 2000}">
                                                                <input type="range" class="dual-range-slider" min="2000"
                                                                    max="2024" step="1" id="yearMaxSlider"
                                                                    value="${param.maxYear != null ? param.maxYear : 2024}">
                                                            </div>
                                                            <div class="d-flex justify-content-start mt-2">
                                                                <div id="yearRangeDisplay"
                                                                    style="border:1px solid #e0e0e0; border-radius:8px; padding:4px 16px; background:#fff; font-weight:500; min-width:100px; text-align:center; box-shadow:0 2px 8px rgba(0,0,0,0.03);">
                                                                    2000 - 2024
                                                                </div>
                                                            </div>
                                                            <input type="hidden" name="minYear" id="minYearInput"
                                                                value="${param.minYear}">
                                                            <input type="hidden" name="maxYear" id="maxYearInput"
                                                                value="${param.maxYear}">
                                                        </div>
                                                        <!-- Fuel type radio -->
                                                        <div class="mb-4">
                                                            <label class="fw-medium mb-2 d-block">Fuel Type</label>
                                                            <div class="row">
                                                                <div class="col-12 col-md-6 mb-2">
                                                                    <label
                                                                        class="form-check-label d-flex align-items-center p-3 border rounded w-100 fuel-hover"
                                                                        style="cursor: pointer; transition: all 0.2s;">
                                                                        <input type="radio"
                                                                            class="form-check-input me-3"
                                                                            name="fuelTypeId" value="" <c:choose>
                                                                        <c:when test="${empty paramValues.fuelTypeId}">
                                                                            checked</c:when>
                                                                        <c:when
                                                                            test="${paramValues.fuelTypeId[0] == ''}">
                                                                            checked</c:when>
                                                                        </c:choose>>
                                                                        <span class="fw-medium flex-grow-1">All</span>
                                                                    </label>
                                                                </div>
                                                                <c:forEach var="fuel" items="${fuelTypeList}">
                                                                    <div class="col-12 col-md-6 mb-2">
                                                                        <label
                                                                            class="form-check-label d-flex align-items-center p-3 border rounded w-100 fuel-hover"
                                                                            style="cursor: pointer; transition: all 0.2s;">
                                                                            <input type="radio"
                                                                                class="form-check-input me-3"
                                                                                name="fuelTypeId"
                                                                                value="${fuel.fuelTypeId}" <c:if
                                                                                test="${paramValues.fuelTypeId != null && fn:contains(paramValues.fuelTypeId, fuel.fuelTypeId)}">checked
                                                                            </c:if>>
                                                                            <span
                                                                                class="fw-medium flex-grow-1">${fuel.fuelName}</span>
                                                                        </label>
                                                                    </div>
                                                                </c:forEach>
                                                            </div>
                                                        </div>
                                                        <!-- Feature grid -->
                                                        <div class="mb-2">
                                                            <label class="fw-medium mb-2 d-block">Features</label>
                                                            <div class="row">
                                                                <c:forEach var="feature" items="${featureList}">
                                                                    <div class="col-12 col-md-6 mb-2">
                                                                        <label
                                                                            class="form-check-label d-flex align-items-center p-3 border rounded w-100"
                                                                            style="cursor: pointer; transition: all 0.2s;">
                                                                            <input type="checkbox"
                                                                                class="form-check-input me-3"
                                                                                name="featureId"
                                                                                value="${feature.featureId}" <c:if
                                                                                test="${paramValues.featureId != null && fn:contains(paramValues.featureId, feature.featureId)}">checked
                                                                            </c:if>>
                                                                            <span class="fw-medium flex-grow-1"
                                                                                style="white-space: normal; word-break: break-word;">${feature.featureName}</span>
                                                                        </label>
                                                                    </div>
                                                                </c:forEach>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <div
                                                        class="modal-footer border-0 pt-4 pb-4 d-flex flex-column flex-md-row justify-content-between gap-3">
                                                        <button type="reset"
                                                            class="btn btn-outline-secondary px-4 py-2 fw-bold w-100">Reset
                                                            Filter</button>
                                                        <button type="submit"
                                                            class="btn btn-success px-5 py-2 fw-bold w-100">Apply
                                                            Filter</button>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Danh sách xe -->
                                <jsp:include page="car-list-fragment.jsp" />
                            </div>
                        </section>

                        <jsp:include page="../includes/footer.jsp" />

                        <div id="ftco-loader" class="show fullscreen"
                            style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(255,255,255,0.9); display: none; justify-content: center; align-items: center; z-index: 9999;">
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

                        <!-- Bootstrap 5 Bundle for Modal support -->
                        <script
                            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

                        <script src="${pageContext.request.contextPath}/scripts/car/car.js"></script>
                        <!-- Toast notification -->
                        <div id="favorite-toast" style="display: none;"></div>
                        <script>
                            var contextPath = '${pageContext.request.contextPath}';
                        </script>


                        <!-- Modal: Brand Filter -->
                        <div class="modal fade" id="brandFilterModal" tabindex="-1"
                            aria-labelledby="brandFilterModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h2 class="modal-title fs-4" id="brandFilterModalLabel">Select Brands</h2>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <form method="get" action="${pageContext.request.contextPath}/pages/car">
                                        <!-- Preserve other filter parameters -->
                                        <c:forEach var="param" items="${paramValues}">
                                            <c:if test="${param.key != 'brandId'}">
                                                <c:forEach var="value" items="${param.value}">
                                                    <input type="hidden" name="${param.key}" value="${value}">
                                                </c:forEach>
                                            </c:if>
                                        </c:forEach>
                                        <div class="modal-body">
                                            <div class="row mb-3 g-2">
                                                <div class="col-12 col-md-6">
                                                    <button type="button" id="selectAllBrand"
                                                        class="btn w-100 btn-outline-success py-2 select-all-btn"
                                                        data-type="brand" style="border: 2px solid #01D28E;">
                                                        <i class="bi bi-check2-circle me-2"></i><span
                                                            class="select-all-text">Select All</span>
                                                    </button>
                                                </div>
                                                <div class="col-12 col-md-6">
                                                    <button type="button" id="clearAllBrand"
                                                        class="btn w-100 btn-outline-secondary py-2"
                                                        style="border: 2px solid #adb5bd;">
                                                        <i class="bi bi-x-circle me-2"></i>Clear All
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <c:forEach var="brand" items="${brandList}" varStatus="status">
                                                    <div class="col-12 col-md-6 mb-2">
                                                        <label
                                                            class="form-check-label d-flex align-items-center p-3 border rounded w-100 filter-modal-hover"
                                                            style="cursor: pointer; transition: all 0.2s;">
                                                            <input type="checkbox" class="form-check-input me-3"
                                                                name="brandId" value="${brand.brandId}" <c:if
                                                                test="${paramValues.brandId != null && fn:contains(paramValues.brandId, brand.brandId)}">checked
                                                            </c:if>>
                                                            <span
                                                                class="fw-medium flex-grow-1">${brand.brandName}</span>
                                                        </label>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Cancel</button>
                                            <button type="submit" class="btn btn-primary">Apply Filter</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Modal: Category Filter -->
                        <div class="modal fade" id="categoryFilterModal" tabindex="-1"
                            aria-labelledby="categoryFilterModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h2 class="modal-title fs-4" id="categoryFilterModalLabel">Select Car Types</h2>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <form method="get" action="${pageContext.request.contextPath}/pages/car">
                                        <!-- Preserve other filter parameters -->
                                        <c:forEach var="param" items="${paramValues}">
                                            <c:if test="${param.key != 'categoryId'}">
                                                <c:forEach var="value" items="${param.value}">
                                                    <input type="hidden" name="${param.key}" value="${value}">
                                                </c:forEach>
                                            </c:if>
                                        </c:forEach>
                                        <div class="modal-body">
                                            <div class="row mb-3 g-2">
                                                <div class="col-12 col-md-6">
                                                    <button type="button" id="selectAllCategory"
                                                        class="btn w-100 btn-outline-success py-2 select-all-btn"
                                                        data-type="category" style="border: 2px solid #01D28E;">
                                                        <i class="bi bi-check2-circle me-2"></i><span
                                                            class="select-all-text">Select All</span>
                                                    </button>
                                                </div>
                                                <div class="col-12 col-md-6">
                                                    <button type="button" id="clearAllCategory"
                                                        class="btn w-100 btn-outline-secondary py-2"
                                                        style="border: 2px solid #adb5bd;">
                                                        <i class="bi bi-x-circle me-2"></i>Clear All
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="row">
                                                <c:forEach var="cat" items="${categoryList}" varStatus="status">
                                                    <div class="col-12 col-md-6 mb-2">
                                                        <label
                                                            class="form-check-label d-flex align-items-center p-3 border rounded w-100 filter-modal-hover"
                                                            style="cursor: pointer; transition: all 0.2s;">
                                                            <input type="checkbox" class="form-check-input me-3"
                                                                name="categoryId" value="${cat.categoryId}" <c:if
                                                                test="${paramValues.categoryId != null && fn:contains(paramValues.categoryId, cat.categoryId)}">checked
                                                            </c:if>>
                                                            <span
                                                                class="fw-medium flex-grow-1">${cat.categoryName}</span>
                                                        </label>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Cancel</button>
                                            <button type="submit" class="btn btn-primary">Apply Filter</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Modal: Transmission Filter -->
                        <div class="modal fade" id="transmissionFilterModal" tabindex="-1"
                            aria-labelledby="transmissionFilterModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h2 class="modal-title fs-4" id="transmissionFilterModalLabel">Select
                                            Transmission</h2>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <form method="get" action="${pageContext.request.contextPath}/pages/car">
                                        <!-- Preserve other filter parameters -->
                                        <c:forEach var="param" items="${paramValues}">
                                            <c:if test="${param.key != 'transmissionTypeId'}">
                                                <c:forEach var="value" items="${param.value}">
                                                    <input type="hidden" name="${param.key}" value="${value}">
                                                </c:forEach>
                                            </c:if>
                                        </c:forEach>
                                        <div class="modal-body">
                                            <div class="row mb-3 g-2">
                                                <div class="col-12 col-md-6">
                                                    <button type="button" id="selectAllTransmission"
                                                        class="btn w-100 btn-outline-success py-2 select-all-btn"
                                                        data-type="transmission" style="border: 2px solid #01D28E;">
                                                        <i class="bi bi-check2-circle me-2"></i><span
                                                            class="select-all-text">Select All</span>
                                                    </button>
                                                </div>
                                                <div class="col-12 col-md-6">
                                                    <button type="button" id="clearAllTransmission"
                                                        class="btn w-100 btn-outline-secondary py-2"
                                                        style="border: 2px solid #adb5bd;">
                                                        <i class="bi bi-x-circle me-2"></i>Clear All
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="selected-count-modal mb-2" id="transmissionSelectedCountModal">
                                            </div>
                                            <div class="row">
                                                <c:forEach var="trans" items="${transmissionTypeList}">
                                                    <div class="col-12 col-md-6 mb-2">
                                                        <label
                                                            class="form-check-label d-flex align-items-center p-3 border rounded w-100 filter-modal-hover"
                                                            style="cursor: pointer; transition: all 0.2s;">
                                                            <input type="checkbox"
                                                                class="form-check-input me-3 transmission-checkbox"
                                                                name="transmissionTypeId"
                                                                value="${trans.transmissionTypeId}" <c:if
                                                                test="${paramValues.transmissionTypeId != null && fn:contains(paramValues.transmissionTypeId, trans.transmissionTypeId)}">checked
                                                            </c:if>>
                                                            <span
                                                                class="fw-medium flex-grow-1">${trans.transmissionName}</span>
                                                        </label>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Cancel</button>
                                            <button type="submit" class="btn btn-primary">Apply Filter</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Modal: Fuel Filter -->
                        <div class="modal fade" id="fuelFilterModal" tabindex="-1"
                            aria-labelledby="fuelFilterModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h2 class="modal-title fs-4" id="fuelFilterModalLabel">Select Fuel Type</h2>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <form method="get" action="${pageContext.request.contextPath}/pages/car">
                                        <!-- Preserve other filter parameters -->
                                        <c:forEach var="param" items="${paramValues}">
                                            <c:if test="${param.key != 'fuelTypeId'}">
                                                <c:forEach var="value" items="${param.value}">
                                                    <input type="hidden" name="${param.key}" value="${value}">
                                                </c:forEach>
                                            </c:if>
                                        </c:forEach>
                                        <div class="modal-body">
                                            <div class="row mb-3 g-2">
                                                <div class="col-12 col-md-6">
                                                    <button type="button" id="selectAllFuel"
                                                        class="btn w-100 btn-outline-success py-2 select-all-btn"
                                                        data-type="fuel" style="border: 2px solid #01D28E;">
                                                        <i class="bi bi-check2-circle me-2"></i><span
                                                            class="select-all-text">Select All</span>
                                                    </button>
                                                </div>
                                                <div class="col-12 col-md-6">
                                                    <button type="button" id="clearAllFuel"
                                                        class="btn w-100 btn-outline-secondary py-2"
                                                        style="border: 2px solid #adb5bd;">
                                                        <i class="bi bi-x-circle me-2"></i>Clear All
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="selected-count-modal mb-2" id="fuelSelectedCountModal"></div>
                                            <div class="row">
                                                <c:forEach var="fuel" items="${fuelTypeList}">
                                                    <div class="col-12 col-md-6 mb-2">
                                                        <label
                                                            class="form-check-label d-flex align-items-center p-3 border rounded w-100 filter-modal-hover"
                                                            style="cursor: pointer; transition: all 0.2s;">
                                                            <input type="checkbox"
                                                                class="form-check-input me-3 fuel-checkbox"
                                                                name="fuelTypeId" value="${fuel.fuelTypeId}" <c:if
                                                                test="${paramValues.fuelTypeId != null && fn:contains(paramValues.fuelTypeId, fuel.fuelTypeId)}">checked
                                                            </c:if>>
                                                            <span class="fw-medium flex-grow-1">${fuel.fuelName}</span>
                                                        </label>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Cancel</button>
                                            <button type="submit" class="btn btn-primary">Apply Filter</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Modal: Status Filter -->
                        <div class="modal fade" id="statusFilterModal" tabindex="-1"
                            aria-labelledby="statusFilterModalLabel" aria-hidden="true">
                            <div class="modal-dialog modal-lg">
                                <div class="modal-content">
                                    <div class="modal-header">
                                        <h2 class="modal-title fs-4" id="statusFilterModalLabel">Select Status</h2>
                                        <button type="button" class="btn-close" data-bs-dismiss="modal"
                                            aria-label="Close"></button>
                                    </div>
                                    <form method="get" action="${pageContext.request.contextPath}/pages/car">
                                        <!-- Preserve other filter parameters -->
                                        <c:forEach var="param" items="${paramValues}">
                                            <c:if test="${param.key != 'status'}">
                                                <c:forEach var="value" items="${param.value}">
                                                    <input type="hidden" name="${param.key}" value="${value}">
                                                </c:forEach>
                                            </c:if>
                                        </c:forEach>
                                        <div class="modal-body">
                                            <div class="row mb-3 g-2">
                                                <div class="col-12 col-md-6">
                                                    <button type="button" id="selectAllStatus"
                                                        class="btn w-100 btn-outline-success py-2 select-all-btn"
                                                        data-type="status" style="border: 2px solid #01D28E;">
                                                        <i class="bi bi-check2-circle me-2"></i><span
                                                            class="select-all-text">Select All</span>
                                                    </button>
                                                </div>
                                                <div class="col-12 col-md-6">
                                                    <button type="button" id="clearAllStatus"
                                                        class="btn w-100 btn-outline-secondary py-2"
                                                        style="border: 2px solid #adb5bd;">
                                                        <i class="bi bi-x-circle me-2"></i>Clear All
                                                    </button>
                                                </div>
                                            </div>
                                            <div class="selected-count-modal mb-2" id="statusSelectedCountModal"></div>
                                            <div class="row">
                                                <c:forEach var="status" items="${statusList}">
                                                    <div class="col-12 col-md-6 mb-2">
                                                        <label
                                                            class="form-check-label d-flex align-items-center p-3 border rounded w-100 filter-modal-hover"
                                                            style="cursor: pointer; transition: all 0.2s;">
                                                            <input type="checkbox"
                                                                class="form-check-input me-3 status-checkbox"
                                                                name="status" value="${status.value}" <c:if
                                                                test="${paramValues.status != null && fn:contains(paramValues.status, status.value)}">checked
                                                            </c:if>>
                                                            <span class="fw-medium flex-grow-1">${status.display}</span>
                                                        </label>
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </div>
                                        <div class="modal-footer">
                                            <button type="button" class="btn btn-secondary"
                                                data-bs-dismiss="modal">Cancel</button>
                                            <button type="submit" class="btn btn-primary">Apply Filter</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>

                        <!-- Script to open modal -->
                        <script>
                            function openBrandModal() {
                                console.log('Opening brand modal...');
                                const modal = new bootstrap.Modal(document.getElementById('brandFilterModal'));
                                modal.show();
                            }

                            // Debug script
                            document.addEventListener('DOMContentLoaded', function () {
                                console.log('Page loaded');
                                console.log('Modal element:', document.getElementById('brandFilterModal'));

                                // Test if Bootstrap 5 is loaded
                                if (typeof bootstrap !== 'undefined') {
                                    console.log('Bootstrap 5 is loaded');
                                } else {
                                    console.log('Bootstrap 5 is not loaded');
                                }
                            });
                        </script>
                        <script>
                            // Hiển thị giá trị dual range slider
                            document.addEventListener('DOMContentLoaded', function () {
                                function bindDualSlider(minSliderId, maxSliderId, minValueId, maxValueId, minInputId, maxInputId, unit, isThousand) {
                                    var minSlider = document.getElementById(minSliderId);
                                    var maxSlider = document.getElementById(maxSliderId);
                                    var minValue = document.getElementById(minValueId);
                                    var maxValue = document.getElementById(maxValueId);
                                    var minInput = document.getElementById(minInputId);
                                    var maxInput = document.getElementById(maxInputId);

                                    if (minSlider && maxSlider && minValue && maxValue && minInput && maxInput) {
                                        // Update display and hidden inputs
                                        function updateDisplay() {
                                            minValue.textContent = minSlider.value + (unit || '');
                                            maxValue.textContent = maxSlider.value + (unit || '');
                                            minInput.value = minSlider.value;
                                            maxInput.value = maxSlider.value;
                                        }

                                        // Ensure min doesn't exceed max
                                        minSlider.addEventListener('input', function () {
                                            if (parseInt(minSlider.value) > parseInt(maxSlider.value)) {
                                                maxSlider.value = minSlider.value;
                                            }
                                            updateDisplay();
                                        });

                                        // Ensure max doesn't go below min
                                        maxSlider.addEventListener('input', function () {
                                            if (parseInt(maxSlider.value) < parseInt(minSlider.value)) {
                                                minSlider.value = maxSlider.value;
                                            }
                                            updateDisplay();
                                        });

                                        // Initial display
                                        updateDisplay();
                                    }
                                }

                                bindDualSlider('priceHourMinSlider', 'priceHourMaxSlider', 'priceHourMinValue', 'priceHourMaxValue', 'minPricePerHourInput', 'maxPricePerHourInput', ' VND/hour', true);
                                bindDualSlider('mileageMinSlider', 'mileageMaxSlider', 'mileageMinValue', 'mileageMaxValue', 'minOdometerInput', 'maxOdometerInput', ' km');
                                bindDualSlider('distanceMinSlider', 'distanceMaxSlider', 'distanceMinValue', 'distanceMaxValue', 'minDistanceInput', 'maxDistanceInput', ' km');
                                bindDualSlider('seatsMinSlider', 'seatsMaxSlider', 'seatsMinValue', 'seatsMaxValue', 'minSeatsInput', 'maxSeatsInput', '');
                                bindDualSlider('yearMinSlider', 'yearMaxSlider', 'yearMinValue', 'yearMaxValue', 'minYearInput', 'maxYearInput', '');
                            });
                        </script>
                        <script>
                            // Dual range slider logic for all filters
                            function formatNumberWithCommas(x) {
                                return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
                            }
                            function updateDualSlider(minSlider, maxSlider, track, min, max) {
                                const minVal = parseInt(minSlider.value);
                                const maxVal = parseInt(maxSlider.value);
                                const percentMin = ((minVal - min) / (max - min)) * 100;
                                const percentMax = ((maxVal - min) / (max - min)) * 100;
                                track.style.left = percentMin + "%";
                                track.style.width = (percentMax - percentMin) + "%";
                            }
                            function bindDualSliderV2(minSliderId, maxSliderId, trackId, displayId, minInputId, maxInputId, options) {
                                var minSlider = document.getElementById(minSliderId);
                                var maxSlider = document.getElementById(maxSliderId);
                                var track = document.getElementById(trackId);
                                var display = document.getElementById(displayId);
                                var minInput = document.getElementById(minInputId);
                                var maxInput = document.getElementById(maxInputId);
                                if (!minSlider || !maxSlider || !track || !display || !minInput || !maxInput) return;
                                var min = parseInt(minSlider.min);
                                var max = parseInt(maxSlider.max);
                                function updateDisplay() {
                                    let minVal = parseInt(minSlider.value);
                                    let maxVal = parseInt(maxSlider.value);
                                    if (minVal > maxVal) minVal = maxVal;
                                    if (maxVal < minVal) maxVal = minVal;
                                    minSlider.value = minVal;
                                    maxSlider.value = maxVal;
                                    minInput.value = minVal;
                                    maxInput.value = maxVal;
                                    // Format display
                                    let text = '';
                                    if (options && options.format) {
                                        text = options.format(minVal, maxVal);
                                    } else {
                                        text = minVal + ' - ' + maxVal;
                                    }
                                    display.textContent = text;
                                    updateDualSlider(minSlider, maxSlider, track, min, max);
                                }
                                minSlider.addEventListener('input', function () {
                                    if (parseInt(minSlider.value) > parseInt(maxSlider.value)) {
                                        maxSlider.value = minSlider.value;
                                    }
                                    updateDisplay();
                                });
                                maxSlider.addEventListener('input', function () {
                                    if (parseInt(maxSlider.value) < parseInt(minSlider.value)) {
                                        minSlider.value = maxSlider.value;
                                    }
                                    updateDisplay();
                                });
                                updateDisplay();
                            }
                            document.addEventListener('DOMContentLoaded', function () {
                                // Price
                                bindDualSliderV2('priceHourMinSlider', 'priceHourMaxSlider', 'priceTrack', 'priceHourRangeDisplay', 'minPricePerHourInput', 'maxPricePerHourInput', {
                                    format: function (min, max) {
                                        return (min === max) ? (min * 1000).toLocaleString('vi-VN') + ' VND' : (min * 1000).toLocaleString('vi-VN') + 'K - ' + (max * 1000).toLocaleString('vi-VN') + 'K';
                                    }
                                });
                                // Mileage
                                bindDualSliderV2('mileageMinSlider', 'mileageMaxSlider', 'mileageTrack', 'mileageRangeDisplay', 'minOdometerInput', 'maxOdometerInput', {
                                    format: function (min, max) {
                                        return formatNumberWithCommas(min) + ' - ' + formatNumberWithCommas(max) + ' km';
                                    }
                                });
                                // Distance
                                bindDualSliderV2('distanceMinSlider', 'distanceMaxSlider', 'distanceTrack', 'distanceRangeDisplay', 'minDistanceInput', 'maxDistanceInput', {
                                    format: function (min, max) {
                                        return min + ' - ' + max + ' km';
                                    }
                                });
                                // Seats
                                bindDualSliderV2('seatsMinSlider', 'seatsMaxSlider', 'seatsTrack', 'seatsRangeDisplay', 'minSeatsInput', 'maxSeatsInput', {
                                    format: function (min, max) {
                                        return min + ' - ' + max + ' seats';
                                    }
                                });
                                // Year
                                bindDualSliderV2('yearMinSlider', 'yearMaxSlider', 'yearTrack', 'yearRangeDisplay', 'minYearInput', 'maxYearInput', {
                                    format: function (min, max) {
                                        return min + ' - ' + max;
                                    }
                                });
                            });
                        </script>
                    </body>

                    </html>