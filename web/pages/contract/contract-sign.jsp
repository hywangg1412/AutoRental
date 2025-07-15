<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <% String bookingId=(String) request.getAttribute("bookingId"); %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <title>Sign Contract</title>
            <meta name="viewport" content="width=device-width, initial-scale=1">

            <!-- Bootstrap CSS -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css"
                rel="stylesheet">
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

            <!-- ===== NavBar Styles ===== -->
            <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/nav.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/contract/contract-sign.css">

            <style>
                /* 1. CSS cho Modal - Loại bỏ giới hạn chiều cao và overflow */
                .modal-dialog.modal-fullscreen-contract {
                    max-width: 95vw;
                    width: 95vw;
                    height: 95vh;
                    max-height: 95vh;
                    margin: 2.5vh auto;
                }

                .modal-content.contract-modal-content {
                    height: 100%;
                    overflow: visible;
                }

                .modal-body.contract-modal-body {
                    overflow: visible !important;
                    height: auto !important;
                    max-height: none !important;
                    padding: 0;
                }

                /* 2. CSS cho Contract Template trong Modal */
                .contract-template-in-modal {
                    background: #f5f5f5;
                    padding: 20px;
                    overflow: visible;
                    height: auto;
                }

                .contract-page {
                    width: 100%;
                    max-width: 210mm;
                    min-height: auto;
                    padding: 20mm;
                    margin: 10px auto;
                    background: white;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                    border-radius: 2px;
                    box-sizing: border-box;
                    page-break-after: avoid;
                }

                /* 3. CSS cho iframe trong modal */
                .contract-iframe-in-modal {
                    width: 100%;
                    border: none;
                    overflow: visible;
                    height: auto;
                    min-height: 600px;
                }

                /* 4. Override Bootstrap modal defaults */
                .modal.show .modal-dialog {
                    transform: none;
                }

                .modal-header {
                    border-bottom: 1px solid #dee2e6;
                    padding: 1rem 1.5rem;
                }

                .modal-footer {
                    border-top: 1px solid #dee2e6;
                    padding: 1rem 1.5rem;
                }

                /* 5. Responsive cho mobile */
                @media (max-width: 768px) {
                    .modal-dialog.modal-fullscreen-contract {
                        max-width: 98vw;
                        width: 98vw;
                        height: 98vh;
                        max-height: 98vh;
                        margin: 1vh auto;
                    }

                    .contract-page {
                        width: 100%;
                        padding: 15mm;
                        margin: 5px auto;
                    }
                }

                .btn-sign-contract {
                    background: #7edfa0;
                    color: #fff;
                    border: none;
                    border-radius: 6px;
                    box-shadow: 0 2px 8px rgba(126, 223, 160, 0.12);
                    transition: background 0.2s, box-shadow 0.2s, opacity 0.3s;
                    font-size: 1.08rem;
                    font-weight: 600;
                    letter-spacing: 0.5px;
                    text-transform: none;
                    opacity: 0.5;
                }
                .btn-sign-contract.enabled {
                    opacity: 1;
                }
                .btn-sign-contract:disabled {
                    opacity: 0.5;
                    cursor: not-allowed;
                }

                .btn-clear-signature {
                    background: #e0e0e0;
                    color: #333;
                    border: none;
                    border-radius: 6px;
                    font-weight: 500;
                    font-size: 1.08rem;
                    transition: background 0.2s, color 0.2s;
                    text-transform: none;
                }

                .btn-clear-signature:hover,
                .btn-clear-signature:focus {
                    background: #bdbdbd;
                    color: #111;
                }

                .btn-sign-equal {
                    width: 120px;
                    height: 40px;
                    font-size: 1rem;
                    display: inline-flex;
                    align-items: center;
                    justify-content: center;
                    font-weight: 600;
                    padding: 0;
                }

                .signature-method-group {
                    margin-bottom: 18px;
                }

                .signature-method-option {
                    border: 2px solid #e0e0e0;
                    border-radius: 8px;
                    padding: 4px 14px;
                    background: #fafbfc;
                    cursor: pointer;
                    font-weight: 500;
                    font-size: 0.98rem;
                    transition: border 0.2s, background 0.2s, color 0.2s;
                    display: flex;
                    align-items: center;
                    gap: 6px;
                    user-select: none;
                    height: 32px;
                    min-width: 0;
                    white-space: nowrap;
                }

                .signature-method-option input[type="radio"] {
                    accent-color: #7edfa0;
                    margin-right: 8px;
                }

                .signature-method-option.selected,
                .signature-method-option:hover {
                    border: 2px solid #7edfa0;
                    background: #eafff2;
                    color: #2e7d32;
                }

                .upload-area {
                    width: 400px;
                    height: 180px;
                    border: 2px dashed #ccc;
                    background: #fafbfc;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    margin-bottom: 16px;
                    position: relative;
                    margin-left: auto;
                    margin-right: auto;
                    display: flex;
                }

                .upload-label {
                    color: #888;
                    font-size: 1.1rem;
                    cursor: pointer;
                    text-align: center;
                }
                .sign-error {
                    color: #dc3545;
                    font-weight: 500;
                    font-size: 0.98rem;
                    margin-top: 2px;
                    margin-bottom: 0;
                    overflow: hidden;
                    transition: max-height 0.25s cubic-bezier(0.4,0,0.2,1), opacity 0.25s cubic-bezier(0.4,0,0.2,1);
                    max-height: 0;
                    opacity: 0;
                    padding-left: 2px;
                }
                .sign-error.show {
                    max-height: 40px;
                    opacity: 1;
                    margin-bottom: 6px;
                }
                .input-error {
                    border-color: #dc3545 !important;
                }
            </style>
        </head>

        <body style="background:#f5f5f5;">
            <%-- Include navigation bar --%>
                <jsp:include page="../includes/nav.jsp" />

                <h2 class="mb-4 text-center">Sign Your Contract</h2>
                <!-- Hiển thị contract template trực tiếp -->
                <div class="mb-3">
                    <iframe id="contractTemplateFrame"
                        src="${pageContext.request.contextPath}/pages/contract/contract-template.jsp" width="100%"
                        style="border:none; height: 3590px;"></iframe>
                </div>
                <!-- Khung trắng cho phần tick điều khoản, ký và upload -->
                <div class="sign-action-box"
                    style="max-width: 600px; margin: -10px auto 0 auto; background: #fff; border-radius: 16px; box-shadow: 0 2px 16px rgba(0,0,0,0.08); padding: 32px 28px 28px 28px;">
                    <form id="signForm" method="post" action="${pageContext.request.contextPath}/contract/sign">
                        <input type="hidden" name="bookingId" value="<%= bookingId %>">
                        <div class="form-check mt-3">
                            <input class="form-check-input" type="checkbox" id="acceptTerms" name="acceptTerms">
                            <label class="form-check-label" for="acceptTerms">
                                I have read and agree to the terms and conditions
                            </label>
                        </div>
                        <!-- Phần chọn phương thức ký -->
                        <div class="signature-method-group d-flex justify-content-center gap-3 mb-3">
                            <div class="signature-method-option selected" data-method="draw">
                                <span>Draw Signature</span>
                            </div>
                            <div class="signature-method-option" data-method="upload">
                                <span>Upload Signature Image</span>
                            </div>
                            <div class="signature-method-option" data-method="type">
                                <span>Type Signature</span>
                            </div>
                        </div>
                        <!-- Phần canvas, upload ảnh và nhập chữ ký -->
                        <div id="drawSignatureBox">
                            <canvas id="signature-pad" width="400" height="180"
                                style="border:2px dashed #ccc; background:#fafbfc; margin-bottom:16px;"></canvas>
                        </div>
                        <div id="uploadSignatureBox" style="display:none;">
                            <div class="upload-area"
                                style="width:400px; height:180px; border:2px dashed #ccc; background:#fafbfc; display:flex; align-items:center; justify-content:center; margin-bottom:16px;">
                                <input type="file" id="signatureImageInput" accept=".png,.jpg,.jpeg,image/png,image/jpeg" style="display:none;">
                                <label for="signatureImageInput" class="upload-label"
                                    style="cursor:pointer; color:#888; font-size:1.1rem;">Click to upload signature
                                    image</label>
                                <img id="signatureImagePreview" src="" alt="Signature Preview"
                                    style="display:none; max-width:100%; max-height:100%; object-fit:contain;" />
                            </div>
                        </div>
                        <div id="typeSignatureBox" style="display:none;">
                            <input type="text" id="typedSignatureInput" class="form-control mb-2" maxlength="50"
                                placeholder="Enter your name as signature...">
                            <div id="typedSignatureError" class="sign-error error-animate"></div>
                            <input type="text" id="typedFullNameInput" class="form-control mt-2" maxlength="50"
                                placeholder="Enter your full name...">
                            <div id="typedFullNameError" class="sign-error" style="min-height:22px;"></div>
                        </div>
                        <input type="hidden" name="signatureData" id="signatureData">
                        <input type="hidden" name="fullName" id="fullNameHidden">
                        <input type="hidden" name="signatureMethod" id="signatureMethodHidden" value="draw">
                        <input type="hidden" name="termsVersion" value="v1.0">
                        <input type="hidden" name="termsFileUrl"
                            value="${pageContext.request.contextPath}/terms/current">
                        <div class="d-flex justify-content-center gap-3 mt-3">
                            <button type="button" id="clearBtn"
                                class="btn btn-clear-signature btn-sign-equal">Clear</button>
                            <button type="submit" id="signBtn"
                                class="btn btn-sign-contract btn-sign-equal">Sign</button>
                        </div>
                        <div id="signStatus" class="mt-3 text-center"></div>
                    </form>
                </div>

                <%@include file="../includes/footer.jsp" %>

                    <!-- loader -->
                    <div id="ftco-loader" class="show fullscreen"><svg class="circular" width="48px" height="48px">
                            <circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4"
                                stroke="#eeeeee" />
                            <circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4"
                                stroke-miterlimit="10" stroke="#F96D00" />
                        </svg></div>

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
                    <script
                        src="https://maps.googleapis.com/maps/api/js?key=AIzaSyBVWaKrjvy3MaE7SQ74_uJiULgl1JY0H2s&sensor=false"></script>
                    <script src="${pageContext.request.contextPath}/assets/js/google-map.js"></script>
                    <script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
                    <script
                        src="https://cdn.jsdelivr.net/npm/signature_pad@4.1.6/dist/signature_pad.umd.min.js"></script>

                    <!-- Nav and notification JS -->
                    <script src="${pageContext.request.contextPath}/scripts/common/nav-dropdown.js"></script>
                    <script src="${pageContext.request.contextPath}/scripts/common/user-notification.js"></script>
                    <script src="${pageContext.request.contextPath}/scripts/contract/contract-sign.js"></script>
        </body>

        </html>