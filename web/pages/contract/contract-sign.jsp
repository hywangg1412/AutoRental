
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String bookingId = (String) request.getAttribute("bookingId");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Sign Contract</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <!-- Bootstrap CSS -->
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

    <!-- ===== NavBar Styles ===== -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/contract/contract-sign.css">
</head>
<body>
    <%-- Include navigation bar --%>
    <jsp:include page="../includes/nav.jsp" />

    <div class="container signature-container" style="margin-top: 100px;">
        <h2 class="mb-4 text-center">Sign Your Contract</h2>
        <form id="signForm" method="post" action="${pageContext.request.contextPath}/contract/sign">
            <input type="hidden" name="bookingId" value="<%= bookingId %>">
            <!-- Rental Terms & Conditions -->
            <div class="mb-3">
                <label class="form-label fw-bold" style="font-size: 1.15rem;">Rental Terms & Conditions</label>
                <div class="terms-box">
                    <div class="terms-content">
                        <div class="terms-section collapsible-section">
                            <div class="terms-header">
                                <div class="terms-icon">1</div>
                                <button type="button" class="terms-title-btn" aria-expanded="false">
                                    Renter's Responsibilities
                                    <span class="collapse-arrow"><i class="bi bi-chevron-down"></i></span>
                                </button>
                            </div>
                            <div class="terms-body collapse">
                                <ul>
                                    <li>Return the car on time as agreed in the contract.</li>
                                    <li>Keep the car in the same condition as received (except for normal wear and tear).</li>
                                    <li>Be responsible for all traffic violations during the rental period.</li>
                                    <li>Pay all rental fees and any additional charges (if any) in full.</li>
                                    <li>Hold a valid driver's license and meet the age requirements.</li>
                                </ul>
                            </div>
                        </div>
                        <div class="terms-section collapsible-section">
                            <div class="terms-header">
                                <div class="terms-icon">2</div>
                                <button type="button" class="terms-title-btn" aria-expanded="false">
                                    Usage Regulations
                                    <span class="collapse-arrow"><i class="bi bi-chevron-down"></i></span>
                                </button>
                            </div>
                            <div class="terms-body collapse">
                                <ul>
                                    <li>No smoking or drinking alcohol while driving.</li>
                                    <li>Do not transport prohibited or hazardous goods.</li>
                                    <li>Do not use the car for illegal purposes.</li>
                                    <li>Mileage is limited according to the rental package (extra charges apply for excess mileage).</li>
                                    <li>Only drivers named in the contract are allowed to drive the car.</li>
                                </ul>
                            </div>
                        </div>
                        <div class="terms-section collapsible-section">
                            <div class="terms-header">
                                <div class="terms-icon">3</div>
                                <button type="button" class="terms-title-btn" aria-expanded="false">
                                    Fees and Payments
                                    <span class="collapse-arrow"><i class="bi bi-chevron-down"></i></span>
                                </button>
                            </div>
                            <div class="terms-body collapse">
                                <ul>
                                    <li>Late return: 50,000 VND/hour (within the day), 200,000 VND/day (over 6 hours late).</li>
                                    <li>Cleaning fee: 100,000 - 300,000 VND depending on the level.</li>
                                    <li>Excess mileage: 3,000 VND/km for manual cars, 5,000 VND/km for automatic cars.</li>
                                    <li>Lost key: 500,000 VND.</li>
                                    <li>Damage due to renter's fault: Actual repair cost.</li>
                                </ul>
                            </div>
                        </div>
                        <div class="terms-section collapsible-section">
                            <div class="terms-header">
                                <div class="terms-icon">4</div>
                                <button type="button" class="terms-title-btn" aria-expanded="false">
                                    Insurance and Accidents
                                    <span class="collapse-arrow"><i class="bi bi-chevron-down"></i></span>
                                </button>
                            </div>
                            <div class="terms-body collapse">
                                <ul>
                                    <li>The car is covered by compulsory civil liability insurance.</li>
                                    <li>Minor accidents (&lt; 2 million VND): The renter pays the cost.</li>
                                    <li>Major accidents: According to insurance policy, the renter pays 20% of the cost.</li>
                                    <li>Report any incidents to the company within 30 minutes.</li>
                                    <li>Do not leave the scene without instructions from the company.</li>
                                </ul>
                            </div>
                        </div>
                        <div class="terms-section collapsible-section">
                            <div class="terms-header">
                                <div class="terms-icon">5</div>
                                <button type="button" class="terms-title-btn" aria-expanded="false">
                                    Other Terms
                                    <span class="collapse-arrow"><i class="bi bi-chevron-down"></i></span>
                                </button>
                            </div>
                            <div class="terms-body collapse">
                                <ul>
                                    <li>The company reserves the right to repossess the car in case of serious violations.</li>
                                    <li>The renter may cancel the contract at least 24 hours in advance (10% cancellation fee applies).</li>
                                    <li>All disputes will be resolved at the competent Court.</li>
                                    <li>The contract is valid once signed and the deposit is paid.</li>
                                    <li>Customer information is kept confidential in accordance with the law.</li>
                                </ul>
                            </div>
                        </div>
                        <div class="alert alert-info mt-3 mb-2">
                            <i class="fas fa-info-circle me-2"></i>
                            <strong>Note:</strong> Please read all terms carefully before signing.
                            For any questions, please contact our hotline: <strong>1900-xxxx</strong>
                        </div>
                    </div>
                </div>
                <!-- Checkbox phần dưới giữ nguyên -->
                <div class="form-check mt-3">
                    <input class="form-check-input" type="checkbox" id="acceptTerms" name="acceptTerms">
                    <label class="form-check-label" for="acceptTerms">
                        I have read, understood, and agree to all the terms & conditions above
                    </label>
                </div>
                <div class="form-check mt-2">
                    <input class="form-check-input" type="checkbox" id="confirmInfo" name="confirmInfo">
                    <label class="form-check-label" for="confirmInfo">
                        I confirm that the personal information and documents provided are accurate
                    </label>
                </div>
                <!-- Vùng ký -->
                <canvas id="signature-pad" width="400" height="180"></canvas>
                <input type="hidden" name="signatureData" id="signatureData">
                <input type="hidden" name="termsVersion" value="v1.0">
                <input type="hidden" name="termsFileUrl" value="${pageContext.request.contextPath}/terms/current">
                <div class="d-flex justify-content-center gap-3 mt-3">
                    <button id="clearBtn" type="button" class="btn btn-secondary btn-sign">Clear</button>
                    <button id="signBtn" type="submit" class="btn btn-primary btn-sign" disabled>Sign</button>
                </div>
                <div id="signStatus" class="mt-3 text-center"></div>
            </div>
        </form>
    </div>

    <%@include file="../includes/footer.jsp" %>
    
    <!-- loader -->
    <div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#F96D00"/></svg></div>

    <!-- Scripts -->
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
    <script src="https://cdn.jsdelivr.net/npm/signature_pad@4.1.6/dist/signature_pad.umd.min.js"></script>
    
    <!-- Nav and notification JS -->
    <script src="${pageContext.request.contextPath}/scripts/common/nav-dropdown.js"></script>
    <script src="${pageContext.request.contextPath}/scripts/common/user-notification.js"></script>
    <script src="${pageContext.request.contextPath}/scripts/contract/contract-sign.js"></script>
</body>
</html>
