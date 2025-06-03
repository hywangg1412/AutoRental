<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Carbook - Free Bootstrap 4 Template by Colorlib</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

        <link href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap" rel="stylesheet">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/open-iconic-bootstrap.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/animate.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/owl.carousel.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/owl.theme.default.min.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/magnific-popup.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/aos.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ionicons.min.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bootstrap-datepicker.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/jquery.timepicker.css">


        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/flaticon.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/icomoon.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    </head>
    <body>

        <jsp:include page="includes/nav.jsp" />

        <div class="hero-wrap hero-wrap-2 js-fullheight" style="background-image: url('../images/bg_3.jpg');" data-stellar-background-ratio="0.5">
            <div class="overlay"></div>
            <div class="js-fullheight d-flex justify-content-center align-items-center">
                <div class="col-md-8 text text-center">
                    <div class="img mb-4" style="background-image: url('../images/author.jpg');"></div>
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
                <div class="row d-flex mb-5 contact-info">
                    <div class="col-md-12 mb-4">
                        <h2 class="h3">Contact Information</h2>
                    </div>
                    <div class="w-100"></div>
                    <div class="col-md-3">
                        <p><span>Address:</span> 198 West 21th Street, Suite 721 New York NY 10016</p>
                    </div>
                    <div class="col-md-3">
                        <p><span>Phone:</span> <a href="tel://1234567920">+ 1235 2355 98</a></p>
                    </div>
                    <div class="col-md-3">
                        <p><span>Email:</span> <a href="mailto:info@yoursite.com">info@yoursite.com</a></p>
                    </div>
                    <div class="col-md-3">
                        <p><span>Website</span> <a href="#">yoursite.com</a></p>
                    </div>
                </div>
                <div class="row block-9">
                    <div class="col-md-6 order-md-last pr-md-5">
                        <form action="#">
                            <div class="form-group">
                                <input type="text" class="form-control" placeholder="Your Name">
                            </div>
                            <div class="form-group">
                                <input type="text" class="form-control" placeholder="Your Email">
                            </div>
                            <div class="form-group">
                                <input type="text" class="form-control" placeholder="Subject">
                            </div>
                            <div class="form-group">
                                <textarea name="" id="" cols="30" rows="7" class="form-control" placeholder="Message"></textarea>
                            </div>
                            <div class="form-group">
                                <input type="submit" value="Send Message" class="btn btn-primary py-3 px-5">
                            </div>
                        </form>

                    </div>

                    <div class="col-md-6">
                        <div id="map"></div>
                    </div>
                </div>
            </div>
        </section>

        <%@include file="includes/footer.jsp" %>


        <!-- loader -->
        <div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/></svg></div>


        <script src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery-migrate-3.0.1.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/popper.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.easing.1.3.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.waypoints.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.stellar.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/owl.carousel.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.magnific-popup.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/aos.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.animateNumber.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/bootstrap-datepicker.js"></script>
        <script src="${pageContext.request.contextPath}/js/jquery.timepicker.min.js"></script>
        <script src="${pageContext.request.contextPath}/js/scrollax.min.js"></script>
        <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBVWaKrjvy3MaE7SQ74_uJiULgl1JY0H2s&sensor=false"></script>
        <script src="${pageContext.request.contextPath}/js/google-map.js"></script>
        <script src="${pageContext.request.contextPath}/js/main.js"></script>

    </body>
</html>