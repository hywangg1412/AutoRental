// Car image gallery functionality
function changeMainImage(thumbnail) {
  const mainImage = document.getElementById("mainCarImage")
  const thumbnails = document.querySelectorAll(".thumbnail")

  // Update main image
  mainImage.src = thumbnail.src.replace("150", "600").replace("100", "400")

  // Update active thumbnail
  thumbnails.forEach((thumb) => thumb.classList.remove("active"))
  thumbnail.classList.add("active")
}

// Price calculation functionality
function calculatePrice() {
  const rentalType = document.getElementById("rentalType").value
  const startDate = new Date(document.getElementById("startDate").value)
  const endDate = new Date(document.getElementById("endDate").value)

  if (!rentalType || !startDate || !endDate || startDate >= endDate) {
    updatePriceDisplay(0, 0, "0 ngày")
    return
  }

  const timeDiff = endDate - startDate
  let duration, unitPrice, totalPrice, durationText

  // Sample prices (should come from server)
  const prices = {
    hourly: 150, // 150K/hour
    daily: 1301, // 1301K/day
    monthly: 25000, // 25000K/month
  }

  switch (rentalType) {
    case "hourly":
      duration = Math.ceil(timeDiff / (1000 * 60 * 60)) // hours
      unitPrice = prices.hourly
      totalPrice = duration * unitPrice
      durationText = `${duration} giờ`
      break
    case "daily":
      duration = Math.ceil(timeDiff / (1000 * 60 * 60 * 24)) // days
      unitPrice = prices.daily
      totalPrice = duration * unitPrice
      durationText = `${duration} ngày`
      break
    case "monthly":
      duration = Math.ceil(timeDiff / (1000 * 60 * 60 * 24 * 30)) // months
      unitPrice = prices.monthly
      totalPrice = duration * unitPrice
      durationText = `${duration} tháng`
      break
    default:
      duration = 0
      unitPrice = 0
      totalPrice = 0
      durationText = "0 ngày"
  }

  updatePriceDisplay(unitPrice, totalPrice, durationText)
}

function updatePriceDisplay(unitPrice, totalPrice, duration) {
  document.getElementById("totalDuration").textContent = duration
  document.getElementById("unitPrice").textContent = `${unitPrice.toLocaleString()}K`
  document.getElementById("totalPrice").textContent = `${totalPrice.toLocaleString()}K`
}

// Form validation
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
    alert("Ngày bắt đầu không thể là quá khứ")
    isValid = false
  }

  if (startDate >= endDate) {
    alert("Ngày kết thúc phải sau ngày bắt đầu")
    isValid = false
  }

  return isValid
}

// Navigation functions
function goHome() {
  if (confirm("Bạn có chắc muốn quay về trang chủ? Thông tin đã nhập sẽ bị mất.")) {
    window.location.href = "index.jsp"
  }
}

// Event listeners
document.addEventListener("DOMContentLoaded", () => {
  // Set minimum date to today
  const now = new Date()
  const today = now.toISOString().slice(0, 16)
  document.getElementById("startDate").min = today
  document.getElementById("endDate").min = today

  // Add event listeners for price calculation
  document.getElementById("rentalType").addEventListener("change", calculatePrice)
  document.getElementById("startDate").addEventListener("change", function () {
    // Update minimum end date
    document.getElementById("endDate").min = this.value
    calculatePrice()
  })
  document.getElementById("endDate").addEventListener("change", calculatePrice)

  // Form submission
  document.getElementById("bookingForm").addEventListener("submit", (e) => {
    if (!validateForm()) {
      e.preventDefault()
    }
  })

  // Auto-fill user info if logged in (mock data)
  const isLoggedIn = true // This should come from server
  if (isLoggedIn) {
    document.getElementById("customerName").value = "Nguyễn Văn A"
    document.getElementById("customerPhone").value = "+84831837721"
    document.getElementById("customerEmail").value = "user@example.com"
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
    // Show additional delivery address field (can be implemented)
    console.log("Delivery option selected")
  }
})
