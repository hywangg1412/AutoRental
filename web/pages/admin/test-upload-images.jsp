<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Test Upload Images - AutoRental</title>
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
      .form-group label {
        display: block;
        margin-bottom: 5px;
        font-weight: bold;
      }
      .form-group input {
        width: 100%;
        padding: 8px;
        border: 1px solid #ddd;
        border-radius: 4px;
      }
      .btn {
        padding: 10px 20px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
        margin-right: 10px;
      }
      .btn-primary {
        background-color: #007bff;
        color: white;
      }
      .btn-secondary {
        background-color: #6c757d;
        color: white;
      }
      .alert {
        padding: 10px;
        margin-bottom: 15px;
        border-radius: 4px;
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
      .alert-warning {
        background-color: #fff3cd;
        color: #856404;
        border: 1px solid #ffeaa7;
      }
      .image-preview {
        max-width: 100px;
        max-height: 60px;
        margin: 5px;
        border-radius: 4px;
        border: 1px solid #eee;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h1>Test Upload Images</h1>

      <div id="message"></div>

      <form id="uploadForm" enctype="multipart/form-data">
        <div class="form-group">
          <label for="carId">Car ID:</label>
          <input
            type="text"
            id="carId"
            name="carId"
            value="11111111-1111-1111-1111-111111111111"
            required
          />
          <small>Nhập Car ID để test (có thể dùng UUID mẫu)</small>
        </div>

        <div class="form-group">
          <label for="carImage">Chọn ảnh:</label>
          <input
            type="file"
            id="carImage"
            name="carImage"
            accept="image/*"
            multiple
            onchange="validateImages()"
          />
          <div id="imagePreview"></div>
        </div>

        <div class="form-group">
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

      <div style="margin-top: 30px">
        <h3>Debug Info:</h3>
        <div id="debugInfo"></div>
      </div>
    </div>

    <script>
      function validateImages() {
        const input = document.getElementById("carImage");
        const preview = document.getElementById("imagePreview");
        preview.innerHTML = "";

        for (let i = 0; i < input.files.length; i++) {
          const file = input.files[i];
          console.log(
            "File:",
            file.name,
            "Size:",
            file.size,
            "Type:",
            file.type
          );

          if (!file.type.startsWith("image/")) {
            showMessage("Chỉ chấp nhận file ảnh!", "error");
            input.value = "";
            preview.innerHTML = "";
            return;
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
      }

      document
        .getElementById("uploadForm")
        .addEventListener("submit", function (e) {
          e.preventDefault();

          const formData = new FormData();
          const carId = document.getElementById("carId").value;
          const fileInput = document.getElementById("carImage");

          if (!carId) {
            showMessage("Car ID is required", "error");
            return;
          }

          if (fileInput.files.length === 0) {
            showMessage("Please select at least one image", "error");
            return;
          }

          formData.append("carId", carId);
          for (let i = 0; i < fileInput.files.length; i++) {
            formData.append("carImage", fileInput.files[i]);
          }

          showMessage("Đang upload...", "warning");

          console.log(
            "Uploading to:",
            "${pageContext.request.contextPath}/carImageUploadServlet"
          );
          console.log("Car ID:", carId);
          console.log("Files:", fileInput.files.length);

          fetch("${pageContext.request.contextPath}/carImageUploadServlet", {
            method: "POST",
            body: formData,
          })
            .then((response) => {
              console.log("Response status:", response.status);
              console.log("Response headers:", response.headers);

              if (!response.ok) {
                throw new Error(
                  `HTTP ${response.status}: ${response.statusText}`
                );
              }
              return response.text();
            })
            .then((text) => {
              console.log("Response text:", text);
              try {
                const data = JSON.parse(text);
                console.log("Parsed data:", data);

                if (data.success) {
                  showMessage(data.message, "success");
                  document.getElementById("uploadForm").reset();
                  document.getElementById("imagePreview").innerHTML = "";
                } else {
                  showMessage(
                    "Upload failed: " + (data.message || "Unknown error"),
                    "error"
                  );
                }
              } catch (e) {
                console.error("JSON parse error:", e);
                showMessage("Invalid response format: " + text, "error");
              }
            })
            .catch((error) => {
              console.error("Error:", error);
              showMessage("Upload failed: " + error.message, "error");
            });
        });

      function deleteImages() {
        const carId = document.getElementById("carId").value;
        if (!carId) {
          showMessage("Car ID is required", "error");
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

        showMessage("Đang xóa...", "warning");

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
            return response.text();
          })
          .then((text) => {
            console.log("Delete response text:", text);
            try {
              const data = JSON.parse(text);
              if (data.success) {
                showMessage(data.message, "success");
              } else {
                showMessage(
                  "Delete failed: " + (data.message || "Unknown error"),
                  "error"
                );
              }
            } catch (e) {
              console.error("JSON parse error:", e);
              showMessage("Invalid response format: " + text, "error");
            }
          })
          .catch((error) => {
            console.error("Error:", error);
            showMessage("Delete failed: " + error.message, "error");
          });
      }

      function showMessage(message, type) {
        const messageDiv = document.getElementById("message");
        messageDiv.innerHTML = `<div class="alert alert-${type}">${message}</div>`;

        // Add to debug info
        const debugDiv = document.getElementById("debugInfo");
        const timestamp = new Date().toLocaleTimeString();
        debugDiv.innerHTML += `<div>[${timestamp}] ${type.toUpperCase()}: ${message}</div>`;

        if (type !== "warning") {
          setTimeout(() => {
            messageDiv.innerHTML = "";
          }, 5000);
        }
      }
    </script>
  </body>
</html>
