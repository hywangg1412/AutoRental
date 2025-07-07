// Multiple car booking functionality
const carPrices = {
  1: 1301, // KIA SEDONA
  2: 1150, // Toyota Vios
  3: 950, // Honda City
}

// Car images data
const carImages = {
  1: [
    "/placeholder.svg?height=300&width=400",
    "/placeholder.svg?height=300&width=400",
    "/placeholder.svg?height=300&width=400",
    "/placeholder.svg?height=300&width=400",
  ],
  2: [
    "/placeholder.svg?height=300&width=400",
    "/placeholder.svg?height=300&width=400",
    "/placeholder.svg?height=300&width=400",
    "/placeholder.svg?height=300&width=400",
  ],
  3: [
    "/placeholder.svg?height=300&width=400",
    "/placeholder.svg?height=300&width=400",
    "/placeholder.svg?height=300&width=400",
    "/placeholder.svg?height=300&width=400",
  ],
}

const currentImageIndex = {}
let lightboxActive = false
let currentLightboxCarId = null
let appliedDiscount = 0
let discountType = "fixed" // 'fixed' or 'percentage'

// Initialize current image index for each car
Object.keys(carImages).forEach((carId) => {
  currentImageIndex[carId] = 0
})

document.addEventListener("DOMContentLoaded", () => {
  initializeForm()
  calculateTotalPrice()
  createLightbox()
})

function initializeForm() {
  // Set minimum date to today
  const now = new Date()
  const today = now.toISOString().slice(0, 16)
  document.getElementById("startDate").min = today
  document.getElementById("endDate").min = today

  // Add event listeners for price calculation
  document.getElementById("rentalType").addEventListener("change", calculateTotalPrice)
  document.getElementById("startDate").addEventListener("change", function () {
    // Update minimum end date
    document.getElementById("endDate").min = this.value
    calculateTotalPrice()
  })
  document.getElementById("endDate").addEventListener("change", calculateTotalPrice)

  // Form submission
  document.getElementById("bookingForm").addEventListener("submit", (e) => {
    if (!validateForm()) {
      e.preventDefault()
    }
  })

  // Auto-fill user info if logged in (mock data)
  const isLoggedIn = true // This should come from server
  if (isLoggedIn) {
    document.getElementById("customerName").value = "John Doe"
    document.getElementById("customerPhone").value = "+84831837721"
    document.getElementById("customerEmail").value = "user@example.com"
  }

  // Check for applied voucher from URL params
  const urlParams = new URLSearchParams(window.location.search)
  const voucher = urlParams.get("voucher")
  if (voucher) {
    applyVoucherFromCart(voucher)
  }
}

function toggleCarDetails(carId) {
  const allDetails = document.querySelectorAll(".car-details")
  const allToggleBtns = document.querySelectorAll(".btn-toggle")
  const currentDetails = document.getElementById(`details-${carId}`)
  const currentBtn = document.getElementById(`toggle-${carId}`)

  // Close all other expanded details
  allDetails.forEach((detail, index) => {
    if (detail !== currentDetails && detail.classList.contains("expanded")) {
      detail.classList.remove("expanded")
      allToggleBtns[index].classList.remove("expanded")
    }
  })

  // Toggle current detail
  if (currentDetails.classList.contains("expanded")) {
    // Collapse
    currentDetails.classList.remove("expanded")
    currentBtn.classList.remove("expanded")
  } else {
    // Expand
    currentDetails.classList.add("expanded")
    currentBtn.classList.add("expanded")

    // Initialize gallery
    initializeGallery(carId)

    // Smooth scroll to the expanded section
    setTimeout(() => {
      currentDetails.scrollIntoView({
        behavior: "smooth",
        block: "nearest",
      })
    }, 100)
  }
}

function initializeGallery(carId) {
  const mainImg = document.getElementById(`main-img-${carId}`)
  if (mainImg && carImages[carId]) {
    mainImg.src = carImages[carId][0]
    currentImageIndex[carId] = 0
    updateThumbnails(carId)

    // Add click event to main image for lightbox
    mainImg.addEventListener("click", () => {
      openLightbox(carId, currentImageIndex[carId])
    })

    // Add hover event to show navigation arrows
    const galleryMain = mainImg.parentElement
    galleryMain.addEventListener("mouseenter", () => {
      galleryMain.classList.add("active")
    })

    galleryMain.addEventListener("mouseleave", () => {
      if (!lightboxActive) {
        galleryMain.classList.remove("active")
      }
    })
  }
}

function updateThumbnails(carId) {
  const thumbnails = document.querySelectorAll(`#details-${carId} .thumbnail`)
  thumbnails.forEach((thumb, index) => {
    thumb.addEventListener("click", () => {
      selectImage(carId, index)
    })
    if (index === currentImageIndex[carId]) {
      thumb.classList.add("active")
    } else {
      thumb.classList.remove("active")
    }
  })
}

function selectImage(carId, index) {
  const mainImg = document.getElementById(`main-img-${carId}`)
  const thumbnails = document.querySelectorAll(`#details-${carId} .thumbnail`)

  if (mainImg && carImages[carId] && carImages[carId][index]) {
    mainImg.src = carImages[carId][index]
    currentImageIndex[carId] = index

    // Update thumbnail active state
    thumbnails.forEach((thumb, i) => {
      if (i === index) {
        thumb.classList.add("active")
      } else {
        thumb.classList.remove("active")
      }
    })
  }
}

function nextImage(carId) {
  if (carImages[carId]) {
    const nextIndex = (currentImageIndex[carId] + 1) % carImages[carId].length
    selectImage(carId, nextIndex)

    if (lightboxActive) {
      updateLightboxImage(carId, nextIndex)
    }
  }
}

function previousImage(carId) {
  if (carImages[carId]) {
    const prevIndex = currentImageIndex[carId] === 0 ? carImages[carId].length - 1 : currentImageIndex[carId] - 1
    selectImage(carId, prevIndex)

    if (lightboxActive) {
      updateLightboxImage(carId, prevIndex)
    }
  }
}

// Add lightbox functionality
function createLightbox() {
  // Check if lightbox already exists
  if (document.getElementById("lightbox")) return

  const lightbox = document.createElement("div")
  lightbox.id = "lightbox"
  lightbox.className = "lightbox-overlay"
  lightbox.innerHTML = `
    <button class="lightbox-close" id="lightbox-close">
      <i class="fas fa-times"></i>
    </button>
    <div class="lightbox-content">
      <img src="/placeholder.svg" alt="Car Image" class="lightbox-image" id="lightbox-image">
      <button class="lightbox-nav prev" id="lightbox-prev">
        <i class="fas fa-chevron-left"></i>
      </button>
      <button class="lightbox-nav next" id="lightbox-next">
        <i class="fas fa-chevron-right"></i>
      </button>
    </div>
  `
  document.body.appendChild(lightbox)

  // Add event listeners
  document.getElementById("lightbox-close").addEventListener("click", closeLightbox)
  document.getElementById("lightbox-prev").addEventListener("click", () => {
    if (currentLightboxCarId) previousImage(currentLightboxCarId)
  })
  document.getElementById("lightbox-next").addEventListener("click", () => {
    if (currentLightboxCarId) nextImage(currentLightboxCarId)
  })

  // Close on background click
  lightbox.addEventListener("click", (e) => {
    if (e.target === lightbox) closeLightbox()
  })

  // Keyboard navigation
  document.addEventListener("keydown", (e) => {
    if (!lightboxActive) return

    if (e.key === "Escape") {
      closeLightbox()
    } else if (e.key === "ArrowLeft") {
      if (currentLightboxCarId) previousImage(currentLightboxCarId)
    } else if (e.key === "ArrowRight") {
      if (currentLightboxCarId) nextImage(currentLightboxCarId)
    }
  })
}

function openLightbox(carId, imageIndex) {
  createLightbox()

  const lightbox = document.getElementById("lightbox")
  const lightboxImage = document.getElementById("lightbox-image")

  // Set current car and image
  currentLightboxCarId = carId
  updateLightboxImage(carId, imageIndex)

  // Show lightbox
  lightbox.classList.add("active")
  lightboxActive = true

  // Prevent body scrolling
  document.body.style.overflow = "hidden"
}

function updateLightboxImage(carId, imageIndex) {
  const lightboxImage = document.getElementById("lightbox-image")
  if (lightboxImage && carImages[carId] && carImages[carId][imageIndex]) {
    lightboxImage.src = carImages[carId][imageIndex]
    currentImageIndex[carId] = imageIndex

    // Update thumbnails if visible
    updateThumbnails(carId)
  }
}

function closeLightbox() {
  const lightbox = document.getElementById("lightbox")
  lightbox.classList.remove("active")
  lightboxActive = false
  currentLightboxCarId = null

  // Restore body scrolling
  document.body.style.overflow = ""
}

function calculateTotalPrice() {
  const rentalType = document.getElementById("rentalType").value
  const startDate = new Date(document.getElementById("startDate").value)
  const endDate = new Date(document.getElementById("endDate").value)

  if (!rentalType || !startDate || !endDate || startDate >= endDate) {
    updatePriceDisplay(0, 0, "0 days", 0)
    return
  }

  const timeDiff = endDate - startDate
  let duration, totalSubtotal, durationText

  // Calculate duration based on rental type
  switch (rentalType) {
    case "hourly":
      duration = Math.ceil(timeDiff / (1000 * 60 * 60)) // hours
      durationText = `${duration} hours`
      break
    case "daily":
      duration = Math.ceil(timeDiff / (1000 * 60 * 60 * 24)) // days
      durationText = `${duration} days`
      break
    case "monthly":
      duration = Math.ceil(timeDiff / (1000 * 60 * 60 * 24 * 30)) // months
      durationText = `${duration} months`
      break
    default:
      duration = 0
      durationText = "0 days"
  }

  // Calculate total for all cars
  totalSubtotal = 0
  Object.values(carPrices).forEach((price) => {
    let unitPrice = price
    if (rentalType === "hourly") {
      unitPrice = Math.round(price / 24) // Convert daily to hourly
    } else if (rentalType === "monthly") {
      unitPrice = price * 25 // Approximate monthly rate
    }
    totalSubtotal += unitPrice * duration
  })

  // Apply discount
  let discountAmount = 0
  if (appliedDiscount > 0) {
    if (discountType === "percentage") {
      discountAmount = (totalSubtotal * appliedDiscount) / 100
    } else {
      discountAmount = appliedDiscount
    }
  }

  const finalTotal = totalSubtotal - discountAmount
  const depositAmount = Math.round(finalTotal * 0.3) // 30% deposit

  updatePriceDisplay(totalSubtotal, finalTotal, durationText, discountAmount, depositAmount)
}

function updatePriceDisplay(subtotal, total, duration, discount = 0, deposit = 0) {
  document.getElementById("totalDuration").textContent = duration
  document.getElementById("subtotal").textContent = `${subtotal.toLocaleString()}K`
  document.getElementById("totalPrice").textContent = `${total.toLocaleString()}K`
  document.getElementById("depositAmount").textContent = `${deposit.toLocaleString()}K`

  // Show/hide discount row
  const discountRow = document.getElementById("discountRow")
  if (discount > 0) {
    discountRow.style.display = "flex"
    document.getElementById("discountAmount").textContent = `-${discount.toLocaleString()}K`
  } else {
    discountRow.style.display = "none"
  }
}

function applyVoucherFromCart(voucherCode) {
  const vouchers = {
    SAVE10: { type: "percentage", value: 10 },
    FIRST50: { type: "fixed", value: 50 },
    WEEKEND20: { type: "percentage", value: 20 },
  }

  if (vouchers[voucherCode]) {
    const voucher = vouchers[voucherCode]
    appliedDiscount = voucher.value
    discountType = voucher.type
    calculateTotalPrice()
    showToast(`Voucher ${voucherCode} applied successfully!`, "success")
  }
}

function validateForm() {
  const form = document.getElementById("bookingForm")
  const requiredFields = form.querySelectorAll("[required]")
  let isValid = true

  requiredFields.forEach((field) => {
    if (!field.value.trim()) {
      field.style.borderColor = "#ef4444"
      isValid = false
    } else {
      field.style.borderColor = "#d1d5db"
    }
  })

  // Validate dates
  const startDate = new Date(document.getElementById("startDate").value)
  const endDate = new Date(document.getElementById("endDate").value)
  const now = new Date()

  if (startDate < now) {
    showToast("Start date cannot be in the past", "error")
    isValid = false
  }

  if (startDate >= endDate) {
    showToast("End date must be after start date", "error")
    isValid = false
  }

  // Check minimum rental duration
  const timeDiff = endDate - startDate
  const hoursDiff = timeDiff / (1000 * 60 * 60)

  if (hoursDiff < 1) {
    showToast("Minimum rental duration is 1 hour", "error")
    isValid = false
  }

  return isValid
}

function goBack() {
  if (confirm("Are you sure you want to go back? Your booking information will be lost.")) {
    window.location.href = "booking-form-cart.jsp"
  }
}

// Toast notification function
function showToast(message, type = "info") {
  const toast = document.createElement("div")
  toast.className = `toast toast-${type}`
  toast.textContent = message

  const styles = {
    position: "fixed",
    top: "20px",
    right: "20px",
    padding: "1rem 1.5rem",
    borderRadius: "6px",
    color: "white",
    fontWeight: "500",
    zIndex: "1001",
    animation: "slideIn 0.3s ease",
  }

  const colors = {
    success: "#10b981",
    error: "#ef4444",
    info: "#3b82f6",
  }

  Object.assign(toast.style, styles)
  toast.style.background = colors[type] || colors.info

  document.body.appendChild(toast)

  setTimeout(() => {
    toast.style.animation = "slideOut 0.3s ease"
    setTimeout(() => {
      if (document.body.contains(toast)) {
        document.body.removeChild(toast)
      }
    }, 300)
  }, 3000)
}

// Add CSS animations for toast
const style = document.createElement("style")
style.textContent = `
  @keyframes slideIn {
    from { transform: translateX(100%); opacity: 0; }
    to { transform: translateX(0); opacity: 1; }
  }
  @keyframes slideOut {
    from { transform: translateX(0); opacity: 1; }
    to { transform: translateX(100%); opacity: 0; }
  }
`
document.head.appendChild(style)

// Keyboard navigation for gallery
document.addEventListener("keydown", (e) => {
  // Find currently expanded car details
  const expandedDetails = document.querySelector(".car-details.expanded")
  if (expandedDetails) {
    const carId = expandedDetails.id.split("-")[1]

    if (e.key === "ArrowLeft") {
      e.preventDefault()
      previousImage(carId)
    } else if (e.key === "ArrowRight") {
      e.preventDefault()
      nextImage(carId)
    } else if (e.key === "Escape") {
      toggleCarDetails(carId)
    }
  }
})

// Smooth scrolling for better UX
function smoothScrollTo(element) {
  element.scrollIntoView({
    behavior: "smooth",
    block: "center",
  })
}

// Handle pickup location change
document.getElementById("pickupLocation").addEventListener("change", function () {
  if (this.value === "delivery") {
    showToast("Delivery option selected. Additional fees may apply.", "info")
  }
})

// Auto-expand first car details on load
document.addEventListener("DOMContentLoaded", () => {
  setTimeout(() => {
    toggleCarDetails(1)
  }, 500)
})

// Handle window resize for responsive behavior
window.addEventListener("resize", () => {
  // Adjust scroll container height on mobile
  if (window.innerWidth <= 768) {
    const container = document.querySelector(".cars-list-container")
    if (container) {
      container.style.maxHeight = "300px"
    }
  }
})
