<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Profile - Auto Rental</title>

        <!-- ===== External CSS Libraries ===== -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap" rel="stylesheet">

        <!-- ===== Include Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/scripts/include/userNav.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/scripts/include/nav.css">
        
        <!-- ===== Custom Styles ===== -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/user/about.css">
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

        <style>
            .account-info-block .info-list a, .account-info-block .info-list .add-link {
                text-decoration: none !important;
            }
        </style>
    </head>
    <body>
        <!-- Header -->
        <jsp:include page="/pages/includes/userNav.jsp" />

        <div class="container">
            <div class="row g-5">
                <!-- Sidebar -->
                <div class="col-lg-3 col-md-4">
                    <jsp:include page="/pages/includes/UserSidebar.jsp" />
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
                                            <h1 class="h5 fw-semibold mb-0 text-dark d-flex align-items-center gap-2" style="font-size:1.25rem;color:#222;">
                                                Account Information
                                                <a href="#" class="btn btn-light border rounded-circle p-1 d-flex align-items-center justify-content-center ms-2" title="Edit" style="font-size:0.95rem;width:28px;height:28px;line-height:1;">
                                                    <i class="bi bi-pencil" style="font-size:1.1em;"></i>
                                                </a>
                                            </h1>
                                            <div class="col-md-4 d-flex flex-column align-items-center mb-3 mb-md-0">
                                                <div class="rounded-circle overflow-hidden mb-3 bg-light border" style="width:120px;height:120px;background:#fff;">
                                                    <img src="https://i.imgur.com/0y0y0y0.png" alt="avatar" style="width:100%;height:100%;object-fit:cover;">
                                                </div>
                                                <div class="fw-semibold text-center" style="font-size:1.25rem;color:#111;">hywang1412</div>
                                                <div class="text-center mb-2" style="font-size:0.95rem;color:#111;">Joined: 28/05/2025</div>
                                                <div class="d-flex justify-content-center">
                                                    <span class="badge bg-white rounded-3 px-3 py-2 d-flex align-items-center gap-1"
                                                          style="color:#111;font-weight:600;font-size:1rem;border:1.5px solid #e0e0e0;">
                                                        <i class="bi bi-star-fill" style="color:#fbbf24;font-size:1.1em;"></i>
                                                        0 Point
                                                    </span>
                                                </div>
                                            </div>
                                            <!-- Right: Account Details -->
                                            <div class="col-md-8" style="margin-top:2.4rem;">
                                                <!-- Box: Date of birth & Gender -->
                                                <div class="bg-light rounded px-3 py-2 mb-2 d-flex justify-content-between align-items-center" style="font-size:0.97rem;">
                                                    <div>
                                                        <div class="text-muted mb-1" style="font-size:0.93rem;">Date of birth</div>
                                                        <div class="text-muted mb-1" style="font-size:0.93rem;">Gender</div>
                                                    </div>
                                                    <div>
                                                        <div style="font-size:0.97rem;">--/--/----</div>
                                                        <div style="font-size:0.97rem;">Male</div>
                                                    </div>
                                                </div>
                                                <!-- List: Other info -->
                                                <div class="info-list">
                                                    <div class="info-row d-flex align-items-center justify-content-between mb-1" style="font-size:0.97rem;">
                                                        <span class="text-muted">Phone</span>
                                                        <span class="d-flex align-items-center gap-1">
                                                            <span class="badge badge-not-verified">
                                                                <i class="bi bi-exclamation-circle-fill me-1"></i>Not verified
                                                            </span>
                                                            <span class="fw-semibold" style="font-size:0.97rem;">+84931937721</span>
                                                            <a href="#" class="ms-1 text-muted d-flex align-items-center" style="font-size:1em;"><i class="bi bi-pencil"></i></a>
                                                        </span>
                                                    </div>
                                                    <div class="info-row d-flex align-items-center justify-content-between mb-1" style="font-size:0.97rem;">
                                                        <span class="text-muted">Email</span>
                                                        <span class="d-flex align-items-center gap-1">
                                                            <span class="badge badge-not-verified">
                                                                <i class="bi bi-exclamation-circle-fill me-1"></i>Not verified
                                                            </span>
                                                            <a href="#" class="add-link" style="font-size:0.97em;">Add email</a>
                                                            <a href="#" class="ms-1 text-muted d-flex align-items-center" style="font-size:1em;"><i class="bi bi-pencil"></i></a>
                                                        </span>
                                                    </div>
                                                    <div class="info-row d-flex align-items-center justify-content-between mb-1" style="font-size:0.97rem;">
                                                        <span class="text-muted">Facebook</span>
                                                        <span class="d-flex align-items-center gap-1">
                                                            <a href="#" class="add-link" style="font-size:0.97em;">Add link</a>
                                                            <a href="#" class="ms-1 text-muted d-flex align-items-center" style="font-size:1em;"><i class="bi bi-link-45deg"></i></a>
                                                        </span>
                                                    </div>
                                                    <div class="info-row d-flex align-items-center justify-content-between" style="font-size:0.97rem;">
                                                        <span class="text-muted">Google</span>
                                                        <span class="d-flex align-items-center gap-1">
                                                            <a href="#" class="add-link" style="font-size:0.97em;">Add link</a>
                                                            <a href="#" class="ms-1 text-muted d-flex align-items-center" style="font-size:1em;"><i class="bi bi-link-45deg"></i></a>
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
                                                <span class="badge verification-failed px-3 py-1">
                                                    <i class="bi bi-exclamation-triangle me-1"></i>Verification failed
                                                </span>
                                            </div>
                                            <div class="driver-license-actions">
                                                <button type="button" class="btn btn-outline-secondary btn-edit">
                                                    <i class="bi bi-pencil me-1"></i>Edit
                                                </button>
                                                <button type="button" class="btn btn-cancel d-none ms-2">Cancel</button>
                                                <button type="button" class="btn btn-save d-none ms-2">Update</button>
                                            </div>
                                        </div>
                                        <div class="row g-5">
                                            <div class="col-md-4">
                                                <h6 class="text-muted mb-3">Image</h6>
                                                <div class="upload-area p-5 text-center">
                                                    <div class="upload-icon rounded-circle d-flex align-items-center justify-content-center mx-auto mb-3">
                                                        <i class="bi bi-upload"></i>
                                                    </div>
                                                    <p class="text-muted mb-0">Click to upload</p>
                                                </div>
                                            </div>

                                            <div class="col-md-8">
                                                <h6 class="text-muted mb-4">General Information</h6>

                                                <div class="mb-4">
                                                    <label class="form-label text-muted">Driver's License Number</label>
                                                    <input type="text" class="form-control driver-license-input" placeholder="" disabled>
                                                </div>

                                                <div class="mb-4">
                                                    <label class="form-label text-muted">Full name</label>
                                                    <input type="text" class="form-control driver-license-input" placeholder="" disabled>
                                                </div>

                                                <div class="mb-4">
                                                    <label class="form-label text-muted">Date of birth</label>
                                                    <input type="date" class="form-control driver-license-input" placeholder="" disabled>
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
        </div>
        <jsp:include page="/pages/includes/footer.jsp" />

        <!-- Bootstrap JS -->
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


        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
        <script src="${pageContext.request.contextPath}/scripts/user/UserAboutSidebar.js"></script>
        <script src="${pageContext.request.contextPath}/scripts/user/userAbout.js"></script>
    
    </body>
</html>