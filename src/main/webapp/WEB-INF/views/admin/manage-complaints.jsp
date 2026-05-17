<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Complaints - CivicConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/stylesheet.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <main class="container">
        <h2>Manage Complaints - <c:out value="${sessionScope.municipalityName}" /></h2>
        
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
            <form action="${pageContext.request.contextPath}/admin/manage-complaints" method="GET" class="filter-form">
                <input type="text" name="search" placeholder="Search title or description..." value="<c:out value='${paramSearch}'/>">
                
                <select name="categoryId">
                    <option value="">All Categories</option>
                    <c:forEach var="cat" items="${categories}">
                        <option value="${cat.id}" ${paramCategoryId == cat.id ? 'selected' : ''}>
                            <c:out value="${cat.name}" />
                        </option>
                    </c:forEach>
                </select>

                <input type="number" name="wardNumber" placeholder="Ward Number" min="1" max="33" value="<c:out value='${paramWard}'/>">

                <select name="status">
                    <option value="">All Statuses</option>
                    <option value="pending" ${paramStatus == 'pending' ? 'selected' : ''}>Pending</option>
                    <option value="in_progress" ${paramStatus == 'in_progress' ? 'selected' : ''}>In Progress</option>
                    <option value="resolved" ${paramStatus == 'resolved' ? 'selected' : ''}>Resolved</option>
                </select>
                
                <select name="sortBy">
                    <option value="date_desc" ${paramSortBy == 'date_desc' ? 'selected' : ''}>Newest First</option>
                    <option value="date_asc" ${paramSortBy == 'date_asc' ? 'selected' : ''}>Oldest First</option>
                    <option value="votes_desc" ${paramSortBy == 'votes_desc' ? 'selected' : ''}>Most Supported</option>
                    <option value="votes_asc" ${paramSortBy == 'votes_asc' ? 'selected' : ''}>Least Supported</option>
                </select>

                <button type="submit" class="btn btn-primary">Apply Filters</button>
                <a href="${pageContext.request.contextPath}/admin/manage-complaints" class="btn btn-secondary">Clear</a>
            </form>
        </section>

        <section class="list-container" style="margin-top: 1.5rem;">
            <c:choose>
                <c:when test="${empty complaints}">
                    <p>No complaints found matching your criteria.</p>
                </c:when>
                <c:otherwise>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Submitted By</th>
                                <th>Category</th>
                                <th>Ward</th>
                                <th>Status</th>
                                <th>Votes</th>
                                <th>Date Submitted</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="complaint" items="${complaints}">
                                <tr>
                                    <td><c:out value="${complaint.title}" /></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${complaint.anonymous}">
                                                <c:out value="${complaint.userName}" /> <span class="badge badge-secondary">Anonymous</span>
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="${complaint.userName}" />
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><c:out value="${complaint.categoryName}" /></td>
                                    <td><c:out value="${complaint.wardNumber}" /></td>
                                    <td>
                                        <span class="badge badge-${fn:toLowerCase(complaint.status)}">
                                            <c:choose>
                                                <c:when test="${complaint.status == 'pending'}">Pending</c:when>
                                                <c:when test="${complaint.status == 'in_progress'}">In Progress</c:when>
                                                <c:when test="${complaint.status == 'resolved'}">Resolved</c:when>
                                            </c:choose>
                                        </span>
                                    </td>
                                    <td><c:out value="${complaint.voteCount}" /></td>
                                    <td><fmt:formatDate value="${complaint.createdAt}" pattern="yyyy-MM-dd" /></td>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/admin/complaint-detail?id=${complaint.id}" class="btn-sm btn-primary">View</a>
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
