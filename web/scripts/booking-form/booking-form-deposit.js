// Payment method selection
document.addEventListener("DOMContentLoaded", () => {
  const paymentMethods = document.querySelectorAll(".payment-method")
  const bankPayment = document.getElementById("bankPayment")
  const momoPayment = document.getElementById("momoPayment")
  const agreeTerms = document.getElementById("agreeTerms")
  const confirmBtn = document.getElementById("confirmBtn")

  // Payment method selection
  paymentMethods.forEach((method) => {
    method.addEventListener("click", function () {
      // Remove active class from all methods
      paymentMethods.forEach((m) => m.classList.remove("active"))

      // Add active class to selected method
      this.classList.add("active")

      // Show/hide payment details
      const selectedMethod = this.dataset.method
      if (selectedMethod === "bank") {
        bankPayment.style.display = "block"
        momoPayment.style.display = "none"
      } else if (selectedMethod === "momo") {
        bankPayment.style.display = "none"
        momoPayment.style.display = "block"
      }
    })
  })

  // Terms agreement checkbox
  agreeTerms.addEventListener("change", function () {
    confirmBtn.disabled = !this.checked
  })

  // Start countdown timer
  startCountdown(15 * 60) // 15 minutes

  // Simulate payment status check
  setTimeout(() => {
    // This would normally be an AJAX call to check payment status
    // simulatePaymentReceived();
  }, 30000) // Check after 30 seconds for demo
})

// Copy to clipboard functionality
function copyToClipboard(text) {
  navigator.clipboard
    .writeText(text)
    .then(() => {
      showToast("Đã sao chép: " + text)
    })
    .catch((err) => {
      console.error("Could not copy text: ", err)
      // Fallback for older browsers
      const textArea = document.createElement("textarea")
      textArea.value = text
      document.body.appendChild(textArea)
      textArea.select()
      document.execCommand("copy")
      document.body.removeChild(textArea)
      showToast("Đã sao chép: " + text)
    })
}

// Show toast notification
function showToast(message) {
  // Create toast element
  const toast = document.createElement("div")
  toast.className = "toast"
  toast.textContent = message
  toast.style.cssText = `
        position: fixed;
        top: 20px;
        right: 20px;
        background: #10b981;
        color: white;
        padding: 1rem 1.5rem;
        border-radius: 6px;
        box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        z-index: 1000;
        animation: slideIn 0.3s ease;
    `

  // Add CSS animation
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

  document.body.appendChild(toast)

  // Remove toast after 3 seconds
  setTimeout(() => {
    toast.style.animation = "slideOut 0.3s ease"
    setTimeout(() => {
      document.body.removeChild(toast)
      document.head.removeChild(style)
    }, 300)
  }, 3000)
}

// Countdown timer
function startCountdown(seconds) {
  const countdownElement = document.getElementById("countdown")

  function updateCountdown() {
    const minutes = Math.floor(seconds / 60)
    const remainingSeconds = seconds % 60

    countdownElement.textContent = `${minutes.toString().padStart(2, "0")}:${remainingSeconds.toString().padStart(2, "0")}`

    if (seconds <= 0) {
      countdownElement.textContent = "00:00"
      countdownElement.style.color = "#dc2626"
      showPaymentTimeout()
      return
    }

    seconds--
    setTimeout(updateCountdown, 1000)
  }

  updateCountdown()
}

// Handle payment timeout
function showPaymentTimeout() {
  const paymentStatus = document.querySelector(".payment-status")
  paymentStatus.innerHTML = `
        <div class="status-indicator">
            <i class="fas fa-times-circle"></i>
            <span>Hết thời gian thanh toán</span>
        </div>
        <p class="status-text">Vui lòng thực hiện lại giao dịch</p>
        <button class="btn btn-primary" onclick="location.reload()">
            <i class="fas fa-redo"></i>
            Thử lại
        </button>
    `
  paymentStatus.style.background = "#fee2e2"
  paymentStatus.style.borderColor = "#dc2626"
}

// Simulate payment received (for demo purposes)
function simulatePaymentReceived() {
  const paymentStatus = document.querySelector(".payment-status")
  paymentStatus.innerHTML = `
        <div class="status-indicator">
            <i class="fas fa-check-circle"></i>
            <span>Đã nhận được thanh toán</span>
        </div>
        <p class="status-text">Cảm ơn bạn đã thanh toán. Đơn hàng của bạn đang được xử lý.</p>
    `
  paymentStatus.style.background = "#d1fae5"
  paymentStatus.style.borderColor = "#10b981"

  // Enable confirm button
  const confirmBtn = document.getElementById("confirmBtn")
  confirmBtn.disabled = false
  confirmBtn.innerHTML = `
        <i class="fas fa-check"></i>
        Hoàn tất đặt xe
    `
}

// Navigation functions
function goBack() {
  if (confirm("Bạn có chắc muốn quay lại? Thông tin thanh toán sẽ bị mất.")) {
    window.history.back()
  }
}

function confirmPayment() {
  const agreeTerms = document.getElementById("agreeTerms")

  if (!agreeTerms.checked) {
    alert("Vui lòng đồng ý với điều khoản đặt cọc")
    return
  }

  // Show loading state
  const confirmBtn = document.getElementById("confirmBtn")
  const originalText = confirmBtn.innerHTML
  confirmBtn.innerHTML = `
        <i class="fas fa-spinner fa-spin"></i>
        Đang xử lý...
    `
  confirmBtn.disabled = true

  // Simulate processing time
  setTimeout(() => {
    // Redirect to contract signing page instead of success
    window.location.href = "booking-form-contract.jsp"
  }, 2000)
}

// Auto-scroll terms to bottom when user starts reading
let hasScrolledTerms = false
document.querySelector(".terms-content").addEventListener("scroll", () => {
  if (!hasScrolledTerms) {
    hasScrolledTerms = true
    // User has started reading terms
  }
})

// Smooth scroll to agreement section when terms are fully scrolled
document.querySelector(".terms-content").addEventListener("scroll", function () {
  if (this.scrollTop + this.clientHeight >= this.scrollHeight - 10) {
    // User has scrolled to bottom of terms
    setTimeout(() => {
      document.querySelector(".agreement-section").scrollIntoView({
        behavior: "smooth",
        block: "center",
      })
    }, 500)
  }
})

// Prevent form submission on Enter key in terms section
document.querySelector(".terms-section").addEventListener("keydown", (e) => {
  if (e.key === "Enter") {
    e.preventDefault()
  }
})

// Add visual feedback for successful copy operations
function addCopyFeedback(element) {
  const originalColor = element.style.color
  element.style.color = "#059669"
  element.style.transform = "scale(1.05)"

  setTimeout(() => {
    element.style.color = originalColor
    element.style.transform = "scale(1)"
  }, 200)
}

// Enhanced copy functionality with visual feedback
document.querySelectorAll(".copyable").forEach((element) => {
  element.addEventListener("click", function () {
    addCopyFeedback(this)
  })
})
