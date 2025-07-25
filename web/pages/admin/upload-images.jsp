<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Upload Car Images - AutoRental</title>
    <link
      href="https://fonts.googleapis.com/css?family=Roboto:400,500,700&display=swap"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="${pageContext.request.contextPath}/styles/admin/upload-images.css"
    />
  </head>
  <body>
    <div class="upload-container">
      <h2>Upload Car Images</h2>

      <div class="alert alert-info">
        <strong>Hướng dẫn:</strong> Upload ảnh cho xe. Giới hạn: tối đa 10 ảnh,
        mỗi ảnh tối đa 5MB.
      </div>

      <div id="message"></div>

      <div class="car-info">
        <h4>Thông tin xe:</h4>
        <p><strong>Car ID:</strong> <span id="carIdDisplay"></span></p>
        <p><strong>Model:</strong> <span id="carModelDisplay"></span></p>
      </div>

      <form id="uploadForm" enctype="multipart/form-data">
        <input type="hidden" id="carId" name="carId" value="" />

        <div class="form-group">
          <label for="carImage">Chọn ảnh (Max 10 files, 5MB each)</label>
          <input
            type="file"
            id="carImage"
            name="carImage"
            accept="image/*"
            multiple
            onchange="validateImages()"
          />
          <div id="imagePreview"></div>
          <small
            >Chọn ảnh để upload. Hệ thống sẽ tự động giới hạn số lượng.</small
          >
        </div>

        <div style="margin-top: 20px">
          <button type="submit" class="btn btn-primary">Upload Images</button>
          <button
            type="button"
            class="btn btn-secondary"
            onclick="deleteImages()"
          >
            Delete All Images
          </button>
          <a
            href="${pageContext.request.contextPath}/manageCarsServlet"
            class="btn btn-secondary"
            >Back to Car Management</a
          >
        </div>
      </form>
    </div>

    <script>
      // Lấy carId từ URL parameter
      const urlParams = new URLSearchParams(window.location.search);
      const carId = urlParams.get("carId");

      if (carId) {
        document.getElementById("carId").value = carId;
        document.getElementById("carIdDisplay").textContent = carId;

        // Fetch car info
        fetchCarInfo(carId);
      } else {
        document.getElementById("message").innerHTML =
          '<div class="alert alert-warning">Car ID is required. Please go back and select a car.</div>';
      }

      function fetchCarInfo(carId) {
        fetch(
          "${pageContext.request.contextPath}/manageCarsServlet?carId=" + carId
        )
          .then((res) => res.json())
          .then((car) => {
            document.getElementById("carModelDisplay").textContent =
              car.carModel || "N/A";
          })
          .catch((error) => {
            console.error("Error fetching car info:", error);
          });
      }

      function validateImages() {
        const input = document.getElementById("carImage");
        const preview = document.getElementById("imagePreview");
        preview.innerHTML = "";
        if (input.files.length > 10) {
          alert(
            "Tối đa 10 ảnh được phép upload. Hệ thống sẽ chỉ xử lý 10 ảnh đầu tiên."
          );
        }
        for (let i = 0; i < Math.min(input.files.length, 10); i++) {
          const file = input.files[i];
          if (!file.type.startsWith("image/")) {
            alert("Chỉ chấp nhận file ảnh!");
            input.value = "";
            preview.innerHTML = "";
            return false;
          }
          if (file.size > 5 * 1024 * 1024) {
            alert("Ảnh " + file.name + " vượt quá 5MB!");
            input.value = "";
            preview.innerHTML = "";
            return false;
          }
          const reader = new FileReader();
          reader.onload = (e) => {
            const img = document.createElement("img");
            img.src = e.target.result;
            img.className = "image-preview";
            preview.appendChild(img);
          };
          reader.readAsDataURL(file);
        }
        return true;
      }

      document.getElementById("uploadForm").onsubmit = function () {
        return validateImages();
      };

      document
        .getElementById("uploadForm")
        .addEventListener("submit", function (e) {
          e.preventDefault();

          const formData = new FormData();
          const carId = document.getElementById("carId").value;
          const fileInput = document.getElementById("carImage");

          if (!carId) {
            showMessage("Car ID is required", "warning");
            return;
          }

          if (fileInput.files.length === 0) {
            showMessage("Please select at least one image", "warning");
            return;
          }

          formData.append("carId", carId);
          for (let i = 0; i < Math.min(fileInput.files.length, 10); i++) {
            formData.append("carImage", fileInput.files[i]);
          }

          fetch("${pageContext.request.contextPath}/carImageUploadServlet", {
            method: "POST",
            body: formData,
          })
            .then((response) => {
              console.log("Response status:", response.status);
              if (!response.ok) {
                throw new Error(
                  `HTTP ${response.status}: ${response.statusText}`
                );
              }
              return response.json();
            })
            .then((data) => {
              console.log("Response data:", data);
              if (data.success) {
                showMessage(data.message, "success");
                document.getElementById("uploadForm").reset();
                document.getElementById("imagePreview").innerHTML = "";
              } else {
                showMessage(
                  "Upload failed: " + (data.message || "Unknown error"),
                  "warning"
                );
              }
            })
            .catch((error) => {
              console.error("Error:", error);
              showMessage("Upload failed: " + error.message, "warning");
            });
        });

      function deleteImages() {
        const carId = document.getElementById("carId").value;
        if (!carId) {
          showMessage("Car ID is required", "warning");
          return;
        }

        if (
          !confirm("Are you sure you want to delete all images for this car?")
        ) {
          return;
        }

        const formData = new FormData();
        formData.append("carId", carId);
        formData.append("action", "delete");

        fetch("${pageContext.request.contextPath}/carImageUploadServlet", {
          method: "POST",
          body: formData,
        })
          .then((response) => {
            console.log("Delete response status:", response.status);
            if (!response.ok) {
              throw new Error(
                `HTTP ${response.status}: ${response.statusText}`
              );
            }
            return response.json();
          })
          .then((data) => {
            console.log("Delete response data:", data);
            if (data.success) {
              showMessage(data.message, "success");
            } else {
              showMessage(
                "Delete failed: " + (data.message || "Unknown error"),
                "warning"
              );
            }
          })
          .catch((error) => {
            console.error("Error:", error);
            showMessage("Delete failed: " + error.message, "warning");
          });
      }

      function showMessage(message, type) {
        const messageDiv = document.getElementById("message");
        messageDiv.innerHTML = `<div class="alert alert-${type}">${message}</div>`;

        setTimeout(() => {
          messageDiv.innerHTML = "";
        }, 5000);
      }
    </script>
  </body>
</html>
