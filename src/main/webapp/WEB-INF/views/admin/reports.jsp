<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Reports - CivicConnect</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/stylesheet.css">
    <style>
        .report-section { margin-bottom: 3rem; background: #fff; padding: 2rem; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .report-section h3 { margin-top: 0; color: #333; border-bottom: 2px solid #0056b3; padding-bottom: 0.5rem; margin-bottom: 1rem; }
        .grid-2-col { display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; }
        @media (max-width: 768px) { .grid-2-col { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <jsp:include page="navbar.jsp" />

    <main class="container">
        <h2>Analytics & Reports - <c:out value="${sessionScope.municipalityName}" /></h2>
        
        <p>This page provides a statistical overview of the civic issues reported in your municipality.</p>

        <div class="grid-2-col">
            <section class="report-section">
                <h3>Complaints by Status</h3>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Status</th>
                            <th>Count</th>
                            <th>Percentage</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Pending</td>
                            <td><c:out value="${pendingCount}" /></td>
                            <td><fmt:formatNumber value="${pendingPct}" maxFractionDigits="1" />%</td>
                        </tr>
                        <tr>
                            <td>In Progress</td>
                            <td><c:out value="${inProgressCount}" /></td>
                            <td><fmt:formatNumber value="${inProgressPct}" maxFractionDigits="1" />%</td>
                        </tr>
                        <tr>
                            <td>Resolved</td>
                            <td><c:out value="${resolvedCount}" /></td>
                            <td><fmt:formatNumber value="${resolvedPct}" maxFractionDigits="1" />%</td>
                        </tr>
                        <tr style="font-weight: bold; background: #f8f9fa;">
                            <td>Total</td>
                            <td><c:out value="${totalComplaints}" /></td>
                            <td>100%</td>
                        </tr>
                    </tbody>
                </table>
            </section>

            <section class="report-section">
                <h3>Recent Activity (7 & 30 Days)</h3>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Metric</th>
                            <th>Last 7 Days</th>
                            <th>Last 30 Days</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>New Complaints Filed</td>
                            <td><c:out value="${newLast7Days}" /></td>
                            <td><c:out value="${newLast30Days}" /></td>
                        </tr>
                        <tr>
                            <td>Complaints Resolved</td>
                            <td><c:out value="${resolvedLast7Days}" /></td>
                            <td><c:out value="${resolvedLast30Days}" /></td>
                        </tr>
                    </tbody>
                </table>
            </section>
        </div>

        <div class="grid-2-col">
            <section class="report-section">
                <h3>Complaints by Category</h3>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Category Name</th>
                            <th>Number of Complaints</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="entry" items="${categoryCounts}">
                            <tr>
                                <td><c:out value="${entry.key}" /></td>
                                <td><c:out value="${entry.value}" /></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty categoryCounts}">
                            <tr><td colspan="2">No data available.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </section>

            <section class="report-section">
                <h3>Most Reported Wards</h3>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>Ward Number</th>
                            <th>Total Complaints</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="entry" items="${wardCounts}">
                            <tr>
                                <td>Ward <c:out value="${entry.key}" /></td>
                                <td><c:out value="${entry.value}" /></td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty wardCounts}">
                            <tr><td colspan="2">No data available.</td></tr>
                        </c:if>
                    </tbody>
                </table>
            </section>
        </div>

        <section class="report-section">
            <h3>Top 10 Most Supported Issues</h3>
            <table class="data-table">
                <thead>
                    <tr>
                        <th>Rank</th>
                        <th>Title</th>
                        <th>Category</th>
                        <th>Status</th>
                        <th>Votes</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="complaint" items="${topSupported}" varStatus="status">
                        <tr>
                            <td>#<c:out value="${status.index + 1}" /></td>
                            <td><a href="${pageContext.request.contextPath}/admin/complaint-detail?id=${complaint.id}"><c:out value="${complaint.title}" /></a></td>
                            <td><c:out value="${complaint.categoryName}" /></td>
                            <td><c:out value="${complaint.status}" /></td>
                            <td><strong><c:out value="${complaint.voteCount}" /></strong></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty topSupported}">
                        <tr><td colspan="5">No data available.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </section>

    </main>
</body>
</html>
