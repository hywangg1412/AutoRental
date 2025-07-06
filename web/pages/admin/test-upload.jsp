<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>Test Upload</title>
  </head>
  <body>
    <h2>Test Upload Multiple Images</h2>

    <form
      action="${pageContext.request.contextPath}/manageCarsServlet"
      method="post"
      enctype="multipart/form-data"
    >
      <input type="hidden" name="action" value="add" />
      <input type="hidden" name="carModel" value="Test Car" />
      <input
        type="hidden"
        name="brandId"
        value="550e8400-e29b-41d4-a716-446655440000"
      />
      <input
        type="hidden"
        name="fuelTypeId"
        value="550e8400-e29b-41d4-a716-446655440001"
      />
      <input
        type="hidden"
        name="transmissionTypeId"
        value="550e8400-e29b-41d4-a716-446655440002"
      />
      <input type="hidden" name="seats" value="4" />
      <input type="hidden" name="yearManufactured" value="2023" />
      <input type="hidden" name="pricePerDay" value="50.00" />
      <input type="hidden" name="pricePerHour" value="5.00" />
      <input type="hidden" name="status" value="Available" />

      <label>Select Images (Max 5):</label><br />
      <input
        type="file"
        name="carImage"
        accept="image/*"
        multiple
      /><br /><br />

      <button type="submit">Test Upload</button>
    </form>

    <br />
    <a href="${pageContext.request.contextPath}/manageCarsServlet"
      >Back to Car Management</a
    >
  </body>
</html>
