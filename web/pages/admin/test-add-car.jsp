<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <% // Load data for the test page try
{ Service.Car.CarBrandService carBrandService = new
Service.Car.CarBrandService(); Service.Car.FuelTypeService fuelTypeService = new
Service.Car.FuelTypeService(); Service.Car.TransmissionTypeService
transmissionTypeService = new Service.Car.TransmissionTypeService();
Service.Car.CarCategoriesService carCategoriesService = new
Service.Car.CarCategoriesService(); request.setAttribute("brandList",
carBrandService.getAll()); request.setAttribute("fuelTypeList",
fuelTypeService.getAll()); request.setAttribute("transmissionTypeList",
transmissionTypeService.getAll()); request.setAttribute("categoryList",
carCategoriesService.getAll()); request.setAttribute("maxYear",
java.time.Year.now().getValue() + 1); } catch (Exception e) {
e.printStackTrace(); } %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Test Add Car - AutoRental</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 20px;
        background: #f5f5f5;
      }
      .container {
        max-width: 800px;
        margin: 0 auto;
        background: white;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
      }
      .header {
        text-align: center;
        margin-bottom: 30px;
        padding-bottom: 20px;
        border-bottom: 2px solid #e9ecef;
      }
      .header h1 {
        color: #333;
        margin-bottom: 10px;
      }
      .header p {
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
      .alert {
        padding: 12px;
        margin-bottom: 20px;
        border-radius: 4px;
      }
      .alert-success {
        background: #d4edda;
        color: #155724;
        border: 1px solid #c3e6cb;
      }
      .alert-error {
        background: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
      }
      .note-box {
        background: #e7f3ff;
        padding: 15px;
        border-radius: 6px;
        border-left: 4px solid #007bff;
        margin-bottom: 20px;
      }
      .note-box p {
        margin: 0;
        color: #0056b3;
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
    <div class="container">
      <div class="header">
        <h1>🚗 Test Add Car</h1>
        <p>Trang test chức năng thêm xe mới (không có upload ảnh)</p>
      </div>

      <!-- Note about images -->
      <div class="note-box">
        <p>
          <strong>📝 Lưu ý:</strong> Ảnh xe có thể được upload riêng biệt sau
          khi thêm xe thành công. Sử dụng nút "Upload Images" trong danh sách xe
          để thêm ảnh.
        </p>
      </div>

      <!-- Alerts -->
      <c:if test="${not empty param.error || not empty param.success}">
        <div
          class="alert ${not empty param.error ? 'alert-error' : 'alert-success'}"
        >
          ${param.error != null ? param.error : param.success}
        </div>
      </c:if>

      <!-- Add Car Form -->
      <form
        id="addCarForm"
        action="${pageContext.request.contextPath}/manageCarsServlet"
        method="post"
      >
        <input type="hidden" name="action" value="add" />

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
                <option value="Available">Available</option>
                <option value="Rented">Rented</option>
                <option value="Unavailable">Unavailable</option>
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
            <svg
              width="16"
              height="16"
              fill="currentColor"
              viewBox="0 0 24 24"
              style="margin-right: 8px"
            >
              <path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z" />
            </svg>
            Add Car
          </button>
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
              style="margin-right: 8px"
            >
              <path
                d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"
              />
            </svg>
            Fill Test Data
          </button>
          <button type="button" class="btn btn-success" onclick="resetForm()">
            <svg
              width="16"
              height="16"
              fill="currentColor"
              viewBox="0 0 24 24"
              style="margin-right: 8px"
            >
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
          <svg
            width="16"
            height="16"
            fill="currentColor"
            viewBox="0 0 24 24"
            style="margin-right: 8px"
          >
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

      function fillTestData() {
        document.getElementById("carModel").value =
          "Test Car Model " + new Date().getTime();
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
          "Test car description - " + new Date().toLocaleString();
        document.getElementById("status").value = "Available";

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
        document.getElementById("addCarForm").reset();
        document
          .querySelectorAll("#addCarForm select")
          .forEach((select) => (select.selectedIndex = 0));
      }

      // Form validation
      document.getElementById("addCarForm").addEventListener("submit", (e) => {
        console.log("Form submitted");

        // Debug: Log form data
        const formData = new FormData(e.target);
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
