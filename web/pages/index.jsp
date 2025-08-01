<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8" %> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>AutoRental</title>
    <meta charset="utf-8" />
    <meta
      name="viewport"
      content="width=device-width, initial-scale=1, shrink-to-fit=no"
    />

    <!-- 1. External Libraries -->
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"
      rel="stylesheet"
    />
    <link
      href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
      rel="stylesheet"
    />
    <link
      href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css"
      rel="stylesheet"
    />
    <link
      href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap"
      rel="stylesheet"
    />

    <!-- 2. Plugin/Assets CSS -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/open-iconic-bootstrap.min.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/animate.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/owl.carousel.min.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/owl.theme.default.min.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/magnific-popup.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/aos.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/ionicons.min.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/bootstrap-datepicker.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/jquery.timepicker.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/flaticon.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/icomoon.css"
    />

    <!-- 3. Global/Shared CSS -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/styles/include/nav.css"
    />

    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/car.css"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/assets/css/style.css"
    />

    <!-- 4. Page-specific CSS -->
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/styles/index.css"
    />

    <style>
      .step-number {
        color: #2196f3;
        font-weight: 700;
        font-size: 1.5rem;
        margin-right: 8px;
        letter-spacing: 1px;
      }

      .btn-selfdrive {
        background: #5fcf86;
        color: #fff;
        border-radius: 14px;
        padding: 1rem 2rem;
        font-size: 1.15rem;
        text-align: center;
        min-width: 220px;
        font-weight: bold;
        transition: background 0.2s;
      }

      .btn-selfdrive:hover,
      .btn-selfdrive:focus {
        background: #6ee7a2;
        color: #fff;
      }
    </style>
  </head>

  <body>
    <jsp:include page="includes/nav.jsp" />

    <!-- 1. Hero/Banner -->
    <div
      class="hero-wrap ftco-degree-bg"
      style="
        background-image: url('${pageContext.request.contextPath}/assets/images/bg_1.jpg');
      "
      data-stellar-background-ratio="0.5"
    >
      <div class="overlay"></div>
      <div class="container">
        <div
          class="row no-gutters slider-text justify-content-start align-items-center justify-content-center"
        >
          <div class="col-lg-8 ftco-animate">
            <div class="text w-100 text-center mb-md-5 pb-md-5">
              <h1 class="mb-4">Fast &amp; Easy Way To Rent A Car</h1>
              <p style="font-size: 18px">
                Discover the best car rental experience with AutoRental. We
                offer a wide range of vehicles, affordable prices, and excellent
                customer service to make your journey comfortable and
                convenient.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!--                 2. Booking Form/Quick Search 
                        <section class="ftco-section ftco-no-pt bg-light">
                            <div class="container">
                                <div class="row no-gutters">
                                    <div class="col-md-12 featured-top">
                                        <div class="row no-gutters">
                                            <div class="col-md-4 d-flex align-items-center">
                                                <form action="#" class="request-form ftco-animate bg-primary">
                                                    <h2>Make your trip</h2>
                                                    <div class="form-group">
                                                        <label for="" class="label">Pick-up location</label>
                                                        <input type="text" class="form-control"
                                                            placeholder="City, Airport, Station, etc">
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="" class="label">Drop-off location</label>
                                                        <input type="text" class="form-control"
                                                            placeholder="City, Airport, Station, etc">
                                                    </div>
                                                    <div class="d-flex">
                                                        <div class="form-group mr-2">
                                                            <label for="" class="label">Pick-up date</label>
                                                            <input type="text" class="form-control" id="book_pick_date"
                                                                placeholder="Date">
                                                        </div>
                                                        <div class="form-group ml-2">
                                                            <label for="" class="label">Drop-off date</label>
                                                            <input type="text" class="form-control" id="book_off_date"
                                                                placeholder="Date">
                                                        </div>
                                                    </div>
                                                    <div class="form-group">
                                                        <label for="" class="label">Pick-up time</label>
                                                        <input type="text" class="form-control" id="time_pick"
                                                            placeholder="Time">
                                                    </div>
                                                    <div class="form-group">
                                                        <input type="submit" value="Rent A Car Now"
                                                            class="btn btn-secondary py-3 px-4">
                                                    </div>
                                                </form>
                                            </div>
                                            <div class="col-md-8 d-flex align-items-center">
                                                <div class="services-wrap rounded-right w-100">
                                                    <h3 class="heading-section mb-4">Better Way to Rent Your Perfect Cars</h3>
                                                    <div class="row d-flex mb-4">
                                                        <div class="col-md-4 d-flex align-self-stretch ftco-animate">
                                                            <div class="services w-100 text-center">
                                                                <div
                                                                    class="icon d-flex align-items-center justify-content-center">
                                                                    <span class="flaticon-route"></span></div>
                                                                <div class="text w-100">
                                                                    <h3 class="heading mb-2">Choose Your Pickup Location</h3>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4 d-flex align-self-stretch ftco-animate">
                                                            <div class="services w-100 text-center">
                                                                <div
                                                                    class="icon d-flex align-items-center justify-content-center">
                                                                    <span class="flaticon-handshake"></span></div>
                                                                <div class="text w-100">
                                                                    <h3 class="heading mb-2">Select the Best Deal</h3>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-4 d-flex align-self-stretch ftco-animate">
                                                            <div class="services w-100 text-center">
                                                                <div
                                                                    class="icon d-flex align-items-center justify-content-center">
                                                                    <span class="flaticon-rent"></span></div>
                                                                <div class="text w-100">
                                                                    <h3 class="heading mb-2">Reserve Your Rental Car</h3>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <p><a href="#" class="btn btn-primary py-3 px-4">Reserve Your Perfect
                                                            Car</a></p>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                        </section>-->

    <!-- 3. Featured Vehicles -->
    <section class="ftco-section ftco-no-pt bg-light">
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-md-12 heading-section text-center ftco-animate mb-5">
            <span class="subheading" style="color: #5fcf86">What we offer</span>
            <h2 class="mb-2">Featured Vehicles</h2>
          </div>
        </div>
        <div class="row">
          <div class="container">
            <div class="row">
              <c:forEach var="car" items="${carList}" varStatus="status">
                <c:if test="${status.index < 6}">
                  <div class="col-md-4 mb-4">
                    <a
                      href="${pageContext.request.contextPath}/pages/car-single?id=${car.carId}"
                      class="text-decoration-none"
                      style="display: block; color: inherit"
                    >
                      <div
                        class="car-wrap rounded ftco-animate"
                        style="
                          border: 1.5px solid #e0e0e0;
                          border-radius: 18px !important;
                          overflow: hidden;
                        "
                      >
                        <div
                          class="img rounded d-flex align-items-end"
                          style="
                            background-image: url('${pageContext.request.contextPath}${car.mainImageUrl}');
                            border-radius: 18px 18px 0 0;
                          "
                        ></div>
                        <div class="card-body pb-2">
                          <div
                            class="d-flex align-items-center justify-content-between mb-2"
                          >
                            <span
                              class="card-title mb-0"
                              style="font-size: 1.1rem; font-weight: 600"
                            >
                              ${car.carModel}
                            </span>
                            <span
                              class="badge ${car.statusCssClass}"
                              style="min-width: 70px; text-align: center"
                              >${car.statusDisplay}</span
                            >
                          </div>
                          <!-- Thông tin số, chỗ, nhiên liệu -->
                          <div
                            class="d-flex justify-content-between align-items-center mt-2"
                            style="font-size: 0.78rem; color: #888; gap: 0.5rem"
                          >
                            <span
                              class="d-flex align-items-center"
                              style="min-width: 90px"
                              ><i
                                class="bi bi-gear-wide-connected me-1"
                                style="font-size: 1.1em"
                              ></i
                              >${car.transmissionTypeName}</span
                            >
                            <span
                              class="d-flex align-items-center"
                              style="min-width: 70px"
                              ><i
                                class="bi bi-person-fill me-1"
                                style="font-size: 1.1em"
                              ></i
                              >${car.seats} seats</span
                            >
                            <span
                              class="d-flex align-items-center"
                              style="min-width: 90px"
                              ><i
                                class="bi bi-fuel-pump me-1"
                                style="font-size: 1.1em"
                              ></i
                              >${car.fuelName}</span
                            >
                          </div>
                          <!-- Rating dưới cùng, không có số chuyến -->
                          <div
                            class="d-flex align-items-center mt-3"
                            style="font-size: 0.95rem"
                          >
                            <i class="bi bi-star-fill text-warning me-1"></i>
                            <span class="fw-bold" style="color: #444">
                              <c:choose>
                                <c:when test="${car.averageRating != null}">
                                  <fmt:formatNumber
                                    value="${car.averageRating}"
                                    pattern="#.#"
                                    minFractionDigits="0"
                                    maxFractionDigits="1"
                                  />
                                </c:when>
                                <c:otherwise>0</c:otherwise>
                              </c:choose>
                            </span>
                            <span class="mx-2">•</span>
                            <span
                              class="fw-bold"
                              style="color: #5fcf86; font-size: 1.15rem"
                            >
                              <fmt:formatNumber
                                value="${car.pricePerHour * 1000}"
                                type="number"
                                pattern="#,#00"
                              />
                            </span>
                            <span
                              class="ms-1"
                              style="color: #888; font-size: 1rem"
                              >VND/hour</span
                            >
                          </div>
                        </div>
                      </div>
                    </a>
                  </div>
                </c:if>
              </c:forEach>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- 5. About Us (Custom Layout) -->
    <section class="container py-5">
      <!-- Top row: Title & description -->
      <div class="row mb-4 align-items-start">
        <div class="col-lg-3 mb-3 mb-lg-0 d-flex align-items-start">
          <h1
            class="fw-bold mb-3 text-break"
            style="
              font-size: 2.2rem;
              line-height: 1.2;
              font-family: 'Poppins', Arial, sans-serif;
            "
          >
            AutoRental – With you on every journey
          </h1>
        </div>
        <div class="col-lg-9 d-flex align-items-start">
          <div
            style="
              color: #222;
              font-size: 1.2rem;
              font-family: 'Poppins', Arial, sans-serif;
              text-align: justify;
              max-width: 95%;
            "
          >
            Every trip is a journey to explore life and the world around us—a
            chance to learn and conquer new things, making each individual
            better. Therefore, customer experience quality is always our top
            priority and the source of inspiration for the AutoRental team.<br /><br />
            AutoRental is a car-sharing platform. Our mission goes beyond simply
            connecting car owners and customers quickly, safely, and
            conveniently. We aim to inspire the community to DISCOVER new things
            through every journey on our platform.
          </div>
        </div>
      </div>
      <!-- Bottom row: 1 image -->
      <div class="row g-3">
        <div class="col-12">
          <img
            src="${pageContext.request.contextPath}/assets/images/about/aboutus1.4c31a699.png"
            class="img-fluid rounded-4 w-100"
            alt="About 1"
            style="min-height: 320px; object-fit: cover"
          />
        </div>
      </div>
    </section>

    <!-- 6. Drive Explore Inspire Section -->
    <section class="container py-5">
      <div class="row align-items-center">
        <!-- Bên trái: Tiêu đề + mô tả -->
        <div class="col-lg-6 mb-4 mb-lg-0">
          <h1
            class="fw-bold mb-3"
            style="
              font-size: 3rem;
              font-family: 'Poppins', Arial, sans-serif;
              color: #222;
            "
          >
            Drive. Explore. Inspire
          </h1>
          <p class="mb-2" style="color: #222; font-size: 1.2rem">
            <b>Drive</b> and <b>Explore</b> a world full of <b>Inspiration</b>.
          </p>
          <p style="color: #222; font-size: 1.2rem">
            AutoRental aims to become the #1 reputable and civilized car-sharing
            community in Vietnam, bringing practical value to all members for a
            better life.
          </p>
          <p style="color: #222; font-size: 1.2rem">
            We believe that every journey matters. That’s why the AutoRental
            team and our partners, with extensive experience in car rental,
            technology, insurance, and tourism, will bring you new, exciting,
            and safe experiences on every trip.
          </p>
        </div>
        <!-- Bên phải: Ảnh -->
        <div class="col-lg-6">
          <img
            src="${pageContext.request.contextPath}/assets/images/about/aboutus2.18999daf.png"
            class="img-fluid rounded-4 w-100"
            alt="Drive Explore Inspire"
            style="min-height: 320px; object-fit: cover"
          />
        </div>
      </div>
    </section>

    <!-- 4. How to Rent a Car (Modern Style, Inline Step Title) -->
    <section class="container py-5 mt-5">
      <div class="text-center mb-4">
        <h2 class="fw-bold" style="font-size: 2.5rem">How to Rent a Car</h2>
        <p class="mb-0" style="color: #444; font-size: 1.2rem">
          Just 4 simple steps to experience car rental with AutoRental quickly
          and easily
        </p>
      </div>
      <div class="row justify-content-center g-4">
        <div
          class="col-12 col-sm-6 col-lg-3 d-flex flex-column align-items-center"
        >
          <div
            class="mb-3 d-flex align-items-center justify-content-center"
            style="
              width: 96px;
              height: 96px;
              background: #eafaf0;
              border-radius: 20px;
            "
          >
            <i
              class="bi bi-phone"
              style="font-size: 2.5rem; color: #4cd964"
            ></i>
          </div>
          <div
            class="d-flex align-items-baseline"
            style="width: 100%; justify-content: flex-start"
          >
            <span
              style="
                color: #5fcf86;
                font-weight: bold;
                font-size: 1.5rem;
                min-width: 2.5rem;
              "
              >01</span
            >
            <span
              class="fw-bold"
              style="
                font-size: 1.25rem;
                color: #111;
                margin-left: 0.5rem;
                text-align: left;
                line-height: 1.2;
              "
              >Book a car on<br />AutoRental app/web</span
            >
          </div>
        </div>
        <div
          class="col-12 col-sm-6 col-lg-3 d-flex flex-column align-items-center"
        >
          <div
            class="mb-3 d-flex align-items-center justify-content-center"
            style="
              width: 96px;
              height: 96px;
              background: #eafaf0;
              border-radius: 20px;
            "
          >
            <i
              class="bi bi-car-front"
              style="font-size: 2.5rem; color: #4cd964"
            ></i>
          </div>
          <div
            class="d-flex align-items-baseline"
            style="width: 100%; justify-content: flex-start"
          >
            <span
              style="
                color: #5fcf86;
                font-weight: bold;
                font-size: 1.5rem;
                min-width: 2.5rem;
              "
              >02</span
            >
            <span
              class="fw-bold"
              style="
                font-size: 1.25rem;
                color: #111;
                margin-left: 0.5rem;
                text-align: left;
                line-height: 1.2;
              "
              >Receive the car</span
            >
          </div>
        </div>
        <div
          class="col-12 col-sm-6 col-lg-3 d-flex flex-column align-items-center"
        >
          <div
            class="mb-3 d-flex align-items-center justify-content-center"
            style="
              width: 96px;
              height: 96px;
              background: #eafaf0;
              border-radius: 20px;
            "
          >
            <i
              class="bi bi-geo-alt"
              style="font-size: 2.5rem; color: #4cd964"
            ></i>
          </div>
          <div
            class="d-flex align-items-baseline"
            style="width: 100%; justify-content: flex-start"
          >
            <span
              style="
                color: #5fcf86;
                font-weight: bold;
                font-size: 1.5rem;
                min-width: 2.5rem;
              "
              >03</span
            >
            <span
              class="fw-bold"
              style="
                font-size: 1.25rem;
                color: #111;
                margin-left: 0.5rem;
                text-align: left;
                line-height: 1.2;
              "
              >Start your journey</span
            >
          </div>
        </div>
        <div
          class="col-12 col-sm-6 col-lg-3 d-flex flex-column align-items-center"
        >
          <div
            class="mb-3 d-flex align-items-center justify-content-center"
            style="
              width: 96px;
              height: 96px;
              background: #eafaf0;
              border-radius: 20px;
            "
          >
            <i class="bi bi-star" style="font-size: 2.5rem; color: #4cd964"></i>
          </div>
          <div
            class="d-flex align-items-baseline"
            style="width: 100%; justify-content: flex-start"
          >
            <span
              style="
                color: #5fcf86;
                font-weight: bold;
                font-size: 1.5rem;
                min-width: 2.5rem;
              "
              >04</span
            >
            <span
              class="fw-bold"
              style="
                font-size: 1.25rem;
                color: #111;
                margin-left: 0.5rem;
                text-align: left;
                line-height: 1.2;
              "
              >Return the car & finish<br />your trip</span
            >
          </div>
        </div>
      </div>
    </section>

    <!-- 6. Services -->
    <!-- <section class="ftco-section">
            <div class="container">
                <div class="row justify-content-center mb-5">
                    <div class="col-md-7 text-center heading-section ftco-animate">
                        <span class="subheading">Services</span>
                        <h2 class="mb-3">Our Latest Services</h2>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <div class="services services-2 w-100 text-center">
                            <div class="icon d-flex align-items-center justify-content-center"><span
                                    class="flaticon-wedding-car"></span></div>
                            <div class="text w-100">
                                <h3 class="heading mb-2">Wedding Ceremony</h3>
                                <p>A small river named Duden flows by their place and supplies it with the
                                    necessary regelialia.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="services services-2 w-100 text-center">
                            <div class="icon d-flex align-items-center justify-content-center"><span
                                    class="flaticon-transportation"></span></div>
                            <div class="text w-100">
                                <h3 class="heading mb-2">City Transfer</h3>
                                <p>A small river named Duden flows by their place and supplies it with the
                                    necessary regelialia.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="services services-2 w-100 text-center">
                            <div class="icon d-flex align-items-center justify-content-center"><span
                                    class="flaticon-car"></span></div>
                            <div class="text w-100">
                                <h3 class="heading mb-2">Airport Transfer</h3>
                                <p>A small river named Duden flows by their place and supplies it with the
                                    necessary regelialia.</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="services services-2 w-100 text-center">
                            <div class="icon d-flex align-items-center justify-content-center"><span
                                    class="flaticon-transportation"></span></div>
                            <div class="text w-100">
                                <h3 class="heading mb-2">Whole City Tour</h3>
                                <p>A small river named Duden flows by their place and supplies it with the
                                    necessary regelialia.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section> -->

    <!-- 7. Testimonial
                <section class="ftco-section testimony-section bg-light">
                    <div class="container">
                        <div class="row justify-content-center mb-5">
                            <div class="col-md-7 text-center heading-section ftco-animate">
                                <span class="subheading">Testimonial</span>
                                <h2 class="mb-3">Happy Clients</h2>
                            </div>
                        </div>
                        <div class="row ftco-animate">
                            <div class="col-md-12">
                                <div class="carousel-testimony owl-carousel ftco-owl">
                                    <div class="item">
                                        <div class="testimony-wrap rounded text-center py-4 pb-5">
                                            <div class="user-img mb-2"
                                                style="background-image: url('${pageContext.request.contextPath}/assets/images/person_1.jpg')">
                                            </div>
                                            <div class="text pt-4">
                                                <p class="mb-4">Far far away, behind the word mountains, far from the
                                                    countries Vokalia and Consonantia, there live the blind texts.</p>
                                                <p class="name">Roger Scott</p>
                                                <span class="position">Marketing Manager</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="item">
                                        <div class="testimony-wrap rounded text-center py-4 pb-5">
                                            <div class="user-img mb-2"
                                                style="background-image: url('${pageContext.request.contextPath}/assets/images/person_2.jpg')">
                                            </div>
                                            <div class="text pt-4">
                                                <p class="mb-4">Far far away, behind the word mountains, far from the
                                                    countries Vokalia and Consonantia, there live the blind texts.</p>
                                                <p class="name">Roger Scott</p>
                                                <span class="position">Interface Designer</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="item">
                                        <div class="testimony-wrap rounded text-center py-4 pb-5">
                                            <div class="user-img mb-2"
                                                style="background-image: url('${pageContext.request.contextPath}/assets/images/person_3.jpg')">
                                            </div>
                                            <div class="text pt-4">
                                                <p class="mb-4">Far far away, behind the word mountains, far from the
                                                    countries Vokalia and Consonantia, there live the blind texts.</p>
                                                <p class="name">Roger Scott</p>
                                                <span class="position">UI Designer</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="item">
                                        <div class="testimony-wrap rounded text-center py-4 pb-5">
                                            <div class="user-img mb-2"
                                                style="background-image: url('${pageContext.request.contextPath}/assets/images/person_1.jpg')">
                                            </div>
                                            <div class="text pt-4">
                                                <p class="mb-4">Far far away, behind the word mountains, far from the
                                                    countries Vokalia and Consonantia, there live the blind texts.</p>
                                                <p class="name">Roger Scott</p>
                                                <span class="position">Web Developer</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="item">
                                        <div class="testimony-wrap rounded text-center py-4 pb-5">
                                            <div class="user-img mb-2"
                                                style="background-image: url('${pageContext.request.contextPath}/assets/images/person_1.jpg')">
                                            </div>
                                            <div class="text pt-4">
                                                <p class="mb-4">Far far away, behind the word mountains, far from the
                                                    countries Vokalia and Consonantia, there live the blind texts.</p>
                                                <p class="name">Roger Scott</p>
                                                <span class="position">System Analyst</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </section> -->

    <!-- 8. Blog/News -->
    <!-- <section class="ftco-section">
            <div class="container">
                <div class="row justify-content-center mb-5">
                    <div class="col-md-7 heading-section text-center ftco-animate">
                        <span class="subheading">Blog</span>
                        <h2>Auto Rental Blog</h2>
                    </div>
                </div>
                <div class="row d-flex">
                    <div class="col-md-4 d-flex ftco-animate">
                        <div class="blog-entry justify-content-end">
                            <a href="blog-single.jsp" class="block-20"
                               style="background-image: url('${pageContext.request.contextPath}/assets/images/image_1.jpg');">
                            </a>
                            <div class="text pt-4">
                                <div class="meta mb-3">
                                    <div><a href="#">Oct. 29, 2019</a></div>
                                    <div><a href="#">Admin</a></div>
                                    <div><a href="#" class="meta-chat"><span class="icon-chat"></span> 3</a>
                                    </div>
                                </div>
                                <h3 class="heading mt-2"><a href="#">Why Lead Generation is Key for Business
                                        Growth</a></h3>
                                <p><a href="#" class="btn btn-primary">Read more</a></p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 d-flex ftco-animate">
                        <div class="blog-entry justify-content-end">
                            <a href="blog-single.jsp" class="block-20"
                               style="background-image: url('${pageContext.request.contextPath}/assets/images/image_2.jpg');">
                            </a>
                            <div class="text pt-4">
                                <div class="meta mb-3">
                                    <div><a href="#">Oct. 29, 2019</a></div>
                                    <div><a href="#">Admin</a></div>
                                    <div><a href="#" class="meta-chat"><span class="icon-chat"></span> 3</a>
                                    </div>
                                </div>
                                <h3 class="heading mt-2"><a href="#">Why Lead Generation is Key for Business
                                        Growth</a></h3>
                                <p><a href="#" class="btn btn-primary">Read more</a></p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 d-flex ftco-animate">
                        <div class="blog-entry">
                            <a href="blog-single.jsp" class="block-20"
                               style="background-image: url('${pageContext.request.contextPath}/assets/images/image_3.jpg');">
                            </a>
                            <div class="text pt-4">
                                <div class="meta mb-3">
                                    <div><a href="#">Oct. 29, 2019</a></div>
                                    <div><a href="#">Admin</a></div>
                                    <div><a href="#" class="meta-chat"><span class="icon-chat"></span> 3</a>
                                    </div>
                                </div>
                                <h3 class="heading mt-2"><a href="#">Why Lead Generation is Key for Business
                                        Growth</a></h3>
                                <p><a href="#" class="btn btn-primary">Read more</a></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section> -->

    <!-- 9. Call to Action (Become a Driver) -->
    <!-- <section class="ftco-section ftco-intro" style="background-image: url('${pageContext.request.contextPath}/assets/images/bg_3.jpg');">
            <div class="overlay"></div>
            <div class="container">
                <div class="row justify-content-end">
                    <div class="col-md-6 heading-section heading-section-white ftco-animate">
                        <h2 class="mb-3">Do You Want To Earn With Us? So Don't Be Late.</h2>
                        <a href="#" class="btn btn-primary btn-lg">Become A Driver</a>
                    </div>
                </div>
            </div>
        </section> -->

    <!-- 10. Counter/Statistics -->
    <!--        <section class="ftco-counter ftco-section img bg-light" id="section-counter">
            <div class="overlay"></div>
            <div class="container">
                <div class="row">
                    <div class="col-md-6 col-lg-3 justify-content-center counter-wrap ftco-animate">
                        <div class="block-18">
                            <div class="text text-border d-flex align-items-center">
                                <strong class="number" data-number="60">0</strong>
                                <span>Year <br>Experienced</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3 justify-content-center counter-wrap ftco-animate">
                        <div class="block-18">
                            <div class="text text-border d-flex align-items-center">
                                <strong class="number" data-number="1090">0</strong>
                                <span>Total <br>Cars</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3 justify-content-center counter-wrap ftco-animate">
                        <div class="block-18">
                            <div class="text text-border d-flex align-items-center">
                                <strong class="number" data-number="2590">0</strong>
                                <span>Happy <br>Customers</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6 col-lg-3 justify-content-center counter-wrap ftco-animate">
                        <div class="block-18">
                            <div class="text d-flex align-items-center">
                                <strong class="number" data-number="67">0</strong>
                                <span>Total <br>Branches</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <c:if test="${sessionScope.isLoggedIn}">
      <script
        src="https://messenger.svc.chative.io/static/v1.0/channels/sdb66d1a7-bfed-449d-96c8-b8ff21fed2dc/messenger.js?mode=livechat"
        defer="defer"
      ></script>
    </c:if>
        </section>--><c:if test="${sessionScope.isLoggedIn}">
      <script src="https://messenger.svc.chative.io/static/v1.0/channels/s9bdc024e-8500-44b2-a7d1-ebf04f1100fc/messenger.js?mode=livechat" defer="defer"></script>
    </c:if>

    <!-- Self-drive Car Rental Section (Image Left, Large, Balanced Text) -->
    <section class="container py-5 mt-5">
      <!-- Thêm mt-5 để tăng khoảng cách phía trên -->
      <div class="row align-items-center justify-content-center">
        <div
          class="col-12 col-lg-6 d-flex justify-content-center align-items-center mb-4 mb-lg-0"
        >
          <img
            src="${pageContext.request.contextPath}/assets/images/about/thue_xe.png"
            alt="Self-drive car"
            class="img-fluid rounded-4"
            style="max-width: 100%; height: 320px; object-fit: cover"
          />
        </div>
        <div
          class="col-12 col-lg-6 d-flex flex-column justify-content-center align-items-start"
        >
          <h2
            class="fw-bold mb-3"
            style="font-size: 2.7rem; color: #222; line-height: 1.15"
          >
            The car is ready.<br />Start your journey now!
          </h2>
          <p
            class="mb-4"
            style="
              color: #444;
              font-size: 1.25rem;
              max-width: 600px;
              line-height: 1.5;
            "
          >
            Take the wheel of your favorite car and make your trip more
            exciting.
          </p>
          <a
            href="${pageContext.request.contextPath}/pages/car"
            class="btn btn-selfdrive"
            >Rent a car</a
          >
        </div>
      </div>
    </section>

    <jsp:include page="includes/footer.jsp" />

    <!-- loader -->
    <div id="ftco-loader" class="show fullscreen">
      <svg class="circular" width="48px" height="48px">
        <circle
          class="path-bg"
          cx="24"
          cy="24"
          r="22"
          fill="none"
          stroke-width="4"
          stroke="#eeeeee"
        />
        <circle
          class="path"
          cx="24"
          cy="24"
          r="22"
          fill="none"
          stroke-width="4"
          stroke-miterlimit="10"
          stroke="#F96D00"
        />
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
    <script src="${pageContext.request.contextPath}/assets/js/jquery.magnific-popup.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/aos.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.animateNumber.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/bootstrap-datepicker.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/jquery.timepicker.min.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/scrollax.min.js"></script>
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBVWaKrjvy3MaE7SQ74_uJiULgl1JY0H2s&sensor=false"></script>
    <script src="${pageContext.request.contextPath}/assets/js/google-map.js"></script>
    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
    <script src="${pageContext.request.contextPath}/scripts/common/index.js"></script>
    <script src="${pageContext.request.contextPath}/scripts/common/user-notification.js"></script>
  </body>
</html>
