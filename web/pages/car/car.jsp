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
<!--                        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/car.css">-->

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
        <div class="container">
            <jsp:include page="../includes/car-nav.jsp" />
        </div>
        <section class="ftco-section bg-light">
            <div class="container" style="max-width: 1140px; margin-top: 80px;">
                <!-- Thay thế toàn bộ filter-bar, advanced filter, các modal filter bằng đoạn này -->
                <div class="row">
                    <!-- SIDEBAR FILTER -->
                    <div class="col-lg-3 col-md-4 mb-4">
                        <div class="d-flex align-items-center mb-3">
                            <form method="get" action="${pageContext.request.contextPath}/pages/car" id="refreshForm" style="margin-right: 8px;">
                                <button type="submit" class="btn btn-outline-secondary" title="Reset filters" style="padding: 6px 12px; border-radius: 8px;">
                                    <i class="bi bi-arrow-clockwise"></i>
                                </button>
                            </form>
                            <span style="font-weight: 600; font-size: 1.1rem;">Filter</span>
                        </div>
                        <form method="get" action="${pageContext.request.contextPath}/pages/car" id="sidebarFilterForm">
                            <!-- Brand -->
                            <div class="mb-4">
                                <label class="fw-bold mb-2 d-block">Brand</label>
                                <c:forEach var="brand" items="${brandList}" varStatus="status">
                                    <c:if test="${status.index < 3}">
                                        <div>
                                            <input type="checkbox" name="brandId" value="${brand.brandId}" <c:if test="${paramValues.brandId != null && fn:contains(paramValues.brandId, brand.brandId)}">checked</c:if> />
                                            <span>${brand.brandName}</span>
                                        </div>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${fn:length(brandList) > 3}">
                                    <div id="brandMore" style="display:none;">
                                        <c:forEach var="brand" items="${brandList}" varStatus="status">
                                            <c:if test="${status.index >= 3}">
                                                <div>
                                                    <input type="checkbox" name="brandId" value="${brand.brandId}" <c:if test="${paramValues.brandId != null && fn:contains(paramValues.brandId, brand.brandId)}">checked</c:if> />
                                                    <span>${brand.brandName}</span>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                    <a href="#" id="brandMoreBtn" onclick="toggleMore('brandMore', this); return false;">Show more</a>
                                </c:if>
                            </div>
                            <!-- Category -->
                            <div class="mb-4">
                                <label class="fw-bold mb-2 d-block">Category</label>
                                <c:forEach var="cat" items="${categoryList}" varStatus="status">
                                    <c:if test="${status.index < 3}">
                                        <div>
                                            <input type="checkbox" name="categoryId" value="${cat.categoryId}" <c:if test="${paramValues.categoryId != null && fn:contains(paramValues.categoryId, cat.categoryId)}">checked</c:if> />
                                            <span>${cat.categoryName}</span>
                                        </div>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${fn:length(categoryList) > 3}">
                                    <div id="categoryMore" style="display:none;">
                                        <c:forEach var="cat" items="${categoryList}" varStatus="status">
                                            <c:if test="${status.index >= 3}">
                                                <div>
                                                    <input type="checkbox" name="categoryId" value="${cat.categoryId}" <c:if test="${paramValues.categoryId != null && fn:contains(paramValues.categoryId, cat.categoryId)}">checked</c:if> />
                                                    <span>${cat.categoryName}</span>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                    <a href="#" id="categoryMoreBtn" onclick="toggleMore('categoryMore', this); return false;">Show more</a>
                                </c:if>
                            </div>
                            <!-- Transmission -->
                            <div class="mb-4">
                                <label class="fw-bold mb-2 d-block">Transmission</label>
                                <c:forEach var="trans" items="${transmissionTypeList}" varStatus="status">
                                    <c:if test="${status.index < 3}">
                                        <div>
                                            <input type="checkbox" name="transmissionTypeId" value="${trans.transmissionTypeId}" <c:if test="${paramValues.transmissionTypeId != null && fn:contains(paramValues.transmissionTypeId, trans.transmissionTypeId)}">checked</c:if> />
                                            <span>${trans.transmissionName}</span>
                                        </div>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${fn:length(transmissionTypeList) > 3}">
                                    <div id="transmissionMore" style="display:none;">
                                        <c:forEach var="trans" items="${transmissionTypeList}" varStatus="status">
                                            <c:if test="${status.index >= 3}">
                                                <div>
                                                    <input type="checkbox" name="transmissionTypeId" value="${trans.transmissionTypeId}" <c:if test="${paramValues.transmissionTypeId != null && fn:contains(paramValues.transmissionTypeId, trans.transmissionTypeId)}">checked</c:if> />
                                                    <span>${trans.transmissionName}</span>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                    <a href="#" id="transmissionMoreBtn" onclick="toggleMore('transmissionMore', this); return false;">Show more</a>
                                </c:if>
                            </div>
                            <!-- Fuel -->
                            <div class="mb-4">
                                <label class="fw-bold mb-2 d-block">Fuel type</label>
                                <c:forEach var="fuel" items="${fuelTypeList}" varStatus="status">
                                    <c:if test="${status.index < 3}">
                                        <div>
                                            <input type="checkbox" name="fuelTypeId" value="${fuel.fuelTypeId}" <c:if test="${paramValues.fuelTypeId != null && fn:contains(paramValues.fuelTypeId, fuel.fuelTypeId)}">checked</c:if> />
                                            <span>${fuel.fuelName}</span>
                                        </div>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${fn:length(fuelTypeList) > 3}">
                                    <div id="fuelMore" style="display:none;">
                                        <c:forEach var="fuel" items="${fuelTypeList}" varStatus="status">
                                            <c:if test="${status.index >= 3}">
                                                <div>
                                                    <input type="checkbox" name="fuelTypeId" value="${fuel.fuelTypeId}" <c:if test="${paramValues.fuelTypeId != null && fn:contains(paramValues.fuelTypeId, fuel.fuelTypeId)}">checked</c:if> />
                                                    <span>${fuel.fuelName}</span>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                    <a href="#" id="fuelMoreBtn" onclick="toggleMore('fuelMore', this); return false;">Show more</a>
                                </c:if>
                            </div>
                            <!-- Features -->
                            <div class="mb-4">
                                <label class="fw-bold mb-2 d-block">Features</label>
                                <c:forEach var="feature" items="${featureList}" varStatus="status">
                                    <c:if test="${status.index < 3}">
                                        <div>
                                            <input type="checkbox" name="featureId" value="${feature.featureId}" <c:if test="${paramValues.featureId != null && fn:contains(paramValues.featureId, feature.featureId)}">checked</c:if> />
                                            <span>${feature.featureName}</span>
                                        </div>
                                    </c:if>
                                </c:forEach>
                                <c:if test="${fn:length(featureList) > 3}">
                                    <div id="featureMore" style="display:none;">
                                        <c:forEach var="feature" items="${featureList}" varStatus="status">
                                            <c:if test="${status.index >= 3}">
                                                <div>
                                                    <input type="checkbox" name="featureId" value="${feature.featureId}" <c:if test="${paramValues.featureId != null && fn:contains(paramValues.featureId, feature.featureId)}">checked</c:if> />
                                                    <span>${feature.featureName}</span>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </div>
                                    <a href="#" id="featureMoreBtn" onclick="toggleMore('featureMore', this); return false;">Show more</a>
                                </c:if>
                            </div>
                            <!-- Price Range -->
                            <div class="mb-4">
                                <label class="fw-bold mb-2 d-block">Price range (VND/hour)</label>
                                <div class="d-flex align-items-center gap-2">
                                    <div style="position: relative; display: flex; align-items: center;">
                                        <input type="text" name="minPricePerHour" id="minPricePerHourInput"
                                               value="${param.minPricePerHour}" class="form-control" style="max-width:80px"
                                               placeholder="From" autocomplete="off"
                                               min="${minPricePerHour}" max="${maxPricePerHour}" />
                                        <span style="margin-left: 4px; font-size: 1rem; color: #888;">.000</span>
                                    </div>
                                    <span>-</span>
                                    <div style="position: relative; display: flex; align-items: center;">
                                        <input type="text" name="maxPricePerHour" id="maxPricePerHourInput"
                                               value="${param.maxPricePerHour}" class="form-control" style="max-width:80px"
                                               placeholder="To" autocomplete="off"
                                               min="${minPricePerHour}" max="${maxPricePerHour}" />
                                        <span style="margin-left: 4px; font-size: 1rem; color: #888;">.000</span>
                                    </div>
                                </div>
                                <div class="text-muted small mt-1">
                                    Enter between <fmt:formatNumber value="${minPricePerHour}" type="number" pattern="#.###"/>.000 and <fmt:formatNumber value="${maxPricePerHour}" type="number" pattern="#.###"/>.000 VND
                                </div>
                                <div id="priceErrorMsg" class="text-danger small mt-1" style="display:none;"></div>
                            </div>
                            <button type="submit" class="btn btn-primary w-100">Apply Filter</button>
                        </form>
                    </div>
                    <!-- DANH SÁCH XE -->
                    <div class="col-lg-9 col-md-8">
                        <form method="get" action="${pageContext.request.contextPath}/pages/car" class="mb-3">
                            <div class="search-sort-bar d-flex align-items-center">
                                <input type="text" name="keyword" class="search-input flex-grow-1"
                                       placeholder="Search car, brand..." value="${param.keyword}">
                                <button class="search-btn" type="submit" title="Search">
                                    <i class="bi bi-search"></i>
                                </button>
                                <select name="sort" id="sortSelect" class="sort-select">
                                    <option value="" ${empty param.sort ? 'selected' : '' }>Default</option>
                                    <option value="priceAsc" ${param.sort=='priceAsc' ? 'selected' : '' }>Price Ascending</option>
                                    <option value="priceDesc" ${param.sort=='priceDesc' ? 'selected' : '' }>Price Descending</option>
                                    <option value="nameAsc" ${param.sort=='nameAsc' ? 'selected' : '' }>A-Z</option>
                                    <option value="nameDesc" ${param.sort=='nameDesc' ? 'selected' : '' }>Z-A</option>
                                    <option value="yearDesc" ${param.sort=='yearDesc' ? 'selected' : '' }>Newest Year</option>
                                    <option value="yearAsc" ${param.sort=='yearAsc' ? 'selected' : '' }>Oldest Year</option>
                                </select>
                            </div>
                        </form>
                        <jsp:include page="car-list-fragment.jsp" />
                    </div>
                </div>
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
                if (!minSlider || !maxSlider || !track || !display || !minInput || !maxInput)
                    return;
                var min = parseInt(minSlider.min);
                var max = parseInt(maxSlider.max);
                function updateDisplay() {
                    let minVal = parseInt(minSlider.value);
                    let maxVal = parseInt(maxSlider.value);
                    if (minVal > maxVal)
                        minVal = maxVal;
                    if (maxVal < minVal)
                        maxVal = minVal;
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
        <script>
            function toggleMore(id, btn) {
                var more = document.getElementById(id);
                if (more.style.display === "none") {
                    more.style.display = "block";
                    btn.innerText = "Show less";
                } else {
                    more.style.display = "none";
                    btn.innerText = "Show more";
                }
            }
            // Validate price input for price range
            function validatePriceInputs() {
                const minInput = document.getElementById('minPricePerHourInput');
                const maxInput = document.getElementById('maxPricePerHourInput');
                const errorMsg = document.getElementById('priceErrorMsg');
                const minDB = parseInt(minInput.getAttribute('min'));
                const maxDB = parseInt(maxInput.getAttribute('max'));
                let minVal = minInput.value.replace(/\D/g, '');
                let maxVal = maxInput.value.replace(/\D/g, '');
                let minNum = minVal ? parseInt(minVal, 10) : null;
                let maxNum = maxVal ? parseInt(maxVal, 10) : null;
                let error = '';
                if ((minInput.value && isNaN(minNum)) || (maxInput.value && isNaN(maxNum))) {
                    error = 'Please enter a valid number.';
                } else if ((minNum && (minNum < minDB || minNum > maxDB)) || (maxNum && (maxNum < minDB || maxNum > maxDB))) {
                    error = `Please enter a value in range.`;
                } else if (minNum && maxNum && minNum > maxNum) {
                    error = 'Minimum price must be less than or equal to maximum price.';
                }
                if (error) {
                    errorMsg.style.display = '';
                    errorMsg.textContent = error;
                } else {
                    errorMsg.style.display = 'none';
                    errorMsg.textContent = '';
                }
            }
            document.addEventListener('DOMContentLoaded', function () {
                const minInput = document.getElementById('minPricePerHourInput');
                const maxInput = document.getElementById('maxPricePerHourInput');
                [minInput, maxInput].forEach(function (input) {
                    input.addEventListener('input', function () {
                        input.value = input.value.replace(/[^0-9]/g, '');
                        validatePriceInputs();
                    });
                    input.addEventListener('blur', function () {
                        validatePriceInputs();
                    });
                });
                // Trước khi submit, luôn lấy số nguyên (không dấu phẩy, không ký tự đặc biệt)
                var filterForm = document.getElementById('sidebarFilterForm');
                if (filterForm) {
                    filterForm.addEventListener('submit', function(e) {
                        if (document.getElementById('priceErrorMsg').style.display !== 'none') {
                            e.preventDefault();
                            return false;
                        }
                        minInput.value = minInput.value.replace(/\D/g, '');
                        maxInput.value = maxInput.value.replace(/\D/g, '');
                    });
                }
            });
        </script>
        <script>
            // Pagination giữ lại filter:
            document.addEventListener('DOMContentLoaded', function () {
                // Tìm tất cả các link phân trang
                document.querySelectorAll('.pagination-link').forEach(function(link) {
                    link.addEventListener('click', function(e) {
                        e.preventDefault();
                        // Lấy url hiện tại và các tham số filter
                        const url = new URL(window.location.href);
                        const params = new URLSearchParams(url.search);
                        // Lấy page mới
                        const page = this.getAttribute('data-page');
                        params.set('page', page);
                        // Giữ lại tất cả các filter hiện tại
                        window.location.href = url.pathname + '?' + params.toString();
                    });
                });
            });
        </script>
    </body>

</html>