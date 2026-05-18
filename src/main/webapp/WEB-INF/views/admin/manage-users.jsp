<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Users - CivicConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/stylesheet.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <main class="container">
        <h2>Manage Citizens - <c:out value="${sessionScope.municipalityName}" /></h2>
        
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">
                <c:out value="${param.success}" />
            </div>
        </c:if>
        
        <c:if test="${not empty param.error}">
            <div class="alert alert-error">
                <c:out value="${param.error}" />
            </div>
        </c:if>

        <section class="filter-section">
            <form action="${pageContext.request.contextPath}/admin/manage-users" method="GET" class="filter-form">
                <input type="text" name="search" placeholder="Search by name, email, or phone..." value="<c:out value='${paramSearch}'/>" style="flex: 1;">
                <button type="submit" class="btn btn-primary">Search</button>
                <a href="${pageContext.request.contextPath}/admin/manage-users" class="btn btn-secondary">Clear</a>
            </form>
        </section>

        <section class="list-container" style="margin-top: 1.5rem;">
            <c:choose>
                <c:when test="${empty citizens}">
                    <p>No citizens found.</p>
                </c:when>
                <c:otherwise>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Ward</th>
                                <th>Status</th>
                                <th>Date Registered</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${citizens}">
                                <tr>
                                    <td><c:out value="${user.id}" /></td>
                                    <td><c:out value="${user.fullName}" /></td>
                                    <td><c:out value="${user.email}" /></td>
                                    <td><c:out value="${user.phone}" /></td>
                                    <td><c:out value="${user.wardNumber}" /></td>
                                    <td>
                                        <span class="badge badge-${user.status == 'active' ? 'success' : 'secondary'}">
                                            <c:out value="${user.status == 'active' ? 'Active' : 'Inactive'}" />
                                        </span>
                                    </td>
                                    <td><fmt:formatDate value="${user.createdAt}" pattern="yyyy-MM-dd" /></td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin/manage-users" method="POST" style="display:inline;">
                                            <input type="hidden" name="userId" value="${user.id}">
                                            <c:choose>
                                                <c:when test="${user.status == 'active'}">
                                                    <input type="hidden" name="action" value="deactivate">
                                                    <button type="submit" class="btn-sm btn-danger" onclick="return confirm('Are you sure you want to deactivate this user?');">Deactivate</button>
                                                </c:when>
                                                <c:otherwise>
                                                    <input type="hidden" name="action" value="activate">
                                                    <button type="submit" class="btn-sm btn-success">Activate</button>
                                                </c:otherwise>
                                            </c:choose>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </section>
    </main>
</body>
</html>
