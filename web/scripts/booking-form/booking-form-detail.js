/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

// Global variables

// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Clear any stale data from previous sessions to prevent errors
    if(window.localStorage) {
        window.localStorage.clear();
    }
    initializeForm();
    setupLicenseUpload();
    setupFormValidation();
    calculateAndDisplayPrice();
});

// Initialize form
function initializeForm() {
    // Set minimum date to today
    const now = new Date();
    const today = now.toISOString().slice(0, 16);
    const startDateInput = document.getElementById("startDate");
    const endDateInput = document.getElementById("endDate");

    if(startDateInput) startDateInput.min = today;
    if(endDateInput) endDateInput.min = today;

    // Add event listeners for price calculation
    document.getElementById("rentalType")?.addEventListener("change", calculateAndDisplayPrice);
    document.getElementById("startDate")?.addEventListener("change", function() {
        if(endDateInput) endDateInput.min = this.value;
        calculateAndDisplayPrice();
    });
    document.getElementById("endDate")?.addEventListener("change", calculateAndDisplayPrice);
}

// Setup license upload functionality
function setupLicenseUpload() {
    const licenseImageInput = document.getElementById("licenseImageInput");
    if (licenseImageInput) {
        licenseImageInput.addEventListener("change", handleLicenseImageUpload);
    }
}

// Handle license image upload
function handleLicenseImageUpload(e) {
    const file = e.target.files[0];
    const licenseImagePreview = document.getElementById("licenseImagePreview");
    
    if (file && licenseImagePreview) {
        // Validate file type
        const allowedTypes = ["image/jpeg", "image/jpg", "image/png", "image/gif"];
        if (!allowedTypes.includes(file.type)) {
            showAlert("Please select a valid image file (JPG, PNG, GIF)", "error");
            return;
        }

        // Validate file size (5MB limit)
        const maxSize = 5 * 1024 * 1024; // 5MB in bytes
        if (file.size > maxSize) {
            showAlert("File size must be less than 5MB", "error");
            return;
        }

        // Create preview
        const reader = new FileReader();
        reader.onload = function(e) {
            licenseImagePreview.innerHTML = `
                <img id="previewImg" src="${e.target.result}" alt="License Preview">
                <button type="button" class="remove-image" onclick="removeLicenseImage()">
                    <i class="fas fa-times"></i>
                </button>
            `;
            licenseImagePreview.style.display = "block";
        };
        reader.readAsDataURL(file);

        showAlert("License image uploaded successfully", "success");
    }
}

// Remove license image
function removeLicenseImage() {
    const licenseImageInput = document.getElementById("licenseImageInput");
    const licenseImagePreview = document.getElementById("licenseImagePreview");
    
    if(licenseImageInput) licenseImageInput.value = "";
    if(licenseImagePreview) {
        licenseImagePreview.style.display = "none";
        licenseImagePreview.innerHTML = "";
    }
}

// Setup form validation
function setupFormValidation() {
    const bookingForm = document.getElementById("bookingForm");
    if (bookingForm) {
        // Remove any existing event listeners
        bookingForm.removeEventListener("submit", validateAndSubmitForm);
        
        // Add new event listener
        bookingForm.addEventListener("submit", function(e) {
            validateAndSubmitForm(e);
        });
    }
}

// Validate and submit form
function validateAndSubmitForm(e) {
    if (!validateForm()) {
        e.preventDefault();
        showAlert("Please fix the errors before submitting.", "error");
        return false;
    }
    
    // Show loading state
    const submitBtn = e.target.querySelector('button[type="submit"]');
    if(submitBtn) {
        const originalText = submitBtn.innerHTML;
        submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
        submitBtn.disabled = true;
    }
    
    // Form will submit normally if validation passes
    return true;
}

// Form validation
function validateForm() {
    const form = document.getElementById("bookingForm");
    if (!form) {
        return false;
    }

    let isValid = true;
    
    const existingAlerts = document.querySelectorAll('.alert.alert-danger');
    existingAlerts.forEach(alert => alert.remove());
    
    const requiredFields = form.querySelectorAll("[required]");
    requiredFields.forEach(field => {
        field.style.borderColor = "";
    });

    requiredFields.forEach((field, index) => {
        if (!field.value.trim()) {
            field.style.borderColor = "#ef4444";
            isValid = false;
        }
    });

    // --- DATE VALIDATION IMPROVEMENT ---
    const startDateInput = document.getElementById("startDate");
    const endDateInput = document.getElementById("endDate");
    
    if (startDateInput && endDateInput) {
        const startDate = new Date(startDateInput.value);
        const endDate = new Date(endDateInput.value);
        
        // Tạo một thời điểm đệm, ví dụ 5 phút sau thời điểm hiện tại
        const bufferTime = 5 * 60 * 1000; // 5 phút tính bằng mili giây
        const nowWithBuffer = new Date(new Date().getTime() + bufferTime);

        if (startDate < nowWithBuffer) {
            showAlert("Pickup date must be at least 5 minutes from now.", "error");
            startDateInput.style.borderColor = "#ef4444";
            isValid = false;
        }

        if (startDate >= endDate) {
            showAlert("End date must be after start date.", "error");
            endDateInput.style.borderColor = "#ef4444";
            isValid = false;
        }
    }
    // --- END OF DATE VALIDATION IMPROVEMENT ---

    const licenseNumber = document.getElementById("licenseNumber");
    if (licenseNumber && licenseNumber.hasAttribute('required')) {
        const licensePattern = /^[0-9]{12}$/;
        if (!licensePattern.test(licenseNumber.value)) {
            showAlert("Driver license number must be exactly 12 digits.", "error");
            licenseNumber.style.borderColor = "#ef4444";
            isValid = false;
        }
    }
    
    if (!isValid) {
        showAlert("Please fill in all required fields correctly.", "error");
    }

    return isValid;
}

// Show alert message
function showAlert(message, type = "info") {
    const formContainer = document.querySelector('.booking-form-container');
    if (!formContainer) return;

    // Create new alert
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type === "error" ? "danger" : type}`;
    alertDiv.innerHTML = `
        <i class="fas fa-${type === "error" ? "exclamation-triangle" : type === "success" ? "check-circle" : "info-circle"}"></i>
        <span>${message}</span>
    `;
    
    // Make alert temporary
    alertDiv.style.marginBottom = '1rem';
    
    // Insert alert at the top of the form
    formContainer.insertBefore(alertDiv, formContainer.querySelector('form'));

    // Auto remove alert after 5 seconds
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.remove();
        }
    }, 5000);
}

// Navigation functions
function goHome() {
    if (confirm("Are you sure you want to return to the home page? Entered information will be lost.")) {
        window.location.href = "/";
    }
}

function goToDeposit() {
    if (validateForm()) {
        const form = document.getElementById("bookingForm");
        const formData = new FormData(form);
        const formObject = {};
        formData.forEach((value, key) => {
            formObject[key] = value;
        });
        
        sessionStorage.setItem("bookingFormData", JSON.stringify(formObject));
        
        // This should point to the correct deposit page URL
        window.location.href = "/pages/booking-form/booking-form-deposit.jsp";
    } else {
        showAlert("Please fix the form errors before proceeding.", "error");
    }
}

// Utility function to format date
function formatDate(date) {
    return date.toISOString().slice(0, 16);
}

// Utility function to validate email
function validateEmail(email) {
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return emailPattern.test(email);
}

// Utility function to validate phone number
function validatePhone(phone) {
    const phonePattern = /^[0-9]{10,11}$/;
    return phonePattern.test(phone.replace(/\s/g, ''));
}

// Thêm lại logic tính tổng tiền động trên form booking

document.addEventListener('DOMContentLoaded', function() {
    const rentalTypeInput = document.getElementById("rentalType");
    const startDateInput = document.getElementById("startDate");
    const endDateInput = document.getElementById("endDate");

    function getPricePerUnit(type) {
        switch (type) {
            case "hourly":
                return parseFloat(document.getElementById("carHourlyPrice").value) || 0;
            case "daily":
                return parseFloat(document.getElementById("carDailyPrice").value) || 0;
            case "monthly":
                return parseFloat(document.getElementById("carMonthlyPrice").value) || 0;
            default:
                return 0;
        }
    }

    function calculateAndDisplayPrice() {
        const rentalType = rentalTypeInput.value;
        const start = new Date(startDateInput.value);
        const end = new Date(endDateInput.value);
        let duration = 0;
        let unitPrice = getPricePerUnit(rentalType);
        let total = 0;
        let durationText = "";

        if (rentalType && start && end && end > start) {
            const diffMs = end - start;
            if (rentalType === "hourly") {
                duration = Math.ceil(diffMs / (1000 * 60 * 60));
                durationText = `${duration} hour(s)`;
            } else if (rentalType === "daily") {
                duration = Math.ceil(diffMs / (1000 * 60 * 60 * 24));
                durationText = `${duration} day(s)`;
            } else if (rentalType === "monthly") {
                duration = Math.ceil(diffMs / (1000 * 60 * 60 * 24 * 30));
                durationText = `${duration} month(s)`;
            }
            total = duration * unitPrice;
        }

        document.getElementById("totalDuration").textContent = durationText || "0";
        document.getElementById("unitPrice").textContent = unitPrice + "K";
        document.getElementById("totalPrice").textContent = total + "K";
        document.getElementById("hiddenTotalAmount").value = total;
    }

    if (rentalTypeInput && startDateInput && endDateInput) {
        rentalTypeInput.addEventListener("change", calculateAndDisplayPrice);
        startDateInput.addEventListener("change", calculateAndDisplayPrice);
        endDateInput.addEventListener("change", calculateAndDisplayPrice);
    }
});
