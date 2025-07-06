<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
    <title>Test Form</title>
  </head>
  <body>
    <h2>Test Upload Form</h2>

    <form
      action="${pageContext.request.contextPath}/manageCarsServlet"
      method="post"
      enctype="multipart/form-data"
    >
      <input type="hidden" name="action" value="add" />

      <div>
        <label>Car Model:</label>
        <input type="text" name="carModel" value="Test Car" required />
      </div>

      <div>
        <label>Brand ID:</label>
        <input
          type="text"
          name="brandId"
          value="550e8400-e29b-41d4-a716-446655440000"
          required
        />
      </div>

      <div>
        <label>Fuel Type ID:</label>
        <input
          type="text"
          name="fuelTypeId"
          value="550e8400-e29b-41d4-a716-446655440001"
          required
        />
      </div>

      <div>
        <label>Transmission Type ID:</label>
        <input
          type="text"
          name="transmissionTypeId"
          value="550e8400-e29b-41d4-a716-446655440002"
          required
        />
      </div>

      <div>
        <label>Seats:</label>
        <input type="number" name="seats" value="5" required />
      </div>

      <div>
        <label>Year:</label>
        <input type="number" name="yearManufactured" value="2023" required />
      </div>

      <div>
        <label>Price Per Day:</label>
        <input
          type="number"
          name="pricePerDay"
          value="50.00"
          step="0.01"
          required
        />
      </div>

      <div>
        <label>Price Per Hour:</label>
        <input
          type="number"
          name="pricePerHour"
          value="5.00"
          step="0.01"
          required
        />
      </div>

      <div>
        <label>Status:</label>
        <select name="status" required>
          <option value="Available">Available</option>
          <option value="Rented">Rented</option>
          <option value="Unavailable">Unavailable</option>
        </select>
      </div>

      <div>
        <label>Car Image:</label>
        <input type="file" name="carImage" accept="image/*" />
      </div>

      <button type="submit">Test Add Car</button>
    </form>

    <hr />

    <h3>Test Update Form</h3>
    <form
      action="${pageContext.request.contextPath}/manageCarsServlet"
      method="post"
      enctype="multipart/form-data"
    >
      <input type="hidden" name="action" value="update" />
      <input
        type="hidden"
        name="carId"
        value="550e8400-e29b-41d4-a716-446655440003"
      />

      <div>
        <label>Car Model:</label>
        <input type="text" name="carModel" value="Updated Test Car" required />
      </div>

      <div>
        <label>Brand ID:</label>
        <input
          type="text"
          name="brandId"
          value="550e8400-e29b-41d4-a716-446655440000"
          required
        />
      </div>

      <div>
        <label>Fuel Type ID:</label>
        <input
          type="text"
          name="fuelTypeId"
          value="550e8400-e29b-41d4-a716-446655440001"
          required
        />
      </div>

      <div>
        <label>Transmission Type ID:</label>
        <input
          type="text"
          name="transmissionTypeId"
          value="550e8400-e29b-41d4-a716-446655440002"
          required
        />
      </div>

      <div>
        <label>Seats:</label>
        <input type="number" name="seats" value="5" required />
      </div>

      <div>
        <label>Year:</label>
        <input type="number" name="yearManufactured" value="2023" required />
      </div>

      <div>
        <label>Price Per Day:</label>
        <input
          type="number"
          name="pricePerDay"
          value="60.00"
          step="0.01"
          required
        />
      </div>

      <div>
        <label>Price Per Hour:</label>
        <input
          type="number"
          name="pricePerHour"
          value="6.00"
          step="0.01"
          required
        />
      </div>

      <div>
        <label>Status:</label>
        <select name="status" required>
          <option value="Available">Available</option>
          <option value="Rented">Rented</option>
          <option value="Unavailable">Unavailable</option>
        </select>
      </div>

      <div>
        <label>Car Image (optional):</label>
        <input type="file" name="carImage" accept="image/*" />
      </div>

      <button type="submit">Test Update Car</button>
    </form>
  </body>
</html>
