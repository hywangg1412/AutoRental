<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <% // Load car data for the test page
try { Service.Car.CarListService carListService = new
Service.Car.CarListService(); request.setAttribute("carList",
carListService.getAll()); } catch (Exception e) { e.printStackTrace(); } %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Simple Update Test - AutoRental</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 20px;
      }
      .container {
        max-width: 600px;
        margin: 0 auto;
      }
      .form-group {
        margin-bottom: 15px;
      }
      label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
      }
      input,
      select {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
      }
      button {
        padding: 10px 20px;
        background: #007bff;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
      }
      button:hover {
        background: #0056b3;
      }
      .alert {
        padding: 10px;
        margin-bottom: 15px;
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
    </style>
  </head>
  <body>
    <div class="container">
      <h1>🧪 Simple Update Test</h1>

      <!-- Alerts -->
      <c:if test="${not empty param.error || not empty param.success}">
        <div
          class="alert ${not empty param.error ? 'alert-error' : 'alert-success'}"
        >
          ${param.error != null ? param.error : param.success}
        </div>
      </c:if>

      <!-- Car Selector -->
      <div class="form-group">
        <label for="carSelect">Chọn xe:</label>
        <select id="carSelect" onchange="loadCarData()">
          <option value="">-- Chọn xe --</option>
          <c:forEach var="car" items="${carList}">
            <option value="${car.carId}">${car.carModel} - ${car.carId}</option>
          </c:forEach>
        </select>
      </div>

      <!-- Update Form -->
      <form
        id="updateForm"
        action="${pageContext.request.contextPath}/manageCarsServlet"
        method="post"
        style="display: none"
      >
        <input type="hidden" name="action" value="update" />
        <input type="hidden" name="carId" id="carId" />

        <div class="form-group">
          <label for="carModel">Car Model:</label>
          <input type="text" id="carModel" name="carModel" required />
        </div>

        <div class="form-group">
          <label for="brandId">Brand ID:</label>
          <input type="text" id="brandId" name="brandId" required />
        </div>

        <div class="form-group">
          <label for="fuelTypeId">Fuel Type ID:</label>
          <input type="text" id="fuelTypeId" name="fuelTypeId" required />
        </div>

        <div class="form-group">
          <label for="transmissionTypeId">Transmission Type ID:</label>
          <input
            type="text"
            id="transmissionTypeId"
            name="transmissionTypeId"
            required
          />
        </div>

        <div class="form-group">
          <label for="seats">Seats:</label>
          <input type="number" id="seats" name="seats" required />
        </div>

        <div class="form-group">
          <label for="yearManufactured">Year:</label>
          <input
            type="number"
            id="yearManufactured"
            name="yearManufactured"
            required
          />
        </div>

        <div class="form-group">
          <label for="licensePlate">License Plate:</label>
          <input type="text" id="licensePlate" name="licensePlate" required />
        </div>

        <div class="form-group">
          <label for="odometer">Odometer:</label>
          <input type="number" id="odometer" name="odometer" required />
        </div>

        <div class="form-group">
          <label for="pricePerDay">Price Per Day:</label>
          <input
            type="number"
            id="pricePerDay"
            name="pricePerDay"
            step="0.01"
            required
          />
        </div>

        <div class="form-group">
          <label for="pricePerHour">Price Per Hour:</label>
          <input
            type="number"
            id="pricePerHour"
            name="pricePerHour"
            step="0.01"
            required
          />
        </div>

        <div class="form-group">
          <label for="pricePerMonth">Price Per Month:</label>
          <input
            type="number"
            id="pricePerMonth"
            name="pricePerMonth"
            step="0.01"
            value="0"
          />
        </div>

        <div class="form-group">
          <label for="status">Status:</label>
          <select id="status" name="status" required>
            <option value="">Select Status</option>
            <option value="Available">Available</option>
            <option value="Rented">Rented</option>
            <option value="Unavailable">Unavailable</option>
          </select>
        </div>

        <div class="form-group">
          <label for="description">Description:</label>
          <input
            type="text"
            id="description"
            name="description"
            value="Test update"
          />
        </div>

        <button type="submit">Update Car</button>
        <button type="button" onclick="fillTestData()">Fill Test Data</button>
      </form>

      <div style="margin-top: 20px">
        <a href="${pageContext.request.contextPath}/manageCarsServlet"
          >← Quay lại trang quản lý xe</a
        >
      </div>
    </div>

    <script>
      function loadCarData() {
        const carSelect = document.getElementById("carSelect");
        const carId = carSelect.value;

        if (!carId) {
          document.getElementById("updateForm").style.display = "none";
          return;
        }

        fetch(
          "${pageContext.request.contextPath}/manageCarsServlet?carId=" + carId
        )
          .then((res) => {
            if (!res.ok) throw new Error("Failed to fetch car data");
            return res.json();
          })
          .then((car) => {
            console.log("Car data:", car);

            document.getElementById("carId").value = car.carId || "";
            document.getElementById("carModel").value = car.carModel || "";
            document.getElementById("brandId").value = car.brandId || "";
            document.getElementById("fuelTypeId").value = car.fuelTypeId || "";
            document.getElementById("transmissionTypeId").value =
              car.transmissionTypeId || "";
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
                : "0";
            document.getElementById("status").value = car.status || "";
            document.getElementById("description").value =
              car.description || "Test update";

            document.getElementById("updateForm").style.display = "block";
          })
          .catch((error) => {
            console.error("Error:", error);
            alert("Unable to load car information!");
          });
      }

      function fillTestData() {
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
        document.getElementById("status").value = "Available";
      }

      // Debug form submission
      document.getElementById("updateForm").addEventListener("submit", (e) => {
        console.log("Form submitted");
        const formData = new FormData(e.target);
        for (let [key, value] of formData.entries()) {
          console.log(key + ": " + value);
        }
      });
    </script>
  </body>
</html>
