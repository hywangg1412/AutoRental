<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="Model.DTO.CarDetailDTO" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%
    CarDetailDTO car = (CarDetailDTO) request.getAttribute("car");
%>
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
        <link href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap" rel="stylesheet">

     

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
        
        <!-- ===== Page Styles (Load Last for Priority) ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/car-single.css?v=<%=System.currentTimeMillis()%>">

           <!-- ===== NavBar Styles ===== -->
           <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/nav.css">
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
                            <p class="price ml-auto"><fmt:formatNumber value="${car.pricePerDay * 1000}" type="number" pattern="#,###,###" /> <span>&nbsp;VND/day</span></p>
                            <div class="price-label">Price per hour</div>
                            <p class="price ml-auto"><fmt:formatNumber value="${car.pricePerHour * 1000}" type="number" pattern="#,###" /> <span>&nbsp;VND/hour</span></p>
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
                                        <a class="nav-link active" id="pills-description-tab" data-bs-toggle="pill" href="#pills-description" role="tab" aria-controls="pills-description" aria-selected="true">Features</a>
                                    </li>
                                    <li class="nav-item">
                                        <a class="nav-link" id="pills-manufacturer-tab" data-bs-toggle="pill" href="#pills-manufacturer" role="tab" aria-controls="pills-manufacturer" aria-selected="false">Description</a>
                                    </li>
                                    <!-- Tab Review -->
                                    <li class="nav-item">
                                        <a class="nav-link" id="pills-review-tab" data-bs-toggle="pill" href="#pills-review" role="tab" aria-controls="pills-review" aria-selected="false">Reviews</a>
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

                                <!-- Tab Content cho Review -->
                                <div class="tab-pane fade" id="pills-review" role="tabpanel" aria-labelledby="pills-review-tab">
    <div class="review-section-row">
        <div class="review-list-col">
                                            <h3 class="head">${totalReviews} Reviews</h3>
            <c:choose>
                <c:when test="${empty reviews && userReview == null}">
                    <div class="alert alert-info">
                                                        No reviews yet. Be the first to review this car!
                    </div>
                </c:when>
                <c:otherwise>
                    <!-- Đánh giá của người dùng hiện tại -->
                    <c:if test="${userReview != null}">
                        <div class="review d-flex mb-4 border p-3 rounded" style="background-color: #f8f9fa;" data-feedback-id="${userReview.feedbackId}">
                            <div class="user-img me-3" style="background-image: url('${not empty userReview.userAvatar ? fn:escapeXml(userReview.userAvatar) : pageContext.request.contextPath}/assets/images/person_1.jpg'); width: 60px; height: 60px; border-radius: 50%; background-size: cover;"></div>
                            <div class="desc flex-grow-1">
                                <div class="d-flex justify-content-between mb-2">
                                    <h5 class="mb-0">${not empty userReview.username ? fn:escapeXml(userReview.username) : userName}</h5>
                                    <div class="d-flex align-items-center">
                                        <small class="text-muted me-3">${userReview.formattedCreatedDate}</small>
                                        <button class="btn btn-sm btn-outline-primary edit-feedback" data-bs-toggle="modal" data-bs-target="#editFeedbackModal" data-feedback-id="${userReview.feedbackId}" data-rating="${userReview.rating}" data-content="${fn:escapeXml(userReview.content)}">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>
                                    </div>
                                </div>
                                <div class="review-content p-3 rounded" style="background-color: #e9ecef;">
                                    <p class="mb-1"><strong>Rating:</strong> ${userReview.rating}/5 ${userReview.ratingStarsHtml}</p>
                                    <p class="mb-1"><strong>Content:</strong> ${fn:escapeXml(userReview.content)}</p>
                                    <p class="mb-0"><strong>Date:</strong> ${userReview.formattedCreatedDate}</p>
                                    <c:if test="${sessionScope.userId == userReview.userId.toString()}">
                                        <p class="mb-0"><small class="text-muted">Booking Code: ${not empty userReview.bookingCode ? userReview.bookingCode : 'N/A'}</small></p>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Hiển thị tất cả các đánh giá khác của người dùng hiện tại -->
                        <c:if test="${not empty userOtherReviews}">
                            <h5 class="mb-3">Previous Reviews</h5>
                            <c:forEach var="review" items="${userOtherReviews}">
                                <div class="review d-flex mb-4 border p-3 rounded" style="background-color: #f8f9fa;" data-feedback-id="${review.feedbackId}">
                                    <div class="user-img me-3" style="background-image: url('${not empty review.userAvatar ? fn:escapeXml(review.userAvatar) : pageContext.request.contextPath}/assets/images/person_1.jpg'); width: 60px; height: 60px; border-radius: 50%; background-size: cover;"></div>
                                    <div class="desc flex-grow-1">
                                        <div class="d-flex justify-content-between mb-2">
                                            <h5 class="mb-0">${not empty review.username ? fn:escapeXml(review.username) : userName}</h5>
                                            <div class="d-flex align-items-center">
                                                <small class="text-muted me-3">${review.formattedCreatedDate}</small>
                                                <button class="btn btn-sm btn-outline-primary edit-feedback" data-bs-toggle="modal" data-bs-target="#editFeedbackModal" data-feedback-id="${review.feedbackId}" data-rating="${review.rating}" data-content="${fn:escapeXml(review.content)}">
                                                    <i class="fas fa-edit"></i> Edit
                                                </button>
                                            </div>
                                        </div>
                                        <div class="review-content p-3 rounded" style="background-color: #e9ecef;">
                                            <p class="mb-1"><strong>Rating:</strong> ${review.rating}/5 ${review.ratingStarsHtml}</p>
                                            <p class="mb-1"><strong>Content:</strong> ${fn:escapeXml(review.content)}</p>
                                            <p class="mb-0"><strong>Date:</strong> ${review.formattedCreatedDate}</p>
                                            <c:if test="${sessionScope.userId == review.userId.toString()}">
                                                <p class="mb-0"><small class="text-muted">Booking Code: ${not empty review.bookingCode ? review.bookingCode : 'N/A'}</small></p>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:if>
                    </c:if>
                    <!-- Đánh giá của người dùng khác -->
                    <c:forEach var="review" items="${reviews}">
                        <div class="review d-flex mb-4 border p-3 rounded" style="background-color: #f8f9fa;" data-feedback-id="${review.feedbackId}">
                            <div class="user-img me-3" style="background-image: url('${not empty review.userAvatar ? fn:escapeXml(review.userAvatar) : pageContext.request.contextPath}/assets/images/person_1.jpg'); width: 60px; height: 60px; border-radius: 50%; background-size: cover;"></div>
                            <div class="desc flex-grow-1">
                                <div class="d-flex justify-content-between mb-2">
                                                                    <h5 class="mb-0">${not empty review.username ? fn:escapeXml(review.username) : 'User'}</h5>
                                                                    <div class="d-flex align-items-center">
                                                                        <small class="text-muted me-3">${review.formattedCreatedDate}</small>
                                                                        <!-- Hiển thị nút Edit chỉ khi đánh giá thuộc về người dùng hiện tại -->
                                <c:if test="${sessionScope.userId == review.userId}">
                                                                            <button class="btn btn-sm btn-outline-primary edit-feedback" data-bs-toggle="modal" data-bs-target="#editFeedbackModal" data-feedback-id="${review.feedbackId}" data-rating="${review.rating}" data-content="${fn:escapeXml(review.content)}">
                                                                                <i class="fas fa-edit"></i> Edit
                                                                            </button>
                                </c:if>
                                                                    </div>
                                                                </div>
                                                                <div class="review-content p-3 rounded" style="background-color: #e9ecef;">
                                                                    <p class="mb-1"><strong>Rating:</strong> ${review.rating}/5 ${review.ratingStarsHtml}</p>
                                                                    <p class="mb-1"><strong>Content:</strong> ${fn:escapeXml(review.content)}</p>
                                                                    <p class="mb-0"><strong>Date:</strong> ${review.formattedCreatedDate}</p>
                                                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
        <div class="review-summary-col">
            <div class="rating-wrap">
                                                <h3 class="head">Average Rating: ${averageRating != null ? fn:escapeXml(String.format('%.2f', averageRating)) : 'None'} / 5</h3>
                <c:if test="${canReview && userReview == null}">
                    <form id="reviewForm" action="${pageContext.request.contextPath}/review" method="post">
                        <input type="hidden" name="carId" value="${car.carId}">
                        <div class="mb-3">
                                                            <label for="rating" class="form-label">Select rating:</label>
                            <select class="form-select" name="rating" id="rating" required>
                                                                <option value="5">★★★★★ - Excellent</option>
                                                                <option value="4">★★★★ - Good</option>
                                                                <option value="3">★★★ - Average</option>
                                                                <option value="2">★★ - Poor</option>
                                                                <option value="1">★ - Very Poor</option>
                            </select>
                        </div>
                        <div class="mb-3">
                                                            <label for="content" class="form-label">Comment:</label>
                            <textarea class="form-control" name="content" id="content" rows="4" required></textarea>
                        </div>
                                                        <button type="submit" class="btn btn-primary">Submit Review</button>
                    </form>
                </c:if>
                                                
                                                <!-- Hiển thị form đánh giá mới khi người dùng đã có đánh giá nhưng vẫn có thể thêm đánh giá mới -->
                                                <c:if test="${canReview && userReview != null}">
                                                    <div class="mt-4">
                                                        <button id="showNewReviewFormBtn" class="btn btn-outline-primary mb-3">
                                                            <i class="fas fa-plus-circle"></i> Add New Review
                                                        </button>
                                                        <div id="newReviewFormContainer" style="display: none;">
                                                            <form id="newReviewForm" action="${pageContext.request.contextPath}/review" method="post">
                                                                <input type="hidden" name="carId" value="${car.carId}">
                                                                <div class="mb-3">
                                                                    <label for="newRating" class="form-label">Select rating:</label>
                                                                    <select class="form-select" name="rating" id="newRating" required>
                                                                        <option value="5">★★★★★ - Excellent</option>
                                                                        <option value="4">★★★★ - Good</option>
                                                                        <option value="3">★★★ - Average</option>
                                                                        <option value="2">★★ - Poor</option>
                                                                        <option value="1">★ - Very Poor</option>
                                                                    </select>
                                                                </div>
                                                                <div class="mb-3">
                                                                    <label for="newContent" class="form-label">Comment:</label>
                                                                    <textarea class="form-control" name="content" id="newContent" rows="4" required></textarea>
                                                                </div>
                                                                <button type="submit" class="btn btn-primary">Submit New Review</button>
                                                                <button type="button" class="btn btn-secondary ms-2" id="cancelNewReviewBtn">Cancel</button>
                                                            </form>
                                                        </div>
                                                    </div>
                                                </c:if>
                                                
                <c:if test="${not canReview || userReview != null}">
                    <p class="alert alert-info">
                        <c:choose>
                                                            <c:when test="${userReview != null and not canReview}">
                                                                You have already submitted a review for this car.
                                                            </c:when>
                                                            <c:when test="${userReview != null and canReview}">
                                                                You have already submitted a review for this car, but you can add another review for your latest completed booking.
                            </c:when>
                            <c:otherwise>
                                                                You need to login and have a completed booking to submit a review.
                            </c:otherwise>
                        </c:choose>
                    </p>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Modal chỉnh sửa đánh giá -->
    <div class="modal fade" id="editFeedbackModal" tabindex="-1" aria-labelledby="editFeedbackModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                                                    <h5 class="modal-title" id="editFeedbackModalLabel">Edit Review</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="editFeedbackMessage" class="alert d-none"></div>
                    <form id="editFeedbackForm" method="post">
                        <input type="hidden" name="feedbackId" id="editFeedbackId">
                        <div class="mb-3">
                                                            <label for="editRating" class="form-label">Select rating:</label>
                            <select class="form-select" name="rating" id="editRating" required>
                                                                <option value="5">★★★★★ - Excellent</option>
                                                                <option value="4">★★★★ - Good</option>
                                                                <option value="3">★★★ - Average</option>
                                                                <option value="2">★★ - Poor</option>
                                                                <option value="1">★ - Very Poor</option>
                            </select>
                        </div>
                        <div class="mb-3">
                                                            <label for="editContent" class="form-label">Comment:</label>
                            <textarea class="form-control" name="content" id="editContent" rows="4" required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Update</button>
                    </form>
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

        <!-- Modal thông báo thành công -->
        <div class="modal fade" id="successModal" tabindex="-1" aria-labelledby="successModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="successModalLabel">Success</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="d-flex align-items-center">
                            <i class="bi bi-check-circle-fill text-success me-3" style="font-size: 2rem;"></i>
                            <div>
                                <h6 class="mb-0">Review submitted successfully!</h6>
                                <p class="mb-0 text-muted">Thank you for your feedback.</p>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-success" data-bs-dismiss="modal">OK</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Modal thông báo cập nhật thành công -->
        <div class="modal fade" id="updateSuccessModal" tabindex="-1" aria-labelledby="updateSuccessModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="updateSuccessModalLabel">Update Successful</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="d-flex align-items-center">
                            <i class="bi bi-pencil-fill text-primary me-3" style="font-size: 2rem;"></i>
                            <div>
                                <h6 class="mb-0">Review has been updated!</h6>
                                <p class="mb-0 text-muted">Your changes have been saved.</p>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" data-bs-dismiss="modal">OK</button>
                    </div>
                </div>
            </div>
        </div>

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
        <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
        
        <!-- Bootstrap 5 JS for modal functionality -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        
        <!-- Car single page functionality -->
        <script src="${pageContext.request.contextPath}/scripts/car/car-single.js"></script>
        
        <script>
    // Global variables for car-single.js
    const contextPath = '${pageContext.request.contextPath}';
    const carId = '${car.carId}';
    const currentUser = '${sessionScope.userId != null ? "true" : "false"}';
</script>
        
    </body>
</html>