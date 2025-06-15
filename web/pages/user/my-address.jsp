<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Address - Auto Rental</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free@6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css?family=Poppins:200,300,400,500,600,700,800&display=swap" rel="stylesheet">
    <!-- ===== Include Styles ===== -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/userNav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/include/nav.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/user/my-address.css">
    <!-- ===== Custom Styles ===== -->
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
</head>
<body>
    <!-- Header -->
    <jsp:include page="/pages/includes/userNav.jsp" />
    <div class="container">
        <div class="row g-5 mt-4">
            <!-- Sidebar -->
            <div class="col-lg-3 col-md-4">
                <div class="sidebar">
                    <h2 class="h2 fw-bold mb-3">Hello !</h2>
                    <ul class="sidebar-menu">
                        <li><a href="${pageContext.request.contextPath}/pages/user/user-profile.jsp" class="nav-link text-dark border-top-custom">
                                <i class="bi bi-person text-dark"></i>
                                My account
                            </a></li>
                        <li><a href="${pageContext.request.contextPath}/pages/user/favorite-car.jsp" class="nav-link text-dark">
                                <i class="bi bi-heart text-dark"></i>
                                Favorite cars
                            </a></li>
                        <li><a href="${pageContext.request.contextPath}/pages/user/my-trip.jsp" class="nav-link text-dark">
                                <i class="bi bi-car-front text-dark"></i>
                                My trips
                            </a></li>
                        <li><a href="${pageContext.request.contextPath}/pages/user/longterm-booking.jsp" class="nav-link text-dark">
                                <i class="bi bi-clipboard-check text-dark"></i>
                                Long-term car rental orders
                            </a></li>
                        <li><a href="${pageContext.request.contextPath}/pages/user/my-address.jsp" class="nav-link active text-dark">
                                <i class="bi bi-geo-alt text-dark"></i>
                                My address
                            </a></li>
                        <li><a href="${pageContext.request.contextPath}/pages/user/change-password.jsp" class="nav-link text-dark border-top-custom">
                                <i class="bi bi-lock text-dark"></i>
                                Change password
                            </a></li>
                        <li><a href="${pageContext.request.contextPath}/pages/user/request-delete.jsp" class="nav-link text-dark border-bottom-custom">
                                <i class="bi bi-trash text-dark"></i>
                                Request account deletion
                            </a></li>
                        <li><a href="#" class="nav-link text-danger">
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
                            <div class="main-content p-4 mt-1">
                                <div class="account-info-block mb-4 p-4 bg-white rounded shadow-sm w-100" style="max-width:900px;margin-left:auto;margin-right:auto;">
                                    <!-- Page Header -->
                                    <div class="d-flex justify-content-between align-items-center mb-4">
                                        <div>
                                            <h1 class="h4 fw-semibold mb-1">My Addresses</h1>
                                            <p class="text-muted mb-0">Manage your saved addresses for easier booking</p>
                                        </div>
                                        <button class="btn btn-primary-custom" data-bs-toggle="modal" data-bs-target="#addAddressModal">
                                            <i class="bi bi-plus-lg me-2"></i>Add New Address
                                        </button>
                                    </div>
                                    <!-- Address Cards -->
                                    <div class="address-list">
                                        <!-- Default Address -->
                                        <div class="address-card default">
                                            <div class="default-badge">Default</div>
                                            <div class="address-type home">Home</div>
                                            <div class="address-name">Nguyen Van A</div>
                                            <div class="address-details">
                                                123 Nguyen Hue Street, Ben Nghe Ward<br>
                                                District 1, Ho Chi Minh City<br>
                                                Vietnam, 700000
                                            </div>
                                            <div class="address-phone">
                                                <i class="bi bi-telephone me-2"></i>+84 901 234 567
                                            </div>
                                            <div class="address-actions">
                                                <button class="btn btn-outline-custom btn-action" onclick="editAddress(1)">
                                                    <i class="bi bi-pencil me-1"></i>Edit
                                                </button>
                                                <button class="btn btn-outline-custom btn-action" onclick="setDefault(1)" disabled>
                                                    <i class="bi bi-check-circle me-1"></i>Default
                                                </button>
                                                <button class="btn btn-danger-custom btn-action" onclick="deleteAddress(1)">
                                                    <i class="bi bi-trash me-1"></i>Delete
                                                </button>
                                            </div>
                                        </div>
                                        <!-- Work Address -->
                                        <div class="address-card">
                                            <div class="address-type work">Work</div>
                                            <div class="address-name">Nguyen Van A</div>
                                            <div class="address-details">
                                                456 Le Loi Boulevard, Ben Thanh Ward<br>
                                                District 1, Ho Chi Minh City<br>
                                                Vietnam, 700000
                                            </div>
                                            <div class="address-phone">
                                                <i class="bi bi-telephone me-2"></i>+84 901 234 567
                                            </div>
                                            <div class="address-actions">
                                                <button class="btn btn-outline-custom btn-action" onclick="editAddress(2)">
                                                    <i class="bi bi-pencil me-1"></i>Edit
                                                </button>
                                                <button class="btn btn-primary-custom btn-action" onclick="setDefault(2)">
                                                    <i class="bi bi-check-circle me-1"></i>Set as Default
                                                </button>
                                                <button class="btn btn-danger-custom btn-action" onclick="deleteAddress(2)">
                                                    <i class="bi bi-trash me-1"></i>Delete
                                                </button>
                                            </div>
                                        </div>
                                        <!-- Other Address -->
                                        <div class="address-card">
                                            <div class="address-type">Other</div>
                                            <div class="address-name">Nguyen Van A</div>
                                            <div class="address-details">
                                                789 Dong Khoi Street, Ben Nghe Ward<br>
                                                District 1, Ho Chi Minh City<br>
                                                Vietnam, 700000
                                            </div>
                                            <div class="address-phone">
                                                <i class="bi bi-telephone me-2"></i>+84 901 234 567
                                            </div>
                                            <div class="address-actions">
                                                <button class="btn btn-outline-custom btn-action" onclick="editAddress(3)">
                                                    <i class="bi bi-pencil me-1"></i>Edit
                                                </button>
                                                <button class="btn btn-primary-custom btn-action" onclick="setDefault(3)">
                                                    <i class="bi bi-check-circle me-1"></i>Set as Default
                                                </button>
                                                <button class="btn btn-danger-custom btn-action" onclick="deleteAddress(3)">
                                                    <i class="bi bi-trash me-1"></i>Delete
                                                </button>
                                            </div>
                                        </div>
                                        <!-- Add New Address Card -->
                                        <div class="add-address-card" data-bs-toggle="modal" data-bs-target="#addAddressModal">
                                            <div class="add-icon">
                                                <i class="bi bi-plus-lg"></i>
                                            </div>
                                            <h5 class="mb-2">Add New Address</h5>
                                            <p class="text-muted mb-0">Add a new address for faster booking</p>
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
    <!-- Bootstrap JS & Custom Scripts giống UserAbout -->
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
    <!-- Giữ lại các script quản lý address như cũ -->
    <script>
        // Edit address function
        function editAddress(addressId) {
            // Populate modal with existing data
            document.getElementById('addAddressModalLabel').textContent = 'Edit Address';
            
            // Sample data - in real app, fetch from server
            const addresses = {
                1: {
                    fullName: 'Nguyen Van A',
                    phoneNumber: '+84 901 234 567',
                    addressType: 'home',
                    streetAddress: '123 Nguyen Hue Street',
                    ward: 'Ben Nghe Ward',
                    district: 'District 1',
                    city: 'ho-chi-minh',
                    postalCode: '700000',
                    country: 'vietnam'
                },
                2: {
                    fullName: 'Nguyen Van A',
                    phoneNumber: '+84 901 234 567',
                    addressType: 'work',
                    streetAddress: '456 Le Loi Boulevard',
                    ward: 'Ben Thanh Ward',
                    district: 'District 1',
                    city: 'ho-chi-minh',
                    postalCode: '700000',
                    country: 'vietnam'
                },
                3: {
                    fullName: 'Nguyen Van A',
                    phoneNumber: '+84 901 234 567',
                    addressType: 'other',
                    streetAddress: '789 Dong Khoi Street',
                    ward: 'Ben Nghe Ward',
                    district: 'District 1',
                    city: 'ho-chi-minh',
                    postalCode: '700000',
                    country: 'vietnam'
                }
            };
            
            const address = addresses[addressId];
            if (address) {
                document.getElementById('fullName').value = address.fullName;
                document.getElementById('phoneNumber').value = address.phoneNumber;
                document.getElementById('addressType').value = address.addressType;
                document.getElementById('streetAddress').value = address.streetAddress;
                document.getElementById('ward').value = address.ward;
                document.getElementById('district').value = address.district;
                document.getElementById('city').value = address.city;
                document.getElementById('postalCode').value = address.postalCode;
                document.getElementById('country').value = address.country;
            }
            
            // Show modal
            const modal = new bootstrap.Modal(document.getElementById('addAddressModal'));
            modal.show();
        }

        // Set default address function
        function setDefault(addressId) {
            if (confirm('Set this address as your default address?')) {
                // Remove default from all cards
                document.querySelectorAll('.address-card').forEach(card => {
                    card.classList.remove('default');
                    const badge = card.querySelector('.default-badge');
                    if (badge) badge.remove();
                    
                    // Enable "Set as Default" buttons
                    const defaultBtn = card.querySelector('button[onclick*="setDefault"]');
                    if (defaultBtn) {
                        defaultBtn.disabled = false;
                        defaultBtn.innerHTML = '<i class="bi bi-check-circle me-1"></i>Set as Default';
                        defaultBtn.className = 'btn btn-primary-custom btn-action';
                    }
                });
                
                // Set new default
                const targetCard = document.querySelector(`button[onclick="setDefault(${addressId})"]`).closest('.address-card');
                targetCard.classList.add('default');
                
                // Add default badge
                const badge = document.createElement('div');
                badge.className = 'default-badge';
                badge.textContent = 'Default';
                targetCard.appendChild(badge);
                
                // Disable the button
                const defaultBtn = targetCard.querySelector('button[onclick*="setDefault"]');
                defaultBtn.disabled = true;
                defaultBtn.innerHTML = '<i class="bi bi-check-circle me-1"></i>Default';
                defaultBtn.className = 'btn btn-outline-custom btn-action';
                
                alert('Default address updated successfully!');
            }
        }

        // Delete address function
        function deleteAddress(addressId) {
            if (confirm('Are you sure you want to delete this address?')) {
                const addressCard = document.querySelector(`button[onclick="deleteAddress(${addressId})"]`).closest('.address-card');
                
                // Check if it's the default address
                if (addressCard.classList.contains('default')) {
                    alert('Cannot delete the default address. Please set another address as default first.');
                    return;
                }
                
                // Remove the address card with animation
                addressCard.style.transition = 'all 0.3s ease';
                addressCard.style.opacity = '0';
                addressCard.style.transform = 'scale(0.95)';
                
                setTimeout(() => {
                    addressCard.remove();
                }, 300);
            }
        }

        // Save address function
        function saveAddress() {
            const form = document.getElementById('addressForm');
            
            // Basic validation
            if (!form.checkValidity()) {
                form.reportValidity();
                return;
            }
            
            // Get form data
            const formData = {
                fullName: document.getElementById('fullName').value,
                phoneNumber: document.getElementById('phoneNumber').value,
                addressType: document.getElementById('addressType').value,
                streetAddress: document.getElementById('streetAddress').value,
                ward: document.getElementById('ward').value,
                district: document.getElementById('district').value,
                city: document.getElementById('city').value,
                postalCode: document.getElementById('postalCode').value,
                country: document.getElementById('country').value,
                setAsDefault: document.getElementById('setAsDefault').checked
            };
            
            // Simulate saving
            console.log('Saving address:', formData);
            
            // Close modal
            const modal = bootstrap.Modal.getInstance(document.getElementById('addAddressModal'));
            modal.hide();
            
            // Reset form
            form.reset();
            document.getElementById('addAddressModalLabel').textContent = 'Add New Address';
            
            alert('Address saved successfully!');
        }

        // Reset modal when closed
        document.getElementById('addAddressModal').addEventListener('hidden.bs.modal', function() {
            document.getElementById('addressForm').reset();
            document.getElementById('addAddressModalLabel').textContent = 'Add New Address';
        });

        // Auto-format phone number
        document.getElementById('phoneNumber').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.startsWith('84')) {
                value = '+84 ' + value.substring(2);
            } else if (value.startsWith('0')) {
                value = '+84 ' + value.substring(1);
            }
            e.target.value = value;
        });
    </script>
</body>
</html>