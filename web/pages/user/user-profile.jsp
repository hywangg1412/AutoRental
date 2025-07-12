<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <% String successMessage=(String) session.getAttribute("success"); String errorMessage=(String)
            session.getAttribute("error"); session.removeAttribute("success"); session.removeAttribute("error"); %>
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
                <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/nav.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/user/user-profile.css">

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
                <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/common/toast.css">
            </head>

            <body>
                <!-- Toast Container -->
                <div class="toast-container position-fixed bottom-0 end-0 p-3">
                    <% if (successMessage !=null) { %>
                        <div class="toast align-items-center text-white bg-success border-0" role="alert"
                            aria-live="assertive" aria-atomic="true">
                            <div class="d-flex">
                                <div class="toast-body">
                                    <i class="fas fa-check-circle me-2"></i>
                                    <%= successMessage %>
                                </div>
                                <button type="button" class="btn-close btn-close-white me-2 m-auto"
                                    data-bs-dismiss="toast" aria-label="Close"></button>
                            </div>
                        </div>
                        <% } %>

                            <% if (errorMessage !=null) { %>
                                <div class="toast align-items-center text-white bg-danger border-0" role="alert"
                                    aria-live="assertive" aria-atomic="true">
                                    <div class="d-flex">
                                        <div class="toast-body">
                                            <i class="fas fa-exclamation-circle me-2"></i>
                                            <%= errorMessage %>
                                        </div>
                                        <button type="button" class="btn-close btn-close-white me-2 m-auto"
                                            data-bs-dismiss="toast" aria-label="Close"></button>
                                    </div>
                                </div>
                                <% } %>
                </div>
                <!-- Header -->
                <jsp:include page="/pages/includes/nav.jsp" />

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
                        <div class="col-lg-9 col-md-8">
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
                                                                <div style="font-size:0.97rem;">${profile.userDOB !=
                                                                    null ? profile.userDOB : '--/--/----'}</div>
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
                                                                    <span
                                                                        class="badge ${profile.phoneNumber != null ? 'badge-verified' : 'badge-not-verified'}">
                                                                        <i
                                                                            class="bi ${profile.phoneNumber != null ? 'bi-check-circle-fill' : 'bi-exclamation-circle-fill'} me-1"></i>
                                                                        ${profile.phoneNumber != null ? 'Verified' :
                                                                        'Not verified'}
                                                                    </span>
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
                                                                                    action="${pageContext.request.contextPath}/facebook-unlink"
                                                                                    method="post"
                                                                                    style="display: inline;"
                                                                                    onsubmit="return confirm('Are you sure you want to unlink your Facebook account?')">
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
                                                                            <a href="${pageContext.request.contextPath}/facebook-link"
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
                                                                                    action="${pageContext.request.contextPath}/google-unlink"
                                                                                    method="post"
                                                                                    style="display: inline;"
                                                                                    onsubmit="return confirm('Are you sure you want to unlink your Google account?')">
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
                                                                            <a href="${pageContext.request.contextPath}/google-link"
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
                                                                    style="display:none;" id="licenseImageInput">
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
                                                                <div class="invalid-feedback" id="licenseNumberError">
                                                                </div>
                                                            </div>
                                                            <div class="mb-4">
                                                                <label class="form-label text-muted">Full name</label>
                                                                <input type="text"
                                                                    class="form-control driver-license-input"
                                                                    name="fullName" id="fullName"
                                                                    value="${driverLicense != null ? driverLicense.fullName : ''}"
                                                                    disabled required>
                                                                <div class="invalid-feedback" id="fullNameError"></div>
                                                            </div>
                                                            <div class="mb-4">
                                                                <label class="form-label text-muted">Date of
                                                                    birth</label>
                                                                <input type="date"
                                                                    class="form-control driver-license-input" name="dob"
                                                                    id="dob"
                                                                    value="${driverLicense != null ? driverLicense.dob : ''}"
                                                                    disabled required>
                                                                <div class="invalid-feedback" id="dobError"></div>
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
                <!-- <script src="${pageContext.request.contextPath}/scripts/user/UserAboutSidebar.js"></script> -->
                <!-- <script src="${pageContext.request.contextPath}/scripts/user/userAbout.js"></script> -->
                <script src="${pageContext.request.contextPath}/scripts/user/user-profile.js"></script>
                <!-- Modal: Update User Info -->
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

                <!-- Modal: Verify Phone Number -->
                <div class="modal fade" id="editPhoneModal" tabindex="-1" aria-labelledby="editPhoneModalLabel"
                    aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h2 class="modal-title fs-4 w-100 text-center" id="editPhoneModalLabel">Verify Phone
                                    Number</h2>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"
                                    aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <!-- Error/Success Messages -->
                                <div id="phone-error-message" class="alert alert-danger" style="display: none;"></div>
                                <div class="mb-3">
                                    <label class="form-label">Phone Number</label>
                                    <input type="tel" class="form-control" id="phoneInput"
                                        placeholder="Enter your phone number (e.g. 0903123456)" pattern="[0-9]{10,11}"
                                        required>
                                    <div class="form-text">Enter your Vietnam phone number (10 or 11 digits)</div>
                                </div>
                                <!-- reCAPTCHA Container -->
                                <div id="recaptcha-container" class="mb-3"></div>
                                <!-- Send OTP Button -->
                                <button type="button" class="btn btn-primary w-100 mb-3" id="sendOtpBtn">Send
                                    OTP</button>
                                <!-- Retry Button (hidden by default) -->
                                <button type="button" id="retry-recaptcha" class="btn btn-outline-secondary w-100 mb-3"
                                    style="display: none;">Retry Security Verification</button>
                                <!-- OTP Section -->
                                <div id="otpSection" style="display:none;">
                                    <hr>
                                    <div class="mb-3">
                                        <label class="form-label">OTP Code</label>
                                        <input type="text" class="form-control" id="otpInput"
                                            placeholder="Enter 6-digit OTP code" pattern="[0-9]{6}" maxlength="6"
                                            required>
                                        <div class="form-text">Enter the 6-digit code sent to your phone</div>
                                    </div>
                                    <button type="button" class="btn btn-success w-100" id="verifyOtpBtn">Verify
                                        OTP</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <jsp:include page="/pages/includes/logout-confirm-modal.jsp" />

                <script type="module">
                    // Import các hàm cần thiết từ Firebase SDK
                    import { initializeApp } from "https://www.gstatic.com/firebasejs/11.10.0/firebase-app.js";
                    import { getAuth, signInWithPhoneNumber, RecaptchaVerifier } from "https://www.gstatic.com/firebasejs/11.10.0/firebase-auth.js";

                    // Cấu hình Firebase
                    const firebaseConfig = {
                        apiKey: "AIzaSyAv-rpxoan3FiyG8CP-NeoyYC4h7PHea6s",
                        authDomain: "autorental-3624c.firebaseapp.com",
                        projectId: "autorental-3624c",
                        storageBucket: "autorental-3624c.firebaseapp.com", // Giữ lại nếu bạn dự định dùng Storage
                        messagingSenderId: "597182569986",
                        appId: "1:597182569986:web:aa4e93d088c2634ec4111b",
                        measurementId: "G-2239XPK4MT"
                    };

                    // Khởi tạo Firebase
                    const app = initializeApp(firebaseConfig);
                    const auth = getAuth(app);
                    auth.useDeviceLanguage();

                    // Biến toàn cục cho reCAPTCHA và xác minh OTP
                    let recaptchaVerifier = null;
                    let confirmationResult = null;

                    // Hàm hiển thị thông báo lỗi
                    function showError(msg) {
                        const errorDiv = document.getElementById('phone-error-message');
                        errorDiv.className = 'alert alert-danger';
                        errorDiv.textContent = msg;
                        errorDiv.style.display = 'block';
                    }

                    // Hàm hiển thị thông báo thành công
                    function showSuccess(msg) {
                        const errorDiv = document.getElementById('phone-error-message');
                        errorDiv.className = 'alert alert-success';
                        errorDiv.textContent = msg;
                        errorDiv.style.display = 'block';
                    }

                    // Hàm ẩn thông báo lỗi
                    function hideError() {
                        const errorDiv = document.getElementById('phone-error-message');
                        errorDiv.style.display = 'none';
                    }

                    // Hàm hiển thị trạng thái loading
                    function showLoading(btn, text) {
                        btn.disabled = true;
                        btn.innerHTML = `<span class="spinner-border spinner-border-sm me-2" role="status" aria-hidden="true"></span>${text}`;
                    }

                    // Hàm ẩn trạng thái loading
                    function hideLoading(btn, text) {
                        btn.disabled = false;
                        btn.innerHTML = text;
                    }

                    // Khởi tạo reCAPTCHA
                    async function initRecaptcha() {
                        if (recaptchaVerifier) return;

                        try {
                            console.log('Starting reCAPTCHA initialization...');
                            const container = document.getElementById('recaptcha-container');
                            if (!container) throw new Error('reCAPTCHA container not found');
                            console.log('reCAPTCHA container found:', container);

                            if (!auth) {
                                throw new Error('Firebase Auth not initialized');
                            }
                            console.log('Firebase Auth ready:', auth);

                            console.log('Current domain:', window.location.hostname);
                            console.log('Current protocol:', window.location.protocol);

                            recaptchaVerifier = new RecaptchaVerifier('recaptcha-container', {
                                'size': 'invisible'
                            }, auth);
                            console.log('RecaptchaVerifier created:', recaptchaVerifier);

                            const renderPromise = recaptchaVerifier.render();
                            const timeoutPromise = new Promise((_, reject) => {
                                setTimeout(() => reject(new Error('reCAPTCHA render timeout (15s)')), 15000);
                            });

                            await Promise.race([renderPromise, timeoutPromise]);
                            document.getElementById('retry-recaptcha').style.display = 'none';
                            console.log('reCAPTCHA initialized successfully');
                        } catch (e) {
                            console.error('Error initializing reCAPTCHA:', e);
                            showError(`Security verification failed: ${e.message}. Please try again.`);
                            document.getElementById('retry-recaptcha').style.display = 'block';
                            recaptchaVerifier = null;
                        }
                    }

                    // Reset reCAPTCHA
                    function resetRecaptcha() {
                        if (recaptchaVerifier) {
                            try {
                                recaptchaVerifier.clear();
                            } catch (e) {
                                console.log('Error clearing reCAPTCHA:', e);
                            }
                            recaptchaVerifier = null;
                        }
                        document.getElementById('recaptcha-container').innerHTML = '';
                        document.getElementById('retry-recaptcha').style.display = 'none';
                    }

                    // Sự kiện khi modal editPhoneModal được mở
                    document.getElementById('editPhoneModal').addEventListener('shown.bs.modal', async function () {
                        hideError();
                        document.getElementById('otpSection').style.display = 'none';
                        document.getElementById('phoneInput').value = '';
                        document.getElementById('otpInput').value = '';
                        await initRecaptcha();
                    });

                    // Sự kiện khi modal editPhoneModal bị đóng
                    document.getElementById('editPhoneModal').addEventListener('hidden.bs.modal', function () {
                        resetRecaptcha();
                        hideError();
                        document.getElementById('otpSection').style.display = 'none';
                        document.getElementById('phoneInput').value = '';
                        document.getElementById('otpInput').value = '';
                        hideLoading(document.getElementById('sendOtpBtn'), 'Send OTP');
                        hideLoading(document.getElementById('verifyOtpBtn'), 'Verify OTP');
                    });

                    // Sự kiện nút Retry reCAPTCHA
                    document.getElementById('retry-recaptcha').onclick = async function () {
                        resetRecaptcha();
                        await initRecaptcha();
                    };

                    // Sự kiện nút Send OTP
                    document.getElementById('sendOtpBtn').onclick = async function () {
                        const phoneInput = document.getElementById('phoneInput');
                        let phoneNumber = phoneInput.value.trim();

                        if (!phoneNumber) {
                            showError('Please enter a phone number');
                            return;
                        }

                        if (phoneNumber.startsWith('0')) {
                            phoneNumber = '+84' + phoneNumber.substring(1);
                        } else if (!phoneNumber.startsWith('+')) {
                            phoneNumber = '+84' + phoneNumber;
                        }

                        if (!/^\+84[3-9]\d{8}$/.test(phoneNumber)) {
                            showError('Invalid phone number format. Please use Vietnam phone number format.');
                            return;
                        }

                        hideError();
                        showLoading(this, 'Sending...');

                        try {
                            if (!recaptchaVerifier) await initRecaptcha();
                            if (!recaptchaVerifier) throw new Error('Failed to initialize security verification');

                            console.log('Sending OTP to:', phoneNumber);
                            confirmationResult = await signInWithPhoneNumber(auth, phoneNumber, recaptchaVerifier);

                            document.getElementById('otpSection').style.display = 'block';
                            showSuccess('OTP sent successfully! Please check your phone.');
                            hideLoading(this, 'Send OTP');
                        } catch (error) {
                            console.error('Error sending OTP:', error);
                            showError('Failed to send OTP: ' + (error.message || error.code));
                            hideLoading(this, 'Send OTP');
                            resetRecaptcha();
                            setTimeout(() => initRecaptcha(), 1000);
                        }
                    };

                    // Sự kiện nút Verify OTP
                    document.getElementById('verifyOtpBtn').onclick = async function () {
                        const code = document.getElementById('otpInput').value.trim();

                        if (!code) {
                            showError('Please enter the OTP code');
                            return;
                        }

                        if (!confirmationResult) {
                            showError('Please request OTP first');
                            return;
                        }

                        showLoading(this, 'Verifying...');

                        try {
                            const result = await confirmationResult.confirm(code);
                            const token = await result.user.getIdToken();
                            const phoneNumber = result.user.phoneNumber || document.getElementById('phoneInput').value;

                            console.log('Verifying OTP:', { code, phoneNumber, token });

                            const response = await fetch('${pageContext.request.contextPath}/user/verify-phone', {
                                method: 'POST',
                                headers: { 'Content-Type': 'application/json' },
                                body: JSON.stringify({ idToken: token, phoneNumber: phoneNumber })
                            });

                            const data = await response.json();

                            if (data.success) {
                                showSuccess('Phone number verified successfully!');
                                setTimeout(() => { location.reload(); }, 1500);
                            } else {
                                showError(data.error || 'Verification failed');
                            }

                            hideLoading(this, 'Verify OTP');
                        } catch (error) {
                            console.error('OTP verification error:', error);
                            showError('Verification failed: ' + (error.message || error.code));
                            hideLoading(this, 'Verify OTP');
                        }
                    };
                </script>
            </body>

            </html>