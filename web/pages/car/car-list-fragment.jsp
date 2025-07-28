<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<div class="row g-4">
    <c:forEach var="car" items="${carList}">
        <div class="col-lg-4 col-md-6 col-12 d-flex">
            <a href="${pageContext.request.contextPath}/pages/car-single?id=${car.carId}" class="car-card-link text-decoration-none">
                <div class="car-wrap rounded ftco-animate h-100 w-100">
                    <div class="img rounded d-flex align-items-end"
                        style="background-image: url('${pageContext.request.contextPath}${car.mainImageUrl}'); position: relative; height: 220px; background-size: cover; background-position: center;">
                        <c:set var="isFavorite" value="${favoriteCarIds.contains(car.carId.toString())}" />
                        <form method="post" action="${pageContext.request.contextPath}/user/favorite-car" 
                              style="position: absolute; top: 10px; right: 10px; z-index: 10;">
                            <input type="hidden" name="action" value="${isFavorite ? 'remove' : 'add'}">
                            <input type="hidden" name="carId" value="${car.carId}">
                            <input type="hidden" name="source" value="car" />
                            <button class="favorite-btn" type="submit" title="${isFavorite ? 'Unfavorite' : 'Favorite'}" style="background: none; border: none; box-shadow: none; padding: 0; margin: 0;">
                                <i class="bi ${isFavorite ? 'bi-heart-fill text-success' : 'bi-heart'}" style="font-size: 1.5rem;"></i>
                            </button>
                        </form>
                    </div>
                    <div class="text p-3">
                        <div class="car-title-row d-flex align-items-center justify-content-between mb-2">
                            <h2 class="mb-0 flex-grow-1" style="font-size: 1.1rem; font-weight: 600; color: #333;">
                                ${car.carModel}
                            </h2>
                            <span class="car-status-inline badge ${car.statusCssClass}" style="min-width: 70px; text-align: center;">${car.statusDisplay}</span>
                        </div>
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <span class="cat text-muted small">${car.brandName}</span>
                            <p class="price mb-0 fw-bold text-primary">
                                <fmt:formatNumber value="${car.pricePerHour * 1000}" type="number" pattern="#,###" />
                                <span class="small">&nbsp;VND/h</span>
                            </p>
                        </div>
                        <div class="d-grid gap-2">
                            <div class="row g-1">
                                <div class="col-12">
                                    <a href="${pageContext.request.contextPath}/booking/form/details?id=${car.carId}"
                                        class="btn btn-primary btn-sm w-100" onclick="event.stopPropagation();">Book now</a>
                                </div>
                            </div>
                            <div class="row g-1">
                                <div class="col-12">
                                    <a href="${pageContext.request.contextPath}/pages/car-single?id=${car.carId}"
                                        class="btn btn-outline-secondary btn-sm w-100" onclick="event.stopPropagation();">Details</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </a>
        </div>
    </c:forEach>
    <c:if test="${empty carList}">
        <div class="col-12 text-center">
            <div class="alert alert-info">
                <i class="bi bi-info-circle me-2"></i>
                No cars found matching your search criteria!
            </div>
        </div>
    </c:if>
</div>

<!-- Phân trang -->
<div class="row mt-5">
    <div class="col text-center">
        <div class="block-27">
            <ul class="pagination justify-content-center">
                <c:if test="${currentPage > 1}">
                    <li class="page-item">
                        <a class="page-link pagination-link" href="#"
                            data-page="${currentPage - 1}"
                            data-keyword="${param.keyword}"
                            data-sort="${param.sort}"
                            data-brand-ids="<c:forEach var='brand' items='${paramValues.brandId}' varStatus='status'>${brand}<c:if test='${!status.last}'>,</c:if></c:forEach>"
                            data-fuel-ids="<c:forEach var='fuel' items='${paramValues.fuelTypeId}' varStatus='status'>${fuel}<c:if test='${!status.last}'>,</c:if></c:forEach>"
                            data-category-ids="<c:forEach var='cat' items='${paramValues.categoryId}' varStatus='status'>${cat}<c:if test='${!status.last}'>,</c:if></c:forEach>"
                            data-status-values="<c:forEach var='st' items='${paramValues.status}' varStatus='status'>${st}<c:if test='${!status.last}'>,</c:if></c:forEach>"
                            data-feature-ids="<c:forEach var='feature' items='${paramValues.featureId}' varStatus='status'>${feature}<c:if test='${!status.last}'>,</c:if></c:forEach>"
                            data-transmission-ids="<c:forEach var='trans' items='${paramValues.transmissionTypeId}' varStatus='status'>${trans}<c:if test='${!status.last}'>,</c:if></c:forEach>">&laquo;</a>
                    </li>
                </c:if>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <c:choose>
                        <c:when test="${currentPage eq i}">
                            <li class="page-item active"><span class="page-link">${i}</span></li>
                        </c:when>
                        <c:otherwise>
                            <li class="page-item"><a class="page-link pagination-link" href="#"
                                    data-page="${i}"
                                    data-keyword="${param.keyword}"
                                    data-sort="${param.sort}"
                                    data-brand-ids="<c:forEach var='brand' items='${paramValues.brandId}' varStatus='status'>${brand}<c:if test='${!status.last}'>,</c:if></c:forEach>"
                                    data-fuel-ids="<c:forEach var='fuel' items='${paramValues.fuelTypeId}' varStatus='status'>${fuel}<c:if test='${!status.last}'>,</c:if></c:forEach>"
                                    data-category-ids="<c:forEach var='cat' items='${paramValues.categoryId}' varStatus='status'>${cat}<c:if test='${!status.last}'>,</c:if></c:forEach>"
                                    data-status-values="<c:forEach var='st' items='${paramValues.status}' varStatus='status'>${st}<c:if test='${!status.last}'>,</c:if></c:forEach>"
                                    data-feature-ids="<c:forEach var='feature' items='${paramValues.featureId}' varStatus='status'>${feature}<c:if test='${!status.last}'>,</c:if></c:forEach>"
                                    data-transmission-ids="<c:forEach var='trans' items='${paramValues.transmissionTypeId}' varStatus='status'>${trans}<c:if test='${!status.last}'>,</c:if></c:forEach>">${i}</a>
                            </li>
                        </c:otherwise>
                    </c:choose>
                </c:forEach>
                <c:if test="${currentPage < totalPages}">
                    <li class="page-item">
                        <a class="page-link pagination-link" href="#"
                            data-page="${currentPage + 1}"
                            data-keyword="${param.keyword}"
                            data-sort="${param.sort}"
                            data-brand-ids="<c:forEach var='brand' items='${paramValues.brandId}' varStatus='status'>${brand}<c:if test='${!status.last}'>,</c:if></c:forEach>"
                            data-fuel-ids="<c:forEach var='fuel' items='${paramValues.fuelTypeId}' varStatus='status'>${fuel}<c:if test='${!status.last}'>,</c:if></c:forEach>"
                            data-category-ids="<c:forEach var='cat' items='${paramValues.categoryId}' varStatus='status'>${cat}<c:if test='${!status.last}'>,</c:if></c:forEach>"
                            data-status-values="<c:forEach var='st' items='${paramValues.status}' varStatus='status'>${st}<c:if test='${!status.last}'>,</c:if></c:forEach>"
                            data-feature-ids="<c:forEach var='feature' items='${paramValues.featureId}' varStatus='status'>${feature}<c:if test='${!status.last}'>,</c:if></c:forEach>"
                            data-transmission-ids="<c:forEach var='trans' items='${paramValues.transmissionTypeId}' varStatus='status'>${trans}<c:if test='${!status.last}'>,</c:if></c:forEach>">&raquo;</a>
                    </li>
                </c:if>
            </ul>
        </div>
    </div>
</div> 