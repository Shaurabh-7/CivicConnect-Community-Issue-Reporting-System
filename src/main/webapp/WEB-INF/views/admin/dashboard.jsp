<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - CivicConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/stylesheet.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <main class="container">
        <h2>Dashboard - <c:out value="${sessionScope.municipalityName}" /></h2>
        
        <c:if test="${not empty param.success}">
            <div class="alert alert-success">
                <c:out value="${param.success}" />
            </div>
        </c:if>

        <section class="stats-grid">
            <div class="stat-card">
                <h3>Total Complaints</h3>
                <p class="stat-value"><c:out value="${totalComplaints}" /></p>
            </div>
            <div class="stat-card">
                <h3>Pending</h3>
                <p class="stat-value warning"><c:out value="${pendingCount}" /></p>
            </div>
            <div class="stat-card">
                <h3>In Progress</h3>
                <p class="stat-value info"><c:out value="${inProgressCount}" /></p>
            </div>
            <div class="stat-card">
                <h3>Resolved</h3>
                <p class="stat-value success"><c:out value="${resolvedCount}" /></p>
            </div>
            <div class="stat-card">
                <h3>Total Citizens</h3>
                <p class="stat-value"><c:out value="${totalCitizens}" /></p>
            </div>
            <div class="stat-card">
                <h3>Total Votes</h3>
                <p class="stat-value"><c:out value="${totalVotes}" /></p>
            </div>
        </section>

        <div class="dashboard-actions">
            <a href="${pageContext.request.contextPath}/admin/manage-complaints" class="btn btn-primary">View All Complaints</a>
            <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-secondary">View Reports</a>
            <a href="${pageContext.request.contextPath}/admin/manage-users" class="btn btn-secondary">Manage Users</a>
        </div>

        <section class="dashboard-lists">
            <div class="list-container">
                <h3>Latest Complaints</h3>
                <c:choose>
                    <c:when test="${empty latestComplaints}">
                        <p>No complaints have been submitted yet.</p>
                    </c:when>
                    <c:otherwise>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Submitter</th>
                                    <th>Category</th>
                                    <th>Ward</th>
                                    <th>Status</th>
                                    <th>Votes</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="complaint" items="${latestComplaints}">
                                    <tr>
                                        <td><a href="${pageContext.request.contextPath}/admin/complaint-detail?id=${complaint.id}"><c:out value="${complaint.title}" /></a></td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${complaint.anonymous}">
                                                    <c:out value="${complaint.userFullName}" /> <span class="badge badge-secondary">Anonymous</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <c:out value="${complaint.userFullName}" />
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
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>

            <div class="list-container" style="margin-top: 2rem;">
                <h3>Top Supported Complaints</h3>
                <c:choose>
                    <c:when test="${empty topSupported}">
                        <p>No supported complaints yet.</p>
                    </c:when>
                    <c:otherwise>
                        <table class="data-table">
                            <thead>
                                <tr>
                                    <th>Title</th>
                                    <th>Status</th>
                                    <th>Votes</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="complaint" items="${topSupported}">
                                    <tr>
                                        <td><a href="${pageContext.request.contextPath}/admin/complaint-detail?id=${complaint.id}"><c:out value="${complaint.title}" /></a></td>
                                        <td>
                                            <span class="badge badge-${fn:toLowerCase(complaint.status)}">
                                                <c:choose>
                                                    <c:when test="${complaint.status == 'pending'}">Pending</c:when>
                                                    <c:when test="${complaint.status == 'in_progress'}">In Progress</c:when>
                                                    <c:when test="${complaint.status == 'resolved'}">Resolved</c:when>
                                                </c:choose>
                                            </span>
                                        </td>
                                        <td><strong><c:out value="${complaint.voteCount}" /></strong></td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </section>
    </main>
</body>
</html>
