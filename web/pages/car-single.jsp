<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.DTO.CarDetailDTO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    CarDetailDTO car = (CarDetailDTO) request.getAttribute("car");
%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Carbook - Free Bootstrap 4 Template by Colorlib</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <link href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap" rel="stylesheet">

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

        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/nav.css">

        <!-- ===== Include Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/scripts/include/nav.css">

        <!-- ===== Custom Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/car-single.css">
    </head>
    <body>

        <jsp:include page="includes/nav.jsp" />

        <div class="hero-wrap hero-wrap-2 js-fullheight" style="background-image: url('${pageContext.request.contextPath}/assets/images/bg_3.jpg');" data-stellar-background-ratio="0.5">
            <div class="overlay"></div>
            <div class="container">
                <div class="row no-gutters slider-text js-fullheight align-items-end justify-content-start">
                    <div class="col-md-9 ftco-animate pb-5">
                        <p class="breadcrumbs"><span class="mr-2"><a href="${pageContext.request.contextPath}/pages/index.jsp">Home <i class="ion-ios-arrow-forward"></i></a></span> <span>Cars <i class="ion-ios-arrow-forward"></i></span> <span>Car Details <i class="ion-ios-arrow-forward"></i></span></p>
                        <h1 class="mb-3 bread">Car Details</h1>
                    </div>
                </div>
            </div>
        </div>

        <section class="ftco-section ftco-car-details">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-12">
                        <div class="car-details">
                            <div class="img rounded" style="background-image: url('${pageContext.request.contextPath}<%= car.getImageUrls().get(0)%>');"></div>
                            <div class="text text-center">
                                <span class="subheading"><%= car.getBrandName()%></span>
                                <h2><%= car.getCarModel()%></h2>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <!-- Odometer -->
                    <div class="col-md d-flex align-self-stretch ftco-animate">
                        <div class="media block-6 services">
                            <div class="media-body py-md-4">
                                <div class="d-flex mb-3 align-items-center">
                                    <div class="icon d-flex align-items-center justify-content-center"><span class="flaticon-dashboard"></span></div>
                                    <div class="text">
                                        <h3 class="heading mb-0 pl-3">Mileage<span><%= car.getOdometer()%> km</span></h3>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Transmission -->
                    <div class="col-md d-flex align-self-stretch ftco-animate">
                        <div class="media block-6 services">
                            <div class="media-body py-md-4">
                                <div class="d-flex mb-3 align-items-center">
                                    <div class="icon d-flex align-items-center justify-content-center"><span class="flaticon-pistons"></span></div>
                                    <div class="text">
                                        <h3 class="heading mb-0 pl-3">Transmission<span><%= car.getTransmissionName()%></span></h3>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Seats -->
                    <div class="col-md d-flex align-self-stretch ftco-animate">
                        <div class="media block-6 services">
                            <div class="media-body py-md-4">
                                <div class="d-flex mb-3 align-items-center">
                                    <div class="icon d-flex align-items-center justify-content-center"><span class="flaticon-car-seat"></span></div>
                                    <div class="text">
                                        <h3 class="heading mb-0 pl-3">Seats<span><%= car.getSeats()%> Adults</span></h3>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!--                     Luggage (tạm tĩnh nếu chưa có cột trong DB) 
                                        <div class="col-md d-flex align-self-stretch ftco-animate">
                                            <div class="media block-6 services">
                                                <div class="media-body py-md-4">
                                                    <div class="d-flex mb-3 align-items-center">
                                                        <div class="icon d-flex align-items-center justify-content-center"><span class="flaticon-backpack"></span></div>
                                                        <div class="text">
                                                            <h3 class="heading mb-0 pl-3">Luggage<span>4 Bags</span></h3>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>-->

                    <!-- Fuel -->
                    <div class="col-md d-flex align-self-stretch ftco-animate">
                        <div class="media block-6 services">
                            <div class="media-body py-md-4">
                                <div class="d-flex mb-3 align-items-center">
                                    <div class="icon d-flex align-items-center justify-content-center"><span class="flaticon-diesel"></span></div>
                                    <div class="text">
                                        <h3 class="heading mb-0 pl-3">Fuel<span><%= car.getFuelName()%></span></h3>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Price and Action Buttons -->
                <div class="row justify-content-center">
                    <div class="col-md-8">
                        <div class="car-price-info">
                            <div class="price-label">Price per day</div>
                            <div class="price"><%= car.getPricePerDay() != null ? car.getPricePerDay().toString() + " VND/day" : "Contact"%></div>
                            <div class="price-label">Price per hour</div>
                            <div class="price"><%= car.getPricePerHour() != null ? car.getPricePerHour().toString() + " VND/day" : "Contact"%></div>
                        </div>
                        <div class="car-action-buttons">
                            <a href="${pageContext.request.contextPath}/pages/booking?carId=<%= car.getCarId()%>" class="btn btn-book-now">
                                <i class="ion-ios-calendar"></i> Book now
                            </a>
                            <a href="#" class="btn btn-add-cart" onclick="addToCart(<%= car.getCarId()%>)">
                                <i class="ion-ios-cart"></i> Add to cart
                            </a>
                        </div>
                    </div>
                </div>

                <div class="row">
                    <div class="col-md-12 pills">
                        <div class="bd-example bd-example-tabs">
                            <div class="d-flex justify-content-center">
                                <ul class="nav nav-pills mb-3" id="pills-tab" role="tablist">

                                    <li class="nav-item">
                                        <a class="nav-link active" id="pills-description-tab" data-toggle="pill" href="#pills-description" role="tab" aria-controls="pills-description" aria-selected="true">Features</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" id="pills-manufacturer-tab" data-toggle="pill" href="#pills-manufacturer" role="tab" aria-controls="pills-manufacturer" aria-selected="false">Description</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" id="pills-review-tab" data-toggle="pill" href="#pills-review" role="tab" aria-controls="pills-review" aria-selected="false">Review</a>
                                    </li>
                                </ul>
                            </div>

                            <div class="tab-content" id="pills-tabContent">
                                <div class="tab-pane fade show active" id="pills-description" role="tabpanel" aria-labelledby="pills-description-tab">
                                    <div class="row">
                                        <c:forEach var="col" begin="0" end="2">
                                            <div class="col-md-4">
                                                <ul class="features">
                                                    <c:forEach var="i" begin="${col*5}" end="${col*5+4}">
                                                        <c:if test="${i < car.allFeatureNames.size()}">
                                                            <li class="${car.featureNames.contains(car.allFeatureNames[i]) ? 'check' : 'uncheck'}">
                                                                <span class="${car.featureNames.contains(car.allFeatureNames[i]) ? 'ion-ios-checkmark-circle' : 'ion-ios-close-circle'}"></span>
                                                                ${car.allFeatureNames[i]}
                                                            </li>
                                                        </c:if>
                                                    </c:forEach>
                                                </ul>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </div>

                                <div class="tab-pane fade" id="pills-manufacturer" role="tabpanel" aria-labelledby="pills-manufacturer-tab">
                                    <p><%= car.getDescription() != null && !car.getDescription().isEmpty() ? car.getDescription() : "Chưa có mô tả cho xe này."%></p>
                                </div>

                                <div class="tab-pane fade" id="pills-review" role="tabpanel" aria-labelledby="pills-review-tab">
                                    <div class="row">
                                        <div class="col-md-7">
                                            <h3 class="head">23 Reviews</h3>
                                            <div class="review d-flex">
                                                <div class="user-img" style="background-image: url('../images/person_1.jpg')"></div>
                                                <div class="desc">
                                                    <h4>
                                                        <span class="text-left">Jacob Webb</span>
                                                        <span class="text-right">14 March 2018</span>
                                                    </h4>
                                                    <p class="star">
                                                        <span>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                        </span>
                                                        <span class="text-right"><a href="#" class="reply"><i class="icon-reply"></i></a></span>
                                                    </p>
                                                    <p>When she reached the first hills of the Italic Mountains, she had a last view back on the skyline of her hometown Bookmarksgrov</p>
                                                </div>
                                            </div>
                                            <div class="review d-flex">
                                                <div class="user-img" style="background-image: url('../images/person_2.jpg')"></div>
                                                <div class="desc">
                                                    <h4>
                                                        <span class="text-left">Jacob Webb</span>
                                                        <span class="text-right">14 March 2018</span>
                                                    </h4>
                                                    <p class="star">
                                                        <span>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                        </span>
                                                        <span class="text-right"><a href="#" class="reply"><i class="icon-reply"></i></a></span>
                                                    </p>
                                                    <p>When she reached the first hills of the Italic Mountains, she had a last view back on the skyline of her hometown Bookmarksgrov</p>
                                                </div>
                                            </div>
                                            <div class="review d-flex">
                                                <div class="user-img" style="background-image: url('../images/person_3.jpg')"></div>
                                                <div class="desc">
                                                    <h4>
                                                        <span class="text-left">Jacob Webb</span>
                                                        <span class="text-right">14 March 2018</span>
                                                    </h4>
                                                    <p class="star">
                                                        <span>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                        </span>
                                                        <span class="text-right"><a href="#" class="reply"><i class="icon-reply"></i></a></span>
                                                    </p>
                                                    <p>When she reached the first hills of the Italic Mountains, she had a last view back on the skyline of her hometown Bookmarksgrov</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-5">
                                            <div class="rating-wrap">
                                                <h3 class="head">Give a Review</h3>
                                                <div class="wrap">
                                                    <p class="star">
                                                        <span>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            (98%)
                                                        </span>
                                                        <span>4.8 out of 5</span>
                                                    </p>
                                                    <p class="star">
                                                        <span>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            (85%)
                                                        </span>
                                                        <span>4.6 out of 5</span>
                                                    </p>
                                                    <p class="star">
                                                        <span>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            (70%)
                                                        </span>
                                                        <span>3.9 out of 5</span>
                                                    </p>
                                                    <p class="star">
                                                        <span>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            (75%)
                                                        </span>
                                                        <span>4.0 out of 5</span>
                                                    </p>
                                                    <p class="star">
                                                        <span>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            <i class="ion-ios-star"></i>
                                                            (85%)
                                                        </span>
                                                        <span>4.6 out of 5</span>
                                                    </p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <jsp:include page="includes/footer.jsp" />

        <!-- ===== External JS Libraries ===== -->
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
        <script src="${pageContext.request.contextPath}/assets/js/google-map.js"></script>
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    </body>
</html>