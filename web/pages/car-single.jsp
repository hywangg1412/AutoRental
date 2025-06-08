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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/car-single.css">
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
              <div class="text text-center">
                <span class="subheading">Small SUV</span>
                <h2>Mercedes Grand Sedan</h2>
              </div>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-md-12">
            <div class="carousel-car owl-carousel ftco-owl">
              <div class="item">
                <div class="car-wrap rounded ftco-animate">
                  <div class="img rounded d-flex align-items-end" style="background-image: url('${pageContext.request.contextPath}/assets/images/car-1.jpg');">
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="car-wrap rounded ftco-animate">
                  <div class="img rounded d-flex align-items-end" style="background-image: url('${pageContext.request.contextPath}/assets/images/car-2.jpg');">
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="car-wrap rounded ftco-animate">
                  <div class="img rounded d-flex align-items-end" style="background-image: url('${pageContext.request.contextPath}/assets/images/car-3.jpg');">
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="car-wrap rounded ftco-animate">
                  <div class="img rounded d-flex align-items-end" style="background-image: url('${pageContext.request.contextPath}/assets/images/car-4.jpg');">
                  </div>
                </div>
              </div>
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
                    <div class="col-md-4">
                      <ul class="features">
                        <li class="check"><span class="ion-ios-checkmark-circle"></span>Airconditions</li>
                        <li class="check"><span class="ion-ios-checkmark-circle"></span>Child Seat</li>
                        <li class="check"><span class="ion-ios-checkmark-circle"></span>GPS</li>
                        <li class="check"><span class="ion-ios-checkmark-circle"></span>Luggage</li>
                        <li class="check"><span class="ion-ios-checkmark-circle"></span>Music</li>
                      </ul>
                    </div>
                    <div class="col-md-4">
                      <ul class="features">
                        <li class="check"><span class="ion-ios-checkmark-circle"></span>Seat Belt</li>
                        <li class="check"><span class="ion-ios-checkmark-circle"></span>Sleeping Bed</li>
                        <li class="check"><span class="ion-ios-checkmark-circle"></span>Water</li>
                        <li class="check"><span class="ion-ios-checkmark-circle"></span>Bluetooth</li>
                        <li class="check"><span class="ion-ios-checkmark-circle"></span>Onboard computer</li>
                      </ul>
                    </div>
                    <div class="col-md-4">
                      <ul class="features">
                        <li class="check"><span class="ion-ios-checkmark-circle"></span>Audio input</li>
                        <li class="check"><span class="ion-ios-checkmark-circle"></span>Long Term Trips</li>
                        <li class="check"><span class="ion-ios-checkmark-circle"></span>Car Kit</li>
                        <li class="check"><span class="ion-ios-checkmark-circle"></span>Remote central locking</li>
                        <li class="check"><span class="ion-ios-checkmark-circle"></span>Climate control</li>
                      </ul>
                    </div>
                  </div>
                </div>

                <div class="tab-pane fade" id="pills-manufacturer" role="tabpanel" aria-labelledby="pills-manufacturer-tab">
                  <p>Even the all-powerful Pointing has no control about the blind texts it is an almost unorthographic life One day however a small line of blind text by the name of Lorem Ipsum decided to leave for the far World of Grammar.</p>
                  <p>When she reached the first hills of the Italic Mountains, she had a last view back on the skyline of her hometown Bookmarksgrove, the headline of Alphabet Village and the subline of her own road, the Line Lane. Pityful a rethoric question ran over her cheek, then she continued her way.</p>
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