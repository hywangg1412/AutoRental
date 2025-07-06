<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Get UUIDs for Testing</title>
    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 20px;
      }
      .section {
        margin-bottom: 30px;
        padding: 15px;
        border: 1px solid #ddd;
        border-radius: 4px;
      }
      .uuid {
        font-family: monospace;
        background: #f5f5f5;
        padding: 5px;
        border-radius: 3px;
        margin: 5px 0;
      }
      .copy-btn {
        padding: 2px 8px;
        background: #007bff;
        color: white;
        border: none;
        border-radius: 3px;
        cursor: pointer;
        font-size: 12px;
      }
      .copy-btn:hover {
        background: #0056b3;
      }
      h2 {
        color: #333;
        border-bottom: 2px solid #007bff;
        padding-bottom: 5px;
      }
    </style>
  </head>
  <body>
    <h1>🔑 Get UUIDs for Testing</h1>

    <div class="section">
      <h2>Car Brands</h2>
      <c:forEach var="brand" items="${brandList}">
        <div>
          <span class="uuid" id="brand-${brand.brandId}">${brand.brandId}</span>
          <button
            class="copy-btn"
            onclick="copyToClipboard('brand-${brand.brandId}')"
          >
            Copy
          </button>
          <strong>${brand.brandName}</strong>
        </div>
      </c:forEach>
    </div>

    <div class="section">
      <h2>Fuel Types</h2>
      <c:forEach var="fuel" items="${fuelTypeList}">
        <div>
          <span class="uuid" id="fuel-${fuel.fuelTypeId}"
            >${fuel.fuelTypeId}</span
          >
          <button
            class="copy-btn"
            onclick="copyToClipboard('fuel-${fuel.fuelTypeId}')"
          >
            Copy
          </button>
          <strong>${fuel.fuelName}</strong>
        </div>
      </c:forEach>
    </div>

    <div class="section">
      <h2>Transmission Types</h2>
      <c:forEach var="trans" items="${transmissionTypeList}">
        <div>
          <span class="uuid" id="trans-${trans.transmissionTypeId}"
            >${trans.transmissionTypeId}</span
          >
          <button
            class="copy-btn"
            onclick="copyToClipboard('trans-${trans.transmissionTypeId}')"
          >
            Copy
          </button>
          <strong>${trans.transmissionName}</strong>
        </div>
      </c:forEach>
    </div>

    <div class="section">
      <h2>Existing Cars (for Update/Delete tests)</h2>
      <c:forEach var="car" items="${carList}">
        <div>
          <span class="uuid" id="car-${car.carId}">${car.carId}</span>
          <button
            class="copy-btn"
            onclick="copyToClipboard('car-${car.carId}')"
          >
            Copy
          </button>
          <strong>${car.carModel}</strong> - ${car.brandName}
        </div>
      </c:forEach>
    </div>

    <div class="section">
      <h2>Instructions</h2>
      <ol>
        <li>Click "Copy" button next to any UUID you want to use</li>
        <li>
          Go to
          <a
            href="${pageContext.request.contextPath}/pages/admin/debug-servlet.jsp"
            >Debug Servlet page</a
          >
        </li>
        <li>Paste the UUIDs into the appropriate fields</li>
        <li>Test the forms</li>
      </ol>
    </div>

    <script>
      function copyToClipboard(elementId) {
        const element = document.getElementById(elementId);
        const text = element.textContent;

        navigator.clipboard
          .writeText(text)
          .then(function () {
            const btn = element.nextElementSibling;
            const originalText = btn.textContent;
            btn.textContent = "Copied!";
            btn.style.background = "#28a745";

            setTimeout(function () {
              btn.textContent = originalText;
              btn.style.background = "#007bff";
            }, 1000);
          })
          .catch(function (err) {
            console.error("Could not copy text: ", err);
            alert("Failed to copy: " + err);
          });
      }
    </script>
  </body>
</html>
