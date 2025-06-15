<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Address - Auto Rental</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/common.css">
   <link rel="stylesheet" href="${pageContext.request.contextPath}/styles/user/my-address.css">
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container-fluid">
            <div class="d-flex justify-content-between align-items-center py-3">
                <div class="logo">
                    <span class="text-dark">AUTO</span><span class="text-success">RENTAL</span>
                </div>
                <div class="d-flex align-items-center gap-4">
                    <nav class="nav-links d-flex gap-4">
                        <a href="#" class="fw-medium">About</a>
                        <a href="#" class="fw-medium">My trips</a>
                    </nav>
                    <div class="d-flex align-items-center gap-2">
                        <i class="bi bi-bell"></i>
                        <i class="bi bi-chat-dots"></i>
                        <div class="dropdown">
                            <button class="btn btn-link text-decoration-none text-dark dropdown-toggle d-flex align-items-center gap-2" 
                                    type="button" data-bs-toggle="dropdown">
                                <div class="user-avatar rounded-circle"></div>
                                <span>hywang1412</span>
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#">Profile</a></li>
                                <li><a class="dropdown-item" href="#">Settings</a></li>
                                <li><hr class="dropdown-divider"></li>
                                <li><a class="dropdown-item" href="#">Logout</a></li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </header>

    <div class="container-fluid mt-4">
        <div class="row g-4">
            <!-- Sidebar -->
            <div class="col-lg-3">
                <div class="sidebar p-4">
                    <h2 class="h4 fw-bold mb-4">Hello !</h2>
                    <ul class="sidebar-menu">
                        <li><a href="my-account.jsp" class="nav-link">
                            <i class="bi bi-person"></i>
                            My account
                        </a></li>
                        <li><a href="favorite-car.jsp" class="nav-link">
                            <i class="bi bi-heart"></i>
                            Favorite cars
                        </a></li>
                        <li><a href="my-trip.jsp" class="nav-link">
                            <i class="bi bi-car-front"></i>
                            My trips
                        </a></li>
                        <li><a href="longterm-booking.jsp" class="nav-link">
                            <i class="bi bi-clipboard-check"></i>
                            Long-term car rental orders
                        </a></li>
                        <li><a href="my-address.jsp" class="nav-link active">
                            <i class="bi bi-geo-alt"></i>
                            My address
                        </a></li>
                        <li><a href="change-password.jsp" class="nav-link">
                            <i class="bi bi-lock"></i>
                            Change password
                        </a></li>
                        <li><a href="request-delete.jsp" class="nav-link">
                            <i class="bi bi-trash"></i>
                            Request account deletion
                        </a></li>
                        <li class="mt-3"><a href="#" class="nav-link text-danger">
                            <i class="bi bi-box-arrow-right"></i>
                            Log out
                        </a></li>
                    </ul>
                </div>
            </div>

            <!-- Main Content -->
            <div class="col-lg-9">
                <div class="main-content p-4">
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

    <!-- Add/Edit Address Modal -->
    <div class="modal fade" id="addAddressModal" tabindex="-1" aria-labelledby="addAddressModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title fw-semibold" id="addAddressModalLabel">Add New Address</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form id="addressForm">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <label for="fullName" class="form-label">Full Name *</label>
                                <input type="text" class="form-control" id="fullName" required>
                            </div>
                            <div class="col-md-6">
                                <label for="phoneNumber" class="form-label">Phone Number *</label>
                                <input type="tel" class="form-control" id="phoneNumber" required>
                            </div>
                            <div class="col-12">
                                <label for="addressType" class="form-label">Address Type *</label>
                                <select class="form-select" id="addressType" required>
                                    <option value="">Select address type</option>
                                    <option value="home">Home</option>
                                    <option value="work">Work</option>
                                    <option value="other">Other</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <label for="streetAddress" class="form-label">Street Address *</label>
                                <input type="text" class="form-control" id="streetAddress" placeholder="House number and street name" required>
                            </div>
                            <div class="col-md-6">
                                <label for="ward" class="form-label">Ward *</label>
                                <input type="text" class="form-control" id="ward" required>
                            </div>
                            <div class="col-md-6">
                                <label for="district" class="form-label">District *</label>
                                <input type="text" class="form-control" id="district" required>
                            </div>
                            <div class="col-md-6">
                                <label for="city" class="form-label">City *</label>
                                <select class="form-select" id="city" required>
                                    <option value="">Select city</option>
                                    <option value="ho-chi-minh">Ho Chi Minh City</option>
                                    <option value="hanoi">Hanoi</option>
                                    <option value="da-nang">Da Nang</option>
                                    <option value="can-tho">Can Tho</option>
                                    <option value="hai-phong">Hai Phong</option>
                                </select>
                            </div>
                            <div class="col-md-6">
                                <label for="postalCode" class="form-label">Postal Code</label>
                                <input type="text" class="form-control" id="postalCode">
                            </div>
                            <div class="col-12">
                                <label for="country" class="form-label">Country *</label>
                                <select class="form-select" id="country" required>
                                    <option value="vietnam" selected>Vietnam</option>
                                </select>
                            </div>
                            <div class="col-12">
                                <div class="form-check">
                                    <input class="form-check-input" type="checkbox" id="setAsDefault">
                                    <label class="form-check-label" for="setAsDefault">
                                        Set as default address
                                    </label>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-outline-custom" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-primary-custom" onclick="saveAddress()">Save Address</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
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