document.addEventListener("DOMContentLoaded", () => {
  initializeContract()
})

function initializeContract() {
  const agreeContract = document.getElementById("agreeContract")
  const signContractBtn = document.getElementById("signContractBtn")
  const paymentOptions = document.querySelectorAll('input[name="paymentOption"]')
  const paymentMethods = document.getElementById("paymentMethods")

  // Enable/disable sign contract button based on agreement
  agreeContract.addEventListener("change", function () {
    signContractBtn.disabled = !this.checked
  })

  // Handle payment option selection
  paymentOptions.forEach((option) => {
    option.addEventListener("change", function () {
      if (this.checked) {
        paymentMethods.style.display = "block"
        updatePaymentAmount(this.value)
      }
    })
  })

  // Handle payment method selection
  const methodButtons = document.querySelectorAll(".payment-method")
  methodButtons.forEach((method) => {
    method.addEventListener("click", function () {
      methodButtons.forEach((m) => m.classList.remove("active"))
      this.classList.add("active")
      updateQRCode(this.dataset.method)
    })
  })
}

function updatePaymentAmount(option) {
  const paymentAmount = document.getElementById("paymentAmount")
  const baseAmount = 2380700

  if (option === "full") {
    // Apply 5% discount for full payment
    const discountedAmount = Math.round(baseAmount * 0.95)
    paymentAmount.textContent = `${discountedAmount.toLocaleString()} VND`
  } else {
    paymentAmount.textContent = `${baseAmount.toLocaleString()} VND`
  }
}

function updateQRCode(method) {
  const qrCode = document.getElementById("paymentQR")

  if (method === "bank") {
    qrCode.src = "/placeholder.svg?height=200&width=200&text=Bank+QR"
  } else if (method === "momo") {
    qrCode.src = "/placeholder.svg?height=200&width=200&text=MoMo+QR"
  }
}

function signContract() {
  const agreeContract = document.getElementById("agreeContract")
  const selectedPaymentOption = document.querySelector('input[name="paymentOption"]:checked')

  if (!agreeContract.checked) {
    showToast("Please agree to the contract terms first", "error")
    return
  }

  if (!selectedPaymentOption) {
    showToast("Please select a payment option", "error")
    return
  }

  // Show loading state
  const signBtn = document.getElementById("signContractBtn")
  const originalText = signBtn.innerHTML
  signBtn.innerHTML = `
    <i class="fas fa-spinner fa-spin"></i>
    Processing...
  `
  signBtn.disabled = true

  // Simulate contract signing process
  setTimeout(() => {
    if (selectedPaymentOption.value === "full") {
      // Redirect to payment processing
      showToast("Contract signed successfully! Processing payment...", "success")
      setTimeout(() => {
        window.location.href = "booking-success.jsp"
      }, 2000)
    } else {
      // Schedule payment for later
      showToast("Contract signed successfully! Payment reminder will be sent 24 hours before pickup.", "success")
      setTimeout(() => {
        window.location.href = "booking-success.jsp?payment=scheduled"
      }, 2000)
    }
  }, 2000)
}

function goBack() {
  if (confirm("Are you sure you want to go back? Your contract progress will be lost.")) {
    window.location.href = "booking-form-deposit.jsp"
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

// Auto-fill customer information (mock data)
document.addEventListener("DOMContentLoaded", () => {
  // This would normally come from the server/session
  const customerInfo = {
    name: "John Doe",
    id: "123456789",
    phone: "+84831837721",
    address: "456 Le Duan, Da Nang",
  }

  document.querySelector(".customer-name").textContent = customerInfo.name
  document.querySelector(".customer-id").textContent = customerInfo.id
  document.querySelector(".customer-phone").textContent = customerInfo.phone
  document.querySelector(".customer-address").textContent = customerInfo.address
})
