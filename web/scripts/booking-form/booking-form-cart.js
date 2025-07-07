// Add at the beginning of the file
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
  4: [
    "/placeholder.svg?height=300&width=400",
    "/placeholder.svg?height=300&width=400",
    "/placeholder.svg?height=300&width=400",
    "/placeholder.svg?height=300&width=400",
  ],
}

const currentImageIndex = {}
let lightboxActive = false
let currentLightboxCarId = null

// Initialize current image index for each car
Object.keys(carImages).forEach((carId) => {
  currentImageIndex[carId] = 0
})

// Cart functionality
const selectedCars = new Set()
let appliedVoucher = null

document.addEventListener("DOMContentLoaded", () => {
  initializeCart()
  updateOrderSummary()
  createLightbox()
})

function initializeCart() {
  // Select all checkbox functionality
  const selectAllCheckbox = document.getElementById("selectAll")
  const carCheckboxes = document.querySelectorAll(".car-checkbox")

  selectAllCheckbox.addEventListener("change", function () {
    carCheckboxes.forEach((checkbox) => {
      checkbox.checked = this.checked
      if (this.checked) {
        selectedCars.add(Number.parseInt(checkbox.dataset.carId))
      } else {
        selectedCars.delete(Number.parseInt(checkbox.dataset.carId))
      }
    })
    updateOrderSummary()
    updateRemoveSelectedButton()
  })

  // Individual car checkbox functionality
  carCheckboxes.forEach((checkbox) => {
    checkbox.addEventListener("change", function () {
      const carId = Number.parseInt(this.dataset.carId)
      if (this.checked) {
        selectedCars.add(carId)
      } else {
        selectedCars.delete(carId)
      }

      // Update select all checkbox
      selectAllCheckbox.checked = carCheckboxes.length === selectedCars.size
      selectAllCheckbox.indeterminate = selectedCars.size > 0 && selectedCars.size < carCheckboxes.length

      updateOrderSummary()
      updateRemoveSelectedButton()
    })
  })
}

// Update the updateOrderSummary function to include deposit calculation
function updateOrderSummary() {
  const selectedCount = selectedCars.size
  let subtotal = 0

  // Calculate subtotal
  selectedCars.forEach((carId) => {
    const carItem = document.querySelector(`[data-car-id="${carId}"]`)
    if (carItem) {
      const price = Number.parseInt(carItem.dataset.price)
      subtotal += price
    }
  })

  // Apply discount
  let discountAmount = 0
  if (appliedVoucher) {
    if (appliedVoucher.type === "percentage") {
      discountAmount = (subtotal * appliedVoucher.value) / 100
    } else {
      discountAmount = appliedVoucher.value
    }
  }

  const total = subtotal - discountAmount
  const depositAmount = Math.round(total * 0.3) // 30% deposit

  // Update UI
  document.getElementById("selectedCount").textContent = `${selectedCount} cars`
  document.getElementById("subtotal").textContent = `${subtotal.toLocaleString()}K`
  document.getElementById("totalAmount").textContent = `${total.toLocaleString()}K`
  document.getElementById("depositAmount").textContent = `${depositAmount.toLocaleString()}K`

  // Show/hide discount row
  const discountRow = document.getElementById("discountRow")
  if (discountAmount > 0) {
    discountRow.style.display = "flex"
    document.getElementById("discountAmount").textContent = `-${discountAmount.toLocaleString()}K`
  } else {
    discountRow.style.display = "none"
  }

  // Enable/disable book button
  const bookBtn = document.getElementById("bookCarsBtn")
  bookBtn.disabled = selectedCount === 0
}

function updateRemoveSelectedButton() {
  const removeBtn = document.getElementById("removeSelected")
  removeBtn.disabled = selectedCars.size === 0
}

function removeCarFromCart(carId) {
  if (confirm("Are you sure you want to remove this car from cart?")) {
    const carItem = document.querySelector(`[data-car-id="${carId}"]`)
    if (carItem) {
      carItem.remove()
      selectedCars.delete(carId)
      updateOrderSummary()
      updateRemoveSelectedButton()
      updateCartCount()
    }
  }
}

// Update cart count to reflect the correct number
function updateCartCount() {
  const remainingCars = document.querySelectorAll(".cart-item").length
  document.querySelector(".cart-count").textContent = `${remainingCars} cars in cart`

  // Update select all text
  const selectAllLabel = document.querySelector('label[for="selectAll"]')
  if (selectAllLabel) {
    selectAllLabel.innerHTML = `
      <input type="checkbox" id="selectAll">
      <span class="checkmark"></span>
      Select All (${remainingCars})
    `
  }
}

// Voucher functionality
function applyVoucher() {
  const voucherCode = document.getElementById("voucherCode").value.trim().toUpperCase()

  const vouchers = {
    SAVE10: { type: "percentage", value: 10, minOrder: 2000 },
    FIRST50: { type: "fixed", value: 50, minOrder: 0 },
    WEEKEND20: { type: "percentage", value: 20, minOrder: 1000 },
  }

  if (vouchers[voucherCode]) {
    const voucher = vouchers[voucherCode]
    const subtotal = calculateSubtotal()

    if (subtotal >= voucher.minOrder) {
      appliedVoucher = { ...voucher, code: voucherCode }
      updateOrderSummary()
      showToast(`Voucher ${voucherCode} applied successfully!`, "success")
    } else {
      showToast(`Minimum order of ${voucher.minOrder}K required for this voucher`, "error")
    }
  } else {
    showToast("Invalid voucher code", "error")
  }
}

function calculateSubtotal() {
  let subtotal = 0
  selectedCars.forEach((carId) => {
    const carItem = document.querySelector(`[data-car-id="${carId}"]`)
    if (carItem) {
      subtotal += Number.parseInt(carItem.dataset.price)
    }
  })
  return subtotal
}

function showVoucherModal() {
  document.getElementById("voucherModal").classList.add("show")
}

function closeVoucherModal() {
  document.getElementById("voucherModal").classList.remove("show")
}

function selectVoucher(code, value) {
  document.getElementById("voucherCode").value = code
  closeVoucherModal()
  applyVoucher()
}

// Navigation functions
function proceedToBooking() {
  if (selectedCars.size === 0) {
    showToast("Please select at least one car", "error")
    return
  }

  // Convert selected cars to array and pass to booking page
  const selectedCarIds = Array.from(selectedCars)
  const queryParams = new URLSearchParams({
    cars: selectedCarIds.join(","),
    voucher: appliedVoucher ? appliedVoucher.code : "",
  })

  window.location.href = `booking-form-multiple.jsp?${queryParams.toString()}`
}

function continueShopping() {
  window.location.href = "car-listing.jsp"
}

// Toast notification
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
      document.body.removeChild(toast)
    }, 300)
  }, 3000)
}

// Add CSS animations
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

// Close modal when clicking outside
document.getElementById("voucherModal").addEventListener("click", function (e) {
  if (e.target === this) {
    closeVoucherModal()
  }
})

// Add these functions after the existing functions

function toggleCarDetails(carId) {
  const allDetails = document.querySelectorAll(".car-details")
  const allExpandBtns = document.querySelectorAll(".btn-expand")
  const currentDetails = document.getElementById(`details-${carId}`)
  const currentBtn = document.getElementById(`expand-${carId}`)

  // Close all other expanded details
  allDetails.forEach((detail, index) => {
    if (detail !== currentDetails && detail.classList.contains("expanded")) {
      detail.classList.remove("expanded")
      allExpandBtns[index].classList.remove("expanded")
    }
  })

  // Toggle current detail
  if (currentDetails.classList.contains("expanded")) {
    currentDetails.classList.remove("expanded")
    currentBtn.classList.remove("expanded")
  } else {
    currentDetails.classList.add("expanded")
    currentBtn.classList.add("expanded")
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
