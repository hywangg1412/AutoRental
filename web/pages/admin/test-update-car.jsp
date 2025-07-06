<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %> <% // Load car data for the test page
try { Service.Car.CarListService carListService = new
Service.Car.CarListService(); Service.Car.CarBrandService carBrandService = new
Service.Car.CarBrandService(); Service.Car.FuelTypeService fuelTypeService = new
Service.Car.FuelTypeService(); Service.Car.TransmissionTypeService
transmissionTypeService = new Service.Car.TransmissionTypeService();
Service.Car.CarCategoriesService carCategoriesService = new
Service.Car.CarCategoriesService(); request.setAttribute("carList",
carListService.getAll()); request.setAttribute("brandList",
carBrandService.getAll()); request.setAttribute("fuelTypeList",
fuelTypeService.getAll()); request.setAttribute("transmissionTypeList",
transmissionTypeService.getAll()); request.setAttribute("categoryList",
carCategoriesService.getAll()); request.setAttribute("statusList",
java.util.Arrays.asList( new
Controller.Admin.CarManagementServlet.CarStatusOption("Available", "Available"),
new Controller.Admin.CarManagementServlet.CarStatusOption("Rented", "Rented"),
new Controller.Admin.CarManagementServlet.CarStatusOption("Unavailable",
"Unavailable") )); request.setAttribute("maxYear",
java.time.Year.now().getValue() + 1); } catch (Exception e) {
e.printStackTrace(); } %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Test Update Car - AutoRental</title>
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/css/admin-style.css"
    />
    <link
      href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
      rel="stylesheet"
    />
    <style>
      .test-container {
        max-width: 800px;
        margin: 50px auto;
        padding: 20px;
        background: white;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }
      .test-header {
        text-align: center;
        margin-bottom: 30px;
        padding-bottom: 20px;
        border-bottom: 2px solid #e9ecef;
      }
      .test-header h1 {
        color: #333;
        margin-bottom: 10px;
      }
      .test-header p {
        color: #666;
        font-size: 16px;
      }
      .form-section {
        margin-bottom: 30px;
        padding: 20px;
        background: #f8f9fa;
        border-radius: 6px;
      }
      .form-section h3 {
        margin-bottom: 15px;
        color: #495057;
        border-bottom: 1px solid #dee2e6;
        padding-bottom: 10px;
      }
      .form-row {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
        margin-bottom: 15px;
      }
      .form-group {
        margin-bottom: 15px;
      }
      .form-group label {
        display: block;
        margin-bottom: 5px;
        font-weight: 500;
        color: #333;
      }
      .form-group input,
      .form-group select,
      .form-group textarea {
        width: 100%;
        padding: 10px;
        border: 1px solid #ddd;
        border-radius: 4px;
        font-size: 14px;
        box-sizing: border-box;
      }
      .form-group textarea {
        resize: vertical;
        min-height: 80px;
      }
      .btn-group {
        display: flex;
        gap: 10px;
        justify-content: center;
        margin-top: 20px;
      }
      .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
        font-weight: 500;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        gap: 8px;
      }
      .btn-primary {
        background-color: #007bff;
        color: white;
      }
      .btn-primary:hover {
        background-color: #0056b3;
      }
      .btn-success {
        background-color: #28a745;
        color: white;
      }
      .btn-success:hover {
        background-color: #218838;
      }
      .btn-warning {
        background-color: #ffc107;
        color: #212529;
      }
      .btn-warning:hover {
        background-color: #e0a800;
      }
      .btn-danger {
        background-color: #dc3545;
        color: white;
      }
      .btn-danger:hover {
        background-color: #c82333;
      }
      .btn-secondary {
        background-color: #6c757d;
        color: white;
      }
      .btn-secondary:hover {
        background-color: #545b62;
      }
      .alert {
        padding: 12px;
        margin-bottom: 20px;
        border-radius: 4px;
        display: flex;
        align-items: center;
        gap: 10px;
      }
      .alert-success {
        background-color: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
      }
      .alert-error {
        background-color: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
      }
      .car-selector {
        background: #e9ecef;
        padding: 15px;
        border-radius: 6px;
        margin-bottom: 20px;
      }
      .car-info {
        background: #fff3cd;
        padding: 15px;
        border-radius: 6px;
        margin-bottom: 20px;
        border-left: 4px solid #ffc107;
      }
      .car-info h4 {
        margin: 0 0 10px 0;
        color: #856404;
      }
      .car-info p {
        margin: 5px 0;
        color: #856404;
      }
      .hidden {
        display: none;
      }
      .back-link {
        text-align: center;
        margin-top: 20px;
      }
      .back-link a {
        color: #007bff;
        text-decoration: none;
        font-weight: 500;
      }
      .back-link a:hover {
        text-decoration: underline;
      }
    </style>
  </head>
  <body>
    <div class="test-container">
      <div class="test-header">
        <h1>🧪 Test Update Car</h1>
        <p>Trang test chức năng cập nhật thông tin xe</p>
      </div>

      <!-- Alerts -->
      <c:if test="${not empty param.error || not empty param.success}">
        <div
          class="alert ${not empty param.error ? 'alert-error' : 'alert-success'}"
        >
          <svg width="20" height="20" fill="currentColor" viewBox="0 0 24 24">
            <path ${not empty param.error ? 'd="M12 2C6.48 2 2 6.48 2 12s4.48 10
            10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-2h2v2zm0-4h-2V7h2v6z"' :
            'd="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12
            2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"'}/>
          </svg>
          <span>${param.error != null ? param.error : param.success}</span>
        </div>
      </c:if>

      <!-- Car Selector -->
      <div class="car-selector">
        <h3>📋 Bước 1: Chọn xe để cập nhật</h3>
        <div class="form-row">
          <div class="form-group">
            <label for="carSelect">Chọn xe:</label>
            <select id="carSelect" onchange="loadCarData()">
              <option value="">-- Chọn xe --</option>
              <c:forEach var="car" items="${carList}">
                <option value="${car.carId}">
                  ${car.carModel} - ${car.licensePlate}
                </option>
              </c:forEach>
            </select>
          </div>
          <div class="form-group">
            <label>&nbsp;</label>
            <button
              type="button"
              class="btn btn-warning"
              onclick="fillTestData()"
            >
              <svg
                width="16"
                height="16"
                fill="currentColor"
                viewBox="0 0 24 24"
              >
                <path
                  d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"
                />
              </svg>
              Fill Test Data
            </button>
          </div>
        </div>
      </div>

      <!-- Car Info Display -->
      <div id="carInfo" class="car-info hidden">
        <h4>📊 Thông tin xe hiện tại</h4>
        <div id="carInfoContent"></div>
      </div>

      <!-- Update Form -->
      <form
        id="updateForm"
        action="${pageContext.request.contextPath}/manageCarsServlet"
        method="post"
        class="hidden"
      >
        <input type="hidden" name="action" value="update" />
        <input type="hidden" name="carId" id="carId" />

        <div class="form-section">
          <h3>🚗 Thông tin cơ bản</h3>
          <div class="form-row">
            <div class="form-group">
              <label for="carModel">Car Model *</label>
              <input
                type="text"
                id="carModel"
                name="carModel"
                required
                maxlength="100"
                placeholder="Enter car model"
              />
            </div>
            <div class="form-group">
              <label for="licensePlate">License Plate *</label>
              <input
                type="text"
                id="licensePlate"
                name="licensePlate"
                required
                maxlength="20"
                placeholder="e.g., 30A-12345"
              />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label for="brandId">Brand *</label>
              <select id="brandId" name="brandId" required>
                <option value="">Select Brand</option>
                <c:forEach var="brand" items="${brandList}">
                  <option value="${brand.brandId}">${brand.brandName}</option>
                </c:forEach>
              </select>
            </div>
            <div class="form-group">
              <label for="categoryId">Category</label>
              <select id="categoryId" name="categoryId">
                <option value="">Select Category (Optional)</option>
                <c:forEach var="category" items="${categoryList}">
                  <option value="${category.categoryId}">
                    ${category.categoryName}
                  </option>
                </c:forEach>
              </select>
            </div>
          </div>
        </div>

        <div class="form-section">
          <h3>⚙️ Thông số kỹ thuật</h3>
          <div class="form-row">
            <div class="form-group">
              <label for="fuelTypeId">Fuel Type *</label>
              <select id="fuelTypeId" name="fuelTypeId" required>
                <option value="">Select Fuel Type</option>
                <c:forEach var="fuel" items="${fuelTypeList}">
                  <option value="${fuel.fuelTypeId}">${fuel.fuelName}</option>
                </c:forEach>
              </select>
            </div>
            <div class="form-group">
              <label for="transmissionTypeId">Transmission Type *</label>
              <select
                id="transmissionTypeId"
                name="transmissionTypeId"
                required
              >
                <option value="">Select Transmission</option>
                <c:forEach var="trans" items="${transmissionTypeList}">
                  <option value="${trans.transmissionTypeId}">
                    ${trans.transmissionName}
                  </option>
                </c:forEach>
              </select>
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label for="seats">Seats *</label>
              <input
                type="number"
                id="seats"
                name="seats"
                min="1"
                max="50"
                required
                placeholder="1-50"
              />
            </div>
            <div class="form-group">
              <label for="yearManufactured">Year Manufactured *</label>
              <input
                type="number"
                id="yearManufactured"
                name="yearManufactured"
                min="1900"
                max="${maxYear}"
                required
                placeholder="e.g., 2023"
              />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label for="odometer">Odometer (km) *</label>
              <input
                type="number"
                id="odometer"
                name="odometer"
                min="0"
                required
                placeholder="e.g., 50000"
              />
            </div>
            <div class="form-group">
              <label for="status">Status *</label>
              <select id="status" name="status" required>
                <option value="">Select Status</option>
                <c:forEach var="status" items="${statusList}">
                  <option value="${status.value}">${status.label}</option>
                </c:forEach>
              </select>
            </div>
          </div>
        </div>

        <div class="form-section">
          <h3>💰 Thông tin giá</h3>
          <div class="form-row">
            <div class="form-group">
              <label for="pricePerDay">Price Per Day ($) *</label>
              <input
                type="number"
                id="pricePerDay"
                name="pricePerDay"
                step="0.01"
                min="0"
                required
                placeholder="e.g., 50.00"
              />
            </div>
            <div class="form-group">
              <label for="pricePerHour">Price Per Hour ($) *</label>
              <input
                type="number"
                id="pricePerHour"
                name="pricePerHour"
                step="0.01"
                min="0"
                required
                placeholder="e.g., 5.00"
              />
            </div>
          </div>
          <div class="form-row">
            <div class="form-group">
              <label for="pricePerMonth">Price Per Month ($)</label>
              <input
                type="number"
                id="pricePerMonth"
                name="pricePerMonth"
                step="0.01"
                min="0"
                placeholder="e.g., 1000.00 (optional)"
              />
              <small style="color: #666">Leave empty if not applicable</small>
            </div>
          </div>
        </div>

        <div class="form-section">
          <h3>📝 Mô tả</h3>
          <div class="form-group">
            <label for="description">Description</label>
            <textarea
              id="description"
              name="description"
              rows="3"
              maxlength="500"
              placeholder="Enter car description (optional)"
            ></textarea>
          </div>
        </div>

        <div class="btn-group">
          <button type="submit" class="btn btn-primary">
            <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M3 17.25V21h3.75L17.81 9.94l-3.75-3.75L3 17.25zM20.71 7.04c.39-.39.39-1.02 0-1.41l-2.34-2.34c-.39-.39-1.02-.39-1.41 0l-1.83 1.83 3.75 3.75 1.83-1.83z"
              />
            </svg>
            Update Car
          </button>
          <button type="button" class="btn btn-secondary" onclick="resetForm()">
            <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
              <path
                d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"
              />
            </svg>
            Reset
          </button>
        </div>
      </form>

      <div class="back-link">
        <a href="${pageContext.request.contextPath}/manageCarsServlet">
          <svg width="16" height="16" fill="currentColor" viewBox="0 0 24 24">
            <path
              d="M20 11H7.83l5.59-5.59L12 4l-8 8 8 8 1.41-1.41L7.83 13H20v-2z"
            />
          </svg>
          Quay lại trang quản lý xe
        </a>
      </div>
    </div>

    <script>
      const maxYear = parseInt("${maxYear}") || new Date().getFullYear() + 1;

      function loadCarData() {
        const carSelect = document.getElementById("carSelect");
        const carId = carSelect.value;

        if (!carId) {
          document.getElementById("updateForm").classList.add("hidden");
          document.getElementById("carInfo").classList.add("hidden");
          return;
        }

        // Fetch car data
        fetch(
          "${pageContext.request.contextPath}/manageCarsServlet?carId=" + carId
        )
          .then((res) => {
            if (!res.ok) throw new Error("Failed to fetch car data");
            return res.json();
          })
          .then((car) => {
            // Fill form fields
            document.getElementById("carId").value = car.carId || "";
            document.getElementById("carModel").value = car.carModel || "";
            setSelectValue("brandId", car.brandId);
            setSelectValue("fuelTypeId", car.fuelTypeId);
            setSelectValue("transmissionTypeId", car.transmissionTypeId);
            setSelectValue("categoryId", car.categoryId);
            document.getElementById("seats").value = car.seats || "";
            document.getElementById("yearManufactured").value =
              car.yearManufactured || "";
            document.getElementById("licensePlate").value =
              car.licensePlate || "";
            document.getElementById("odometer").value = car.odometer || "";
            document.getElementById("pricePerDay").value =
              car.pricePerDay || "";
            document.getElementById("pricePerHour").value =
              car.pricePerHour || "";
            document.getElementById("pricePerMonth").value =
              car.pricePerMonth !== "null" && car.pricePerMonth !== "0"
                ? car.pricePerMonth
                : "";
            setSelectValue("status", car.status);
            document.getElementById("description").value =
              car.description || "";

            // Show car info
            showCarInfo(car);

            // Show form
            document.getElementById("updateForm").classList.remove("hidden");
          })
          .catch((error) => {
            console.error("Error:", error);
            alert("Unable to load car information!");
          });
      }

      function showCarInfo(car) {
        const carInfo = document.getElementById("carInfo");
        const carInfoContent = document.getElementById("carInfoContent");

        carInfoContent.innerHTML = `
                <p><strong>Model:</strong> ${car.carModel || "N/A"}</p>
                <p><strong>License Plate:</strong> ${
                  car.licensePlate || "N/A"
                }</p>
                <p><strong>Year:</strong> ${car.yearManufactured || "N/A"}</p>
                <p><strong>Seats:</strong> ${car.seats || "N/A"}</p>
                <p><strong>Price/Day:</strong> $${car.pricePerDay || "N/A"}</p>
                <p><strong>Status:</strong> ${car.status || "N/A"}</p>
            `;

        carInfo.classList.remove("hidden");
      }

      function setSelectValue(selectId, value) {
        const select = document.getElementById(selectId);
        if (select && value) {
          for (let option of select.options) {
            if (option.value === value) {
              option.selected = true;
              break;
            }
          }
        }
      }

      function fillTestData() {
        const carSelect = document.getElementById("carSelect");
        if (!carSelect.value) {
          alert("Vui lòng chọn xe trước khi fill test data!");
          return;
        }

        // Fill with test data
        document.getElementById("carModel").value =
          "Test Updated Model " + new Date().getTime();
        document.getElementById("licensePlate").value =
          "30A-" + Math.floor(Math.random() * 90000) + 10000;
        document.getElementById("seats").value =
          Math.floor(Math.random() * 7) + 2;
        document.getElementById("yearManufactured").value =
          2020 + Math.floor(Math.random() * 4);
        document.getElementById("odometer").value =
          Math.floor(Math.random() * 100000) + 10000;
        document.getElementById("pricePerDay").value = (
          Math.floor(Math.random() * 200) + 50
        ).toFixed(2);
        document.getElementById("pricePerHour").value = (
          Math.floor(Math.random() * 20) + 5
        ).toFixed(2);
        document.getElementById("pricePerMonth").value = (
          Math.floor(Math.random() * 5000) + 1000
        ).toFixed(2);
        document.getElementById("description").value =
          "Test updated description - " + new Date().toLocaleString();

        // Set random status
        const statuses = ["Available", "Rented", "Unavailable"];
        document.getElementById("status").value =
          statuses[Math.floor(Math.random() * statuses.length)];

        // Set random brand, fuel, transmission
        const brandSelect = document.getElementById("brandId");
        if (brandSelect.options.length > 1) {
          brandSelect.selectedIndex =
            Math.floor(Math.random() * (brandSelect.options.length - 1)) + 1;
        }

        const fuelSelect = document.getElementById("fuelTypeId");
        if (fuelSelect.options.length > 1) {
          fuelSelect.selectedIndex =
            Math.floor(Math.random() * (fuelSelect.options.length - 1)) + 1;
        }

        const transmissionSelect =
          document.getElementById("transmissionTypeId");
        if (transmissionSelect.options.length > 1) {
          transmissionSelect.selectedIndex =
            Math.floor(
              Math.random() * (transmissionSelect.options.length - 1)
            ) + 1;
        }

        alert("Test data đã được điền!");
      }

      function resetForm() {
        document.getElementById("updateForm").reset();
        document.getElementById("carSelect").selectedIndex = 0;
        document.getElementById("updateForm").classList.add("hidden");
        document.getElementById("carInfo").classList.add("hidden");
      }

      // Form validation
      document.getElementById("updateForm").addEventListener("submit", (e) => {
        console.log("Form submitted");

        // Debug: Log form data
        const formData = new FormData(document.getElementById("updateForm"));
        for (let [key, value] of formData.entries()) {
          console.log(key + ": " + value);
        }

        const seats = document.getElementById("seats").value;
        const year = document.getElementById("yearManufactured").value;
        const licensePlate = document.getElementById("licensePlate").value;
        const odometer = document.getElementById("odometer").value;
        const pricePerDay = document.getElementById("pricePerDay").value;
        const pricePerHour = document.getElementById("pricePerHour").value;
        const pricePerMonth = document.getElementById("pricePerMonth").value;

        if (!seats || seats < 1 || seats > 50) {
          e.preventDefault();
          alert("Seats must be between 1 and 50");
          return;
        }

        if (!year || year < 1900 || year > maxYear) {
          e.preventDefault();
          alert("Year must be between 1900 and " + maxYear);
          return;
        }

        if (!licensePlate || licensePlate.trim().length === 0) {
          e.preventDefault();
          alert("License plate is required");
          return;
        }

        if (!odometer || odometer < 0) {
          e.preventDefault();
          alert("Odometer must be a positive number");
          return;
        }

        if (
          !pricePerDay ||
          pricePerDay < 0 ||
          !pricePerHour ||
          pricePerHour < 0
        ) {
          e.preventDefault();
          alert("Prices per day and hour cannot be negative");
          return;
        }

        if (pricePerMonth !== "" && pricePerMonth < 0) {
          e.preventDefault();
          alert("Price per month cannot be negative");
          return;
        }

        // License plate format validation
        const licensePlateRegex = /^[0-9]{2}[A-Z]-[0-9]{4,5}$/;
        if (!licensePlateRegex.test(licensePlate.trim())) {
          e.preventDefault();
          alert("License plate must be in format: XX-XXXXX (e.g., 30A-12345)");
          return;
        }

        console.log("Form validation passed, submitting...");
      });

      // Auto-hide alerts after 5 seconds
      document.querySelectorAll(".alert").forEach((alert) => {
        setTimeout(() => (alert.style.display = "none"), 5000);
      });
    </script>
  </body>
</html>
