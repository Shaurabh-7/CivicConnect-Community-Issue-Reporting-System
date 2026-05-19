<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - CivicConnect</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/stylesheet.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <main class="admin-main-content">
        <div class="admin-page-header">
            <h1><c:out value="${sessionScope.municipalityName}" /></h1>
            <p>Municipality Admin Dashboard · <c:out value="${sessionScope.municipalityDistrict}" /> District, <c:out value="${sessionScope.municipalityProvince}" /></p>
        </div>

        <c:if test="${not empty param.success}">
            <div class="alert alert-success" style="margin-bottom: 2rem;">
                <c:out value="${param.success}" />
            </div>
        </c:if>
        
        <c:if test="${not empty param.error}">
            <div class="alert alert-danger" style="margin-bottom: 2rem;">
                <c:out value="${param.error}" />
            </div>
        </c:if>

        <!-- Stats Row 1: 4 cards wide -->
        <section class="admin-stats-grid">
            <div class="admin-stat-card card-border-blue">
                <span class="admin-stat-label">TOTAL COMPLAINTS</span>
                <span class="admin-stat-value"><c:out value="${totalComplaints}" /></span>
                <span class="admin-stat-subtext">All time</span>
            </div>
            <div class="admin-stat-card card-border-orange">
                <span class="admin-stat-label">PENDING</span>
                <span class="admin-stat-value"><c:out value="${pendingCount}" /></span>
                <span class="admin-stat-subtext">Need attention</span>
            </div>
            <div class="admin-stat-card card-border-blue">
                <span class="admin-stat-label">IN PROGRESS</span>
                <span class="admin-stat-value"><c:out value="${inProgressCount}" /></span>
                <span class="admin-stat-subtext">Being addressed</span>
            </div>
            <div class="admin-stat-card card-border-green">
                <span class="admin-stat-label">RESOLVED</span>
                <span class="admin-stat-value"><c:out value="${resolvedCount}" /></span>
                <span class="admin-stat-subtext">
                    <c:choose>
                        <c:when test="${totalComplaints > 0}">
                            <fmt:formatNumber value="${(resolvedCount * 100.0) / totalComplaints}" maxFractionDigits="1" />% resolution rate
                        </c:when>
                        <c:otherwise>
                            0% resolution rate
                        </c:otherwise>
                    </c:choose>
                </span>
            </div>
        </section>

        <!-- Stats Row 2: 3 cards wide -->
        <section class="admin-stats-grid-secondary">
            <div class="admin-stat-card">
                <span class="admin-stat-label">TOTAL CITIZENS</span>
                <span class="admin-stat-value"><c:out value="${totalCitizens}" /></span>
                <span class="admin-stat-subtext">Registered users</span>
            </div>
            <div class="admin-stat-card">
                <span class="admin-stat-label">TOTAL VOTES</span>
                <span class="admin-stat-value"><fmt:formatNumber value="${totalVotes}" /></span>
                <span class="admin-stat-subtext">Community supports</span>
            </div>
            <div class="admin-stat-card card-border-red">
                <span class="admin-stat-label">NEW THIS WEEK</span>
                <span class="admin-stat-value">18</span>
                <span class="admin-stat-subtext">Complaints received</span>
            </div>
        </section>

        <section style="display: grid; gap: 2rem;">
            <!-- Latest Complaints Card -->
            <div class="content-card">
                <div class="card-header">
                    <h3>Latest Complaints</h3>
                    <a href="<%= request.getContextPath() %>/admin/manage-complaints" class="btn-view-outline">View All</a>
                </div>
                <div class="table-responsive">
                    <c:choose>
                        <c:when test="${empty latestComplaints}">
                            <div style="text-align: center; padding: 3rem; color: #64748b;">
                                No complaints have been submitted yet.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>TITLE</th>
                                        <th>SUBMITTED BY</th>
                                        <th>CATEGORY</th>
                                        <th>WARD</th>
                                        <th>STATUS</th>
                                        <th>VOTES</th>
                                        <th>DATE</th>
                                        <th>ACTIONS</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="complaint" items="${latestComplaints}">
                                        <tr>
                                            <td>
                                                <a href="<%= request.getContextPath() %>/admin/complaint-detail?id=${complaint.id}" class="admin-table-title-link">
                                                    <c:out value="${complaint.title}" />
                                                </a>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${complaint.anonymous}">
                                                        Anonymous
                                                    </c:when>
                                                    <c:otherwise>
                                                        <c:out value="${complaint.userName}" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <span class="admin-cat-badge cat-${fn:toLowerCase(complaint.categoryName)}">
                                                    <c:out value="${complaint.categoryName}" />
                                                </span>
                                            </td>
                                            <td><c:out value="${complaint.wardNumber}" /></td>
                                            <td>
                                                <span class="admin-status-badge admin-status-${fn:toLowerCase(complaint.status)}">
                                                    <c:choose>
                                                        <c:when test="${complaint.status == 'pending'}">PENDING</c:when>
                                                        <c:when test="${complaint.status == 'in_progress'}">IN PROGRESS</c:when>
                                                        <c:when test="${complaint.status == 'resolved'}">RESOLVED</c:when>
                                                        <c:otherwise><c:out value="${fn:toUpperCase(complaint.status)}" /></c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td><c:out value="${complaint.voteCount}" /></td>
                                            <td><c:out value="${complaint.formattedCreatedAt}" /></td>
                                            <td>
                                                <div style="display: flex; gap: 8px; align-items: center;">
                                                    <a href="<%= request.getContextPath() %>/admin/complaint-detail?id=${complaint.id}" class="btn-view-outline">View</a>
                                                    
                                                    <c:choose>
                                                        <c:when test="${complaint.status == 'pending'}">
                                                            <form action="<%= request.getContextPath() %>/admin/complaint-detail" method="POST" style="margin:0;">
                                                                <input type="hidden" name="action" value="updateStatus">
                                                                <input type="hidden" name="id" value="${complaint.id}">
                                                                <input type="hidden" name="status" value="in_progress">
                                                                <button type="submit" class="btn-action-transition">→ Progress</button>
                                                            </form>
                                                        </c:when>
                                                        <c:when test="${complaint.status == 'in_progress'}">
                                                            <form action="<%= request.getContextPath() %>/admin/complaint-detail" method="POST" style="margin:0;">
                                                                <input type="hidden" name="action" value="updateStatus">
                                                                <input type="hidden" name="id" value="${complaint.id}">
                                                                <input type="hidden" name="status" value="resolved">
                                                                <button type="submit" class="btn-action-resolve">✓ Resolve</button>
                                                            </form>
                                                        </c:when>
                                                    </c:choose>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Top 5 Most Supported Issues Card -->
            <div class="content-card">
                <div class="card-header">
                    <h3>Top 5 Most Supported Issues</h3>
                </div>
                <div class="table-responsive">
                    <c:choose>
                        <c:when test="${empty topSupported}">
                            <div style="text-align: center; padding: 3rem; color: #64748b;">
                                No supported complaints yet.
                            </div>
                        </c:when>
                        <c:otherwise>
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>#</th>
                                        <th>TITLE</th>
                                        <th>CATEGORY</th>
                                        <th>STATUS</th>
                                        <th style="text-align: right;">VOTES</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="complaint" items="${topSupported}" varStatus="loop">
                                        <tr>
                                            <td style="color: #94a3b8; font-weight: 500;">
                                                <fmt:formatNumber value="${loop.index + 1}" minIntegerDigits="2" />
                                            </td>
                                            <td>
                                                <a href="<%= request.getContextPath() %>/admin/complaint-detail?id=${complaint.id}" class="admin-table-title-link">
                                                    <c:out value="${complaint.title}" />
                                                </a>
                                            </td>
                                            <td>
                                                <span class="admin-cat-badge cat-${fn:toLowerCase(complaint.categoryName)}">
                                                    <c:out value="${complaint.categoryName}" />
                                                </span>
                                            </td>
                                            <td>
                                                <span class="admin-status-badge admin-status-${fn:toLowerCase(complaint.status)}">
                                                    <c:choose>
                                                        <c:when test="${complaint.status == 'pending'}">PENDING</c:when>
                                                        <c:when test="${complaint.status == 'in_progress'}">IN PROGRESS</c:when>
                                                        <c:when test="${complaint.status == 'resolved'}">RESOLVED</c:when>
                                                        <c:otherwise><c:out value="${fn:toUpperCase(complaint.status)}" /></c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td style="text-align: right; font-weight: 700; color: #2563eb;">
                                                <c:out value="${complaint.voteCount}" />
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </section>
    </main>

    <footer class="dashboard-footer" style="margin-left: 240px; background-color: #1e3a8a; color: rgba(255, 255, 255, 0.6); border-top: 1px solid rgba(255, 255, 255, 0.1); padding: 2rem 2.5rem;">
        <div class="footer-content">
            <p>&copy; 2026 CivicConnect. All rights reserved.</p>
            <div class="footer-links">
                <span>Version 1.0.0</span>
                <span class="separator">|</span>
                <span>System Status: <span class="status-online">Online</span></span>
            </div>
        </div>
    </footer>
</body>
</html>
