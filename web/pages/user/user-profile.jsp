<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ page import="Utils.FormatUtils" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Profile - Auto Rental</title>

                <!-- ===== External CSS Libraries ===== -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css"
                    rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css"
                    rel="stylesheet">
                <link href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap"
                    rel="stylesheet">

                <!-- ===== Include Styles ===== -->
                <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/user/user-profile.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/user-nav.css">

                <!-- ===== Custom Styles ===== -->
                <link rel="stylesheet"
                    href="${pageContext.request.contextPath}/assets/css/open-iconic-bootstrap.min.css">
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

            </head>

            <body>
                <!-- Include Toast Notification -->

                <!-- Header -->
                <jsp:include page="/pages/includes/user-nav.jsp" />

                <div class="container">
                    <div class="row g-5" style="margin-top: 80px;">
                        <!-- Sidebar -->
                        <div class="col-lg-3 col-md-4">
                            <div class="sidebar">
                                <h2 class="h2 fw-bold mb-3">Hello !</h2>
                                <ul class="sidebar-menu">
                                    <li><a href="${pageContext.request.contextPath}/user/profile"
                                            class="nav-link active text-dark border-top-custom">
                                            <i class="bi bi-person text-dark"></i>
                                            My account
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/user/favorite-car-page"
                                            class="nav-link text-dark">
                                            <i class="bi bi-heart text-dark"></i>
                                            Favorite cars
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/user/my-trip"
                                            class="nav-link text-dark">
                                            <i class="bi bi-car-front text-dark"></i>
                                            My trips
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/pages/user/change-password.jsp"
                                            class="nav-link text-dark border-top-custom">
                                            <i class="bi bi-lock text-dark"></i>
                                            Change password
                                        </a></li>
                                    <li><a href="${pageContext.request.contextPath}/pages/user/request-delete.jsp"
                                            class="nav-link text-dark border-bottom-custom">
                                            <i class="bi bi-trash text-dark"></i>
                                            Request account deletion
                                        </a></li>
                                    <li><a href="#" class="nav-link text-danger logoutBtn">
                                            <i class="bi bi-box-arrow-right"></i>
                                            Log out
                                        </a></li>
                                </ul>
                            </div>
                        </div>
                        <!-- Main content -->
                        <div class="col-lg-8 col-md-8">
                            <div class="main-content">
                                <div class="container mt-4">
                                    <div class="row g-5">
                                        <!-- Main Content -->
                                        <div class="main-content p-4 mt-1">
                                            <!-- Account Information Block -->
                                            <div class="account-info-block mb-4 p-4 bg-white rounded shadow-sm">
                                                <div class="row align-items-center">
                                                    <!-- Left: Avatar + Info -->
                                                    <h1 class="h5 fw-semibold mb-0 text-dark d-flex align-items-center gap-2"
                                                        style="font-size:1.25rem;color:#222;">
                                                        Account Information
                                                        <a href="#"
                                                            class="btn btn-light border rounded-circle p-1 d-flex align-items-center justify-content-center ms-2"
                                                            title="Edit"
                                                            style="font-size:0.95rem;width:28px;height:28px;line-height:1;"
                                                            data-bs-toggle="modal" data-bs-target="#editUserInfoModal">
                                                            <i class="bi bi-pencil" style="font-size:1.1em;"></i>
                                                        </a>
                                                    </h1>
                                                    <div
                                                        class="col-md-4 d-flex flex-column align-items-center mb-3 mb-md-0">
                                                        <form id="changeAvatarForm"
                                                            action="${pageContext.request.contextPath}/user/update-avatar"
                                                            method="post" enctype="multipart/form-data">
                                                            <label class="avatar-upload-wrapper" title="Change avatar">
                                                                <img src="<c:choose>
                                                            <c:when test='${not empty profile.avatarUrl}'>
                                                                ${profile.avatarUrl}
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${pageContext.request.contextPath}/assets/images/default-avatar.png
                                                            </c:otherwise>
                                                        </c:choose>" alt="Avatar"
                                                                    onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/assets/images/default-avatar.png';">
                                                                <span class="avatar-upload-icon">
                                                                    <i class="bi bi-camera-fill"></i>
                                                                </span>
                                                                <input type="file" name="avatar"
                                                                    class="avatar-upload-input" accept="image/*"
                                                                    onchange="document.getElementById('changeAvatarForm').submit();">
                                                            </label>
                                                        </form>
                                                        <c:if test="${not empty avatarError}">
                                                            <div class="text-danger">${avatarError}</div>
                                                        </c:if>
                                                        <div class="fw-semibold text-center"
                                                            style="font-size:1.25rem;color:#111;">${profile.username}
                                                        </div>
                                                        <div class="text-center mb-2"
                                                            style="font-size:0.95rem;color:#111;">Joined:
                                                            ${profile.createdAt}</div>
                                                        <div class="d-flex justify-content-center">
                                                            <span
                                                                class="badge bg-white rounded-3 px-3 py-2 d-flex align-items-center gap-1"
                                                                style="color:#111;font-weight:600;font-size:1rem;border:1.5px solid #e0e0e0;">
                                                                <i class="bi bi-star-fill"
                                                                    style="color:#fbbf24;font-size:1.1em;"></i>
                                                                0 Point
                                                            </span>
                                                        </div>
                                                    </div>
                                                    <!-- Right: Account Details -->
                                                    <div class="col-md-8" style="margin-top:2.4rem;">
                                                        <!-- Box: Date of birth & Gender -->
                                                        <div class="bg-light rounded px-3 py-2 mb-2 d-flex justify-content-between align-items-center"
                                                            style="font-size:0.97rem;">
                                                            <div>
                                                                <div class="text-muted mb-1" style="font-size:0.93rem;">
                                                                    Date of birth</div>
                                                                <div class="text-muted mb-1" style="font-size:0.93rem;">
                                                                    Gender</div>
                                                            </div>
                                                            <div>
                                                                <div style="font-size:0.97rem;">
                                                                    ${profile.userDOBFormatted != null ?
                                                                    profile.userDOBFormatted : '--/--/----'}</div>
                                                                <div style="font-size:0.97rem;">${profile.gender != null
                                                                    ? profile.gender : 'Not specified'}</div>
                                                            </div>
                                                        </div>
                                                        <!-- List: Other info -->
                                                        <div class="info-list">
                                                            <div class="info-row d-flex align-items-center justify-content-between mb-1"
                                                                style="font-size:0.97rem;">
                                                                <span class="text-muted">Phone</span>
                                                                <span class="d-flex align-items-center gap-1">
                                                                    <span class="fw-semibold"
                                                                        style="font-size:0.97rem;">${profile.phoneNumber
                                                                        != null ? profile.phoneNumber : 'Not
                                                                        added'}</span>
                                                                    <a href="#"
                                                                        class="ms-1 text-muted d-flex align-items-center"
                                                                        style="font-size:1em;" data-bs-toggle="modal"
                                                                        data-bs-target="#editPhoneModal"><i
                                                                            class="bi bi-pencil"></i></a>
                                                                </span>
                                                            </div>
                                                            <div class="info-row d-flex align-items-center justify-content-between mb-1"
                                                                style="font-size:0.97rem;">
                                                                <span class="text-muted">Email</span>
                                                                <span class="d-flex align-items-center gap-1">
                                                                    <span
                                                                        class="badge ${profile.emailVerified ? 'badge-verified' : 'badge-not-verified'}">
                                                                        <i
                                                                            class="bi ${profile.emailVerified ? 'bi-check-circle-fill' : 'bi-exclamation-circle-fill'} me-1"></i>
                                                                        ${profile.emailVerified ? 'Verified' : 'Not
                                                                        verified'}
                                                                    </span>
                                                                    <span class="fw-semibold"
                                                                        style="font-size:0.97rem;">${profile.email !=
                                                                        null ? profile.email : 'Not added'}</span>
                                                                    <a href="#"
                                                                        class="ms-1 text-muted d-flex align-items-center"
                                                                        style="font-size:1em;"><i
                                                                            class="bi bi-pencil"></i></a>
                                                                </span>
                                                            </div>
                                                            <div class="info-row d-flex align-items-center justify-content-between mb-1"
                                                                style="font-size:0.97rem;">
                                                                <span class="text-muted">Facebook</span>
                                                                <span class="d-flex align-items-center gap-1">
                                                                    <c:choose>
                                                                        <c:when test="${profile.hasFacebookLogin}">
                                                                            <div
                                                                                class="d-flex align-items-center gap-2">
                                                                                <span class="badge badge-verified">
                                                                                    <i
                                                                                        class="bi bi-check-circle-fill me-1"></i>
                                                                                    ${not empty
                                                                                    profile.facebookAccountName ?
                                                                                    profile.facebookAccountName :
                                                                                    'Connected'}
                                                                                </span>
                                                                                <form
                                                                                    action="${pageContext.request.contextPath}/user/social-unlink"
                                                                                    method="post"
                                                                                    style="display: inline;">
                                                                                    <input type="hidden" name="provider"
                                                                                        value="facebook">
                                                                                    <button type="submit"
                                                                                        class="btn btn-outline-danger btn-unlink-social d-flex align-items-center gap-1 px-3 py-1"
                                                                                        style="font-size:0.95em; border-radius: 20px; border-width: 2px; font-weight: 500;"
                                                                                        data-bs-toggle="tooltip"
                                                                                        data-bs-placement="top"
                                                                                        title="Unlink this social account">
                                                                                        <i class="bi bi-unlink"
                                                                                            style="font-size:1.1em;"></i>
                                                                                        Unlink
                                                                                    </button>
                                                                                </form>
                                                                            </div>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <a href="${pageContext.request.contextPath}/user/social-link?provider=facebook"
                                                                                class="add-link d-flex align-items-center"
                                                                                style="font-size:0.97em;">
                                                                                <i class="bi bi-link-45deg me-1"></i>Add
                                                                                link
                                                                            </a>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </div>
                                                            <div class="info-row d-flex align-items-center justify-content-between"
                                                                style="font-size:0.97rem;">
                                                                <span class="text-muted">Google</span>
                                                                <span class="d-flex align-items-center gap-1">
                                                                    <c:choose>
                                                                        <c:when test="${profile.hasGoogleLogin}">
                                                                            <div
                                                                                class="d-flex align-items-center gap-2">
                                                                                <span class="badge badge-verified">
                                                                                    <i
                                                                                        class="bi bi-check-circle-fill me-1"></i>
                                                                                    ${not empty
                                                                                    profile.googleAccountName ?
                                                                                    profile.googleAccountName :
                                                                                    'Connected'}
                                                                                </span>
                                                                                <form
                                                                                    action="${pageContext.request.contextPath}/user/social-unlink"
                                                                                    method="post"
                                                                                    style="display: inline;">
                                                                                    <input type="hidden" name="provider"
                                                                                        value="google">
                                                                                    <button type="submit"
                                                                                        class="btn btn-outline-danger btn-unlink-social d-flex align-items-center gap-1 px-3 py-1"
                                                                                        style="font-size:0.95em; border-radius: 20px; border-width: 2px; font-weight: 500;"
                                                                                        data-bs-toggle="tooltip"
                                                                                        data-bs-placement="top"
                                                                                        title="Unlink this social account">
                                                                                        <i class="bi bi-unlink"
                                                                                            style="font-size:1.1em;"></i>
                                                                                        Unlink
                                                                                    </button>
                                                                                </form>
                                                                            </div>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <a href="${pageContext.request.contextPath}/user/social-link?provider=google"
                                                                                class="add-link d-flex align-items-center"
                                                                                style="font-size:0.97em;">
                                                                                <i class="bi bi-link-45deg me-1"></i>Add
                                                                                link
                                                                            </a>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </span>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <!-- Driver's License Block -->
                                            <div class="driver-license-block p-4 bg-white rounded shadow-sm">
                                                <!-- Driver's License Section -->
                                                <div class="d-flex justify-content-between align-items-center mb-4">
                                                    <div class="d-flex align-items-center gap-3">
                                                        <h2 class="h5 fw-semibold mb-0">Driver's License</h2>
                                                    </div>
                                                    <div class="driver-license-actions">
                                                        <button type="button" class="btn btn-outline-secondary btn-edit"
                                                            id="editDriverLicenseBtn">
                                                            <i class="bi bi-pencil me-1"></i>Edit
                                                        </button>
                                                        <div class="d-flex gap-2">
                                                            <button type="button" class="btn btn-cancel d-none"
                                                                id="cancelDriverLicenseBtn">Cancel</button>
                                                            <button type="button" class="btn btn-save d-none"
                                                                id="saveDriverLicenseBtn">Update</button>
                                                        </div>
                                                    </div>
                                                </div>
                                                <form id="driverLicenseInfoForm"
                                                    action="${pageContext.request.contextPath}/user/update-driver-license"
                                                    method="post" enctype="multipart/form-data"
                                                    onsubmit="return false;">
                                                    <input type="hidden" name="action" value="updateInfo" />
                                                    <div class="row g-5">
                                                        <div class="col-md-5">
                                                            <h6 class="driver-license-label">Image</h6>
                                                            <label class="driver-license-upload-area"
                                                                style="width:100%;display:block;cursor:pointer;position:relative;">
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${not empty driverLicense.licenseImage}">
                                                                        <img id="driverLicenseImg"
                                                                            src="${driverLicense.licenseImage}"
                                                                            alt="Driver License Image"
                                                                            class="driver-license-img-preview">
                                                                        <span class="driver-license-upload-icon">
                                                                            <i class="bi bi-camera-fill"></i>
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="upload-area-empty">
                                                                            <div class="upload-icon">
                                                                                <i class="bi bi-upload"></i>
                                                                            </div>
                                                                            <div class="upload-text">Click to upload
                                                                            </div>
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <input type="file" name="licenseImage" accept="image/*"
                                                                    style="display:none;" id="licenseImageInput"
                                                                    disabled>
                                                            </label>
                                                            <c:if test="${not empty licenseImageError}">
                                                                <div class="text-danger">${licenseImageError}</div>
                                                            </c:if>
                                                        </div>
                                                        <div class="col-md-7">
                                                            <h6 class="text-muted mb-4">General Information</h6>
                                                            <div class="mb-4">
                                                                <label class="form-label text-muted">Driver's License
                                                                    Number</label>
                                                                <input type="text"
                                                                    class="form-control driver-license-input"
                                                                    name="licenseNumber" id="licenseNumber"
                                                                    value="${driverLicense != null ? driverLicense.licenseNumber : ''}"
                                                                    disabled required>
                                                                <div class="error-message" id="licenseNumberError">
                                                                </div>
                                                            </div>
                                                            <div class="mb-4">
                                                                <label class="form-label text-muted">Full name</label>
                                                                <input type="text"
                                                                    class="form-control driver-license-input"
                                                                    name="fullName" id="fullName"
                                                                    value="${driverLicense != null ? driverLicense.fullName : ''}"
                                                                    disabled required>
                                                                <div class="error-message" id="fullNameError"></div>
                                                            </div>
                                                            <div class="mb-4">
                                                                <label class="form-label text-muted">Date of
                                                                    birth</label>
                                                                <input type="text"
                                                                    class="form-control driver-license-input" name="dob"
                                                                    id="dob" placeholder="dd/MM/yyyy" maxlength="10"
                                                                    autocomplete="off"
                                                                    value="${driverLicense != null && driverLicense.dob != null ? FormatUtils.formatDisplayDate(driverLicense.dob) : ''}"
                                                                    required disabled>
                                                                <div class="error-message" id="dobError"></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                            <!-- Citizen ID Block -->
                                            <div class="citizen-id-block p-4 bg-white rounded shadow-sm mt-4"
                                                id="citizenIdBlock">
                                                <div class="d-flex justify-content-between align-items-center mb-4">
                                                    <div class="d-flex align-items-center gap-3">
                                                        <h2 class="h5 fw-semibold mb-0">Citizen ID (CCCD)</h2>
                                                    </div>
                                                    <div class="citizen-id-actions">
                                                        <button type="button" class="btn btn-outline-secondary btn-edit"
                                                            id="editCitizenIdBtn">
                                                            <i class="bi bi-pencil me-1"></i>Edit
                                                        </button>
                                                        <div class="d-flex gap-2">
                                                            <button type="button" class="btn btn-cancel d-none"
                                                                id="cancelCitizenIdBtn">Cancel</button>
                                                            <button type="button" class="btn btn-save d-none"
                                                                id="saveCitizenIdBtn">Update</button>
                                                        </div>
                                                    </div>
                                                </div>
                                                <form id="citizenIdInfoForm"
                                                    action="${pageContext.request.contextPath}/user/update-citizen-id"
                                                    method="post" enctype="multipart/form-data">
                                                    <div class="row g-5">
                                                        <div class="col-md-5">
                                                            <h6 class="citizen-id-label">CCCD Front Image <span
                                                                    class="text-danger">*</span></h6>
                                                            <label class="citizen-id-upload-area">
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${not empty citizenId.citizenIdImageUrl}">
                                                                        <img id="citizenIdImg"
                                                                            src="${citizenId.citizenIdImageUrl}"
                                                                            alt="Citizen ID Image"
                                                                            class="citizen-id-img-preview">
                                                                        <span class="citizen-id-upload-icon">
                                                                            <i class="bi bi-camera-fill"></i>
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="citizen-id-upload-empty">
                                                                            <div class="upload-icon">
                                                                                <i class="bi bi-upload"></i>
                                                                            </div>
                                                                            <div class="citizen-id-upload-text">Click to
                                                                                upload CCCD front image</div>
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <input type="file" name="citizenIdImage"
                                                                    accept="image/*" style="display:none;"
                                                                    id="citizenIdImageInput" class="citizen-id-input"
                                                                    required disabled>
                                                            </label>
                                                            <c:if test="${not empty citizenIdImageError}">
                                                                <div class="error-message" id="citizenIdImageError">
                                                                    ${citizenIdImageError}</div>
                                                            </c:if>

                                                            <!-- Thêm phần upload ảnh mặt sau -->
                                                            <h6 class="citizen-id-label mt-4">CCCD Back Image <span
                                                                    class="text-danger">*</span></h6>
                                                            <label class="citizen-id-upload-area">
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${not empty citizenId.citizenIdBackImageUrl}">
                                                                        <img id="citizenIdBackImg"
                                                                            src="${citizenId.citizenIdBackImageUrl}"
                                                                            alt="Citizen ID Back Image"
                                                                            class="citizen-id-img-preview">
                                                                        <span class="citizen-id-upload-icon">
                                                                            <i class="bi bi-camera-fill"></i>
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div class="citizen-id-upload-empty">
                                                                            <div class="upload-icon">
                                                                                <i class="bi bi-upload"></i>
                                                                            </div>
                                                                            <div class="citizen-id-upload-text">Click to
                                                                                upload CCCD back image</div>
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                                <input type="file" name="citizenIdBackImage"
                                                                    accept="image/*" style="display:none;"
                                                                    id="citizenIdBackImageInput"
                                                                    class="citizen-id-input" required disabled>
                                                            </label>
                                                            <c:if test="${not empty citizenIdBackImageError}">
                                                                <div class="error-message" id="citizenIdBackImageError">
                                                                    ${citizenIdBackImageError}</div>
                                                            </c:if>
                                                        </div>
                                                        <div class="col-md-7">
                                                            <h6 class="text-muted mb-4">General Information</h6>
                                                            <div class="mb-4">
                                                                <label class="form-label text-muted">Citizen ID Number
                                                                    <span class="text-danger">*</span></label>
                                                                <input type="text" class="form-control citizen-id-input"
                                                                    name="citizenIdNumber" id="citizenIdNumber"
                                                                    value="${citizenId != null ? citizenId.citizenIdNumber : ''}"
                                                                    maxlength="12" pattern="\d{12}" required disabled>
                                                                <div class="error-message" id="citizenIdNumberError">
                                                                </div>
                                                            </div>
                                                            <div class="mb-4">
                                                                <label class="form-label text-muted">Full name <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" class="form-control citizen-id-input"
                                                                    name="citizenFullName" id="citizenFullName"
                                                                    value="${citizenId != null ? citizenId.fullName : ''}"
                                                                    required disabled>
                                                                <div class="error-message" id="citizenFullNameError">
                                                                </div>
                                                            </div>
                                                            <div class="mb-4">
                                                                <label class="form-label text-muted">Date of birth <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" class="form-control citizen-id-input"
                                                                    name="citizenDob" id="citizenDob"
                                                                    placeholder="dd/MM/yyyy" maxlength="10"
                                                                    autocomplete="off"
                                                                    value="${citizenId != null && citizenId.dob != null ? FormatUtils.formatDisplayDate(citizenId.dob) : ''}"
                                                                    disabled>
                                                                <span id="citizenDobError" class="text-danger"></span>
                                                            </div>
                                                            <div class="mb-4">
                                                                <label class="form-label text-muted">Issue date <span
                                                                        class="text-danger">*</span></label>
                                                                <input type="text" class="form-control citizen-id-input"
                                                                    name="citizenIssueDate" id="citizenIssueDate"
                                                                    placeholder="dd/MM/yyyy" maxlength="10"
                                                                    autocomplete="off"
                                                                    value="${citizenId != null && citizenId.citizenIdIssuedDate != null ? FormatUtils.formatDisplayDate(citizenId.citizenIdIssuedDate) : ''}"
                                                                    disabled>
                                                                <span id="citizenIssueDateError"
                                                                    class="text-danger"></span>
                                                            </div>
                                                            <div class="mb-4">
                                                                <label class="form-label text-muted">Place of issue
                                                                    <span class="text-danger">*</span></label>
                                                                <input type="text" class="form-control citizen-id-input"
                                                                    name="citizenPlaceOfIssue" id="citizenPlaceOfIssue"
                                                                    value="${citizenId != null ? citizenId.citizenIdIssuedPlace : ''}"
                                                                    required disabled>
                                                                <div class="error-message"
                                                                    id="citizenPlaceOfIssueError"></div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </form>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <jsp:include page="/pages/includes/footer.jsp" />

                <!-- Bootstrap JS -->
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
                <script
                    src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBVWaKrjvy3MaE7SQ74_uJiULgl1JY0H2s&sensor=false"></script>
                <script src="${pageContext.request.contextPath}/assets/js/google-map.js"></script>
                <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
                <script src="${pageContext.request.contextPath}/scripts/user/user-profile.js"></script>
                <jsp:include page="/pages/includes/logout-confirm-modal.jsp" />
                <div class="toast-container position-fixed bottom-0 end-0 p-3" id="toastContainer"
                    style="z-index: 12000;">
                    <!-- Toast test static đã bị ẩn -->
                    <c:if test="${not empty success}">
                        <div class="toast align-items-center fade show" role="alert" aria-live="assertive"
                            aria-atomic="true" data-bs-delay="4000" id="serverToast"
                            style="background: #f5f7fa !important; border: 1.5px solid #e0e0e0; box-shadow: 0 4px 24px rgba(60,60,60,0.10); border-radius: 14px; min-width: 260px; max-width: 380px; padding: 0;">
                            <div class="d-flex align-items-center" style="padding: 0.7rem 1.1rem 0.7rem 1rem;">
                                <div class="toast-body small"
                                    style="font-size: 0.92rem; color: #222 !important; font-weight: 600; letter-spacing: 0.01em; flex: 1;">
                                    <i class="bi bi-check-circle-fill me-2"
                                        style="color: #4caf50; font-size: 1.1em; vertical-align: -2px;"></i>
                                    ${success}
                                </div>
                                <!-- Nút close đã bị ẩn -->
                            </div>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="toast align-items-center fade show" role="alert" aria-live="assertive"
                            aria-atomic="true" data-bs-delay="4000" id="serverToast"
                            style="background: #f5f7fa !important; border: 1.5px solid #e0e0e0; box-shadow: 0 4px 24px rgba(60,60,60,0.10); border-radius: 14px; min-width: 260px; max-width: 380px; padding: 0;">
                            <div class="d-flex align-items-center" style="padding: 0.7rem 1.1rem 0.7rem 1rem;">
                                <div class="toast-body small"
                                    style="font-size: 0.92rem; color: #d32f2f !important; font-weight: 600; letter-spacing: 0.01em; flex: 1;">
                                    <i class="bi bi-x-circle-fill me-2"
                                        style="color: #d32f2f; font-size: 1.1em; vertical-align: -2px;"></i>
                                    ${error}
                                </div>
                                <!-- Nút close đã bị ẩn -->
                            </div>
                        </div>
                    </c:if>
                </div>
                <!-- Modal xác nhận unlink social -->
                <div class="modal fade" id="confirmUnlinkModal" tabindex="-1" aria-labelledby="confirmUnlinkModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog modal-dialog-centered" style="max-width:350px;">
                        <div class="modal-content"
                            style="border-radius: 14px; padding: 1.2rem 1.2rem 1rem 1.2rem; min-height:320px;">
                            <div class="modal-header border-0 pb-0">
                                <h2 class="modal-title w-100 text-center" id="confirmUnlinkModalLabel"
                                    style="font-size:1.2rem;font-weight:700;">Confirmation</h2>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"
                                    style="font-size:1.1rem;"></button>
                            </div>
                            <div class="modal-body text-center" style="font-size:1rem;">
                                Are you sure you want to unlink your current <span id="unlinkProviderName"
                                    style="font-weight:600;"></span> account?
                            </div>
                            <div class="modal-footer border-0 pt-0 d-flex justify-content-center">
                                <button type="button" class="btn btn-success btn-save-modal" id="confirmUnlinkBtn"
                                    style="min-width:140px;font-size:1rem !important;">Continue</button>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal fade" id="editUserInfoModal" tabindex="-1" aria-labelledby="editUserInfoModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h2 class="modal-title fs-4" id="editUserInfoModalLabel">Update Information</h2>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <form id="updateUserInfoForm" action="${pageContext.request.contextPath}/user/update-info"
                                method="POST">
                                <input type="hidden" name="fromUpdateUserInfo" value="true" />
                                <div class="modal-body">
                                    <div class="mb-3">
                                        <label class="form-label">Username</label>
                                        <input type="text" class="form-control" name="username"
                                            value="${not empty profile_username ? profile_username : profile.username}"
                                            required>
                                        <c:if test="${not empty usernameError}">
                                            <div class="text-danger">${usernameError}</div>
                                        </c:if>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Date of birth</label>
                                        <input type="text" class="form-control" id="dob" name="dob"
                                            value="${not empty profile_userDOB ? profile_userDOB : (not empty profile.userDOB ? profile.userDOB : '')}"
                                            placeholder="dd/MM/yyyy" autocomplete="off">
                                        <c:if test="${not empty dobError}">
                                            <div class="text-danger">${dobError}</div>
                                        </c:if>
                                    </div>
                                    <div class="mb-3">
                                        <label class="form-label">Gender</label>
                                        <select class="form-select" name="gender">
                                            <option value="Male" ${((not empty profile_gender ? profile_gender :
                                                profile.gender)=='Male' ) ? 'selected' : '' }>Male</option>
                                            <option value="Female" ${((not empty profile_gender ? profile_gender :
                                                profile.gender)=='Female' ) ? 'selected' : '' }>Female</option>
                                        </select>
                                        <c:if test="${not empty genderError}">
                                            <div class="text-danger">${genderError}</div>
                                        </c:if>
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <button type="submit" class="btn btn-save-modal">Update</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <c:if test="${not empty dobError && param.fromUpdateUserInfo == 'true'}">
                    <script>
                        document.addEventListener("DOMContentLoaded", function () {
                            var myModal = new bootstrap.Modal(document.getElementById('editUserInfoModal'));
                            myModal.show();
                        });
                    </script>
                </c:if>

                <!-- Modal: Update Phone Number -->
                <div class="modal fade" id="editPhoneModal" tabindex="-1" aria-labelledby="editPhoneModalLabel" aria-hidden="true">
                  <div class="modal-dialog">
                    <div class="modal-content">
                      <div class="modal-header">
                        <h2 class="modal-title w-100 text-center" id="editPhoneModalLabel" style="font-size:1rem;font-weight:700;">Update Phone Number</h2>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                      </div>
                      <form id="updatePhoneForm" action="${pageContext.request.contextPath}/user/update-phone" method="post">
                        <div class="modal-body">
                          <div class="mb-3">
                            <label class="form-label">Phone Number</label>
                            <input type="text" class="form-control" id="phoneInput" name="phone"
                              placeholder="Enter Vietnamese phone number (e.g., 0123456789)"
                              value="${profile.phoneNumber != null ? profile.phoneNumber : ''}" required>
                            <!-- Animated error message for phone input -->
                            <div class="text-danger error-message" id="phoneError"></div>
                          </div>
                        </div>
                        <div class="modal-footer border-0 pt-0">
                          <button type="submit" class="btn btn-save-modal" id="updatePhoneBtn">Update</button>
                        </div>
                      </form>
                    </div>
                  </div>
                </div>
            </body>

            </html>