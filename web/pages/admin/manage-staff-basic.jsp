<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib prefix="c"
uri="http://java.sun.com/jsp/jstl/core" %> <%@ taglib prefix="fmt"
uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
  <head>
    <title>Quản lý nhân viên (Basic)</title>
  </head>
  <body>
    <h2>Quản lý nhân viên</h2>
    <c:if test="${not empty success}"
      ><div style="color: green">${success}</div></c:if
    >
    <c:if test="${not empty error}"
      ><div style="color: red">${error}</div></c:if
    >

    <!-- Form Thêm nhân viên -->
    <form method="post" action="StaffServlet">
      <input type="hidden" name="action" value="add" />
      <b>Thêm nhân viên:</b>
      Họ: <input name="firstName" required /> Tên:
      <input name="lastName" required /> Email:
      <input name="email" type="email" required /> Tài khoản:
      <input name="username" required /> Mật khẩu:
      <input name="password" type="password" required />
      <button type="submit">Thêm</button>
    </form>
    <br />

    <!-- Bảng danh sách nhân viên -->
    <table border="1" cellpadding="6" cellspacing="0">
      <tr>
        <th>Họ tên</th>
        <th>Tài khoản</th>
        <th>Email</th>
        <th>Điện thoại</th>
        <th>Ngày tạo</th>
        <th>Trạng thái</th>
        <th>Thao tác</th>
      </tr>
      <c:forEach var="staff" items="${staffList}">
        <tr>
          <td>
            <form method="post" action="StaffServlet" style="display:inline">
              <input type="hidden" name="userId" value="${staff.userId}" />
              <input name="firstName" value="${staff.firstName}" size="8" required />
              <input name="lastName" value="${staff.lastName}" size="8" required />
          </td>
          <td><input name="username" value="${staff.username}" size="8" required readonly /></td>
          <td><input name="email" value="${staff.email}" size="16" required readonly /></td>
          <td><input name="phoneNumber" value="${staff.phoneNumber}" size="10" /></td>
          <td>
            <c:choose>
              <c:when test="${not empty staff.createdDate}">
                ${staff.createdDate}
              </c:when>
              <c:otherwise>N/A</c:otherwise>
            </c:choose>
          </td>
          <td>${staff.status}</td>
          <td>
            <button name="action" value="update" type="submit">Lưu</button>
            <button name="action" value="delete" type="submit" onclick="return confirm('Xóa nhân viên này?')">Xóa</button>
            </form>
          </td>
        </tr>
      </c:forEach>
      <c:if test="${empty staffList}">
        <tr>
          <td colspan="7" align="center">Không có nhân viên nào</td>
        </tr>
      </c:if>
    </table>
  </body>
</html>
