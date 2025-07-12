<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
  <!DOCTYPE html>
  <html lang="en">

  <head>
    <title>Carbook - Free Bootstrap 4 Template by Colorlib</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <!-- ===== External CSS Libraries ===== -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap"
      rel="stylesheet">

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

    <!-- ===== Page Styles ===== -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/contact.css">

    <!-- ===== NavBar Styles (load last to override other styles) ===== -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/main/contact.css">
  </head>

  <body>

    <jsp:include page="includes/nav.jsp" />

    <section class="hero-wrap hero-wrap-2 js-fullheight"
      style="background-image: url('${pageContext.request.contextPath}/assets/images/bg_3.jpg');"
      data-stellar-background-ratio="0.5">
      <div class="overlay"></div>
      <div class="container">
        <div class="row no-gutters slider-text js-fullheight align-items-end justify-content-start">
          <div class="col-md-9 ftco-animate pb-5">
            <p class="breadcrumbs"><span class="mr-2"><a href="${pageContext.request.contextPath}/pages/home">Home <i
                    class="ion-ios-arrow-forward"></i></a></span> <span>Contact <i
                  class="ion-ios-arrow-forward"></i></span></p>
            <h1 class="mb-3 bread">Contact Us</h1>
          </div>
        </div>
      </div>
    </section>

    <section class="ftco-section contact-section">
      <div class="container">
        <div class="row d-flex mb-5 contact-info">
          <div class="col-md-4">
            <div class="row mb-5">
              <div class="col-md-12">
                <div class="border w-100 p-4 rounded mb-2 d-flex">
                  <div class="icon mr-3">
                    <span class="icon-map-o"></span>
                  </div>
                  <p><span>Address:</span> FPT City Urban Area, Ngu Hanh Son District, Da Nang City 55000</p>
                </div>
              </div>
              <div class="col-md-12">
                <div class="border w-100 p-4 rounded mb-2 d-flex">
                  <div class="icon mr-3">
                    <span class="icon-mobile-phone"></span>
                  </div>
                  <p><span>Phone:</span> <a href="tel://1234567920">+ 84 931937721</a></p>
                </div>
              </div>
              <div class="col-md-12">
                <div class="border w-100 p-4 rounded mb-2 d-flex">
                  <div class="icon mr-3">
                    <span class="icon-envelope-o"></span>
                  </div>
                  <p><span>Email:</span> <a href="mailto:info@yoursite.com">hyperrhy1412@gmail.com</a></p>
                </div>
              </div>
            </div>
          </div>
          <div class="col-md-8 block-9 mb-md-5">
            <% if (request.getAttribute("success") !=null) { %>
              <div class="alert alert-success text-center" style="margin-bottom: 16px;">
                <%= request.getAttribute("success") %>
              </div>
              <% } else if (request.getAttribute("error") !=null) { %>
                <div class="alert alert-danger text-center" style="margin-bottom: 16px;">
                  <%= request.getAttribute("error") %>
                </div>
                <% } %>
                  <form action="${pageContext.request.contextPath}/contact" method="post"
                    class="bg-light p-5 contact-form">
                    <div class="form-group">
                      <input type="text" class="form-control" name="name" placeholder="Your Name" required>
                    </div>
                    <div class="form-group">
                      <input type="email" class="form-control" name="email" placeholder="Your Email" required>
                    </div>
                    <div class="form-group">
                      <input type="text" class="form-control" name="subject" placeholder="Subject" required>
                    </div>
                    <div class="form-group">
                      <textarea name="message" cols="30" rows="7" class="form-control" placeholder="Message"
                        required></textarea>
                    </div>
                    <div class="form-group">
                      <input type="submit" value="Send Message" class="btn btn-primary py-3 px-5">
                    </div>
                  </form>
          </div>
        </div>
        <div class="row justify-content-center">
          <div class="col-md-12">
            <div id="map" class="bg-white">
              <iframe
                src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d7671.703799174302!2d108.25981849393939!3d15.969108692580052!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3142116949840599%3A0x365b35580f52e8d5!2sFPT%20University%20Danang!5e0!3m2!1sen!2s!4v1750757639019!5m2!1sen!2s"
                width="100%" height="450" style="border:0;" allowfullscreen="" loading="lazy"
                referrerpolicy="no-referrer-when-downgrade"></iframe>
            </div>
          </div>
        </div>
      </div>
    </section>

    <jsp:include page="includes/footer.jsp" />

    <!-- loader -->
    <div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px">
        <circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee" />
        <circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10"
          stroke="#F96D00" />
      </svg></div>

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