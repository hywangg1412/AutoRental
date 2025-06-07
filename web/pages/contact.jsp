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
        <link rel="stylesheet" href="${pageContext.request.contextPath}/Includes/css/nav.css">

        <!-- ===== Include Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/scripts/include/nav.css">
        
        <!-- ===== Custom Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/contact.css">
    </head>
    <body>

        <jsp:include page="includes/nav.jsp" />

        <div class="hero-wrap hero-wrap-2 js-fullheight" style="background-image: url('${pageContext.request.contextPath}/assets/images/bg_3.jpg');" data-stellar-background-ratio="0.5">
            <div class="overlay"></div>
            <div class="js-fullheight d-flex justify-content-center align-items-center">
                <div class="col-md-8 text text-center">
                    <div class="img mb-4" style="background-image: url('${pageContext.request.contextPath}/assets/images/author.jpg');"></div>
                    <div class="desc">
                        <h2 class="subheading">Hello I'm</h2>
                        <h1 class="mb-4">I'm a Photographer</h1>
                        <p class="mb-4">I am Awwward winning photographer based in Los Angeles. I specialize in street, architecture and commercial photography.</p>
                        <p><a href="#" class="btn-custom">More About Me <span class="ion-ios-arrow-forward"></span></a></p>
                    </div>
                </div>
            </div>
        </div>

        <section class="ftco-section contact-section">
            <div class="container">
                <div class="row justify-content-center mb-5">
                    <div class="col-md-7 text-center">
                        <h2 class="mb-4">Contact Us</h2>
                    </div>
                </div>
                <div class="row">
                    <!-- Contact Info -->
                    <div class="col-md-5 mb-4">
                        <div class="contact-info-box mb-3 d-flex align-items-center">
                            <span class="icon flaticon-placeholder"></span>
                            <div class="ml-3">
                                <div class="text-muted small">Address:</div>
                                <div class="font-weight-bold">198 West 21th Street, Suite 721<br>New York NY 10016</div>
                            </div>
                        </div>
                        <div class="contact-info-box mb-3 d-flex align-items-center">
                            <span class="icon flaticon-phone-call"></span>
                            <div class="ml-3">
                                <div class="text-muted small">Phone:</div>
                                <div class="font-weight-bold">+ 1235 2355 98</div>
                            </div>
                        </div>
                        <div class="contact-info-box mb-3 d-flex align-items-center">
                            <span class="icon flaticon-envelope"></span>
                            <div class="ml-3">
                                <div class="text-muted small">Email:</div>
                                <div class="font-weight-bold">info@yoursite.com</div>
                            </div>
                        </div>
                    </div>
                    <!-- Contact Form -->
                    <div class="col-md-7">
                        <form action="#" class="bg-light p-4 rounded shadow-sm">
                            <div class="form-group">
                                <input type="text" class="form-control" placeholder="Your Name">
                            </div>
                            <div class="form-group">
                                <input type="email" class="form-control" placeholder="Your Email">
                            </div>
                            <div class="form-group">
                                <input type="text" class="form-control" placeholder="Subject">
                            </div>
                            <div class="form-group">
                                <textarea class="form-control" rows="5" placeholder="Message"></textarea>
                            </div>
                            <div class="form-group text-right">
                                <button type="submit" class="btn btn-primary px-4">Send Message</button>
                            </div>
                        </form>
                    </div>
                </div>
                <!-- Google Map (nếu cần) -->
                <div class="row mt-5">
                    <div class="col-12">
                        <div id="map" style="height: 350px;"></div>
                    </div>
                </div>
            </div>
        </section>

        <%@include file="includes/footer.jsp" %>


        <!-- loader -->
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

    </body>
</html>