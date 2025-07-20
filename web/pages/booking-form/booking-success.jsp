<%@ page contentType="text/html;charset=UTF-8" language="java" %> <%@ taglib
prefix="c" uri="jakarta.tags.core" %> <%@ taglib prefix="fmt"
uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
  <head>
    <title>Booking Successful</title>
    <link
      rel="stylesheet"
      href="<%= request.getContextPath() %>/styles/success.css"
    />
  </head>
  <body>
    <div class="success-message">
      <h1>🎉 Booking Successful!</h1>
      <p>
        Thank you for your booking. Our staff will contact you soon for
        confirmation.
      </p>
      <c:if test="${not empty booking}">
        <p class="fw-bold">
          <!-- Hiển thị tổng tiền với đơn vị K (nghìn đồng) -->
          Total Amount:
          <fmt:formatNumber
            value="${booking.totalAmount * 1000}"
            pattern="#,##0"
          />
          VND
        </p>
      </c:if>
      <a
        href="<%= request.getContextPath() %>/index.jsp"
        class="btn btn-primary"
        >Back to Home</a
      >
    </div>
  </body>
</html>
