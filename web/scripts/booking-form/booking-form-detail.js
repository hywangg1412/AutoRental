/* 
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/JavaScript.js to edit this template
 */

// Price calculation functionality
function calculatePrice() {
  const rentalType = document.getElementById("rentalType")?.value;
  const startDate = new Date(document.getElementById("startDate")?.value);
  const endDate = new Date(document.getElementById("endDate")?.value);

  if (!rentalType || !startDate || !endDate || startDate >= endDate) {
    updatePriceDisplay(0, 0, "0 ngày");
    return;
  }

  const priceData = document.getElementById("carPriceData")?.dataset;
  if (!priceData) return;

  const prices = {
    hourly: parseFloat(priceData.hourly),
    daily: parseFloat(priceData.daily),
    monthly: parseFloat(priceData.monthly),
  };

  let duration = 0, unitPrice = 0, totalPrice = 0, durationText = "";

  const timeDiff = endDate - startDate;

  switch (rentalType) {
    case "hourly":
      duration = Math.ceil(timeDiff / (1000 * 60 * 60));
      unitPrice = prices.hourly;
      durationText = `${duration} giờ`;
      break;
    case "daily":
      duration = Math.ceil(timeDiff / (1000 * 60 * 60 * 24));
      unitPrice = prices.daily;
      durationText = `${duration} ngày`;
      break;
    case "monthly":
      duration = Math.ceil(timeDiff / (1000 * 60 * 60 * 24 * 30));
      unitPrice = prices.monthly;
      durationText = `${duration} tháng`;
      break;
    default:
      duration = 0;
      durationText = "0 ngày";
  }

  totalPrice = duration * unitPrice;
  updatePriceDisplay(unitPrice, totalPrice, durationText);
}

function updatePriceDisplay(unitPrice, totalPrice, duration) {
  document.getElementById("totalDuration").textContent = duration;
  document.getElementById("unitPrice").textContent = `${unitPrice.toLocaleString()}K`;
  document.getElementById("totalPrice").textContent = `${totalPrice.toLocaleString()}K`;
}

// Form validation
function validateForm() {
  const form = document.getElementById("bookingForm");
  const requiredFields = form.querySelectorAll("[required]");
  let isValid = true;

  requiredFields.forEach((field) => {
    if (!field.value.trim()) {
      field.style.borderColor = "#ef4444";
      isValid = false;
    } else {
      field.style.borderColor = "#d1d5db";
    }
  });

  const startDate = new Date(document.getElementById("startDate").value);
  const endDate = new Date(document.getElementById("endDate").value);
  const now = new Date();

  if (startDate < now) {
    alert("Ngày bắt đầu không thể là quá khứ");
    isValid = false;
  }

  if (startDate >= endDate) {
    alert("Ngày kết thúc phải sau ngày bắt đầu");
    isValid = false;
  }

  return isValid;
}

// Navigation
function goHome() {
  if (confirm("Bạn có chắc muốn quay về trang chủ? Thông tin đã nhập sẽ bị mất.")) {
    window.location.href = "index.jsp";
  }
}

function goToDeposit() {
  if (!validateForm()) return;
  document.getElementById("bookingForm").submit();
}

// Event listeners
document.addEventListener("DOMContentLoaded", () => {
  const now = new Date();
  const today = now.toISOString().slice(0, 16);
  document.getElementById("startDate").min = today;
  document.getElementById("endDate").min = today;

  document.getElementById("rentalType")?.addEventListener("change", calculatePrice);
  document.getElementById("startDate")?.addEventListener("change", function () {
    document.getElementById("endDate").min = this.value;
    calculatePrice();
  });
  document.getElementById("endDate")?.addEventListener("change", calculatePrice);

  document.getElementById("bookingForm")?.addEventListener("submit", (e) => {
    if (!validateForm()) {
      e.preventDefault();
    }
  });

  // Optional: handle pickupLocation if you have this field
  const pickupLocation = document.getElementById("pickupLocation");
  if (pickupLocation) {
    pickupLocation.addEventListener("change", function () {
      if (this.value === "delivery") {
        console.log("Delivery option selected");
      }
    });
  }
});
