<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<c:forEach var="staff" items="${staffList}">
  <tr>
    <form method="post" action="${pageContext.request.contextPath}/admin/staff-management">
      <input type="hidden" name="userId" value="${staff.userId}" />
      <td>
        <span>${staff.firstName}</span> <span>${staff.lastName}</span>
      </td>
      <td>
        <span>${staff.username}</span>
      </td>
      <td>
        <span>${staff.email}</span>
      </td>
      <td>
        <span>${staff.phoneNumber}</span>
      </td>
      <td>
        <c:choose>
          <c:when test="${not empty staff.createdDate}">
            <span>${fn:substringBefore(staff.createdDate, 'T')}</span>
          </c:when>
          <c:otherwise>N/A</c:otherwise>
        </c:choose>
      </td>
      <td>
        <c:choose>
          <c:when test="${staff.status eq 'Active'}">
            <span class="badge success">Active</span>
          </c:when>
          <c:when test="${staff.status eq 'Banned'}">
            <span class="badge danger">Banned</span>
          </c:when>
          <c:when test="${staff.status eq 'Inactive'}">
            <span class="badge warning">Inactive</span>
          </c:when>
          <c:when test="${staff.status eq 'Deleted'}">
            <span class="badge secondary">Deleted</span>
          </c:when>
          <c:otherwise>
            <span class="badge secondary">
              <c:out value="${staff.status}" default="Unknown" />
            </span>
          </c:otherwise>
        </c:choose>
      </td>
      <td>
        <button type="button" class="btn btn-outline-edit"
          onclick="openEditStaffModalFromRow('${staff.userId}', '${staff.firstName}', '${staff.lastName}', '${staff.username}', '${staff.email}', '${staff.phoneNumber}', '${staff.gender}', '${staff.userDOB}')">
          Edit
        </button>
        <button name="action" value="delete" type="submit" class="btn btn-outline-delete"
          onclick="return confirm('Delete this staff member?')">
          Delete
        </button>
      </td>
    </form>
  </tr>
</c:forEach>
<c:if test="${empty staffList}">
  <tr>
    <td colspan="7" style="text-align: center; color: #888">
      No staff members found
    </td>
  </tr>
</c:if> 